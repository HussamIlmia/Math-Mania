import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '/src/core/trainer_constants.dart';
import '/src/data/db/dao/attempt_dao.dart';
import '/src/data/db/dao/fact_card_dao.dart';
import '/src/data/db/dao/fact_dao.dart';
import '/src/data/models/trainer/fact_card.dart';
import '/src/data/models/trainer/trainer_attempt.dart';
import '/src/data/models/trainer/trainer_problem.dart';
import '/src/data/srs/srs_scheduler.dart';
import '/src/data/timing/timing_service.dart';
import '/src/ui/common/common_answer_input.dart';
import '/src/utility/tuple.dart';

class SrsReviewView extends StatefulWidget {
  final List<FactCard> dueCards;

  const SrsReviewView({super.key, required this.dueCards});

  @override
  State<SrsReviewView> createState() => _SrsReviewViewState();
}

class _SrsReviewViewState extends State<SrsReviewView> {
  late final AttemptDao _attemptDao = GetIt.I.get<AttemptDao>();
  late final FactCardDao _factCardDao = GetIt.I.get<FactCardDao>();
  late final FactDao _factDao = GetIt.I.get<FactDao>();
  late final SrsScheduler _scheduler = GetIt.I.get<SrsScheduler>();
  late final TimingService _timingService = GetIt.I.get<TimingService>();

  int index = 0;
  String input = '';
  TrainerProblem? currentProblem;
  bool done = false;

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    if (index >= widget.dueCards.length) {
      return;
    }
    final card = widget.dueCards[index];
    final fact = await _factDao.getById(card.factId);
    setState(() {
      currentProblem = TrainerProblem(
        id: "srs_${fact?.id ?? card.factId}",
        factId: card.factId,
        lessonId: null,
        prompt: fact?.prompt ?? "Missing fact",
        expectedAnswer: fact?.answer ?? "0",
        inputType: InputType.numeric,
        source: ProblemSource.srs,
      );
    });
    _timingService.start();
  }

  Future<void> _submit() async {
    final problem = currentProblem;
    if (problem == null) return;
    final startedAt = _timingService.startedAt();
    final latency = _timingService.end();
    final endedAt = startedAt + latency;
    final correct = input == problem.expectedAnswer;
    final card = widget.dueCards[index];
    final rating = correct
        ? (latency <= kDiagnosticFastLatencyMs
            ? AttemptRating.good
            : AttemptRating.hard)
        : AttemptRating.again;
    final updatedCard = _scheduler.schedule(
      card,
      rating,
      endedAt,
    );
    await _factCardDao.upsert(
      updatedCard.copyWith(
        lastLatencyMs: latency,
        reps: correct ? card.reps + 1 : card.reps,
      ),
    );
    await _attemptDao.insertAttempt(
      TrainerAttempt(
        problemId: problem.id,
        factId: card.factId,
        lessonId: null,
        startedAt: startedAt,
        endedAt: endedAt,
        latencyMs: latency,
        correct: correct ? 1 : 0,
        userAnswer: input,
        source: ProblemSource.srs,
      ),
    );
    if (index < widget.dueCards.length - 1) {
      setState(() {
        index += 1;
        input = '';
      });
      _loadCurrent();
    } else {
      setState(() {
        done = true;
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dueCards.isEmpty || done) {
      return Scaffold(
        appBar: AppBar(title: const Text("Review")),
        body: Center(child: const Text("No cards due")),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Review (${index + 1}/${widget.dueCards.length})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (currentProblem != null)
              Text(
                currentProblem!.prompt,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            const SizedBox(height: 32),
            Text(input, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            CommonAnswerInput(
              inputType: InputType.numeric,
              colorTuple: const Tuple2(Color(0xff4895ef), Color(0xff3f37c9)),
              currentValue: input,
              onValueChanged: (value) {
                setState(() {
                  input = value;
                });
              },
              onSubmit: (value) {
                _submit();
              },
            ),
            ElevatedButton(
              onPressed: input.isNotEmpty ? () => _submit() : null,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
