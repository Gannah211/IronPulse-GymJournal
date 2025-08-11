import 'package:flutter/material.dart';
import '../screens/day_name_screen.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import '../screens/exercise_datails_screen.dart';
import '../models/exercise_model.dart';
import '../models/day_model.dart';
import '../services/exercise_services.dart';
import '../services/day_services.dart';
import '../widgets/editExercisesButton.dart';
import '../widgets/renameButton.dart';
import '../widgets/deleteDayButton.dart';
import '../services/exercise_per_day_services.dart';

class DaysListScreen extends StatefulWidget {
  const DaysListScreen({super.key});

  @override
  State<DaysListScreen> createState() => _DaysListScreenState();
}

Future<Exercise?> getExerciseName(int id) async {
  return await ExerciseServices().getExerciseById(id);
}

class _DaysListScreenState extends State<DaysListScreen> {
  List<Days> days = [];
  bool isLoading = true;
  Map<int, List<Map<String, dynamic>>> dayExercises = {};

  Future<void> loadDays() async {
    try {
      final loadedDays = await DayServices().getAllDays();
      setState(() {
        days = loadedDays;
        isLoading = false;
      });
      await loadExercisesForAllDays();
    } catch (e) {
      print('Error loading days: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadExercisesForAllDays() async {
    for (Days day in days) {
      final exercises = await ExercisePerDayServices()
          .getExercisesWithNamesForDays(day.Did!);
      print("Found ${exercises.length} exercises for day ${day.Dname}");

      if (mounted) {
        setState(() {
          dayExercises[day.Did!] = exercises;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadDays();
  }

  void _onReturnFromScreen() {
    print("Refreshing data after returning from another screen");
    loadExercisesForAllDays();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DayNameScreen()),
              );
              if (result == true) {
                await loadDays(); 
                
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: const Color.fromARGB(255, 61, 61, 61),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_box_outlined,
                  size: 30,
                  color: const Color.fromARGB(255, 182, 182, 182),
                ),
                SizedBox(width: 20),
                Text(
                  'Add new day',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 182, 182, 182),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: loadExercisesForAllDays,
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final exercises = dayExercises[day.Did!] ?? [];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onDoubleTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExerciseDetails(dayId: day.Did!),
                        ),
                      );
                      print("Returned from ExerciseDetails, result: $result");
                      _onReturnFromScreen();
                    },
                    child: ExpansionTileCard(
                      baseColor: Color.fromARGB(255, 119, 46, 28),
                      expandedColor: Color.fromARGB(255, 176, 60, 24),
                      title: Text(
                        day.Dname,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 253, 253),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        if (exercises.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No exercises assigned to this day',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          ...exercises.map<Widget>(
                            (exercise) =>
                                ListTile(title: Text(exercise['Ename'])),
                          ),

                        Row(
                          children: [
                            Expanded(
                              child: OverflowBar(
                                children: [
                                  Row(
                                    children: [
                                      Editexercisesbutton(
                                        exercises: exercises
                                            .map(
                                              (e) => Exercise(
                                                Ename: e['Ename'],
                                                Eid: e['Exercise_id'],
                                              ),
                                            )
                                            .toList(),
                                        day_id: day.Did!,
                                        day_name: day.Dname,
                                        loadExercisesForAllDays:
                                            loadExercisesForAllDays,
                                      ),
                                      SizedBox(width: 30),

                                      Renamebutton(
                                        day_id: day.Did!,
                                        day_name: day.Dname,
                                        loadDays: loadDays,
                                      ),
                                      SizedBox(width: 25),
                                      Deletedaybutton(
                                        day_id: day.Did!,
                                        loadDays: loadDays,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
