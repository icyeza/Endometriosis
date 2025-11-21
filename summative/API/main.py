"""
FastAPI application for Endometriosis Regression Model Predictions
This API provides endpoints to make predictions using the trained linear regression model.
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, field_validator
from typing import Optional
import joblib
import numpy as np
import pandas as pd
import os
from pathlib import Path

# Initialize FastAPI app
app = FastAPI(
    title="Endometriosis Prediction API",
    description="API for predicting endometriosis diagnosis using machine learning",
    version="1.0.0"
)

# Configure CORS (Cross-Origin Resource Sharing)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (in production, specify allowed domains)
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

# ==================== Pydantic Models ====================

class PatientData(BaseModel):
    """
    Input model for patient endometriosis prediction.
    
    Attributes:
        age: Patient age in years (18-100)
        menstrual_irregularity: Binary indicator (0 or 1)
        chronic_pain_level: Pain level on scale 0-10
        hormone_level_abnormality: Binary indicator (0 or 1)
        infertility: Binary indicator of infertility (0 or 1)
        bmi: Body Mass Index (10-60)
    """
    
    age: int = Field(
        ...,
        ge=18,
        le=100,
        description="Patient age in years (18-100)"
    )
    menstrual_irregularity: int = Field(
        ...,
        ge=0,
        le=1,
        description="Menstrual irregularity (0=No, 1=Yes)"
    )
    chronic_pain_level: float = Field(
        ...,
        ge=0.0,
        le=10.0,
        description="Chronic pain level on scale 0-10"
    )
    hormone_level_abnormality: int = Field(
        ...,
        ge=0,
        le=1,
        description="Hormone level abnormality (0=No, 1=Yes)"
    )
    infertility: int = Field(
        ...,
        ge=0,
        le=1,
        description="Infertility status (0=No, 1=Yes)"
    )
    bmi: float = Field(
        ...,
        ge=10.0,
        le=60.0,
        description="Body Mass Index (10-60)"
    )
    
    @field_validator('age')
    @classmethod
    def validate_age(cls, v):
        if v < 18 or v > 100:
            raise ValueError('Age must be between 18 and 100 years')
        return v
    
    @field_validator('chronic_pain_level')
    @classmethod
    def validate_pain_level(cls, v):
        if v < 0 or v > 10:
            raise ValueError('Chronic pain level must be between 0 and 10')
        return v
    
    @field_validator('bmi')
    @classmethod
    def validate_bmi(cls, v):
        if v < 10 or v > 60:
            raise ValueError('BMI must be between 10 and 60')
        return v
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "age": 32,
                "menstrual_irregularity": 1,
                "chronic_pain_level": 6.5,
                "hormone_level_abnormality": 1,
                "infertility": 0,
                "bmi": 23.5
            }
        }
    }


class BatchPredictionRequest(BaseModel):
    """
    Input model for batch predictions.
    
    Attributes:
        patients: List of patient records for batch prediction
    """
    patients: list[PatientData] = Field(..., description="List of patient data for batch prediction")
    
    model_config = {
        "json_schema_extra": {
            "example": {
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
        }
    }


class PredictionResponse(BaseModel):
    """Response model for predictions."""
    prediction: float = Field(..., description="Predicted diagnosis probability (0-1)")
    confidence: str = Field(..., description="Confidence level: Low, Medium, or High")
    input_data: dict = Field(..., description="Echo of input data for verification")


class BatchPredictionResponse(BaseModel):
    """Response model for batch predictions."""
    predictions: list[dict] = Field(..., description="List of predictions for each patient")
    total_processed: int = Field(..., description="Total number of patients processed")
    success: bool = Field(..., description="Whether all predictions were successful")


# ==================== Model Loading ====================

class ModelManager:
    """Manager for loading and using the trained model."""
    
    def __init__(self, model_dir: str = "models"):
        """Initialize the model manager and load artifacts."""
        self.model_dir = model_dir
        self.model = None
        self.scaler = None
        self.features = None
        self.label_encoders = None
        self._load_artifacts()
    
    def _load_artifacts(self):
        """Load model and preprocessing artifacts."""
        try:
            # Try loading from relative path first (for local testing)
            if os.path.exists(self.model_dir):
                model_path = os.path.join(self.model_dir, 'best_model.pkl')
            else:
                # Try parent directory path (for when running from API folder)
                model_path = os.path.join('..', 'linear_regression', 'models', 'best_model.pkl')
                self.model_dir = os.path.dirname(model_path)
            
            self.model = joblib.load(model_path)
            scaler_path = os.path.join(self.model_dir, 'scaler.pkl')
            self.scaler = joblib.load(scaler_path)
            
            features_path = os.path.join(self.model_dir, 'features.pkl')
            self.features = joblib.load(features_path)
            
            encoders_path = os.path.join(self.model_dir, 'label_encoders.pkl')
            self.label_encoders = joblib.load(encoders_path)
            
            print(f"✓ Model artifacts loaded successfully from {self.model_dir}")
        except Exception as e:
            print(f"⚠ Warning: Could not load model artifacts: {e}")
            print("API will attempt to load models on first request")
    
    def preprocess_input(self, data: PatientData) -> np.ndarray:
        """
        Preprocess input data for prediction.
        
        Args:
            data: PatientData input
            
        Returns:
            np.ndarray: Scaled features
        """
        # Convert input to dictionary with correct column names
        input_dict = {
            'Age': data.age,
            'Menstrual_Irregularity': data.menstrual_irregularity,
            'Chronic_Pain_Level': data.chronic_pain_level,
            'Hormone_Level_Abnormality': data.hormone_level_abnormality,
            'Infertility': data.infertility,
            'BMI': data.bmi
        }
        
        # Create DataFrame with correct column order
        df = pd.DataFrame([input_dict])
        
        # Ensure columns are in the same order as training data
        df = df[self.features]
        
        # Scale the features
        scaled_data = self.scaler.transform(df)
        
        return scaled_data
    
    def predict(self, data: PatientData) -> tuple:
        """
        Make a prediction for a single patient.
        
        Args:
            data: PatientData input
            
        Returns:
            tuple: (prediction, confidence_level)
        """
        if self.model is None:
            raise HTTPException(
                status_code=503,
                detail="Model is not loaded. Please check server logs."
            )
        
        # Preprocess input
        scaled_data = self.preprocess_input(data)
        
        # Make prediction
        prediction = self.model.predict(scaled_data)[0]
        
        # Clip prediction to valid range [0, 1]
        prediction = max(0.0, min(1.0, prediction))
        
        # Determine confidence level
        if prediction < 0.33:
            confidence = "Low"
        elif prediction < 0.67:
            confidence = "Medium"
        else:
            confidence = "High"
        
        return prediction, confidence


# Initialize model manager
try:
    model_manager = ModelManager(model_dir="models")
except Exception as e:
    print(f"Error initializing model manager: {e}")
    model_manager = None


# ==================== API Endpoints ====================

@app.get("/", tags=["Health Check"])
def read_root():
    """Root endpoint - Health check."""
    return {
        "status": "online",
        "message": "Endometriosis Prediction API is running",
        "docs_url": "/docs",
        "openapi_url": "/openapi.json"
    }


@app.get("/health", tags=["Health Check"])
def health_check():
    """Health check endpoint."""
    return {
        "status": "healthy",
        "model_loaded": model_manager.model is not None if model_manager else False,
        "service": "Endometriosis Prediction API"
    }


@app.post("/predict", response_model=PredictionResponse, tags=["Predictions"])
def predict_single(patient: PatientData):
    """
    Make a prediction for a single patient.
    
    Args:
        patient: Patient data containing all required features
        
    Returns:
        PredictionResponse: Prediction probability and confidence level
        
    Example:
        {
            "age": 32,
            "menstrual_irregularity": 1,
            "chronic_pain_level": 6.5,
            "hormone_level_abnormality": 1,
            "infertility": 0,
            "bmi": 23.5
        }
    """
    try:
        if model_manager is None or model_manager.model is None:
            raise HTTPException(
                status_code=503,
                detail="Model is not available. Please contact administrator."
            )
        
        # Make prediction
        prediction, confidence = model_manager.predict(patient)
        
        # Create response
        response = PredictionResponse(
            prediction=round(prediction, 4),
            confidence=confidence,
            input_data={
                "age": patient.age,
                "menstrual_irregularity": patient.menstrual_irregularity,
                "chronic_pain_level": patient.chronic_pain_level,
                "hormone_level_abnormality": patient.hormone_level_abnormality,
                "infertility": patient.infertility,
                "bmi": patient.bmi
            }
        )
        
        return response
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error during prediction: {str(e)}"
        )


@app.post("/predict_batch", response_model=BatchPredictionResponse, tags=["Predictions"])
def predict_batch(request: BatchPredictionRequest):
    """
    Make predictions for multiple patients.
    
    Args:
        request: BatchPredictionRequest containing list of patients
        
    Returns:
        BatchPredictionResponse: List of predictions for all patients
    """
    try:
        if model_manager is None or model_manager.model is None:
            raise HTTPException(
                status_code=503,
                detail="Model is not available. Please contact administrator."
            )
        
        predictions = []
        
        for idx, patient in enumerate(request.patients):
            try:
                prediction, confidence = model_manager.predict(patient)
                predictions.append({
                    "patient_id": idx + 1,
                    "prediction": round(prediction, 4),
                    "confidence": confidence,
                    "status": "success"
                })
            except Exception as e:
                predictions.append({
                    "patient_id": idx + 1,
                    "prediction": None,
                    "confidence": None,
                    "status": "error",
                    "error": str(e)
                })
        
        response = BatchPredictionResponse(
            predictions=predictions,
            total_processed=len(request.patients),
            success=all(p["status"] == "success" for p in predictions)
        )
        
        return response
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error during batch prediction: {str(e)}"
        )


@app.get("/model-info", tags=["Model Information"])
def get_model_info():
    """Get information about the trained model."""
    return {
        "model_type": "Linear Regression with Gradient Descent",
        "algorithm": "SGDRegressor",
        "dataset": "Endometriosis Dataset",
        "features": model_manager.features if model_manager else None,
        "model_loaded": model_manager.model is not None if model_manager else False,
        "features_count": len(model_manager.features) if model_manager and model_manager.features else 0
    }


# ==================== Error Handlers ====================

@app.exception_handler(ValueError)
async def value_error_handler(request, exc):
    """Handle validation errors."""
    return {
        "error": "Validation Error",
        "detail": str(exc),
        "status_code": 400
    }


if __name__ == "__main__":
    import uvicorn
    print("\n" + "="*60)
    print(" Starting Endometriosis Prediction API Server")
    print("="*60)
    print(" Local access: http://localhost:8000")
    print(" Android emulator: http://10.0.2.2:8000")
    print(" Network access: http://0.0.0.0:8000")
    print(" Swagger UI: http://localhost:8000/docs")
    print("="*60 + "\n")
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=False
    )
