import 'package:sqflite/sqflite.dart';
import '../models/exercise_model.dart';
import '../database/db.dart';

class ExerciseServices {
  final String exerciseTable = 'Exercise';
  final String exercisePerDayTable = 'Exercise_per_day';

  Future<int> insertExercise(Exercise exercise) async {
    final db = await DatabaseHelper.instance.database;
    if (await exerciseNameExists(exercise.Ename)) {
      throw Exception('Exercise Name "${exercise.Ename}" already exists.');
    }
    try {
      return await db.insert(exerciseTable, exercise.toMap());
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Exercise Name "${exercise.Ename}" already exists.');
      }
      rethrow;
    }
  }

  Future<void> ensureDefaultExercises() async {
    final db = await DatabaseHelper.instance.database;

    // Check if exercises table is empty
    final List<Map<String, dynamic>> exercises = await db.query(exerciseTable);

    if (exercises.isEmpty) {
      await _insertDefaultExercises(db);
    }
  }

  Future<void> _insertDefaultExercises(Database db) async {
    List<String> exercises = [
      "Jumping Jacks",
      "Burpees",
      "Mountain Climbers",
      "High Knees",
      "Push-Ups",
      "Squats",
      "Plank",
      "Plank to Push-Up",
      "Inchworms",
      "Lunge with Twist",
      "Wall Sit",
      "Glute Bridge",
      "Step-Ups",
      "Side Plank",
      "Skaters",
      "Dumbbell Squats",
      "Dumbbell Shoulder Press",
      "Deadlifts",
      "Bent-over Rows",
      "Russian Twists",
      "Kettlebell Swings",
      "Clean and Press",
      "Renegade Rows",
      "Weighted Lunges",
    ];
    for (String exercise in exercises) {
      await db.insert(exerciseTable, {
        'Ename': exercise,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<List<Exercise>> getAllExercise() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(exerciseTable);
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  Future<Exercise?> getExerciseById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      exerciseTable,
      where: 'Eid = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Exercise.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Exercise>> getExercisesByDayId(int dayId) async {
    final db = await DatabaseHelper.instance.database;

    // Query using the junction table to get exercises for a specific day
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
    SELECT e.Eid, e.Ename, epd.Exercise_order 
    FROM $exerciseTable e
    INNER JOIN $exercisePerDayTable epd ON e.Eid = epd.Exercise_id
    WHERE epd.day_id = ?
    ORDER BY epd.Exercise_order ASC
  ''',
      [dayId],
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<int> deleteExercise(int Eid) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(exerciseTable, where: 'Eid=?', whereArgs: [Eid]);
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      exerciseTable,
      exercise.toMap(),
      where: 'Eid = ?',
      whereArgs: [exercise.Eid],
    );
  }

  Future<bool> exerciseNameExists(String name, {int? excludeId}) async {
    final db = await DatabaseHelper.instance.database;
    String whereClause = 'Ename = ?';
    List<dynamic> whereArgs = [name];

    if (excludeId != null) {
      whereClause += ' AND Eid != ?';
      whereArgs.add(excludeId);
    }

    final result = await db.query(
      exerciseTable,
      where: whereClause,
      whereArgs: whereArgs,
    );
    return result.isNotEmpty;
  }
}
