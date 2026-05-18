import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'output_target.dart';

// ---------------------------------------------------------------------------
// ChromecastOutput
// Output Google Cast via Cast V2 protocol over TLS + protobuf-like JSON.
// Miroir de ChromecastOutput.swift (iOS skeleton) / pychromecast (Linux)
//
// Cast V2 protocol uses a persistent TLS connection on port 8009.
// Messages are length-prefixed protobufs, but the payload is JSON.
// We implement a minimal Cast V2 client that:
//   1. Connects via TLS to device:8009
//   2. Sends CONNECT to receiver-0
//   3. Launches the Default Media Receiver (CC1AD845)
//   4. Sends CONNECT to the transport (session)
//   5. Sends LOAD / PLAY / PAUSE / STOP / SEEK / SET_VOLUME on media channel
//
// Actions implemented:
//   Launch app, Load media, Play, Pause, Stop, Seek, SetVolume, Status polling
// ---------------------------------------------------------------------------

/// Default Media Receiver app ID.
const _kDefaultMediaReceiverAppId = 'CC1AD845';

/// Cast V2 namespaces.
const _nsConnection = 'urn:x-cast:com.google.cast.tp.connection';
const _nsHeartbeat = 'urn:x-cast:com.google.cast.tp.heartbeat';
const _nsReceiver = 'urn:x-cast:com.google.cast.receiver';
const _nsMedia = 'urn:x-cast:com.google.cast.media';

class ChromecastOutput implements OutputTarget {
  @override
  final String id;

  @override
  final String displayName;

  final String host;
  final int port;

  OutputReadyState _readyState = OutputReadyState.idle;
  double _volume = 1.0;
  bool _playing = false;

  // Cast V2 connection state
  SecureSocket? _socket;
  String? _sessionId;
  String? _transportId;
  int _mediaSessionId = 0;
  int _requestId = 0;
  Timer? _heartbeatTimer;
  final _pendingRequests = <int, Completer<Map<String, dynamic>>>{};
  final _incomingBuffer = <int>[];

  // Position tracking from last status
  Duration _lastKnownPosition = Duration.zero;
  Duration _lastKnownDuration = Duration.zero;
  DateTime? _lastPositionTimestamp;

  ChromecastOutput({
    required this.id,
    required this.displayName,
    required this.host,
    this.port = 8009,
  });

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> prepare() async {
    _readyState = OutputReadyState.preparing;
    try {
      await _connect();
      await _connectChannel('sender-0', 'receiver-0', _nsConnection);
      _startHeartbeat();

      // Get current receiver status to check volume
      final status = await _getReceiverStatus();
      if (status != null) {
        final vol = status['status']?['volume']?['level'];
        if (vol is num) {
          _volume = vol.toDouble().clamp(0.0, 1.0);
        }
      }

      _readyState = OutputReadyState.ready;
      debugPrint('[Chromecast] Connected to $displayName ($host:$port)');
      return const OutputSuccess();
    } catch (e) {
      _readyState = OutputReadyState.error;
      debugPrint('[Chromecast] prepare failed: $e');
      return OutputFailure('Chromecast prepare failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _pendingRequests.clear();

    try {
      if (_transportId != null) {
        _sendMessage(
          sourceId: 'sender-0',
          destinationId: _transportId!,
          namespace: _nsConnection,
          payload: {'type': 'CLOSE'},
        );
      }
      _sendMessage(
        sourceId: 'sender-0',
        destinationId: 'receiver-0',
        namespace: _nsConnection,
        payload: {'type': 'CLOSE'},
      );
    } catch (_) {}

    await _socket?.close();
    _socket = null;
    _sessionId = null;
    _transportId = null;
    _mediaSessionId = 0;
    _readyState = OutputReadyState.idle;
    _playing = false;
  }

  // ---------------------------------------------------------------------------
  // Transport
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> play(
    String url, {
    String? title,
    String? artist,
    String? album,
    String? albumArtUrl,
    int? durationMs,
  }) async {
    try {
      // 1. Launch the Default Media Receiver if not already running
      await _ensureAppLaunched();

      // 2. Load media
      final reqId = _nextRequestId();
      final metadata = <String, dynamic>{
        'metadataType': 3, // MusicTrackMediaMetadata
        if (title != null) 'title': title,
        if (artist != null) 'artist': artist,
        if (albumArtUrl != null)
          'images': [
            {'url': albumArtUrl}
          ],
        if (durationMs != null) 'duration': durationMs / 1000.0,
      };

      final loadPayload = <String, dynamic>{
        'type': 'LOAD',
        'requestId': reqId,
        'media': {
          'contentId': url,
          'contentType': _guessMimeType(url),
          'streamType': 'BUFFERED',
          'metadata': metadata,
        },
        'autoplay': true,
      };

      final response = await _sendMediaCommand(loadPayload, reqId);
      if (response != null) {
        _updatePositionFromStatus(response);
        _playing = true;
        debugPrint('[Chromecast] Playing: ${title ?? url} on $displayName');
        return const OutputSuccess();
      }
      return const OutputFailure('Chromecast LOAD: no response');
    } catch (e) {
      return OutputFailure('Chromecast Play failed: $e');
    }
  }

  @override
  Future<OutputResult> pause() async {
    try {
      final reqId = _nextRequestId();
      await _sendMediaCommand({
        'type': 'PAUSE',
        'requestId': reqId,
        'mediaSessionId': _mediaSessionId,
      }, reqId);
      _playing = false;
      _lastPositionTimestamp = null;
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('Chromecast Pause failed: $e');
    }
  }

  @override
  Future<OutputResult> resume() async {
    try {
      final reqId = _nextRequestId();
      await _sendMediaCommand({
        'type': 'PLAY',
        'requestId': reqId,
        'mediaSessionId': _mediaSessionId,
      }, reqId);
      _playing = true;
      _lastPositionTimestamp = DateTime.now();
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('Chromecast Resume failed: $e');
    }
  }

  @override
  Future<OutputResult> stop() async {
    try {
      final reqId = _nextRequestId();
      await _sendMediaCommand({
        'type': 'STOP',
        'requestId': reqId,
        'mediaSessionId': _mediaSessionId,
      }, reqId);
      _playing = false;
      _lastKnownPosition = Duration.zero;
      _lastPositionTimestamp = null;
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('Chromecast Stop failed: $e');
    }
  }

  @override
  Future<OutputResult> seek(Duration position) async {
    try {
      final reqId = _nextRequestId();
      final response = await _sendMediaCommand({
        'type': 'SEEK',
        'requestId': reqId,
        'mediaSessionId': _mediaSessionId,
        'currentTime': position.inMilliseconds / 1000.0,
      }, reqId);
      if (response != null) {
        _updatePositionFromStatus(response);
      }
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('Chromecast Seek failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> setVolume(double volume) async {
    try {
      final reqId = _nextRequestId();
      _sendMessage(
        sourceId: 'sender-0',
        destinationId: 'receiver-0',
        namespace: _nsReceiver,
        payload: {
          'type': 'SET_VOLUME',
          'requestId': reqId,
          'volume': {
            'level': volume.clamp(0.0, 1.0),
          },
        },
      );
      _volume = volume.clamp(0.0, 1.0);
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure('Chromecast SetVolume failed: $e');
    }
  }

  @override
  double? get currentVolume => _volume;

  // ---------------------------------------------------------------------------
  // Position
  // ---------------------------------------------------------------------------

  @override
  Future<Duration?> currentPosition() async {
    // Try to get fresh status from the device
    try {
      final status = await _getMediaStatus();
      if (status != null) {
        _updatePositionFromStatus(status);
        return _lastKnownPosition;
      }
    } catch (_) {}

    // Fallback: estimate from last known position + elapsed time
    if (_lastPositionTimestamp != null && _playing) {
      final elapsed = DateTime.now().difference(_lastPositionTimestamp!);
      return _lastKnownPosition + elapsed;
    }
    return _lastKnownPosition;
  }

  @override
  Future<Duration?> duration() async {
    if (_lastKnownDuration > Duration.zero) return _lastKnownDuration;

    try {
      final status = await _getMediaStatus();
      if (status != null) {
        _updatePositionFromStatus(status);
        return _lastKnownDuration;
      }
    } catch (_) {}
    return null;
  }

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  @override
  OutputReadyState get readyState => _readyState;

  @override
  bool get isPlaying => _playing;

  // ---------------------------------------------------------------------------
  // Cast V2 Protocol — TLS connection
  // ---------------------------------------------------------------------------

  Future<void> _connect() async {
    _socket = await SecureSocket.connect(
      host,
      port,
      onBadCertificate: (_) => true, // Cast devices use self-signed certs
      timeout: const Duration(seconds: 10),
    );

    _socket!.listen(
      _onData,
      onError: (e) {
        debugPrint('[Chromecast] socket error: $e');
        _readyState = OutputReadyState.error;
      },
      onDone: () {
        debugPrint('[Chromecast] socket closed');
        _readyState = OutputReadyState.idle;
        _playing = false;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Cast V2 Protocol — Message framing
  //
  // Each message is: [4 bytes big-endian length][protobuf CastMessage]
  //
  // We use a simplified approach: since CastMessage protobuf has a known
  // structure, we build/parse it manually without a protobuf dependency.
  //
  // CastMessage fields (proto field numbers):
  //   1: protocol_version (varint, always 0 = CASTV2_1_0)
  //   2: source_id (string)
  //   3: destination_id (string)
  //   4: namespace (string)
  //   5: payload_type (varint, 0 = STRING)
  //   6: payload_utf8 (string)
  // ---------------------------------------------------------------------------

  void _sendMessage({
    required String sourceId,
    required String destinationId,
    required String namespace,
    required Map<String, dynamic> payload,
  }) {
    final payloadJson = jsonEncode(payload);
    final proto = _encodeCastMessage(
      sourceId: sourceId,
      destinationId: destinationId,
      namespace: namespace,
      payloadUtf8: payloadJson,
    );

    // Length prefix (4 bytes big-endian)
    final length = proto.length;
    final frame = <int>[
      (length >> 24) & 0xFF,
      (length >> 16) & 0xFF,
      (length >> 8) & 0xFF,
      length & 0xFF,
      ...proto,
    ];

    _socket?.add(frame);
  }

  /// Encode a CastMessage protobuf manually.
  List<int> _encodeCastMessage({
    required String sourceId,
    required String destinationId,
    required String namespace,
    required String payloadUtf8,
  }) {
    final buf = <int>[];

    // Field 1: protocol_version = 0 (CASTV2_1_0), varint
    buf.addAll(_protoVarint(1, 0));

    // Field 2: source_id (length-delimited string)
    buf.addAll(_protoString(2, sourceId));

    // Field 3: destination_id
    buf.addAll(_protoString(3, destinationId));

    // Field 4: namespace
    buf.addAll(_protoString(4, namespace));

    // Field 5: payload_type = 0 (STRING), varint
    buf.addAll(_protoVarint(5, 0));

    // Field 6: payload_utf8
    buf.addAll(_protoString(6, payloadUtf8));

    return buf;
  }

  /// Encode a varint field.
  List<int> _protoVarint(int fieldNumber, int value) {
    final tag = (fieldNumber << 3) | 0; // wire type 0 = varint
    final result = <int>[];
    result.addAll(_encodeVarint(tag));
    result.addAll(_encodeVarint(value));
    return result;
  }

  /// Encode a length-delimited string field.
  List<int> _protoString(int fieldNumber, String value) {
    final tag = (fieldNumber << 3) | 2; // wire type 2 = length-delimited
    final bytes = utf8.encode(value);
    final result = <int>[];
    result.addAll(_encodeVarint(tag));
    result.addAll(_encodeVarint(bytes.length));
    result.addAll(bytes);
    return result;
  }

  List<int> _encodeVarint(int value) {
    final result = <int>[];
    var v = value;
    while (v > 0x7F) {
      result.add((v & 0x7F) | 0x80);
      v >>= 7;
    }
    result.add(v & 0x7F);
    return result;
  }

  // ---------------------------------------------------------------------------
  // Cast V2 Protocol — Receive and parse
  // ---------------------------------------------------------------------------

  void _onData(List<int> data) {
    _incomingBuffer.addAll(data);
    _processBuffer();
  }

  void _processBuffer() {
    while (_incomingBuffer.length >= 4) {
      // Read 4-byte big-endian length
      final length = (_incomingBuffer[0] << 24) |
          (_incomingBuffer[1] << 16) |
          (_incomingBuffer[2] << 8) |
          _incomingBuffer[3];

      if (_incomingBuffer.length < 4 + length) break; // incomplete message

      final messageBytes = _incomingBuffer.sublist(4, 4 + length);
      _incomingBuffer.removeRange(0, 4 + length);

      _handleMessage(messageBytes);
    }
  }

  void _handleMessage(List<int> messageBytes) {
    try {
      final parsed = _decodeCastMessage(messageBytes);
      if (parsed == null) return;

      final namespace = parsed['namespace'] as String;
      final payloadStr = parsed['payload'] as String;

      Map<String, dynamic>? payload;
      try {
        payload = jsonDecode(payloadStr) as Map<String, dynamic>;
      } catch (_) {
        return;
      }

      final type = payload['type'] as String? ?? '';

      // Handle heartbeat PING
      if (namespace == _nsHeartbeat && type == 'PING') {
        _sendMessage(
          sourceId: parsed['destinationId'] as String,
          destinationId: parsed['sourceId'] as String,
          namespace: _nsHeartbeat,
          payload: {'type': 'PONG'},
        );
        return;
      }

      // Handle receiver status (app launched)
      if (namespace == _nsReceiver && type == 'RECEIVER_STATUS') {
        _handleReceiverStatus(payload);
      }

      // Handle media status
      if (namespace == _nsMedia && type == 'MEDIA_STATUS') {
        _handleMediaStatus(payload);
      }

      // Complete pending requests
      final requestId = payload['requestId'];
      if (requestId is int && _pendingRequests.containsKey(requestId)) {
        _pendingRequests.remove(requestId)?.complete(payload);
      }
    } catch (e) {
      debugPrint('[Chromecast] handleMessage error: $e');
    }
  }

  /// Decode a CastMessage protobuf manually.
  Map<String, dynamic>? _decodeCastMessage(List<int> bytes) {
    final result = <String, dynamic>{};
    var offset = 0;

    while (offset < bytes.length) {
      if (offset >= bytes.length) break;
      final (tag, newOffset) = _readVarint(bytes, offset);
      offset = newOffset;

      final fieldNumber = tag >> 3;
      final wireType = tag & 0x7;

      if (wireType == 0) {
        // Varint
        final (value, nextOffset) = _readVarint(bytes, offset);
        offset = nextOffset;
        if (fieldNumber == 1) result['protocolVersion'] = value;
        if (fieldNumber == 5) result['payloadType'] = value;
      } else if (wireType == 2) {
        // Length-delimited
        final (length, nextOffset) = _readVarint(bytes, offset);
        offset = nextOffset;
        if (offset + length > bytes.length) break;
        final data = bytes.sublist(offset, offset + length);
        offset += length;

        final str = utf8.decode(data, allowMalformed: true);
        switch (fieldNumber) {
          case 2:
            result['sourceId'] = str;
          case 3:
            result['destinationId'] = str;
          case 4:
            result['namespace'] = str;
          case 6:
            result['payload'] = str;
          case 7:
            result['payloadBinary'] = data;
        }
      } else {
        // Unknown wire type — skip (best effort)
        break;
      }
    }

    if (result.containsKey('namespace') && result.containsKey('payload')) {
      return result;
    }
    return null;
  }

  (int, int) _readVarint(List<int> bytes, int offset) {
    var result = 0;
    var shift = 0;
    while (offset < bytes.length) {
      final b = bytes[offset++];
      result |= (b & 0x7F) << shift;
      if ((b & 0x80) == 0) break;
      shift += 7;
    }
    return (result, offset);
  }

  // ---------------------------------------------------------------------------
  // Cast V2 Protocol — Channel management
  // ---------------------------------------------------------------------------

  Future<void> _connectChannel(
      String sourceId, String destinationId, String namespace) async {
    _sendMessage(
      sourceId: sourceId,
      destinationId: destinationId,
      namespace: namespace,
      payload: {
        'type': 'CONNECT',
        'origin': {},
      },
    );
    // Small delay for the connection to be established
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      try {
        _sendMessage(
          sourceId: 'sender-0',
          destinationId: 'receiver-0',
          namespace: _nsHeartbeat,
          payload: {'type': 'PING'},
        );
      } catch (e) {
        debugPrint('[Chromecast] heartbeat error: $e');
      }
    });
  }

  // ---------------------------------------------------------------------------
  // App launch & session management
  // ---------------------------------------------------------------------------

  Future<void> _ensureAppLaunched() async {
    if (_sessionId != null && _transportId != null) return;

    // Launch the Default Media Receiver
    final reqId = _nextRequestId();
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[reqId] = completer;

    _sendMessage(
      sourceId: 'sender-0',
      destinationId: 'receiver-0',
      namespace: _nsReceiver,
      payload: {
        'type': 'LAUNCH',
        'requestId': reqId,
        'appId': _kDefaultMediaReceiverAppId,
      },
    );

    // Wait for RECEIVER_STATUS with the app session
    await completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => <String, dynamic>{},
    );

    // If the response itself didn't populate sessionId/transportId,
    // wait a bit and check again
    if (_sessionId == null) {
      await Future.delayed(const Duration(seconds: 1));
      if (_sessionId == null) {
        // Try getting status again
        final status = await _getReceiverStatus();
        if (status != null) {
          _handleReceiverStatus(status);
        }
      }
    }

    if (_sessionId == null || _transportId == null) {
      throw StateError('Failed to launch Cast app — no session received');
    }
  }

  void _handleReceiverStatus(Map<String, dynamic> payload) {
    final status = payload['status'] as Map<String, dynamic>?;
    if (status == null) return;

    // Update volume
    final vol = status['volume']?['level'];
    if (vol is num) {
      _volume = vol.toDouble().clamp(0.0, 1.0);
    }

    // Check for running app session
    final apps = status['applications'] as List<dynamic>?;
    if (apps != null && apps.isNotEmpty) {
      final app = apps[0] as Map<String, dynamic>;
      final appId = app['appId'] as String?;
      if (appId == _kDefaultMediaReceiverAppId) {
        _sessionId = app['sessionId'] as String?;
        _transportId = app['transportId'] as String?;

        // Connect to the transport
        if (_transportId != null) {
          _sendMessage(
            sourceId: 'sender-0',
            destinationId: _transportId!,
            namespace: _nsConnection,
            payload: {
              'type': 'CONNECT',
              'origin': {},
            },
          );
        }
      }
    }
  }

  void _handleMediaStatus(Map<String, dynamic> payload) {
    final statusList = payload['status'] as List<dynamic>?;
    if (statusList == null || statusList.isEmpty) return;

    final status = statusList[0] as Map<String, dynamic>;
    final msid = status['mediaSessionId'];
    if (msid is int) _mediaSessionId = msid;

    final playerState = status['playerState'] as String?;
    if (playerState != null) {
      _playing = playerState == 'PLAYING' || playerState == 'BUFFERING';
    }

    _updatePositionFromMediaStatus(status);
  }

  // ---------------------------------------------------------------------------
  // Media commands
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> _sendMediaCommand(
      Map<String, dynamic> payload, int reqId) async {
    if (_transportId == null) return null;

    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[reqId] = completer;

    _sendMessage(
      sourceId: 'sender-0',
      destinationId: _transportId!,
      namespace: _nsMedia,
      payload: payload,
    );

    try {
      return await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => <String, dynamic>{},
      );
    } catch (e) {
      debugPrint('[Chromecast] media command error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getReceiverStatus() async {
    final reqId = _nextRequestId();
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[reqId] = completer;

    _sendMessage(
      sourceId: 'sender-0',
      destinationId: 'receiver-0',
      namespace: _nsReceiver,
      payload: {
        'type': 'GET_STATUS',
        'requestId': reqId,
      },
    );

    try {
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => <String, dynamic>{},
      );
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getMediaStatus() async {
    if (_transportId == null) return null;

    final reqId = _nextRequestId();
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[reqId] = completer;

    _sendMessage(
      sourceId: 'sender-0',
      destinationId: _transportId!,
      namespace: _nsMedia,
      payload: {
        'type': 'GET_STATUS',
        'requestId': reqId,
      },
    );

    try {
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => <String, dynamic>{},
      );
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Position tracking
  // ---------------------------------------------------------------------------

  void _updatePositionFromStatus(Map<String, dynamic> response) {
    final statusList = response['status'] as List<dynamic>?;
    if (statusList == null || statusList.isEmpty) return;
    _updatePositionFromMediaStatus(statusList[0] as Map<String, dynamic>);
  }

  void _updatePositionFromMediaStatus(Map<String, dynamic> status) {
    final currentTime = status['currentTime'];
    if (currentTime is num) {
      _lastKnownPosition =
          Duration(milliseconds: (currentTime.toDouble() * 1000).round());
      _lastPositionTimestamp = DateTime.now();
    }

    final media = status['media'] as Map<String, dynamic>?;
    if (media != null) {
      final dur = media['duration'];
      if (dur is num) {
        _lastKnownDuration =
            Duration(milliseconds: (dur.toDouble() * 1000).round());
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  int _nextRequestId() => ++_requestId;

  String _guessMimeType(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('.flac')) return 'audio/flac';
    if (lower.contains('.wav')) return 'audio/wav';
    if (lower.contains('.ogg')) return 'audio/ogg';
    if (lower.contains('.opus')) return 'audio/ogg; codecs=opus';
    if (lower.contains('.aac') || lower.contains('.m4a')) return 'audio/mp4';
    if (lower.contains('.aiff') || lower.contains('.aif')) return 'audio/aiff';
    if (lower.contains('.ape')) return 'audio/x-ape';
    if (lower.contains('.wv')) return 'audio/x-wavpack';
    return 'audio/mpeg'; // default to MP3
  }
}
