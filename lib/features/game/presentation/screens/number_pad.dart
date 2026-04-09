import 'dart:math'; // min 함수 사용을 위해 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_notifier.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';

class NumberPad extends ConsumerWidget {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCell = ref.watch(selectedCellProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    // [수정됨] 버튼 최대 크기를 65 픽셀로 제한하여 데스크톱 레이아웃 붕괴 방지 (レイアウト崩れ防止)
    final btnSize = min((screenWidth - 40) / 6, 65.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...[6, 7, 8, 9].map(
                (i) =>
                    _buildButton(ref, selectedCell, i.toString(), i, btnSize),
              ),
              _buildEraseButton(ref, selectedCell, btnSize),
            ],
          ),
        ],
      ),
    );
  }

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
          height: size * 1.1,
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

  Widget _buildEraseButton(
    WidgetRef ref,
    ({int row, int col})? selectedCell,
    double size,
  ) {
    return Material(
      color: Colors.red[50],
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
