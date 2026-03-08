# cattle_breed_recognition_from_images.py
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.preprocessing.image import ImageDataGenerator

# -------------------------
# 1. Parameters
# -------------------------
IMG_HEIGHT, IMG_WIDTH = 224, 224
BATCH_SIZE = 32
EPOCHS = 20
DATASET_PATH = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/train"  # Replace with your dataset folder path

# -------------------------
# 2. Prepare Image Generators
# -------------------------
datagen = ImageDataGenerator(
    rescale=1./255,
    validation_split=0.2  # 20% validation
)

train_generator = datagen.flow_from_directory(
    DATASET_PATH,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    subset='training',
    shuffle=True
)

val_generator = datagen.flow_from_directory(
    DATASET_PATH,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    subset='validation',
    shuffle=False
)

num_classes = train_generator.num_classes

# -------------------------
# 3. Load Pretrained MobileNetV2
# -------------------------
base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(IMG_HEIGHT, IMG_WIDTH, 3))
base_model.trainable = False  # Freeze base layers initially

# -------------------------
# 4. Build the Model
# -------------------------
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(256, activation='relu')(x)
x = Dropout(0.5)(x)
predictions = Dense(num_classes, activation='softmax')(x)

model = Model(inputs=base_model.input, outputs=predictions)
model.compile(optimizer=Adam(learning_rate=0.001),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

model.summary()

# -------------------------
# 5. Train the Model
# -------------------------
history = model.fit(
    train_generator,
    validation_data=val_generator,
    epochs=EPOCHS
)

# -------------------------
# 6. Optional Fine-Tuning
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
    epochs=10
)

# -------------------------
# 7. Save the Model
# -------------------------
model.save("cattle_breed_mobilenetv2.h5")
print("Model saved as 'cattle_breed_mobilenetv2.h5'")
