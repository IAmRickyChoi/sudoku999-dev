import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/data/repositories/vs_repository.dart';

part 'vs_notifier.g.dart';

// [수정] 상대방 도망침(opponentLeft) 상태 추가
enum VsStatus { disconnected, waiting, matched, opponentLeft }

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
          final dynamic rawSeed = data['seed'];
          final int seedValue = (rawSeed is num) ? rawSeed.toInt() : 0;
          state = state.copyWith(status: VsStatus.matched, seed: seedValue);
        } else if (data['type'] == 'progress') {
          final dynamic rawPercent = data['percent'];
          final int percentValue = (rawPercent is num) ? rawPercent.toInt() : 0;
          state = state.copyWith(opponentProgress: percentValue);
        }
        // 👇 [추가] 서버에서 상대방 도망 메시지를 받으면 상태 변경!
        else if (data['type'] == 'opponent_left') {
          state = state.copyWith(status: VsStatus.opponentLeft);
        }
      },
      onDone: () {
        // 이미 opponentLeft 처리된 게 아니라면 연결 끊김으로 처리
        if (state.status != VsStatus.opponentLeft) {
          state = state.copyWith(status: VsStatus.disconnected);
        }
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
