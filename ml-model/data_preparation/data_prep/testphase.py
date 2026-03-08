import os
from PIL import Image
import numpy as np

dataset_path = r"C:\Users\sanja_szc7g1i\OneDrive\Desktop\Datasets\Indian_bovine_breeds\Indian_bovine_breeds\dataset\test\Alambadi"
output_path = r"C:\Users\sanja_szc7g1i\OneDrive\Desktop\Datasets\Indian_bovine_breeds\Indian_bovine_breeds\dataset_preprocessed\test\Alambadi"

os.makedirs(output_path, exist_ok=True)
target_size = (224, 224)

for img_file in os.listdir(dataset_path):
    img_input_path = os.path.join(dataset_path, img_file)
    img_output_path = os.path.join(output_path, img_file)
    
    try:
        # Load image and convert to RGB
        img = Image.open(img_input_path).convert("RGB")
        
        # Resize
        img = img.resize(target_size)
        
        # Normalize (0-1)
        img_array = np.array(img) / 255.0
        
        # Convert back to image and save
        img_normalized = Image.fromarray((img_array * 255).astype(np.uint8))
        img_normalized.save(img_output_path)
        
    except Exception as e:
        print(f"Error processing {img_input_path}: {e}")

print("Alambadi images resized and normalized successfully!")
