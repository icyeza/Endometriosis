# Endometriosis Prediction App 🎗️

## Mission: Empowering Women's Health Through Technology

This application is dedicated to advancing women's health by providing accessible, data-driven insights into endometriosis risk assessment. Endometriosis affects approximately 1 in 10 women of reproductive age worldwide, yet it often takes 7-10 years for a proper diagnosis. By leveraging machine learning and creating an intuitive mobile interface, we aim to empower women to take proactive steps in understanding their health, facilitating earlier conversations with healthcare providers, and ultimately improving quality of life.

**Our commitment:** Making women's health data and predictive tools accessible, understandable, and actionable for every woman who needs them.

---

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

## Usage Guide

### Making a Prediction

1. **Launch the App** - Open the application on your device/browser
2. **Fill in Patient Data:**
   - Age (numeric)
   - BMI (numeric, e.g., 24.5)
   - Chronic Pain Level (0-10 scale)
   - Menstrual Irregularity (Yes/No toggle)
   - Hormone Abnormality (Yes/No toggle)
   - Infertility Status (Yes/No toggle)
3. **Click "Predict Risk"** - Submit the form
4. **View Results:**
   - Risk Level: Low, Medium, or High
   - Percentage: Probability of endometriosis
   - Risk Description: Actionable recommendations

### Viewing History

1. Navigate to the **History** tab (bottom navigation)
2. View all past predictions in reverse chronological order
3. Each entry shows:
   - Date and time of prediction
   - Risk level with color coding
   - All input parameters
   - Option to delete individual entries
4. Clear all history using the trash icon in the app bar

### Settings Configuration

1. Navigate to the **Settings** tab
2. **API Configuration:**
   - View/edit API base URL
   - Reset to default (`http://localhost:8000`)
   - Save custom API endpoints
3. **Connection Testing:**
   - Click "Check Connection" to verify API status
   - View color-coded status indicator
4. **About Section:**
   - View app version and information

---

## Technical Details

### Flutter Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0 # HTTP client
  shared_preferences: ^2.2.2 # Local storage
```

### Python Dependencies

```
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.0
scikit-learn==1.7.2
numpy==1.26.2
pandas==2.1.3
joblib==1.3.2
```

### API Request/Response Format

**Request (POST /predict):**

```json
{
  "age": 30,
  "menstrual_irregularity": 1,
  "chronic_pain_level": 7.5,
  "hormone_level_abnormality": 1,
  "infertility": 0,
  "bmi": 24.5
}
```

**Response:**

```json
{
  "prediction": 0.5454,
  "confidence": "Medium",
  "input_data": {
    "age": 30,
    "menstrual_irregularity": 1,
    "chronic_pain_level": 7.5,
    "hormone_level_abnormality": 1,
    "infertility": 0,
    "bmi": 24.5
  }
}
```

---

## Troubleshooting

### Common Issues

**1. FormatException when making predictions**

- **Cause:** Empty text fields for binary values
- **Solution:** Binary fields now default to '0' (No) automatically

**2. API Connection Failed**

- **Cause:** Backend server not running or wrong URL
- **Solution:**
  - Verify API is running: `python -m uvicorn main:app --host 0.0.0.0 --port 8000`
  - Check Settings tab and verify URL is correct
  - Click "Check Connection" to test

**3. History Not Saving**

- **Cause:** SharedPreferences not initialized or parsing error
- **Solution:** Check console logs for detailed error messages
- Latest fixes include enhanced error handling and timestamp parsing

**4. Model Loading Error**

- **Cause:** Missing model files or version mismatch
- **Solution:**
  - Ensure all `.pkl` files exist in `API/models/`
  - Check scikit-learn version matches training version (1.7.2)

---

## Development Notes

### Recent Bug Fixes

- ✅ Fixed FormatException by adding default values to binary toggle fields
- ✅ Enhanced JSON parsing with timestamp support
- ✅ Added comprehensive debugging logs throughout prediction flow
- ✅ Implemented history persistence with SharedPreferences
- ✅ Added fallback parsing for numeric fields

### Debug Logging

The app includes extensive console logging for debugging:

- Request/response data in API service
- JSON parsing details in model layer
- History save/load operations
- Error stack traces with context

---

## Future Enhancements

🔮 **Planned Features:**

- Export prediction history to PDF/CSV
- Data visualization (charts and trends)
- Multi-language support
- Push notifications for health reminders
- Integration with wearable health devices
- Enhanced ML model with additional features
- User authentication and cloud sync

---

## Contributing

This project was developed as part of a women's health initiative. Contributions that further the mission of accessible, accurate, and empowering health technology are welcome.

---

## Disclaimer

⚠️ **Important:** This application is intended for educational and informational purposes only. It should NOT be used as a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.

The machine learning model has limitations (R² = 0.0692) and should be considered a preliminary risk assessment tool, not a diagnostic instrument.

---

## License

This project is developed for educational purposes as part of a university summative assessment.

---

## Acknowledgments

- **Dataset:** Kaggle contributor Prasoon Kottarathil
- **Framework:** Flutter & FastAPI communities
- **Mission:** Dedicated to all women affected by endometriosis and those advocating for better women's health outcomes

---

## Contact & Support

For questions, issues, or contributions related to this project, please refer to the project repository or contact the development team.

**Empowering women through accessible health technology. 🎗️💜**
