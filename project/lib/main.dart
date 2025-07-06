import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'instructions_high.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fire Icon Scale Animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 0.9, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // 5-Second Delay Before Navigating
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FireAnalysisScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark Theme Background
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.red.shade900, Colors.orange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Centered Fire Icon with Animation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.7),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [Colors.orangeAccent, Colors.redAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                // App Name with Animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(seconds: 3),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Text(
                        "Forest Fire Detection Application",
                        style: TextStyle(
                          fontFamily: "monospace",
                          fontSize: 50,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} // SPLASHHHHHHH

// Fire Analysis Screen
class FireAnalysisScreen extends StatefulWidget {
  const FireAnalysisScreen({super.key});

  @override
  _FireAnalysisScreenState createState() => _FireAnalysisScreenState();
}

class _FireAnalysisScreenState extends State<FireAnalysisScreen> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get Current Location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Text(
          'Forest Fire Analysis',
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
              ),
              child: Text(
                "Menu",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                tileColor: Colors.transparent, // Prevents default color
                leading: Icon(Icons.bar_chart, color: Colors.white),

                title: Text(
                  "View Stats",
                  style: TextStyle(
                    color: Colors.white, // Ensures white text
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),

          // View Stats Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DashboardScreen()), // Navigate to DashboardScreen
              );
            },
            icon: Icon(Icons.bar_chart, color: Colors.white),
            label: Text(
              "View Stats",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          SizedBox(height: 60),

          // Latitude and Longitude Information
          Expanded(
            flex: 1,
            child: Wrap(
              spacing: 40, // Space between latitude & longitude
              runSpacing: 10, // Space if wrapped to next line
              children: [
                GestureDetector(
                  onTap: () {
                    // Add any interactive functionality here
                  },
                  child: Chip(
                    avatar: Icon(Icons.location_on, color: Colors.white),
                    label: Text(
                      "Latitude: ${_currentPosition?.latitude ?? 'Fetching...'}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.orange.shade200,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Add any interactive functionality here
                  },
                  child: Chip(
                    avatar: Icon(Icons.map, color: Colors.white),
                    label: Text(
                      "Longitude: ${_currentPosition?.longitude ?? 'Fetching...'}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.orange.shade200,
                  ),
                ),
              ],
            ),
          ),
          // Map Section
          Expanded(
            flex: 2,
            child: _currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      initialZoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(_currentPosition!.latitude,
                                _currentPosition!.longitude),
                            width: 40,
                            height: 40,
                            child: Icon(Icons.location_pin,
                                color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
} // MAPSSS AND LATTILONGII PAGE

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLoading = true;
  late MapController mapController;
  double temperature = 0.0;
  double humidity = 0.0;
  double smoke = 0.0;
  int fire_predicted = 0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getCurrentLocation();
    _fetchSensorData();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permission permanently denied');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      isLoading = false;
    });

    mapController.move(LatLng(latitude, longitude), 15);
  }

  Future<void> _fetchSensorData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5000/latest-reading'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = double.tryParse(data['temperature'].toString()) ?? 0.0;
          humidity = double.tryParse(data['humidity'].toString()) ?? 0.0;
          smoke = double.tryParse(data['smoke'].toString()) ?? 0.0;
          fire_predicted = int.tryParse(data['fire_predicted'].toString()) ?? 0;
          checkForestFire(context, fire_predicted);
        });
      } else {
        debugPrint('Failed to load sensor data');
      }
    } catch (e) {
      debugPrint('Error fetching sensor data: $e');
    }
  }

  Widget _buildGauge(String label, double value, double maxValue, Color color) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: maxValue,
          startAngle: 180,
          endAngle: 0,
          showTicks: false,
          showLabels: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            thicknessUnit: GaugeSizeUnit.factor,
            color: color.withOpacity(0.3),
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: value,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              color: color,
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${value.toStringAsFixed(1)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              angle: 90,
              positionFactor: 0.1,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          // Top half: Map
          Expanded(
            flex: 1,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(latitude, longitude),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(latitude, longitude),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bottom half: Gauges
          const SizedBox(height: 30),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildGauge(
                        'Temperature', temperature, 100, Colors.red),
                  ),
                  Expanded(
                    child: _buildGauge('Humidity', humidity, 100, Colors.blue),
                  ),
                  Expanded(
                    child: _buildGauge('Smoke', smoke, 100, Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularGauge extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;

  const CircularGauge({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: min,
            maximum: max,
            showLabels: false,
            showTicks: false,
            axisLineStyle: const AxisLineStyle(
              thickness: 15,
              cornerStyle: CornerStyle.bothCurve,
              color: Colors.black,
            ),
            pointers: [
              NeedlePointer(
                value: value,
                needleColor: Colors.orange,
                needleLength: 0.8,
                needleStartWidth: 1,
                needleEndWidth: 5,
                knobStyle: const KnobStyle(
                  color: Color.fromARGB(255, 241, 193, 52),
                  sizeUnit: GaugeSizeUnit.factor,
                ),
              ),
            ],
            annotations: [
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value.toStringAsFixed(1) + unit,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.7,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void checkForestFire(BuildContext context, int fire_predicted) {
  String message = "";
  Color bgColor = Colors.green;
  Widget? nextPage;

  if (fire_predicted == 0) {
    message = "NO FOREST FIRE DETECTED";
    bgColor = Colors.green;
    nextPage = null; // No navigation
  } else if (fire_predicted == 1) {
    message = "FOREST FIRE DETECTED";
    bgColor = Colors.red;
    nextPage = InstructionsMediumPage(); // Navigate to InstructionsHighPage
  }

  Future.delayed(Duration(seconds: 5), () {
    BuildContext dialogContext; // Store dialog context to close later
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) {
        dialogContext = dContext;
        return AlertDialog(
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context, rootNavigator: true).pop(); // Close pop-up
      if (nextPage != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage!),
        );
      }
    });
  });
}
