import 'package:flutter/material.dart';
import 'Authentication_screens/otp_01.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> with TickerProviderStateMixin {
  late AnimationController _mainTextController;
  late AnimationController _subTextController;
  late AnimationController _buttonController;

  late Animation<double> _mainFade;
  late Animation<Offset> _mainSlide;

  late Animation<double> _subFade;
  late Animation<Offset> _subSlide;

  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();

    // Main Text Animation
    _mainTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _mainFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainTextController, curve: Curves.easeIn),
    );

    _mainSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _mainTextController, curve: Curves.easeOut),
    );

    // Subtitle Animation
    _subTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _subFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _subTextController, curve: Curves.easeIn),
    );

    _subSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _subTextController, curve: Curves.easeOut),
    );

    // Button Animation
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeIn),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    // Start animations in sequence
    _mainTextController.forward().whenComplete(() {
      _subTextController.forward().whenComplete(() {
        _buttonController.forward();
      });
    });
  }

  @override
  void dispose() {
    _mainTextController.dispose();
    _subTextController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF861FC0),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background GIF
          Center(
            child: Image.asset(
              "assets/animations/power.gif",
              width: 900,
              height: 1000,
            ),
          ),

          // Main Text
          Positioned(
            top: 200,
            child: FadeTransition(
              opacity: _mainFade,
              child: SlideTransition(
                position: _mainSlide,
                child: const Text(
                  "Stay Safe, Anytime",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Katibeh',
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Subtitle
          Positioned(
            bottom: 200,
            child: FadeTransition(
              opacity: _subFade,
              child: SlideTransition(
                position: _subSlide,
                child: const Text(
                  "Instant access to Emergency Resources \n and Contacts",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    fontFamily: 'Katibeh',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // ✅ "Get Started" Button → Navigate to Otp01
          Positioned(
            bottom: 50,
            child: FadeTransition(
              opacity: _buttonFade,
              child: SlideTransition(
                position: _buttonSlide,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Otp01()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF861FC0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Katibeh',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
