# finetune_mobilenetv2_mixup_v2.py
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import ReduceLROnPlateau, EarlyStopping, ModelCheckpoint
import numpy as np
import os
import json

# -------------------------
# 1. GPU setup
# -------------------------
physical_devices = tf.config.list_physical_devices('GPU')
if physical_devices:
    tf.config.experimental.set_memory_growth(physical_devices[0], True)
    print("GPU detected:", physical_devices[0])
else:
    print("No GPU detected, using CPU")

# -------------------------
# 2. Parameters
# -------------------------
IMG_HEIGHT, IMG_WIDTH = 256, 256
BATCH_SIZE = 32
EPOCHS = 15
TRAIN_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/train"
VAL_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/val"
TEST_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/test"
MODEL_PATH = "cattle_breed_mobilenetv2_finetuned_v6.keras"

# -------------------------
# 3. Load model
# -------------------------
model = load_model(MODEL_PATH)
print("Loaded model:", MODEL_PATH)

# -------------------------
# 4. Image generators
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
    rotation_range=30,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest'
)

val_datagen = ImageDataGenerator(rescale=1./255)
test_datagen = ImageDataGenerator(rescale=1./255)

train_gen = train_datagen.flow_from_directory(
    TRAIN_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=True
)

val_gen = val_datagen.flow_from_directory(
    VAL_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=False
)

test_gen = test_datagen.flow_from_directory(
    TEST_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=False
)

num_classes = train_gen.num_classes

# -------------------------
# 5. Mixup generator
# -------------------------
def mixup_generator(generator, alpha=0.2):
    while True:
        x, y = next(generator)
        lam = np.random.beta(alpha, alpha, x.shape[0])
        lam_x = lam.reshape(x.shape[0], 1, 1, 1)
        lam_y = lam.reshape(x.shape[0], 1)
        index = np.random.permutation(x.shape[0])
        mixed_x = lam_x * x + (1 - lam_x) * x[index]
        mixed_y = lam_y * y + (1 - lam_y) * y[index]
        yield mixed_x, mixed_y

train_mix_gen = mixup_generator(train_gen)

# -------------------------
# 6. Callbacks
# -------------------------
checkpoint = ModelCheckpoint(
    "cattle_breed_mobilenetv2_mixupv6_best.keras",
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
# 7. Compile model
# -------------------------
model.compile(
    optimizer=Adam(1e-4),
    loss=tf.keras.losses.CategoricalCrossentropy(label_smoothing=0.1),
    metrics=['accuracy']
)

# -------------------------
# 8. Train model
# -------------------------
history = model.fit(
    train_mix_gen,
    steps_per_epoch=len(train_gen),
    validation_data=val_gen,
    epochs=EPOCHS,
    callbacks=[checkpoint, early_stop, reduce_lr]
)

# -------------------------
# 9. Save final model
# -------------------------
final_model_path = "cattle_breed_mobilenetv2_mixupv6_final.keras"
model.save(final_model_path)
print(f"Final model saved as {final_model_path}")

# -------------------------
# 10. Evaluate
# -------------------------
val_loss, val_acc = model.evaluate(val_gen)
print(f"Validation Accuracy: {val_acc*100:.2f}%")
print(f"Validation Loss: {val_loss:.4f}")

test_loss, test_acc = model.evaluate(test_gen)
print(f"Test Accuracy: {test_acc*100:.2f}%")
print(f"Test Loss: {test_loss:.4f}")

# -------------------------
# 11. Save class indices
# -------------------------
with open("class_indices.json", "w") as f:
    json.dump(train_gen.class_indices, f)
print("Class indices saved.")
