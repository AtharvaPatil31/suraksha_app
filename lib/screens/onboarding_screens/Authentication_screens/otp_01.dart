import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'verify_otp_screen.dart'; // 👈 make sure this path is correct

class Otp01 extends StatefulWidget {
  final String centerText;
  final double fontSize;
  final double subTextFontSize;
  final Color color;
  final FontWeight fontWeight;

  const Otp01({
    super.key,
    this.centerText = "Let's verify you",
    this.fontSize = 60,
    this.subTextFontSize = 25,
    this.color = Colors.white,
    this.fontWeight = FontWeight.bold,
  });

  @override
  State<Otp01> createState() => _Otp01State();
}

class _Otp01State extends State<Otp01> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> _sendOtp() async {
    final supabase = Supabase.instance.client;
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit phone number")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.signInWithOtp(
        phone: "+91$phone", // 👈 country code
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent to +91$phone")),
      );

      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpScreen(phone: "+91$phone"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Top image
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.5,
                child: Image.asset(
                  "assets/images/violence.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFFE1B7F9),
                    Color(0xFFB83EE0),
                    Color(0xFF861FC0),
                  ],
                  stops: [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Centered content
          Positioned(
            top: screenHeight * 0.4,
            left: 20,
            right: 20,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.centerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.color,
                      fontWeight: widget.fontWeight,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter mobile number to sign up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.subTextFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Phone input
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      counterText: "",
                      prefixIcon: const Icon(Icons.phone, color: Colors.white),
                      hintText: "Phone Number",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Get OTP button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF861FC0),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Get OTP",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
