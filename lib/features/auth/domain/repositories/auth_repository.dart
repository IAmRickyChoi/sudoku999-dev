import 'package:sudoku_999/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<User> login(String username, String password);
  Future<void> logout();
}
