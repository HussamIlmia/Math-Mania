import '/src/data/models/trainer/lesson_slide.dart';
import '/src/data/models/trainer/drill_spec.dart';

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final List<LessonSlide> slides;
  final String trickId;
  final int targetCount;
  final int targetLatencyMs;
  final List<String>? prerequisiteLessonIds;

  Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.slides,
    required this.trickId,
    required this.targetCount,
    required this.targetLatencyMs,
    this.prerequisiteLessonIds,
  });

  DrillSpec toDrillSpec() {
    return DrillSpec(
      trickId: trickId,
      count: targetCount,
      targetLatencyMs: targetLatencyMs,
    );
  }
}
