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

// 👇 [핵심 수정] 승률 전용 프로바이더를 Notifier로 업그레이드!
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

    // 1. [Optimistic Update] 서버 응답을 기다리지 않고 UI(숫자)부터 즉시 1 올려버립니다!
    if (state.hasValue) {
      final currentWins = state.value!['wins'] ?? 0;
      final currentLosses = state.value!['losses'] ?? 0;
      state = AsyncData({
        'wins': currentWins + (result == 'win' ? 1 : 0),
        'losses': currentLosses + (result == 'loss' ? 1 : 0),
      });
    }

    // 2. 백그라운드에서 조용히 서버로 저장 요청 (사용자는 이미 갱신된 UI를 보고 있음)
    try {
      final repository = AuthRepositoryImpl();
      await repository.recordResult(user.username, result);
    } catch (e) {
      print("기록 실패: $e");
    }
  }
}
