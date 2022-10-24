import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: const [
          Icon(
            FontAwesomeIcons.creditCard,
            size: 55,
            color: Color(0xFF15485D),
          ),
          Text(
            'Money Manager',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF15485D),
            ),
          ),
        ],
      ),
      nextScreen: const HomeScreen(),
      duration: 2500,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
