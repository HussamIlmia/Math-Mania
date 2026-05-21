import 'dart:async';

import '/src/data/models/square_root.dart';
import '/src/core/app_constant.dart';
import '/src/ui/app/game_provider.dart';

class SquareRootProvider extends GameProvider<SquareRoot> {
  @override
  final DifficultyType difficultyType;

  SquareRootProvider({required super.vsync, required this.difficultyType})
    : super(
        gameCategoryType: GameCategoryType.SQUARE_ROOT,
        difficultyType: difficultyType,
      ) {
    startGame();
  }

  Future<void> checkResult(String answer) async {
    if (int.parse(answer) == currentState.answer &&
        timerStatus != TimerStatus.pause) {
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
