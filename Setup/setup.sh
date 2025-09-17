#!/bin/bash
# Unix Shell Setup Script for Emotion Recognition System
# Automates virtual environment creation and dependency installation

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Print header
echo "============================================================"
echo "🎯 EMOTION RECOGNITION SYSTEM - UNIX SETUP"
echo "============================================================"
echo

# Check if Python is installed
echo "🔍 Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        print_error "Python is not installed or not in PATH"
        echo "   Please install Python 3.8+ from https://python.org"
        echo "   Or use your package manager:"
        echo "   - Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip python3-venv"
        echo "   - CentOS/RHEL: sudo yum install python3 python3-pip"
        echo "   - macOS: brew install python3"
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

# Check Python version
PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | cut -d' ' -f2)
print_status "Python $PYTHON_VERSION found"

# Check Python version compatibility
$PYTHON_CMD -c "import sys; exit(0 if sys.version_info >= (3, 8) else 1)" 2>/dev/null
if [ $? -ne 0 ]; then
    print_error "Python 3.8 or higher is required"
    echo "   Current version: $PYTHON_VERSION"
    exit 1
fi

print_status "Python version is compatible"
echo

# Set variables
VENV_NAME="emotion_env"
PROJECT_DIR=$(pwd)

# Check if virtual environment already exists
if [ -d "$VENV_NAME" ]; then
    print_warning "Virtual environment already exists"
    read -p "Do you want to recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️ Removing existing virtual environment..."
        rm -rf "$VENV_NAME"
    else
        print_status "Using existing virtual environment"
        source "$VENV_NAME/bin/activate"
        SKIP_VENV_CREATION=true
    fi
fi

# Create virtual environment
if [ -z "$SKIP_VENV_CREATION" ]; then
    echo "📦 Creating virtual environment: $VENV_NAME"
    $PYTHON_CMD -m venv "$VENV_NAME"
    if [ $? -eq 0 ]; then
        print_status "Virtual environment created successfully"
    else
        print_error "Failed to create virtual environment"
        exit 1
    fi
    
    # Activate virtual environment
    source "$VENV_NAME/bin/activate"
fi

echo

# Install dependencies
echo "📋 Installing dependencies..."

# Upgrade pip
echo "⬆️ Upgrading pip..."
python -m pip install --upgrade pip
if [ $? -eq 0 ]; then
    print_status "Pip upgraded successfully"
else
    print_warning "Failed to upgrade pip"
fi

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    print_error "requirements.txt not found!"
    echo "📝 Creating requirements.txt..."
    create_requirements_file
fi

# Install requirements
echo "📦 Installing dependencies from requirements.txt..."
pip install -r requirements.txt
if [ $? -eq 0 ]; then
    print_status "Dependencies installed successfully"
else
    print_error "Failed to install some dependencies"
    echo "   Check the error messages above"
    exit 1
fi

echo

# Create local images directory
echo "📁 Setting up face database directory..."
if [ ! -d "local_images" ]; then
    mkdir -p "local_images"
    print_status "Created directory: local_images"
    create_instructions_file
else
    print_status "Directory already exists: local_images"
fi

echo

# Function to create requirements.txt
create_requirements_file() {
    cat > requirements.txt << EOF
# Core deep learning and computer vision
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
EOF
    print_status "Created requirements.txt"
}

# Function to create instructions file
create_instructions_file() {
    cat > "local_images/INSTRUCTIONS.txt" << EOF
HOW TO ADD PEOPLE TO RECOGNIZE:

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
EOF
    print_status "Created setup instructions"
}

# Verify installation
echo "🔍 Verifying installation..."
verify_imports() {
    local imports=("cv2:OpenCV" "deepface:DeepFace" "tensorflow:TensorFlow" "matplotlib:Matplotlib" "PIL:Pillow" "numpy:NumPy")
    
    for item in "${imports[@]}"; do
        module=$(echo $item | cut -d':' -f1)
        name=$(echo $item | cut -d':' -f2)
        
        if python -c "import $module" 2>/dev/null; then
            print_status "$name import successful"
        else
            print_error "$name import failed"
        fi
    done
}

verify_imports
echo

# Success message
echo "============================================================"
echo "🎉 SETUP COMPLETED SUCCESSFULLY!"
echo "============================================================"
echo
echo "📋 NEXT STEPS:"
echo "1. Activate your virtual environment:"
echo "   source $VENV_NAME/bin/activate"
echo
echo "2. Add face images to the local_images folder:"
echo "   - Use clear, well-lit photos"
echo "   - Name them like: john_doe.jpg, jane_smith.png"
echo "   - One face per image"
echo
echo "3. Run the application:"
echo "   python emotion_recognition_system.py"
echo
echo "4. In the application:"
echo "   - Click 'Start Camera' to begin"
echo "   - Click 'Refresh Database' after adding new images"
echo "   - Use 'Save New Face' to add faces during runtime"
echo
echo "🔧 TROUBLESHOOTING:"
echo "   - If camera doesn't work, check permissions"
echo "   - If recognition is poor, add more/better photos"
echo "   - Check README.md for detailed documentation"
echo
echo "📖 DOCUMENTATION:"
echo "   - README.md: Setup and user guide"
echo "   - DOCUMENTATION.md: Technical details"
echo
echo "============================================================"

# Deactivate virtual environment
deactivate 2>/dev/null || true

echo "Setup completed! Remember to activate your virtual environment before running the application."
echo "Command: source $VENV_NAME/bin/activate"
