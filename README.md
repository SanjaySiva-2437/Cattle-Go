# 🐄 CattleGo — Intelligent Livestock Breed Identification System

## 📌 Overview

CattleGo is a smart livestock management app that helps farmers and researchers identify Indian cattle breeds using AI-based image recognition. It combines machine learning, real-time detection, multilingual support, and a RAG-based chatbot to make livestock management more accessible and efficient.

## 🚀 Features

### 🧠 Breed Detection (AI Model)
- Custom MobileNetV2 model trained for Indian cattle breed classification
- Supports both real-time detection and photo upload
- Achieves **53% accuracy** on validation dataset

### 📱 Frontend
- Built with Flutter for cross-platform use
- Firebase Authentication for secure user login
- Clean UI with options for live camera, image upload, and breed prediction results

### 🌐 Backend
- Model served through FastAPI
- Hosted locally and made public using ngrok for API access
- Handles image uploads and returns predicted breed with confidence score

### 💬 RAG-based Chatbot
- Hosted on a separate server
- Provides breed-related answers and general livestock guidance
- Context-aware and supports user queries dynamically

### 🈳 Multilingual Support
- App available in English, Tamil, and Hindi for wider accessibility

## 🧩 Tech Stack

| Layer | Technologies Used |
|-------|------------------|
| Frontend | Flutter |
| Backend | FastAPI, Python |
| Machine Learning | TensorFlow / Keras (MobileNetV2) |
| Authentication | Firebase |
| Deployment | ngrok (for FastAPI), separate server for chatbot |
| Database | Firebase Firestore (optional for storing user data) |

## ⚙️ Architecture Workflow

1. **User Login** → Firebase Authentication
2. **Choose Detection Mode** → Upload photo or live camera feed
3. **Image Sent to FastAPI Server** → ngrok exposes localhost API
4. **Model (MobileNetV2)** → Predicts cattle breed and returns response
5. **Result Displayed in App** → Breed name + confidence level
6. **Chatbot Interaction** → Users can ask breed-related queries
7. **Multilingual UI** → English, Tamil, Hindi toggle

## 🧠 Machine Learning Model Details

- **Architecture**: MobileNetV2
- **Training Dataset**: Indian cattle breed images
- **Input Size**: 256×256×3
- **Accuracy**: ~53% (Baseline)
- **Framework**: TensorFlow / Keras
- **Optimization Options**: FP16 / INT8 quantization for deployment

## 📈 Training Evolution

### Stage 1: Initial Fine-tuning (After Finetune1 → Before Finetune2)
![Stage 1 Results](DL/Fine_Tune/Mobile_Net/After_finetune1_and_before_finetune2.png)
**Analysis**: Model begins learning but struggles with generalization, showing clear overfitting patterns.

### Stage 2: Intermediate Fine-tuning (After Finetune2 → Before Finetune3)
![Stage 2 Results](DL/Fine_Tune/Mobile_Net/After_finetune2_and_before_finetune3.png)
**Analysis**: Overfitting reduced; model generalizes better with stable loss and accuracy curves.

### Stage 3: Enhanced Fine-tuning (After Finetune3 → Before Finetune4)
![Stage 3 Results](DL/Fine_Tune/Mobile_Net/After_finetune3_and_before_finetune4.png)
**Analysis**: Excellent convergence with high accuracy and synchronized loss curves.

### Stage 4: Final Optimization (After Finetune4 → Before Finetune5)
![Stage 4 Results](DL/Fine_Tune/Mobile_Net/After_finetune4_and_before_finetune5.png)
**Analysis**: Model achieves its best performance; overfitting minimized and accuracy plateau achieved.

### 🧮 Confusion Matrix
![Confusion Matrix](DL/Graphs/our_model.png)
**Purpose**: Displays model performance across all breed classes, highlighting correctly and incorrectly predicted breeds.

## 🖼️ App Screenshots

Below are key screens of the CattleGo app demonstrating multilingual support, breed classification, chatbot, and user interface design.

### 🔐 Authentication
| Sign In | Sign Up |
|----------|----------|
| ![Sign In Page](DL/App%20screenshots/Sign_In_Page.jpg) | ![Sign Up Page](DL/App%20screenshots/Sign_Up_Page.jpg) |

### 🏠 Home & Settings
| Home Page | Settings Page | Profile |
|------------|----------------|----------|
| ![Home Page](DL/App%20screenshots/Home_Page.jpg) | ![Settings Page](DL/App%20screenshots/settings_page.jpg) | ![Profile Page](DL/App%20screenshots/Profile_page.jpg) |

### 🐄 Breed Classification
| Classification Page | Breeds List | Breeds Info |
|----------------------|-------------|--------------|
| ![Classify Page](DL/App%20screenshots/classify_page.jpg) | ![Breeds Page](DL/App%20screenshots/Breeds_page.jpg) | ![Breeds Page 2](DL/App%20screenshots/Breeds_page2.jpg) |

### 💬 RAG Chatbot & Info Pages
| Chatbot | How To Use | App Language |
|----------|-------------|--------------|
| ![Chatbot Page](DL/App%20screenshots/Rag_Chatbot_Page.jpg) | ![How To Page](DL/App%20screenshots/How_to_page.jpg) | ![Language Page](DL/App%20screenshots/App_Language_Page.jpg) |

### 🔒 Privacy Policy
![Privacy Policy Page](DL/App%20screenshots/Privacy_Policy_Page.jpg)

## 📲 Try the App

You can try the CattleGo app on your Android device using our **pre-release APK**:

[Download CattleGo APK](https://release-assets.githubusercontent.com/github-production-release-asset/1064854025/2df32d5a-f3f5-4dc8-973d-f776ae00db26?sp=r&sv=2018-11-09&sr=b&spr=https&se=2025-10-09T07%3A31%3A32Z&rscd=attachment%3B+filename%3DCattleGo-APK.Release.--.apk&rsct=application%2Fvnd.android.package-archive&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2025-10-09T06%3A31%3A22Z&ske=2025-10-09T07%3A31%3A32Z&sks=b&skv=2018-11-09&sig=oR2cvfDxr%2FVQ%2F%2F1kPpANIZfbTnB2dCrCWYFfpSTvMBM%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc1OTk5MzU4MiwibmJmIjoxNzU5OTkxNzgyLCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.6z8kI3xgPNOxKexzDrHdgLnHM2j514Pxn39ZrUagdJ8&response-content-disposition=attachment%3B%20filename%3DCattleGo-APK.Release.--.apk&response-content-type=application%2Fvnd.android.package-archive)

> ⚠️ Make sure to enable “Install from unknown sources” on your Android device to install the APK.

# GPU Resource

```text
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 580.65.06              Driver Version: 580.65.06      CUDA Version: 13.0     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 4070 ...    Off |   00000000:01:00.0  On |                  N/A |
|  0%   37C    P8              9W /  220W |   10369MiB /  12282MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A            1364      G   /usr/lib/xorg/Xorg                      150MiB |
|    0   N/A  N/A            1600      G   /usr/bin/gnome-shell                     20MiB |
|    0   N/A  N/A            4666      G   /usr/share/code/code                     44MiB |
|    0   N/A  N/A            5360      C   python                                10052MiB |
|    0   N/A  N/A            6189      G   rustdesk                                 31MiB |
+-----------------------------------------------------------------------------------------+
```
--

## 🔍 Future Enhancements

- Improve model accuracy (>80%) with more balanced datasets
- Add offline detection using TensorFlow Lite
- Integrate GPS-based livestock tracking
- Expand chatbot knowledge base for veterinary queries
- Support for more regional languages
- Real-time health monitoring features
- Breed recommendation system for different climates

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK
- Python 3.8+
- TensorFlow
- Firebase account
- ngrok account
- CUDA Toolkit 12.1 with cuDNN 8.9.2
- Ubuntu 22.04 Jammy Jellyfish

### Installation Steps
1. Clone the repository
2. Install Flutter dependencies: `flutter pub get`
3. Set up Python backend: `pip install -r requirements.txt`
4. Configure Firebase authentication
5. Start FastAPI server and expose via ngrok
6. Run the Flutter app: `flutter run`

## 📱 Usage

1. **Login**: Users authenticate via Firebase
2. **Detection Mode Selection**:
   - Live Camera: Real-time breed detection
   - Photo Upload: Detect from existing images
3. **Results**: View predicted breed with confidence score
4. **Chat Assistance**: Ask breed-related questions via chatbot
5. **Language Toggle**: Switch between English, Tamil, or Hindi

## 🤝 Contributing

We welcome contributions to improve CattleGo! Areas of interest:
- Model accuracy improvements
- Additional language support
- UI/UX enhancements
- Documentation updates
- Bug fixes and performance optimizations

---

*Note: This documentation reflects the model training progress up to Finetune4, with Finetune5 representing ongoing optimization efforts.*

*Disclaimer: Developed by Team VeriSimilar. All Rights Reserved 2025*
