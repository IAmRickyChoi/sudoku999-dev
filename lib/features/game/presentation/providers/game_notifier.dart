import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/use_cases/load_game_usecase.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  FutureOr<GameSession?> build() async {
    final loadGame = ref.read(LoadGameUsecaseProvider);
    return await loadGame.execute();
  }
}
