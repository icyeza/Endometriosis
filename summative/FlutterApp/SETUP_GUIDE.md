# Flutter App Setup Guide

## 🚀 Quick Start

### Step 1: Prerequisites

- **Flutter SDK**: Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Comes with Flutter
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- **Emulator/Device**: Android emulator, iOS simulator, or physical device

### Step 2: Verify Installation

```bash
flutter --version
dart --version
flutter doctor
```

### Step 3: Get Flutter Dependencies

```bash
cd FlutterApp
flutter pub get
```

### Step 4: Run the App

#### **On Emulator/Simulator**

```bash
# List available devices
flutter devices

# Run on default device
flutter run

# Run on specific device
flutter run -d <device_id>
```

#### **On Physical Device**

```bash
# Enable USB debugging (Android)
# Or enable developer mode (iOS)

flutter devices
flutter run -d <device_id>
```

#### **On Web**

```bash
flutter run -d chrome
```

---

## 📋 Project Structure

```
FlutterApp/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── constants/
│   │   └── colors.dart             # Design system
│   ├── models/
│   │   └── prediction_model.dart   # Data models
│   ├── services/
│   │   └── api_service.dart        # API client
│   └── screens/
│       ├── home_screen.dart        # Prediction form
│       ├── history_screen.dart     # Past predictions
│       └── settings_screen.dart    # Configuration
├── pubspec.yaml                    # Dependencies
├── android/                        # Android config
├── ios/                            # iOS config
├── web/                            # Web config
└── README.md                       # Documentation
```

---

## 🔧 Configuration

### API Setup

1. **Default API URL**: `http://localhost:8000`
2. **Configure in App**: Settings screen → Enter API URL → Save
3. **Test Connection**: Settings screen → Check Connection button

### API Requirements

- FastAPI backend must be running
- CORS must be enabled (already configured)
- `/predict` endpoint must be available

---

## 📱 Running on Different Platforms

### Android

```bash
# Development
flutter run

# Release build
flutter build apk --release

# App bundle (for Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Development
flutter run

# Release build
flutter run --release

# Archive for App Store
flutter build ios --release
```

### Web

```bash
# Development
flutter run -d chrome

# Release build
flutter build web --release
```

---

## 🐛 Common Issues & Solutions

### Issue: "Flutter command not found"

**Solution**: Add Flutter to PATH

```bash
# On Windows (PowerShell)
$env:Path += ";C:\path\to\flutter\bin"

# Add permanently to system PATH
```

### Issue: "Gradle build failed"

**Solution**: Clean and rebuild

```bash
flutter clean
cd android
gradle clean
cd ..
flutter pub get
flutter run
```

### Issue: "CocoaPods pods are out of date"

**Solution**: Update pods

```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
pod install
cd ..
flutter run
```

### Issue: "Cannot connect to API"

**Solution**: Verify API is running

```bash
# Check if API is accessible
curl http://localhost:8000/health

# Or use Settings screen to test connection
```

### Issue: "Hot reload not working"

**Solution**: Restart the app

```bash
# In terminal where app is running
R  - Hot reload
r  - Hot restart
q  - Quit
```

---

## 🎯 Development Workflow

### 1. Make Changes

Edit your Dart files in `lib/` directory

### 2. Hot Reload (Quick)

- Save file in IDE, or press `R` in terminal
- Changes visible in app within 1 second

### 3. Hot Restart (When Needed)

- Press `r` in terminal if hot reload fails
- Full restart of Dart VM, takes 2-3 seconds

### 4. Full Rebuild

```bash
flutter clean
flutter run
```

---

## 📦 Managing Dependencies

### Add Package

```bash
flutter pub add package_name
```

### Update Packages

```bash
flutter pub get        # Get dependencies
flutter pub upgrade    # Upgrade to latest
flutter pub outdated   # Check outdated packages
```

### Remove Package

```bash
flutter pub remove package_name
```

### Edit pubspec.yaml Manually

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  dio: ^5.3.0
```

---

## 🧪 Testing

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/models/prediction_model_test.dart

# With coverage
flutter test --coverage
```

### Build Test APK

```bash
flutter build apk --debug
```

---

## 📊 Performance Optimization

### Disable Debug Banner

```dart
// In main.dart
debugShowCheckedModeBanner: false
```

### Profile App

```bash
flutter run --profile
```

### Check App Size

```bash
flutter build apk --analyze-size
```

---

## 🔐 Security Tips

1. **Never hardcode API URLs in production**

   - Use environment variables or configuration
   - Settings screen for user configuration

2. **Always use HTTPS in production**

   - Change `http://` to `https://`
   - Implement SSL pinning if needed

3. **Validate user input**

   - Already implemented in PredictionRequest model

4. **Protect sensitive data**
   - SharedPreferences for non-sensitive data
   - Secure storage for sensitive data (API keys)

---

## 🚀 Deployment Checklist

- [ ] API URL configured for production
- [ ] HTTPS enabled
- [ ] Error handling tested
- [ ] Offline behavior tested
- [ ] Performance optimized
- [ ] App signed (Android/iOS)
- [ ] Privacy policy created
- [ ] Terms of service created
- [ ] Tested on real devices
- [ ] Version number updated
- [ ] Build number incremented

---

## 📱 Device Testing

### Android Device

```bash
# Enable USB debugging
# Settings > Developer Options > USB Debugging

adb devices
flutter devices
flutter run -d <device_id>
```

### iOS Device

```bash
# Sign app with Apple ID
# In Xcode: Signing & Capabilities

open ios/Runner.xcworkspace
flutter run -d <device_id>
```

---

## 📖 Useful Commands Reference

```bash
# Clean
flutter clean

# Get dependencies
flutter pub get

# Run app
flutter run

# Run with specific device
flutter run -d <device_id>

# Debug mode
flutter run --debug

# Release mode
flutter run --release

# Profile mode
flutter run --profile

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build web
flutter build web --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Check code issues
dart fix --dry-run
dart fix --apply

# Format code
dart format lib/

# Get all devices
flutter devices

# Doctor (diagnostic info)
flutter doctor -v
```

---

## 🎓 Learning Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Dart Language Tour**: https://dart.dev/guides/language/language-tour
- **Widget Catalog**: https://flutter.dev/docs/development/ui/widgets
- **Material Design**: https://material.io/design
- **Awesome Flutter**: https://github.com/Solido/awesome-flutter

---

## 📞 Getting Help

1. **Flutter Docs**: https://flutter.dev/docs
2. **Stack Overflow**: Tag with `flutter`
3. **GitHub Issues**: flutter/flutter repository
4. **Flutter Community**: https://flutter.dev/community

---

## ✅ Setup Complete!

Your Flutter app is now ready to:

- ✓ Make predictions via API
- ✓ Store prediction history
- ✓ Configure API settings
- ✓ Display beautiful UI

### Next Steps:

1. Start the FastAPI backend
2. Configure API URL in Settings
3. Create a test prediction
4. Check history and settings

**Happy coding! 🎉**
