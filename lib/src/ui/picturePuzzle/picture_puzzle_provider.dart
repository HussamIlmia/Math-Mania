import 'dart:async';
import '/src/data/models/picture_puzzle.dart';
import '/src/ui/app/game_provider.dart';
import '/src/core/app_constant.dart';

class PicturePuzzleProvider extends GameProvider<PicturePuzzle> {
  @override
  late String result;
  @override
  final DifficultyType difficultyType;

  PicturePuzzleProvider({required super.vsync, required this.difficultyType})
    : super(
        gameCategoryType: GameCategoryType.PICTURE_PUZZLE,
        difficultyType: difficultyType,
      ) {
    startGame();
  }

  void checkGameResult(String answer) async {
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
