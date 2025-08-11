import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

class AppbarWidget extends StatelessWidget {
  final String Title;
  final Widget ScafoldWidget;

  const AppbarWidget({
    super.key,
    required this.Title,
    required this.ScafoldWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 26, 26),
      appBar: GradientAppBar(
        title: Row(
          children: [
            Icon(Icons.bolt, size: 40, color: Colors.amber),
            Text(
              Title,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
          ],
        ),
        gradient: LinearGradient(
          colors: [Color(0xFF1C1018), Color(0xFFD34E24)],
        ),
      ),
      body: ScafoldWidget,
    );
  }
}
