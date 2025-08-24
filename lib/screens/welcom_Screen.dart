import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import '../screens/sign_in_screen.dart';
import '../screens/intro_screen.dart';

class WelcomScreen extends StatefulWidget {
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 28, 28, 28)),
      body: AnimatedSplashScreen(
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        splash: Padding(
          padding: const EdgeInsets.only(bottom: 110),
          child: SizedBox(width: 1000, height: 1000, child: Image.asset('assets/intro.gif', width: 900, height: 900,fit: BoxFit.cover,),
          ),
        ),
        splashIconSize: 500,
        nextScreen: IntroScreen(),
        duration: 3150,
      ),
    );
  }
}
