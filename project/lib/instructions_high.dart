import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest Fire Detection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: InstructionsMediumPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InstructionsMediumPage extends StatefulWidget {
  @override
  State<InstructionsMediumPage> createState() => _InstructionsMediumPageState();
}

class _InstructionsMediumPageState extends State<InstructionsMediumPage> {
  List<String> safetyInstructions = [
    "Stay calm and do not panic.",
    "Evacuate immediately if advised by authorities.",
    "Cover your nose and mouth with a damp cloth.",
    "Avoid flammable materials and move to a safe zone.",
    "Keep emergency contacts saved in your phone",
    "Prepare an emergency kit with essentials like water, food, flashlight, and first-aid.",
    "Identify multiple evacuation routes from your location.",
  ];

  bool isAlertVisible = true;
  String button1Text = "ALERT NEARBY RESIDENTS";
  String button2Text = "ALERT NEARBY FIRE STATION";
  List<String> residentNumbers = [];
  TextEditingController instructionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchResidentNumbers();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        isAlertVisible = !isAlertVisible;
      });
    });
  }

  // Fetch resident phone numbers from the database
  Future<void> fetchResidentNumbers() async {
    final String apiUrl = "http://127.0.0.1:5000/residents"; // Flask API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          residentNumbers = data.map((res) => res['phone'].toString()).toList();
        });
      } else {
        print("Failed to fetch residents: ${response.body}");
      }
    } catch (e) {
      print("Error fetching residents: $e");
    }
  }

  // Send SMS alert via Flask backend
  Future<void> sendAlert1() async {
    final String apiUrl = "http://127.0.0.1:5000/send_alert_residents";
    if (residentNumbers.isEmpty) {
      print("No residents found to alert.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone_numbers": residentNumbers}),
      );

      if (response.statusCode == 200) {
        setState(() {
          button1Text = "Nearby residents alerted successfully";
        });
      } else {
        print("Failed to send alert: ${response.body}");
      }
    } catch (e) {
      print("Error sending alert: $e");
    }
  }

  Future<void> sendAlert2() async {
    final String apiUrl = "http://127.0.0.1:5000/send_alert_fs";
    if (residentNumbers.isEmpty) {
      print("No residents found to alert.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone_numbers": residentNumbers}),
      );

      if (response.statusCode == 200) {
        setState(() {
          button2Text = "Nearby fire station alerted successfully";
        });
      } else {
        print("Failed to send alert: ${response.body}");
      }
    } catch (e) {
      print("Error sending alert: $e");
    }
  }

  // Add custom instruction
  void addInstruction() {
    if (instructionController.text.isNotEmpty) {
      setState(() {
        safetyInstructions.add(instructionController.text);
      });
      instructionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Text(
          'Instructions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Forest Fire Safety Guidelines as advised by Emergency services",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: safetyInstructions.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.red),
                    title: Text(
                      safetyInstructions[index],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),

          // Add Your Own Instruction
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: instructionController,
                    decoration: InputDecoration(
                      hintText: "Add your own instruction...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green, size: 36),
                  onPressed: addInstruction,
                ),
              ],
            ),
          ),

          // ALERT Button (Animated)
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: isAlertVisible ? 1.0 : 0.4,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: sendAlert1,
                child: Text(
                  button1Text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: isAlertVisible ? 1.0 : 0.4,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: sendAlert2,
                child: Text(
                  button2Text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
