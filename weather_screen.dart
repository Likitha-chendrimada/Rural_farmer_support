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
  String? _lastSearchedVillage;

  @override
  void initState() {
    super.initState();
    _loadLastVillage();
  }

  Future<void> _loadLastVillage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedVillage = prefs.getString("lastVillage");
    if (savedVillage != null) {
      _fetchWeather(savedVillage);
    }
  }

  Future<void> _fetchWeather(String village) async {
    final data = await _weatherService.fetchWeatherByCity(village);
    if (data != null) {
      setState(() {
        _weatherData = data;
        _lastSearchedVillage = village;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("lastVillage", village);
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
      appBar: AppBar(title: const Text("Karnataka Village Weather")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: _weatherData != null
            ? _getBackgroundColor(_weatherData!['weather'][0]['description'])
            : Colors.blueGrey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Search Box
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Enter village name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _fetchWeather(_controller.text);
                      }
                    },
                  )
                ],
              ),
            ),

            if (_weatherData == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/weather2.jpg", // ✅ Default image
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Search for a village to see weather 🌤️",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _lastSearchedVillage ?? "",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),

                  // 🔹 Weather Icon
                  Image.network(
                    "http://openweathermap.org/img/wn/${_weatherData!['weather'][0]['icon']}@2x.png",
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.cloud, size: 80, color: Colors.white);
                    },
                  ),

                  // 🔹 Temperature
                  Text(
                    "${_weatherData!['main']['temp']}°C",
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),

                  // 🔹 Condition
                  Text(
                    _weatherData!['weather'][0]['description'],
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Extra Info Row (with emojis 🌬️🔥🍃)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text("🔥", style: TextStyle(fontSize: 30)),
                          Text("${_weatherData!['main']['humidity']}%",
                              style: const TextStyle(color: Colors.white)),
                          const Text("Humidity", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("🍃", style: TextStyle(fontSize: 30)),
                          Text("${_weatherData!['wind']['speed']} m/s",
                              style: const TextStyle(color: Colors.white)),
                          const Text("Wind", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("🌬️", style: TextStyle(fontSize: 30)),
                          Text("${_weatherData!['main']['pressure']} hPa",
                              style: const TextStyle(color: Colors.white)),
                          const Text("Pressure", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
