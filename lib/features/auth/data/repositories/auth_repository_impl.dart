import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sudoku_999/features/auth/domain/entities/user.dart';
import 'package:sudoku_999/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // NAS의 IP 주소로 변경하세요. (에뮬레이터 테스트 시 로컬호스트 사용)
  final String baseUrl = 'http://10.0.2.2:8080/api';

  @override
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(username: data['username'], token: data['token']);
    } else {
      throw Exception('Login failed');
    }
  }

  @override
  Future<void> logout() async {
    // 로컬 스토리지 등에 저장된 토큰을 지우는 로직 추가 가능
  }
}
