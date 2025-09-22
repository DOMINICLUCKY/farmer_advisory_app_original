import 'package:flutter/material.dart';
import 'voice_helper.dart';
import 'ai_service.dart';

// Import your feature screens
import 'crop_screen.dart';
import 'fertilizer_screen.dart';
import 'weather_screen.dart';
import 'pest_screen.dart';
import 'market_screen.dart';

void main() {
  runApp(const FarmerAdvisoryApp());
}

class FarmerAdvisoryApp extends StatelessWidget {
  const FarmerAdvisoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer Advisory App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
      routes: {
        '/crop': (context) => const CropScreen(),
        '/fertilizer': (context) => const FertilizerScreen(),
        '/weather': (context) => const WeatherScreen(),
        '/pest': (context) => const PestScreen(),
        '/market': (context) => const MarketScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VoiceHelper _voice = VoiceHelper();
  String _reply = "🎙 Tap mic and ask (Hindi/English)";

  /// Handle mic button pressed
  Future<void> _onMicPressed() async {
    setState(() {
      _reply = "🎤 Listening...";
    });

    final spoken = await _voice.startListening();

    if (spoken == null || spoken.trim().isEmpty) {
      setState(() => _reply = "⚠ Did not catch that, please try again.");
      return;
    }

    setState(() => _reply = "You said: $spoken");

    // Send to AI Service (intent matcher)
    final ai = await AiService.getResponse(spoken);
    final reply = ai['reply'] as String? ?? "Maaf kijiye, samajh nahi aaya.";
    final route = ai['route'] as String?;

    // Speak back
    await _voice.speak(reply);
    setState(() => _reply = reply);

    // Navigate to correct feature
    if (route != null) {
      Navigator.pushNamed(context, '/$route');
    }
  }

  /// Build Feature Card
  Widget _buildFeatureCard(String icon, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        color: Colors.green.shade50,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌾 Farmer Advisory App"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16.0),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard("🌱", "Soil & Crop Advisory", '/crop'),
                _buildFeatureCard(
                  "💧",
                  "Fertilizer Suggestions",
                  '/fertilizer',
                ),
                _buildFeatureCard("☁", "Weather Alerts", '/weather'),
                _buildFeatureCard("🐛", "Pest & Disease Advisory", '/pest'),
                _buildFeatureCard("📈", "Market Prices", '/market'),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(_reply, style: const TextStyle(fontSize: 16)),
                ),
                FloatingActionButton(
                  onPressed: _onMicPressed,
                  child: const Icon(Icons.mic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
