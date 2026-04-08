import 'package:isar_community/isar.dart';
import 'package:sudoku_999/features/game/data/models/game_session_model.dart';
import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';
import 'package:sudoku_999/features/game/domain/repositories/sudoku_repository.dart';

class SudokuRepositoryImpl implements SudokuRepository {
  final Isar isar;
  SudokuRepositoryImpl(this.isar);

  @override
  Future<void> saveGame(GameSession gameSession) async {
    final model = GameSessionModel()
      ..gameStatus = gameSession.status
      ..difficulty = gameSession.board.difficulty
      ..seed = gameSession.board.seed
      ..mistakes = gameSession.mistakes
      ..elapsedSeconds = gameSession.elapsedSeconds
      ..cells = gameSession.board.cells
          .expand((row) => row)
          .map(
            (cell) => CellModel()
              ..answer = cell.answer
              ..currentValue = cell.currentValue
              ..isGiven = cell.isGiven,
          )
          .toList();

    await isar.writeTxn(() async {
      await isar.gameSessionModels.clear();
      await isar.gameSessionModels.put(model);
    });
  }

  @override
  Future<GameSession?> loadGame() async {
    final model = await isar.gameSessionModels.where().findFirst();
    // final model = await isar.gameSessionModels
    //     .where(sort: Sort.desc)
    //     .findFirst();
    if (model == null) return null;

    List<List<Cell>> grid = List.generate(9, (row) {
      return List.generate(9, (col) {
        final index = row * 9 + col;
        final cellModel = model.cells[index];

        return Cell(
          answer: cellModel.answer,
          currentValue: cellModel.currentValue,
          isGiven: cellModel.isGiven,
        );
      });
    });

    final sudokuBoard = SudokuBoard(
      cells: grid,
      difficulty: model.difficulty,
      seed: model.seed,
    );

    return GameSession(
      board: sudokuBoard,
      mistakes: model.mistakes,
      status: model.gameStatus,
      elapsedSeconds: model.elapsedSeconds,
    );
  }

  @override
  Future<void> clearSavedGame() async {
    await isar.writeTxn(() async {
      return await isar.gameSessionModels.clear();
    });
  }
}
