import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../screens/exerciselistscreen.dart';

class Editexercisesbutton extends StatefulWidget {
  final List<Exercise> exercises;
  final int day_id;
  final String day_name;
  final Future<void> Function() loadExercisesForAllDays;
  const Editexercisesbutton({
    super.key,
    required this.exercises,
    required this.day_id,
    required this.day_name,
    required this.loadExercisesForAllDays,
  });

  @override
  State<Editexercisesbutton> createState() => _EditexercisesbuttonState();
}

class _EditexercisesbuttonState extends State<Editexercisesbutton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final currentExerciseIds = widget.exercises
            .map((exercise) => exercise.Eid!)
            .toList();

        print('Navigating to ExerciseListScreen with:');
        print('Day ID: ${widget.day_id}');
        print('Day Name: ${widget.day_name}');
        print('Current exercises: $currentExerciseIds');
        final editedResults = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseListScreen(
              dayId: widget.day_id,
              dayName: widget.day_name,
              selectedExcercise: currentExerciseIds,
            ),
          ),
        );
        if (editedResults == true) {
          await widget.loadExercisesForAllDays();
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.edit_attributes,
            color: const Color.fromARGB(255, 26, 26, 26),
          ),

          Padding(padding: const EdgeInsets.symmetric(horizontal: 1)),
          Text(
            "edit exercises",
            style: TextStyle(color: const Color.fromARGB(255, 26, 26, 26)),
          ),
        ],
      ),
    );
  }
}
