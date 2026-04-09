import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_999/features/auth/presentation/providers/auth_notifier.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_notifier.dart';
import 'package:sudoku_999/features/game/presentation/providers/vs_notifier.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final vsState = ref.watch(vsProvider);

    ref.listen<VsState>(vsProvider, (previous, next) {
      if (previous?.status == VsStatus.waiting &&
          next.status == VsStatus.matched) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        if (next.seed != null) {
          // [수정됨] VS 모드에서는 서버가 준 시드값으로 '새 게임'을 시작합니다!
          ref
              .read(gameProvider.notifier)
              .startGame(next.seed!, Difficulty.medium);
          context.push('/game');
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.username ?? "Guest"}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // 기존 싱글 플레이어 버튼
            FilledButton.icon(
              onPressed: () {
                // [수정됨] 싱글 플레이를 누르면 서버에서 세이브 데이터를 먼저 찾아봅니다 (ロード試行)
                ref.read(gameProvider.notifier).loadSavedGame();
                context.push('/game');
              },
              icon: const Icon(Icons.person),
              label: const Text('Single Player (シングルプレイ)'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 새로운 실시간 VS 모드 버튼
            FilledButton.tonalIcon(
              onPressed: () {
                if (user != null) {
                  ref.read(vsProvider.notifier).startMatchmaking(user.username);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('매칭 중...'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('상대방을 기다리고 있습니다.'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ref.read(vsProvider.notifier).disconnect();
                              Navigator.of(context).pop();
                            },
                            child: const Text('취소 (キャンセル)'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.people_alt_rounded),
              label: const Text('Online VS Mode (オンライン対戦)'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
