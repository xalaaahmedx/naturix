import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/logo.jpg',
            fit: BoxFit.cover,
          ),

          const SizedBox(
            height: 80,
          ),
          // Circular Progress Indicator
          const Align(
            alignment: Alignment(0, 0.60),
            child: SizedBox(
              height: 60, // Adjust these values as needed
              width: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 2, 165, 146)),
                strokeWidth: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
