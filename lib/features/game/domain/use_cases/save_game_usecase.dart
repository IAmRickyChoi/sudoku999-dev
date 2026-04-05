import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/repositories/sudoku_repository.dart';

class SaveGameUsecase {
  final SudokuRepository sudokuRepository;

  SaveGameUsecase(this.sudokuRepository);

  Future<void> execute(GameSession gameSession) async {
    await sudokuRepository.saveGame(gameSession);
  }
}
