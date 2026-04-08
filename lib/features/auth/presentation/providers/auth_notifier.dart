import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/auth/domain/entities/user.dart';
import 'package:sudoku_999/features/auth/data/repositories/auth_repository_impl.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    return const AsyncData(null); // 초기 상태는 로그인 안 됨
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

  void logout() {
    state = const AsyncData(null);
  }
}
