import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_notifier.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';
import 'package:sudoku_999/features/game/presentation/providers/timer_provider.dart';
import 'package:sudoku_999/features/game/presentation/screens/number_pad.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStatus = ref.watch(gameProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // 살짝 부드러운 배경색
      appBar: AppBar(
        title: const Text(
          'Clean Sudoku',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 28),
            onPressed: () {
              final newSeed = DateTime.now().millisecondsSinceEpoch;
              ref
                  .read(gameProvider.notifier)
                  .startGame(newSeed, Difficulty.easy);
            },
          ),
        ],
      ),
      body: gameStatus.when(
        data: (session) {
          if (session == null) {
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
                onPressed: () => ref
                    .read(gameProvider.notifier)
                    .startGame(
                      DateTime.now().millisecondsSinceEpoch,
                      Difficulty.easy,
                    ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(
                  '새 게임 시작',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양끝 정렬
                  children: [
                    // 기존 Mistakes 표시 (좌측)
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
                    // 새로 만든 타이머 표시 (우측)
                    const TimerWidget(),
                  ],
                ),
              ),
              // 스도쿠 판 (그림자 및 테두리 효과)
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1, // 완벽한 정사각형 유지
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20,
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
              const SizedBox(height: 30),
              // 하단 숫자 패드
              const NumberPad(),
              const SizedBox(height: 40),
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
      physics: const NeverScrollableScrollPhysics(), // 스크롤 방지
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        childAspectRatio: 1.0,
        crossAxisSpacing: 0, // 간격을 0으로! (테두리로만 구분)
        mainAxisSpacing: 0,
      ),
      itemCount: 81,
      itemBuilder: (context, index) {
        final row = index ~/ 9;
        final col = index % 9;
        final cell = cells[row][col];

        // 1. 선택된 칸
        final isSelected = selectedCell?.row == row && selectedCell?.col == col;

        // 2. 연관된 칸 (같은 가로, 세로, 3x3 박스 내에 있는 칸들 하이라이트)
        final isRelated =
            selectedCell != null &&
            !isSelected &&
            (selectedCell.row == row ||
                selectedCell.col == col ||
                (selectedCell.row ~/ 3 == row ~/ 3 &&
                    selectedCell.col ~/ 3 == col ~/ 3));

        // 3. 3x3 테두리 굵기 계산 (수학의 마법!)
        final topBorder = (row % 3 == 0) ? 2.0 : 0.5;
        final leftBorder = (col % 3 == 0) ? 2.0 : 0.5;
        final rightBorder = (col == 8) ? 2.0 : 0.0;
        final bottomBorder = (row == 8) ? 2.0 : 0.0;

        return GestureDetector(
          onTap: () => ref.read(selectedCellProvider.notifier).update(row, col),
          child: Container(
            decoration: BoxDecoration(
              // 배경색 로직 (선택됨 > 연관됨 > 기본힌트 > 빈칸)
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
                // 기본 주어진 숫자는 까맣고 두껍게, 내가 쓴 숫자는 파랗고 살짝 얇게
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

class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // timerNotifierProvider만 구독(Subscribe)
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
