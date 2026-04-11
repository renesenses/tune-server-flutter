import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

/// WebSocket client for real-time events from a remote Tune server.
/// Mirrors TuneWebSocket.swift (iOS).
class TuneWebSocket {
  final String wsUrl;
  WebSocketChannel? _channel;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _reconnectTimer;
  bool _shouldReconnect = true;

  TuneWebSocket(this.wsUrl);

  Stream<Map<String, dynamic>> get eventStream => _eventController.stream;

  Future<void> connect() async {
    _shouldReconnect = true;
    try {
      final uri = Uri.parse(wsUrl);
      _channel = WebSocketChannel.connect(uri);

      // Subscribe to all events
      _channel!.sink.add(jsonEncode({
        'type': 'subscribe',
        'patterns': ['playback.*', 'zone.*', 'playlist.*', 'library.*', 'device.*', 'radio.*'],
      }));

      _channel!.stream.listen(
        (data) {
          try {
            final event = jsonDecode(data as String) as Map<String, dynamic>;
            _eventController.add(event);
          } catch (e) {
            debugPrint('[WS] Parse error: $e');
          }
        },
        onDone: () {
          debugPrint('[WS] Connection closed');
          _scheduleReconnect();
        },
        onError: (e) {
          debugPrint('[WS] Error: $e');
          _scheduleReconnect();
        },
      );

      debugPrint('[WS] Connected to $wsUrl');
    } catch (e) {
      debugPrint('[WS] Connect error: $e');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      debugPrint('[WS] Reconnecting...');
      connect();
    });
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
