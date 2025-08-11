import 'package:sqflite/sqflite.dart';
import '../models/exercise_per_day_model.dart';
import '../database/db.dart';
import '../services/day_services.dart';

class DBService {
  final String daysTable = 'Days';
  final String exerciseTable = 'Exercise';
  final String exercisePerDayTable = 'Exercise_per_day';
  final String exerciseSetTable = 'Exercise_Set';

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $daysTable(
    Did INTEGER PRIMARY KEY AUTOINCREMENT,
    Dname TEXT NOT NULL
    )''');
    await db.execute('''
    CREATE TABLE $exerciseTable(
    Eid INTEGER PRIMARY KEY AUTOINCREMENT,
    Ename TEXT NOT NULL
    )''');
    await db.execute('''
    CREATE TABLE $exercisePerDayTable(
    EPDid INTEGER PRIMARY KEY AUTOINCREMENT,
    day_id INTEGER,
    Exercise_id INTEGER,
    Exercise_order INTEGER,
    FOREIGN KEY(day_id) REFERENCES $daysTable(Did),
    FOREIGN KEY(Exercise_id) REFERENCES $exerciseTable(Eid)
    )''');
    await db.execute('''
    CREATE TABLE $exerciseSetTable(
    ESid INTEGER PRIMARY KEY AUTOINCREMENT,
    ExercisePerday_id INTEGER,
    repsCount INTEGER NOT NULL,
    Kgs INTEGER NOT NULL,
    isFinsihed INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(ExercisePerday_id) REFERENCES $exercisePerDayTable(EPDid)
    )''');

    await _insertDefaultExercises(db);
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

  // ==================== HELPER METHODS ====================
  Future<void> insertExercisesForDay(int dayId, List<int> exerciseIDs) async {
    final db = await DatabaseHelper.instance.database;
    Batch batch = db.batch();
    for (int i = 0; i < exerciseIDs.length; i++) {
      ExercisePerDay exercisePerDay = ExercisePerDay(
        day_id: dayId,
        Exercise_order: i + 1,
        Exercise_id: exerciseIDs[i],
      );
      batch.insert(exercisePerDayTable, exercisePerDay.toMap());
    }
    await batch.commit();
  }

  Future<void> deleteExerciseForDay(int dayId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      exercisePerDayTable,
      where: 'day_id = ?',
      whereArgs: [dayId],
    );
  }

  Future<Map<String, dynamic>> getCompleteWorkoutData(int dayId) async {
    final db = await DatabaseHelper.instance.database;
    final dayData = await DayServices().getDayById(dayId);

    final exercisesWithSets = await db.rawQuery(
      '''
SELECT 
        ed.EPDid, 
        ed.Exercise_order, 
        e.Ename,
        es.ESid,
        es.repsCount,
        es.Kgs,
        es.isFinsihed
      FROM $exercisePerDayTable ed
      JOIN $exerciseTable e ON ed.Exercise_id = e.Eid
      LEFT JOIN $exerciseSetTable es ON ed.EPDid = es.ExercisePerday_id
      WHERE ed.day_id = ?
      ORDER BY ed.Exercise_order ASC, es.ESid ASC
    ''',
      [dayId],
    );
    return {'day': dayData, 'exercises': exercisesWithSets};
  }
}
