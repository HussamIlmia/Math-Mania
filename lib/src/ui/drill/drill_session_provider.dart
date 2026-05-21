import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '/src/core/trainer_constants.dart';
import '/src/data/db/dao/attempt_dao.dart';
import '/src/data/db/dao/lesson_progress_dao.dart';
import '/src/data/models/trainer/lesson_progress.dart';
import '/src/data/models/trainer/trainer_attempt.dart';
import '/src/data/models/trainer/trainer_problem.dart';
import '/src/data/repository/lesson_repository.dart';
import '/src/data/repository/trick_generators.dart';
import '/src/data/timing/timing_service.dart';

class DrillSessionProvider extends ChangeNotifier {
  DrillSessionProvider({required this.lessonId}) {
    _lessonRepository = GetIt.I.get<LessonRepository>();
    _attemptDao = GetIt.I.get<AttemptDao>();
    _lessonProgressDao = GetIt.I.get<LessonProgressDao>();
    _timingService = GetIt.I.get<TimingService>();
    _trickGenerators = const TrickGenerators();
    _load();
  }

  final String lessonId;
  late final LessonRepository _lessonRepository;
  late final AttemptDao _attemptDao;
  late final LessonProgressDao _lessonProgressDao;
  late final TimingService _timingService;
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
    final accuracy = (correct / total * 100).round().toDouble();
    final latencyMs = _medianLatency();
    final masteredNow = accuracy >= kMasteryAccuracyMinimumPercent &&
        latencyMs <= kMasteryMedianLatencyMs;
    final existing = await _lessonProgressDao.getByLessonId(lessonId);
    final wasMastered = existing?.state == LessonState.mastered;
    final nextState = (masteredNow || wasMastered)
        ? LessonState.mastered
        : LessonState.inProgress;
    final bestAccuracy = existing == null
        ? accuracy
        : (accuracy > existing.bestAccuracy ? accuracy : existing.bestAccuracy);
    final int? existingBestLatency =
        existing != null && existing.bestMedianLatencyMs > 0
            ? existing.bestMedianLatencyMs
            : null;
    final int bestLatencyMs = existingBestLatency == null
        ? latencyMs
        : (latencyMs > 0 && latencyMs < existingBestLatency
            ? latencyMs
            : existingBestLatency);
    final masteredAt = wasMastered
        ? existing!.masteredAt
        : (masteredNow ? DateTime.now().millisecondsSinceEpoch : null);
    await _lessonProgressDao.upsert(
      LessonProgress(
        lessonId: lessonId,
        state: nextState,
        bestAccuracy: bestAccuracy,
        bestMedianLatencyMs: bestLatencyMs,
        masteredAt: masteredAt,
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
