from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np
import io

# -------------------------
# 1. Load model & class indices
# -------------------------
MODEL_PATH = "cattle_breed_mobilenetv2_v5promax_finetuned.keras"
model = load_model(MODEL_PATH)
print("Model loaded:", MODEL_PATH)

import json
with open("class_indices.json", "r") as f:
    class_indices = json.load(f)
# Reverse mapping: index -> class name
idx_to_class = {v: k for k, v in class_indices.items()}

# -------------------------
# 2. FastAPI app
# -------------------------
app = FastAPI(title="Cattle Breed Recognition API")

# -------------------------
# 3. Image preprocessing function
# -------------------------
IMG_HEIGHT, IMG_WIDTH = 256, 256

def preprocess_image(file_bytes):
    img = image.load_img(io.BytesIO(file_bytes), target_size=(IMG_HEIGHT, IMG_WIDTH))
    img_array = image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)  # shape (1, H, W, C)
    return img_array

# -------------------------
# 4. Prediction endpoint
# -------------------------
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        img_array = preprocess_image(contents)
        preds = model.predict(img_array)
        class_idx = np.argmax(preds, axis=1)[0]
        confidence = float(np.max(preds))
        return JSONResponse({
            "class": idx_to_class[class_idx],
            "confidence": confidence
        })
    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=400)

# -------------------------
# 5. Root endpoint
# -------------------------
@app.get("/")
async def root():
    return {"message": "Cattle Breed Recognition API is running!"}
