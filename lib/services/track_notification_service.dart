import 'dart:async';
import 'package:flutter/foundation.dart';
import 'tune_websocket.dart';

// ---------------------------------------------------------------------------
// TrackNotificationService — listens to WebSocket track.changed events
// and triggers a local notification callback. The actual notification display
// is handled by the caller (main.dart or AppState) using
// flutter_local_notifications or a simple SnackBar overlay, depending on
// what packages are available.
//
// This service is intentionally decoupled from flutter_local_notifications
// to avoid a hard dependency — the consumer decides the UI.
// ---------------------------------------------------------------------------

/// Track change info passed to the notification callback.
class TrackChangeInfo {
  final String title;
  final String? artist;
  final String? album;
  final String? coverPath;
  final int? zoneId;
  final String? zoneName;

  const TrackChangeInfo({
    required this.title,
    this.artist,
    this.album,
    this.coverPath,
    this.zoneId,
    this.zoneName,
  });
}

class TrackNotificationService {
  StreamSubscription? _subscription;
  final void Function(TrackChangeInfo info) onTrackChanged;

  TrackNotificationService({required this.onTrackChanged});

  /// Start listening to a WebSocket event stream.
  void listen(TuneWebSocket ws) {
    _subscription?.cancel();
    _subscription = ws.eventStream.listen(_handleEvent);
  }

  void _handleEvent(Map<String, dynamic> event) {
    final type = event['type'] as String? ?? '';

    // Listen for track change events
    if (type == 'playback.track_changed' ||
        type == 'track.changed' ||
        type == 'playback.started') {
      final data = event['data'] as Map<String, dynamic>? ?? event;

      final title = data['track_title'] as String? ??
          data['title'] as String? ??
          (data['track'] is Map ? (data['track'] as Map)['title'] : null) as String?;

      if (title == null || title.isEmpty) return;

      final info = TrackChangeInfo(
        title: title,
        artist: data['artist_name'] as String? ?? data['artist'] as String?,
        album: data['album_title'] as String? ?? data['album'] as String?,
        coverPath: data['cover_path'] as String?,
        zoneId: data['zone_id'] as int?,
        zoneName: data['zone_name'] as String?,
      );

      try {
        onTrackChanged(info);
      } catch (e) {
        debugPrint('[TrackNotification] Callback error: $e');
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
