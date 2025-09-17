@echo off
:: Windows Batch Setup Script for Emotion Recognition System
:: Automates virtual environment creation and dependency installation

setlocal enabledelayedexpansion

echo ============================================================
echo 🎯 EMOTION RECOGNITION SYSTEM - WINDOWS SETUP
echo ============================================================
echo.

:: Check if Python is installed
echo 🔍 Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed or not in PATH
    echo    Please install Python 3.8+ from https://python.org
    pause
    exit /b 1
)

:: Display Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✅ Python %PYTHON_VERSION% found

:: Check Python version compatibility
python -c "import sys; exit(0 if sys.version_info >= (3, 8) else 1)" >nul 2>&1
if errorlevel 1 (
    echo ❌ Python 3.8 or higher is required
    echo    Current version: %PYTHON_VERSION%
    pause
    exit /b 1
)

echo ✅ Python version is compatible
echo.

:: Set variables
set VENV_NAME=emotion_env
set PROJECT_DIR=%CD%

:: Check if virtual environment already exists
if exist "%VENV_NAME%" (
    echo ⚠️ Virtual environment already exists
    set /p RECREATE="Do you want to recreate it? (y/N): "
    if /i "!RECREATE!" == "y" (
        echo 🗑️ Removing existing virtual environment...
        rmdir /s /q "%VENV_NAME%"
    ) else (
        echo ✅ Using existing virtual environment
        goto :install_deps
    )
)

:: Create virtual environment
echo 📦 Creating virtual environment: %VENV_NAME%
python -m venv "%VENV_NAME%"
if errorlevel 1 (
    echo ❌ Failed to create virtual environment
    pause
    exit /b 1
)
echo ✅ Virtual environment created successfully
echo.

:install_deps
:: Activate virtual environment and install dependencies
echo 📋 Installing dependencies...
call "%VENV_NAME%\Scripts\activate.bat"

:: Upgrade pip
echo ⬆️ Upgrading pip...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo ⚠️ Warning: Failed to upgrade pip
)

:: Check if requirements.txt exists
if not exist "requirements.txt" (
    echo ❌ requirements.txt not found!
    echo 📝 Creating requirements.txt...
    call :create_requirements
)

:: Install requirements
echo 📦 Installing dependencies from requirements.txt...
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ Failed to install some dependencies
    echo    Check the error messages above
    pause
    exit /b 1
)
echo ✅ Dependencies installed successfully
echo.

:: Create local images directory
echo 📁 Setting up face database directory...
if not exist "local_images" (
    mkdir "local_images"
    echo ✅ Created directory: local_images
    call :create_instructions
) else (
    echo ✅ Directory already exists: local_images
)
echo.

:: Verify installation
echo 🔍 Verifying installation...
call :verify_imports
echo.

:: Success message
echo ============================================================
echo 🎉 SETUP COMPLETED SUCCESSFULLY!
echo ============================================================
echo.
echo 📋 NEXT STEPS:
echo 1. Activate your virtual environment:
echo    %VENV_NAME%\Scripts\activate.bat
echo.
echo 2. Add face images to the local_images folder:
echo    - Use clear, well-lit photos
echo    - Name them like: john_doe.jpg, jane_smith.png
echo    - One face per image
echo.
echo 3. Run the application:
echo    python emotion_recognition_system.py
echo.
echo 4. In the application:
echo    - Click 'Start Camera' to begin
echo    - Click 'Refresh Database' after adding new images
echo    - Use 'Save New Face' to add faces during runtime
echo.
echo 🔧 TROUBLESHOOTING:
echo    - If camera doesn't work, check permissions
echo    - If recognition is poor, add more/better photos
echo    - Check README.md for detailed documentation
echo.
echo 📖 DOCUMENTATION:
echo    - README.md: Setup and user guide
echo    - DOCUMENTATION.md: Technical details
echo.
echo Press any key to exit...
pause >nul
goto :eof

:create_requirements
echo # Core deep learning and computer vision > requirements.txt
echo deepface==0.0.79 >> requirements.txt
echo opencv-python==4.8.1.78 >> requirements.txt
echo tensorflow==2.13.0 >> requirements.txt
echo. >> requirements.txt
echo # GUI framework >> requirements.txt
echo tkinter-dnd2==0.3.0 >> requirements.txt
echo. >> requirements.txt
echo # Image processing and display >> requirements.txt
echo Pillow==10.0.1 >> requirements.txt
echo numpy==1.24.3 >> requirements.txt
echo. >> requirements.txt
echo # Data visualization >> requirements.txt
echo matplotlib==3.7.2 >> requirements.txt
echo. >> requirements.txt
echo # Data handling >> requirements.txt
echo pandas==2.0.3 >> requirements.txt
echo. >> requirements.txt
echo # System utilities >> requirements.txt
echo psutil==5.9.5 >> requirements.txt
echo ✅ Created requirements.txt
goto :eof

:create_instructions
echo HOW TO ADD PEOPLE TO RECOGNIZE: > "local_images\INSTRUCTIONS.txt"
echo. >> "local_images\INSTRUCTIONS.txt"
echo 1. Place clear face photos in this folder >> "local_images\INSTRUCTIONS.txt"
echo 2. Name files like: john_doe.jpg, jane_smith.png, alex_johnson.jpeg >> "local_images\INSTRUCTIONS.txt"
echo 3. Use underscores for spaces in names >> "local_images\INSTRUCTIONS.txt"
echo 4. Supported formats: .jpg, .jpeg, .png, .bmp >> "local_images\INSTRUCTIONS.txt"
echo 5. One face per image works best >> "local_images\INSTRUCTIONS.txt"
echo 6. Good lighting and frontal face preferred >> "local_images\INSTRUCTIONS.txt"
echo. >> "local_images\INSTRUCTIONS.txt"
echo Examples: >> "local_images\INSTRUCTIONS.txt"
echo - john_doe.jpg >> "local_images\INSTRUCTIONS.txt"
echo - mary_johnson.png >> "local_images\INSTRUCTIONS.txt"
echo - alex_smith.jpeg >> "local_images\INSTRUCTIONS.txt"
echo. >> "local_images\INSTRUCTIONS.txt"
echo After adding images, click 'Refresh Database' in the app. >> "local_images\INSTRUCTIONS.txt"
echo ✅ Created setup instructions
goto :eof

:verify_imports
python -c "import cv2; print('✅ OpenCV import successful')" 2>nul || echo ❌ OpenCV import failed
python -c "import deepface; print('✅ DeepFace import successful')" 2>nul || echo ❌ DeepFace import failed
python -c "import tensorflow; print('✅ TensorFlow import successful')" 2>nul || echo ❌ TensorFlow import failed
python -c "import matplotlib; print('✅ Matplotlib import successful')" 2>nul || echo ❌ Matplotlib import failed
python -c "import PIL; print('✅ Pillow import successful')" 2>nul || echo ❌ Pillow import failed
python -c "import numpy; print('✅ NumPy import successful')" 2>nul || echo ❌ NumPy import failed
goto :eof
