import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '/src/data/db/dao/fact_card_dao.dart';
import '/src/data/db/dao/lesson_progress_dao.dart';
import '/src/data/models/trainer/fact_card.dart';
import '/src/data/models/trainer/lesson.dart';
import '/src/data/models/trainer/lesson_progress.dart';
import '/src/data/repository/lesson_repository.dart';

class TodayProvider extends ChangeNotifier {
  TodayProvider() {
    _factCardDao = GetIt.I.get<FactCardDao>();
    _lessonProgressDao = GetIt.I.get<LessonProgressDao>();
    _lessonRepository = GetIt.I.get<LessonRepository>();
    load();
  }

  late final FactCardDao _factCardDao;
  late final LessonProgressDao _lessonProgressDao;
  late final LessonRepository _lessonRepository;

  bool loading = true;
  List<FactCard> dueCards = [];
  Lesson? lesson;
  LessonProgress? lessonProgress;

  Future<void> load() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    dueCards = await _factCardDao.dueCards(now);
    final lessons = _lessonRepository.all();
    lesson = lessons.isNotEmpty ? lessons.first : null;
    if (lesson != null) {
      lessonProgress = await _lessonProgressDao.getByLessonId(lesson!.id);
    }
    loading = false;
    notifyListeners();
  }

  int get dueCount => dueCards.length;
}
