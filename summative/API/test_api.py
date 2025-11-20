"""
Test script for the Endometriosis Prediction API
"""

import requests
import json
import time

BASE_URL = "http://localhost:8000"

def test_health():
    """Test health endpoint"""
    print("=" * 60)
    print("Testing Health Endpoint")
    print("=" * 60)
    try:
        response = requests.get(f"{BASE_URL}/health")
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    print()

def test_single_prediction():
    """Test single prediction endpoint"""
    print("=" * 60)
    print("Testing Single Prediction Endpoint")
    print("=" * 60)
    
    patient_data = {
        "age": 32,
        "menstrual_irregularity": 1,
        "chronic_pain_level": 6.5,
        "hormone_level_abnormality": 1,
        "infertility": 0,
        "bmi": 23.5
    }
    
    try:
        print(f"Request Data: {json.dumps(patient_data, indent=2)}")
        response = requests.post(f"{BASE_URL}/predict", json=patient_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    print()

def test_batch_prediction():
    """Test batch prediction endpoint"""
    print("=" * 60)
    print("Testing Batch Prediction Endpoint")
    print("=" * 60)
    
    batch_data = {
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
            },
            {
                "age": 28,
                "menstrual_irregularity": 0,
                "chronic_pain_level": 2.1,
                "hormone_level_abnormality": 0,
                "infertility": 0,
                "bmi": 21.5
            }
        ]
    }
    
    try:
        print(f"Request: Batch of {len(batch_data['patients'])} patients")
        response = requests.post(f"{BASE_URL}/predict_batch", json=batch_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    print()

def test_invalid_input():
    """Test with invalid input to verify validation"""
    print("=" * 60)
    print("Testing Input Validation (Invalid Age)")
    print("=" * 60)
    
    invalid_data = {
        "age": 150,  # Out of range (max 100)
        "menstrual_irregularity": 1,
        "chronic_pain_level": 6.5,
        "hormone_level_abnormality": 1,
        "infertility": 0,
        "bmi": 23.5
    }
    
    try:
        print(f"Request Data (Invalid): {json.dumps(invalid_data, indent=2)}")
        response = requests.post(f"{BASE_URL}/predict", json=invalid_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    print()

def test_model_info():
    """Test model info endpoint"""
    print("=" * 60)
    print("Testing Model Information Endpoint")
    print("=" * 60)
    try:
        response = requests.get(f"{BASE_URL}/model-info")
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    print()

def main():
    """Run all tests"""
    print("\n")
    print("#" * 60)
    print("# ENDOMETRIOSIS PREDICTION API - TEST SUITE")
    print("#" * 60)
    print()
    
    # Wait for server to be ready
    max_retries = 5
    for i in range(max_retries):
        try:
            requests.get(f"{BASE_URL}/health", timeout=2)
            break
        except:
            if i < max_retries - 1:
                print("Waiting for server to start...")
                time.sleep(2)
            else:
                print("Server did not start in time. Please check if the API is running.")
                return
    
    # Run tests
    test_health()
    test_model_info()
    test_single_prediction()
    test_batch_prediction()
    test_invalid_input()
    
    print("=" * 60)
    print("API Testing Complete!")
    print("=" * 60)
    print("\nAccess Swagger UI: http://localhost:8000/docs")
    print("Access ReDoc: http://localhost:8000/redoc")
    print()

if __name__ == "__main__":
    main()
