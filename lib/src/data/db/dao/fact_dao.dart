import 'package:sqflite/sqflite.dart';
import '/src/core/trainer_constants.dart';
import '/src/data/db/app_database.dart';
import '/src/data/models/trainer/fact.dart';

class FactDao {
  final AppDatabase appDatabase;

  FactDao(this.appDatabase);

  Future<void> upsert(Fact fact) {
    return appDatabase.database.insert(
      AppDatabase.tableFacts,
      fact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Fact>> getAll() async {
    final rows = await appDatabase.database.query(AppDatabase.tableFacts);
    return rows.map(Fact.fromMap).toList();
  }

  Future<bool> hasAny() async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableFacts,
      columns: ['id'],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<Fact?> getById(String id) async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableFacts,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Fact.fromMap(rows.first);
  }

  Future<List<Fact>> getByCategory(FactCategory category) async {
    final rows = await appDatabase.database.query(
      AppDatabase.tableFacts,
      where: "category = ?",
      whereArgs: [category.name],
    );
    return rows.map(Fact.fromMap).toList();
  }
}
