# CattleGo — Cattle Breed Identification via Computer Vision

> Automated Indian cattle breed classification using transfer learning, built for mobile-scale inference.

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](https://python.org)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.x-orange)](https://tensorflow.org)
[![Model](https://img.shields.io/badge/Model-MobileNetV2-green)](https://arxiv.org/abs/1801.04381)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

---

## Overview

CattleGo is a deep learning pipeline for **fine-grained visual classification of Indian cattle breeds** from camera or uploaded images. The system is designed to run efficiently on mobile hardware, enabling farmers, livestock researchers, and agri-tech platforms to identify breeds instantly — without domain expertise.

The model tackles a genuinely hard computer vision problem: distinguishing between **40+ morphologically similar cattle breeds** under uncontrolled real-world conditions (variable lighting, pose, background clutter).

---

## Problem

Manual breed identification requires trained veterinary experts and is impractical at scale. Existing generic image classifiers fail on fine-grained livestock classification due to:

- High inter-class visual similarity across breeds
- Intra-class variation from lighting, angle, and posture
- Limited labeled datasets for Indian indigenous breeds
- Compute constraints for mobile/edge deployment

---

## Solution

A **4-stage progressive fine-tuning pipeline** built on MobileNetV2, designed to maximize generalization on a constrained dataset while remaining deployable on mobile devices.

---

## Model Architecture

| Component         | Detail                             |
|-------------------|------------------------------------|
| Base Model        | MobileNetV2 (ImageNet pretrained)  |
| Framework         | TensorFlow / Keras                 |
| Input Shape       | 256 × 256 × 3                      |
| Output            | Softmax — multi-class (40+ breeds) |
| Deployment Target | Mobile (iOS / Android)             |
| Quantization      | FP16 / INT8 supported              |

MobileNetV2 was chosen for its **inverted residual structure with linear bottlenecks**, which delivers strong accuracy-to-latency tradeoffs critical for on-device inference.

---

## Training Strategy

Training used **progressive layer unfreezing** across 4 fine-tuning stages — a principled approach to transfer learning that prevents catastrophic forgetting while allowing deep feature adaptation.

```
Stage 1 → Train classification head only       (base frozen)
Stage 2 → Unfreeze top MobileNetV2 blocks      (lower LR)
Stage 3 → Unfreeze deeper layers               (lower LR + augmentation)
Stage 4 → Full network fine-tune               (minimal LR, early stopping)
```

---

## Training Evolution

### Stages 1 & 2 — Head Training → Initial Unfreezing

<table>
  <tr>
    <td align="center" width="50%">
      <img src="images/training_images/stage1_training.png" width="100%"/>
      <br/>
      <sub><b>Stage 1:</b> Head-only training. Clear train/val gap — expected. Base features not yet adapted to cattle domain.</sub>
    </td>
    <td align="center" width="50%">
      <img src="images/training_images/stage2_training.png" width="100%"/>
      <br/>
      <sub><b>Stage 2:</b> Top blocks unfrozen. Overfitting reduces; val loss stabilizes. Generalization begins.</sub>
    </td>
  </tr>
</table>

---

### Stages 3 & 4 — Deep Fine-tuning → Final Optimization

<table>
  <tr>
    <td align="center" width="50%">
      <img src="images/training_images/stage3_training.png" width="100%"/>
      <br/>
      <sub><b>Stage 3:</b> Deeper layers unfrozen. Train accuracy ~90%; val climbing. Loss curves converging cleanly.</sub>
    </td>
    <td align="center" width="50%">
      <img src="images/training_images/stage4_training.png" width="100%"/>
      <br/>
      <sub><b>Stage 4:</b> Full network fine-tune. Model plateaus; overfitting minimized. Best checkpoint saved here.</sub>
    </td>
  </tr>
</table>

---

## Results

| Metric                       | Value              |
|------------------------------|--------------------|
| Baseline Validation Accuracy | ~53%               |
| Random Chance Baseline       | ~2.5%              |
| Number of Classes            | 40+ breeds         |
| Inference Target             | Mobile (real-time) |

**Context on accuracy:** Fine-grained classification across 40+ visually similar classes with a moderately sized dataset is a known hard problem. A random baseline sits at ~2.5%. The confusion matrix below reveals the model performs strongly on well-represented breeds, with most errors occurring between closely related regional variants — a sensible failure mode.

### Confusion Matrix

<p align="center">
  <img src="images/training_images/confusion_matrix.png" width="85%"/>
  <br/>
  <sub>Diagonal dominance indicates correct predictions. Off-diagonal clusters highlight visually similar breed pairs that warrant additional training data.</sub>
</p>

---

## Data Pipeline

### Preprocessing
- Resize to 256 × 256
- Per-channel pixel normalization
- Stratified train / validation split

### Augmentation
Augmentation was critical for improving robustness across natural variation in real-world cattle photography:
- Random rotation
- Horizontal flip
- Zoom transforms
- Brightness jitter

---

## Roadmap

- [ ] Dataset expansion via web scraping + data partnerships
- [ ] Experiment with EfficientNetV2 and Vision Transformers (ViT)
- [ ] Self-supervised pretraining on unlabeled cattle imagery
- [ ] TFLite conversion + on-device latency benchmark
- [ ] Confidence calibration and rejection threshold for low-confidence predictions
- [ ] REST API wrapper for backend integration

---

## Project Structure

```
ml-model/
├── assets/                        # Static assets (icons, sample images)
├── data_preparation/
│   └── data_prep/                 # Dataset preprocessing scripts
├── evaluation/
│   └── Graphs/                    # Confusion matrix and evaluation plots
├── images/                        # Training curve images for README
├── inference/                     # Inference pipeline + API integration
├── training/
│   └── Fine_Tune/                 # Stage-wise fine-tuning scripts
└── README.md
```

---

## Tech Stack

- **TensorFlow / Keras** — model training and export
- **MobileNetV2** — pretrained backbone
- **NumPy / Pandas** — data handling
- **Matplotlib / Seaborn** — visualization
- **TFLite** — mobile deployment target

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss the approach. See `CONTRIBUTING.md` for guidelines.

---

## License

[MIT](LICENSE)

---

*Built as part of the CattleGo platform — an agri-tech solution for livestock management in India.*
