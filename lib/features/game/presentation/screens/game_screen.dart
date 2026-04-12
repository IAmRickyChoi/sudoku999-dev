// (임포트 부분 기존과 동일)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/entities/game_status.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_notifier.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';
import 'package:sudoku_999/features/game/presentation/providers/timer_provider.dart';
import 'package:sudoku_999/features/game/presentation/providers/vs_notifier.dart';
import 'package:sudoku_999/features/game/presentation/screens/number_pad.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  void _showResultDialog(BuildContext context, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isSuccess ? '🎉 성공 (Success)!' : '💀 실패 (Game Over)',
            style: TextStyle(
              color: isSuccess ? Colors.green : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            isSuccess
                ? '모든 칸을 완벽하게 채웠습니다!\n훌륭합니다!'
                : '어딘가 틀린 숫자가 있습니다.\n아쉽지만 이번 게임은 실패입니다.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('보드 확인하기'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop();
              },
              child: const Text('메뉴로 돌아가기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStatus = ref.watch(gameProvider);
    final vsState = ref.watch(vsProvider);

    ref.listen<AsyncValue<GameSession?>>(gameProvider, (prev, next) {
      final prevStatus = prev?.value?.status;
      final nextStatus = next.value?.status;

      if (prevStatus != nextStatus && nextStatus != null) {
        if (nextStatus == GameStatus.complete) {
          _showResultDialog(context, true);
        } else if (nextStatus == GameStatus.gameOver) {
          _showResultDialog(context, false);
        }
      }
    });

    // 👇 [추가] 상대방 탈주를 감지하는 강력한 리스너!
    ref.listen<VsState>(vsProvider, (prev, next) {
      if (prev?.status == VsStatus.matched &&
          next.status == VsStatus.opponentLeft) {
        // 내 게임 타이머 정지
        ref.read(timerProvider.notifier).pause();

        showDialog(
          context: context,
          barrierDismissible: false, // 터치로 닫기 방지
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                '🎉 부전승 (Victory)!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text('상대방이 게임에서 도망갔습니다!\n당신의 깔끔한 승리입니다! 😎'),
              actions: [
                FilledButton(
                  onPressed: () {
                    // 다이얼로그 닫고
                    Navigator.of(context).pop();
                    // 웹소켓 완전히 끊어주고
                    ref.read(vsProvider.notifier).disconnect();
                    // 메인 메뉴로 강제 추방(이동)
                    context.pop();
                  },
                  child: const Text('메인 메뉴로'),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (vsState.status != VsStatus.disconnected) {
              ref.read(vsProvider.notifier).disconnect();
            }
            context.pop();
          },
        ),
        title: const Text(
          'Clean Sudoku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (vsState.status != VsStatus.matched)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 28),
              onPressed: () {
                final newSeed = DateTime.now().millisecondsSinceEpoch;
                ref
                    .read(gameProvider.notifier)
                    .startGame(newSeed, Difficulty.medium);
              },
            ),
        ],
      ),
      body: gameStatus.when(
        data: (session) {
          if (session == null) {
            if (vsState.status == VsStatus.matched) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: FilledButton.icon(
                onPressed: () =>
                    ref.read(gameProvider.notifier).loadSavedGame(),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('싱글 플레이 이어하기'),
              ),
            );
          }

          int totalEmptyCells = 0;
          int filledEmptyCells = 0;
          for (var row in session.board.cells) {
            for (var cell in row) {
              if (!cell.isGiven) {
                totalEmptyCells++;
                if (cell.currentValue != null && cell.currentValue != 0) {
                  filledEmptyCells++;
                }
              }
            }
          }

          double myProgress = totalEmptyCells > 0
              ? filledEmptyCells / totalEmptyCells.toDouble()
              : 0.0;
          final double opProgress = vsState.opponentProgress / 100.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (vsState.status == VsStatus.matched)
                VsProgressWidget(myProgress: myProgress, opProgress: opProgress)
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [TimerWidget()],
                  ),
                ),

              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: _buildSudokuGrid(session, ref),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const NumberPad(),
              const SizedBox(height: 30),
            ],
          );
        },
        error: (error, stackTrace) => Center(child: Text('에러발생 : $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildSudokuGrid(GameSession session, WidgetRef ref) {
    final selectedCell = ref.watch(selectedCellProvider);
    final cells = session.board.cells;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        childAspectRatio: 1.0,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: 81,
      itemBuilder: (context, index) {
        final row = index ~/ 9;
        final col = index % 9;
        final cell = cells[row][col];

        final isSelected = selectedCell?.row == row && selectedCell?.col == col;
        final isRelated =
            selectedCell != null &&
            !isSelected &&
            (selectedCell.row == row ||
                selectedCell.col == col ||
                (selectedCell.row ~/ 3 == row ~/ 3 &&
                    selectedCell.col ~/ 3 == col ~/ 3));

        final topBorder = (row % 3 == 0) ? 2.0 : 0.5;
        final leftBorder = (col % 3 == 0) ? 2.0 : 0.5;
        final rightBorder = (col == 8) ? 2.0 : 0.0;
        final bottomBorder = (row == 8) ? 2.0 : 0.0;

        return GestureDetector(
          onTap: () => ref.read(selectedCellProvider.notifier).update(row, col),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue[200]
                  : (isRelated
                        ? Colors.blue[50]
                        : (cell.isGiven
                              ? const Color(0xFFF5F7FA)
                              : Colors.white)),
              border: Border(
                top: BorderSide(color: Colors.black87, width: topBorder),
                left: BorderSide(color: Colors.black87, width: leftBorder),
                right: BorderSide(color: Colors.black87, width: rightBorder),
                bottom: BorderSide(color: Colors.black87, width: bottomBorder),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              (cell.currentValue == null || cell.currentValue == 0)
                  ? ''
                  : cell.currentValue.toString(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: cell.isGiven ? FontWeight.w800 : FontWeight.w500,
                color: cell.isGiven
                    ? Colors.black87
                    : (session.status == GameStatus.gameOver &&
                          cell.currentValue != cell.answer)
                    ? Colors.red[500]
                    : Colors.blue[700],
              ),
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------
// 👇 아래쪽이 날아갔던 위젯들입니다! 이제 지워지지 않고 잘 붙어있습니다.
// -------------------------------------------------------------

// VS 모드 전용 프로그레스 바 위젯 (VSモード専用UI)
class VsProgressWidget extends StatelessWidget {
  final double myProgress;
  final double opProgress;

  const VsProgressWidget({
    super.key,
    required this.myProgress,
    required this.opProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '나 (Me)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              Text(
                '${(myProgress * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: myProgress,
            color: Colors.blue,
            backgroundColor: Colors.blue[100],
            minHeight: 10,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '상대방 (Opponent)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              Text(
                '${(opProgress * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: opProgress,
            color: Colors.redAccent,
            backgroundColor: Colors.red[100],
            minHeight: 10,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

// 상단 타이머 위젯 (タイマーウィジェット)
class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(timerProvider);

    final minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        Icon(Icons.timer_outlined, color: Colors.blueGrey[600], size: 24),
        const SizedBox(width: 4),
        Text(
          '$minutesStr:$secondsStr',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
