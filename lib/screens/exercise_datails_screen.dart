import 'package:flutter/material.dart';
import 'package:gym/widgets/appbar.dart';
import '../screens/exercise_settings_screen.dart';
import '../models/day_model.dart';
import '../services/day_services.dart';
import '../services/exercise_per_day_services.dart';

class ExerciseDetails extends StatefulWidget {
  final int dayId;
  const ExerciseDetails({super.key, required this.dayId});

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  Days? day;
  List<Map<String, dynamic>> exercises = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print("🚀 ExerciseDetails initialized for dayId: ${widget.dayId}");
    loadData();
  }

  Future<void> loadData() async {
    print("📥 Loading data for dayId: ${widget.dayId}");
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final dayData = await DayServices().getDayById(widget.dayId);
      final exerciseData = await ExercisePerDayServices()
          .getExercisesWithNamesForDays(widget.dayId);
      if (mounted) {
        setState(() {
          day = dayData;
          exercises = exerciseData;
          isLoading = false;
        });
        print(
          "✅ Data loaded successfully. ${exercises.length} exercises found.",
        );
      }
    } catch (e) {
      print('❌ Error loading data : $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load exercises. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print("🔙 PopScope triggered. didPop: $didPop");
        if (!didPop) {
          print("🔙 Manually popping with result: true");
          Navigator.pop(context, true);
        }
      },
      child: AppbarWidget(
        Title: day?.Dname ?? 'Workout Day',
        ScafoldWidget: isLoading
            ? Center(child: CircularProgressIndicator())
            : ExerciseFaltButton(
                day: day,
                dayId: widget.dayId,
                exercises: exercises,
                onExercisesUpdated: (updatedExercises) {
                  print(
                    "🔄 onExercisesUpdated called with ${updatedExercises.length} exercises",
                  );

                  setState(() {
                    exercises = updatedExercises;
                  });
                },
              ),
      ),
    );
  }
}

class ExerciseFaltButton extends StatefulWidget {
  final Days? day;
  final int dayId;
  final List<Map<String, dynamic>> exercises;
  final Function(List<Map<String, dynamic>>) onExercisesUpdated;
  const ExerciseFaltButton({
    super.key,
    required this.day,
    required this.dayId,
    required this.exercises,
    required this.onExercisesUpdated,
  });

  @override
  State<ExerciseFaltButton> createState() => _ExerciseFaltButtonState();
}

class _ExerciseFaltButtonState extends State<ExerciseFaltButton> {
  late List<Map<String, dynamic>> _localExercises;
  bool _isUpdating = false;
  @override
  void initState() {
    super.initState();
    _localExercises = widget.exercises
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    print(
      "🏁 ExerciseFaltButton initialized with ${_localExercises.length} exercises",
    );
  }

  @override
  void didUpdateWidget(ExerciseFaltButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exercises != oldWidget.exercises) {
      _localExercises = widget.exercises
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      print(
        "🔄 Widget updated, _localExercises refreshed with ${_localExercises.length} exercises",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 25),
        if (_isUpdating) const LinearProgressIndicator(),
        Expanded(
          child: ExerciseFlatButton(
            dayId: widget.dayId,
            exercises: _localExercises,
            onReorder: _onReorder,
            isUpdating: _isUpdating,
          ),
        ),
      ],
    );
  }

  void _onReorder(int oldIndex, int newIndex) async {
    print("🔀 Reorder triggered: $oldIndex -> $newIndex");

    if (_isUpdating) {
      print("⏸️ Already updating, ignoring reorder");
      return;
    }
    final originalExercises = List<Map<String, dynamic>>.from(_localExercises);
    print("💾 Saved original state with ${originalExercises.length} exercises");

    setState(() {
      _isUpdating = true;
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _localExercises.removeAt(oldIndex);
      _localExercises.insert(newIndex, item);
      print("📝 Local reorder complete. Updating exercise orders...");

      for (int i = 0; i < _localExercises.length; i++) {
        _localExercises[i]['Exercise_order'] = i + 1;
        print("  ${i + 1}. ${_localExercises[i]['Ename']} -> order ${i + 1}");
      }
    });
    try {
      print("💾 Starting database update...");

      await _updateExerciseOrders();
      print("🐛 Calling debug method...");

      // widget.onExercisesUpdated(_localExercises);
      await ExercisePerDayServices().debugPrintExerciseOrders(widget.dayId);
      final updateExercises = await ExercisePerDayServices()
          .getExercisesWithNamesForDays(widget.dayId);

      if (mounted) {
        setState(() {
          _localExercises = updateExercises;
        });
        widget.onExercisesUpdated(_localExercises);
        print("✅ UI updated with fresh data from database");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercise order updated successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error updating exercise orders: $e');
      widget.onExercisesUpdated([]);
      if (mounted) {
        setState(() {
          _localExercises = originalExercises;
        });
        widget.onExercisesUpdated(_localExercises);
        print("🔄 Rolled back to original state");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update exercise order'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
        print("🏁 Reorder operation completed");
      }
    }
  }

  Future<void> _updateExerciseOrders() async {
    final updates = _localExercises
        .map(
          (exercise) => {
            'EPDid': exercise['EPDid'],
            'Exercise_order': exercise['Exercise_order'],
          },
        )
        .toList();

    print("📤 Sending ${updates.length} updates to database:");
    for (int i = 0; i < updates.length; i++) {
      print(
        "  ${i + 1}. EPDid: ${updates[i]['EPDid']} -> Order: ${updates[i]['Exercise_order']}",
      );
    }

    await ExercisePerDayServices().updateExerciseOrders(updates);
    await Future.delayed(Duration(milliseconds: 100));
  }
}

class ExerciseFlatButton extends StatelessWidget {
  final int dayId;
  final List<Map<String, dynamic>> exercises;
  final Function(int, int) onReorder;
  final bool isUpdating;

  const ExerciseFlatButton({
    super.key,
    required this.dayId,
    required this.exercises,
    required this.onReorder,
    required this.isUpdating,
  });

  Future<void> _navigateToExerciseSettings(
    BuildContext context,
    Map<String, dynamic> exercise,
    int exerciseIndex,
  ) async {
    // Create a safe copy of exercises
    final safeExercises = exercises
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseSettings(
          exercises: safeExercises,
          exercisePerDayId: exercise['EPDid'] ?? 0,
          exerciseName: exercise['Ename'] ?? 'Unknown Exercise',
          initialExerciseIndex: exerciseIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: exercises.length,
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          color: Color.fromARGB(151, 14, 14, 14),
          key: ValueKey(exercise['EPDid']),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Icon(
              Icons.drag_handle,
              color: isUpdating
                  ? Colors.grey
                  : const Color.fromARGB(169, 255, 255, 255),
            ),
            title: Text(
              exercise['Ename'],
              style: TextStyle(
                color: Color(0xFFD34E24),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: const Color.fromARGB(169, 255, 255, 255),
            ),
            enabled: !isUpdating,
            onTap: isUpdating
                ? null
                : () => _navigateToExerciseSettings(context, exercise, index),
          ),
        );
      },
    );
  }
}
