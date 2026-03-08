# finetune_cattle_resnet50_v1.py
import tensorflow as tf
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.models import Model, load_model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau, ModelCheckpoint
from tensorflow.keras.losses import CategoricalCrossentropy
from sklearn.utils import class_weight
import numpy as np
import matplotlib.pyplot as plt
import json
import os

# -------------------------
# 1. GPU + Mixed Precision
# -------------------------
physical_devices = tf.config.list_physical_devices('GPU')
if physical_devices:
    tf.config.experimental.set_memory_growth(physical_devices[0], True)
    print("GPU detected:", physical_devices[0])
else:
    print("No GPU detected, using CPU")

from tensorflow.keras import mixed_precision
mixed_precision.set_global_policy('mixed_float16')

# -------------------------
# 2. Parameters
# -------------------------
IMG_HEIGHT, IMG_WIDTH = 256, 256
BATCH_SIZE = 32  # ResNet50 is heavier, reduce batch size
EPOCHS_HEAD = 10  # train top layers first
EPOCHS_FINE = 20  # fine-tune last layers
TRAIN_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/train"
VAL_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/val"
TEST_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/test"
MODEL_SAVE_PATH = "cattle_breed_resnet50_finetuned_v1.keras"

# -------------------------
# 3. Image Generators
# -------------------------
def preprocess(image):
    image = tf.image.random_contrast(image, 0.8, 1.2)
    image = tf.image.random_saturation(image, 0.8, 1.2)
    image = tf.image.random_hue(image, 0.05)
    image = tf.image.random_brightness(image, 0.1)
    return image

train_datagen = ImageDataGenerator(
    preprocessing_function=preprocess,
    rescale=1./255,
    rotation_range=40,
    width_shift_range=0.25,
    height_shift_range=0.25,
    shear_range=0.25,
    zoom_range=0.35,
    horizontal_flip=True,
    fill_mode='nearest'
)

val_datagen = ImageDataGenerator(rescale=1./255)
test_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    TRAIN_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=True
)

val_generator = val_datagen.flow_from_directory(
    VAL_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=False
)

test_generator = test_datagen.flow_from_directory(
    TEST_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=False
)

num_classes = train_generator.num_classes

# -------------------------
# 4. Class Weighting
# -------------------------
classes = train_generator.classes
weights = class_weight.compute_class_weight('balanced', classes=np.unique(classes), y=classes)
class_weights = dict(enumerate(weights))
print("Class weights:", class_weights)

# -------------------------
# 5. Load ResNet50 Base
# -------------------------
base_model = ResNet50(include_top=False, weights='imagenet', input_shape=(IMG_HEIGHT, IMG_WIDTH, 3))
base_model.trainable = False  # freeze base for head training

# -------------------------
# 6. Add Custom Head
# -------------------------
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(1024, activation='relu')(x)
x = Dropout(0.4)(x)
output = Dense(num_classes, activation='softmax', dtype='float32')(x)

model = Model(inputs=base_model.input, outputs=output)

# -------------------------
# 7. Compile for Head Training
# -------------------------
loss_fn = CategoricalCrossentropy(label_smoothing=0.1)
model.compile(
    optimizer=Adam(learning_rate=1e-3),
    loss=loss_fn,
    metrics=['accuracy']
)

# -------------------------
# 8. Callbacks
# -------------------------
checkpoint = ModelCheckpoint(
    MODEL_SAVE_PATH,
    monitor='val_accuracy',
    save_best_only=True,
    verbose=1
)

early_stop = EarlyStopping(
    monitor='val_loss',
    patience=6,
    restore_best_weights=True
)

reduce_lr = ReduceLROnPlateau(
    monitor='val_loss',
    factor=0.5,
    patience=3,
    min_lr=1e-6,
    verbose=1
)

# -------------------------
# 9. Train Head
# -------------------------
history_head = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=EPOCHS_HEAD,
    class_weight=class_weights,
    callbacks=[checkpoint, early_stop, reduce_lr]
)

# -------------------------
# 10. Fine-Tune Last Layers
# -------------------------
for layer in base_model.layers[-50:]:
    if hasattr(layer, 'trainable'):
        layer.trainable = True

model.compile(
    optimizer=Adam(learning_rate=1e-4),
    loss=loss_fn,
    metrics=['accuracy']
)

history_fine = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=EPOCHS_FINE,
    class_weight=class_weights,
    callbacks=[checkpoint, early_stop, reduce_lr]
)

# -------------------------
# 11. Evaluate Test Set
# -------------------------
test_loss, test_acc = model.evaluate(test_generator)
print(f"Test Accuracy: {test_acc*100:.2f}%")
print(f"Test Loss: {test_loss:.4f}")

# -------------------------
# 12. Save Class Indices
# -------------------------
with open("class_indices.json", "w") as f:
    json.dump(train_generator.class_indices, f)
print("Class indices saved as 'class_indices.json'")

# -------------------------
# 13. Plot Accuracy & Loss
# -------------------------
plt.figure(figsize=(14,5))

plt.subplot(1,2,1)
plt.plot(history_head.history['accuracy'] + history_fine.history['accuracy'], label='Train Accuracy')
plt.plot(history_head.history['val_accuracy'] + history_fine.history['val_accuracy'], label='Validation Accuracy')
plt.title('Model Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend()

plt.subplot(1,2,2)
plt.plot(history_head.history['loss'] + history_fine.history['loss'], label='Train Loss')
plt.plot(history_head.history['val_loss'] + history_fine.history['val_loss'], label='Validation Loss')
plt.title('Model Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()

plt.tight_layout()
plt.show()
