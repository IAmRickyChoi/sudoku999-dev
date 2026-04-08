import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_provider.g.dart'; // 코드 생성 필요

@Riverpod(keepAlive: true)
class TimerNotifier extends _$TimerNotifier {
  Timer? _timer;

  @override
  int build() {
    // 프로바이더가 파기될 때 타이머 리소스 해제 (메모리 누수 방지)
    ref.onDispose(() => _timer?.cancel());
    return 0; // 초기 시간 0초
  }

  void start(int initialSeconds) {
    state = initialSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state++; // 1초마다 상태(State) 증가
    });
  }

  void pause() {
    _timer?.cancel();
  }

  void reset() {
    _timer?.cancel();
    state = 0;
  }
}
