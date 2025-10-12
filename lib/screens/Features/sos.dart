import 'package:flutter/material.dart';

class SosDetailScreen extends StatelessWidget {
  const SosDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SOS"),
        backgroundColor: const Color(0xFF861FC0),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "🚨 SOS Details and Actions Coming Soon",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
