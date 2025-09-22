import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  bool isLoading = false;

  // Fetch weather by manual input
  Future<void> _getWeatherManual(BuildContext context) async {
    String city = cityController.text.trim();
    String district = districtController.text.trim();
    String state = stateController.text.trim();

    if (city.isEmpty || district.isEmpty || state.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Please enter City, District, and State."),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await WeatherService.fetchWeather(city, state, district);

      // Navigate to results page
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherResultScreen(data: data),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to load weather: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Fetch weather by GPS
  Future<void> _getWeatherByLocation(BuildContext context) async {
    setState(() => isLoading = true);

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠ Location permission denied.")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await WeatherService.fetchWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherResultScreen(data: data),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to load weather: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("☁ Weather Alerts")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: "Enter City"),
            ),
            TextField(
              controller: districtController,
              decoration: const InputDecoration(labelText: "Enter District"),
            ),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: "Enter State"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _getWeatherManual(context),
                  child: const Text("Get Weather"),
                ),
                ElevatedButton(
                  onPressed: () => _getWeatherByLocation(context),
                  child: const Text("Use Current Location"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// ✅ Weather Result Screen
class WeatherResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const WeatherResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌤 Weather Report"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context); // Go back to enter location
            },
            icon: const Icon(Icons.edit_location_alt),
            tooltip: "Change Location",
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "📍 Location: ${data['location']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "🌡 Temperature: ${data['temperature']}°C",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "☁ Condition: ${data['condition']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "💨 Wind Speed: ${data['windSpeed']} m/s",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
