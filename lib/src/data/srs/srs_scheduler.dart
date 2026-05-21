import '/src/core/trainer_constants.dart';
import '/src/data/models/trainer/fact_card.dart';

abstract class SrsScheduler {
  FactCard schedule(FactCard card, AttemptRating rating, int nowMs);
}
