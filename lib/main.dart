import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_999/features/game/data/models/game_session_model.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';
import 'package:sudoku_999/features/game/presentation/screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([GameSessionModelSchema], directory: dir.path);

  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '클린 아키텍처 스도쿠',
      debugShowCheckedModeBanner: false, // 오른쪽 위 디버그 띠 없애기
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Material 3 디자인 적용
        useMaterial3: true,
      ),
      // 시작 화면을 우리가 만든 GameScreen으로 설정합니다.
      home: const GameScreen(),
    );
  }
}
