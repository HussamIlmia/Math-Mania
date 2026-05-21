import 'package:flutter_test/flutter_test.dart';
import '/src/data/db/app_database.dart';
import '/src/data/db/dao/attempt_dao.dart';
import '/src/data/db/dao/fact_card_dao.dart';
import '/src/data/models/trainer/fact_card.dart';
import '/src/data/models/trainer/trainer_attempt.dart';
import '/src/core/trainer_constants.dart';

void main() {
  test('In-memory db operations', () async {
    final db = await AppDatabase.open(databaseName: ':memory:');
    final factCardDao = FactCardDao(db);
    final attemptDao = AttemptDao(db);

    await factCardDao.upsert(
      FactCard(
        factId: 'mul_2x3',
        intervalDays: 3,
        easeFactor: 2.5,
        dueAt: 10,
        reps: 1,
        lapses: 0,
        lastLatencyMs: 1000,
      ),
    );
    final card = await factCardDao.getByFactId('mul_2x3');
    expect(card?.factId, 'mul_2x3');

    final due = await factCardDao.dueCards(11);
    expect(due.length, 1);

    await attemptDao.insertAttempt(
      TrainerAttempt(
        problemId: 'p1',
        factId: 'mul_2x3',
        lessonId: null,
        startedAt: 0,
        endedAt: 100,
        latencyMs: 100,
        correct: 1,
        userAnswer: '6',
        source: ProblemSource.drill,
      ),
    );
    final attempts = await attemptDao.getByFactId('mul_2x3');
    expect(attempts.length, 1);

    await db.close();
  });
}
