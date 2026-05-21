import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/core/trainer_constants.dart';
import '/src/ui/common/common_answer_input.dart';
import '/src/ui/drill/drill_session_provider.dart';
import '/src/ui/common/common_alert_dialog.dart';
import '/src/utility/tuple.dart';

class DrillSessionView extends StatefulWidget {
  final String? lessonId;

  const DrillSessionView({super.key, this.lessonId});

  @override
  State<DrillSessionView> createState() => _DrillSessionViewState();
}

class _DrillSessionViewState extends State<DrillSessionView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showResult(int accuracy, int latency) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return CommonAlertDialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Drill complete",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text("Accuracy: $accuracy%"),
                const SizedBox(height: 4),
                Text("Median latency: ${latency}ms"),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          DrillSessionProvider(lessonId: widget.lessonId ?? "lesson_mul11"),
      child: Scaffold(
        appBar: AppBar(title: const Text("Drill")),
        body: Consumer<DrillSessionProvider>(
              builder: (context, model, child) {
            if (model.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final problem = model.currentProblem;
            if (model.finished) {
              final accuracy = model.accuracyPercent;
              final latency = model.medianLatencyMs;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _showResult(accuracy, latency);
                if (mounted) Navigator.pop(context);
              });
              return const Center(child: CircularProgressIndicator());
            }
            if (problem == null) {
              return const Center(child: Text("No problems"));
            }
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${model.index + 1}/${model.total}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    problem.prompt,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    model.currentInput,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  CommonAnswerInput(
                    inputType: InputType.numeric,
                    colorTuple: const Tuple2(Color(0xff4895ef), Color(0xff3f37c9)),
                    currentValue: model.currentInput,
                    onValueChanged: (value) {
                      model.setInput(value);
                    },
                    onSubmit: (value) async {
                      await model.submit();
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: model.currentInput.isNotEmpty
                        ? () {
                            model.submit();
                          }
                        : null,
                    child: const Text("Submit"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
