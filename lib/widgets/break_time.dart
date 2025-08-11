import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class countdownTimer extends StatefulWidget {
  final VoidCallback onComplete;
  final CountDownController controller;

  const countdownTimer({
    super.key,
    required this.onComplete,
    required this.controller,
  });

  @override
  State<countdownTimer> createState() => _countdownTimerState();
}

class _countdownTimerState extends State<countdownTimer> {
  final int _duration = 60;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularCountDownTimer(
        width: 30,
        height: 30,
        duration: _duration,
        initialDuration: 0,
        controller: widget.controller,
        fillColor: Color(0xFF2E2E2E),
        backgroundColor: Colors.white,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: true,
        ringColor: Colors.deepOrange,
        onStart: () {
          debugPrint('Countdown Started');
        },
        onComplete: () {
          debugPrint('Countdown Ended');
          widget.onComplete();
        },
        onChange: (String timeStamp) {
          debugPrint('Countdown Changed $timeStamp');
        },
      ),
    );
  }
}

class FinishDailog extends StatelessWidget {
  const FinishDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
