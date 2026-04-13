import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sudoku_999/features/auth/domain/entities/user.dart';
import 'package:sudoku_999/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl = 'http://192.168.1.163:8080/api';

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
  Future<User> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(username: data['username'], token: data['token']);
    } else {
      throw Exception('Register failed');
    }
  }

  @override
  Future<Map<String, int>> getStats(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats?username=$username'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'wins': data['wins'] as int, 'losses': data['losses'] as int};
    }
    return {'wins': 0, 'losses': 0};
  }

  @override
  Future<void> recordResult(String username, String result) async {
    await http.post(
      Uri.parse('$baseUrl/record'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'result': result}),
    );
  }

  @override
  Future<void> logout() async {}
}
