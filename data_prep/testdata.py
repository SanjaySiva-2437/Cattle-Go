import os
from PIL import Image
import numpy as np
dataset_path = r"C:\Users\sanja_szc7g1i\OneDrive\Desktop\Datasets\Indian_bovine_breeds\Indian_bovine_breeds\dataset_preprocessed"
output_path = r"C:\Users\sanja_szc7g1i\OneDrive\Desktop\Datasets\Indian_bovine_breeds\Indian_bovine_breeds"
target_size = (224, 224)  # Resize to 224x224
for split in ["train", "val", "test"]:
    split_input_path = os.path.join(dataset_path, split)
    split_output_path = os.path.join(output_path, split)
    if not os.path.exists(split_input_path):
        print(f"Skipping {split}, folder not found.")
        continue
    for breed in os.listdir(split_input_path):
        breed_input_path = os.path.join(split_input_path, breed)
        breed_output_path = os.path.join(split_output_path, breed)
        os.makedirs(breed_output_path, exist_ok=True)
        for img_file in os.listdir(breed_input_path):
            img_input_path = os.path.join(breed_input_path, img_file)
            img_output_path = os.path.join(breed_output_path, img_file)
            try:
                img = Image.open(img_input_path).convert("RGB")
                img = img.resize(target_size)
                img_array = np.array(img) / 255.0
                img_normalized = Image.fromarray((img_array * 255).astype(np.uint8))
                img_normalized.save(img_output_path)
            except Exception as e:
                print(f"Error processing {img_input_path}: {e}")
print("All images resized and normalized successfully!")