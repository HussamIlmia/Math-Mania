import 'dart:async';

import '/src/data/models/mental_arithmetic.dart';
import '/src/core/app_constant.dart';
import '/src/ui/app/game_provider.dart';

class MentalArithmeticProvider extends GameProvider<MentalArithmetic> {
  @override
  late String result;
  @override
  final DifficultyType difficultyType;

  MentalArithmeticProvider({required super.vsync, required this.difficultyType})
    : super(
        gameCategoryType: GameCategoryType.MENTAL_ARITHMETIC,
        difficultyType: difficultyType,
      ) {
    startGame();
  }

  Future<void> checkResult(String answer) async {
    if (timerStatus != TimerStatus.pause &&
        result.length < currentState.answer.toString().length &&
        ((result.isEmpty && answer == "-") || (answer != "-"))) {
      result = result + answer;
      notifyListeners();
      if (result != "-" && int.parse(result) == currentState.answer) {
        await Future.delayed(Duration(milliseconds: 300));
        loadNewDataIfRequired();
        notifyListeners();
      } else if (result.length == currentState.answer.toString().length) {
        if (currentScore > 0) {
          wrongAnswer();
        }
      }
    }
  }

  void backPress() {
    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 1);
      notifyListeners();
    }
  }

  void clearResult() {
    result = "";
    notifyListeners();
  }
}
