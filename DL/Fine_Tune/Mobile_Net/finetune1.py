# finetune_cattle_breed_v2.py
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau, ModelCheckpoint
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
BATCH_SIZE = 48
EPOCHS = 20
TRAIN_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/train"
VAL_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/val"
TEST_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/test"
MODEL_PATH = "cattle_breed_mobilenetv2_optimized.keras"

# -------------------------
# 3. Load Model
# -------------------------
model = load_model(MODEL_PATH)
print("Loaded model:", MODEL_PATH)

# -------------------------
# 4. Fine-Tuning: Unfreeze last N layers
# -------------------------
N = 100  # Number of layers to unfreeze
for layer in model.layers[-N:]:
    if hasattr(layer, 'trainable'):
        layer.trainable = True

for layer in model.layers[:-N]:
    if hasattr(layer, 'trainable'):
        layer.trainable = False

print(f"Last {N} layers unfrozen for fine-tuning.")

# -------------------------
# 5. Image Generators
# -------------------------
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=25,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
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
# 6. Compile Model
# -------------------------
model.compile(
    optimizer=Adam(learning_rate=1e-4),
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

# -------------------------
# 7. Callbacks
# -------------------------
checkpoint = ModelCheckpoint(
    "cattle_breed_mobilenetv2_finetuned.keras",
    monitor='val_accuracy',
    save_best_only=True,
    verbose=1
)

early_stop = EarlyStopping(
    monitor='val_loss',
    patience=5,
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
# 8. Train Model
# -------------------------
history = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=EPOCHS,
    callbacks=[checkpoint, early_stop, reduce_lr]
)

# -------------------------
# 9. Save Class Indices
# -------------------------
with open("class_indices.json", "w") as f:
    json.dump(train_generator.class_indices, f)
print("Class indices saved as 'class_indices.json'")

# -------------------------
# 10. Evaluate on Test Set
# -------------------------
test_loss, test_acc = model.evaluate(test_generator)
print(f"Test Accuracy: {test_acc*100:.2f}%")
print(f"Test Loss: {test_loss:.4f}")

# -------------------------
# 11. Plot Accuracy & Loss
# -------------------------
plt.figure(figsize=(14,5))

# Accuracy
plt.subplot(1,2,1)
plt.plot(history.history['accuracy'], label='Train Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.title('Model Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend()

# Loss
plt.subplot(1,2,2)
plt.plot(history.history['loss'], label='Train Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.title('Model Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()

plt.tight_layout()
plt.show()
