import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/repositories/sudoku_repository.dart';

class LoadGameUsecase {
  final SudokuRepository sudokuRepository;

  LoadGameUsecase(this.sudokuRepository);

  Future<GameSession?> execute() async {
    return await sudokuRepository.loadGame();
  }
}
