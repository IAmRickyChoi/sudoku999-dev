import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class VsRepository {
  WebSocketChannel? _channel;

  // 웹소켓 연결 (接続, せつぞく)
  void connect(String username) {
    // NAS의 IP 주소와 포트 번호를 입력합니다. ws:// 프로토콜을 사용합니다.
    final wsUrl = Uri.parse('ws://192.168.1.163:8080/ws/match?user=$username');
    _channel = WebSocketChannel.connect(wsUrl);
  }

  // 서버로부터 오는 메시지를 지속적으로 수신하기 위한 스트림 (ストリーム)
  Stream<dynamic>? get messageStream => _channel?.stream;

  // 내 게임 진행도를 서버로 전송 (送信, そうしん)
  void sendProgress(int progressPercent) {
    if (_channel != null) {
      final msg = jsonEncode({'type': 'progress', 'percent': progressPercent});
      _channel!.sink.add(msg);
    }
  }

  // 연결 종료 (切断, せつだん)
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
