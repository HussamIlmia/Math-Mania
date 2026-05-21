enum InputType { numeric, multipleChoice, classify }

enum ProblemSource { diagnostic, srs, drill }

enum FactCategory {
  multiplication,
  square,
  complement100,
  fractionDecimal,
  other,
}

enum LessonState { locked, unlocked, inProgress, mastered }

enum AttemptRating { again, hard, good, easy }

const int kMasteryAccuracyMinimumPercent = 85;
const int kMasteryMedianLatencyMs = 3000;
const int kDiagnosticFastLatencyMs = 1500;
const int kSessionTargetLatencyMs = 3000;
const int kDrillProblemCount = 20;
const double kDefaultEaseFactor = 2.5;
const int kDefaultIntervalDays = 1;

const String kMetaSeededFlag = "trainer_seeded_v1";

InputType inputTypeFromString(String value) {
  return InputType.values.firstWhere(
    (type) => type.name == value,
    orElse: () => InputType.numeric,
  );
}

ProblemSource problemSourceFromString(String value) {
  return ProblemSource.values.firstWhere(
    (type) => type.name == value,
    orElse: () => ProblemSource.drill,
  );
}

LessonState lessonStateFromString(String value) {
  return LessonState.values.firstWhere(
    (type) => type.name == value,
    orElse: () => LessonState.locked,
  );
}

FactCategory factCategoryFromString(String value) {
  return FactCategory.values.firstWhere(
    (type) => type.name == value,
    orElse: () => FactCategory.other,
  );
}
