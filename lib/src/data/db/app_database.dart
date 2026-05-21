import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  final Database database;

  AppDatabase._(this.database);

  static const String tableFacts = "facts";
  static const String tableFactCards = "fact_cards";
  static const String tableAttempts = "attempts";
  static const String tableLessonProgress = "lesson_progress";

  static Future<AppDatabase> open({String? databaseName}) async {
    final dbName = databaseName ?? "math_mania_trainer.db";
    final dbPath = await getDatabasesPath();
    final path = dbName == ':memory:'
        ? dbName
        : join(dbPath, dbName);
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $tableFacts (
            id TEXT PRIMARY KEY,
            category TEXT NOT NULL,
            prompt TEXT NOT NULL,
            answer TEXT NOT NULL
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE $tableFactCards (
            factId TEXT PRIMARY KEY,
            intervalDays INTEGER NOT NULL,
            easeFactor REAL NOT NULL,
            dueAt INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            lapses INTEGER NOT NULL,
            lastLatencyMs INTEGER NOT NULL
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE $tableAttempts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            problemId TEXT NOT NULL,
            factId TEXT,
            lessonId TEXT,
            startedAt INTEGER NOT NULL,
            endedAt INTEGER NOT NULL,
            latencyMs INTEGER NOT NULL,
            correct INTEGER NOT NULL,
            userAnswer TEXT NOT NULL,
            source TEXT NOT NULL
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE $tableLessonProgress (
            lessonId TEXT PRIMARY KEY,
            state TEXT NOT NULL,
            bestAccuracy REAL NOT NULL,
            bestMedianLatencyMs INTEGER NOT NULL,
            masteredAt INTEGER
          )
          ''',
        );
      },
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
    );
    return AppDatabase._(database);
  }

  Future<void> close() => database.close();
}
