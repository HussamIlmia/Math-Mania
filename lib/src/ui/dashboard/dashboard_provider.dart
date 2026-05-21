import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/src/core/app_assets.dart';
import '/src/data/models/score_board.dart';
import '/src/core/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/game_category.dart';

class DashboardProvider extends ChangeNotifier {
  int _overallScore = 0;
  late List<GameCategory> _list;
  final SharedPreferences preferences;

  int get overallScore => _overallScore;

  List<GameCategory> get list => _list;

  DashboardProvider({required this.preferences}) {
    _overallScore = getOverallScore();
  }

  List<GameCategory> getGameByPuzzleType(PuzzleType puzzleType) {
    switch (puzzleType) {
      case PuzzleType.FREE_PLAY:
        _list = _mathPuzzleGames() + _memoryPuzzleGames() + _brainPuzzleGames();
        break;
      case PuzzleType.MATH_PUZZLE:
        _list = _mathPuzzleGames();
        break;
      case PuzzleType.MEMORY_PUZZLE:
        _list = _memoryPuzzleGames();
        break;
      case PuzzleType.BRAIN_PUZZLE:
        _list = _brainPuzzleGames();
        break;
      case PuzzleType.TODAY:
      case PuzzleType.PATH:
        _list = <GameCategory>[];
        break;
    }
    return _list;
  }

  List<GameCategory> _mathPuzzleGames() {
    return <GameCategory>[
      GameCategory(
        1,
        "Calculator",
        "calculator",
        GameCategoryType.CALCULATOR,
        KeyUtil.calculator,
        getScoreboard("calculator"),
        AppAssets.icCalculator,
      ),
      GameCategory(
        2,
        "Guess the sign?",
        "sign",
        GameCategoryType.GUESS_SIGN,
        KeyUtil.guessSign,
        getScoreboard("sign"),
        AppAssets.icGuessTheSign,
      ),
      GameCategory(
        5,
        "Correct answer",
        "correct_answer",
        GameCategoryType.CORRECT_ANSWER,
        KeyUtil.correctAnswer,
        getScoreboard("correct_answer"),
        AppAssets.icCorrectAnswer,
      ),
      GameCategory(
        8,
        "Quick calculation",
        "quick_calclation",
        GameCategoryType.QUICK_CALCULATION,
        KeyUtil.quickCalculation,
        getScoreboard("quick_calclation"),
        AppAssets.icQuickCalculation,
      ),
    ];
  }

  List<GameCategory> _memoryPuzzleGames() {
    return <GameCategory>[
      GameCategory(
        7,
        "Mental arithmetic",
        "mental_arithmatic",
        GameCategoryType.MENTAL_ARITHMETIC,
        KeyUtil.mentalArithmetic,
        getScoreboard("mental_arithmatic"),
        AppAssets.icMentalArithmetic,
      ),
      GameCategory(
        3,
        "Square root",
        "square_root",
        GameCategoryType.SQUARE_ROOT,
        KeyUtil.squareRoot,
        getScoreboard("square_root"),
        AppAssets.icSquareRoot,
      ),
      GameCategory(
        9,
        "Math Grid",
        "math_machine",
        GameCategoryType.MATH_GRID,
        KeyUtil.mathGrid,
        getScoreboard("math_machine"),
        AppAssets.icMathGrid,
      ),
      GameCategory(
        4,
        "Mathematical pairs",
        "math_pairs",
        GameCategoryType.MATH_PAIRS,
        KeyUtil.mathPairs,
        getScoreboard("math_pairs"),
        AppAssets.icMathematicalPairs,
      ),
    ];
  }

  List<GameCategory> _brainPuzzleGames() {
    return <GameCategory>[
      GameCategory(
        6,
        "Magic triangle",
        "magic_tringle",
        GameCategoryType.MAGIC_TRIANGLE,
        KeyUtil.magicTriangle,
        getScoreboard("magic_tringle"),
        AppAssets.icMagicTriangle,
      ),
      GameCategory(
        10,
        "Picture Puzzle",
        "picture_puzzle",
        GameCategoryType.PICTURE_PUZZLE,
        KeyUtil.picturePuzzle,
        getScoreboard("picture_puzzle"),
        AppAssets.icPicturePuzzle,
      ),
      GameCategory(
        11,
        "Number Pyramid",
        "number_pyramid",
        GameCategoryType.NUMBER_PYRAMID,
        KeyUtil.numberPyramid,
        getScoreboard("number_pyramid"),
        AppAssets.icNumberPyramid,
      ),
    ];
  }

  ScoreBoard getScoreboard(String gameCategoryType) {
    return ScoreBoard.fromJson(
      json.decode(preferences.getString(gameCategoryType) ?? "{}"),
    );
  }

  void setScoreboard(String gameCategoryType, ScoreBoard scoreboard) {
    preferences.setString(gameCategoryType, json.encode(scoreboard.toJson()));
  }

  void updateScoreboard(GameCategoryType gameCategoryType, double newScore) {
    for (var gameCategory in list) {
      if (gameCategory.gameCategoryType == gameCategoryType) {
        if (gameCategory.scoreboard.highestScore < newScore.toInt()) {
          setOverallScore(
            gameCategory.scoreboard.highestScore,
            newScore.toInt(),
          );
          gameCategory.scoreboard.highestScore = newScore.toInt();
        }
        setScoreboard(gameCategory.key, gameCategory.scoreboard);
      }
    }
    notifyListeners();
  }

  int getOverallScore() {
    return preferences.getInt("overall_score") ?? 0;
  }

  void setOverallScore(int highestScore, int newScore) {
    _overallScore = getOverallScore() - highestScore + newScore;
    preferences.setInt("overall_score", _overallScore);
  }

  bool isFirstTime(GameCategoryType gameCategoryType) {
    return list
        .where(
          (GameCategory gameCategory) =>
              gameCategory.gameCategoryType == gameCategoryType,
        )
        .first
        .scoreboard
        .firstTime;
  }

  void setFirstTime(GameCategoryType gameCategoryType) {
    for (var gameCategory in list) {
      if (gameCategory.gameCategoryType == gameCategoryType) {
        gameCategory.scoreboard.firstTime = false;
        setScoreboard(gameCategory.key, gameCategory.scoreboard);
      }
    }
  }
}
