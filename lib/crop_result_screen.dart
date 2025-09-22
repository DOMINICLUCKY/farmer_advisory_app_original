import 'package:flutter/material.dart';

class CropResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const CropResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🌾 Advisory for ${data['crop']}")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data['timeline'].length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text("${index + 1}")),
              title: Text(data['timeline'][index]),
            ),
          );
        },
      ),
    );
  }
}
