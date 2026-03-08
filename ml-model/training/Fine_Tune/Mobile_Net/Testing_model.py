# -------------------------
# quick_test_mobilenetv2.py
# -------------------------
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import numpy as np
import matplotlib.pyplot as plt
import json
import os

# -------------------------
# Paths
# -------------------------
MODEL_PATH = "cattle_breed_mobilenetv2_v5promax_finetuned.keras"
TEST_DIR = "/home/sanjaykumars/Desktop/Hacktrix/dataset_preprocessed/test"
CLASS_INDICES_PATH = "class_indices.json"
IMG_HEIGHT, IMG_WIDTH = 256, 256
BATCH_SIZE = 32

# -------------------------
# Load Model
# -------------------------
model = load_model(MODEL_PATH)
print("Loaded model:", MODEL_PATH)

# -------------------------
# Load Class Indices
# -------------------------
with open(CLASS_INDICES_PATH, "r") as f:
    class_indices = json.load(f)
# reverse mapping
idx_to_class = {v: k for k, v in class_indices.items()}

# -------------------------
# Prepare Test Generator
# -------------------------
test_datagen = ImageDataGenerator(rescale=1./255)
test_generator = test_datagen.flow_from_directory(
    TEST_DIR,
    target_size=(IMG_HEIGHT, IMG_WIDTH),
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=False
)

# -------------------------
# Evaluate Model
# -------------------------
test_loss, test_acc = model.evaluate(test_generator)
print(f"Test Accuracy: {test_acc*100:.2f}%")
print(f"Test Loss: {test_loss:.4f}")

# -------------------------
# Predict Some Test Images
# -------------------------
x_test, y_test = next(test_generator)  # get first batch
preds = model.predict(x_test)
pred_classes = np.argmax(preds, axis=1)

plt.figure(figsize=(12, 6))
for i in range(8):  # show first 8 images
    plt.subplot(2, 4, i+1)
    plt.imshow(x_test[i])
    plt.title(f"Pred: {idx_to_class[pred_classes[i]]}")
    plt.axis('off')
plt.tight_layout()
plt.show()
