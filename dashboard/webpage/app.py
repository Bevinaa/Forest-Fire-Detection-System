from flask import Flask, render_template, jsonify
from flask_cors import CORS
import mysql.connector
import webbrowser
import threading
import time

app = Flask(__name__)
CORS(app)

# Database connection
db_config = {
    "host": "localhost",
    "user": "root",   
    "password": "system", 
    "database": "iot_sensor_readings"
}

def get_sensor_data():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM sensor_readings ORDER BY timestamp")  
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return data
    except mysql.connector.Error as e:
        print("Database Error:", e)
        return []

def get_latest_sensor_data():
    conn = mysql.connector.connect(host="localhost", user="root", password="system", database="iot_sensor_readings")
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT temperature, humidity, smoke, fire_predicted FROM sensor_readings ORDER BY timestamp DESC LIMIT 1")
    data = cursor.fetchone()
    
    cursor.close()
    conn.close()
    
    return data if data else {"temperature": "--", "humidity": "--", "smoke": "--", "fire_predicted": "--"}

@app.route('/get-latest-sensor-data')
def latest_sensor_data():
    return jsonify(get_latest_sensor_data())

@app.route('/api/sensor_data')
def sensor_data():
    return jsonify(get_sensor_data())

@app.route('/api/history')
def history():
    return jsonify(get_sensor_data())

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/history.html')
def history_page():
    return render_template('history.html')

if __name__ == "__main__":
    app.run(debug=True)