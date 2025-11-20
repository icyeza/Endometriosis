# 🚀 DEPLOYMENT GUIDE - Render Hosting

## Quick Summary

Your **Endometriosis Prediction API** is ready for deployment on **Render**!

- ✅ **FastAPI Application**: Fully functional with CORS middleware
- ✅ **Pydantic Validation**: Input validation with range constraints
- ✅ **Swagger UI**: Interactive API documentation at `/docs`
- ✅ **Model Integration**: Pre-trained linear regression model loaded
- ✅ **Batch Processing**: Support for single and batch predictions

---

## Step 1: Prepare Your GitHub Repository

### 1.1 Create a New GitHub Repository

Go to https://github.com/new and create a new repository:

- **Repository Name**: `endometriosis-api`
- **Description**: "FastAPI application for endometriosis diagnosis predictions"
- **Visibility**: Public (for Render to access)
- **Initialize**: Don't add README (we have one)

### 1.2 Push Code to GitHub

In your API folder, run:

```bash
# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Endometriosis Prediction API with FastAPI"

# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/endometriosis-api.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Expected directory structure on GitHub:**

```
endometriosis-api/
├── main.py                 ✓
├── requirements.txt        ✓
├── render.yaml            ✓
├── .gitignore             ✓
├── README.md              ✓
├── models/                ✓
│   ├── best_model.pkl
│   ├── scaler.pkl
│   ├── features.pkl
│   ├── label_encoders.pkl
│   └── model_summary.txt
├── test_api.py           (optional)
├── quick_test.py         (optional)
└── copy_models.py        (optional)
```

---

## Step 2: Deploy on Render

### 2.1 Create a Render Account

1. Go to https://render.com
2. Sign up with GitHub (or email)
3. Authorize Render to access your GitHub repositories

### 2.2 Create a New Web Service

1. Click **"New +"** button (top right)
2. Select **"Web Service"**
3. Connect your GitHub repository:
   - Click **"Connect account"** if not already connected
   - Search for `endometriosis-api` repository
   - Click **"Connect"**

### 2.3 Configure the Service

Fill in the following details:

| Field             | Value                                          |
| ----------------- | ---------------------------------------------- |
| **Name**          | `endometriosis-prediction-api`                 |
| **Environment**   | `Python 3`                                     |
| **Build Command** | `pip install -r requirements.txt`              |
| **Start Command** | `uvicorn main:app --host 0.0.0.0 --port $PORT` |
| **Instance Type** | `Free` (or `Starter` for production)           |

### 2.4 Set Environment Variables (Optional)

If you want to add environment variables, click **"Advanced"** and add:

```
LOG_LEVEL=INFO
```

### 2.5 Deploy

Click **"Create Web Service"**

Render will:

1. Clone your repository
2. Install dependencies
3. Start the Uvicorn server
4. Provide you with a public URL

**Deployment typically takes 2-5 minutes**

---

## Step 3: Access Your Deployed API

Once deployment is complete, Render will show you the public URL:

```
https://endometriosis-prediction-api.onrender.com
```

### Access Points:

- **Swagger UI (Interactive Docs)**:

  ```
  https://endometriosis-prediction-api.onrender.com/docs
  ```

- **ReDoc (Alternative Docs)**:

  ```
  https://endometriosis-prediction-api.onrender.com/redoc
  ```

- **OpenAPI JSON**:

  ```
  https://endometriosis-prediction-api.onrender.com/openapi.json
  ```

- **Health Check**:
  ```
  https://endometriosis-prediction-api.onrender.com/health
  ```

---

## Step 4: Test Your Deployed API

### 4.1 Test with Curl

```bash
curl -X POST "https://endometriosis-prediction-api.onrender.com/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 32,
    "menstrual_irregularity": 1,
    "chronic_pain_level": 6.5,
    "hormone_level_abnormality": 1,
    "infertility": 0,
    "bmi": 23.5
  }'
```

### 4.2 Test with Python

```python
import requests

url = "https://endometriosis-prediction-api.onrender.com/predict"
data = {
    "age": 32,
    "menstrual_irregularity": 1,
    "chronic_pain_level": 6.5,
    "hormone_level_abnormality": 1,
    "infertility": 0,
    "bmi": 23.5
}

response = requests.post(url, json=data)
print(response.json())
```

### 4.3 Expected Response

```json
{
  "prediction": 0.6234,
  "confidence": "Medium",
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

---

## Step 5: Monitor Your Deployment

### 5.1 View Logs

1. Go to https://dashboard.render.com
2. Select your service `endometriosis-prediction-api`
3. Click **"Logs"** tab
4. View real-time logs of requests and errors

### 5.2 View Metrics

Click **"Metrics"** tab to see:

- CPU usage
- Memory usage
- Request count
- Response times

### 5.3 Redeploy

To redeploy after making changes:

1. Push changes to GitHub
2. Render will automatically detect and redeploy
3. Or manually click **"Manual Deploy"** → **"Deploy latest commit"**

---

## Troubleshooting

### Service Won't Start

Check logs for errors:

1. Go to Render Dashboard
2. Click your service
3. View Logs tab
4. Look for error messages

Common issues:

- Missing model files in `models/` directory
- Wrong start command
- Missing dependencies in `requirements.txt`

### Slow Cold Starts

Free tier services sleep after 15 minutes of inactivity. First request will be slow (~30s).

**Solution**: Use Starter plan for production ($7/month)

### CORS Errors

The API has CORS enabled for all origins. If you still get CORS errors:

1. Check browser console for actual error
2. Verify the endpoint URL is correct
3. Check that POST data is JSON format

### Model Loading Errors

If you see scikit-learn version warnings:

- They are non-critical warnings
- API still works correctly
- To fix: Update scikit-learn version in requirements.txt

---

## API Documentation

### Endpoints Reference

#### 1. Health Check

```
GET /health
```

Returns service status and model availability.

#### 2. Single Prediction

```
POST /predict
```

Make prediction for one patient.

**Request Body**:

```json
{
  "age": 32,
  "menstrual_irregularity": 1,
  "chronic_pain_level": 6.5,
  "hormone_level_abnormality": 1,
  "infertility": 0,
  "bmi": 23.5
}
```

#### 3. Batch Prediction

```
POST /predict_batch
```

Make predictions for multiple patients.

**Request Body**:

```json
{
  "patients": [
    {...},
    {...}
  ]
}
```

#### 4. Model Information

```
GET /model-info
```

Get details about the trained model.

---

## Security Considerations

### For Production:

1. **Restrict CORS Origins**: Update `main.py`:

```python
allow_origins=[
    "https://yourdomain.com",
    "https://app.yourdomain.com"
]
```

2. **Add API Key Authentication**: (Optional)

```python
from fastapi.security import APIKey
```

3. **Use HTTPS**: Render provides SSL/TLS by default ✓

4. **Rate Limiting**: (Optional)

```python
from slowapi import Limiter
```

---

## Next Steps

1. ✅ Deploy to Render
2. ✅ Test the Swagger UI at `/docs`
3. ✅ Integrate with your Flask/Flutter app
4. ✅ Monitor performance in Render Dashboard
5. ✅ Update CORS and security settings for production

---

## Support & Resources

- **Render Docs**: https://render.com/docs
- **FastAPI Docs**: https://fastapi.tiangolo.com
- **Pydantic Docs**: https://docs.pydantic.dev
- **API GitHub**: https://github.com/YOUR_USERNAME/endometriosis-api

---

## Your API is Ready! 🎉

Once deployed, share this URL with stakeholders:

```
📊 API Documentation:
https://endometriosis-prediction-api.onrender.com/docs

🏥 Prediction Endpoint:
https://endometriosis-prediction-api.onrender.com/predict

✅ Status Check:
https://endometriosis-prediction-api.onrender.com/health
```

---

**Created**: November 18, 2025  
**Status**: Ready for Deployment ✓
