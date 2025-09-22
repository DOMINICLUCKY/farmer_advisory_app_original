import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey =
      "5ca0f5b6cf69fc095bd5611fd88aa5ff"; // 🔑 Replace with your OpenWeather key
  static const String _baseUrl =
      "https://api.openweathermap.org/data/2.5/weather";

  /// Fetch weather by manual input (city, state, district → we’ll combine as query)
  static Future<Map<String, dynamic>> fetchWeather(
    String city,
    String state,
    String district,
  ) async {
    String query = "$city,$district,$state,IN"; // IN = India
    final url = Uri.parse("$_baseUrl?q=$query&appid=$_apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "location": data["name"],
        "temperature": data["main"]["temp"],
        "condition": data["weather"][0]["description"],
        "windSpeed": data["wind"]["speed"],
      };
    } else {
      throw Exception("Error: ${response.body}");
    }
  }

  /// Fetch weather using GPS coordinates
  static Future<Map<String, dynamic>> fetchWeatherByLocation(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      "$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "location": data["name"],
        "temperature": data["main"]["temp"],
        "condition": data["weather"][0]["description"],
        "windSpeed": data["wind"]["speed"],
      };
    } else {
      throw Exception("Error: ${response.body}");
    }
  }
}
