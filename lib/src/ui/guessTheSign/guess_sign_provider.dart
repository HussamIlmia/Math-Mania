import 'dart:async';

import '/src/data/models/sign.dart';
import '/src/core/app_constant.dart';
import '/src/ui/app/game_provider.dart';

class GuessSignProvider extends GameProvider<Sign> {
  @override
  final DifficultyType difficultyType;

  GuessSignProvider({required super.vsync, required this.difficultyType})
    : super(
        gameCategoryType: GameCategoryType.GUESS_SIGN,
        difficultyType: difficultyType,
      ) {
    startGame();
  }

  void checkResult(String answer) async {
    if (timerStatus != TimerStatus.pause) {
      result = answer;
      notifyListeners();
      if (result == currentState.sign) {
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
