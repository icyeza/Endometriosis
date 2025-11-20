"""
Script to copy model artifacts from linear_regression to API directory
Run this before deploying to ensure models are available
"""

import shutil
import os
from pathlib import Path

def copy_models():
    """Copy model artifacts from linear_regression/models to API/models"""
    
    # Source and destination paths
    source_dir = Path("../linear_regression/models")
    dest_dir = Path("models")
    
    # Create destination if it doesn't exist
    dest_dir.mkdir(parents=True, exist_ok=True)
    
    # Copy all files from source to destination
    if source_dir.exists():
        for file in source_dir.iterdir():
            if file.is_file():
                dest_file = dest_dir / file.name
                shutil.copy2(file, dest_file)
                print(f"✓ Copied: {file.name}")
        
        print(f"\n✓ All model artifacts copied successfully!")
        print(f"Source: {source_dir.absolute()}")
        print(f"Destination: {dest_dir.absolute()}")
        
        # List copied files
        print(f"\nFiles in {dest_dir}:")
        for file in sorted(dest_dir.iterdir()):
            size_mb = file.stat().st_size / (1024 * 1024)
            print(f"  - {file.name} ({size_mb:.2f} MB)")
    else:
        print(f"✗ Source directory not found: {source_dir}")
        print("Please ensure the linear_regression/models directory exists.")


if __name__ == "__main__":
    copy_models()
