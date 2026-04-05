import 'package:sudoku_999/features/game/domain/entities/game_session.dart';

abstract interface class SudokuRepository {
  Future<void> saveGame(GameSession gameSession);
  Future<GameSession?> loadGame();
  Future<void> clearSavedGame();
}
