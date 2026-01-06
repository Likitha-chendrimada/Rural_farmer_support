import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic>? _weatherData;
  String? _lastSearchedLocation;

  @override
  void initState() {
    super.initState();
    _loadLastLocation();
  }

  Future<void> _loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocation = prefs.getString("lastLocation");
    if (savedLocation != null) {
      _fetchWeather(savedLocation);
    }
  }

  Future<void> _fetchWeather(String location) async {
    final data = await _weatherService.fetchWeatherByCity(location);
    if (data != null) {
      setState(() {
        _weatherData = data;
        _lastSearchedLocation = location;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("lastLocation", location);
    }
  }

  Color _getBackgroundColor(String condition) {
    if (condition.contains("rain")) {
      return Colors.grey.shade700;
    } else if (condition.contains("clear")) {
      return Colors.lightBlue.shade400;
    } else if (condition.contains("sun")) {
      return Colors.orange.shade400;
    } else {
      return Colors.blueGrey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: _weatherData != null
            ? _getBackgroundColor(
                _weatherData!['weather'][0]['description'])
            : Colors.blueGrey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Enter city or location",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _fetchWeather(_controller.text.trim());
                      }
                    },
                  )
                ],
              ),
            ),

            if (_weatherData == null)
              Column(
                children: const [
                  Icon(Icons.cloud, size: 120),
                  SizedBox(height: 20),
                  Text(
                    "Search for a location to view weather",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    _lastSearchedLocation ?? "",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  Image.network(
                    "https://openweathermap.org/img/wn/"
                    "${_weatherData!['weather'][0]['icon']}@2x.png",
                    width: 100,
                    height: 100,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.cloud, size: 80, color: Colors.white),
                  ),

                  Text(
                    "${_weatherData!['main']['temp']}°C",
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  Text(
                    _weatherData!['weather'][0]['description'],
                    style: const TextStyle(
                        fontSize: 18, color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoTile("🔥",
                          "${_weatherData!['main']['humidity']}%", "Humidity"),
                      _infoTile("🍃",
                          "${_weatherData!['wind']['speed']} m/s", "Wind"),
                      _infoTile("🌬️",
                          "${_weatherData!['main']['pressure']} hPa", "Pressure"),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),
        Text(value, style: const TextStyle(color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
