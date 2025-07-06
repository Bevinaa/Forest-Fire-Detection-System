#include <DHT.h>

#define DHTPIN 2        // Pin connected to DHT11 (Data Pin)
#define DHTTYPE DHT11   // Define DHT11 type

#define MQ2_PIN A0      // Analog pin A0 connected to MQ-2 smoke sensor

DHT dht(DHTPIN, DHTTYPE);  // Initialize DHT11 sensor

void setup() {
  Serial.begin(9600);  // Start Serial communication
  dht.begin();         // Initialize DHT11 sensor
  delay(2000);         // Wait for sensor to stabilize
}

void loop() {
  // Read temperature and humidity from DHT11 sensor
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  // Read analog value from MQ-2 smoke sensor
  int smokeValue = analogRead(MQ2_PIN);

  // Check if DHT11 readings are valid
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("❌ Failed to read from DHT11 sensor!");
  } else {
    Serial.print("Temp: ");
    Serial.print(temperature);
    Serial.print("°C  |   Humidity: ");
    Serial.print(humidity);
    Serial.println(" %");
  }

  // Print smoke sensor value
  Serial.print("Smoke/Gas Level: ");
  Serial.println(smokeValue);  // Smoke value (0–1023)

  // You can add a threshold to trigger an alert based on the smoke value
  if (smokeValue > 400) {
    Serial.println("Smoke detected!");
  }

  delay(2000);  // Wait 2 seconds before reading again
}