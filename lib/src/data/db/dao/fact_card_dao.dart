import 'package:sqflite/sqflite.dart';
import '/src/data/db/app_database.dart';
import '/src/data/models/trainer/fact_card.dart';

class FactCardDao {
  final AppDatabase appDatabase;

  FactCardDao(this.appDatabase);

  Future<void> upsert(FactCard card) async {
    await appDatabase.database.insert(
      AppDatabase.tableFactCards,
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<FactCard?> getByFactId(String factId) async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableFactCards,
      where: "factId = ?",
      whereArgs: [factId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return FactCard.fromMap(rows.first);
  }

  Future<List<FactCard>> dueCards(int nowMs) async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableFactCards,
      where: "dueAt <= ?",
      whereArgs: [nowMs],
      orderBy: "dueAt ASC",
    );
    return rows.map(FactCard.fromMap).toList();
  }

  Future<List<FactCard>> getAll() async {
    final rows = await appDatabase.database.query(AppDatabase.tableFactCards);
    return rows.map(FactCard.fromMap).toList();
  }
}
