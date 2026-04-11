import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_999/features/auth/presentation/providers/auth_notifier.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/presentation/providers/game_notifier.dart';
import 'package:sudoku_999/features/game/presentation/providers/vs_notifier.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  // 싱글 플레이 난이도 선택 다이얼로그 (難易度選択)
  Future<Difficulty?> _showDifficultyDialog(BuildContext context) async {
    return showDialog<Difficulty>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '난이도 선택',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Difficulty.values.map((difficulty) {
            return ListTile(
              title: Text(difficulty.name.toUpperCase()),
              leading: _getDifficultyIcon(difficulty),
              onTap: () => Navigator.pop(context, difficulty),
            );
          }).toList(),
        ),
      ),
    );
  }

  Icon _getDifficultyIcon(Difficulty d) {
    switch (d) {
      case Difficulty.easy:
        return const Icon(Icons.child_care, color: Colors.green);
      case Difficulty.medium:
        return const Icon(Icons.directions_run, color: Colors.orange);
      case Difficulty.hard:
        return const Icon(Icons.whatshot, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final vsState = ref.watch(vsProvider);

    // 👇 [가장 중요!!!] 이 코드가 지워지면 매칭이 성공해도 영원히 로딩만 돕니다! (画面遷移リスナー)
    ref.listen<VsState>(vsProvider, (previous, next) {
      if (previous?.status == VsStatus.waiting &&
          next.status == VsStatus.matched) {
        // 1. "매칭 중..." 다이얼로그 닫기
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        // 2. 서버에서 받은 안전한 시드(Seed)로 게임 생성 후 화면 이동
        if (next.seed != null) {
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

            // 1. 새 싱글 게임 시작 (난이도 선택)
            FilledButton.icon(
              onPressed: () async {
                final selectedDifficulty = await _showDifficultyDialog(context);
                if (selectedDifficulty != null) {
                  final seed = DateTime.now().millisecondsSinceEpoch;
                  await ref
                      .read(gameProvider.notifier)
                      .startGame(seed, selectedDifficulty);
                  if (context.mounted) {
                    context.push('/game');
                  }
                }
              },
              icon: const Icon(Icons.add_box_rounded),
              label: const Text('New Single Game (새 게임)'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. 기존 게임 이어하기
            FilledButton.icon(
              onPressed: () async {
                await ref.read(gameProvider.notifier).loadSavedGame();
                if (context.mounted) {
                  context.push('/game');
                }
              },
              icon: const Icon(Icons.save_as_rounded),
              label: const Text('Continue Game (이어하기)'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                backgroundColor: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 40),

            // 3. 실시간 온라인 대전
            FilledButton.tonalIcon(
              onPressed: () {
                if (user != null) {
                  ref.read(vsProvider.notifier).startMatchmaking(user.username);
                  showDialog(
                    context: context,
                    barrierDismissible: false, // 바깥 영역 터치로 못 닫게 방어
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
              label: const Text('Online VS Mode (온라인 대전)'),
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
