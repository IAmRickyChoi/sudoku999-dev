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
