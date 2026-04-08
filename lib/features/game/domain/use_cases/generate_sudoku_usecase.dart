import 'dart:math';
import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';

class GenerateSudokuUsecase {
  SudokuBoard execute(int seed, Difficulty difficulty) {
    // 1. 전달받은 시드값으로 난수 생성기 고정 (온라인에서 똑같은 문제가 나오게 하는 핵심!)
    final random = Random(seed);

    // 2. 계산을 위한 임시 9x9 정수형 배열 생성 (0으로 채움)
    List<List<int>> tempGrid = List.generate(
      9,
      (_) => List.generate(9, (_) => 0),
    );

    // 3. 백트래킹(Backtracking) 알고리즘으로 스도쿠 정답 꽉 채우기
    _fillBoard(tempGrid, random);

    // 4. 임시 배열을 바탕으로 모든 칸이 정답으로 채워진 Cell 격자(Grid) 생성
    List<List<Cell>> grid = List.generate(9, (row) {
      return List.generate(9, (col) {
        return Cell(
          answer: tempGrid[row][col],
          currentValue: tempGrid[row][col], // 처음엔 정답이 꽉 차 있게 설정
          isGiven: true, // 기본적으로 모두 힌트로 주어짐
        );
      });
    });

    // 5. 난이도에 따라 무작위 위치의 빈칸 뚫기
    _removeCells(grid, difficulty, random);

    return SudokuBoard(cells: grid, difficulty: difficulty, seed: seed);
  }

  // --- 내부 알고리즘 함수들 ---

  // 백트래킹: 빈칸(0)을 찾아 유효한 숫자를 채우는 재귀 함수 (再帰関数)
  bool _fillBoard(List<List<int>> grid, Random random) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          // 1~9 숫자를 무작위로 섞어서 대입 (시드값 덕분에 매번 동일한 패턴)
          List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          numbers.shuffle(random);

          for (int num in numbers) {
            if (_isValid(grid, row, col, num)) {
              grid[row][col] = num; // 임시로 숫자 채우기

              if (_fillBoard(grid, random)) {
                return true; // 끝까지 다 채웠다면 성공 반환
              }

              grid[row][col] = 0; // 실패했다면 다시 0으로 비우기 (백트래킹)
            }
          }
          return false; // 어떤 숫자를 넣어도 성립하지 않으면 실패 반환
        }
      }
    }
    return true; // 보드가 꽉 참
  }

  // 가로, 세로, 3x3 박스 안에 중복되는 숫자가 없는지 검사하는 함수
  bool _isValid(List<List<int>> grid, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == num) return false;
      if (grid[i][col] == num) return false;
    }

    int startRow = row - (row % 3);
    int startCol = col - (col % 3);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == num) return false;
      }
    }
    return true;
  }

  // 난이도별로 칸을 지우는 함수
  void _removeCells(
    List<List<Cell>> grid,
    Difficulty difficulty,
    Random random,
  ) {
    int cellsToRemove;
    switch (difficulty) {
      case Difficulty.easy:
        cellsToRemove = 30; // 쉬움: 30칸 비우기
        break;
      case Difficulty.medium:
        cellsToRemove = 45; // 보통: 45칸 비우기
        break;
      case Difficulty.hard:
        cellsToRemove = 55; // 어려움: 55칸 비우기
        break;
    }

    int removed = 0;
    while (removed < cellsToRemove) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);

      // 아직 안 지워진 칸이라면 지웁니다.
      if (grid[row][col].isGiven == true) {
        grid[row][col] = Cell(
          answer: grid[row][col].answer, // 진짜 정답은 뒤에 숨겨둠
          currentValue: 0, // 빈칸은 0으로 처리
          isGiven: false, // 유저가 조작할 수 있는 빈칸으로 변경
        );
        removed++;
      }
    }
  }
}
