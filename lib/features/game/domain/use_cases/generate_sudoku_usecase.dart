import 'dart:math';

import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';

class GenerateSudokuUsecase {
  SudokuBoard execute(int seed, Difficulty difficulty) {
    final random = Random(seed);

    List<List<Cell>> grid = List.generate(
      9,
      (_) => List.generate(9, (_) => Cell(answer: 0, isGiven: false)),
    );

    return SudokuBoard(cells: grid, difficulty: difficulty, seed: seed);
  }
}
