// import 'package:sqflite/sqflite.dart';
import '../models/exercise_per_day_model.dart';
import '../database/db.dart';

class ExercisePerDayServices {
  final String exercisePerDayTable = 'Exercise_per_day';

  Future<int> insertExercisePerDay(ExercisePerDay exercisePerDay) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(exercisePerDayTable, exercisePerDay.toMap());
  }

  Future<List<ExercisePerDay>> getExercisesForDay(int dayId) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      exercisePerDayTable,
      where: 'day_id = ?',
      whereArgs: [dayId],
      orderBy: 'Exercise_order ASC',
    );
    return List.generate(maps.length, (i) => ExercisePerDay.fromMap(maps[i]));
  }

  Future<List<Map<String, dynamic>>> getExercisesWithNamesForDays(
    int dayId,
  ) async {
    print("🔍 getExercisesWithNamesForDays called for dayId: $dayId");
    final db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
  SELECT ed.EPDid, ed.day_id, ed.Exercise_id, ed.Exercise_order, e.Ename
      FROM Exercise_per_day ed
      JOIN Exercise e ON ed.Exercise_id = e.Eid
      WHERE ed.day_id = ?
      ORDER BY ed.Exercise_order
    ''',
      [dayId],
    );
    print("📊 Found ${maps.length} exercises for dayId $dayId:");
    for (int i = 0; i < maps.length; i++) {
      final exercise = maps[i];
      print(
        "  ${i + 1}. EPDid: ${exercise['EPDid']}, Name: ${exercise['Ename']}, Order: ${exercise['Exercise_order']}",
      );
    }
    return maps;
  }

  Future<int> updateExercisePerDay(ExercisePerDay exercisePerDay) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      exercisePerDayTable,
      exercisePerDay.toMap(),
      where: 'EPDid = ?',
      whereArgs: [exercisePerDay.EPDid],
    );
  }

  Future<int> deleteExercisePerDay(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      exercisePerDayTable,
      where: 'EPDid = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateExerciseOrder(int exercisePerDayId, int newOrder) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      exercisePerDayTable,
      {'Exercise_order': newOrder},
      where: 'EPDid = ?',
      whereArgs: [exercisePerDayId],
    );
  }

  Future<void> updateExerciseOrders(List<Map<String, dynamic>> updates) async {
    print("🔄 updateExerciseOrders called with ${updates.length} updates");

    final db = await DatabaseHelper.instance.database;
    // Batch batch = db.batch();

    try {
      await db.transaction((txn) async {
        print("📝 Starting transaction...");

        for (int i = 0; i < updates.length; i++) {
          final update = updates[i];
          print(
            "  Updating ${i + 1}/${updates.length}: EPDid ${update['EPDid']} to order ${update['Exercise_order']}",
          );

          final result = await txn.update(
            exercisePerDayTable,
            {'Exercise_order': update['Exercise_order']},
            where: 'EPDid = ?',
            whereArgs: [update['EPDid']],
          );

          print("    Result: $result rows affected");

          if (result == 0) {
            print(
              "    ⚠️ WARNING: No rows were updated for EPDid ${update['EPDid']}",
            );
          }
        }

        print("✅ Transaction completed successfully");
      });

      print("🔍 Verifying updates after transaction...");
      // Verify the updates
      for (final update in updates) {
        final verification = await db.query(
          exercisePerDayTable,
          where: 'EPDid = ?',
          whereArgs: [update['EPDid']],
        );

        if (verification.isNotEmpty) {
          final actualOrder = verification.first['Exercise_order'];
          final expectedOrder = update['Exercise_order'];
          if (actualOrder == expectedOrder) {
            print(
              "  ✅ EPDid ${update['EPDid']}: Expected $expectedOrder, Got $actualOrder",
            );
          } else {
            print(
              "  ❌ EPDid ${update['EPDid']}: Expected $expectedOrder, Got $actualOrder",
            );
          }
        } else {
          print("  ❌ EPDid ${update['EPDid']}: Not found in database!");
        }
      }
    } catch (e) {
      print("❌ Error in updateExerciseOrders: $e");
      rethrow;
    }
  }

  Future<void> debugPrintExerciseOrders(int dayId) async {
    final db = await DatabaseHelper.instance.database;
    final exercises = await db.rawQuery(
      '''
      SELECT ed.EPDid, ed.Exercise_order, e.Ename
      FROM Exercise_per_day ed
      JOIN Exercise e ON ed.Exercise_id = e.Eid
      WHERE ed.day_id = ?
      ORDER BY ed.Exercise_order ASC
      ''',
      [dayId],
    );

    print("=== Debug Exercise Orders for Day $dayId ===");
    for (var exercise in exercises) {
      print(
        "EPDid: ${exercise['EPDid']}, Order: ${exercise['Exercise_order']}, Name: ${exercise['Ename']}",
      );
    }
    print("=== End Debug ===");
  }
}
