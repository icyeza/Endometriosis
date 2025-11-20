import joblib
import json

# Load the features
features = joblib.load('models/features.pkl')
print("Features expected by the model:")
print(json.dumps(features, indent=2))
