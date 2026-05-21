import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '/src/core/trainer_constants.dart';
import '/src/data/db/dao/attempt_dao.dart';
import '/src/data/db/dao/fact_card_dao.dart';
import '/src/data/db/dao/lesson_progress_dao.dart';
import '/src/data/models/trainer/drill_spec.dart';
import '/src/data/models/trainer/lesson_progress.dart';
import '/src/data/models/trainer/trainer_attempt.dart';
import '/src/data/models/trainer/trainer_problem.dart';
import '/src/data/repository/lesson_repository.dart';
import '/src/data/repository/trick_generators.dart';
import '/src/data/srs/srs_scheduler.dart';
import '/src/data/timing/timing_service.dart';

class DrillSessionProvider extends ChangeNotifier {
  DrillSessionProvider({required this.lessonId}) {
    _lessonRepository = GetIt.I.get<LessonRepository>();
    _attemptDao = GetIt.I.get<AttemptDao>();
    _factCardDao = GetIt.I.get<FactCardDao>();
    _lessonProgressDao = GetIt.I.get<LessonProgressDao>();
    _timingService = GetIt.I.get<TimingService>();
    _scheduler = GetIt.I.get<SrsScheduler>();
    _trickGenerators = const TrickGenerators();
    _load();
  }

  final String lessonId;
  late final LessonRepository _lessonRepository;
  late final AttemptDao _attemptDao;
  late final FactCardDao _factCardDao;
  late final LessonProgressDao _lessonProgressDao;
  late final TimingService _timingService;
  late final SrsScheduler _scheduler;
  late final TrickGenerators _trickGenerators;

  bool loading = true;
  List<TrainerProblem> problems = [];
  int index = 0;
  int total = 0;
  String currentInput = '';
  bool finished = false;
  int correct = 0;
  final List<int> _latencies = <int>[];

  Future<void> _load() async {
    final lesson = _lessonRepository.all().firstWhere(
      (item) => item.id == lessonId,
      orElse: () => _lessonRepository.all().first,
    );
    problems = _trickGenerators.generateMul11(lesson.targetCount);
    total = problems.length;
    loading = false;
    _startProblem();
    notifyListeners();
  }

  TrainerProblem? get currentProblem =>
      problems.isNotEmpty ? problems[index] : null;

  void addDigit(String value) {
    currentInput = "$currentInput$value";
    notifyListeners();
  }

  void setInput(String value) {
    currentInput = value;
    notifyListeners();
  }

  void removeDigit() {
    if (currentInput.isNotEmpty) {
      currentInput = currentInput.substring(0, currentInput.length - 1);
      notifyListeners();
    }
  }

  void clear() {
    currentInput = '';
    notifyListeners();
  }

  Future<void> submit() async {
    final problem = currentProblem;
    if (problem == null || currentInput.isEmpty) return;
    final startedAt = _timingService.startedAt();
    final endedAt = DateTime.now().millisecondsSinceEpoch;
    _timingService.end();
    final latency = endedAt - startedAt;
    final isCorrect = currentInput == problem.expectedAnswer;
    if (isCorrect) {
      correct += 1;
    }
    _latencies.add(latency);
    await _attemptDao.insertAttempt(
      TrainerAttempt(
        problemId: problem.id,
        factId: problem.factId,
        lessonId: problem.lessonId,
        startedAt: startedAt,
        endedAt: endedAt,
        latencyMs: latency,
        correct: isCorrect ? 1 : 0,
        userAnswer: currentInput,
        source: ProblemSource.drill,
      ),
    );

    if (index < problems.length - 1) {
      index += 1;
      currentInput = '';
      _startProblem();
      notifyListeners();
      return;
    }
    finished = true;
    await _saveLessonResult();
    notifyListeners();
  }

  Future<void> _saveLessonResult() async {
    final accuracy = (correct / total * 100).round();
    final latencyMs = _medianLatency();
    final state = (accuracy >= kMasteryAccuracyMinimumPercent &&
            latencyMs <= kMasteryMedianLatencyMs)
        ? LessonState.mastered
        : LessonState.inProgress;
    await _lessonProgressDao.upsert(
      LessonProgress(
        lessonId: lessonId,
        state: state,
        bestAccuracy: accuracy.toDouble(),
        bestMedianLatencyMs: latencyMs,
        masteredAt: state == LessonState.mastered
            ? DateTime.now().millisecondsSinceEpoch
            : null,
      ),
    );
  }

  Future<void> _startProblem() {
    _timingService.start();
    return Future.value();
  }

  int _medianLatency() {
    if (_latencies.isEmpty) return 0;
    final sorted = [..._latencies]..sort();
    return sorted[sorted.length ~/ 2];
  }

  int get accuracyPercent {
    if (total == 0) {
      return 0;
    }
    return (correct / total * 100).round();
  }

  int get medianLatencyMs => _medianLatency();
}
