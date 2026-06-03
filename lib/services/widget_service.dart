import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

// ---------------------------------------------------------------------------
// WidgetService — updates the Android home screen "Now Playing" widget
// via the home_widget package (SharedPreferences + AppWidgetManager).
//
// Called from AppState event handlers whenever the current track or
// playback state changes. Mirrors the pattern used by
// TrackNotificationService but targets the OS widget surface.
// ---------------------------------------------------------------------------

class WidgetService {
  WidgetService._();

  /// Android widget provider class name (fully qualified).
  static const _androidWidgetName = 'NowPlayingWidgetProvider';

  /// Update the home screen widget with current playback info.
  /// Safe to call on any platform — silently no-ops on iOS (no widget
  /// configured there yet).
  static Future<void> updateWidget({
    required String title,
    required String artist,
    String? album,
    required bool isPlaying,
  }) async {
    try {
      await Future.wait([
        HomeWidget.saveWidgetData<String>('widgetTrackTitle', title),
        HomeWidget.saveWidgetData<String>('widgetArtistName', artist),
        HomeWidget.saveWidgetData<String>('widgetAlbumTitle', album ?? ''),
        HomeWidget.saveWidgetData<bool>('widgetIsPlaying', isPlaying),
      ]);
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
      );
    } catch (e) {
      debugPrint('[WidgetService] updateWidget error: $e');
    }
  }

  /// Clear widget data (e.g. when playback stops).
  static Future<void> clearWidget() async {
    try {
      await Future.wait([
        HomeWidget.saveWidgetData<String>('widgetTrackTitle', ''),
        HomeWidget.saveWidgetData<String>('widgetArtistName', ''),
        HomeWidget.saveWidgetData<String>('widgetAlbumTitle', ''),
        HomeWidget.saveWidgetData<bool>('widgetIsPlaying', false),
      ]);
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
      );
    } catch (e) {
      debugPrint('[WidgetService] clearWidget error: $e');
    }
  }
}
