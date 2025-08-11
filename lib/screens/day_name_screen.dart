import 'package:flutter/material.dart';
import 'package:gym/widgets/appbar.dart';
import '../screens/exerciselistscreen.dart';
import '../models/day_model.dart';
import '../services/day_services.dart';

class DayNameScreen extends StatefulWidget {
  const DayNameScreen({super.key});

  @override
  State<DayNameScreen> createState() => _DayNameScreenState();
}

class _DayNameScreenState extends State<DayNameScreen> {
  List<Days> days = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDays();
  }

  Future<void> loadDays() async {
    try {
      final daysData = await DayServices().getAllDays();
      setState(() {
        days = daysData;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading days: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppbarWidget(
      Title: 'Day Name',
      ScafoldWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "enter the name of the day:",
            ),
            style: TextStyle(color: Colors.white),
            controller: controller,
          ),
          Center(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (controller.text.trim().isNotEmpty) {
                      try {
                        final dayId = await DayServices().insertDay(
                          Days(Dname: controller.text.trim()),
                        );
                        // Navigator.pop(context);
                        if (dayId > 0) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseListScreen(
                                dayId: dayId,
                                dayName: controller.text.trim(),
                                selectedExcercise: [],
                              ),
                            ),
                          );
                          if (mounted) {
                            Navigator.pop(context, result);
                          }
                        } else {
                          print(
                            '❌ Failed to create day - invalid dayId : $dayId',
                          );
                        }
                      } catch (e) {
                        print('Error adding day : $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error adding day')),
                        );
                      }
                    }
                  },
                  child: Text(
                    "next",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 27, 26, 26),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
