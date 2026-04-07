import 'package:sudoku_999/features/game/domain/entities/game_status.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';

class GameSession {
  final SudokuBoard board;
  final int mistakes;
  final GameStatus status;

  GameSession({
    required this.board,
    this.mistakes = 0,
    this.status = GameStatus.initial,
  });
}
