import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.1.100:5000"; // Update with Flask server IP

  static Future<void> sendAlert(Function updateButtonText) async {
    final response = await http.post(Uri.parse('$baseUrl/send_alert'));

    if (response.statusCode == 200) {
      updateButtonText("Nearby residents alerted successfully");
    } else {
      updateButtonText("Failed to send alert");
    }
  }
}
