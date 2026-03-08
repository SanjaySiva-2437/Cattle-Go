# finetune_existing_mobilenet.py
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.losses import CategoricalCrossentropy
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau, ModelCheckpoint
from sklearn.utils import class_weight
import numpy as np
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
BATCH_SIZE = 32
EPOCHS_FINE = 15
MODEL_PATH = "cattle_breed_mobilenetv2_finetunedv5.keras"
NEW_MODEL_PATH = "cattle_breed_mobilenetv2_finetuned_v5+.keras"
TRAIN_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/train"
VAL_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/val"
TEST_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/test"

# -------------------------
# 3. Image Generators (with strong augmentation)
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

# -------------------------
# 4. Load existing model
# -------------------------
model = load_model(MODEL_PATH)
print("Loaded model:", MODEL_PATH)

# -------------------------
# 5. Class weighting
# -------------------------
classes = train_generator.classes
weights = class_weight.compute_class_weight('balanced', classes=np.unique(classes), y=classes)
class_weights = dict(enumerate(weights))
print("Class weights:", class_weights)

# -------------------------
# 6. Compile for fine-tuning
# -------------------------
loss_fn = CategoricalCrossentropy(label_smoothing=0.1)
model.compile(
    optimizer=Adam(learning_rate=1e-4),  # small LR for fine-tuning
    loss=loss_fn,
    metrics=['accuracy']
)

# -------------------------
# 7. Callbacks
# -------------------------
checkpoint = ModelCheckpoint(
    NEW_MODEL_PATH,
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
# 8. Fine-tune
# -------------------------
history = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=EPOCHS_FINE,
    class_weight=class_weights,
    callbacks=[checkpoint, early_stop, reduce_lr]
)

# -------------------------
# 9. Evaluate on test set
# -------------------------
test_loss, test_acc = model.evaluate(test_generator)
print(f"Test Accuracy: {test_acc*100:.2f}%")
print(f"Test Loss: {test_loss:.4f}")

# -------------------------
# 10. Save class indices
# -------------------------
with open("class_indices.json", "w") as f:
    json.dump(train_generator.class_indices, f)
print("Class indices saved as 'class_indices.json'")
