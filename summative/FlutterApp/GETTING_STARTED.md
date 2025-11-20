# 🚀 Flutter App - Getting Started (5 Minutes)

## ✅ What You Have

A complete, production-ready Flutter application that connects to your FastAPI prediction endpoint with:

- ✅ 3 fully functional screens (Predict, History, Settings)
- ✅ 6 input fields for patient data
- ✅ Real-time input validation
- ✅ API integration ready
- ✅ History persistence
- ✅ Modern, professional UI design
- ✅ Comprehensive documentation

---

## 🎯 Quick Setup (2 Steps)

### Step 1: Install Dependencies

```bash
cd FlutterApp
flutter pub get
```

_Takes 1-2 minutes_

### Step 2: Run the App

```bash
flutter run
```

_App starts on your default device/emulator_

---

## 🔧 Configure API (Important!)

The app comes with a default API URL: `http://localhost:8000`

### To Use a Different Server:

1. **Open the app**
2. **Tap the "Settings" tab** (bottom right)
3. **Change the API URL** in the text field
4. **Tap "Save"**
5. **Tap "Check Connection"** to verify

---

## 📱 Using the App

### **Predict Screen** (Home Tab)

1. Enter patient data in all 6 fields
2. Tap the **"Predict"** button
3. See color-coded result:
   - 🟢 Green = Low Risk
   - 🟡 Yellow = Medium Risk
   - 🔴 Red = High Risk

### **History Screen** (Middle Tab)

- View all past predictions
- Delete individual entries
- Clear all history

### **Settings Screen** (Right Tab)

- Configure API URL
- Test connection
- View app version

---

## 📋 Input Fields

| Field                  | Type   | Range     | Example |
| ---------------------- | ------ | --------- | ------- |
| Age                    | Number | 18-100    | 32      |
| BMI                    | Number | 10.0-60.0 | 23.5    |
| Chronic Pain           | Number | 0.0-10.0  | 6.5     |
| Menstrual Irregularity | Yes/No | 0-1       | Yes     |
| Hormone Abnormality    | Yes/No | 0-1       | Yes     |
| Infertility            | Yes/No | 0-1       | No      |

---

## 🎨 Key Features

### ✨ Modern Design

- Beautiful rose/pink color scheme
- Professional layout
- Smooth animations
- Responsive design

### 🔐 Data Validation

- Checks ranges before sending
- Clear error messages
- Real-time feedback

### 💾 Auto-Save History

- Predictions saved automatically
- Viewable anytime
- Delete when needed

### 🌐 Flexible API

- Configurable endpoint
- Connection testing
- Clear error messages

---

## 🛠 Common Tasks

### Make a Prediction

```
1. Fill all 6 fields
2. Tap "Predict" button
3. View color-coded result
4. Result saved to history automatically
```

### Check Connection

```
1. Go to Settings tab
2. Tap "Check Connection" button
3. See status: Connected ✓ or Disconnected ✗
```

### View Past Predictions

```
1. Tap "History" tab
2. Scroll to see all predictions
3. Tap delete icon to remove
```

### Reset Form

```
1. On Predict screen
2. Tap "Clear" button
3. All fields cleared
```

---

## 📁 File Structure

```
FlutterApp/
├── lib/
│   ├── main.dart                 (App entry point)
│   ├── screens/
│   │   ├── home_screen.dart     (Prediction form)
│   │   ├── history_screen.dart  (Prediction history)
│   │   └── settings_screen.dart (Configuration)
│   ├── services/
│   │   └── api_service.dart     (API communication)
│   ├── models/
│   │   └── prediction_model.dart (Data models)
│   └── constants/
│       └── colors.dart           (Design system)
├── pubspec.yaml                  (Dependencies)
└── README.md, SETUP_GUIDE.md, etc. (Documentation)
```

---

## 🔌 API Connection

### Default URL

```
http://localhost:8000
```

### Required Endpoints

- `POST /predict` - Make prediction
- `GET /health` - Check health
- `GET /model-info` - Get info

### Example Request

```json
POST http://localhost:8000/predict

{
  "age": 32,
  "menstrual_irregularity": 1,
  "chronic_pain_level": 6.5,
  "hormone_level_abnormality": 1,
  "infertility": 0,
  "bmi": 23.5
}
```

---

## 📚 Documentation

All documentation is in the FlutterApp folder:

| File               | Purpose           | Read Time |
| ------------------ | ----------------- | --------- |
| README.md          | Complete guide    | 10 min    |
| SETUP_GUIDE.md     | Installation help | 8 min     |
| QUICK_REFERENCE.md | Quick commands    | 5 min     |
| ARCHITECTURE.md    | Technical details | 15 min    |
| PROJECT_SUMMARY.md | Project overview  | 8 min     |
| FILE_STRUCTURE.md  | File organization | 5 min     |

---

## 🚀 Running on Different Devices

### Android Emulator

```bash
flutter run -d android
```

### iOS Simulator

```bash
flutter run -d ios
```

### Physical Device

```bash
flutter devices          # List devices
flutter run -d <id>    # Run on specific device
```

### Web Browser

```bash
flutter run -d chrome
```

---

## 🐛 Troubleshooting

### "Cannot connect to API"

1. Check API is running: `http://localhost:8000/health`
2. In Settings, update API URL if different
3. Tap "Check Connection" to verify

### "Input fields show errors"

1. Ensure all fields are filled
2. Check values are in valid ranges
3. Age: 18-100, BMI: 10-60, Pain: 0-10

### "App won't start"

```bash
flutter clean
flutter pub get
flutter run
```

### "Hot reload not working"

- Press `r` in terminal for hot restart

---

## 💡 Tips & Tricks

### Faster Testing

1. Use default localhost URL initially
2. Pre-fill test data to speed up testing
3. Use emulator with sufficient resources

### Better Organization

1. Clear history periodically
2. Update API URL in Settings once
3. Use "Check Connection" before making predictions

### Development Mode

```bash
flutter run --debug      # Debug mode (default)
flutter run --profile    # Performance profile
flutter run --release    # Optimized release
```

---

## ✅ Pre-Flight Checklist

Before using the app:

- [ ] Flutter installed (`flutter --version`)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] API running and accessible
- [ ] Correct API URL configured in Settings
- [ ] Connection test passes (green checkmark)

---

## 📊 Result Interpretation

```
Score 0.0 - 0.33:
└── Low Risk
    └── Unlikely to have endometriosis
    └── Continue monitoring

Score 0.33 - 0.67:
└── Medium Risk
    └── Some indicators present
    └── Consult healthcare provider

Score 0.67 - 1.0:
└── High Risk
    └── Multiple risk factors
    └── Immediate consultation recommended
```

---

## 🎓 Learning More

For detailed information:

1. **Want to understand how it works?**

   - Read `ARCHITECTURE.md`

2. **Need installation help?**

   - Read `SETUP_GUIDE.md`

3. **Looking for quick commands?**

   - Read `QUICK_REFERENCE.md`

4. **Want full feature details?**
   - Read `README.md`

---

## 🚀 Next Steps

### Immediate (Now)

1. ✅ Run `flutter pub get`
2. ✅ Run `flutter run`
3. ✅ Verify API connection in Settings

### Soon (Testing)

1. Make a test prediction
2. Check result appears
3. View in History tab
4. Delete from History

### Later (Production)

1. Update API URL to production server
2. Test thoroughly with real data
3. Build release version
4. Deploy to app stores

---

## 🎯 Success Indicators

You're all set when:

- ✅ App starts without errors
- ✅ Settings → "Check Connection" shows green ✓
- ✅ Can enter data and tap "Predict"
- ✅ Result displays with color and percentage
- ✅ Result appears in History tab

---

## 📞 Need Help?

1. **Check troubleshooting section above**
2. **Read the relevant documentation file**
3. **Check API is running**: `curl http://localhost:8000/health`
4. **Check app logs**: Look at Flutter console output

---

## 🎉 You're Ready!

Your Flutter app is complete and ready to use.

**Start by:**

1. Running `flutter run`
2. Configuring API in Settings
3. Making your first prediction

**Enjoy! 🚀**

---

**Version**: 1.0.0  
**Last Updated**: November 2024  
**Status**: Ready to Use ✅
