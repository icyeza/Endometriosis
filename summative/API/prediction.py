"""
Prediction Script using the Best Trained Model
This script loads the best-performing regression model and makes predictions
on new data for the endometriosis dataset.
"""

import pandas as pd
import numpy as np
import joblib
import os
from pathlib import Path

class PredictionEngine:
    """
    A class to handle model predictions using the best-trained regression model.
    """
    
    def __init__(self, model_dir='models'):
        """
        Initialize the prediction engine by loading the model and preprocessing objects.
        
        Args:
            model_dir (str): Directory containing the saved model files
        """
        self.model_dir = model_dir
        self.model = None
        self.scaler = None
        self.features = None
        self.label_encoders = None
        
        self._load_model_artifacts()
    
    def _load_model_artifacts(self):
        """Load the saved model, scaler, and preprocessing objects."""
        try:
            # Load model
            model_path = os.path.join(self.model_dir, 'best_model.pkl')
            self.model = joblib.load(model_path)
            print(f"✓ Model loaded from: {model_path}")
            
            # Load scaler
            scaler_path = os.path.join(self.model_dir, 'scaler.pkl')
            self.scaler = joblib.load(scaler_path)
            print(f"✓ Scaler loaded from: {scaler_path}")
            
            # Load features
            features_path = os.path.join(self.model_dir, 'features.pkl')
            self.features = joblib.load(features_path)
            print(f"✓ Features loaded from: {features_path}")
            
            # Load label encoders
            encoders_path = os.path.join(self.model_dir, 'label_encoders.pkl')
            self.label_encoders = joblib.load(encoders_path)
            print(f"✓ Label encoders loaded from: {encoders_path}")
            
        except FileNotFoundError as e:
            print(f"Error: Could not find model files. {e}")
            raise
    
    def preprocess_input(self, data):
        """
        Preprocess input data to match the training data format.
        
        Args:
            data (pd.DataFrame or dict): Input data for prediction
            
        Returns:
            np.ndarray: Preprocessed and scaled features
        """
        # Convert dict to DataFrame if necessary
        if isinstance(data, dict):
            data = pd.DataFrame([data])
        elif isinstance(data, pd.DataFrame):
            data = data.copy()
        else:
            raise ValueError("Input must be a dictionary or pandas DataFrame")
        
        # Ensure all required features are present
        for feature in self.features:
            if feature not in data.columns:
                raise ValueError(f"Missing required feature: {feature}")
        
        # Select only the required features in the correct order
        data = data[self.features]
        
        # Encode categorical variables
        for col, encoder in self.label_encoders.items():
            if col in data.columns:
                try:
                    data[col] = encoder.transform(data[col].astype(str))
                except ValueError:
                    print(f"Warning: Unknown category in {col}. Using first category as default.")
                    data[col] = encoder.transform(np.full(len(data), encoder.classes_[0]))
        
        # Scale the features
        data_scaled = self.scaler.transform(data)
        
        return data_scaled
    
    def predict(self, data):
        """
        Make predictions on new data.
        
        Args:
            data (pd.DataFrame or dict): Input data for prediction
            
        Returns:
            np.ndarray: Predicted values
        """
        # Preprocess the input
        data_scaled = self.preprocess_input(data)
        
        # Make predictions
        predictions = self.model.predict(data_scaled)
        
        return predictions
    
    def predict_with_confidence(self, data):
        """
        Make predictions with additional statistics.
        
        Args:
            data (pd.DataFrame or dict): Input data for prediction
            
        Returns:
            dict: Dictionary containing predictions and additional info
        """
        predictions = self.predict(data)
        
        result = {
            'predictions': predictions,
            'num_samples': len(predictions) if isinstance(predictions, np.ndarray) else 1,
            'model_type': type(self.model).__name__
        }
        
        return result


def main():
    """
    Example usage of the PredictionEngine.
    """
    print("="*60)
    print("Regression Model Prediction Engine")
    print("="*60)
    
    # Initialize the prediction engine
    predictor = PredictionEngine(model_dir='models')
    
    # Example 1: Single prediction with a dictionary
    print("\nExample 1: Single Prediction")
    print("-"*60)
    
    # You would replace these values with actual feature values
    sample_data = {
        # Replace these with actual column names and values from your dataset
        # Example structure (adjust based on your actual features):
        # 'feature1': value1,
        # 'feature2': value2,
        # etc.
    }
    
    try:
        if sample_data:
            prediction = predictor.predict(sample_data)
            print(f"Input: {sample_data}")
            print(f"Prediction: {prediction[0]:.4f}")
        else:
            print("Note: Please populate sample_data with actual feature values.")
    except Exception as e:
        print(f"Error during prediction: {e}")
    
    # Example 2: Batch predictions from a CSV file
    print("\n\nExample 2: Batch Prediction from CSV")
    print("-"*60)
    
    csv_file = 'data_for_prediction.csv'  # Replace with your actual CSV file
    
    if os.path.exists(csv_file):
        try:
            data = pd.read_csv(csv_file)
            predictions = predictor.predict(data)
            
            # Add predictions to the dataframe
            data['predictions'] = predictions
            
            # Save results
            output_file = 'predictions_output.csv'
            data.to_csv(output_file, index=False)
            
            print(f"✓ Batch prediction completed successfully!")
            print(f"  - Input samples: {len(data)}")
            print(f"  - Output file: {output_file}")
            print(f"\nFirst 5 predictions:")
            print(data[['predictions']].head())
            
        except Exception as e:
            print(f"Error during batch prediction: {e}")
    else:
        print(f"Note: CSV file '{csv_file}' not found. Create a CSV with your data.")
    
    print("\n" + "="*60)
    print("Prediction engine ready for use!")
    print("="*60)


if __name__ == '__main__':
    main()
