import 'package:flutter/material.dart';
import 'package:money_manager/screens/home_screen/home_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const HomeScreen(),
      duration: 4000,
      imageSize: 310,
      imageSrc: "assets\\SPENDEE.png",
      backgroundColor: Colors.white,
    );
  }
}
