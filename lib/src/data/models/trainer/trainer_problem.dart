import 'dart:convert';

import '/src/core/trainer_constants.dart';

class TrainerProblem {
  final String id;
  final String? factId;
  final String? lessonId;
  final String prompt;
  final String expectedAnswer;
  final InputType inputType;
  final List<String>? choices;
  final ProblemSource source;

  TrainerProblem({
    required this.id,
    required this.prompt,
    required this.expectedAnswer,
    required this.inputType,
    required this.source,
    this.factId,
    this.lessonId,
    this.choices,
  });

  factory TrainerProblem.fromMap(Map<String, dynamic> map) {
    final rawChoices = map['choices'];
    return TrainerProblem(
      id: map['id'] as String,
      factId: map['factId'] as String?,
      lessonId: map['lessonId'] as String?,
      prompt: map['prompt'] as String,
      expectedAnswer: map['expectedAnswer'] as String,
      inputType: inputTypeFromString(map['inputType'] as String),
      choices: rawChoices == null
          ? null
          : (jsonDecode(rawChoices.toString()) as List<dynamic>)
                .map((value) => value.toString())
                .toList(),
      source: problemSourceFromString(map['source'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'factId': factId,
      'lessonId': lessonId,
      'prompt': prompt,
      'expectedAnswer': expectedAnswer,
      'inputType': inputType.name,
      'choices': choices == null ? null : jsonEncode(choices),
      'source': source.name,
    };
  }
}
