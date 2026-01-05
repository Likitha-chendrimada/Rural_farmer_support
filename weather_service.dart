import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // ✅ Your OpenWeatherMap API Key
  final String apiKey = "7c004561c464ed7b1e599fbbfe987151";

  /// Fetch weather by city/village name
  Future<Map<String, dynamic>?> fetchWeatherByCity(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }

  /// Fetch weather by latitude & longitude
  Future<Map<String, dynamic>?> fetchWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}
