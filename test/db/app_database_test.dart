import 'package:flutter_test/flutter_test.dart';
import 'package:math_mania/src/core/trainer_constants.dart';
import 'package:math_mania/src/data/db/app_database.dart';
import 'package:math_mania/src/data/db/dao/attempt_dao.dart';
import 'package:math_mania/src/data/db/dao/fact_card_dao.dart';
import 'package:math_mania/src/data/models/trainer/fact_card.dart';
import 'package:math_mania/src/data/models/trainer/trainer_attempt.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  bool ffiReady = false;

  setUpAll(() {
    try {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      ffiReady = true;
    } catch (_) {
      ffiReady = false;
    }
  });

  test('In-memory db operations', () async {
    if (!ffiReady) {
      markTestSkipped(
        'sqflite_common_ffi could not initialize on this host '
        '(sqlite3 native library not available); skipping DB test.',
      );
      return;
    }
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
