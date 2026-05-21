import 'package:flutter_test/flutter_test.dart';
import 'package:math_mania/src/core/trainer_constants.dart';
import 'package:math_mania/src/data/models/trainer/fact_card.dart';
import 'package:math_mania/src/data/srs/sm2_lite_scheduler.dart';

void main() {
  const scheduler = Sm2LiteScheduler();

  test('Fresh card good path follows progression steps', () {
    final started = DateTime.now().millisecondsSinceEpoch;
    final card = FactCard(
      factId: 'mul_2x3',
      intervalDays: 1,
      easeFactor: 2.5,
      dueAt: started,
      reps: 0,
      lapses: 0,
      lastLatencyMs: 500,
    );

    final good1 = scheduler.schedule(card, AttemptRating.good, started);
    expect(good1.intervalDays, 3);
    final good2 = scheduler.schedule(good1, AttemptRating.good, started);
    expect(good2.intervalDays, 7);
    final good3 = scheduler.schedule(good2, AttemptRating.good, started);
    expect(good3.intervalDays, 14);
  });

  test('Again resets interval and lapses', () {
    final card = FactCard(
      factId: 'mul_2x3',
      intervalDays: 7,
      easeFactor: 2.5,
      dueAt: 0,
      reps: 2,
      lapses: 0,
      lastLatencyMs: 800,
    );
    final again = scheduler.schedule(card, AttemptRating.again, 0);
    expect(again.intervalDays, 1);
    expect(again.lapses, 1);
    expect(again.reps, 0);
  });

  test('Ease is clamped between 1.3 and 2.5', () {
    var card = FactCard(
      factId: 'mul_2x3',
      intervalDays: 1,
      easeFactor: 1.4,
      dueAt: 0,
      reps: 0,
      lapses: 0,
      lastLatencyMs: 500,
    );
    for (var i = 0; i < 10; i++) {
      card = scheduler.schedule(card, AttemptRating.again, 0);
    }
    expect(card.easeFactor, inInclusiveRange(1.3, 2.5));
  });
}
