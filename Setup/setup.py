#!/usr/bin/env python3
"""
Automated setup script for Emotion Recognition System
Handles virtual environment creation and dependency installation
"""

import os
import sys
import subprocess
import platform
from pathlib import Path

class EmotionRecognitionSetup:
    def __init__(self):
        self.project_root = Path.cwd()
        self.venv_name = "emotion_env"
        self.venv_path = self.project_root / self.venv_name
        self.is_windows = platform.system() == "Windows"
        
    def print_header(self):
        """Print setup header"""
        print("=" * 60)
        print("🎯 EMOTION RECOGNITION SYSTEM - AUTOMATED SETUP")
        print("=" * 60)
        print(f"📁 Project Directory: {self.project_root}")
        print(f"🐍 Python Version: {sys.version.split()[0]}")
        print(f"💻 Operating System: {platform.system()}")
        print("=" * 60)
    
    def check_python_version(self):
        """Check if Python version is compatible"""
        version = sys.version_info
        if version.major < 3 or (version.major == 3 and version.minor < 8):
            print("❌ Error: Python 3.8 or higher is required")
            print(f"   Current version: {version.major}.{version.minor}")
            sys.exit(1)
        print(f"✅ Python version {version.major}.{version.minor} is compatible")
    
    def create_virtual_environment(self):
        """Create virtual environment"""
        print(f"\n📦 Creating virtual environment: {self.venv_name}")
        
        if self.venv_path.exists():
            print(f"⚠️  Virtual environment already exists at {self.venv_path}")
            response = input("Do you want to recreate it? (y/N): ").strip().lower()
            if response in ['y', 'yes']:
                print("🗑️  Removing existing virtual environment...")
                if self.is_windows:
                    subprocess.run(["rmdir", "/s", "/q", str(self.venv_path)], shell=True)
                else:
                    subprocess.run(["rm", "-rf", str(self.venv_path)])
            else:
                print("✅ Using existing virtual environment")
                return True
        
        try:
            print("🔨 Creating new virtual environment...")
            subprocess.run([sys.executable, "-m", "venv", str(self.venv_path)], 
                         check=True, capture_output=True, text=True)
            print("✅ Virtual environment created successfully")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to create virtual environment: {e}")
            print(f"Error output: {e.stderr}")
            return False
    
    def get_activation_command(self):
        """Get the command to activate virtual environment"""
        if self.is_windows:
            return str(self.venv_path / "Scripts" / "activate.bat")
        else:
            return f"source {self.venv_path}/bin/activate"
    
    def get_python_executable(self):
        """Get path to Python executable in virtual environment"""
        if self.is_windows:
            return str(self.venv_path / "Scripts" / "python.exe")
        else:
            return str(self.venv_path / "bin" / "python")
    
    def install_dependencies(self):
        """Install project dependencies"""
        print("\n📋 Installing project dependencies...")
        
        python_exe = self.get_python_executable()
        
        # Upgrade pip first
        print("⬆️  Upgrading pip...")
        try:
            subprocess.run([python_exe, "-m", "pip", "install", "--upgrade", "pip"], 
                         check=True, capture_output=True, text=True)
            print("✅ Pip upgraded successfully")
        except subprocess.CalledProcessError as e:
            print(f"⚠️  Warning: Failed to upgrade pip: {e}")
        
        # Install requirements
        requirements_file = self.project_root / "requirements.txt"
        if not requirements_file.exists():
            print("❌ requirements.txt not found!")
            print("Creating requirements.txt with basic dependencies...")
            self.create_requirements_file()
        
        print("📦 Installing dependencies from requirements.txt...")
        try:
            result = subprocess.run([python_exe, "-m", "pip", "install", "-r", "requirements.txt"], 
                                  check=True, capture_output=True, text=True)
            print("✅ Dependencies installed successfully")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to install dependencies: {e}")
            print(f"Error output: {e.stderr}")
            return False
    
    def create_requirements_file(self):
        """Create requirements.txt if it doesn't exist"""
        requirements_content = """# Core deep learning and computer vision
deepface==0.0.79
opencv-python==4.8.1.78
tensorflow==2.13.0

# GUI framework
tkinter-dnd2==0.3.0

# Image processing and display
Pillow==10.0.1
numpy==1.24.3

# Data visualization
matplotlib==3.7.2

# Data handling
pandas==2.0.3

# System utilities
psutil==5.9.5

# Optional: Additional face detection backends (install if needed)
# mtcnn==0.1.1
# retina-face==0.0.13

# Development dependencies (optional)
# pytest==7.4.2
# flake8==6.0.0
"""
        
        with open("requirements.txt", "w") as f:
            f.write(requirements_content)
        print("✅ Created requirements.txt")
    
    def create_local_images_directory(self):
        """Create local images directory for face database"""
        print("\n📁 Setting up face database directory...")
        
        images_dir = self.project_root / "local_images"
        if not images_dir.exists():
            images_dir.mkdir()
            print(f"✅ Created directory: {images_dir}")
            
            # Create instructions file
            instructions = """HOW TO ADD PEOPLE TO RECOGNIZE:

1. Place clear face photos in this folder
2. Name files like: john_doe.jpg, jane_smith.png, alex_johnson.jpeg
3. Use underscores for spaces in names
4. Supported formats: .jpg, .jpeg, .png, .bmp
5. One face per image works best
6. Good lighting and frontal face preferred

Examples:
- john_doe.jpg
- mary_johnson.png
- alex_smith.jpeg

After adding images, click 'Refresh Database' in the app.
"""
            with open(images_dir / "INSTRUCTIONS.txt", "w") as f:
                f.write(instructions)
            print("✅ Created setup instructions")
        else:
            print(f"✅ Directory already exists: {images_dir}")
    
    def verify_installation(self):
        """Verify that the installation was successful"""
        print("\n🔍 Verifying installation...")
        
        python_exe = self.get_python_executable()
        
        # Test key imports
        test_imports = [
            ("cv2", "OpenCV"),
            ("deepface", "DeepFace"),
            ("tensorflow", "TensorFlow"),
            ("matplotlib", "Matplotlib"),
            ("PIL", "Pillow"),
            ("numpy", "NumPy")
        ]
        
        all_good = True
        for import_name, display_name in test_imports:
            try:
                result = subprocess.run([python_exe, "-c", f"import {import_name}"], 
                                      check=True, capture_output=True, text=True)
                print(f"✅ {display_name} import successful")
            except subprocess.CalledProcessError:
                print(f"❌ {display_name} import failed")
                all_good = False
        
        return all_good
    
    def print_usage_instructions(self):
        """Print instructions for using the system"""
        print("\n" + "=" * 60)
        print("🎉 SETUP COMPLETED SUCCESSFULLY!")
        print("=" * 60)
        print("\n📋 NEXT STEPS:")
        print("1. Activate your virtual environment:")
        if self.is_windows:
            print(f"   {self.venv_name}\\Scripts\\activate")
        else:
            print(f"   source {self.venv_name}/bin/activate")
        
        print("\n2. Add face images to the local_images folder:")
        print("   - Use clear, well-lit photos")
        print("   - Name them like: john_doe.jpg, jane_smith.png")
        print("   - One face per image")
        
        print("\n3. Run the application:")
        print("   python emotion_recognition_system.py")
        
        print("\n4. In the application:")
        print("   - Click 'Start Camera' to begin")
        print("   - Click 'Refresh Database' after adding new images")
        print("   - Use '📸 Save New Face' to add faces during runtime")
        
        print("\n🔧 TROUBLESHOOTING:")
        print("   - If camera doesn't work, check permissions")
        print("   - If recognition is poor, add more/better photos")
        print("   - Check README.md for detailed documentation")
        
        print("\n📖 DOCUMENTATION:")
        print("   - README.md: Setup and user guide")
        print("   - DOCUMENTATION.md: Technical details")
        
        print("\n" + "=" * 60)
    
    def run_setup(self):
        """Run the complete setup process"""
        self.print_header()
        
        # Check Python version
        self.check_python_version()
        
        # Create virtual environment
        if not self.create_virtual_environment():
            print("❌ Setup failed at virtual environment creation")
            sys.exit(1)
        
        # Install dependencies
        if not self.install_dependencies():
            print("❌ Setup failed at dependency installation")
            sys.exit(1)
        
        # Create directories
        self.create_local_images_directory()
        
        # Verify installation
        if not self.verify_installation():
            print("⚠️  Setup completed with some issues")
            print("   Some dependencies may not have installed correctly")
            print("   Check the error messages above")
        
        # Print usage instructions
        self.print_usage_instructions()

def main():
    """Main setup function"""
    try:
        setup = EmotionRecognitionSetup()
        setup.run_setup()
    except KeyboardInterrupt:
        print("\n\n⚠️  Setup interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Setup failed with error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
