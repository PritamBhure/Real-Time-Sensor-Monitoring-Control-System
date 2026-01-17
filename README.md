Here are the step-by-step instructions and content for your README.md file.
This README is written to be professional and clear, explaining exactly what the project does, how to set it up, and the technical details of how it works (MVC architecture, WebSockets, Provider).
Instructions
1.	Go to your project's root folder (the same folder where pubspec.yaml is).
2.	Create a new file named README.md.
3.	Copy the code block below and paste it into that file.
4.	Save and push to GitHub.
________________________________________
Copy This Content for README.md
Markdown
 🏭 Real-Time Industrial Sensor Monitoring System

A robust Flutter-based Industrial IoT (IIoT) Dashboard designed to monitor critical factory sensors in real-time. This system visualizes live telemetry data, detects sensor faults (offline status), and alerts operators of critical anomalies using a high-performance  WebSocket pipeline.

🚀 Project Overview

This project simulates a "Digital Control Room" where operators can monitor hundreds of industrial sensors (Temperature, Pressure, Voltage, Vibration, etc.) from a mobile device. It uses a  Python-based Simulator to generate synthetic sensor data and a Flutter App to visualise it with live charts and instant status updates.

Core Feature
| Feature | Status | Description |
| Real-Time Streaming | ✅ | Data updates at 1-10Hz frequency via WebSockets. |
| Live Visualisation | ✅ | Interactive Sparkline Charts for every sensor. |
| Health Monitoring | ✅ | Auto-detects Offline Sensors ("Signal Lost" overlay). |
| Alerting System | ✅ | Red Glow/Borders & status tags for critical threshold breaches. |
| Dashboard Analytics | ✅ | Top summary panel showing Total Sensors, Active Alerts, and Offline count. |
| Industrial UI | ✅ | Dark-mode, high-contrast interface designed for control rooms. |

---

 🏗️ System Architecture

The system follows a clean MVC (Model-View-Controller) architecture with a `Provider` for state management.

```

graph LR
    A[Python Simulator] -- JSON over WebSocket --> B(Flutter Controller);
    B -- Stream/Notify --> C{Dashboard UI};
    C -- Live Updates --> D[Sensor Cards];
    C -- Alerts --> E[Summary Header];
    
    subgraph "Backend Layer"
    A
    end
    
    subgraph "Mobile App Layer"
    B
    C
    D
    E
    end
Tech Stack
•	Frontend: Flutter (Dart)
•	State Management: Provider
•	Networking: web_socket_channel (WebSockets)
•	Visualization: fl_chart
•	Backend Simulation: Python (websockets, asyncio)
________________________________________
🛠️ Installation & Setup
Prerequisites
1.	Flutter SDK (Latest Stable Channel)
2.	Python 3.x (For the simulator)
3.	VS Code or Android Studio
4.	Android Emulator or Physical Device
Step 1: Setup the Sensor Simulator (Backend)
We use a Python script to mimic a real factory server.
1.	Open a terminal in the root project folder.
2.	Install the required Python library:
Bash
pip install websockets
3.	Run the simulator script:
Bash
python sensor_sim.py
Output: Sensor Simulator running on ws://0.0.0.0:8080
Step 2: Setup the Flutter App
1.	Open the Flutter project in your IDE.
2.	Install dependencies:
Bash
flutter pub get
3.	Configure Network (Crucial):
o	Android Emulator: Ensure core/constants/appApiConts.dart uses ws://10.0.2.2:8080.
o	iOS / Physical Device: Use your computer's local IP (e.g., ws://192.168.1.5:8080).
4.	Run the app:
Bash
flutter run
________________________________________
🔍 How It Works (Under the Hood)
1. The Data Pipeline (Python)
The sensor_sim.py script acts as a WebSocket server. Every second, it:
•	Generates random values for 6 different sensor types (TEMP, PRES, VOLT, VIBE, FLOW, HUMI).
•	Encodes this data into JSON.
•	Broadcasts it to all connected clients (the Flutter app).
2. The Listener (Flutter Controller)
The SensorController creates a persistent WebSocket connection.
•	Stream Listener: It listens for incoming messages.
•	Deserialization: Converts JSON -> SensorModel.
•	History Buffering: It keeps a list of the last 30 data points (List<FlSpot>) for the real-time chart.
•	Notification: It calls notifyListeners() to update the UI instantly.
3. The Intelligence (Business Logic)
We don't just show numbers; we analyze them.
•	Critical Checks: The app checks specific thresholds for each sensor type (e.g., Vibration > 4.0 mm/s is dangerous).
•	Heartbeat Monitor: A timer runs every 2 seconds. If a sensor hasn't sent data for >5 seconds, it is marked OFFLINE, and the UI dims with a "Signal Lost" overlay.
________________________________________
📂 Project Structure
lib/
├── controller/
│   └── provider/
│       └── sensorController.dart  # Manages WebSocket & State
├── model/
│   └── sensorModel/
│       └── sensorModel.dart       # Data structure
├── view/
│   ├── widgets/
│   │   ├── industrial_sensor_card.dart # The main UI component
│   │   └── sensor_chart.dart           # Sparkline chart widget
│   └── dashboard_view.dart             # Main screen
├── core/
│   ├── constants/
│   │   └── appApiConts.dart       # URL Configuration
│   └── utils/
│       └── checkCriticalStatus.dart # Threshold Logic
└── main.dart
________________________________________
⚠️ Troubleshooting
1. App shows "Connecting..." but no data appears.
•	Fix: Ensure the Python script is running before you start the app.
•	Fix: Check AndroidManifest.xml. You must have <uses-permission android:name="android.permission.INTERNET"/> and android:usesCleartextTraffic="true".
2. "Connection Refused" Error.
•	Fix: If using an Android Emulator, use the IP 10.0.2.2. If using a real phone, use your PC's IP address (run ipconfig or ifconfig to find it).
3. Charts look broken.
•	Fix: Ensure you are using a compatible version of fl_chart. Check pubspec.yaml for version 0.69.0 if you encounter build errors.
________________________________________
License
This project is for educational purposes as part of an Engineering Technical Assessment.

