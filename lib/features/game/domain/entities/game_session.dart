import 'package:sudoku_999/features/game/domain/entities/game_status.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';

class GameSession {
  final SudokuBoard board;
  final int mistakes;
  final GameStatus status;
  final int elapsedSeconds;

  GameSession({
    required this.board,
    this.mistakes = 0,
    this.status = GameStatus.initial,
    this.elapsedSeconds = 0,
  });

  GameSession copyWith({
    SudokuBoard? board,
    int? mistakes,
    GameStatus? status,
    int? elapsedSeconds,
  }) {
    return GameSession(
      board: board ?? this.board,
      mistakes: mistakes ?? this.mistakes,
      status: status ?? this.status,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}
