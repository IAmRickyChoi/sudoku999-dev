import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/data/repositories/sudoku_repository_impl.dart';
import 'package:sudoku_999/features/game/domain/repositories/sudoku_repository.dart';
import 'package:sudoku_999/features/game/domain/use_cases/generate_sudoku_usecase.dart';
import 'package:sudoku_999/features/game/domain/use_cases/load_game_usecase.dart';
import 'package:sudoku_999/features/game/domain/use_cases/save_game_usecase.dart';

part 'game_providers.g.dart';

@Riverpod(keepAlive: true)
Isar isar(Ref ref) {
  throw UnimplementedError();
}

@riverpod
SudokuRepository sudokuRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return SudokuRepositoryImpl(isar);
}

@riverpod
GenerateSudokuUsecase generateSudokuUseCase(Ref ref) {
  return GenerateSudokuUsecase();
}

@riverpod
SaveGameUsecase saveGameUsecase(Ref ref) {
  final repository = ref.watch(sudokuRepositoryProvider);
  return SaveGameUsecase(repository);
}

@riverpod
LoadGameUsecase loadGameUsecase(Ref ref) {
  final repository = ref.watch(sudokuRepositoryProvider);
  return LoadGameUsecase(repository);
}

@riverpod
class SelectedCell extends _$SelectedCell {
  @override
  ({int row, int col})? build() {
    // 초기값은 아무것도 선택되지 않은 상태(null)
    return null;
  }

  // 선택된 칸을 업데이트하는 메서드(メソッド)
  void update(int row, int col) {
    state = (row: row, col: col);
  }

  // 선택을 해제하는 메서드
  void clear() {
    state = null;
  }
}
