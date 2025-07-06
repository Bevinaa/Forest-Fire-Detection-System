# **Forest Fire Detection System**

![Platform](https://img.shields.io/badge/platform-IoT%20%7C%20Flutter%20%7C%20Python%20%7C%20ML-green)
![Status](https://img.shields.io/badge/status-Project%20Complete-brightgreen)

## **Overview**

This repository contains an **IoT-enabled Forest Fire Detection System** designed to monitor environmental conditions and predict fire risk in real time. It includes a **Flutter-based mobile application**, sensor data fetching using **NodeMCU**, and a basic **machine learning model - xgboost** for fire prediction.

The system monitors temperature, humidity, and smoke levels, and visualizes the data in a user-friendly mobile interface.

---

## **Key Features**

- **Real-Time Monitoring**: Tracks temperature, humidity, and smoke levels from sensors.
- **Mobile Dashboard**: Flutter app displays live data and predictions in a clean UI.
- **ML-Based Prediction**: XGBoost model trained to classify whether sensor readings indicate fire.
- **IoT Integration**: NodeMCU fetches and transmits data using Wi-Fi.
- **Database Storage**: Sensor values and predictions are stored in a MySQL database.
- **Resident Alert System**: Button in the app to notify nearby residents with safety instructions.
- **Expandable**: Future integration with AR/VR fire spread simulations and remote server dashboards.

---

## **Technologies Used**

- **Flutter**: For the mobile UI.
- **NodeMCU**: For data collection from DHT11, MQ-2 sensors, etc.
- **Python & jupyter**: For training and running the ML model.
- **MySQL**: For storing and syncing sensor data.
- **C and Arduino IDE**: For programming microcontrollers.

---

## Tech Stack

| Technology         | Purpose                                      |
|--------------------|----------------------------------------------|
| **Flutter**        | Mobile app for real-time monitoring          |
| **NodeMCU**        | IoT microcontroller for sensor interfacing   |
| **MQ-2 Sensor**    | Smoke detection                              |
| **DHT11 Sensor**   | Temperature and humidity measurement         |
| **Python**         | Machine learning model development           |
| **XGBoost**        | ML model for fire risk classification        |
| **MySQL**          | Backend database                             |
| **C (Arduino IDE)**| Microcontroller programming                  |

---

## **Pre-requisites**

To run this project, ensure you have the following installed:

- **Flutter SDK** (latest version)
- **Python 3.7+**
- **Arduino IDE** (for NodeMCU)
- **Hardware**: DHT11, MQ-2, NodeMCU, Breadboard, Jumper wires
- **Database**: MySQL account for backend data storage

---

## How It Works

1. **Sensor Layer**  
   The DHT11 and MQ-2 sensors measure environmental conditions and transmit data via NodeMCU.

2. **Data Transmission**  
   NodeMCU sends sensor readings over Wi-Fi to a backend server (or directly to the mobile app via Firebase/MySQL).

3. **Prediction Engine**  
   The ML model (XGBoost) predicts fire risk using the incoming data.

4. **User Interface**  
   A Flutter-based mobile app displays:
   - Live data (temperature, humidity, smoke)
   - Fire prediction result
   - Alert functionality for residents

---

## Machine Learning Details

- **Algorithm**: XGBoost Classifier  
- **Input Features**: Temperature, Humidity, Smoke Levels  
- **Training Dataset**: Custom collected sensor readings under fire and non-fire conditions  
- **Accuracy**: ~96.4%  
- **Evaluation Metrics**: Precision, Recall, F1-score, Confusion Matrix  

>  The model is lightweight and optimized for fast predictions on limited hardware setups.

---

| Installation and Setup |
|-----------------------------------|
| ![image](https://github.com/user-attachments/assets/3512f0df-1c7e-41f3-9852-35464a893a21) |

---

| Demo of the Project |
|-----------------------------------|
| |

---

##  Screenshots

| Mobile Application | Fire Prediction |
|------------------|-----------------|
| ![image](https://github.com/user-attachments/assets/79f30814-2d28-41da-ba58-adaac74f764b) | ![image](https://github.com/user-attachments/assets/87abae7f-878e-41f0-8307-ef5bd92bb24f) |

---

| Analytics Dashboard |
|-----------------------------------|
| ![image](https://github.com/user-attachments/assets/c23c55fe-4d2a-4251-a24c-3d87d85d7a6c) |
|![image](https://github.com/user-attachments/assets/17752d7c-3bd6-483e-bfc8-627900d74fee) |

---

