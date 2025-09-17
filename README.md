# Real-Time Emotion and Identity Recognition System

A comprehensive real-time face recognition system that detects emotions, identifies people, tracks mood scores, and visualizes emotional states using a Valence-Arousal graph.

## Features

- **Real-time face detection and recognition**
- **Emotion analysis** with 7 basic emotions (happy, sad, angry, fear, surprise, disgust, neutral)
- **Identity recognition** using a local database of face images
- **Mood score tracking** (-100 to +100 scale)
- **Valence-Arousal visualization** showing emotional positions in 2D space
- **Live mood graphing** with historical data
- **Easy face database management** with GUI controls

## Demo
<img width="1919" height="1069" alt="image" src="https://github.com/user-attachments/assets/89c09b8f-7c66-4e17-be61-5bdcdbdef75c" />

*Real-time emotion detection with mood tracking and valence-arousal visualization*

## Requirements

- Python 3.8 or higher
- Webcam/Camera
- Windows/macOS/Linux

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/emotion-recognition-system.git
cd emotion-recognition-system
```

### 2. Set Up Virtual Environment

#### On Windows:
```bash
# Create virtual environment
python -m venv emotion_env

# Activate virtual environment
emotion_env\Scripts\activate

# Verify activation (should show path to your venv)
where python
```

#### On macOS/Linux:
```bash
# Create virtual environment
python3 -m venv emotion_env

# Activate virtual environment
source emotion_env/bin/activate

# Verify activation (should show path to your venv)
which python
```

### 3. Install Dependencies

```bash
# Upgrade pip first
python -m pip install --upgrade pip

# Install all requirements
pip install -r requirements.txt
```

### 4. Set Up Face Database

```bash
# Create the local images directory (if it doesn't exist)
mkdir local_images

# Add face images to the local_images folder
# Name them like: john_doe.jpg, jane_smith.png
```

### 5. Run the Application

```bash
python emotion_recognition_system.py
```

## Detailed Setup Guide

### Virtual Environment Setup

A virtual environment isolates your project dependencies from your system Python installation.

#### Why Use Virtual Environments?

- **Dependency Isolation**: Prevents conflicts between project dependencies
- **Version Control**: Maintain specific package versions for your project
- **Clean Development**: Easy to reset or recreate environment
- **Deployment**: Ensures consistent environments across different systems

#### Step-by-Step Virtual Environment Creation

1. **Navigate to your project directory:**
   ```bash
   cd path/to/your/emotion-recognition-system
   ```

2. **Create the virtual environment:**
   ```bash
   # Windows
   python -m venv emotion_env
   
   # macOS/Linux
   python3 -m venv emotion_env
   ```

3. **Activate the virtual environment:**
   ```bash
   # Windows Command Prompt
   emotion_env\Scripts\activate
   
   # Windows PowerShell
   emotion_env\Scripts\Activate.ps1
   
   # macOS/Linux
   source emotion_env/bin/activate
   ```

4. **Verify activation:**
   Your command prompt should now show `(emotion_env)` at the beginning:
   ```bash
   (emotion_env) C:\your\project\path>
   ```

5. **Upgrade pip:**
   ```bash
   python -m pip install --upgrade pip
   ```

6. **Install project dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

### Deactivating Virtual Environment

When you're done working on the project:

```bash
deactivate
```

### Recreating the Environment

If something goes wrong with your environment:

```bash
# Remove the old environment
rm -rf emotion_env  # macOS/Linux
rmdir /s emotion_env  # Windows

# Create and set up new environment
python -m venv emotion_env
source emotion_env/bin/activate  # or emotion_env\Scripts\activate on Windows
pip install -r requirements.txt
```

## Face Database Setup

### Adding Known Faces

1. **Open the images folder:**
   - Click "Open Images Folder" in the application, or
   - Navigate to the `local_images` directory in your project folder

2. **Add face photos:**
   - Use clear, well-lit photos
   - One face per image
   - Frontal view works best
   - Supported formats: .jpg, .jpeg, .png, .bmp

3. **Name your files correctly:**
   ```
   john_doe.jpg
   jane_smith.png
   alex_johnson.jpeg
   mary_williams.jpg
   ```
   - Use underscores instead of spaces
   - The filename becomes the person's display name

4. **Refresh the database:**
   - Click "Refresh Database" in the application
   - The system will load all faces and show count in the interface

### Using the Save Face Feature

1. Start the camera
2. Position the person in front of the camera
3. Click "📸 Save New Face" button
4. Enter the person's name when prompted
5. If multiple faces are detected, select which one to save
6. The face will be automatically added to your database

## Usage Guide

### Starting the System

1. **Launch the application:**
   ```bash
   python emotion_recognition_system.py
   ```

2. **Start camera feed:**
   - Click "Start Camera" button
   - Grant camera permissions if prompted

3. **Monitor results:**
   - View live video feed with face detection boxes
   - Check emotion analysis in the Detection panel
   - Monitor mood scores in real-time graph
   - Observe emotional positions on Valence-Arousal plot

### Understanding the Interface

#### Video Feed (Top Left)
- Live camera feed with face detection rectangles
- Shows person name, dominant emotion, and mood score overlay

#### Detection Panel (Bottom Left)
- Database status and loaded faces
- Current detections with detailed emotion breakdown
- Mood scores and age estimates

#### Valence-Arousal Graph (Bottom Center)
- 2D emotional space visualization
- X-axis: Valence (negative ← → positive)
- Y-axis: Arousal (low ← → high)
- Shows current emotional positions for detected faces

#### Mood Score Graph (Right Panel)
- Real-time mood tracking over time
- Scale: -100 (worst) to +100 (best)
- Historical data for up to 60 seconds
- Color-coded lines for different people

### Interpreting Results

#### Emotion Categories
- **Happy**: Joy, contentment, amusement
- **Sad**: Sorrow, melancholy, disappointment
- **Angry**: Frustration, irritation, rage
- **Fear**: Anxiety, worry, apprehension
- **Surprise**: Shock, amazement, unexpected reaction
- **Disgust**: Revulsion, distaste, aversion
- **Neutral**: Calm, composed, no strong emotion

#### Mood Score Calculation
- **+100 to +50**: Very happy/positive state
- **+50 to +20**: Happy/good mood
- **+20 to -20**: Neutral mood
- **-20 to -50**: Sad/negative mood
- **-50 to -100**: Very sad/depressed state

#### Valence-Arousal Quadrants
- **Top Right**: High arousal, positive emotions (excitement, joy)
- **Top Left**: High arousal, negative emotions (anger, fear)
- **Bottom Right**: Low arousal, positive emotions (calm happiness)
- **Bottom Left**: Low arousal, negative emotions (sadness, depression)

## Troubleshooting

### Common Issues

#### "DeepFace not available" Error
```bash
# Reinstall DeepFace
pip uninstall deepface
pip install deepface==0.0.79
```

#### Camera Not Working
- Check if another application is using the camera
- Try different camera indices in the code (change `cv2.VideoCapture(0)` to `cv2.VideoCapture(1)`)
- Ensure camera permissions are granted

#### Poor Recognition Accuracy
- Use high-quality, well-lit photos for the database
- Ensure faces are clearly visible and frontal
- Add multiple photos of the same person from different angles
- Clean the camera lens

#### Performance Issues
- Close other applications using the camera
- Reduce the analysis frequency in the code
- Use a more powerful computer for better performance

### Installation Issues

#### TensorFlow Installation Problems
```bash
# For Windows with compatible GPU
pip install tensorflow-gpu==2.13.0

# For CPU-only systems
pip install tensorflow-cpu==2.13.0
```

#### OpenCV Issues
```bash
# Reinstall OpenCV
pip uninstall opencv-python
pip install opencv-python==4.8.1.78
```

#### Dependencies Conflicts
```bash
# Create fresh environment
deactivate
rm -rf emotion_env
python -m venv emotion_env
source emotion_env/bin/activate  # Windows: emotion_env\Scripts\activate
pip install -r requirements.txt
```

## Technical Documentation

### Architecture Overview

The system uses a multi-threaded architecture:
- **Video Thread**: Captures frames and updates GUI display
- **Analysis Thread**: Performs face detection and emotion analysis
- **Main GUI Thread**: Handles user interactions and updates

### Key Components

#### EmotionIdentityRecognizer Class
Main application class that coordinates all functionality.

#### Core Methods
- `analyze_frame()`: Performs face detection and emotion analysis
- `calculate_mood_score()`: Converts emotion probabilities to mood score
- `calculate_valence_arousal()`: Maps emotions to 2D emotional space
- `identify_person_from_region()`: Matches faces against local database

#### Data Storage
- `emotion_history`: Historical emotion data for graphing
- `mood_history`: Historical mood scores for tracking
- `local_face_data`: Database of known faces

### Performance Optimization

- Frame analysis runs every 1.5 seconds to balance accuracy and performance
- Video display updates at ~60 FPS for smooth user experience
- Multiple detection backends (OpenCV, MTCNN, RetinaFace) for better accuracy
- Efficient memory management with deque for historical data

### Customization Options

#### Adjusting Analysis Frequency
In `analysis_loop()` method, change:
```python
time.sleep(1.5)  # Analyze every 1.5 seconds
```

#### Modifying Mood Score Weights
In `__init__()` method, adjust:
```python
self.positive_emotions = {'happy': 1.0, 'surprise': 0.3}
self.negative_emotions = {'sad': -1.0, 'angry': -0.9, ...}
```

#### Changing Display Resolution
In `update_video_display()` method, modify:
```python
max_width, max_height = 500, 400  # Display resolution
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [DeepFace](https://github.com/serengil/deepface) for face analysis
- [OpenCV](https://opencv.org/) for computer vision
- [Matplotlib](https://matplotlib.org/) for data visualization

## Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/emotion-recognition-system/issues) page
2. Create a new issue with detailed description
3. Include error messages and system information

## Changelog

### Version 1.0.0 (Current)
- Initial release with emotion detection
- Identity recognition system
- Mood score tracking
- Valence-Arousal visualization
- Real-time graphing capabilities
