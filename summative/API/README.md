# Endometriosis Prediction API

A FastAPI application that provides machine learning endpoints for predicting endometriosis diagnosis based on patient medical data.

## Features

- ✅ **REST API** built with FastAPI
- ✅ **CORS Support** for cross-origin requests
- ✅ **Pydantic Validation** with data type enforcement and range constraints
- ✅ **Single & Batch Predictions** endpoints
- ✅ **Interactive Swagger UI** documentation at `/docs`
- ✅ **Model Artifacts** saved and versioned
- ✅ **Production Ready** with proper error handling

## Project Structure

```
API/
├── main.py                 # FastAPI application
├── requirements.txt        # Python dependencies
├── render.yaml            # Render deployment config
├── .gitignore            # Git ignore rules
├── README.md             # This file
└── models/               # Pre-trained model artifacts
    ├── best_model.pkl
    ├── scaler.pkl
    ├── features.pkl
    ├── label_encoders.pkl
    └── model_summary.txt
```

## Installation

### Local Development

1. **Clone or navigate to the project directory**:

   ```bash
   cd API
   ```

2. **Create a virtual environment** (optional but recommended):

   ```bash
   python -m venv venv

   # Windows
   venv\Scripts\activate

   # macOS/Linux
   source venv/bin/activate
   ```

3. **Install dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

4. **Ensure model files are in place**:
   - Copy the `models` folder from the `linear_regression` directory to the `API` directory
   - Or update the model path in `main.py` if located elsewhere

## Running Locally

Start the development server:

```bash
python main.py
```

Or use uvicorn directly:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at: `http://localhost:8000`

### Access API Documentation

- **Swagger UI (Interactive)**: http://localhost:8000/docs
- **ReDoc (Alternative UI)**: http://localhost:8000/redoc
- **OpenAPI JSON**: http://localhost:8000/openapi.json

## API Endpoints

### 1. Health Check

- **Endpoint**: `GET /`
- **Description**: Check API status
- **Response**: Status and documentation links

### 2. Health Status

- **Endpoint**: `GET /health`
- **Description**: Detailed health check
- **Response**: Service status and model availability

### 3. Single Prediction

- **Endpoint**: `POST /predict`
- **Description**: Make prediction for a single patient
- **Input**: Patient data with validation
- **Output**: Diagnosis prediction and confidence level

**Example Request**:

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

**Example Response**:

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

### 4. Batch Prediction

- **Endpoint**: `POST /predict_batch`
- **Description**: Make predictions for multiple patients
- **Input**: Array of patient records
- **Output**: Array of predictions with status

**Example Request**:

```json
{
  "patients": [
    {
      "age": 32,
      "menstrual_irregularity": 1,
      "chronic_pain_level": 6.5,
      "hormone_level_abnormality": 1,
      "infertility": 0,
      "bmi": 23.5
    },
    {
      "age": 45,
      "menstrual_irregularity": 1,
      "chronic_pain_level": 3.2,
      "hormone_level_abnormality": 0,
      "infertility": 1,
      "bmi": 25.0
    }
  ]
}
```

### 5. Model Information

- **Endpoint**: `GET /model-info`
- **Description**: Get details about the trained model
- **Response**: Model type, features, status

## Input Validation

All inputs are validated using Pydantic with the following constraints:

| Field                     | Type  | Range     | Description          |
| ------------------------- | ----- | --------- | -------------------- |
| age                       | int   | 18-100    | Patient age in years |
| menstrual_irregularity    | int   | 0-1       | Binary indicator     |
| chronic_pain_level        | float | 0.0-10.0  | Pain level on scale  |
| hormone_level_abnormality | int   | 0-1       | Binary indicator     |
| infertility               | int   | 0-1       | Binary indicator     |
| bmi                       | float | 10.0-60.0 | Body Mass Index      |

## CORS Configuration

The API includes CORS middleware configured to accept requests from all origins. In production, modify the `allow_origins` list in `main.py` to include only trusted domains:

```python
allow_origins=[
    "https://yourdomain.com",
    "https://app.yourdomain.com",
    # ... other trusted origins
]
```

## Deployment on Render

### Step 1: Prepare Repository

1. Create a GitHub repository with the following structure:

   ```
   endometriosis-api/
   ├── API/
   │   ├── main.py
   │   ├── requirements.txt
   │   ├── render.yaml
   │   ├── .gitignore
   │   ├── README.md
   │   └── models/
   │       ├── best_model.pkl
   │       ├── scaler.pkl
   │       ├── features.pkl
   │       └── label_encoders.pkl
   ```

2. Initialize git and push to GitHub:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Endometriosis Prediction API"
   git remote add origin https://github.com/yourusername/endometriosis-api.git
   git push -u origin main
   ```

### Step 2: Deploy on Render

1. Go to [render.com](https://render.com)
2. Sign up or log in to your account
3. Click **"New +"** and select **"Web Service"**
4. Connect your GitHub repository
5. Configure the service:
   - **Name**: `endometriosis-prediction-api`
   - **Environment**: `Python`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Plan**: Free (or paid for production)
6. Click **"Deploy"**

### Step 3: Access Your Deployed API

Once deployed, Render will provide you with a public URL. Access your API documentation:

```
https://your-service-name.onrender.com/docs
```

Example:

```
https://endometriosis-prediction-api.onrender.com/docs
```

## Testing with cURL

### Single Prediction

```bash
curl -X POST "http://localhost:8000/predict" \
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

### Batch Prediction

```bash
curl -X POST "http://localhost:8000/predict_batch" \
  -H "Content-Type: application/json" \
  -d '{
    "patients": [
      {
        "age": 32,
        "menstrual_irregularity": 1,
        "chronic_pain_level": 6.5,
        "hormone_level_abnormality": 1,
        "infertility": 0,
        "bmi": 23.5
      }
    ]
  }'
```

## Environment Variables

Create a `.env` file for configuration (optional):

```env
LOG_LEVEL=INFO
MODEL_PATH=models
```

## Performance Considerations

- **Single Prediction**: ~50-100ms
- **Batch Processing**: ~2-5ms per patient
- **Memory Usage**: ~200MB (models loaded on startup)

## Troubleshooting

### Model Not Loading

- Ensure the `models` directory exists in the API directory
- Check that all model files are present: `best_model.pkl`, `scaler.pkl`, `features.pkl`, `label_encoders.pkl`
- Check server logs for detailed error messages

### CORS Errors

- In development, CORS is configured to allow all origins
- In production, specify allowed origins in the CORS middleware configuration

### Port Already in Use

```bash
# Change the port when running
uvicorn main:app --host 0.0.0.0 --port 8001
```

## API Response Status Codes

- **200 OK**: Successful prediction
- **400 Bad Request**: Invalid input data or validation error
- **422 Unprocessable Entity**: Request body validation failed
- **500 Internal Server Error**: Server error during prediction
- **503 Service Unavailable**: Model not loaded

## Security Considerations

1. **Input Validation**: All inputs are validated using Pydantic
2. **Type Checking**: Enforced data types prevent injection attacks
3. **Range Constraints**: Realistic value ranges prevent anomalies
4. **CORS Security**: Configure allowed origins in production
5. **Error Handling**: Detailed errors only in development mode

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Commit and push
5. Create a pull request

## License

This project is part of an educational assignment on Machine Learning and API Development.

## Support

For issues or questions, please check:

- API Documentation: `http://localhost:8000/docs`
- Model Information: `GET /model-info`
- Health Status: `GET /health`

## References

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Pydantic Documentation](https://docs.pydantic.dev/)
- [Render Documentation](https://render.com/docs)
- [CORS Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
