import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '/src/core/trainer_constants.dart';
import '/src/data/models/trainer/lesson.dart';
import '/src/data/repository/lesson_repository.dart';

class LessonProvider extends ChangeNotifier {
  LessonProvider({this.lessonId}) {
    _lessonRepository = GetIt.I.get<LessonRepository>();
    load();
  }

  final String? lessonId;
  late final LessonRepository _lessonRepository;

  bool loading = true;
  Lesson? lesson;
  LessonState state = LessonState.locked;

  Future<void> load() async {
    final all = _lessonRepository.all();
    if (all.isEmpty) {
      loading = false;
      state = LessonState.locked;
      notifyListeners();
      return;
    }
    final targetId = lessonId ?? LessonRepository.lesson1Id;
    lesson = all.firstWhere(
      (item) => item.id == targetId,
      orElse: () => all.first,
    );
    state = lesson == null ? LessonState.locked : LessonState.unlocked;
    loading = false;
    notifyListeners();
  }
}
