import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  // API key loaded securely from environment
  final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<Map<String, dynamic>?> fetchWeatherByCity(String city) async {
    if (_apiKey.isEmpty) {
      throw Exception("API key not found");
    }

    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather"
      "?q=$city&appid=$_apiKey&units=metric",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchWeatherByCoords(
      double lat, double lon) async {
    if (_apiKey.isEmpty) {
      throw Exception("API key not found");
    }

    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather"
      "?lat=$lat&lon=$lon&appid=$_apiKey&units=metric",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
