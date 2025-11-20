# Video Presentation Script - Endometriosis Prediction App

**Duration: 2 minutes | Camera ON throughout**

---

## 🎬 INTRODUCTION (0:00 - 0:15)

**[Camera on, smile, confident posture]**

> "Hello! Today I'm presenting my Endometriosis Risk Prediction application - a full-stack machine learning solution designed to empower women's health through accessible AI-driven predictions. Let me show you how it works."

---

## 📱 PART 1: MOBILE APP DEMO (0:15 - 0:45)

**[Screen share: Flutter Web App running]**

### Show the Prediction Interface (0:15 - 0:30)

> "Here's the prediction interface. I have **six input fields** that match our dataset features:"

**[Fill in sample data while speaking]:**

- Age: 32
- BMI: 24.5
- Chronic Pain Level: 7.5
- Menstrual Irregularity: Yes (toggle)
- Hormone Abnormality: Yes (toggle)
- Infertility: No (toggle)

> "Notice the validation - age must be 18-100, pain level 0-10, and binary toggles for clinical indicators."

### Make the Prediction (0:30 - 0:40)

**[Click "Predict Risk" button]**

> "When I click Predict Risk, the app sends a POST request to our FastAPI backend..."

**[Show result card appearing]**

> "And we get a **54.5% risk score** - that's Medium risk with High confidence. The color-coded display and progress bar make it easy to interpret."

### Show History Feature (0:40 - 0:45)

**[Navigate to History tab]**

> "All predictions are saved locally using SharedPreferences, maintaining up to 50 records for tracking patient history."

---

## 🔧 PART 2: API SWAGGER DEMO (0:45 - 1:05)

**[Screen share: http://0.0.0.0:8000/docs]**

### Show API Documentation (0:45 - 0:50)

> "Now let's test the API directly. Here's our Swagger UI at port 8000 - fully documented with OpenAPI standards."

### Test the /predict Endpoint (0:50 - 1:00)

**[Click on POST /predict, then "Try it out"]**

> "I'll test the predict endpoint with this sample data..."

**[Paste into Request body]:**

```json
{
  "age": 28,
  "menstrual_irregularity": 1,
  "chronic_pain_level": 8.0,
  "hormone_level_abnormality": 1,
  "infertility": 0,
  "bmi": 22.3
}
```

**[Click Execute]**

### Show Response (1:00 - 1:05)

> "Perfect! **200 OK** response. Prediction is **0.6234** or 62.34% risk - High confidence. Notice the **Pydantic validation** ensures all constraints are met: age 18-100, pain 0-10, binary values 0 or 1. The **CORS middleware** allows our Flutter app to communicate seamlessly."

---

## 🤖 PART 3: MODEL JUSTIFICATION (1:05 - 1:50)

**[Screen share: Jupyter notebook OR slide with metrics]**

### Dataset Context (1:05 - 1:20)

> "For context: I used the **Kaggle Endometriosis Dataset** with **10,000 patient records** and **6 features**. This is a **regression problem** predicting diagnosis probability from 0 to 1, not classification."

> "I trained **three models**: Linear Regression using SGD, Decision Tree, and Random Forest."

### Model Performance Metrics (1:20 - 1:35)

**[Show comparison table or metrics]**

> "Here are the performance metrics on the test set:"

- **Linear Regression (SGD)**: R² = 0.0692, MSE = 0.2214
- **Decision Tree**: R² = -0.0156, MSE = 0.2417
- **Random Forest**: R² = 0.0156, MSE = 0.2343

> "While none achieved high R² scores, **Linear Regression performed best** with the lowest Mean Squared Error and highest R² score."

### Model Selection Justification (1:35 - 1:50)

> "I selected **Linear Regression with Stochastic Gradient Descent** for deployment because:"

1. **Best Performance**: Highest R² (0.0692) and lowest loss (MSE = 0.2214)
2. **Dataset Fit**: With only 6 features, linear relationships are appropriate
3. **Interpretability**: Healthcare requires explainable predictions - each coefficient represents a feature's impact
4. **Efficiency**: Fast inference for real-time predictions
5. **Clinical Context**: Endometriosis diagnosis is complex with many unmeasured factors, so modest R² is expected

> "The model was saved using joblib with StandardScaler for consistent preprocessing."

---

## 🎯 PART 4: DEPLOYMENT & CONCLUSION (1:50 - 2:00)

### Deployment Overview (1:50 - 1:55)

> "Deployment architecture: **FastAPI backend** with CORS on port 8000, **Flutter web frontend**, and **StandardScaler** for feature normalization. All model artifacts - the SGD model, scaler, feature names, and encoders - are loaded at startup."

### Closing (1:55 - 2:00)

**[Camera focus, smile]**

> "This solution demonstrates end-to-end ML deployment: from data analysis to production API with a modern UI. The focus is on **accessibility, validation, and clinical relevance**. Thank you!"

**[End recording]**

---

## 📋 CHECKLIST - Ensure You Show:

- ✅ Mobile app with all 6 input fields
- ✅ Prediction button working
- ✅ Output display with risk score, confidence, visual indicators
- ✅ History feature
- ✅ Swagger UI at /docs
- ✅ API POST request test with sample data
- ✅ 200 OK response with prediction result
- ✅ Mention CORS and Pydantic validation
- ✅ Show/mention all 3 models trained
- ✅ Display performance metrics (R², MSE)
- ✅ Justify Linear Regression selection
- ✅ Explain deployment architecture
- ✅ Camera ON throughout

---

## 🎥 TECHNICAL SETUP BEFORE RECORDING:

### Terminal 1 - Start API:

```powershell
cd API
python main.py
# Wait for "Application startup complete"
```

### Terminal 2 - Start Flutter App:

```powershell
cd FlutterApp
flutter run -d chrome --web-port=61045
# Wait for app to load in browser
```

### Browser Tabs to Have Open:

1. **Tab 1**: http://localhost:61045 (Flutter App)
2. **Tab 2**: http://0.0.0.0:8000/docs (Swagger UI)
3. **Tab 3**: Jupyter notebook with metrics (or screenshot ready)

### Screen Recording Settings:

- **Resolution**: 1920x1080 minimum
- **Frame rate**: 30fps
- **Audio**: Clear microphone, test levels
- **Camera**: Well-lit, eye level, professional background
- **Duration**: Aim for 1:50-2:00 (under 2 minutes is key!)

---

## 💡 PRO TIPS:

1. **Practice 2-3 times** to stay under 2 minutes
2. **Speak clearly and confidently** - not too fast
3. **Point to screen elements** while explaining
4. **Have sample data ready** (copy-paste for speed)
5. **Pre-fill some fields** before recording to save time
6. **Test both systems work** before recording
7. **Smile and make eye contact** with camera
8. **Emphasize key terms**: R², MSE, Pydantic, CORS, deployment
9. **Show enthusiasm** about the project
10. **End strong** with confident closing statement

---

## 🚨 IF SOMETHING GOES WRONG DURING RECORDING:

- **API error**: Restart API server, verify port 8000
- **Flutter error**: Restart with `flutter run -d chrome`
- **Prediction fails**: Check API logs, verify model files in `models/` directory
- **Too slow**: Cut down dataset explanation, focus on metrics only
- **Too fast**: Add brief pause after predictions, explain output more

---

## 📊 OPTIONAL: CREATE A METRICS SLIDE

If you want a cleaner visual than the notebook, create a simple slide showing:

```
Model Performance Comparison
═══════════════════════════════════════
Model                    R²        MSE
───────────────────────────────────────
Linear Regression      0.0692    0.2214  ⭐ SELECTED
Decision Tree         -0.0156    0.2417
Random Forest          0.0156    0.2343
═══════════════════════════════════════

Selected: Linear Regression (SGD)
Reason: Best performance + interpretability
        for clinical healthcare context
```

---

**Good luck with your presentation! 🎉**
