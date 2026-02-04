# ECG Signal Processing and Analysis

This project focuses on analyzing real-world Electrocardiogram (ECG) signals using fundamental biomedical signal processing techniques. The goal is to understand heart activity, detect key waveform features, analyze frequency components, and reduce noise for accurate interpretation.

---

## 📌 Objective
- Analyze ECG waveform data
- Detect heart rate using R-peak detection
- Study frequency characteristics using FFT
- Remove power-line and high-frequency noise
- Improve ECG signal quality for reliable analysis

---

## 🫀 Background
An Electrocardiogram (ECG) records the electrical activity of the heart over time.  
Key components of an ECG waveform include:
- **P wave** – atrial depolarization
- **QRS complex** – ventricular depolarization
- **T wave** – ventricular repolarization  

ECG analysis is widely used to diagnose heart conditions such as arrhythmias, tachycardia, and bradycardia.

---

## 📂 Dataset
- ECG signal data loaded from a CSV file
- Key parameters:
  - Elapsed Time
  - Voltage Amplitude
- Sampling frequency: **360 Hz**

---

## 🛠️ Methodology

### 1. Data Exploration
- Loaded ECG data from CSV
- Visualized time-domain waveform
- Identified amplitude and time parameters

### 2. ECG Signal Behavior Analysis
- Identified P, Q, R, S, and T wave points
- Detected R-peaks (highest amplitude)
- Calculated RR intervals
- Computed average heart rate

**Average Heart Rate:** ~73.9 BPM

---

### 3. Frequency Domain Analysis
- Applied **Fast Fourier Transform (FFT)**
- Observed that ECG signal energy is concentrated in low-frequency components
- Identified 50 Hz power-line interference peak

---

### 4. Noise Analysis
- Added artificial **50 Hz Power Line Interference (PLI)**
- Compared ECG signal with and without noise
- Observed waveform distortion due to noise

---

### 5. Noise Reduction and Filtering
- Applied filtering techniques:
  - Notch filter for 50 Hz PLI
  - Low-pass filtering for high-frequency noise
- Compared ECG signal before and after filtering
- Achieved significantly cleaner ECG waveform

---

### 6. Statistical Analysis
- Calculated mean and standard deviation of ECG amplitude:
  - Before noise addition
  - After noise addition
  - After filtering
- Demonstrated improvement in signal quality after filtering

---

## 📊 Key Results
- Accurate R-peak detection and heart rate estimation
- Effective identification of frequency components using FFT
- Successful removal of power-line interference
- Enhanced ECG signal clarity after filtering

---

## 🧠 Practical Applications
- Real-time ECG monitoring
- Arrhythmia detection
- Wearable ECG devices
- Early diagnosis of cardiovascular diseases

---

## 🚀 Technologies Used
- MATLAB / Python (signal processing scripts)
- FFT analysis
- Digital filtering techniques
- Biomedical signal processing concepts

---

## 📈 Future Scope
- Real-time ECG monitoring systems
- Machine learning–based arrhythmia classification
- Integration with wearable health devices
- Predictive analysis for cardiovascular diseases

---

## 📜 Conclusion
This project demonstrates how signal processing techniques can be applied to biomedical data to extract meaningful health information. Proper noise reduction and feature extraction are crucial for accurate ECG interpretation and reliable heart monitoring systems.

---
