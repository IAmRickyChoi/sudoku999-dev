import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/auth/presentation/providers/auth_notifier.dart';
import 'package:sudoku_999/features/game/data/repositories/sudoku_repository_impl.dart';
import 'package:sudoku_999/features/game/domain/repositories/sudoku_repository.dart';
import 'package:sudoku_999/features/game/domain/use_cases/generate_sudoku_usecase.dart';
import 'package:sudoku_999/features/game/domain/use_cases/load_game_usecase.dart';
import 'package:sudoku_999/features/game/domain/use_cases/save_game_usecase.dart';

part 'game_providers.g.dart';

// 기존에 있던 Isar Provider는 삭제했습니다!

@riverpod
SudokuRepository sudokuRepository(Ref ref) {
  // authProvider를 구독하여 현재 로그인한 유저 정보를 가져옵니다. (ユーザー情報の取得)
  final user = ref.watch(authProvider).value;
  final username = user?.username ?? 'guest';

  // 리포지토리에 유저 이름을 주입(注入, ちゅうにゅう)합니다.
  return SudokuRepositoryImpl(username);
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
    return null;
  }

  void update(int row, int col) {
    state = (row: row, col: col);
  }

  void clear() {
    state = null;
  }
}
