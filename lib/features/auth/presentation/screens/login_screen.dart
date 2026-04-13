import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku_999/features/auth/presentation/providers/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idController = TextEditingController(text: 'ricky');
  final _pwController = TextEditingController(text: 'password123');

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Online Sudoku',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _pwController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (authState.isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  FilledButton(
                    onPressed: () => ref
                        .read(authProvider.notifier)
                        .login(_idController.text, _pwController.text),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Login (로그인)',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref
                        .read(authProvider.notifier)
                        .register(_idController.text, _pwController.text),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Sign Up (회원가입)',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  if (authState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        '오류: 아이디나 비밀번호를 확인하세요.',
                        style: TextStyle(color: Colors.red[400]),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
