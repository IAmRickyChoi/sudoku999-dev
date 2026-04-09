import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku_999/core/router/app_router.dart';

void main() {
  // Isar 관련 모든 비동기(Async) 초기화 코드를 제거했습니다.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Clean Sudoku Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      routerConfig: router,
    );
  }
}
