import 'package:sudoku_999/features/game/domain/entities/cell.dart';

class CheckAnswerUsecase {
  bool execute(Cell cell, int input) {
    if (cell.isGiven == true) return false;

    return cell.answer == input;
  }
}
