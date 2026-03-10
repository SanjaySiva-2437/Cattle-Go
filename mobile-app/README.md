# 📱 CattleGo — Mobile App

> Cross-platform Flutter application for AI-powered Indian cattle breed identification, RAG-based livestock assistance, and multilingual farmer support.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-orange)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)
[![i18n](https://img.shields.io/badge/i18n-EN%20%7C%20TA%20%7C%20HI-green)](#multilingual-support)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

---

## Overview

The CattleGo mobile app is the primary user-facing interface of the CattleGo platform. It enables farmers and livestock professionals to identify Indian cattle breeds in real time using their phone camera, consult an AI chatbot for breed and health guidance, and access the full experience in their native language.

The app communicates with a FastAPI backend (serving the MobileNetV2 classification model) and a separately hosted RAG chatbot server, keeping the mobile client lightweight while offloading all inference to the backend.

---

## Features

### 🧠 AI Breed Classification
- Real-time detection via live camera feed
- Photo upload mode for offline-captured images
- Displays predicted breed name and confidence score
- Powered by a MobileNetV2 model served over FastAPI

### 💬 RAG Chatbot
- Natural language Q&A for breed info, milk yields, and livestock guidance
- Context-aware responses grounded in curated breed documentation
- Integrated directly into the app UI

### 🔐 Authentication
- Firebase Authentication — secure email/password login and registration

### 🌐 Multilingual Support
- Full UI available in **English**, **Tamil**, and **Hindi**
- Configured via `l10n.yaml` with ARB-based localization

### 📋 Breed Encyclopedia
- Browsable breed list with detailed info pages
- Sourced from the RAG knowledge base

---

## App Screens

### Authentication
| Sign In | Sign Up |
|---------|---------|
| ![Sign In](assets/screenshots/signin.png) | ![Sign Up](assets/screenshots/signup.png) |

### Home & Settings
| Home | Settings | Profile |
|------|----------|---------|
| ![Home](assets/screenshots/home.png) | ![Settings](assets/screenshots/settings.png) | ![Profile](assets/screenshots/profile.png) |

### Breed Classification
| Classify | Breeds List | Breed Info |
|----------|-------------|------------|
| ![Classify](assets/screenshots/classify.png) | ![Breeds](assets/screenshots/breeds.png) | ![Info](assets/screenshots/breed_info.png) |

### Chatbot & Utilities
| Chatbot | How To Use | Language |
|---------|------------|----------|
| ![Chatbot](assets/screenshots/chatbot.png) | ![How To](assets/screenshots/howto.png) | ![Language](assets/screenshots/language.png) |

---

## Architecture

```
Flutter App
    │
    ├── Firebase Auth          → User login / registration
    │
    ├── FastAPI Backend ──────→ MobileNetV2 breed classification
    │     (via ngrok)               Returns: breed name + confidence
    │
    └── RAG Chatbot Server ───→ LangChain + Chroma + Ollama
                                    Returns: grounded breed Q&A
```

---

## Project Structure

```
mobile-app/
├── flutter_app/
│   ├── assets/                # Images, icons, fonts
│   ├── lib/                   # Main Dart source
│   │   ├── data/              # API clients, repository layer
│   │   ├── localization/      # ARB files — EN, TA, HI strings
│   │   ├── models/            # Data models (breed, user, response)
│   │   ├── screens/           # UI screens (home, classify, chat, etc.)
│   │   ├── services/          # Firebase, API, and chatbot service logic
│   │   └── main.dart          # App entry point
│   ├── linux/                 # Linux platform target
│   ├── macos/                 # macOS platform target
│   ├── test/                  # Widget and unit tests
│   ├── web/                   # Web platform target
│   ├── windows/               # Windows platform target
│   └── pubspec.yaml           # Flutter dependencies
├── lib/                       # Shared Dart utilities
├── analysis_options.yaml      # Dart linter config
├── cattle_app.iml             # IntelliJ module file
├── firebase.json              # Firebase project config
├── firebase_options.dart      # Generated Firebase options
├── l10n.yaml                  # Localization config
├── pubspec.yaml               # Root package manifest
└── README.md
```

---

## Tech Stack

| Layer           | Technology                          |
|-----------------|-------------------------------------|
| UI Framework    | Flutter 3.x (Dart)                  |
| Authentication  | Firebase Auth                       |
| Database        | Firebase Firestore                  |
| ML Backend      | FastAPI + MobileNetV2 (via ngrok)   |
| RAG Chatbot     | LangChain + Chroma + Ollama         |
| Localization    | Flutter i18n (ARB — EN / TA / HI)  |
| Testing         | Flutter widget tests                |

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x+
- Firebase project with Auth and Firestore enabled
- FastAPI backend running and exposed via [ngrok](https://ngrok.com)
- RAG chatbot server running (see [`rag-chatbot/README.md`](../rag-chatbot/README.md))

### Installation

```bash
# 1. Navigate to the Flutter app
cd mobile-app/flutter_app

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase
# Replace firebase_options.dart with your project's generated config
# or run: flutterfire configure

# 4. Set your FastAPI endpoint
# Update the base URL in lib/services/api_service.dart

# 5. Run the app
flutter run
```

### Build APK

```bash
flutter build apk --release
```

---

## Localization

Translations are managed via ARB files in `lib/localization/`. To add a new language:

1. Create `app_<locale>.arb` in `lib/localization/`
2. Add the locale to `l10n.yaml`
3. Run `flutter gen-l10n`

Currently supported: **English (`en`)**, **Tamil (`ta`)**, **Hindi (`hi`)**

---

## Try the App

Download the latest Android APK:

> **[⬇ Download CattleGo APK](#)**

> ⚠️ Enable *"Install from unknown sources"* on your Android device before installing.

---

## Roadmap

- [ ] Offline breed detection via TensorFlow Lite (on-device)
- [ ] Push notifications for livestock health reminders
- [ ] GPS-based livestock tracking
- [ ] Expanded language support (Telugu, Kannada, Marathi)
- [ ] Breed recommendation engine based on climate and region
- [ ] Real-time health monitoring integration

---

## Related Modules

| Module | Description |
|--------|-------------|
| [`ml-model/`](../ml-model/README.md) | MobileNetV2 training pipeline and evaluation |
| [`rag-chatbot/`](../rag-chatbot/README.md) | RAG chatbot — LangChain + Chroma + Ollama |

---

## License

[MIT](LICENSE) — Built by Team VeriSimilar © 2025