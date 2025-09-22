import 'package:flutter/material.dart';
import 'fertilizer_service.dart';
import 'weather_service.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  String? selectedSoil;
  String? selectedCrop;
  Map<String, dynamic>? result;
  bool isLoading = false;

  final List<String> soils = [
    "Loamy",
    "Clay",
    "Sandy",
    "Red Soil",
    "Black Soil",
  ];
  final List<String> crops = ["Wheat", "Rice", "Maize", "Mustard", "Groundnut"];

  void _getFertilizerPlan() async {
    if (selectedSoil == null || selectedCrop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please select soil and crop")),
      );
      return;
    }

    setState(() => isLoading = true);

    final plan = FertilizerService.getFertilizerPlan(
      selectedSoil!,
      selectedCrop!,
    );

    for (var f in plan["fertilizers"]) {
      final weather = await WeatherService.fetchWeather(
        "Delhi", // 🔹 TODO: replace with farmer location
        "Delhi",
        "Delhi",
      );

      f["weather"] = weather["condition"];
      f["decision"] =
          weather["condition"].toString().toLowerCase().contains("rain")
          ? "⚠ Postpone (rain expected)"
          : "✅ Safe to apply";
    }

    setState(() {
      result = plan;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("💧 Fertilizer Suggestions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedSoil,
              items: soils
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) => setState(() => selectedSoil = value),
              decoration: const InputDecoration(labelText: "Select Soil Type"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedCrop,
              items: crops
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => selectedCrop = value),
              decoration: const InputDecoration(labelText: "Select Crop Type"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getFertilizerPlan,
              child: const Text("Get Suggestions"),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (result != null && !isLoading)
              Expanded(
                child: ListView(
                  children: [
                    ...result!["fertilizers"].map<Widget>((f) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Text("Day ${f['day']}"),
                          title: Text("${f['name']} - ${f['qty']}"),
                          subtitle: Text(
                            "Stage: ${f['stage']}\n"
                            "🌦 Weather: ${f['weather']}\n"
                            "📌 Decision: ${f['decision']}",
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                    Text(
                      "📝 Advice: ${result!['advice']}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
