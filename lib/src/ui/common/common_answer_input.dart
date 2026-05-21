import 'package:flutter/material.dart';
import '/src/core/trainer_constants.dart';
import '/src/ui/common/common_number_button.dart';
import '/src/utility/tuple.dart';

class CommonAnswerInput extends StatelessWidget {
  final InputType inputType;
  final Tuple2<Color, Color> colorTuple;
  final String currentValue;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<String> onSubmit;
  final List<String> choices;

  const CommonAnswerInput({
    super.key,
    required this.inputType,
    required this.colorTuple,
    required this.currentValue,
    required this.onValueChanged,
    required this.onSubmit,
    this.choices = const <String>[],
  });

  @override
  Widget build(BuildContext context) {
    switch (inputType) {
      case InputType.numeric:
        return _buildNumericKeyboard();
      case InputType.multipleChoice:
        return _buildMultipleChoice();
      case InputType.classify:
        return _buildClassify();
    }
  }

  Widget _buildNumericKeyboard() {
    const values = <String>[
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "DEL",
      "0",
      "OK",
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final value = values[index];
        return CommonNumberButton(
          text: value,
          height: 74,
          colorTuple: colorTuple,
          onTab: () {
            if (value == "DEL") {
              if (currentValue.isNotEmpty) {
                onValueChanged(currentValue.substring(0, currentValue.length - 1));
              }
            } else if (value == "OK") {
              onSubmit(currentValue);
            } else {
              onValueChanged("$currentValue$value");
            }
          },
        );
      },
    );
  }

  Widget _buildMultipleChoice() {
    final effectiveChoices = choices.isEmpty
        ? const ["Option A", "Option B", "Option C", "Option D"]
        : choices;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: effectiveChoices.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final value = effectiveChoices[index];
        return ElevatedButton(onPressed: () => onSubmit(value), child: Text(value));
      },
    );
  }

  Widget _buildClassify() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSubmit("yes"),
            child: const Text("Yes"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSubmit("no"),
            child: const Text("No"),
          ),
        ),
      ],
    );
  }
}

