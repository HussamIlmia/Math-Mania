import '/src/core/trainer_constants.dart';

class TrainerAttempt {
  final int? id;
  final String problemId;
  final String? factId;
  final String? lessonId;
  final int startedAt;
  final int endedAt;
  final int latencyMs;
  final int correct;
  final String userAnswer;
  final ProblemSource source;

  TrainerAttempt({
    this.id,
    required this.problemId,
    this.factId,
    this.lessonId,
    required this.startedAt,
    required this.endedAt,
    required this.latencyMs,
    required this.correct,
    required this.userAnswer,
    required this.source,
  });

  factory TrainerAttempt.fromMap(Map<String, dynamic> map) {
    return TrainerAttempt(
      id: map['id'] as int?,
      problemId: map['problemId'] as String,
      factId: map['factId'] as String?,
      lessonId: map['lessonId'] as String?,
      startedAt: map['startedAt'] as int,
      endedAt: map['endedAt'] as int,
      latencyMs: map['latencyMs'] as int,
      correct: map['correct'] as int,
      userAnswer: map['userAnswer'] as String,
      source: problemSourceFromString(map['source'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'problemId': problemId,
      'factId': factId,
      'lessonId': lessonId,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'latencyMs': latencyMs,
      'correct': correct,
      'userAnswer': userAnswer,
      'source': source.name,
    };
  }
}
