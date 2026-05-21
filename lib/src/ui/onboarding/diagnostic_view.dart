import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/core/app_constant.dart';
import '/src/core/trainer_constants.dart';
import '/src/ui/common/common_answer_input.dart';
import '/src/ui/onboarding/diagnostic_provider.dart';
import '/src/utility/tuple.dart';

class DiagnosticView extends StatefulWidget {
  const DiagnosticView({super.key});

  @override
  State<DiagnosticView> createState() => _DiagnosticViewState();
}

class _DiagnosticViewState extends State<DiagnosticView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiagnosticProvider()..start(),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<DiagnosticProvider>(
            builder: (context, model, child) {
              if (model.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (model.completed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, KeyUtil.today);
                      },
                      child: const Text("Diagnostic complete - Continue to Today"),
                    ),
                  ),
                );
              }

              final problem = model.currentProblem;
              if (problem == null) {
                return const Center(child: Text("No diagnostic problems"));
              }
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Diagnostic: ${model.index + 1}/${model.total}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              problem.prompt,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              model.currentInput,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CommonAnswerInput(
                      inputType: InputType.numeric,
                      colorTuple: const Tuple2(
                        Color(0xff4895ef),
                        Color(0xff3f37c9),
                      ),
                      currentValue: model.currentInput,
                      onValueChanged: (value) {
                        model.setInput(value);
                      },
                      onSubmit: (value) {
                        if (value.isNotEmpty) {
                          model.submitCurrent();
                        }
                      },
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: model.currentInput.isNotEmpty
                          ? model.submitCurrent
                          : null,
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
