import 'dart:async';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../server/discovery/content_directory_client.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/domain_models.dart';
import '../models/enums.dart';
import '../server/database/database.dart';
import '../server/discovery/discovery_manager.dart';
import '../server/event_bus.dart';
import '../server/license/license_manager.dart';
import '../server/server_engine.dart';
import '../server/streaming/radio_metadata_service.dart';
import '../server/streaming/streaming_service.dart';
import '../services/track_notification_service.dart';
import '../services/tune_api_client.dart';
import '../services/widget_service.dart';
import '../services/tune_websocket.dart';
import '../services/update_checker.dart';
import 'library_state.dart';
import 'settings_state.dart';
import 'zone_state.dart';

part 'app_state_library.dart';
part 'app_state_zones.dart';
part 'app_state_radio.dart';
part 'app_state_playback.dart';
part 'app_state_misc.dart';
part 'app_state_lifecycle.dart';
part 'app_state_events.dart';

// ---------------------------------------------------------------------------
// T9.5 — AppState
// ChangeNotifier racine. Orchestre ServerEngine + event loop EventBus
// + délègue vers ZoneState / LibraryState / SettingsState.
// Miroir de AppState.swift (iOS / @Observable)
// ---------------------------------------------------------------------------

class AppState extends ChangeNotifier {
  final ServerEngine engine;
  final ZoneState zoneState;
  final LibraryState libraryState;
  final SettingsState settingsState;

  bool _serverStarted = false;
  String? _errorMessage;

  /// Dernière erreur de lecture (ex: aucune zone sélectionnée).
  /// Les vues peuvent l'observer pour afficher un SnackBar.
  String? _lastPlaybackError;
  String? get lastPlaybackError => _lastPlaybackError;
  void clearPlaybackError() {
    if (_lastPlaybackError == null) return;
    _lastPlaybackError = null;
    notifyListeners();
  }

  /// Dernière erreur liée aux zones (ex: limite du palier Free atteinte).
  /// Les vues l'observent pour proposer un passage Premium.
  String? _lastZoneError;
  String? get lastZoneError => _lastZoneError;
  void clearZoneError() {
    if (_lastZoneError == null) return;
    _lastZoneError = null;
    notifyListeners();
  }

  // Remote mode
  TuneApiClient? _apiClient;
  TuneWebSocket? _webSocket;
  StreamSubscription? _wsSubscription;
  Timer? _remotePollingTimer;
  Timer? _zoneRefreshDebounce;
  bool _refreshingZones = false;

  // Auth token — synced from AuthService, injected into API client
  String? _authToken;

  /// Update the auth token used for API requests. Called by AuthService
  /// when login/logout occurs.
  void setAuthToken(String? token) {
    _authToken = token;
    _apiClient?.authToken = token;
    notifyListeners();
  }

  // Track change notifications
  TrackNotificationService? _trackNotificationService;

  /// Callback for track change notifications. Set this from the UI layer
  /// (e.g. main.dart) to show OS-level or in-app notifications.
  void Function(TrackChangeInfo info)? onTrackChangeNotification;

  TrackNotificationService? get trackNotificationService => _trackNotificationService;

  // Update check — populated on app launch and every 30 min by
  // _refreshUpdateInfo. Drives a banner in SettingsView when a newer
  // tune-server-flutter release is on GitHub. Same UX rhythm as the
  // web client's MAJ badge / macOS menubar update notice.
  UpdateInfo? _updateInfo;
  UpdateInfo? get updateInfo => _updateInfo;
  Timer? _updateCheckTimer;

  // What's New — show a dialog on first launch after update.
  bool _showWhatsNew = false;
  bool get showWhatsNew => _showWhatsNew;
  String? _whatsNewVersion;
  String? get whatsNewVersion => _whatsNewVersion;

  bool get isRemoteMode => settingsState.isRemoteMode;
  bool get isRemoteConnected => _apiClient != null;
  TuneApiClient? get apiClient => _apiClient;

  /// Raw WebSocket event stream (remote mode only). Null in local server mode.
  /// Used by widgets that need to subscribe to specific events directly.
  Stream<Map<String, dynamic>>? get wsEventStream => _webSocket?.eventStream;

  final List<StreamSubscription> _subs = [];

  AppState({
    required this.engine,
    required this.zoneState,
    required this.libraryState,
    required this.settingsState,
  });

  bool get serverStarted => _serverStarted;
  String? get errorMessage => _errorMessage;

  /// Public wrapper for ChangeNotifier.notifyListeners() so part-of
  /// extensions (Playback, Library, Radio…) can trigger UI rebuilds
  /// without bumping into the @protected modifier.
  void notify() => notifyListeners();

  /// Dismiss the What's New dialog and persist the seen version.
  Future<void> dismissWhatsNew() async {
    if (_whatsNewVersion != null) {
      await engine.config.setLastSeenVersion(_whatsNewVersion!);
    }
    _showWhatsNew = false;
    _whatsNewVersion = null;
    notifyListeners();
  }

  /// Non-radio play count for a local track (Progman, #1056).
  Future<int> trackPlays(int trackId) => engine.db.historyRepo.trackPlays(trackId);

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  static Future<AppState> create({
    String qobuzAppId = '798273057',
    String qobuzAppSecret = 'abb21364945c0583309667d13ca3d93a',
  }) async {
    final engine = await ServerEngine.create(
      qobuzAppId: qobuzAppId,
      qobuzAppSecret: qobuzAppSecret,
    );

    final settingsState = SettingsState(engine.config);
    final zoneState = ZoneState();
    final libraryState = LibraryState();

    final app = AppState(
      engine: engine,
      zoneState: zoneState,
      libraryState: libraryState,
      settingsState: settingsState,
    );

    app._subscribeToEventBus();
    return app;
  }

  Future<void> _refreshFavoriteTracks() async {
    final favs = await engine.db.trackRepo.favorites();
    libraryState.setFavoriteTracks(favs);
  }



  // ---------------------------------------------------------------------------
  // Refresh helpers
  // ---------------------------------------------------------------------------

  Future<void> _refreshZones() async {
    final snapshots = engine.zoneManager
        .allZones()
        .map((z) => z.snapshot())
        .toList();
    zoneState.setZones(snapshots);
    zoneState.setDevices(engine.allDevices());
  }

  Future<void> _refreshLibrarySummary() async {
    final results = await Future.wait([
      engine.db.albumRepo.all(),
      engine.db.artistRepo.all(),
      engine.db.albumRepo.allAudioInfo(),
    ]);
    libraryState.setAlbums(results[0] as List<Album>);
    libraryState.setArtists(results[1] as List<Artist>);
    libraryState.setAlbumAudioInfo(results[2] as Map<int, AlbumAudioInfo>);

    // Load recently added albums
    final recent = await engine.db.albumRepo.recent(limit: 30);
    libraryState.setRecentAlbums(recent);
  }

  Future<void> _refreshRadios() async {
    final radios = await engine.db.radioRepo.all();
    libraryState.setRadios(radios);
  }

  Future<void> _refreshPlaylists() async {
    final playlists = await engine.db.playlistRepo.all();
    libraryState.setPlaylists(playlists);
  }

  Future<void> _refreshStreamingStatus() async {
    libraryState.setStreamingServices(engine.streamingManager.status);
  }

  // ---------------------------------------------------------------------------
  // Helpers internes
  // ---------------------------------------------------------------------------

  ZoneWithState? _findZone(String zoneId) {
    final id = int.tryParse(zoneId);
    if (id == null) return null;
    try {
      return zoneState.zones.firstWhere((z) => z.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _resolveUrl(Track track) async {
    if (track.filePath != null) {
      // Local : convertit en URL streamer si c'est un chemin fichier
      if (track.source == 'local' && !track.filePath!.startsWith('http')) {
        return engine.trackStreamUrl(track.filePath!);
      }
      return track.filePath;
    }
    // Streaming : résout via StreamingManager
    if (track.sourceId != null && track.source != 'local') {
      return engine.streamingManager.resolveStreamUrl(
        track.source,
        track.sourceId!,
      );
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  @override
  Future<void> dispose() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
    _subs.clear();
    await engine.stop();
    super.dispose();
  }
}
