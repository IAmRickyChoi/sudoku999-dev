import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku_999/features/auth/presentation/providers/auth_notifier.dart';
import 'package:sudoku_999/features/auth/presentation/screens/login_screen.dart';
import 'package:sudoku_999/features/game/presentation/screens/game_screen.dart';
import 'package:sudoku_999/features/menu/presentation/screens/menu_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authState.value != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/menu';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/menu', builder: (context, state) => const MenuScreen()),
      GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
    ],
  );
});
