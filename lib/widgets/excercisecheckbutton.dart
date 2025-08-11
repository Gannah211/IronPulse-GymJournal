import 'package:flutter/material.dart';
import 'package:gym/models/exercise_model.dart';

class Excercisecheckbutton extends StatefulWidget {
  final Exercise exercise;
  final Function(bool?, String) onchange;
  final bool isInitiallyChecked;

  const Excercisecheckbutton({
    super.key,
    required this.exercise,
    required this.onchange,
    this.isInitiallyChecked = false,
  });

  @override
  State<Excercisecheckbutton> createState() => _ExcercisecheckbuttonState();
}

class _ExcercisecheckbuttonState extends State<Excercisecheckbutton> {
  late bool isCheck;

  @override
  void initState() {
    super.initState();
    isCheck = widget.isInitiallyChecked;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.exercise.Ename, style: TextStyle(color: Colors.white)),
      value: isCheck,
      activeColor: Color(0xFF1C1018),
      checkColor: Color(0xFFD34E24),
      onChanged: (bool? value) {
        setState(() {
          isCheck = value!;
        });
        widget.onchange(value, widget.exercise.Ename);
      },
    );
  }
}
