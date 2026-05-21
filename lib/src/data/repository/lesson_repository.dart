import '/src/core/trainer_constants.dart';
import '/src/data/models/trainer/lesson.dart';
import '/src/data/models/trainer/lesson_slide.dart';

class LessonRepository {
  static const String lesson1Id = "lesson_mul11";

  List<Lesson> all() {
    return <Lesson>[
      Lesson(
        id: lesson1Id,
        title: "Multiply by 11",
        subtitle: "Start here and build a fast mental arithmetic habit.",
        slides: [
          LessonSlide(
            order: 1,
            title: "Rule",
            body:
                "For 73 x 11, add 7 and 3 to get 10, then place it in the middle: 803.",
          ),
          LessonSlide(
            order: 2,
            title: "Worked Example",
            body:
                "Try: 47 x 11 = 4  (4+7=11)  7. Place carry: 517.",
          ),
        ],
        trickId: "mul11",
        targetCount: kDrillProblemCount,
        targetLatencyMs: kSessionTargetLatencyMs,
      ),
    ];
  }
}

