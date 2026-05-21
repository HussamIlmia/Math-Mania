import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '/src/core/trainer_constants.dart';
import '/src/data/db/dao/lesson_progress_dao.dart';
import '/src/data/models/trainer/lesson.dart';
import '/src/data/models/trainer/lesson_progress.dart';
import '/src/data/repository/lesson_repository.dart';

class PathProvider extends ChangeNotifier {
  PathProvider() {
    _lessonRepository = GetIt.I.get<LessonRepository>();
    _lessonProgressDao = GetIt.I.get<LessonProgressDao>();
    load();
  }

  late final LessonRepository _lessonRepository;
  late final LessonProgressDao _lessonProgressDao;

  bool loading = true;
  List<Lesson> lessons = [];
  final Map<String, LessonProgress?> progress = {};

  Future<void> load() async {
    lessons = _lessonRepository.all();
    final allProgress = await _lessonProgressDao.getAll();
    for (final item in allProgress) {
      progress[item.lessonId] = item;
    }
    loading = false;
    notifyListeners();
  }

  int get masteredLessonCount =>
      progress.values.where((item) => item?.state == LessonState.mastered).length;

  double get tierOneProgress {
    if (lessons.isEmpty) {
      return 0;
    }
    return masteredLessonCount / lessons.length;
  }

  bool isUnlocked(Lesson lesson) {
    final current = progress[lesson.id]?.state ?? LessonState.locked;
    final prereqs = lesson.prerequisiteLessonIds ?? [];
    if (prereqs.isEmpty) {
      return true;
    }
    return prereqs.every((id) {
      final state = progress[id]?.state;
      return state == LessonState.mastered;
    });
  }
}
