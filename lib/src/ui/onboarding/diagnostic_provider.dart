import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/core/trainer_constants.dart';
import '/src/data/db/dao/attempt_dao.dart';
import '/src/data/db/dao/fact_card_dao.dart';
import '/src/data/models/trainer/fact_card.dart';
import '/src/data/models/trainer/trainer_attempt.dart';
import '/src/data/models/trainer/trainer_problem.dart';
import '/src/data/repository/fact_repository.dart';
import '/src/data/srs/srs_scheduler.dart';
import '/src/data/timing/timing_service.dart';

class DiagnosticProvider extends ChangeNotifier {
  DiagnosticProvider() {
    _factRepository = GetIt.I.get<FactRepository>();
    _factCardDao = GetIt.I.get<FactCardDao>();
    _attemptDao = GetIt.I.get<AttemptDao>();
    _srsScheduler = GetIt.I.get<SrsScheduler>();
    _timingService = GetIt.I.get<TimingService>();
    _preferences = GetIt.I.get<SharedPreferences>();
  }

  late final FactRepository _factRepository;
  late final FactCardDao _factCardDao;
  late final AttemptDao _attemptDao;
  late final SrsScheduler _srsScheduler;
  late final TimingService _timingService;
  late final SharedPreferences _preferences;
  Timer? _flashTimer;
  bool _isDisposed = false;

  List<TrainerProblem> problems = [];
  bool loading = true;
  bool completed = false;
  bool isSubmitting = false;
  int index = 0;
  String currentInput = '';
  int? _currentStartedAt;

  int? get currentStartedAt => _currentStartedAt;

  Future<void> start() async {
    if (problems.isNotEmpty) {
      return;
    }
    final facts = await _factRepository.getMultiplicationFacts();
    problems = facts
        .where((fact) => fact.id.startsWith("mul_"))
        .map(
          (fact) => TrainerProblem(
            id: "diag_${fact.id}",
            factId: fact.id,
            lessonId: null,
            prompt: fact.prompt,
            expectedAnswer: fact.answer,
            inputType: InputType.numeric,
            source: ProblemSource.diagnostic,
            choices: null,
          ),
        )
        .toList();
    if (problems.isEmpty) {
      loading = false;
      completed = true;
      notifyListeners();
      return;
    }
    _startProblem();
    loading = false;
    notifyListeners();
  }

  TrainerProblem? get currentProblem =>
      problems.isNotEmpty ? problems[index] : null;

  int get total => problems.length;

  @override
  void dispose() {
    _isDisposed = true;
    _flashTimer?.cancel();
    super.dispose();
  }

  void appendDigit(String value) {
    currentInput = "$currentInput$value";
    notifyListeners();
  }

  void setInput(String value) {
    currentInput = value;
    notifyListeners();
  }

  void clearInput() {
    currentInput = '';
    notifyListeners();
  }

  void removeLast() {
    if (currentInput.isNotEmpty) {
      currentInput = currentInput.substring(0, currentInput.length - 1);
      notifyListeners();
    }
  }

  Future<void> submitCurrent() async {
    if (currentProblem == null || isSubmitting) {
      return;
    }
    isSubmitting = true;
    final problem = currentProblem!;
    final int startedAt = _timingService.startedAt();
    final int latencyMs = _timingService.end();
    final int endedAt = startedAt + latencyMs;
    final isCorrect = currentInput == problem.expectedAnswer;
    await _attemptDao.insertAttempt(
      TrainerAttempt(
        problemId: problem.id,
        factId: problem.factId,
        lessonId: problem.lessonId,
        startedAt: startedAt,
        endedAt: endedAt,
        latencyMs: latencyMs,
        correct: isCorrect ? 1 : 0,
        userAnswer: currentInput,
        source: ProblemSource.diagnostic,
      ),
    );

    final factId = problem.factId;
    if (factId != null) {
      final existing = await _factCardDao.getByFactId(factId);
      final base = existing ??
          FactCard(
            factId: factId,
            intervalDays: 1,
            easeFactor: kDefaultEaseFactor,
            dueAt: endedAt,
            reps: 0,
            lapses: 0,
            lastLatencyMs: latencyMs,
          );
      final rating = isCorrect
          ? (latencyMs <= kDiagnosticFastLatencyMs
              ? AttemptRating.good
              : AttemptRating.hard)
          : AttemptRating.again;
      final scheduled = _srsScheduler.schedule(
        base.copyWith(lastLatencyMs: latencyMs),
        rating,
        endedAt,
      );
      final updated = scheduled.copyWith(
        intervalDays: rating == AttemptRating.good
            ? 7
            : (rating == AttemptRating.hard ? 3 : 1),
      );
      await _factCardDao.upsert(updated);
    }

    if (index < problems.length - 1) {
      index += 1;
      currentInput = '';
      _startProblem();
      isSubmitting = false;
      notifyListeners();
      return;
    }

    completed = true;
    await _preferences.setBool("diagnostic_complete", true);
    isSubmitting = false;
    notifyListeners();
  }

  void _startProblem() {
    _currentStartedAt = DateTime.now().millisecondsSinceEpoch;
    _timingService.start();
    _flashTimer?.cancel();
    _flashTimer = Timer(
      Duration(milliseconds: kDiagnosticFastLatencyMs),
      () async {
        if (_isDisposed || completed || isSubmitting) {
          return;
        }
        await submitCurrent();
      },
    );
  }
}
