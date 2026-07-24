# Genetic Type-2 Fuzzy Logic System for Lung Nodule Detection

This repository contains an implementation of a **Genetic Interval Type-2 Fuzzy Logic System (IT2FLS)** designed for automated medical image analysis. The system addresses the inherent noise and uncertainty (e.g., gray-level ambiguity, texture variations) found in medical imaging to improve the classification performance of Computer-Aided Detection (CAD) pipelines.

The project replicates and evaluates the methodology introduced in the scientific paper:  
*R. Hosseini et al., "A Genetic type-2 fuzzy logic system for pattern recognition in computer aided detection systems," IEEE International Conference on Fuzzy Systems (2010)*.

## 🧠 System Architecture & Optimization
Standard Type-1 Fuzzy Systems use precise numbers for membership functions, which limits their capability to handle high levels of data uncertainty[cite: 1]. This project utilizes **Interval Type-2 Fuzzy Sets** combined with a **Genetic Algorithm (GA)**[cite: 1]:
- **Fuzzy Core:** Implements a full IT2FLS pipeline consisting of a Fuzzifier, Inference Engine (rules), Type-Reducer (Center of Mass method), and Defuzzifier[cite: 1].
- **GA Optimization:** A Genetic Algorithm is deployed to fine-tune the parameters of the Gaussian membership functions, significantly enhancing overall diagnostic accuracy[cite: 1].
- **Generation Methods:** Supports two approaches for membership function generation: one based on scaling an existing Type-1 system (T1FLS) and another trained directly from data[cite: 1].

## 📊 Experimental Results
The system was evaluated using **ROC Accuracy** and **Mean Absolute Error (MAE)** over 100 runs to ensure stability[cite: 1]:
- **Traditional T1FLS:** ~56% ROC Accuracy[cite: 1].
- **IT2FLS (T1-derived):** ~86% ROC Accuracy[cite: 1].
- **IT2FLS (Data-driven):** ~88% ROC Accuracy[cite: 1].

## 🛠️ Requirements & Dependencies
Make sure you have Python installed along with the following libraries:
```bash
pip install numpy scipy matplotlib
