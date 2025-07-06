# **Forest Fire Detection System**

## **Overview**

This repository contains an **IoT-enabled Forest Fire Detection System** designed to monitor environmental conditions and predict fire risk in real time. It includes a **Flutter-based mobile application**, sensor data fetching using **NodeMCU**, and a basic **machine learning model - xgboost** for fire prediction.

The system monitors temperature, humidity, and smoke levels, and visualizes the data in a user-friendly mobile interface.

---

## **Key Features**

- **Real-Time Monitoring**: Continuously fetches sensor data like temperature, humidity, and smoke levels.
- **Mobile Dashboard**: Built using Flutter for a clean and responsive user experience.
- **Machine Learning Model**: Predicts fire risk based on environmental sensor data.
- **IoT Integration**: Works with NodeMCU connected to sensors.
- **Expandable**: Structured to allow future enhancements like AR/VR visualization and push notifications.

---

## **Technologies Used**

- **Flutter**: For the mobile UI.
- **NodeMCU**: For data collection from DHT11, MQ-2 sensors, etc.
- **Python & jupyter**: For training and running the ML model.
- **MySQL**: For storing and syncing sensor data.
- **C and Arduino IDE**: For programming microcontrollers.

---

## **Pre-requisites**

To run this project, ensure you have the following installed:

- **Flutter SDK** (latest version)
- **Python 3.7+**
- **Arduino IDE** (for NodeMCU)
- **Hardware**: DHT11, MQ-2, NodeMCU, Breadboard, Jumper wires
- **Database**: MySQL account for backend data storage

---

## **Setting Up the Project**

### 1. Clone the Repository

```bash
git clone https://github.com/Bevinaa/forest-fire-detection-system.git
cd forest-fire-detection-system
