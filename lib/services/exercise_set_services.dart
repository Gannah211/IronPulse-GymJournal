import 'package:sqflite/sqflite.dart';
import '../models/exercise_set_model.dart';
import '../database/db.dart';

class ExerciseSetServices {
  final String exerciseSetTable = 'Exercise_Set';

  Future<int> insertExerciseSet(ExerciseSets exerciseSet) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(exerciseSetTable, exerciseSet.toMap());
  }

  Future<void> addExerciseSet(int exercisePerDay) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(exerciseSetTable, {
      'ExercisePerday_id': exercisePerDay,
      'repsCount': 10,
      ' Kgs': 20,
      'isFinsihed': 0,
    });
  }

  Future<List<ExerciseSets>> getSetsForExercise(int exercisePerDayId) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      exerciseSetTable,
      where: 'ExercisePerday_id = ?',
      whereArgs: [exercisePerDayId],
    );
    return List.generate(maps.length, (i) => ExerciseSets.fromMap(maps[i]));
  }

  Future<int> updateExerciseSet(ExerciseSets exerciseSet) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      exerciseSetTable,
      exerciseSet.toMap(),
      where: 'ESid = ?',
      whereArgs: [exerciseSet.ESid],
    );
  }

  Future<int> deleteExerciseSet(int exercisesetId) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      exerciseSetTable,
      where: 'ESid = ?',
      whereArgs: [exercisesetId],
    );
  }

  // Mark set as finished
  Future<int> markSetAsFinished(int setId) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      exerciseSetTable,
      {'isFinsihed': 1},
      where: 'ESid = ?',
      whereArgs: [setId],
    );
  }

  // Create default sets for an exercise (e.g., 3 sets with default values)
  Future<void> createDefaultSets(
    int exercisePerDayId, {
    int setCount = 3,
    int defaultReps = 10,
    int defaultKgs = 20,
  }) async {
    final db = await DatabaseHelper.instance.database;
    Batch batch = db.batch();

    for (int i = 1; i <= setCount; i++) {
      ExerciseSets set = ExerciseSets(
        ExercisePerday_id: exercisePerDayId,
        repsCount: defaultReps,
        Kgs: defaultKgs,
        isFinsihed: 0,
      );
      batch.insert(exerciseSetTable, set.toMap());
      print('📌 Creating $setCount default sets for $exercisePerDayId');
    }

    await batch.commit();
  }
}
