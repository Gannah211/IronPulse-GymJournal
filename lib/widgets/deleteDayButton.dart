import 'package:flutter/material.dart';
import '../services/day_services.dart';

class Deletedaybutton extends StatefulWidget {
  final int day_id;
  final Future<void> Function() loadDays;
  const Deletedaybutton({
    super.key,
    required this.day_id,
    required this.loadDays,
  });

  @override
  State<Deletedaybutton> createState() => _DeletedaybuttonState();
}

class _DeletedaybuttonState extends State<Deletedaybutton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() async {
          await DayServices().deleteDay(widget.day_id);
          widget.loadDays();
        });
      },
      child: Row(
        children: [
          Icon(Icons.delete, color: const Color.fromARGB(255, 26, 26, 26)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0)),
          Text("delete", style: TextStyle(color: const Color.fromARGB(255, 26, 26, 26))),
        ],
      ),
    );
  }
}
