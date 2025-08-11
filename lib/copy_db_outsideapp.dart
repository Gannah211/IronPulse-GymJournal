import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> copyDatabaseToDownloads() async {
  try {
    // أولاً: نجيب مكان قاعدة البيانات القديمة
    String dbPath = await getDatabasesPath();
    String sourcePath = join(dbPath, 'workout_progress.db');

    // ثانياً: نجيب مكان الـ Downloads في المحاكي
    Directory? downloadsDirectory = await getExternalStorageDirectory();

    // علشان بعض الأجهزة ما ترجعش الـ Download مباشرة (فنعمل شوية تعديل):
    String downloadsPath = downloadsDirectory!.path.replaceFirst(
      "Android/data/اسم_الباكيج/files",
      "Download",
    );

    // ثالثاً: نحدد مكان النسخة الجديدة
    String targetPath = join(downloadsPath, 'workout_progress_copy.db');

    // رابعاً: ننسخ الملف
    File sourceFile = File(sourcePath);
    await sourceFile.copy(targetPath);

    print('Database copied successfully to: $targetPath');
  } catch (e) {
    print('Error copying database: $e');
  }
}
