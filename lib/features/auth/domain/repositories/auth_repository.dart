import 'package:sudoku_999/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> register(String username, String password);
  Future<Map<String, int>> getStats(String username);
  Future<void> recordResult(String username, String result);
  Future<void> logout();
}
