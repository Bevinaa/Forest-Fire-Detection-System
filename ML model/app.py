import joblib
import mysql.connector
import numpy as np

model = joblib.load("forest_fire_model.pkl")
scaler = joblib.load("scaler.pkl")

DB_CONFIG = {
    "host": "localhost",
    "user": "root", 
    "password": "system",   
    "database": "forest_fire_readings_db"
}

def predict_fire(temperature, humidity, smoke):
    """Predicts if a fire is detected based on sensor values."""
    input_data = np.array([[temperature, humidity, smoke]])
    input_scaled = scaler.transform(input_data)
    prediction = model.predict(input_scaled)[0]
    
    result = "FIRE DETECTED" if prediction == 1 else "NO FIRE"
    print(f"Sensor Readings -> Temperature: {temperature}, Humidity: {humidity}, Smoke: {smoke}")
    print(f"Fire Prediction: {result}")
    
    return int(prediction)  

def insert_into_db(temperature, humidity, smoke, fire_prediction):
    """Inserts the sensor data and prediction into MySQL database."""
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    insert_query = """
    INSERT INTO sensor_readings (temperature, humidity, smoke, fire_prediction) 
    VALUES (%s, %s, %s, %s)
    """
    values = (temperature, humidity, smoke, fire_prediction)  # `fire_prediction` is now int

    cursor.execute(insert_query, values)
    conn.commit()
    conn.close()
    
    print("Data inserted into database successfully.")

# ---- MAIN EXECUTION ----
if __name__ == "__main__":
    temp = 50
    hum = 12
    smoke = 900

    fire_prediction = predict_fire(temp, hum, smoke)
    insert_into_db(temp, hum, smoke, fire_prediction)
