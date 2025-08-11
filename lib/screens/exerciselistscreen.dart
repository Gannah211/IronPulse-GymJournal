import 'package:flutter/material.dart';
import 'package:gym/widgets/appbar.dart';
// import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/exercise_model.dart';
import '../services/exercise_services.dart';
import '../services/db_services.dart';
import "../widgets/excercisecheckbutton.dart";

class ExerciseListScreen extends StatefulWidget {
  final int dayId;
  final String dayName;
  final List<int> selectedExcercise;

  const ExerciseListScreen({
    super.key,
    required this.dayId,
    required this.dayName,
    required this.selectedExcercise,
  });

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Exercise> allexercises = [];
  late List<int> selectedExerciseIds;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedExerciseIds = List<int>.from(widget.selectedExcercise);
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      print('Loading exercises...');

      
      print('Database connected');

     
      final exercises = await ExerciseServices().getAllExercise();
      if (mounted) {
        setState(() {
          allexercises = exercises;
          isLoading = false;
        });
      }

      print('Exercises loaded successfully');
      print(
        'First exercise: ${exercises.isNotEmpty ? exercises[0] : 'No exercises'}',
      );
    } catch (e) {
      print('Error loading exercises: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveSelectedExercises() async {
    if (selectedExerciseIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please select at least one exercise.')),
      );
      return;
    }
    try {
      await DBService().deleteExerciseForDay(widget.dayId);
      await DBService().insertExercisesForDay(
        widget.dayId,
        selectedExerciseIds,
      );
    } catch (e) {
      print('Error saving exercises : $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving exercises')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppbarWidget(
      Title: "choose Excercies: ",
      ScafoldWidget: isLoading
          ? Center(child: CircularProgressIndicator())
          : allexercises.isEmpty
          ? Center(child: Text('No exercises found'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: allexercises.length,
                    itemBuilder: (context, index) {
                      final exercise = allexercises[index];
                      final isSelected = selectedExerciseIds.contains(
                        exercise.Eid,
                      );
                      return Excercisecheckbutton(
                        exercise: exercise,
                        isInitiallyChecked: isSelected,
                        onchange: (isChecked, name) {
                          final exerciseId = exercise.Eid;
                          if (exerciseId != null) {
                            setState(() {
                              if (isChecked == true) {
                                if (isSelected) {
                                  selectedExerciseIds.remove(exerciseId);
                                } else {
                                  selectedExerciseIds.add(exerciseId);
                                }
                              } else {
                                selectedExerciseIds.remove(exerciseId);
                              }
                            });
                            print(
                              'Updated selected exercises: $selectedExerciseIds',
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                OverflowBar(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 130),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await saveSelectedExercises();
                              if (mounted) {
                                Navigator.pop(context, true);
                                
                              }
                            },
                            child: Text(
                              "CREATE",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 27, 26, 26),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

