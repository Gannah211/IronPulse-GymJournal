import 'package:flutter/material.dart';
import 'package:gym/screens/editdaynamescreen.dart';

class Renamebutton extends StatefulWidget {
  final int day_id;
  final String day_name;
  final Future<void> Function() loadDays;
  const Renamebutton({
    super.key,
    required this.day_id,
    required this.day_name,
    required this.loadDays,
  });

  @override
  State<Renamebutton> createState() => _RenamebuttonState();
}

class _RenamebuttonState extends State<Renamebutton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final newName = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => editdayname(
              day_id: widget.day_id,
              currentName: widget.day_name,
            ),
          ),
        );
        if (newName != null && newName != widget.day_name) {
          await widget.loadDays();
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.drive_file_rename_outline,
            color: const Color.fromARGB(255, 26, 26, 26),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 1)),
          Text(
            "Rename",
            style: TextStyle(color: const Color.fromARGB(255, 26, 26, 26)),
          ),
        ],
      ),
    );
  }
}
