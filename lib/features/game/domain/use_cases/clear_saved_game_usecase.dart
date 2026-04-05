import 'package:sudoku_999/features/game/domain/repositories/sudoku_repository.dart';

class ClearSavedGameUsecase {
  final SudokuRepository sudokuRepository;

  ClearSavedGameUsecase(this.sudokuRepository);

  Future<void> execute() async {
    await sudokuRepository.clearSavedGame();
  }
}
