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
https://youtu.be/ev7s093bk_A


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

