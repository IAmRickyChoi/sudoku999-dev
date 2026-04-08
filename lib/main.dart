import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_999/core/router/app_router.dart';
import 'package:sudoku_999/features/game/data/models/game_session_model.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_providers.dart';

void main() async {
  // 1. Flutter 바인딩 초기화 (バインディング初期化)
  // 비동기 작업(Isar 초기화 등)을 main에서 수행하기 위해 반드시 필요합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Isar 데이터베이스 초기화 (データベース初期化)
  // 기기 내부 저장소 경로를 가져와서 GameSessionModel 스키마를 사용하는 Isar 인스턴스를 오픈합니다.
  final dir = await getApplicationDocumentsDirectory();
  final isarInstance = await Isar.open([
    GameSessionModelSchema,
  ], directory: dir.path);

  runApp(
    // 3. ProviderScope 설정 (프로바이더 범위 설정)
    // Riverpod을 사용하기 위해 앱 전체를 감쌉니다.
    // isarProvider의 UnimplementedError를 실제 생성된 인스턴스로 오버라이드(上書き)합니다.
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isarInstance)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. AppRouter 구독 (ルーターの購読)
    // 인증 상태에 따라 리다이렉션 로직이 포함된 GoRouter 설정을 가져옵니다.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Clean Sudoku Online',
      debugShowCheckedModeBanner: false,

      // 테마 설정 (テーマ設定)
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        fontFamily: 'Pretendard', // 혹은 원하는 폰트
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),

      // GoRouter 연결 (GoRouterの連結)
      routerConfig: router,
    );
  }
}
