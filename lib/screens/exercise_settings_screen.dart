import 'package:flutter/material.dart';
import 'package:gym/widgets/appbar.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import '../widgets/sets_list.dart';
import '../widgets/restTime.dart';

class ExerciseSettings extends StatefulWidget {
  final int exercisePerDayId;
  final String exerciseName;
  final List<Map<String, dynamic>> exercises;
  final int initialExerciseIndex;

  const ExerciseSettings({
    super.key,
    required this.exercisePerDayId,
    required this.exerciseName,
    required this.exercises,
    this.initialExerciseIndex = 0,
  });

  @override
  State<ExerciseSettings> createState() => _ExerciseSettingsState();
}

class _ExerciseSettingsState extends State<ExerciseSettings>
    with SingleTickerProviderStateMixin {
  bool isGlobalWorkoutMode = false;
  int currentGlobalExerciseIndex = 0;
  late TabController _tabController;
  bool showRestTimer = false;
  List<GlobalKey<ExercisesetState>> exerciseKeys = [];

  bool wasWorkoutAlreadyCompleted = false;
  bool triggerFinishDialogOnComplete = false;
  int modifiedExerciseIndex = -1;

  String buttonLabel = 'Start Workout';
  Color buttonColor = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    print(
      '🏗️ ExerciseSettings initState - initialExerciseIndex: ${widget.initialExerciseIndex}',
    );

    _tabController = TabController(
      length: widget.exercises.length,
      vsync: this,
      initialIndex: widget.initialExerciseIndex,
    );

    _tabController.addListener(() {
      print('📑 Tab changed to index: ${_tabController.index}');
      setState(() {
        currentGlobalExerciseIndex = _tabController.index;
        _updateButtonState();
      });
    });

    exerciseKeys = List.generate(
      widget.exercises.length,
      (_) => GlobalKey<ExercisesetState>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔄 PostFrameCallback - calling _updateButtonState');
      wasWorkoutAlreadyCompleted = _isEntireWorkoutCompleted();
      print(
        '🔔 initial wasWorkoutAlreadyCompleted: $wasWorkoutAlreadyCompleted',
      );
      _updateButtonState();
    });
  }

  bool _isEntireWorkoutCompleted() {
    for (int i = 0; i < exerciseKeys.length; i++) {
      final exerciseState = exerciseKeys[i].currentState;
      if (exerciseState != null) {
        final exerciseSets = exerciseState.sets;
        if (exerciseSets.any((set) => set.isFinsihed == 0)) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    print('\n🔍 _updateButtonState CALLED');
    print('   - currentGlobalExerciseIndex: $currentGlobalExerciseIndex');
    print('   - isGlobalWorkoutMode: $isGlobalWorkoutMode');
    print('   - showRestTimer: $showRestTimer');
    print('   - current buttonLabel: $buttonLabel');
    print('   - current buttonColor: $buttonColor');

    final currentSetState =
        exerciseKeys[currentGlobalExerciseIndex].currentState;

    if (currentSetState == null) {
      print('   ❌ currentSetState is NULL');
      setState(() {
        buttonLabel = 'Start Workout';
        buttonColor = Colors.deepOrange;
      });
      print('   ✅ Set to: Start Workout (orange) - NULL state');
      return;
    }

    final sets = currentSetState.sets;
    // FIX: Consider both global workout mode AND individual exercise workout mode
    final isWorkoutActive =
        isGlobalWorkoutMode || currentSetState.isWorkoutMood;
    final hasUnfinishedSets = sets.any((set) => set.isFinsihed == 0);
    final hasFinishedSets = sets.any((set) => set.isFinsihed == 1);
    final allSetsFinished = sets.every((set) => set.isFinsihed == 1);

    print('   📊 State Analysis:');
    print('      - sets.length: ${sets.length}');
    print('      - isWorkoutActive: $isWorkoutActive');
    print('      - hasUnfinishedSets: $hasUnfinishedSets');
    print('      - hasFinishedSets: $hasFinishedSets');
    print('      - allSetsFinished: $allSetsFinished');

    // Print detailed sets info
    for (int i = 0; i < sets.length; i++) {
      print('      - set[$i]: finished=${sets[i].isFinsihed}');
    }

    String newLabel;
    Color newColor;

    if (showRestTimer) {
      print('   🔄 REST TIMER ACTIVE - preparing Log Set');
      newLabel = 'Log Set';
      newColor = Colors.green;
    } else if (!isWorkoutActive) {
      print('   🛑 WORKOUT NOT ACTIVE');
      if (allSetsFinished && sets.isNotEmpty) {
        print('      → All sets finished → Exercise Completed');
        newLabel = 'Exercise Completed';
        newColor = Colors.deepOrange;
      } else if (hasFinishedSets) {
        print('      → Some sets finished → Continue Workout');
        newLabel = 'Continue Workout';
        newColor = Colors.deepOrange;
      } else {
        print('      → No sets finished → Start Workout');
        newLabel = 'Start Workout';
        newColor = Colors.deepOrange;
      }
    } else {
      print('   ✅ WORKOUT IS ACTIVE');
      if (!hasUnfinishedSets) {
        print('      → No unfinished sets → Exercise Completed');
        newLabel = 'Exercise Completed';
        newColor = Colors.deepOrange;
      } else {
        print('      → Has unfinished sets → Log Set');
        newLabel = 'Log Set';
        newColor = Colors.green;
      }
    }

    print(
      '   🎯 Decision: $newLabel (${newColor == Colors.green ? 'green' : 'orange'})',
    );

    // Only update state if values actually changed to reduce rebuilds
    if (buttonLabel != newLabel || buttonColor != newColor) {
      print('   🔄 UPDATING BUTTON STATE: $newLabel');
      setState(() {
        buttonLabel = newLabel;
        buttonColor = newColor;
      });
    } else {
      print('   ⏭️  No change needed - button already correct');
    }
    print('🔍 _updateButtonState COMPLETED\n');
  }

  void startGlobalWorkout() {
    print('\n🚀 startGlobalWorkout CALLED');
    print(
      '   - currentGlobalExerciseIndex before: $currentGlobalExerciseIndex',
    );
    print('   - _tabController.index: ${_tabController.index}');

    setState(() {
      isGlobalWorkoutMode = true;
      currentGlobalExerciseIndex = _tabController.index;
    });

    print('   - isGlobalWorkoutMode: $isGlobalWorkoutMode');
    print('   - currentGlobalExerciseIndex after: $currentGlobalExerciseIndex');
    print('🚀 Calling _updateButtonState from startGlobalWorkout');

    _updateButtonState();
  }

  void onExerciseCompleted(int exerciseIndex) {
    print('\n🏁 onExerciseCompleted CALLED - exerciseIndex: $exerciseIndex');

    if (exerciseIndex < widget.exercises.length - 1) {
      print('   → Moving to next exercise');
      setState(() {
        showRestTimer = true;
        currentGlobalExerciseIndex = exerciseIndex + 1;
      });
      _tabController.animateTo(currentGlobalExerciseIndex);
    } else {
      print('   → All exercises completed');
      setState(() {
        isGlobalWorkoutMode = false;
        currentGlobalExerciseIndex = 0;
      });
      _updateButtonState();
    }
  }

  void onWorkoutFinished() {
    print('\n🏆 onWorkoutFinished CALLED');
    setState(() {
      isGlobalWorkoutMode = false;
      currentGlobalExerciseIndex = 0;
    });
    _updateButtonState();
  }

  void onSetAdded(int exerciseIndex) {
    print('\n➕ onSetAdded CALLED');
    // bool isStillCompleted = _isEntireWorkoutCompleted();

    final before = wasWorkoutAlreadyCompleted;
    final after = _isEntireWorkoutCompleted();

    print('   - before completion: $before, after completion: $after');

    // If workout was complete before adding and now became incomplete,
    // AND the set was added to a non-last exercise -> remember to show dialog when that exercise completes.
    if (before && !after && exerciseIndex < widget.exercises.length - 1) {
      triggerFinishDialogOnComplete = true;
      modifiedExerciseIndex = exerciseIndex;
      print(
        '   ▶ Will show Mission Completed dialog when exercise $exerciseIndex is completed.',
      );
    }

    // update baseline
    wasWorkoutAlreadyCompleted = after;
    _updateButtonState();
  }

  @override
  Widget build(BuildContext context) {
    return AppbarWidget(
      Title: 'Exercise Settings',
      ScafoldWidget: Column(
        children: [
          ButtonsTabBar(
            controller: _tabController,
            radius: 12,
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            borderWidth: 2,
            borderColor: Colors.white,
            center: false,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1C1018), Color(0xFFD34E24)],
              ),
            ),
            unselectedLabelStyle: const TextStyle(color: Colors.white),
            unselectedBackgroundColor: Color.fromARGB(255, 27, 26, 26),
            height: 50,
            tabs: widget.exercises
                .map((exercise) => Tab(text: exercise['Ename']))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                widget.exercises.length,
                (index) => Exerciseset(
                  key: exerciseKeys[index],
                  exercisePerDayId: widget.exercises[index]['EPDid'],
                  exercises: widget.exercises,
                  exerciseName: widget.exercises[index]['Ename'],
                  initialExerciseIndex: index,
                  isGlobalWorkoutMode: isGlobalWorkoutMode,
                  isCurrentExercise: index == currentGlobalExerciseIndex,
                  onStartWorkout: startGlobalWorkout,
                  onExerciseCompleted: onExerciseCompleted,
                  onWorkoutFinished: onWorkoutFinished,
                  onSetAdded: () => onSetAdded(index),
                  onStateChanged: _updateButtonState,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: showRestTimer
                ? Resttime(
                    onEnd: () {
                      print('\n⏰ Rest timer ended');
                      setState(() {
                        showRestTimer = false;
                      });

                      exerciseKeys[currentGlobalExerciseIndex].currentState
                          ?.handleRestTimerEnd();

                      print('⏰ Calling _updateButtonState after rest timer');
                      _updateButtonState();
                    },
                  )
                : ElevatedButton(
                    onPressed: () async {
                      print(
                        '\n🔘 BUTTON PRESSED - current label: $buttonLabel',
                      );

                      final currentSetState =
                          exerciseKeys[currentGlobalExerciseIndex].currentState;
                      if (currentSetState == null) {
                        print('   ❌ currentSetState is null, returning');
                        return;
                      }

                      final currentSetIndex = currentSetState.currentSetIndex;
                      final sets = currentSetState.sets;

                      print('   📊 Before action:');
                      print('      - currentSetIndex: $currentSetIndex');
                      print(
                        '      - isWorkoutMood: ${currentSetState.isWorkoutMood}',
                      );
                      print('      - showRestTimer: $showRestTimer');
                      print(
                        '      - isGlobalWorkoutMode: $isGlobalWorkoutMode',
                      );

                      // Start workout if not started (either globally or individually)
                      if (!isGlobalWorkoutMode &&
                          !currentSetState.isWorkoutMood) {
                        print('   🚀 Starting global workout...');
                        startGlobalWorkout();
                        // Also start the individual exercise
                        currentSetState.startWorkout();
                        print(
                          '   🚀 Workout started, calling _updateButtonState',
                        );
                        _updateButtonState();
                        return;
                      }

                      // If global workout is started but individual exercise isn't, start it
                      if (isGlobalWorkoutMode &&
                          !currentSetState.isWorkoutMood) {
                        print('   🚀 Starting individual exercise workout...');
                        currentSetState.startWorkout();
                        print(
                          '   🚀 Individual workout started, calling _updateButtonState',
                        );
                        _updateButtonState();
                        return;
                      }

                      // Ignore presses while resting
                      if (showRestTimer) {
                        print('   ⏸️  Ignoring press - rest timer active');
                        return;
                      }

                      final currentSet = sets[currentSetIndex];
                      print(
                        '   📝 Logging set ${currentSetIndex + 1}/${sets.length} (ID: ${currentSet.ESid})',
                      );

                      try {
                        final allSetsCompleted = await currentSetState
                            .markSetAsFinished(currentSet.ESid!);

                        print('   ✅ Set marked as finished');
                        print('   📊 After marking set:');
                        print('      - allSetsCompleted: $allSetsCompleted');

                        print(
                          '   🔄 Calling _updateButtonState after markSetAsFinished',
                        );
                        _updateButtonState();
                        if (allSetsCompleted) {
                          final exerciseIdx =
                              currentSetState.widget.initialExerciseIndex;
                          final isLastExercise =
                              exerciseIdx >= widget.exercises.length - 1;

                          print('   🏁 All sets completed for this exercise');
                          print('      - isLastExercise: $isLastExercise');

                          if (!isLastExercise) {
                            print('   ➡️  Moving to next exercise');
                            onExerciseCompleted(exerciseIdx);
                          } else {
                            print('   🏆 Workout finished!');
                            onWorkoutFinished();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Mission Completed ! "),
                                  content: const Text(
                                    "You have finished your workout for today big guy! 🥳",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                      },
                                      child: const Text(
                                        "Return to home screen",
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          }

                          // --- NEW: the special-case dialog when user previously added a set to a completed workout
                          if (triggerFinishDialogOnComplete &&
                              modifiedExerciseIndex == exerciseIdx) {
                            // reset the trigger and mark workout baseline as completed again
                            triggerFinishDialogOnComplete = false;
                            modifiedExerciseIndex = -1;
                            wasWorkoutAlreadyCompleted = true;

                            print(
                              '   💬 Showing special Mission Completed dialog for re-completed exercise $exerciseIdx',
                            );
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Mission Completed ! "),
                                  content: const Text(
                                    "You have finished your workout for today big guy! 🥳",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                      },
                                      child: const Text(
                                        "Return to home screen",
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          }
                        } else {
                          print(
                            '   ⏰ More sets remaining - starting rest timer',
                          );
                          setState(() => showRestTimer = true);
                        }
                      } catch (e) {
                        print('   ❌ Error: $e');
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      buttonLabel,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
