import '/src/data/db/app_database.dart';
import '/src/data/models/trainer/trainer_attempt.dart';

class AttemptDao {
  final AppDatabase appDatabase;

  AttemptDao(this.appDatabase);

  Future<void> insertAttempt(TrainerAttempt attempt) {
    return appDatabase.database.insert(
      AppDatabase.tableAttempts,
      attempt.toMap(),
    );
  }

  Future<List<TrainerAttempt>> getByFactId(String factId) async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableAttempts,
      where: "factId = ?",
      whereArgs: [factId],
      orderBy: "endedAt DESC",
    );
    return rows.map(TrainerAttempt.fromMap).toList();
  }
}
