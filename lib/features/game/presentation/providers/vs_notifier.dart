import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sudoku_999/features/game/data/repositories/vs_repository.dart';

part 'vs_notifier.g.dart';

// VS 모드의 현재 상태를 나타내는 열거형 (列挙型, れっきょがた)
enum VsStatus { disconnected, waiting, matched }

// 상태를 담는 객체 (状態オブジェクト)
class VsState {
  final VsStatus status;
  final int opponentProgress;
  final int? seed; // 서버에서 받은 동일한 퍼즐용 시드값

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
    // 프로바이더가 파기될 때 웹소켓 연결도 안전하게 해제 (メモリリーク防止)
    ref.onDispose(() {
      _repository.disconnect();
    });
    return VsState();
  }

  // 매치메이킹 시작 (マッチメイキング開始)
  void startMatchmaking(String username) {
    state = state.copyWith(status: VsStatus.waiting, opponentProgress: 0);
    _repository.connect(username);

    // 서버로부터 수신되는 메시지 리스닝 (リスニング)
    _repository.messageStream?.listen(
      (message) {
        final data = jsonDecode(message);

        if (data['type'] == 'matched') {
          // 매칭이 성사되면 시드값을 받고 상태를 matched로 변경
          state = state.copyWith(status: VsStatus.matched, seed: data['seed']);
        } else if (data['type'] == 'progress') {
          // 상대방의 진행도가 도착하면 업데이트 (UI에 반영됨)
          state = state.copyWith(opponentProgress: data['percent']);
        }
      },
      onDone: () {
        // 서버와 연결이 끊어졌을 때의 처리
        state = state.copyWith(status: VsStatus.disconnected);
      },
      onError: (error) {
        state = state.copyWith(status: VsStatus.disconnected);
      },
    );
  }

  // 내 진행도를 서버로 전송
  void sendMyProgress(int currentProgressPercent) {
    if (state.status == VsStatus.matched) {
      _repository.sendProgress(currentProgressPercent);
    }
  }

  // 대기 취소 및 연결 해제
  void disconnect() {
    _repository.disconnect();
    state = VsState(); // 초기 상태로 리셋
  }
}
