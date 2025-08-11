import 'package:flutter/material.dart';
import 'package:gym/widgets/appbar.dart';

class DayDetails extends StatelessWidget {
  final List<Map<String, dynamic>> Days;
  final int index;
  const DayDetails({super.key, required this.Days, required this.index});

  @override
  Widget build(BuildContext context) {
    return AppbarWidget(
      Title: "Iron Pulse",
      ScafoldWidget: execrsice_Details(Days: Days, index: index),
    );
  }
}

class execrsice_Details extends StatelessWidget {
  final List<Map<String, dynamic>> Days;
  final int index;
  const execrsice_Details({super.key, required this.Days, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            Days[index]['name'] ?? Days[index]['day'] ?? 'day Name',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Exerciseflatbutton(Days: Days, index: index),
      ],
    );
  }
}
