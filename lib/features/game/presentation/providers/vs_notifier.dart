import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/data/repositories/vs_repository.dart';

part 'vs_notifier.g.dart';

enum VsStatus { disconnected, waiting, matched }

class VsState {
  final VsStatus status;
  final int opponentProgress;
  final int? seed;

  VsState({
    this.status = VsStatus.disconnected,
    this.opponentProgress = 0,
    this.seed,
  });

  VsState copyWith({VsStatus? status, int? opponentProgress, int? seed}) {
    return VsState(
      status: status ?? this.status,
      opponentProgress: opponentProgress ?? this.opponentProgress,
      seed: seed ?? this.seed,
    );
  }
}

@Riverpod(keepAlive: true)
class VsNotifier extends _$VsNotifier {
  final VsRepository _repository = VsRepository();

  @override
  VsState build() {
    ref.onDispose(() {
      _repository.disconnect();
    });
    return VsState();
  }

  void startMatchmaking(String username) {
    state = state.copyWith(status: VsStatus.waiting, opponentProgress: 0);
    _repository.connect(username);

    _repository.messageStream?.listen(
      (message) {
        final data = jsonDecode(message);

        if (data['type'] == 'matched') {
          // [핵심 복구] 웹(크롬)에서 큰 숫자가 double로 들어올 때 앱이 터지는 것을 방지
          final dynamic rawSeed = data['seed'];
          final int seedValue = (rawSeed is num) ? rawSeed.toInt() : 0;

          state = state.copyWith(status: VsStatus.matched, seed: seedValue);
        } else if (data['type'] == 'progress') {
          // 진행도(percent) 역시 방어 코드 적용
          final dynamic rawPercent = data['percent'];
          final int percentValue = (rawPercent is num) ? rawPercent.toInt() : 0;

          state = state.copyWith(opponentProgress: percentValue);
        }
      },
      onDone: () {
        state = state.copyWith(status: VsStatus.disconnected);
      },
      onError: (error) {
        state = state.copyWith(status: VsStatus.disconnected);
      },
    );
  }

  void sendMyProgress(int currentProgressPercent) {
    if (state.status == VsStatus.matched) {
      _repository.sendProgress(currentProgressPercent);
    }
  }

  void disconnect() {
    _repository.disconnect();
    state = VsState();
  }
}
