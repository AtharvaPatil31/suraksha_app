import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:suraksha_app/screens/onboarding_screens/Authentication_screens/otp_01.dart';
import 'package:suraksha_app/screens/onboarding_screens/screen_1.dart';
import 'package:suraksha_app/screens/main%20screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url: 'https://nzmsmwnugyspvlyynxss.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56bXNtd251Z3lzcHZseXlueHNzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5MDI4NjIsImV4cCI6MjA3MjQ3ODg2Mn0.LCD0ZeDnTaGVCq-qB9r-YM50GlPIvfOJeuG3jK2dRIc',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suraksha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA82AE3),
        ),
        useMaterial3: true,
        fontFamily: 'Katibeh',
      ),
      home: const SplashScreen(fontSize: 70),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final double fontSize;

  const SplashScreen({super.key, this.fontSize = 150});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _sController;
  late AnimationController _lettersController;

  late Animation<Offset> _sSlideAnimation;
  late Animation<double> _sScaleAnimation;

  late Animation<double> _lettersFadeAnimation;
  late Animation<double> _lettersWidthAnimation;

  @override
  void initState() {
    super.initState();

    // "S" animation
    _sController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _sSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _sController, curve: Curves.easeOutBack),
    );

    _sScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _sController, curve: Curves.easeOut),
    );

    // "uraksha" animation
    _lettersController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _lettersFadeAnimation = CurvedAnimation(
      parent: _lettersController,
      curve: Curves.easeIn,
    );

    _lettersWidthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _lettersController, curve: Curves.easeOut),
    );

    // Run animations
    _sController.forward().whenComplete(() {
      _lettersController.forward().whenComplete(() {
        // Navigate after splash
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _checkLoginStatus();
          }
        });
      });
    });
  }

  /// ✅ Check if Supabase session is valid
  Future<void> _checkLoginStatus() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session != null) {
      try {
        final userResponse = await supabase.auth.getUser();
        if (userResponse.user != null) {
          // ✅ Valid session → Go to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          return;
        }
      } catch (e) {
        // ❌ Session invalid, clear it
        await supabase.auth.signOut();
      }
    }

    // ❌ No valid session → Go to onboarding
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Screen1()),
    );
  }

  @override
  void dispose() {
    _sController.dispose();
    _lettersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF861FC0), // darker purple
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // "S"
            SlideTransition(
              position: _sSlideAnimation,
              child: ScaleTransition(
                scale: _sScaleAnimation,
                child: Text(
                  "S",
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Katibeh',
                  ),
                ),
              ),
            ),

            // "uraksha"
            FadeTransition(
              opacity: _lettersFadeAnimation,
              child: SizeTransition(
                sizeFactor: _lettersWidthAnimation,
                axis: Axis.horizontal,
                axisAlignment: -1.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "uraksha",
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Katibeh',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
