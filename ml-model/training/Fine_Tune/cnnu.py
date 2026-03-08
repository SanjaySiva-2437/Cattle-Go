# optimized_cattle_breed_recognition_with_plots.py
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau
import matplotlib.pyplot as plt
import os
import json

# -------------------------
# 1. GPU + Mixed Precision
# -------------------------
physical_devices = tf.config.list_physical_devices('GPU')
if physical_devices:
    try:
        tf.config.experimental.set_memory_growth(physical_devices[0], True)
        print("GPU detected:", physical_devices[0])
    except:
        print("Could not set memory growth")
else:
    print("No GPU detected, using CPU")

from tensorflow.keras import mixed_precision
mixed_precision.set_global_policy('mixed_float16')

# -------------------------
# 2. Parameters
# -------------------------
IMG_HEIGHT, IMG_WIDTH = 256, 256
BATCH_SIZE = 48
INITIAL_EPOCHS = 25
FINETUNE_EPOCHS = 15
DATASET_PATH = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/train"  # Replace with your dataset folder path

# -------------------------
# 3. Image Generators with Augmentation
# -------------------------
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=25,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest',
    validation_split=0.2
)

train_generator = train_datagen.flow_from_directory(
    DATASET_PATH,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    subset='training',
    shuffle=True
)

val_generator = train_datagen.flow_from_directory(
    DATASET_PATH,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    subset='validation',
    shuffle=False
)

num_classes = train_generator.num_classes

# -------------------------
# 4. Load Pretrained MobileNetV2
# -------------------------
base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(IMG_HEIGHT, IMG_WIDTH, 3))
base_model.trainable = False

x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(256, activation='relu')(x)
x = Dropout(0.5)(x)
predictions = Dense(num_classes, activation='softmax', dtype='float32')(x)

model = Model(inputs=base_model.input, outputs=predictions)

# -------------------------
# 5. Callbacks
# -------------------------
early_stop = EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True)
reduce_lr = ReduceLROnPlateau(monitor='val_loss', factor=0.5, patience=3, min_lr=1e-6, verbose=1)

model.compile(optimizer=Adam(learning_rate=0.001),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

model.summary()

# -------------------------
# 6. Initial Training
# -------------------------
history = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=INITIAL_EPOCHS,
    callbacks=[early_stop, reduce_lr]
)

# -------------------------
# 7. Fine-Tuning
# -------------------------
base_model.trainable = True
for layer in base_model.layers[:100]:
    layer.trainable = False

model.compile(optimizer=Adam(learning_rate=1e-5),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

history_finetune = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=FINETUNE_EPOCHS,
    callbacks=[early_stop, reduce_lr]
)

# -------------------------
# 8. Save the Model
# -------------------------
model.save("cattle_breed_mobilenetv2_optimized.keras")
print("Model saved as 'cattle_breed_mobilenetv2_optimized.keras'")

# -------------------------
# 9. Save Class Indices
# -------------------------
with open("class_indices.json", "w") as f:
    json.dump(train_generator.class_indices, f)
print("Class indices saved as 'class_indices.json'")

# -------------------------
# 10. Plot Training History
# -------------------------
def plot_history(histories, titles):
    plt.figure(figsize=(14,5))
    
    # Plot Accuracy
    plt.subplot(1,2,1)
    for h, t in zip(histories, titles):
        plt.plot(h.history['accuracy'], label=f'Train {t}')
        plt.plot(h.history['val_accuracy'], label=f'Val {t}')
    plt.title('Model Accuracy')
    plt.xlabel('Epoch')
    plt.ylabel('Accuracy')
    plt.legend()
    
    # Plot Loss
    plt.subplot(1,2,2)
    for h, t in zip(histories, titles):
        plt.plot(h.history['loss'], label=f'Train {t}')
        plt.plot(h.history['val_loss'], label=f'Val {t}')
    plt.title('Model Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.legend()
    
    plt.tight_layout()
    plt.show()

# Call plotting function
plot_history([history, history_finetune], ['Initial', 'Fine-tune'])
