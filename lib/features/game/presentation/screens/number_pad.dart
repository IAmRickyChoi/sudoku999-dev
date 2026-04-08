import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_notifier.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';

class NumberPad extends ConsumerWidget {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCell = ref.watch(selectedCellProvider);

    // 버튼 크기를 화면 너비에 맞춰서 동적으로 설정
    final screenWidth = MediaQuery.of(context).size.width;
    final btnSize = (screenWidth - 40) / 6; // 한 줄에 5개 + 여백 고려

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // 윗 줄 (1 ~ 5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3, 4, 5]
                .map(
                  (i) =>
                      _buildButton(ref, selectedCell, i.toString(), i, btnSize),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          // 아랫 줄 (6 ~ 9, 지우기)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...[6, 7, 8, 9].map(
                (i) =>
                    _buildButton(ref, selectedCell, i.toString(), i, btnSize),
              ),
              _buildEraseButton(ref, selectedCell, btnSize), // 지우기 버튼
            ],
          ),
        ],
      ),
    );
  }

  // 일반 숫자 버튼
  Widget _buildButton(
    WidgetRef ref,
    ({int row, int col})? selectedCell,
    String text,
    int value,
    double size,
  ) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (selectedCell != null) {
            ref
                .read(gameProvider.notifier)
                .inputNumber(selectedCell.row, selectedCell.col, value);
          }
        },
        child: SizedBox(
          width: size,
          height: size * 1.1, // 살짝 길쭉하게
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 지우기 전용 아이콘 버튼
  Widget _buildEraseButton(
    WidgetRef ref,
    ({int row, int col})? selectedCell,
    double size,
  ) {
    return Material(
      color: Colors.red[50], // 지우기는 빨간 톤으로 구분
      elevation: 2,
      shadowColor: Colors.red[100],
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (selectedCell != null) {
            ref
                .read(gameProvider.notifier)
                .inputNumber(selectedCell.row, selectedCell.col, 0);
          }
        },
        child: SizedBox(
          width: size,
          height: size * 1.1,
          child: Center(
            child: Icon(
              Icons.backspace_rounded,
              color: Colors.red[400],
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
