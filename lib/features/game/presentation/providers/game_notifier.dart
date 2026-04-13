import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/entities/game_status.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';
import 'package:sudoku_999/features/game/presentation/providers/timer_provider.dart';
import 'package:sudoku_999/features/game/presentation/providers/vs_notifier.dart';

part 'game_notifier.g.dart';

// [핵심 복구] 이 속성이 모바일 무한 로딩을 막아줍니다!
@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  @override
  FutureOr<GameSession?> build() {
    // 앱 시작 시 무단으로 덮어쓰는 것을 방지
    return null;
  }

  Future<void> loadSavedGame() async {
    state = const AsyncLoading();
    final loadGame = ref.read(loadGameUsecaseProvider);
    final session = await loadGame.execute();

    if (session != null && session.status == GameStatus.playing) {
      ref.read(timerProvider.notifier).start(session.elapsedSeconds);
      state = AsyncData(session);
    } else {
      final seed = DateTime.now().millisecondsSinceEpoch;
      await startGame(seed, Difficulty.medium);
    }
  }

  Future<void> startGame(int seed, Difficulty difficulty) async {
    state = const AsyncLoading();

    final generateSudoku = ref.read(generateSudokuUseCaseProvider);
    final newBoard = generateSudoku.execute(seed, difficulty);

    final newSession = GameSession(board: newBoard, status: GameStatus.playing);

    state = AsyncData(newSession);
    ref.read(timerProvider.notifier).start(0);

    ref.read(saveGameUsecaseProvider).execute(newSession);
  }

  Future<void> inputNumber(int row, int col, int value) async {
    if (state.value == null) return;

    final currentSession = state.value!;

    if (currentSession.status == GameStatus.gameOver ||
        currentSession.status == GameStatus.complete)
      return;

    final targetCell = currentSession.board.cells[row][col];
    if (targetCell.isGiven) return;

    int newMistakes = currentSession.mistakes;
    int? newValue;
    GameStatus newStatus = currentSession.status;

    // [신규 기획 적용] 오답이어도 일단 무조건 입력되게 합니다.
    if (value == 0) {
      newValue = 0;
    } else {
      newValue = value;
    }

    final newCells = List<List<Cell>>.from(
      currentSession.board.cells.map((r) => List<Cell>.from(r)),
    );
    newCells[row][col] = targetCell.copyWith(currentValue: newValue);

    bool isBoardFull = true;
    bool isAllCorrect = true;
    int totalEmptyCells = 0;
    int filledEmptyCells = 0;

    for (var r in newCells) {
      for (var c in r) {
        if (!c.isGiven) {
          totalEmptyCells++;
          if (c.currentValue != null && c.currentValue != 0) {
            filledEmptyCells++;
          }
        }

        if (c.currentValue == null || c.currentValue == 0) {
          isBoardFull = false;
        } else {
          if (c.currentValue != c.answer) {
            isAllCorrect = false;
          }
        }
      }
    }

    // [신규 기획 적용] 스도쿠 판이 꽉 찼을 때만 한 번에 검사!
    if (isBoardFull &&
        newStatus != GameStatus.gameOver &&
        newStatus != GameStatus.complete) {
      if (isAllCorrect) {
        newStatus = GameStatus.complete; // 대성공!
      } else {
        newStatus = GameStatus.gameOver; // 오답 있음, 게임오버!
      }
    }

    if (newStatus == GameStatus.gameOver || newStatus == GameStatus.complete) {
      ref.read(timerProvider.notifier).pause();
    }

    final newBoard = SudokuBoard(
      cells: newCells,
      difficulty: currentSession.board.difficulty,
      seed: currentSession.board.seed,
    );
    final currentElapsed = ref.read(timerProvider);
    final updatedSession = GameSession(
      board: newBoard,
      mistakes: newMistakes,
      status: newStatus,
      elapsedSeconds: currentElapsed,
    );

    state = AsyncData(updatedSession);

    int progressPercent = 0;
    if (totalEmptyCells > 0) {
      progressPercent = ((filledEmptyCells / totalEmptyCells) * 100).toInt();
    }
    ref.read(vsProvider.notifier).sendMyProgress(progressPercent);

    ref.read(saveGameUsecaseProvider).execute(updatedSession);
  }
}
