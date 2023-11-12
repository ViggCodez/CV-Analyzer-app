# CV Reimagined
<img src="/assets/images/cvrlogo.jpg" alt="Logo" width="400" height="400">

## Description

The CV Analyzer App is a powerful tool designed to streamline the analysis of resumes and CVs. Combining a Python backend for advanced natural language processing and machine learning with a Flutter frontend for a user-friendly interface, the app extracts relevant information from CVs. It provides users with valuable insights, including an overall score based on factors like impact, brevity, style, sections, and soft skills, making the hiring process more efficient.

### Key Features

- **Resume Parsing:** Quickly extract and organize key information from resumes.
- **Skill Analysis:** Identify and analyze the skills mentioned in CVs.
- **Overall Score:** Evaluate CVs based on factors like impact, brevity, style, sections, and soft skills.

## Project overview

![Video-Tutorial](assets/images/cvrtutorial.mp4)

*A tutorial/overview of CV REIMAGINED*

## Getting Started

Follow these steps to get started with the CV Analyzer App:

### Backend (Python)

1.  **Install Python Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run the Backend(Server) in app folder:**
   ```bash
   cd app
   uvicorn main:app --host 0.0.0.0 --port 8000
   uvicorn main:app --reload
   ```


### Frontend (Flutter)

1. **In line 249 in main.dart:**
   Change value of serverUrl variable to your ipv4 address and let the host be 8000 as given
   ```bash
   final String serverUrl ="http://YOUR_IPV4_ADDRESS:8000/cv/analyze";
   ```
   
   You can check your ipv4 address in cmd
   ```cmd
   ipconfig
   ```
  
2. **Install Flutter Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Frontend:**
   ```bash
   flutter run
   ```

5. Open the app on your device or emulator.

## Usage

1. Upload a CV or resume in PDF format using the Flutter app.
2. Click the "Analyze" button to initiate the analysis process.
3. The app communicates with the Python backend to analyze impact, brevity, style, sections, and soft skills.
4. View the overall score and detailed analysis.
