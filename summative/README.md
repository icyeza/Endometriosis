# Endometriosis Prediction App 🎗️

## Mission: Empowering Women's Health Through Technology

This application is dedicated to advancing women's health by providing accessible, data-driven insights into endometriosis risk assessment. Endometriosis affects approximately 1 in 10 women of reproductive age worldwide, yet it often takes 7-10 years for a proper diagnosis. By leveraging machine learning and creating an intuitive mobile interface, we aim to empower women to take proactive steps in understanding their health, facilitating earlier conversations with healthcare providers, and ultimately improving quality of life.

**Our commitment:** Making women's health data and predictive tools accessible, understandable, and actionable for every woman who needs them.

---
## publicly available API endpoint 
https://endometriosis-9799.onrender.com/
## Path to Swagger UI Documentation
https://endometriosis-9799.onrender.com/docs
## Youtube link
https://youtu.be/A2htOhOA240
## About the Project

This is a comprehensive full-stack application consisting of:

- **Flutter Mobile App** - Cross-platform (iOS, Android, Web) interface for risk prediction
- **FastAPI Backend** - RESTful API server with machine learning model integration
- **Machine Learning Model** - Linear Regression model trained on endometriosis patient data

### Key Features

✅ **Real-time Risk Prediction** - Instant endometriosis risk assessment based on patient inputs  
✅ **Prediction History** - Track and review past predictions  
✅ **API Configuration** - Flexible backend connection settings  
✅ **Responsive Design** - Beautiful, gradient-based UI optimized for all screen sizes  
✅ **Offline Capability** - Prediction history stored locally

---

## Data Source

### Dataset Information

- **Source:** Kaggle - [Endometriosis Diagnosis Dataset](https://www.kaggle.com/datasets/prasoonkottarathil/endometriosis-diagnosis-dataset)
- **Size:** 10,000 patient records
- **Features:** 6 clinical and demographic indicators
  - Age (years)
  - BMI (Body Mass Index)
  - Chronic Pain Level (0-10 scale)
  - Menstrual Irregularity (binary: Yes/No)
  - Hormone Level Abnormality (binary: Yes/No)
  - Infertility Status (binary: Yes/No)
- **Target:** Binary diagnosis (0 = No Endometriosis, 1 = Endometriosis)

### Model Performance

- **Algorithm:** Linear Regression with Gradient Descent (SGDRegressor)
- **Training Data:** 8,000 samples (80%)
- **Test Data:** 2,000 samples (20%)
- **R² Score:** 0.0692
- **Mean Squared Error:** 0.2214

The dataset provides a realistic foundation for building a predictive model, though the R² score indicates that endometriosis diagnosis is complex and requires multiple factors beyond these features for clinical accuracy.

---

## Project Structure

```
summative/
├── FlutterApp/               # Flutter mobile application
│   ├── lib/
│   │   ├── constants/       # App colors, styles, and constants
│   │   ├── models/          # Data models (PredictionRequest, PredictionResponse)
│   │   ├── screens/         # UI screens (Home, History, Settings)
│   │   ├── services/        # API service layer
│   │   └── widgets/         # Reusable UI components
│   ├── pubspec.yaml         # Flutter dependencies
│   └── analysis_options.yaml
│
├── API/                     # FastAPI backend server
│   ├── main.py             # FastAPI application with endpoints
│   ├── prediction.py       # Model loading and prediction logic
│   ├── requirements.txt    # Python dependencies
│   ├── models/             # Trained ML model artifacts
│   │   ├── best_model.pkl
│   │   ├── scaler.pkl
│   │   ├── features.pkl
│   │   └── label_encoders.pkl
│   └── test_predict.py     # API testing script
│
├── multivariate.ipynb      # Jupyter notebook for model training
└── linear_regression/      # Original regression experiments
```

---

## Installation & Setup

### Prerequisites

- **Flutter SDK** (3.0+)
- **Python** (3.8+)
- **pip** (Python package manager)

### Backend Setup (FastAPI)

1. Navigate to the API directory:

```bash
cd summative/API
```

2. Install Python dependencies:

```bash
pip install -r requirements.txt
```

3. Start the API server:

```bash
python -m uvicorn main:app --host 0.0.0.0 --port 8000
```

The API will be available at: `http://localhost:8000`

**API Endpoints:**

- `GET /` - Root endpoint
- `GET /health` - Health check
- `POST /predict` - Make a prediction
- `GET /model-info` - Get model information

### Frontend Setup (Flutter)

1. Navigate to the Flutter app directory:

```bash
cd summative/FlutterApp
```

2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
# For web (Edge browser)
flutter run -d edge --web-port 61045

# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

---

