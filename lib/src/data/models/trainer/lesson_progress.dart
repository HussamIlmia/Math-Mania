import '/src/core/trainer_constants.dart';

class LessonProgress {
  final String lessonId;
  final LessonState state;
  final double bestAccuracy;
  final int bestMedianLatencyMs;
  final int? masteredAt;

  LessonProgress({
    required this.lessonId,
    required this.state,
    required this.bestAccuracy,
    required this.bestMedianLatencyMs,
    this.masteredAt,
  });

  factory LessonProgress.fromMap(Map<String, dynamic> map) {
    return LessonProgress(
      lessonId: map['lessonId'] as String,
      state: lessonStateFromString(map['state'] as String),
      bestAccuracy: (map['bestAccuracy'] as num).toDouble(),
      bestMedianLatencyMs: map['bestMedianLatencyMs'] as int,
      masteredAt: map['masteredAt'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lessonId': lessonId,
      'state': state.name,
      'bestAccuracy': bestAccuracy,
      'bestMedianLatencyMs': bestMedianLatencyMs,
      'masteredAt': masteredAt,
    };
  }

  LessonProgress copyWith({
    LessonState? state,
    double? bestAccuracy,
    int? bestMedianLatencyMs,
    int? masteredAt,
  }) {
    return LessonProgress(
      lessonId: lessonId,
      state: state ?? this.state,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
      bestMedianLatencyMs: bestMedianLatencyMs ?? this.bestMedianLatencyMs,
      masteredAt: masteredAt,
    );
  }
}
