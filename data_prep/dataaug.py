from tensorflow.keras.preprocessing.image import ImageDataGenerator
train_datagen = ImageDataGenerator(
    rescale=1./255,         # Normalize pixel values to 0-1
    rotation_range=20,      # Rotate images ±20 degrees
    width_shift_range=0.1,  # Shift images horizontally ±10%
    height_shift_range=0.1, # Shift images vertically ±10%
    shear_range=0.1,        # Shear transformation
    zoom_range=0.1,         # Random zoom ±10%
    horizontal_flip=True,   # Randomly flip images horizontally
    brightness_range=[0.8,1.2],  # Random brightness adjustments
    fill_mode='nearest'     # Fill in new pixels after transformations
)
val_datagen = ImageDataGenerator(rescale=1./255)
batch_size = 32  
train_generator = train_datagen.flow_from_directory(
    r'C:\Users\sanja_szc7g1i\OneDrive\Desktop\Datasets\Indian_bovine_breeds\Indian_bovine_breeds\dataset_preprocessed\train',
    target_size=(224,224),
    batch_size=batch_size,
    class_mode='categorical'
)
val_generator = val_datagen.flow_from_directory(
    r'C:\Users\sanja_szc7g1i\OneDrive\Desktop\Datasets\Indian_bovine_breeds\Indian_bovine_breeds\dataset_preprocessed\val',
    target_size=(224,224),
    batch_size=batch_size,
    class_mode='categorical'
)