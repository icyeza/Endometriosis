import requests
import json

# Test the prediction endpoint
url = "http://localhost:8000/predict"

test_data = {
    "age": 30,
    "menstrual_irregularity": 1,
    "chronic_pain_level": 7.5,
    "hormone_level_abnormality": 1,
    "infertility": 0,
    "bmi": 24.5
}

print("Sending request to:", url)
print("Request data:", json.dumps(test_data, indent=2))

try:
    response = requests.post(url, json=test_data)
    print("\nStatus code:", response.status_code)
    print("Response:", json.dumps(response.json(), indent=2))
except Exception as e:
    print("Error:", str(e))
