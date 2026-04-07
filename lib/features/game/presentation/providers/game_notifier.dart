import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  FutureOr<GameSession?> build() async {
    final loadGame = ref.read(loadGameUsecaseProvider);
    return await loadGame.execute();
  }

  Future<void> startGame(int seed, Difficulty difficulty) async {
    state = const AsyncLoading();
    final ganerateSudoku = ref.read(generateSudokuUseCaseProvider);
    final newBoard = ganerateSudoku.execute(seed, difficulty);

    final newSession = GameSession(board: newBoard);

    state = AsyncData(newSession);

    final saveGame = ref.read(saveGameUsecaseProvider);
    await saveGame.execute(newSession);
  }

  Future<void> inputNumber(int row, int col, int value) async {
    if (state.value == null) return;

    final currentSession = state.value!;
    final targetCell = currentSession.board.cells[row][col];

    if (targetCell.isGiven) return;

    final newCells = List<List<Cell>>.from(
      currentSession.board.cells.map((r) => List<Cell>.from(r)),
    );

    newCells[row][col] = targetCell.copyWith(currentValue: value);

    final newBoard = SudokuBoard(
      cells: newCells,
      difficulty: currentSession.board.difficulty,
      seed: currentSession.board.seed,
    );

    final updatedSession = GameSession(
      board: newBoard,
      mistakes: currentSession.mistakes,
      status: currentSession.status,
    );

    state = AsyncData(updatedSession);

    final saveGame = ref.read(saveGameUsecaseProvider);
    await saveGame.execute(updatedSession);
  }
}
