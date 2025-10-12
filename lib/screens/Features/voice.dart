import 'package:flutter/material.dart';

class VoiceToTextScreen extends StatelessWidget {
  const VoiceToTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice To Text"),
        backgroundColor: const Color(0xFF861FC0),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "🎤 Voice to Text Feature Coming Soon",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
