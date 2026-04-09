import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_notifier.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';
import 'package:sudoku_999/features/game/presentation/providers/timer_provider.dart';
import 'package:sudoku_999/features/game/presentation/providers/vs_notifier.dart';
import 'package:sudoku_999/features/game/presentation/screens/number_pad.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStatus = ref.watch(gameProvider);
    final vsState = ref.watch(vsProvider);

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
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
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
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () =>
                    ref.read(gameProvider.notifier).loadSavedGame(),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(
                  '싱글 플레이 이어하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          // 화면 진행도 계산: 빈칸 기준 (UI表示用の計算)
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

          double myProgress = 0.0;
          if (totalEmptyCells > 0) {
            myProgress = filledEmptyCells / totalEmptyCells.toDouble();
          }
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: Colors.red[400],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Mistakes : ${session.mistakes} / 3',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const TimerWidget(),
                    ],
                  ),
                ),

              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
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
                      child: _buildSudokuGrid(session.board.cells, ref),
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

  Widget _buildSudokuGrid(List<List<dynamic>> cells, WidgetRef ref) {
    final selectedCell = ref.watch(selectedCellProvider);

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
                color: cell.isGiven ? Colors.black87 : Colors.blue[700],
              ),
            ),
          ),
        );
      },
    );
  }
}

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
