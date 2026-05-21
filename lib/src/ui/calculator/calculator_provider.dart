import 'dart:async';
import '/src/data/models/calculator.dart';
import '/src/core/app_constant.dart';
import '/src/ui/app/game_provider.dart';

class CalculatorProvider extends GameProvider<Calculator> {
  @override
  late String result;
  @override
  final DifficultyType difficultyType;

  CalculatorProvider({required super.vsync, required this.difficultyType})
    : super(
        gameCategoryType: GameCategoryType.CALCULATOR,
        difficultyType: difficultyType,
      ) {
    startGame();
  }

  void checkResult(String answer) async {
    if (result.length < currentState.answer.toString().length &&
        timerStatus != TimerStatus.pause) {
      result = result + answer;
      notifyListeners();
      if (int.parse(result) == currentState.answer) {
        await Future.delayed(Duration(milliseconds: 300));
        loadNewDataIfRequired();
        if (timerStatus != TimerStatus.pause) {
          restartTimer();
        }
        notifyListeners();
      } else if (result.length == currentState.answer.toString().length) {
        wrongAnswer();
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
