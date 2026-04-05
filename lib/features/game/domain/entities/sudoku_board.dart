import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';

class SudokuBoard {
  final List<List<Cell>> cells;
  final Difficulty difficulty;
  final int seed;

  SudokuBoard({
    required this.cells,
    required this.difficulty,
    required this.seed,
  });
}
