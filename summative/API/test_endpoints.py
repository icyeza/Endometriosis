"""
Test script for Endometriosis Prediction API endpoints
"""
import json
import subprocess
import time
import sys

def print_section(title):
    """Print a formatted section header"""
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}\n")

def test_endpoints():
    """Test all API endpoints"""
    base_url = "http://127.0.0.1:8000"
    
    print_section("TESTING API ENDPOINTS")
    
    # Test 1: Health Check
    print_section("Test 1: Health Check (/health)")
    try:
        result = subprocess.run(
            ['powershell', '-Command', 
             f'$ProgressPreference = "SilentlyContinue"; (curl -s {base_url}/health).Content | ConvertFrom-Json | ConvertTo-Json -Depth 10'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            print("✅ Health check endpoint working")
            print("Response:")
            print(result.stdout)
        else:
            print("❌ Health check failed")
            print(result.stderr)
    except Exception as e:
        print(f"❌ Error testing health endpoint: {e}")
    
    # Test 2: Model Info
    print_section("Test 2: Model Info (/model-info)")
    try:
        result = subprocess.run(
            ['powershell', '-Command', 
             f'$ProgressPreference = "SilentlyContinue"; (curl -s {base_url}/model-info).Content | ConvertFrom-Json | ConvertTo-Json -Depth 10'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            print("✅ Model info endpoint working")
            print("Response:")
            print(result.stdout)
        else:
            print("❌ Model info failed")
            print(result.stderr)
    except Exception as e:
        print(f"❌ Error testing model-info endpoint: {e}")
    
    # Test 3: Single Prediction
    print_section("Test 3: Single Prediction (/predict)")
    try:
        test_data = {
            "age": 32,
            "menstrual_irregularity": 1,
            "chronic_pain_level": 6.5,
            "hormone_level_abnormality": 1,
            "infertility": 0,
            "bmi": 23.5
        }
        
        json_data = json.dumps(test_data)
        
        result = subprocess.run(
            ['powershell', '-Command', 
             f'''$body = '{json_data}' | ConvertFrom-Json | ConvertTo-Json -Compress
$ProgressPreference = "SilentlyContinue"
$response = curl -s -X POST {base_url}/predict `
  -H "Content-Type: application/json" `
  -d ($body | ConvertTo-Json -Compress)
$response | ConvertFrom-Json | ConvertTo-Json -Depth 10'''],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            print("✅ Prediction endpoint working")
            print("Input Data:")
            print(json.dumps(test_data, indent=2))
            print("\nResponse:")
            print(result.stdout)
        else:
            print("❌ Prediction failed")
            print(result.stderr)
    except Exception as e:
        print(f"❌ Error testing predict endpoint: {e}")
    
    print_section("TESTING COMPLETE")
    print("✅ All endpoint tests completed!\n")

if __name__ == "__main__":
    # Wait a moment for API to be ready
    time.sleep(2)
    test_endpoints()
