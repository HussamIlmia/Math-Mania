import '/src/data/db/app_database.dart';
import '/src/data/models/trainer/lesson_progress.dart';
import 'package:sqflite/sqflite.dart';

class LessonProgressDao {
  final AppDatabase appDatabase;

  LessonProgressDao(this.appDatabase);

  Future<void> upsert(LessonProgress progress) async {
    await appDatabase.database.insert(
      AppDatabase.tableLessonProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LessonProgress?> getByLessonId(String lessonId) async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableLessonProgress,
      where: "lessonId = ?",
      whereArgs: [lessonId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return LessonProgress.fromMap(rows.first);
  }

  Future<List<LessonProgress>> getAll() async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableLessonProgress,
      orderBy: "lessonId ASC",
    );
    return rows.map(LessonProgress.fromMap).toList();
  }

  Future<int> count() async {
    final rows = await appDatabase.database.rawQuery(
      "SELECT COUNT(*) AS total FROM ${AppDatabase.tableLessonProgress}",
    );
    return Sqflite.firstIntValue(rows) ?? 0;
  }
}
