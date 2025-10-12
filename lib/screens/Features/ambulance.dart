import 'package:flutter/material.dart';

class AmbulanceScreen extends StatelessWidget {
  const AmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambulance"),
        backgroundColor: const Color(0xFF861FC0),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "🚑 Call Ambulance Feature Coming Soon",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
