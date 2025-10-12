import 'package:flutter/material.dart';
import 'screen_3.dart'; // 👈 Import Screen3

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> with TickerProviderStateMixin {
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
              "assets/animations/connect.gif",
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
                  "Stay Connected",
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
                  "Get real time safety alerts and updates",
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

          // Skip Text → Navigate back
          Positioned(
            bottom: 50,
            left: 30,
            child: FadeTransition(
              opacity: _buttonFade,
              child: SlideTransition(
                position: _buttonSlide,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // go back
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Katibeh',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Right Arrow Button → Navigate to Screen3
          Positioned(
            bottom: 50,
            right: 30,
            child: FadeTransition(
              opacity: _buttonFade,
              child: SlideTransition(
                position: _buttonSlide,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Screen3()),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
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
