import 'package:flutter/material.dart';
import '../models/exercise_set_model.dart';
import '../services/exercise_set_services.dart';
import '../widgets/lastWidgetInSet.dart';

class Exerciseset extends StatefulWidget {
  final int exercisePerDayId;
  final String exerciseName;
  final List<Map<String, dynamic>> exercises;
  final int initialExerciseIndex;
  final bool isGlobalWorkoutMode;
  final bool isCurrentExercise;
  final VoidCallback onStartWorkout;
  final Function(int) onExerciseCompleted;
  final VoidCallback onWorkoutFinished;
  final VoidCallback? onSetAdded;
  final VoidCallback? onStateChanged;

  const Exerciseset({
    super.key,
    required this.exercisePerDayId,
    required this.exerciseName,
    required this.exercises,
    required this.initialExerciseIndex,
    required this.isGlobalWorkoutMode,
    required this.isCurrentExercise,
    required this.onStartWorkout,
    required this.onExerciseCompleted,
    required this.onWorkoutFinished,
    this.onSetAdded,
    this.onStateChanged,
  });

  @override
  State<Exerciseset> createState() => ExercisesetState();
}

class ExercisesetState extends State<Exerciseset> {
  List<ExerciseSets> sets = [];
  bool isLoading = true;
  bool showRestTimer = false;
  late int currentExerciseIndex;

  @override
  void initState() {
    super.initState();
    currentExerciseIndex = widget.initialExerciseIndex;
    loadSets();
  }

  // Computed property for workout mode
  bool get isWorkoutMood =>
      widget.isGlobalWorkoutMode && widget.isCurrentExercise;

  // Computed property for current set index
  int get currentSetIndex {
    if (!isWorkoutMood) return 0;
    return sets.indexWhere((s) => s.isFinsihed == 0);
  }

  
  Future<void> addSet() async {
    try {
      await ExerciseSetServices().addExerciseSet(widget.exercisePerDayId);
      await loadSets();

     
      widget.onSetAdded?.call();
      widget.onStateChanged?.call();
     
      if (widget.isGlobalWorkoutMode && widget.isCurrentExercise) {
        final hasUnfinished = sets.any((s) => s.isFinsihed == 0);
        if (hasUnfinished) {
        }
      }
    } catch (e) {
      print('❌ Error adding set: $e');
    }
  }

  Future<void> removeSet(int setIndex) async {
    try {
      await ExerciseSetServices().deleteExerciseSet(setIndex);
      await loadSets();

      widget.onStateChanged?.call();
      print('✅  removing set: $setIndex');
    } catch (e) {
      print('❌ Error removing set: $e');
    }
  }

  Future<void> loadSets() async {
    try {
      setState(() {
        isLoading = true;
      });

      final setsData = await ExerciseSetServices().getSetsForExercise(
        widget.exercisePerDayId,
      );
      print(
        '🔍 Found ${setsData.length} sets for exercise ${widget.exercisePerDayId}',
      );

      List<ExerciseSets> finalSets;

      if (setsData.isEmpty) {


        await ExerciseSetServices().createDefaultSets(
          widget.exercisePerDayId,
          setCount: 3,
        );

        finalSets = await ExerciseSetServices().getSetsForExercise(
          widget.exercisePerDayId,
        );
      } else {
        finalSets = setsData;
      }


      setState(() {
        sets = finalSets;
        isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onStateChanged?.call();
      });
    } catch (e) {
      print('❌ Error loading sets: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateSet(ExerciseSets set) async {
    try {
      await ExerciseSetServices().updateExerciseSet(set);
      await loadSets();
      print('✅ Set updated and reloaded from database: ID ${set.ESid}');

      widget.onStateChanged?.call();
    } catch (e) {
      print('Error updating set: $e');
    }
  }

  Future<bool> markSetAsFinished(int setId) async {
    try {
      await ExerciseSetServices().markSetAsFinished(setId);
      await loadSets();

      // Check if all sets are now completed
      final hasUnfinished = sets.any((s) => s.isFinsihed == 0);
      widget.onStateChanged?.call();

      return !hasUnfinished;
    } catch (e) {
      print('Error marking set as finished: $e ');
      return false;
    }
  }

  void startWorkout() {
    int firstUnfinishedIndex = sets.indexWhere((set) => set.isFinsihed == 0);
    if (firstUnfinishedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All sets are already completed ✅")),
      );
      return;
    }

    widget.onStartWorkout();
    widget.onStateChanged?.call();
  }

  void handleRestTimerEnd() {
    setState(() {
      showRestTimer = false;
    });
    widget.onStateChanged?.call();
  }

  ExerciseSets? get currentSet {
    if (currentSetIndex >= 0 && currentSetIndex < sets.length) {
      return sets[currentSetIndex];
    }
    return null;
  }

  bool get isAllSetsCompleted {
    return sets.every((s) => s.isFinsihed == 1);
  }

  bool get isNextSetCompleted {
    final nextSetIndex = currentSetIndex + 1;
    return nextSetIndex < sets.length && sets[nextSetIndex].isFinsihed == 1;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: sets.length + 1,
            itemBuilder: (context, index) {
              if (index == sets.length) {
                return newCountWidget(
                  onAdd: addSet,
                  onRemove: () => removeSet(sets.last.ESid!),
                );
              }
              final set = sets[index];
              final isCurrentSet = isWorkoutMood && index == currentSetIndex;
              final isFinished = set.isFinsihed == 1;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color.fromARGB(255, 45, 44, 44),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isFinished
                        ? Colors.green
                        : isCurrentSet
                        ? Colors.deepOrange
                        : Color(0xFF1C1018),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          initialValue: set.repsCount.toString(),
                          decoration: InputDecoration(
                            labelText: 'Reps',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepOrange,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final newSet = ExerciseSets(
                              ESid: set.ESid,
                              ExercisePerday_id: set.ExercisePerday_id,
                              repsCount: int.tryParse(value) ?? set.repsCount,
                              Kgs: set.Kgs,
                              isFinsihed: set.isFinsihed,
                            );
                            updateSet(newSet);
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white, fontSize: 16),

                          initialValue: set.Kgs.toString(),
                          decoration: InputDecoration(
                            labelText: 'kg',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepOrange,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final newSet = ExerciseSets(
                              ESid: set.ESid,
                              ExercisePerday_id: set.ExercisePerday_id,
                              repsCount: set.repsCount,
                              Kgs: int.tryParse(value) ?? set.Kgs,
                              isFinsihed: set.isFinsihed,
                            );
                            updateSet(newSet);
                          },
                        ),
                      ),
                      SizedBox(width: 8),

                      CircleAvatar(
                        backgroundColor: Color(0xFF1C1018),
                        child: Icon(
                          Icons.check,
                          color: isFinished ? Colors.green : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
