import 'dart:async';
import '/src/data/models/correct_answer.dart';
import '/src/core/app_constant.dart';
import '/src/ui/app/game_provider.dart';

class CorrectAnswerProvider extends GameProvider<CorrectAnswer> {
  @override
  late String result;
  @override
  final DifficultyType difficultyType;

  CorrectAnswerProvider({required super.vsync, required this.difficultyType})
    : super(
        gameCategoryType: GameCategoryType.CORRECT_ANSWER,
        difficultyType: difficultyType,
      ) {
    startGame();
  }

  Future<void> checkResult(String answer) async {
    if (timerStatus != TimerStatus.pause) {
      result = answer;
      notifyListeners();
      if (int.parse(result) == currentState.answer) {
        await Future.delayed(Duration(milliseconds: 300));
        loadNewDataIfRequired();
        if (timerStatus != TimerStatus.pause) {
          restartTimer();
        }
        notifyListeners();
      } else {
        wrongAnswer();
      }
    }
  }
}
