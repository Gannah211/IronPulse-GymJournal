import 'package:sqflite/sqflite.dart';
import '../models/day_model.dart';
import '../database/db.dart';

class DayServices {
  final String daysTable = 'Days';
  final String exerciseTable = 'Exercise';

  // Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //     if (oldVersion < 2) {
  //       // Add unique constraints to existing tables (case-sensitive)
  //       await db.execute(
  //         'CREATE UNIQUE INDEX IF NOT EXISTS idx_days_name ON $daysTable(Dname)',
  //       );
  //       await db.execute(
  //         'CREATE UNIQUE INDEX IF NOT EXISTS idx_exercise_name ON $exerciseTable(Ename)',
  //       );

  //       // Clean up exact duplicates only
  //       await _cleanupExactDaysDuplicates(db);
  //     }
  //   }

  Future<void> _cleanupExactDaysDuplicates(Database db) async {
    // Clean up exact duplicate days - keep the first occurrence
    await db.execute('''
      DELETE FROM $daysTable 
      WHERE Did NOT IN (
        SELECT MIN(Did) 
        FROM $daysTable 
        GROUP BY Dname
      )
    ''');

    // Clean up exact duplicate exercises - keep the first occurrence
    await db.execute('''
      DELETE FROM $exerciseTable 
      WHERE Eid NOT IN (
        SELECT MIN(Eid) 
        FROM $exerciseTable 
        GROUP BY Ename
      )
    ''');
  }

  Future<int> insertDay(Days day) async {
    final db = await DatabaseHelper.instance.database;
    if (await dayNameExists(day.Dname)) {
      throw Exception('Day name "${day.Dname}" already exists.');
    }
    try {
      return await db.insert(daysTable, day.toMap());
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Day name "${day.Dname}" already exists');
      }
      rethrow;
    }
  }

  Future<List<Days>> getAllDays() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(daysTable);
    return List.generate(maps.length, (i) => Days.fromMap(maps[i]));
  }

  Future<Days?> getDayById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      daysTable,
      where: 'Did = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Days.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteDay(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(daysTable, where: 'Did=?', whereArgs: [id]);
  }

  Future<int> updateDay(Days day) async {
    final db = await DatabaseHelper.instance.database;

    if (await dayNameExists(day.Dname, excludeId: day.Did)) {
      throw Exception('Day name "${day.Dname}" already exists.');
    }
    try {
      return await db.update(
        daysTable,
        day.toMap(),
        where: 'Did = ?',
        whereArgs: [day.Did],
      );
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Day name "${day.Dname}" already exists.');
      }
      rethrow;
    }
  }

  // Method to manually clean up exact duplicates only (can be called anytime)
  Future<void> cleanupAllDuplicates() async {
    final db = await DatabaseHelper.instance.database;
    await _cleanupExactDaysDuplicates(db);
  }

  Future<bool> dayNameExists(String name, {int? excludeId}) async {
    final db = await DatabaseHelper.instance.database;
    String whereClause = 'Dname = ?';
    List<dynamic> whereArgs = [name];

    if (excludeId != null) {
      whereClause += ' AND Did != ?';
      whereArgs.add(excludeId);
    }

    final result = await db.query(
      daysTable,
      where: whereClause,
      whereArgs: whereArgs,
    );
    return result.isNotEmpty;
  }

  Future<void> updateDayName(int dayId, String dayName) async {
    // final db = await DatabaseHelper.instance.database;
    final updatedDay = Days(Dname: dayName, Did: dayId);
    await updateDay(updatedDay);
    print("Day name updated sucessfully!!!");
  }
}
