import '/src/core/trainer_constants.dart';
import '/src/data/models/trainer/fact_card.dart';
import '/src/data/srs/srs_scheduler.dart';

class Sm2LiteScheduler implements SrsScheduler {
  static const _dayInMs = 24 * 60 * 60 * 1000;

  const Sm2LiteScheduler();

  @override
  FactCard schedule(FactCard card, AttemptRating rating, int nowMs) {
    final progression = <int>[1, 3, 7, 14, 30];
    double ease = card.easeFactor;
    int reps = card.reps;
    int lapses = card.lapses;
    int nextIntervalDays = card.intervalDays;

    if (rating == AttemptRating.again) {
      lapses += 1;
      reps = 0;
      ease -= 0.2;
      nextIntervalDays = 1;
    } else {
      if (rating == AttemptRating.hard) {
        ease -= 0.15;
      } else if (rating == AttemptRating.easy) {
        ease += 0.1;
      }
      final nextRep = reps + 1;
      reps = nextRep;
      final progressionIndex = nextRep.clamp(0, progression.length - 1);
      nextIntervalDays = progression[progressionIndex];
    }

    final clampedEase = ease.clamp(1.3, 2.5);
    return card.copyWith(
      intervalDays: nextIntervalDays,
      easeFactor: clampedEase,
      dueAt: nowMs + nextIntervalDays * _dayInMs,
      reps: reps,
      lapses: lapses,
    );
  }
}
