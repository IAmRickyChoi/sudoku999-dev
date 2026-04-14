import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class VsRepository {
  final String wsUrl = 'ws://192.168.1.163:8080/ws/match';
  WebSocketChannel? _channel;

  Stream? get messageStream => _channel?.stream;

  void connect(String username) {
    final uri = Uri.parse('$wsUrl?username=$username');
    _channel = WebSocketChannel.connect(uri);
  }

  void sendProgress(int percent) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({'type': 'progress', 'percent': percent}));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
