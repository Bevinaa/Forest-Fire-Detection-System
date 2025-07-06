import serial
import time
import mysql.connector
import joblib
import numpy as np

# Load ML Model and Scaler
model = joblib.load('forest_fire_model.pkl')
scaler = joblib.load('scaler.pkl')

# MySQL Database connection setup
conn = mysql.connector.connect(
    host="localhost",        
    user="root",             
    password="system", 
    database="iot_sensor_readings" 
)
cursor = conn.cursor()

# Create table if not exists (added fire_predicted column)
cursor.execute('''
    CREATE TABLE IF NOT EXISTS sensor_readings (
        id INT AUTO_INCREMENT PRIMARY KEY,
        timestamp DATETIME,
        temperature FLOAT,
        humidity FLOAT,
        smoke INT,
        fire_predicted INT
    )
''')
conn.commit()

# Serial Port Setup
ser = serial.Serial('COM5', 9600)  # <-- Change COM port if needed
time.sleep(2)  # wait for Arduino to reset

# Read one set of data
line1 = ser.readline().decode('utf-8').strip()  
print(line1)

line2 = ser.readline().decode('utf-8').strip()  
print(line2)

# Extract temperature, humidity, smoke
try:
    temperature = float(line1.split('Temp:')[1].split('°C')[0].strip())
    humidity = float(line1.split('Humidity:')[1].split('%')[0].strip())
    smoke = int(line2.split('Level:')[1].strip())

    print(f"📥 Read values => Temp: {temperature}°C, Humidity: {humidity}%, Smoke: {smoke}")

    # Prepare the input for model
    input_features = np.array([[temperature, humidity, smoke]])
    input_scaled = scaler.transform(input_features)

    # Predict Fire
    fire_predicted = model.predict(input_scaled)[0]
    print(f"🔥 Fire Prediction: {fire_predicted} (1 = Fire, 0 = No Fire)")

    # Insert into database
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')

    cursor.execute('''
        INSERT INTO sensor_readings (timestamp, temperature, humidity, smoke, fire_predicted)
        VALUES (%s, %s, %s, %s, %s)
    ''', (timestamp, temperature, humidity, smoke, int(fire_predicted)))
    conn.commit()

    print("✅ One set of data with prediction inserted into MySQL database successfully!")

except Exception as e:
    print(f"❌ Error: {e}")

finally:
    ser.close()
    conn.close()
