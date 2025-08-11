import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class Resttime extends StatefulWidget {
  final VoidCallback onEnd;
  const Resttime({super.key, required this.onEnd});

  @override
  State<Resttime> createState() => _ResttimeState();
}

class _ResttimeState extends State<Resttime> {
  bool isTimerActive = true;
  late DateTime endTime;

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now().add(Duration(seconds: 4));
  }

  void _skipTimer() {
    setState(() {
      isTimerActive = false;
    });
    widget.onEnd(); // Call the callback immediately
  }

  @override
  Widget build(BuildContext context) {
    if (!isTimerActive) {
      return SizedBox.shrink(); // Hide the widget when timer is skipped
    }
    return Center(
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _skipTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 62, 61, 61),
              foregroundColor: Colors.white,
            ),
            child: Text("Skip Timer"),
          ),
          SizedBox(width: 35),
          TimerCountdown(
            timeTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            descriptionTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            format: CountDownTimerFormat.secondsOnly,
            endTime: endTime,
            onEnd: widget.onEnd,
          ),
        ],
      ),
    );
  }
}
