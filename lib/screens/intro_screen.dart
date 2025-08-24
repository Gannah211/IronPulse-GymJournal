import 'package:flutter/material.dart';

import '../widgets/pageView_widget.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        toolbarHeight: MediaQuery.of(context).size.height * 0.035,
      ),
      backgroundColor: Color.fromARGB(255, 28, 28, 28),

      body: Center(
        child: Column(
          children: [
            pageViewElement(),

            
          ],
        ),
      ),
    );
  }
}
