import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'pest_service.dart';
import 'weather_service.dart';

class PestScreen extends StatefulWidget {
  const PestScreen({super.key});

  @override
  State<PestScreen> createState() => _PestScreenState();
}

class _PestScreenState extends State<PestScreen> {
  String? selectedCrop;
  String? selectedPest;
  File? pestImage;
  Map<String, dynamic>? result;
  bool isLoading = false;

  final List<String> crops = ["Wheat", "Rice", "Maize", "Mustard", "Groundnut"];

  final Map<String, List<String>> cropPests = {
    "Wheat": ["Rust", "Aphids"],
    "Rice": ["Stem Borer", "Leaf Blast"],
    "Maize": ["Fall Armyworm", "Turcicum Leaf Blight"],
    "Mustard": ["Aphids", "Powdery Mildew"],
    "Groundnut": ["Leaf Spot", "Rust"],
  };

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.green),
            title: const Text("Take Photo"),
            onTap: () async {
              Navigator.pop(context);
              final XFile? image = await _picker.pickImage(
                source: ImageSource.camera,
              );
              if (image != null) _processImage(File(image.path));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo, color: Colors.blue),
            title: const Text("Choose from Gallery"),
            onTap: () async {
              Navigator.pop(context);
              final XFile? image = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) _processImage(File(image.path));
            },
          ),
        ],
      ),
    );
  }

  void _processImage(File imageFile) {
    setState(() {
      pestImage = imageFile;
      if (selectedCrop != null) {
        final pests = cropPests[selectedCrop]!;
        selectedPest = pests[Random().nextInt(pests.length)];
      }
    });
  }

  void _getAdvisory() async {
    if (selectedCrop == null || selectedPest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please select crop and pest")),
      );
      return;
    }

    setState(() => isLoading = true);

    final pestInfo = PestService.identifyPest(selectedCrop!, selectedPest!);
    final weather = await WeatherService.fetchWeather(
      "Delhi",
      "Delhi",
      "Delhi",
    ); // TODO: real location

    setState(() {
      result = {
        "pest": selectedPest!,
        "chemical": pestInfo["chemical"],
        "organic": pestInfo["organic"],
        "stage": pestInfo["stage"],
        "weather": weather["condition"],
        "decision":
            weather["condition"].toString().toLowerCase().contains("rain")
            ? "⚠ Postpone spray (rain expected)"
            : "✅ Safe to spray",
      };
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🐛 Pest & Disease Advisory")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedCrop,
              items: crops
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() {
                selectedCrop = value;
                selectedPest = null;
              }),
              decoration: const InputDecoration(labelText: "Select Crop"),
            ),
            const SizedBox(height: 16),
            if (selectedCrop != null)
              DropdownButtonFormField<String>(
                initialValue: selectedPest,
                items: cropPests[selectedCrop]!
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => selectedPest = value),
                decoration: const InputDecoration(
                  labelText: "Select Pest/Disease",
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Upload Image"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _getAdvisory,
                  child: const Text("Get Advisory"),
                ),
              ],
            ),
            if (pestImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(pestImage!, height: 100),
              ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (result != null && !isLoading)
              Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Pest/Disease: ${result!['pest']}"),
                  subtitle: Text(
                    "Stage: ${result!['stage']}\n"
                    "💊 Chemical: ${result!['chemical']}\n"
                    "🌿 Organic: ${result!['organic']}\n"
                    "🌦 Weather: ${result!['weather']}\n"
                    "📌 Decision: ${result!['decision']}",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
