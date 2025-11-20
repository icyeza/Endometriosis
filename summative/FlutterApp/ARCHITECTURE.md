# Flutter App Architecture & UI Documentation

## 🏗 Architecture Overview

```
┌─────────────────────────────────────────┐
│         UI Layer (Screens)              │
│  ┌─────────────────────────────────────┐│
│  │ HomeScreen | HistoryScreen          ││
│  │  SettingsScreen                     ││
│  └─────────────────────────────────────┘│
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│       Business Logic Layer              │
│  ┌─────────────────────────────────────┐│
│  │  ApiService (HTTP Communication)   ││
│  │  Models (Data Classes)              ││
│  └─────────────────────────────────────┘│
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│      Data & Storage Layer               │
│  ┌─────────────────────────────────────┐│
│  │ SharedPreferences (Local Storage)   ││
│  │ REST API (Remote Data)              ││
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

---

## 📱 Screen Architecture

### 1. **Home Screen (Prediction Form)**

#### Purpose

Primary screen for making predictions. Users input patient data and receive risk assessment.

#### Components

```
┌────────────────────────────────────┐
│      SliverAppBar                  │
│  (Gradient Header with Icon)       │
├────────────────────────────────────┤
│     Patient Information Section    │
│  ┌──────────────────────────────┐  │
│  │ Age Input Field              │  │
│  │ BMI Input Field              │  │
│  │ Pain Level Input Field       │  │
│  │ Menstrual Irregularity       │  │
│  │ (Toggle Buttons Yes/No)      │  │
│  │ Hormone Abnormality          │  │
│  │ (Toggle Buttons Yes/No)      │  │
│  │ Infertility                  │  │
│  │ (Toggle Buttons Yes/No)      │  │
│  └──────────────────────────────┘  │
├────────────────────────────────────┤
│    Action Buttons Section          │
│  [Clear Button] [Predict Button]   │
├────────────────────────────────────┤
│     Result Display Area            │
│  (Shows result or error message)   │
└────────────────────────────────────┘
```

#### Key Features

- **Input Validation**: Real-time validation with error messages
- **Binary Fields**: Toggle buttons for Yes/No selections
- **Numeric Fields**: Text input with keyboard type detection
- **Result Display**: Color-coded risk assessment with visual feedback
- **Error Handling**: User-friendly error messages
- **Clear Button**: Reset form functionality

#### State Management

```dart
_formKey: GlobalKey<FormState>  // Form validation key
_isLoading: bool                // Loading state
_result: PredictionResponse?    // Prediction result
_errorMessage: String?          // Error message
_controllers: TextEditingController[]  // Input controllers
```

---

### 2. **History Screen (Past Predictions)**

#### Purpose

Display and manage historical predictions with filtering and deletion options.

#### Components

```
┌────────────────────────────────────┐
│       AppBar (Title + Delete Icon) │
├────────────────────────────────────┤
│     Prediction History List        │
│  ┌──────────────────────────────┐  │
│  │  Card 1: Prediction Result   │  │
│  │  ┌──────────────────────────┐│  │
│  │  │ Risk Level: 75% Medium   ││  │
│  │  │ Date: 2024-11-18 14:30   ││  │
│  │  ├──────────────────────────┤│  │
│  │  │ Age: 32, BMI: 23.5       ││  │
│  │  │ Pain: 6.5, Menstrual: Yes││  │
│  │  │ Hormone: Yes, Infertility││  │
│  │  ├──────────────────────────┤│  │
│  │  │ [Delete Button]          ││  │
│  │  └──────────────────────────┘│  │
│  │                              │  │
│  │  Card 2: Prediction Result   │  │
│  │  ...                         │  │
│  └──────────────────────────────┘  │
├────────────────────────────────────┤
│   Empty State (No predictions)     │
│   History icon + message           │
└────────────────────────────────────┘
```

#### Key Features

- **ListView Display**: Scrollable list of predictions
- **Card Layout**: Each prediction in a detailed card
- **Color Coding**: Risk level color (green/yellow/red)
- **Data Display**: All input parameters shown
- **Timestamp**: Date and time of prediction
- **Delete Actions**: Individual or bulk deletion
- **Empty State**: User-friendly message when no history

#### Data Persistence

```dart
_history: List<PredictionResponse>  // In-memory cache
SharedPreferences.prediction_history // Persistent storage
```

---

### 3. **Settings Screen (Configuration)**

#### Purpose

Configure API endpoint and test connectivity.

#### Components

```
┌────────────────────────────────────┐
│  AppBar (Settings Title)           │
├────────────────────────────────────┤
│   API Configuration Section        │
│  ┌──────────────────────────────┐  │
│  │ Label: "API Base URL"        │  │
│  │ ┌────────────────────────────┐│  │
│  │ │ TextField: http://...      ││  │
│  │ └────────────────────────────┘│  │
│  │ [Reset] [Save] Buttons       │  │
│  └──────────────────────────────┘  │
├────────────────────────────────────┤
│  Connection Status Section         │
│  ┌──────────────────────────────┐  │
│  │ 🟢 Status: Connected ✓       │  │
│  │ (Color changes: green/red)   │  │
│  │ [Check Connection] Button    │  │
│  └──────────────────────────────┘  │
├────────────────────────────────────┤
│   About Section                    │
│  ┌──────────────────────────────┐  │
│  │ App Name: Endometriosis...   │  │
│  │ Version: 1.0.0               │  │
│  │ API Version: v1.0            │  │
│  │ Description: (app info)      │  │
│  └──────────────────────────────┘  │
└────────────────────────────────────┘
```

#### Key Features

- **URL Configuration**: Change API endpoint
- **Connection Testing**: Check API availability
- **Status Indicator**: Real-time connection status
- **Default Reset**: One-click reset to default URL
- **App Information**: Version and description
- **Responsive Design**: Works on all screen sizes

#### State Management

```dart
_urlController: TextEditingController
_connectionStatus: String  // "Connected", "Disconnected", "Checking"
_isCheckingConnection: bool
```

---

## 🎨 Design System

### Color Palette

```dart
// Primary Colors (Rose/Pink - Health App Inspired)
primary: #E8839D        // Main brand color
primaryLight: #F5C7D8   // Light variant
primaryDark: #D4526B    // Dark variant

// Secondary Colors
secondary: #6B5B95      // Purple accent
secondaryLight: #C8B5D4 // Light purple

// Neutral Colors
white: #FFFFFF
black: #1A1A1A
grey: #9CA3AF           // Default text
greyLight: #F3F4F6      // Backgrounds
greyDark: #4B5563       // Labels

// Status Colors
success: #10B981        // Green (Low Risk)
warning: #F59E0B        // Amber (Medium Risk)
error: #EF4444          // Red (High Risk)
info: #3B82F6           // Blue (Information)
```

### Spacing System

```dart
xs: 4px
sm: 8px
md: 16px    // Standard padding
lg: 24px    // Section spacing
xl: 32px
xxl: 48px
```

### Border Radius

```dart
sm: 8px
md: 12px    // Form fields
lg: 16px    // Cards
xl: 20px    // Large elements
full: 999px // Circular
```

### Typography

- **Font**: Poppins (custom Google Font)
- **Headline**: 24px, Bold
- **Title**: 18px, Bold
- **Body**: 16px, Regular
- **Small**: 13px, Regular
- **Label**: 14px, SemiBold

### Shadow System

```dart
light: 0.05 opacity, 8px blur    // Subtle
medium: 0.1 opacity, 12px blur   // Standard
heavy: 0.15 opacity, 16px blur   // Prominent
```

---

## 🔄 Data Flow

### Making a Prediction

```
User Input Form
    ↓
Client-Side Validation
    ↓ (Success)
Create PredictionRequest
    ↓
POST /predict
    ↓
Server Processing & ML Model
    ↓
PredictionResponse
    ↓
Display Result (Color-coded)
    ↓
Save to LocalStorage (SharedPreferences)
    ↓
Display in History Screen
```

### Error Handling Flow

```
API Request
    ↓
Network/Server Error
    ↓
Parse Error Response
    ↓
Extract Error Message
    ↓
Display User-Friendly Error
    ↓
Options: Retry, Adjust Input, Check Settings
```

---

## 📊 Data Models

### PredictionRequest

```dart
class PredictionRequest {
  int age;                              // 18-100
  int menstrualIrregularity;            // 0 or 1
  double chronicPainLevel;              // 0.0-10.0
  int hormoneAbnormality;               // 0 or 1
  int infertility;                      // 0 or 1
  double bmi;                           // 10.0-60.0
}
```

### PredictionResponse

```dart
class PredictionResponse {
  double prediction;                    // 0.0-1.0 (risk score)
  String confidence;                    // "Low", "Medium", "High"
  PredictionRequest inputData;          // Original input
  DateTime timestamp;                   // When predicted

  // Computed Properties
  String riskLevel;                     // "Low/Medium/High Risk"
  String riskDescription;               // Detailed assessment
}
```

---

## 🌐 API Integration

### Service Layer (ApiService)

```dart
class ApiService {
  Future<String> getBaseUrl()
  Future<void> setBaseUrl(String url)
  Future<PredictionResponse> predict(PredictionRequest request)
  Future<Map<String, dynamic>> getHealth()
  Future<Map<String, dynamic>> getModelInfo()
}
```

### Error Handling

```
DioException Types:
├── connectionTimeout → "Check your internet connection"
├── sendTimeout → "Request timeout"
├── receiveTimeout → "Response timeout"
├── badResponse → Extract server error message
├── connectionError → "Check your internet connection"
└── unknown → Generic error message
```

---

## 📱 Navigation Flow

```
    ┌─────────────────────┐
    │   App Initialization│
    │   (main.dart)       │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │ MainNavigationScreen│
    │ (BottomNavBar)      │
    └──────────┬──────────┘
               │
    ┌──────────┴───────────────────┐
    │          │                   │
    │          │                   │
┌───▼──┐  ┌───▼──┐             ┌──▼───┐
│Home  │  │      │             │      │
│Screen│  │History            │Settings
│      │  │Screen             │Screen
└──────┘  └──────┘             └──────┘
```

### Bottom Navigation Items

1. **Home (Predict)** - Icon: home_rounded

   - Primary interaction screen
   - Make predictions

2. **History** - Icon: history_rounded

   - View past predictions
   - Manage history

3. **Settings** - Icon: settings_rounded
   - Configure API
   - Check connection

---

## 🎯 Input Validation Rules

### Numeric Fields

```dart
Age:
  ├── Type: Integer
  ├── Min: 18
  ├── Max: 100
  └── Error: "Age must be between 18 and 100"

BMI:
  ├── Type: Double
  ├── Min: 10.0
  ├── Max: 60.0
  └── Error: "BMI must be between 10.0 and 60.0"

Pain Level:
  ├── Type: Double
  ├── Min: 0.0
  ├── Max: 10.0
  └── Error: "Pain must be between 0.0 and 10.0"
```

### Binary Fields

```dart
Menstrual Irregularity, Hormone Abnormality, Infertility:
  ├── Type: Integer (0 or 1)
  ├── Options: [No (0), Yes (1)]
  ├── Display: Toggle buttons
  └── Error: "Please select an option"
```

---

## 🧪 State Management Pattern

```dart
// Home Screen Example
class HomeScreenState extends State<HomeScreen> {
  // UI State
  bool _isLoading = false;
  PredictionResponse? _result;
  String? _errorMessage;

  // Controllers
  TextEditingController _ageController;

  // Methods
  void _makePrediction() async {
    setState(() => _isLoading = true);
    try {
      var result = await _apiService.predict(request);
      setState(() => _result = result);
    } catch(e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
```

---

## 🔐 Local Storage

### SharedPreferences Keys

```dart
'api_base_url' → String (API endpoint)
'prediction_history' → List<String> (JSON encoded predictions)
```

### Data Persistence Flow

```
Prediction Made
    ↓
Response Received
    ↓
Save to SharedPreferences
    ↓
Load on History Screen
    ↓
Display in ListView
```

---

## 📐 Responsive Design

```
Layout Breakpoints:
├── Mobile (< 600dp)    → Single column
├── Tablet (600-900dp)  → Optimized for touch
└── Desktop (> 900dp)   → Multi-column layout
```

### Responsive Components

- **Forms**: Adapt to screen width
- **Cards**: Full width on mobile, constrained on tablet
- **Buttons**: Full width for easy tapping
- **AppBar**: Consistent across all sizes
- **Navigation**: BottomNavBar (mobile-first)

---

## 🚀 Performance Considerations

1. **Form Validation**: Real-time, not on every keystroke
2. **API Calls**: Single request per prediction
3. **History Loading**: Async from SharedPreferences
4. **Images**: Lightweight icons only
5. **Memory**: Proper disposal of controllers
6. **Rebuilds**: Strategic setState usage

---

## 🎓 Key Flutter Concepts Used

1. **StatefulWidget**: For screens with changing state
2. **CustomScrollView/SliverAppBar**: Advanced scrolling
3. **TextFormField**: Form field validation
4. **Container/Padding**: Layout and spacing
5. **ListTile/Card**: Data presentation
6. **SnackBar**: User feedback
7. **DialogBox**: Confirmations
8. **IconButton**: Interactive elements
9. **OutlinedButton/ElevatedButton**: Different button styles
10. **LinearProgressIndicator**: Visual feedback

---

## ✅ Quality Checklist

- ✓ Input validation working correctly
- ✓ API integration complete
- ✓ Error handling implemented
- ✓ UI responsive on all sizes
- ✓ Data persistence working
- ✓ Color scheme consistent
- ✓ Navigation smooth
- ✓ Memory management proper
- ✓ Code well-organized
- ✓ Documentation complete

---

**Architecture Version**: 1.0  
**Last Updated**: November 2024  
**Status**: Production Ready ✅
