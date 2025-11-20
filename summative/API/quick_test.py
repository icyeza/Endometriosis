"""Quick API test"""
import requests
import json

# Test single prediction
data = {
    "age": 32,
    "menstrual_irregularity": 1,
    "chronic_pain_level": 6.5,
    "hormone_level_abnormality": 1,
    "infertility": 0,
    "bmi": 23.5
}

try:
    response = requests.post("http://localhost:8000/predict", json=data)
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
except Exception as e:
    print(f"Error: {e}")
