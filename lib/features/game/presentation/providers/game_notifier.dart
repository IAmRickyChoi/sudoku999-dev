import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/entities/game_status.dart'; // 상태 추가
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';
import 'package:sudoku_999/features/game/domain/use_cases/check_answer_usecase.dart'; // 유즈케이스 추가
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';
import 'package:sudoku_999/features/game/presentation/providers/timer_provider.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  FutureOr<GameSession?> build() async {
    final loadGame = ref.read(loadGameUsecaseProvider);
    final session = await loadGame.execute();

    // 게임을 성공적으로 불러왔고, 진행 중(playing)이라면 타이머 재개
    if (session != null && session.status == GameStatus.playing) {
      ref.read(timerProvider.notifier).start(session.elapsedSeconds);
    }
    return session;
  }

  Future<void> startGame(int seed, Difficulty difficulty) async {
    state = const AsyncLoading();
    final generateSudoku = ref.read(generateSudokuUseCaseProvider);
    final newBoard = generateSudoku.execute(seed, difficulty);

    // 새 게임 시작 상태(playing)로 세션 생성
    final newSession = GameSession(board: newBoard, status: GameStatus.playing);

    state = AsyncData(newSession);

    ref.read(timerProvider.notifier).start(0);

    final saveGame = ref.read(saveGameUsecaseProvider);
    await saveGame.execute(newSession);
  }

  Future<void> inputNumber(int row, int col, int value) async {
    if (state.value == null) return;

    final currentSession = state.value!;

    // 이미 게임 오버이거나 클리어한 상태면 더 이상 입력받지 않음
    if (currentSession.status == GameStatus.gameOver ||
        currentSession.status == GameStatus.complete) {
      return;
    }

    final targetCell = currentSession.board.cells[row][col];

    // 힌트로 주어진 칸은 수정 불가
    if (targetCell.isGiven) return;

    // 이미 정답을 맞춘 칸이라면 수정 불가하게 막기 (옵션)
    if (targetCell.currentValue != null &&
        targetCell.currentValue != 0 &&
        targetCell.currentValue == targetCell.answer) {
      return;
    }

    int newMistakes = currentSession.mistakes;
    int? newValue = targetCell.currentValue;
    GameStatus newStatus = currentSession.status;

    // 1. 정답 체크 로직
    if (value == 0) {
      // 지우기 버튼을 눌렀을 때
      newValue = 0;
    } else {
      // 우리가 만든 유즈케이스 호출
      final checkAnswer = CheckAnswerUsecase();
      final isCorrect = checkAnswer.execute(targetCell, value);

      if (isCorrect) {
        // 정답일 경우 칸에 숫자를 채움
        newValue = value;
      } else {
        // 오답일 경우 칸은 비워두고 실수(Mistakes)만 1 증가
        newMistakes += 1;

        // 3번 틀리면 게임 오버 상태로 전환
        if (newMistakes >= 3) {
          newStatus = GameStatus.gameOver;
        }
      }
    }

    // 2. 상태 업데이트를 위한 깊은 복사
    final newCells = List<List<Cell>>.from(
      currentSession.board.cells.map((r) => List<Cell>.from(r)),
    );

    // 판별된 값(newValue)으로 칸 업데이트
    newCells[row][col] = targetCell.copyWith(currentValue: newValue);

    // 3. 승리 조건 체크 (보드가 빈칸 없이 모두 채워졌는지 확인)
    bool isBoardFull = true;
    for (var r in newCells) {
      for (var c in r) {
        if (c.currentValue == null || c.currentValue == 0) {
          isBoardFull = false;
          break; // 빈칸이 하나라도 있으면 검사 중단
        }
      }
    }

    // 에러로 게임오버가 되지 않았고, 보드가 꽉 찼다면 클리어!
    if (isBoardFull && newStatus != GameStatus.gameOver) {
      newStatus = GameStatus.complete;
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

    // UI에 즉시 반영
    state = AsyncData(updatedSession);

    // Isar 데이터베이스에 현재까지의 진행 상황 저장
    final saveGame = ref.read(saveGameUsecaseProvider);
    await saveGame.execute(updatedSession);
  }
}
