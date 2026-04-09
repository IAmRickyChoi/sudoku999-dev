import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/entities/game_status.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';
import 'package:sudoku_999/features/game/domain/use_cases/check_answer_usecase.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';
import 'package:sudoku_999/features/game/presentation/providers/timer_provider.dart';
import 'package:sudoku_999/features/game/presentation/providers/vs_notifier.dart';

part 'game_notifier.g.dart';

@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  @override
  FutureOr<GameSession?> build() async {
    // 초기 상태는 null이며, 필요 시 명시적으로 호출하여 데이터를 채웁니다.
    return null;
  }

  // 싱글 플레이 데이터 로드
  Future<void> loadSavedGame() async {
    state = const AsyncLoading(); // 로딩 시작
    try {
      final loadGame = ref.read(loadGameUsecaseProvider);
      final session = await loadGame.execute();

      if (session != null) {
        // [수정] 타이머 시작 후 즉시 데이터 주입
        ref.read(timerProvider.notifier).start(session.elapsedSeconds);
        state = AsyncData(session);
      } else {
        // 세이브 데이터 없으면 바로 새 게임 시작
        final seed = DateTime.now().millisecondsSinceEpoch;
        await startGame(seed, Difficulty.medium);
      }
    } catch (e) {
      // 에러 시 방어 로직: 새 게임으로 강제 전환
      final seed = DateTime.now().millisecondsSinceEpoch;
      await startGame(seed, Difficulty.medium);
    }
  }

  // 게임 시작 (온라인 매칭 및 싱글 신규 게임)
  Future<void> startGame(int seed, Difficulty difficulty) async {
    // 1. 상태를 로딩으로 전환
    state = const AsyncLoading();

    // 2. 스도쿠 보드 생성 (이 작업은 로컬에서 수행되므로 매우 빠름)
    final generateSudoku = ref.read(generateSudokuUseCaseProvider);
    final newBoard = generateSudoku.execute(seed, difficulty);
    final newSession = GameSession(board: newBoard, status: GameStatus.playing);

    // 3. [핵심] 서버 저장을 기다리지 않고 즉시 상태를 업데이트하여 화면을 띄움 (UI 우선 로직)
    state = AsyncData(newSession);
    ref.read(timerProvider.notifier).start(0);

    // 4. 서버 저장은 비동기로 백그라운드에서 진행 (사용자는 로딩을 느끼지 못함)
    try {
      ref.read(saveGameUsecaseProvider).execute(newSession);
    } catch (e) {
      print('백그라운드 저장 중 오류 발생(무시): $e');
    }
  }

  Future<void> inputNumber(int row, int col, int value) async {
    if (state.value == null) return;
    final currentSession = state.value!;

    if (currentSession.status == GameStatus.gameOver ||
        currentSession.status == GameStatus.complete)
      return;

    final targetCell = currentSession.board.cells[row][col];
    if (targetCell.isGiven) return;

    final vsState = ref.read(vsProvider);
    final isVsMode = vsState.status == VsStatus.matched;

    int newMistakes = currentSession.mistakes;
    int? newValue = targetCell.currentValue;
    GameStatus newStatus = currentSession.status;

    if (value == 0) {
      newValue = 0;
    } else {
      final checkAnswer = CheckAnswerUsecase();
      final isCorrect = checkAnswer.execute(targetCell, value);

      if (isCorrect) {
        newValue = value;
      } else {
        if (!isVsMode) {
          newMistakes += 1;
          if (newMistakes >= 3) newStatus = GameStatus.gameOver;
        } else {
          newValue = null;
        }
      }
    }

    final newCells = List<List<Cell>>.from(
      currentSession.board.cells.map((r) => List<Cell>.from(r)),
    );
    if (newValue != null) {
      newCells[row][col] = targetCell.copyWith(currentValue: newValue);
    }

    bool isBoardFull = true;
    int totalEmptyCells = 0;
    int filledEmptyCells = 0;

    for (var r in newCells) {
      for (var c in r) {
        if (c.currentValue == null || c.currentValue == 0) {
          isBoardFull = false;
        }
        if (!c.isGiven) {
          totalEmptyCells++;
          if (c.currentValue != null && c.currentValue != 0) {
            filledEmptyCells++;
          }
        }
      }
    }

    if (isBoardFull && newStatus != GameStatus.gameOver)
      newStatus = GameStatus.complete;

    if (newStatus == GameStatus.gameOver || newStatus == GameStatus.complete) {
      ref.read(timerProvider.notifier).pause();
    }

    final newBoard = SudokuBoard(
      cells: newCells,
      difficulty: currentSession.board.difficulty,
      seed: currentSession.board.seed,
    );
    final updatedSession = GameSession(
      board: newBoard,
      mistakes: newMistakes,
      status: newStatus,
      elapsedSeconds: ref.read(timerProvider),
    );

    // UI 즉시 업데이트
    state = AsyncData(updatedSession);

    // 온라인 진행도 전송
    int progressPercent = 0;
    if (totalEmptyCells > 0) {
      progressPercent = ((filledEmptyCells / totalEmptyCells) * 100).toInt();
    }
    ref.read(vsProvider.notifier).sendMyProgress(progressPercent);

    // 서버 저장은 백그라운드에서 처리
    ref.read(saveGameUsecaseProvider).execute(updatedSession);
  }
}
