#!/usr/bin/env python
"""
Test script for local API testing without external dependencies
"""

import json
import urllib.request
import urllib.error

def test_health():
    """Test the /health endpoint"""
    try:
        url = 'http://127.0.0.1:8000/health'
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode('utf-8'))
            print("✓ Health endpoint works:")
            print(json.dumps(data, indent=2))
            return True
    except Exception as e:
        print(f"✗ Health endpoint failed: {e}")
        return False

def test_model_info():
    """Test the /model-info endpoint"""
    try:
        url = 'http://127.0.0.1:8000/model-info'
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode('utf-8'))
            print("\n✓ Model info endpoint works:")
            print(json.dumps(data, indent=2))
            return True
    except Exception as e:
        print(f"✗ Model info endpoint failed: {e}")
        return False

def test_predict():
    """Test the /predict endpoint"""
    try:
        url = 'http://127.0.0.1:8000/predict'
        
        payload = {
            "age": 32,
            "menstrual_irregularity": 1,
            "chronic_pain_level": 6.5,
            "hormone_level_abnormality": 1,
            "infertility": 0,
            "bmi": 23.5
        }
        
        data = json.dumps(payload).encode('utf-8')
        req = urllib.request.Request(
            url,
            data=data,
            headers={'Content-Type': 'application/json'},
            method='POST'
        )
        
        with urllib.request.urlopen(req) as response:
            result = json.loads(response.read().decode('utf-8'))
            print("\n✓ Predict endpoint works:")
            print(json.dumps(result, indent=2))
            return True
    except Exception as e:
        print(f"✗ Predict endpoint failed: {e}")
        return False

if __name__ == '__main__':
    print("Testing Endometriosis API\n" + "="*50)
    
    results = []
    results.append(("Health", test_health()))
    results.append(("Model Info", test_model_info()))
    results.append(("Predict", test_predict()))
    
    print("\n" + "="*50)
    print("Test Results:")
    for name, passed in results:
        status = "✓ PASS" if passed else "✗ FAIL"
        print(f"  {status}: {name}")
    
    all_passed = all(r[1] for r in results)
    print("\n" + ("All tests passed!" if all_passed else "Some tests failed."))
