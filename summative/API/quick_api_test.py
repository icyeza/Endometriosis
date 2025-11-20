#!/usr/bin/env python
"""Test API endpoints"""
import json
import urllib.request

base_url = 'http://127.0.0.1:8000'

print('\n' + '='*70)
print('  TESTING ENDOMETRIOSIS PREDICTION API')
print('='*70 + '\n')

# Test 1: Health
print('[Test 1] Health Check (/health)')
print('-'*70)
try:
    response = urllib.request.urlopen(base_url + '/health', timeout=5)
    data = json.loads(response.read())
    print('✅ Health endpoint working!')
    print('  Status: ' + data.get('status', 'unknown'))
    print('  Message: ' + data.get('message', 'no message'))
except Exception as e:
    print('❌ Error: ' + str(e))

# Test 2: Model Info
print('\n[Test 2] Model Info (/model-info)')
print('-'*70)
try:
    response = urllib.request.urlopen(base_url + '/model-info', timeout=5)
    data = json.loads(response.read())
    print('✅ Model info endpoint working!')
    print('  Model Type: ' + str(data.get('model_type', 'unknown')))
    print('  Algorithm: ' + str(data.get('algorithm', 'unknown')))
    print('  Features Count: ' + str(data.get('features_count', 'unknown')))
    print('  Model Loaded: ' + str(data.get('model_loaded', 'unknown')))
except Exception as e:
    print('❌ Error: ' + str(e))

# Test 3: Single Prediction
print('\n[Test 3] Single Prediction (/predict)')
print('-'*70)
try:
    test_data = {
        'age': 32,
        'menstrual_irregularity': 1,
        'chronic_pain_level': 6.5,
        'hormone_level_abnormality': 1,
        'infertility': 0,
        'bmi': 23.5
    }
    
    req = urllib.request.Request(
        base_url + '/predict',
        data=json.dumps(test_data).encode('utf-8'),
        headers={'Content-Type': 'application/json'},
        method='POST'
    )
    
    response = urllib.request.urlopen(req, timeout=5)
    data = json.loads(response.read())
    print('✅ Prediction endpoint working!')
    print('  Prediction Score: ' + str(data.get('prediction')))
    print('  Confidence Level: ' + str(data.get('confidence')))
except Exception as e:
    print('❌ Error: ' + str(e))

print('\n' + '='*70)
print('  ✅ ALL ENDPOINT TESTS COMPLETED!')
print('='*70 + '\n')
