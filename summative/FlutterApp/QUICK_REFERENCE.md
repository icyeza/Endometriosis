# Flutter App Quick Reference

## 🎯 Files You Created

### Core Application Files

- **`lib/main.dart`** - App entry point with navigation
- **`pubspec.yaml`** - Project dependencies and configuration

### Screens

- **`lib/screens/home_screen.dart`** - Prediction form with input validation
- **`lib/screens/history_screen.dart`** - Past predictions display
- **`lib/screens/settings_screen.dart`** - API configuration and testing

### Services & Models

- **`lib/services/api_service.dart`** - API communication
- **`lib/models/prediction_model.dart`** - Data models (Request/Response)
- **`lib/constants/colors.dart`** - Design system (colors, spacing)

### Documentation

- **`README.md`** - Complete user guide
- **`SETUP_GUIDE.md`** - Installation and development guide
- **`ARCHITECTURE.md`** - Detailed architecture documentation

---

## 🚀 Quick Start (2 minutes)

### 1. Install Dependencies

```bash
cd FlutterApp
flutter pub get
```

### 2. Update API URL (if needed)

- Open app → Settings tab
- Change URL from `http://localhost:8000` to your API endpoint
- Tap "Save"

### 3. Run the App

```bash
flutter run
```

### 4. Make a Prediction

- Go to "Predict" tab
- Fill in patient data
- Tap "Predict" button
- View results

---

## 📱 Screen Overview

### **Predict Screen** (Home Tab)

```
INPUT FORM:
├── Age (18-100)
├── BMI (10.0-60.0)
├── Chronic Pain (0.0-10.0)
├── Menstrual Irregularity (Yes/No)
├── Hormone Abnormality (Yes/No)
└── Infertility (Yes/No)

ACTIONS:
├── Clear Form
└── Predict Button

RESULT:
├── Risk Level (Low/Medium/High)
├── Risk Percentage
├── Confidence Level
└── Assessment Message
```

### **History Screen** (Middle Tab)

```
FEATURES:
├── View all past predictions
├── Show input data for each
├── Timestamp for each prediction
└── Delete individual entries
```

### **Settings Screen** (Right Tab)

```
API CONFIGURATION:
├── API URL input field
├── Save button
├── Reset to default button

CONNECTION:
├── Connection status indicator
└── Check connection button

ABOUT:
├── App version
├── API version
└── App description
```

---

## 🔄 API Endpoints Used

| Method | Endpoint      | Purpose           |
| ------ | ------------- | ----------------- |
| POST   | `/predict`    | Make a prediction |
| GET    | `/health`     | Check API status  |
| GET    | `/model-info` | Get model details |

---

## 📊 Input Validation

| Field       | Type    | Range     | Required |
| ----------- | ------- | --------- | -------- |
| Age         | Integer | 18-100    | Yes      |
| BMI         | Double  | 10.0-60.0 | Yes      |
| Pain        | Double  | 0.0-10.0  | Yes      |
| Menstrual   | Binary  | 0-1       | Yes      |
| Hormone     | Binary  | 0-1       | Yes      |
| Infertility | Binary  | 0-1       | Yes      |

---

## 🎨 Color Coding

```
Risk Levels:
🟢 Low Risk (< 33%)      → Green (#10B981)
🟡 Medium Risk (33-67%)  → Amber (#F59E0B)
🔴 High Risk (> 67%)     → Red (#EF4444)
```

---

## 🛠 Development Commands

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d <device_id>

# Build release APK
flutter build apk --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

## 🐛 Troubleshooting

| Issue                    | Solution                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------- |
| Cannot connect to API    | 1. Check API is running<br>2. Verify URL in Settings<br>3. Check network connectivity |
| Hot reload not working   | Press `r` in terminal for hot restart                                                 |
| Gradle build failed      | Run `flutter clean` then `flutter run`                                                |
| Input validation failing | Ensure values within allowed ranges                                                   |

---

## 📦 Key Dependencies

```yaml
flutter: # Core Flutter
dio: ^5.3.0 # HTTP client
shared_preferences: # Local storage
google_fonts: # Custom fonts
cupertino_icons: # iOS icons
```

---

## 🔐 Local Storage

- **API URL**: Saved in SharedPreferences
- **History**: Saved as JSON list in SharedPreferences
- **Location**: App-specific storage (secure)

---

## ✨ Features Checklist

- ✅ 6 input fields with validation
- ✅ Single prediction endpoint
- ✅ Batch predictions (optional)
- ✅ Color-coded results
- ✅ Prediction history storage
- ✅ API configuration UI
- ✅ Connection testing
- ✅ Error handling
- ✅ Modern design (Flo-inspired)
- ✅ Responsive layout

---

## 📱 Screen Navigation

```
App Start
    ↓
MainNavigationScreen
    ├─→ Home (Predict) ← Default
    ├─→ History
    └─→ Settings
```

---

## 🎓 Common Tasks

### Make a Prediction

1. Tap "Predict" tab
2. Fill all 6 fields
3. Tap "Predict" button
4. View color-coded result

### View History

1. Tap "History" tab
2. Scroll through past predictions
3. Tap delete icon to remove entry

### Configure API

1. Tap "Settings" tab
2. Change API URL
3. Tap "Save"
4. Tap "Check Connection" to test

### Clear Form

1. On Predict screen
2. Tap "Clear" button
3. All fields reset

---

## 📈 Result Interpretation

```
Score < 0.33:
├── Risk Level: Low Risk
├── Action: Continue monitoring
└── Message: Low probability

Score 0.33-0.67:
├── Risk Level: Medium Risk
├── Action: Consult healthcare provider
└── Message: Medium probability

Score > 0.67:
├── Risk Level: High Risk
├── Action: Immediate consultation
└── Message: High probability
```

---

## 🔧 Configuration Files

- **`pubspec.yaml`** - Dependencies and app metadata
- **`android/` folder** - Android configuration
- **`ios/` folder** - iOS configuration
- **`web/` folder** - Web configuration (if enabled)
- **`analysis_options.yaml`** - Code analysis rules

---

## 🌐 API Response Format

### Success

```json
{
  "prediction": 0.65,
  "confidence": "High",
  "input_data": {
    "age": 32,
    "menstrual_irregularity": 1,
    "chronic_pain_level": 6.5,
    "hormone_level_abnormality": 1,
    "infertility": 0,
    "bmi": 23.5
  }
}
```

### Error

```json
{
  "detail": [
    {
      "type": "value_error",
      "loc": ["body", "age"],
      "msg": "ensure this value is less than or equal to 100"
    }
  ]
}
```

---

## 📞 Need Help?

1. **Check README.md** for detailed documentation
2. **Check SETUP_GUIDE.md** for installation help
3. **Check ARCHITECTURE.md** for technical details
4. **Check Settings** → "Check Connection" to test API

---

**Version**: 1.0.0  
**Last Updated**: November 2024  
**Status**: Ready to Use ✅
