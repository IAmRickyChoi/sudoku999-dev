import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/auth/domain/entities/user.dart';
import 'package:sudoku_999/features/auth/data/repositories/auth_repository_impl.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    return const AsyncData(null);
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      final repository = AuthRepositoryImpl();
      final user = await repository.login(username, password);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> register(String username, String password) async {
    state = const AsyncLoading();
    try {
      final repository = AuthRepositoryImpl();
      final user = await repository.register(username, password);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void logout() {
    state = const AsyncData(null);
  }
}

@Riverpod(keepAlive: true)
class UserStats extends _$UserStats {
  @override
  Future<Map<String, int>> build() async {
    final user = ref.watch(authProvider).value;
    if (user == null) return {'wins': 0, 'losses': 0};

    final repository = AuthRepositoryImpl();
    return await repository.getStats(user.username);
  }

  Future<void> recordResult(String result) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    // UI 즉시 업데이트 (낙관적 업데이트)
    if (state.hasValue) {
      final currentWins = state.value!['wins'] ?? 0;
      final currentLosses = state.value!['losses'] ?? 0;
      state = AsyncData({
        'wins': currentWins + (result == 'win' ? 1 : 0),
        'losses': currentLosses + (result == 'loss' ? 1 : 0),
      });
    }

    // 서버로 전적 전송
    try {
      final repository = AuthRepositoryImpl();
      await repository.recordResult(user.username, result);
    } catch (e) {
      print("기록 실패: $e");
    }
  }
}
