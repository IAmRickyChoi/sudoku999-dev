import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku_999/features/auth/presentation/providers/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  bool _isLoginMode = true; // true: 로그인, false: 회원가입
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _submit() {
    // 폼 검증(Validation) 통과 시에만 실행
    if (_formKey.currentState!.validate()) {
      final id = _idController.text.trim();
      final pw = _pwController.text.trim();

      if (_isLoginMode) {
        ref.read(authProvider.notifier).login(id, pw);
      } else {
        ref.read(authProvider.notifier).register(id, pw);
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset(); // 모드 전환 시 에러 메시지 초기화
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // 상태 변화를 감지하여 성공/실패 시 스낵바(알림)를 띄워줍니다.
    ref.listen<AsyncValue>(authProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isLoginMode
                  ? '로그인 실패: 아이디와 비밀번호를 확인하세요.'
                  : '회원가입 실패: 이미 존재하는 아이디이거나 서버 오류입니다.',
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (prev?.isLoading == true &&
          next.hasValue &&
          next.value != null) {
        if (!_isLoginMode) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 회원가입 성공! 환영합니다.'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // 게임 화면과 통일감 있는 배경색
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 및 타이틀 영역
                Icon(Icons.grid_on_rounded, size: 64, color: Colors.blue[700]),
                const SizedBox(height: 16),
                const Text(
                  'Clean Sudoku',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode ? '다시 오신 것을 환영합니다!' : '새로운 계정을 만들어 보세요!',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                ),
                const SizedBox(height: 40),

                // 입력 폼 영역 (카드 스타일)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // 아이디 입력칸
                          TextFormField(
                            controller: _idController,
                            decoration: InputDecoration(
                              labelText: '아이디 (Username)',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '아이디를 입력해 주세요.';
                              }
                              if (value.trim().length < 3) {
                                return '아이디는 3자 이상이어야 합니다.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 비밀번호 입력칸
                          TextFormField(
                            controller: _pwController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: '비밀번호 (Password)',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '비밀번호를 입력해 주세요.';
                              }
                              if (!_isLoginMode && value.trim().length < 6) {
                                return '비밀번호는 6자 이상이어야 합니다.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // 메인 액션 버튼 (로그인 / 회원가입)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: authState.isLoading ? null : _submit,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _isLoginMode
                                          ? '로그인 (Login)'
                                          : '회원가입 (Sign Up)',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 모드 전환 버튼 (계정이 없으신가요?)
                TextButton(
                  onPressed: authState.isLoading ? null : _toggleMode,
                  child: Text(
                    _isLoginMode ? '계정이 없으신가요? 새로 가입하기' : '이미 계정이 있으신가요? 로그인하기',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
