import 'dart:math';

import '/src/core/trainer_constants.dart';
import '/src/data/models/trainer/trainer_problem.dart';

class TrickGenerators {
  const TrickGenerators();

  List<TrainerProblem> generateMul11(int count) {
    final list = <TrainerProblem>[];
    final random = Random();
    while (list.length < count) {
      final left = 12 + random.nextInt(88);
      final prompt = "$left x 11";
      final answer = (left * 11).toString();
      final id = "mul11_${left}_$count_${list.length}";
      list.add(
        TrainerProblem(
          id: id,
          factId: "mul_${left}x11",
          lessonId: "lesson_mul11",
          prompt: prompt,
          expectedAnswer: answer,
          inputType: InputType.numeric,
          source: ProblemSource.drill,
          choices: null,
        ),
      );
    }
    return list;
  }
}

