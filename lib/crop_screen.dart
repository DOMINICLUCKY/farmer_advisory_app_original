import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'crop_service.dart';
import 'crop_result_screen.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  String? selectedSoil;
  String? selectedCrop;

  File? soilImage;
  File? cropImage;

  final List<String> soils = [
    "Loamy",
    "Clay",
    "Sandy",
    "Red Soil",
    "Black Soil",
  ];
  final List<String> crops = ["Wheat", "Rice", "Maize", "Mustard", "Groundnut"];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
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
              if (image != null) _processImage(type, File(image.path));
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
              if (image != null) _processImage(type, File(image.path));
            },
          ),
        ],
      ),
    );
  }

  void _processImage(String type, File imageFile) {
    setState(() {
      if (type == "Soil") {
        soilImage = imageFile;
        selectedSoil = soils[Random().nextInt(soils.length)];
      } else {
        cropImage = imageFile;
        selectedCrop = crops[Random().nextInt(crops.length)];
      }
    });
  }

  void _getAdvisory() {
    if (selectedSoil == null || selectedCrop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please select soil and crop.")),
      );
      return;
    }

    final data = CropService.generateAdvisory(selectedSoil!, selectedCrop!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CropResultScreen(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🌱 Crop & Soil Advisory")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedSoil,
                    items: soils
                        .map(
                          (soil) =>
                              DropdownMenuItem(value: soil, child: Text(soil)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => selectedSoil = value),
                    decoration: const InputDecoration(
                      labelText: "Select Soil Type",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.green),
                  onPressed: () => _pickImage("Soil"),
                ),
              ],
            ),
            if (soilImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(soilImage!, height: 80),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedCrop,
                    items: crops
                        .map(
                          (crop) =>
                              DropdownMenuItem(value: crop, child: Text(crop)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => selectedCrop = value),
                    decoration: const InputDecoration(
                      labelText: "Select Crop Type",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.green),
                  onPressed: () => _pickImage("Crop"),
                ),
              ],
            ),
            if (cropImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(cropImage!, height: 80),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getAdvisory,
              child: const Text("Get Advisory"),
            ),
          ],
        ),
      ),
    );
  }
}
