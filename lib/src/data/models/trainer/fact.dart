import '/src/core/trainer_constants.dart';

class Fact {
  final String id;
  final FactCategory category;
  final String prompt;
  final String answer;

  Fact({
    required this.id,
    required this.category,
    required this.prompt,
    required this.answer,
  });

  factory Fact.fromMap(Map<String, dynamic> map) {
    return Fact(
      id: map['id'] as String,
      category: factCategoryFromString(map['category'] as String),
      prompt: map['prompt'] as String,
      answer: map['answer'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category.name,
      'prompt': prompt,
      'answer': answer,
    };
  }
}
