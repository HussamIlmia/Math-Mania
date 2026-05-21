import 'dart:math';

import '/src/core/trainer_constants.dart';
import '/src/data/db/dao/fact_dao.dart';
import '/src/data/models/trainer/fact.dart';

class FactRepository {
  final FactDao factDao;

  FactRepository(this.factDao);

  Future<void> seedIfEmpty() async {
    final hasRows = await factDao.hasAny();
    if (hasRows) {
      return;
    }
    for (int left = 1; left <= 12; left++) {
      for (int right = 1; right <= 12; right++) {
        final factId = "mul_${left}x$right";
        await factDao.upsert(
          Fact(
            id: factId,
            category: FactCategory.multiplication,
            prompt: "$left x $right",
            answer: (left * right).toString(),
          ),
        );
      }
    }
  }

  Future<List<Fact>> all() => factDao.getAll();

  Future<Fact?> getById(String id) => factDao.getById(id);

  Future<List<Fact>> getMultiplicationFacts({
    int minMultiplier = 3,
    int maxMultiplier = 12,
  }) async {
    final all = await factDao.getByCategory(FactCategory.multiplication);
    final filtered = all
        .where((fact) {
          final parts = fact.id.split('_').last.split('x');
          if (parts.length != 2) {
            return false;
          }
          final first = int.tryParse(parts[0]);
          final second = int.tryParse(parts[1]);
          return first != null &&
              second != null &&
              first >= minMultiplier &&
              second >= minMultiplier &&
              second <= maxMultiplier;
        })
        .toList();
    filtered.shuffle(Random());
    return filtered.length > 12 ? filtered.sublist(0, 12) : filtered;
  }

  Future<List<Fact>> sampleMultiplication({int count = 12}) async {
    final facts = await factDao.getByCategory(FactCategory.multiplication);
    facts.shuffle(Random());
    return facts.take(count).toList();
  }
}
