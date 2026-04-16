import 'dart:async';
import 'dart:io';

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
import '../server/server_engine.dart';
import '../server/streaming/radio_metadata_service.dart';
import '../server/streaming/streaming_service.dart';
import '../services/tune_api_client.dart';
import '../services/tune_websocket.dart';
import 'library_state.dart';
import 'settings_state.dart';
import 'zone_state.dart';

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

  // Remote mode
  TuneApiClient? _apiClient;
  TuneWebSocket? _webSocket;
  StreamSubscription? _wsSubscription;
  Timer? _remotePollingTimer;

  bool get isRemoteMode => settingsState.isRemoteMode;
  bool get isRemoteConnected => _apiClient != null;
  TuneApiClient? get apiClient => _apiClient;

  final List<StreamSubscription> _subs = [];

  AppState({
    required this.engine,
    required this.zoneState,
    required this.libraryState,
    required this.settingsState,
  });

  bool get serverStarted => _serverStarted;
  String? get errorMessage => _errorMessage;

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

  // ---------------------------------------------------------------------------
  // Lifecycle serveur
  // ---------------------------------------------------------------------------

  Future<void> startServer() async {
    try {
      await engine.start();
      _serverStarted = true;
      _errorMessage = null;

      // Charge les données initiales
      await Future.wait([
        _refreshZones(),
        _refreshLibrarySummary(),
        _refreshRadios(),
        _refreshPlaylists(),
        _refreshStreamingStatus(),
      ]);

      // Charge les devices déjà connus + relance le discovery SSDP
      zoneState.setDevices(engine.allDevices());
      engine.discoveryManager.refresh();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> stopServer() async {
    await engine.stop();
    _serverStarted = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Remote mode — connect to a remote Tune server
  // ---------------------------------------------------------------------------

  Future<void> connectRemote() async {
    final host = settingsState.remoteHost;
    if (host.isEmpty) {
      _errorMessage = 'Adresse serveur non configurée';
      notifyListeners();
      return;
    }
    try {
      _apiClient = TuneApiClient(settingsState.remoteBaseUrl);

      // Test connection
      final ok = await _apiClient!.testConnection();
      if (!ok) {
        _errorMessage = 'Impossible de se connecter à $host';
        _apiClient = null;
        notifyListeners();
        return;
      }

      // Connect WebSocket
      _webSocket = TuneWebSocket(settingsState.remoteWsUrl);
      await _webSocket!.connect();
      _wsSubscription = _webSocket!.eventStream.listen(_handleRemoteEvent);

      _serverStarted = true;
      _errorMessage = null;

      // Load initial data
      await Future.wait([
        refreshZonesRemote(),
        _refreshRadiosRemote(),
        _refreshLibraryRemote(),
        _refreshStreamingServicesRemote(),
      ]);

      // Start polling for position updates (every 3s)
      _remotePollingTimer?.cancel();
      _remotePollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        refreshZonesRemote();
      });

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur connexion: $e';
      _apiClient = null;
      notifyListeners();
    }
  }

  Future<void> disconnectRemote() async {
    _remotePollingTimer?.cancel();
    _remotePollingTimer = null;
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _webSocket?.dispose();
    _webSocket = null;
    _apiClient = null;
    _serverStarted = false;
    zoneState.reset();
    notifyListeners();
  }

  void _handleRemoteEvent(Map<String, dynamic> event) {
    final type = event['type'] as String? ?? '';
    final data = event['data'] as Map<String, dynamic>? ?? {};

    if (type.startsWith('playback.') || type.startsWith('zone.')) {
      // Refresh zones from API
      refreshZonesRemote();
    }
  }

  Future<void> refreshZonesRemote() async {
    if (_apiClient == null) return;
    try {
      final zonesJson = await _apiClient!.getZones();
      final zones = zonesJson.map((z) => ZoneWithState.fromJson(z as Map<String, dynamic>)).toList();
      zoneState.setZones(zones);

      // Load queue for current zone
      final zoneId = zoneState.currentZoneId;
      if (zoneId != null) {
        try {
          final queueJson = await _apiClient!.getQueue(zoneId);
          if (queueJson is Map<String, dynamic>) {
            final tracks = (queueJson['tracks'] as List? ?? [])
                .map((t) => trackFromJson(t as Map<String, dynamic>))
                .toList();
            final position = queueJson['position'] as int? ?? 0;
            final shuffle = queueJson['shuffle'] as bool? ?? false;
            final repeatStr = queueJson['repeat'] as String? ?? 'off';
            zoneState.setQueueSnapshot(QueueSnapshot(
              tracks: tracks,
              position: position,
              shuffleEnabled: shuffle,
              repeatMode: RepeatMode.fromRawValue(repeatStr) ?? RepeatMode.off,
            ));
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('[Remote] refreshZones error: $e');
    }
  }

  Future<void> _refreshRadiosRemote() async {
    if (_apiClient == null) return;
    try {
      final radiosJson = await _apiClient!.getRadios();
      final radios = radiosJson.map((r) => radioFromJson(r as Map<String, dynamic>)).toList();
      libraryState.setRadios(radios);
    } catch (e) {
      debugPrint('[Remote] refreshRadios error: $e');
    }
  }

  Future<void> _refreshLibraryRemote() async {
    if (_apiClient == null) return;
    try {
      final albumsJson = await _apiClient!.getAlbums();
      final albums = albumsJson.map((a) => albumFromJson(a as Map<String, dynamic>)).toList();
      libraryState.setAlbums(albums);

      final artistsJson = await _apiClient!.getArtists();
      final artists = artistsJson.map((a) => artistFromJson(a as Map<String, dynamic>)).toList();
      libraryState.setArtists(artists);

      // Recent albums for Home view
      try {
        final recentJson = await _apiClient!.getRecentAlbums(limit: 30);
        final recent = recentJson.map((a) => albumFromJson(a as Map<String, dynamic>)).toList();
        libraryState.setRecentAlbums(recent);
      } catch (_) {}
    } catch (e) {
      debugPrint('[Remote] refreshLibrary error: $e');
    }
  }

  Future<void> _refreshStreamingServicesRemote() async {
    if (_apiClient == null) return;
    try {
      final data = await _apiClient!.getStreamingServices();
      final services = data.entries.map((e) {
        final info = e.value as Map<String, dynamic>;
        return StreamingServiceStatus(
          serviceId: e.key,
          enabled: info['authenticated'] as bool? ?? false,
          authenticated: info['authenticated'] as bool? ?? false,
          quality: info['quality'] as String?,
        );
      }).toList();
      libraryState.setStreamingServices(services);
    } catch (e) {
      debugPrint('[Remote] refreshStreamingServices error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Event loop — abonnements EventBus
  // ---------------------------------------------------------------------------

  void _subscribeToEventBus() {
    // Playback state
    _subs.add(EventBus.instance
        .subscribe<PlaybackStateChangedEvent>(_onPlaybackStateChanged));

    // Track changed
    _subs.add(EventBus.instance
        .subscribe<TrackChangedEvent>(_onTrackChanged));

    // Position
    _subs.add(EventBus.instance
        .subscribe<PlaybackPositionEvent>(_onPosition));

    // Queue
    _subs.add(EventBus.instance
        .subscribe<QueueChangedEvent>(_onQueueChanged));

    // Devices
    _subs.add(EventBus.instance
        .subscribe<DeviceDiscoveredEvent>(_onDeviceDiscovered));
    _subs.add(EventBus.instance
        .subscribe<DeviceLostEvent>(_onDeviceLost));

    // Library scan
    _subs.add(EventBus.instance
        .subscribe<LibraryScanStartedEvent>((e) => libraryState.setScanStarted(deviceId: e.deviceId)));
    _subs.add(EventBus.instance
        .subscribe<LibraryScanProgressEvent>(_onScanProgress));
    _subs.add(EventBus.instance
        .subscribe<LibraryScanCompletedEvent>(_onScanCompleted));
    _subs.add(EventBus.instance
        .subscribe<LibraryScanErrorEvent>(_onScanError));

    // Radio metadata
    _subs.add(EventBus.instance
        .subscribe<RadioMetadataEvent>(_onRadioMetadata));

    // Zone lifecycle — auto-refresh zones list on changes
    _subs.add(EventBus.instance
        .subscribe<ZoneCreatedEvent>((_) => _refreshZones()));
    _subs.add(EventBus.instance
        .subscribe<ZoneDeletedEvent>((_) => _refreshZones()));
    _subs.add(EventBus.instance
        .subscribe<ZoneUpdatedEvent>((_) => _refreshZones()));

    // Zone grouping
    _subs.add(EventBus.instance
        .subscribe<ZoneGroupedEvent>((_) => _refreshZones()));
    _subs.add(EventBus.instance
        .subscribe<ZoneUngroupedEvent>((_) => _refreshZones()));

    // Server errors
    _subs.add(EventBus.instance
        .subscribe<ServerErrorEvent>(_onServerError));
  }

  void _onPlaybackStateChanged(PlaybackStateChangedEvent e) {
    final zone = _findZone(e.zoneId);
    if (zone != null) {
      final state = PlaybackState.fromRawValue(e.state) ?? PlaybackState.stopped;
      zoneState.updateZone(zone.copyWith(state: state));
    }
  }

  void _onTrackChanged(TrackChangedEvent e) {
    final zone = _findZone(e.zoneId);
    if (zone != null) {
      final track = e.track as Track?;
      zoneState.updateZone(zone.copyWith(currentTrack: track));
      if (track != null) {
        libraryState.prependHistory(track, zoneName: zone.name);
      }
    }
  }

  void _onPosition(PlaybackPositionEvent e) {
    zoneState.updatePosition(
      int.tryParse(e.zoneId) ?? -1,
      e.positionMs,
    );
  }

  void _onQueueChanged(QueueChangedEvent e) {
    final zoneId = int.tryParse(e.zoneId);
    if (zoneId == null) return;
    final instance = engine.zoneManager.zone(zoneId);
    if (instance != null) {
      zoneState.setQueueSnapshot(instance.queue.snapshot());
      zoneState.updateZone(instance.snapshot());
    }
  }

  void _onDeviceDiscovered(DeviceDiscoveredEvent e) {
    zoneState.setDevices(engine.allDevices());
    notifyListeners();
  }

  void _onDeviceLost(DeviceLostEvent e) {
    zoneState.removeDevice(e.deviceId);
    notifyListeners();
  }

  void _onScanProgress(LibraryScanProgressEvent e) {
    libraryState.setScanProgress(e.scanned, e.total);
  }

  Future<void> _onScanCompleted(LibraryScanCompletedEvent e) async {
    libraryState.setScanCompleted(e.tracksAdded, e.tracksUpdated);
    await _refreshLibrarySummary();
    final stats = await engine.stats();
    libraryState.setStats(stats);
  }

  void _onScanError(LibraryScanErrorEvent e) {
    libraryState.setScanCompleted(0, 0);
  }

  void _onRadioMetadata(RadioMetadataEvent e) {
    // L'UI écoute RadioMetadataEvent via EventBus directement pour la radio
    // en cours — pas de stockage dans LibraryState (éphémère)
  }

  void _onServerError(ServerErrorEvent e) {
    _errorMessage = e.message;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Contrôles de lecture
  // ---------------------------------------------------------------------------

  Future<void> play({Track? track, int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;

    if (isRemoteMode && _apiClient != null) {
      if (track != null) {
        final body = <String, dynamic>{};
        if (track.id != 0 && track.source == Source.local.rawValue) {
          body['track_id'] = track.id;
        } else if (track.sourceId != null) {
          body['source'] = track.source;
          body['source_id'] = track.sourceId;
        } else if (track.filePath != null) {
          body['file_path'] = track.filePath;
        }
        await _apiClient!.play(id, body);
      } else {
        await _apiClient!.resume(id);
      }
      await refreshZonesRemote();
      return;
    }

    final instance = engine.zoneManager.zone(id);
    if (instance == null) return;

    if (track != null) {
      final url = await _resolveUrl(track);
      if (url == null) return;
      final resolved = url != track.filePath
          ? track.copyWith(filePath: Value(url))
          : track;
      instance.queue.load([resolved], startIndex: 0);
    }
    await instance.player.play();
  }

  Future<void> pause({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.pause(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.pause();
  }

  Future<void> resume({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.resume(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.resume();
  }

  Future<void> stop({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.pause(id); // no stop endpoint, pause is fine
      return;
    }
    await engine.zoneManager.zone(id)?.player.stop();
  }

  Future<void> next({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.next(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.next();
  }

  Future<void> previous({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.previous(id);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.zone(id)?.player.previous();
  }

  Future<void> seek(Duration position, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.seek(id, position.inMilliseconds);
      return;
    }
    await engine.zoneManager.zone(id)?.player.seek(position);
  }

  Future<void> setVolume(double volume, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.setVolume(id, volume);
      return;
    }
    await engine.zoneManager.setVolume(id, volume);
  }

  Future<void> setShuffle({required bool enabled, int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (isRemoteMode && _apiClient != null) {
      if (id != null) await _apiClient!.setShuffle(id, enabled);
      await refreshZonesRemote();
      return;
    }
    final instance = engine.zoneManager.zone(id ?? -1);
    instance?.queue.setShuffle(enabled: enabled);
    if (instance != null) {
      zoneState.setQueueSnapshot(instance.queue.snapshot());
    }
  }

  Future<void> cycleRepeat({int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (isRemoteMode && _apiClient != null) {
      // Cycle through off → all → one
      final current = zoneState.repeatMode;
      final next = current == RepeatMode.off ? 'all' : current == RepeatMode.all ? 'one' : 'off';
      if (id != null) await _apiClient!.setRepeat(id, next);
      await refreshZonesRemote();
      return;
    }
    final instance = engine.zoneManager.zone(id ?? -1);
    instance?.queue.cycleRepeat();
    if (instance != null) {
      zoneState.setQueueSnapshot(instance.queue.snapshot());
    }
  }

  Future<void> moveQueueItem(int fromIndex, int toIndex, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;
    instance.queue.move(fromIndex, toIndex);
    zoneState.setQueueSnapshot(instance.queue.snapshot());
  }

  Future<void> removeQueueItem(int index, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;
    instance.queue.remove(index);
    zoneState.setQueueSnapshot(instance.queue.snapshot());
  }

  // ---------------------------------------------------------------------------
  // Zones
  // ---------------------------------------------------------------------------

  Future<void> createZone(String name) async {
    await engine.zoneManager.createZone(name);
    await _refreshZones();
  }

  /// Creates a zone directly from a discovered device.
  /// The zone inherits the device's name and output type.
  Future<int> createZoneFromDevice(DiscoveredDevice device) async {
    final outputType = device.type == 'renderer'
        ? OutputType.dlna
        : OutputType.local;
    final instance = await engine.zoneManager.createZone(
      device.name,
      outputType: outputType,
      device: device,
    );
    await _refreshZones();
    zoneState.setCurrentZoneId(instance.zone.id);
    return instance.zone.id;
  }

  Future<void> deleteZone(int zoneId) async {
    await engine.zoneManager.deleteZone(zoneId);
    await _refreshZones();
  }

  Future<void> renameZone(int zoneId, String newName) async {
    await engine.zoneManager.renameZone(zoneId, newName);
    await _refreshZones();
  }

  Future<void> setZoneOutput(
    int zoneId,
    OutputType outputType, {
    String? deviceId,
  }) async {
    DiscoveredDevice? device;
    if (deviceId != null) {
      try {
        device = zoneState.devices.firstWhere((d) => d.id == deviceId);
      } catch (_) {}
    }
    await engine.zoneManager.setOutput(zoneId, type: outputType, device: device);
    await _refreshZones();
  }

  // ---------------------------------------------------------------------------
  // Multi-room grouping
  // ---------------------------------------------------------------------------

  Future<void> groupZones(int leaderId, List<int> followerIds) async {
    final allIds = [leaderId, ...followerIds];
    await engine.zoneManager.groupZones(leaderId, allIds);
    await _refreshZones();
  }

  Future<void> ungroupZones(String groupId) async {
    await engine.zoneManager.ungroupZones(groupId);
    await _refreshZones();
  }

  Future<void> updateSyncDelay(int zoneId, int delayMs) async {
    await engine.zoneManager.setSyncDelay(zoneId, delayMs);
    await _refreshZones();
  }

  /// Sélectionne une zone et migre la lecture en cours si nécessaire.
  ///
  /// Si l'ancienne zone jouait, la file + position sont transférées vers la
  /// nouvelle zone, et l'ancienne est stoppée — une seule zone joue à la fois.
  Future<void> selectZone(int newZoneId) async {
    final oldId = zoneState.currentZoneId;
    if (oldId == newZoneId) return;

    if (isRemoteMode) {
      zoneState.setCurrentZoneId(newZoneId);
      await refreshZonesRemote();
      return;
    }

    final oldInstance = engine.zoneManager.zone(oldId ?? -1);
    final newInstance = engine.zoneManager.zone(newZoneId);

    if (oldInstance != null &&
        newInstance != null &&
        oldInstance.player.isPlaying) {
      final tracks = List<Track>.from(oldInstance.queue.tracks);
      final idx = oldInstance.queue.currentIndex;
      final pos = oldInstance.player.position;

      await oldInstance.player.stop();

      if (tracks.isNotEmpty && idx >= 0) {
        newInstance.queue.load(tracks, startIndex: idx);
        await newInstance.player.play();
        if (pos > const Duration(seconds: 1)) {
          await newInstance.player.seek(pos);
        }
      }
    } else if (oldInstance != null && oldInstance.player.isPlaying) {
      await oldInstance.player.stop();
    }

    zoneState.setCurrentZoneId(newZoneId);
    await _refreshZones();
  }

  // ---------------------------------------------------------------------------
  // Lecture streaming (résolution URL à la volée)
  // ---------------------------------------------------------------------------

  Future<void> playStreaming(
    StreamingSearchResult item, {
    int? zoneId,
  }) async {
    final url = await engine.streamingManager
        .resolveStreamUrl(item.serviceId, item.id);
    if (url == null) return;

    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;

    final track = Track(
      id: 0,
      title: item.title,
      albumTitle: item.album,
      artistName: item.artist,
      filePath: url,
      source: item.serviceId,
      sourceId: item.id,
    );

    instance.queue.load([track], startIndex: 0);
    await instance.player.play();
  }

  /// Charge une liste de pistes streaming dans la queue avec résolution d'URL en parallèle.
  Future<void> playStreamingList(
    List<StreamingSearchResult> items, {
    int startIndex = 0,
    int? zoneId,
  }) async {
    if (items.isEmpty) return;

    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;

    // Résolution des URLs en parallèle
    final urls = await Future.wait(
      items.map((item) =>
          engine.streamingManager.resolveStreamUrl(item.serviceId, item.id)),
    );

    final tracks = <Track>[];
    for (var i = 0; i < items.length; i++) {
      final url = urls[i];
      if (url == null) continue;
      final item = items[i];
      tracks.add(Track(
        id: 0,
        title: item.title,
        albumTitle: item.album,
        artistName: item.artist,
        filePath: url,
        source: item.serviceId,
        sourceId: item.id,
      ));
    }

    if (tracks.isEmpty) return;
    instance.queue.load(tracks, startIndex: startIndex.clamp(0, tracks.length - 1));
    await instance.player.play();
  }

  // ---------------------------------------------------------------------------
  // Radio
  // ---------------------------------------------------------------------------

  Future<void> playRadio(Radio radio, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;

    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.playRadio(radio.id, id);
      await refreshZonesRemote();
      return;
    }

    final httpUrl = radio.streamUrl.replaceFirst('https://', 'http://');
    final instance = engine.zoneManager.zone(id);
    if (instance == null) return;

    final track = Track(
      id: 0,
      title: radio.name,
      filePath: httpUrl,
      source: Source.radio.rawValue,
      sourceId: radio.id.toString(),
    );

    instance.queue.load([track], startIndex: 0);
    await instance.player.play();

    RadioMetadataService.instance.startPolling(
      stationName: radio.name,
      streamUrl: httpUrl,
    );
  }

  // ---------------------------------------------------------------------------
  // Radio — CRUD
  // ---------------------------------------------------------------------------

  Future<void> addRadio({
    required String name,
    required String streamUrl,
    String? logoUrl,
    String? genre,
  }) async {
    await engine.db.radioRepo.insert(RadiosCompanion.insert(
      name: name,
      streamUrl: streamUrl,
      logoUrl: Value(logoUrl),
      genre: Value(genre),
    ));
    await _refreshRadios();
  }

  Future<void> deleteRadio(int id) async {
    await engine.db.radioRepo.delete(id);
    await _refreshRadios();
  }

  Future<void> updateRadio({
    required int id,
    required String name,
    required String streamUrl,
    String? logoUrl,
    String? genre,
  }) async {
    await (engine.db.update(engine.db.radios)
          ..where((r) => r.id.equals(id)))
        .write(RadiosCompanion(
      name: Value(name),
      streamUrl: Value(streamUrl),
      logoUrl: Value(logoUrl),
      genre: Value(genre),
    ));
    await _refreshRadios();
  }

  Future<void> toggleRadioFavorite(Radio radio) async {
    await engine.db.radioRepo.setFavorite(radio.id, favorite: !radio.favorite);
    await _refreshRadios();
  }

  /// Importe des stations depuis du contenu M3U (texte brut).
  Future<int> importM3UContent(String content) async {
    final dir = await getTemporaryDirectory();
    final tmp = File(
        '${dir.path}/import_${DateTime.now().millisecondsSinceEpoch}.m3u');
    await tmp.writeAsString(content);
    final added = await engine.db.radioRepo.importM3U(tmp.path);
    try { await tmp.delete(); } catch (_) {}
    await _refreshRadios();
    return added;
  }

  /// Sauvegarde le morceau en cours dans les favoris radio.
  Future<void> saveRadioFavorite({
    required String title,
    String? artist,
    required Radio radio,
  }) async {
    if (isRemoteMode && _apiClient != null) {
      try {
        await _apiClient!.saveRadioFavorite({
          'title': title,
          'artist': artist ?? '',
          'station_name': radio.name,
          'stream_url': radio.streamUrl,
        });
      } catch (e) {
        debugPrint('[Remote] saveRadioFavorite error: $e');
      }
      return;
    }
    await engine.db.radioRepo.insertFavorite(
      RadioFavoritesCompanion.insert(
        title: title,
        artist: artist ?? '',
        stationName: radio.name,
        streamUrl: radio.streamUrl,
        savedAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bibliothèque
  // ---------------------------------------------------------------------------

  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    // Android 13+ : READ_MEDIA_AUDIO ; Android ≤12 : READ_EXTERNAL_STORAGE
    // On essaie les deux — le système ignorera celui qui n'est pas pertinent.
    final audioStatus = await Permission.audio.request();
    if (audioStatus.isGranted) return true;
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted || storageStatus.isLimited;
  }

  Future<void> scanLibrary() async {
    await requestStoragePermission();
    return engine.scanLibrary();
  }

  Future<void> addMusicFolder(String path) async {
    await requestStoragePermission();
    return engine.addMusicFolder(path);
  }

  Future<List<SearchResult>> search(String query) async {
    libraryState.setSearching(true);
    try {
      if (isRemoteMode && _apiClient != null) {
        final data = await _apiClient!.searchLibrary(query);
        final results = <SearchResult>[];
        if (data is Map<String, dynamic>) {
          for (final t in (data['tracks'] as List? ?? [])) {
            results.add(TrackSearchResult(trackFromJson(t as Map<String, dynamic>)));
          }
          for (final a in (data['albums'] as List? ?? [])) {
            results.add(AlbumSearchResult(albumFromJson(a as Map<String, dynamic>)));
          }
          for (final a in (data['artists'] as List? ?? [])) {
            results.add(ArtistSearchResult(artistFromJson(a as Map<String, dynamic>)));
          }
        }
        libraryState.setSearchResults(query, results);
        return results;
      }
      final results = await engine.search(query);
      libraryState.setSearchResults(query, results);
      return results;
    } catch (_) {
      libraryState.setSearching(false);
      return [];
    }
  }

  void clearSearch() => libraryState.clearSearch();

  void clearHistory() => libraryState.setHistory(const []);

  /// Joue un item DIDL-Lite (UPnP/DLNA) directement dans la zone courante.
  Future<void> playDlnaItem(DIDLItem item, {int? zoneId}) async {
    final url = item.resourceUrl;
    if (url == null) return;
    final id = zoneId ?? zoneState.currentZoneId;
    final instance = engine.zoneManager.zone(id ?? -1);
    if (instance == null) return;

    final track = Track(
      id: 0,
      title: item.title,
      filePath: url,
      source: Source.local.rawValue,
      artistName: item.artist,
      albumTitle: item.album,
      durationMs: item.durationMs,
      coverPath: item.albumArtUrl,
    );

    instance.queue.load([track], startIndex: 0);
    await instance.player.play();
  }

  Future<void> clearLibrary() async {
    await engine.clearLibrary();
    await _refreshLibrarySummary();
  }

  Future<void> cleanupOrphans() async {
    await engine.cleanupOrphans();
    await _refreshLibrarySummary();
  }

  // ---------------------------------------------------------------------------
  // Lecture par lot
  // ---------------------------------------------------------------------------

  /// Charge [tracks] dans la queue (URLs locales résolues) et lance la lecture.
  Future<void> playTracks(
    List<Track> tracks, {
    int startIndex = 0,
    int? zoneId,
  }) async {
    if (tracks.isEmpty) return;
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;

    if (isRemoteMode && _apiClient != null) {
      final track = tracks[startIndex];
      await play(track: track, zoneId: id);
      return;
    }

    final instance = engine.zoneManager.zone(id);
    if (instance == null) return;

    final resolved = tracks.map(_resolveTrackSync).toList();
    instance.queue.load(resolved, startIndex: startIndex);
    await instance.player.play();
  }

  /// Résout l'URL d'un track local de manière synchrone (sans await).
  Track _resolveTrackSync(Track track) {
    if (track.filePath == null) return track;
    if (track.source == 'local' && !track.filePath!.startsWith('http')) {
      final url = engine.trackStreamUrl(track.filePath!);
      if (url != track.filePath) {
        return track.copyWith(filePath: Value(url));
      }
    }
    return track;
  }

  // ---------------------------------------------------------------------------
  // Refresh pistes
  // ---------------------------------------------------------------------------

  Future<void> refreshTracks() async {
    final tracks = await engine.db.trackRepo.all();
    libraryState.setTracks(tracks);
  }

  // ---------------------------------------------------------------------------
  // Playlists
  // ---------------------------------------------------------------------------

  Future<void> createPlaylist(String name) async {
    await engine.db.playlistRepo.insert(
      PlaylistsCompanion.insert(name: name),
    );
    await _refreshPlaylists();
  }

  Future<void> deletePlaylist(int id) async {
    await engine.db.playlistRepo.delete(id);
    await _refreshPlaylists();
  }

  Future<void> addTrackToPlaylist(int trackId, int playlistId) async {
    await engine.db.playlistRepo.addTrack(playlistId, trackId);
    await _refreshPlaylists();
  }

  Future<void> removeTrackFromPlaylist(int trackId, int playlistId) async {
    await engine.db.playlistRepo.removeTrack(playlistId, trackId);
    await _refreshPlaylists();
  }

  // ---------------------------------------------------------------------------
  // Édition métadonnées
  // ---------------------------------------------------------------------------

  Future<void> updateAlbum(Album album) async {
    await engine.db.albumRepo.update(album);
    await _refreshLibrarySummary();
  }

  Future<void> updateTrack(Track track) async {
    await engine.db.trackRepo.update(track);
    if (libraryState.tracks.isNotEmpty) await refreshTracks();
  }

  // ---------------------------------------------------------------------------
  // Streaming auth
  // ---------------------------------------------------------------------------

  Future<StreamingAuthResult> authenticateService(
    String serviceId,
    String email,
    String password,
  ) async {
    final result = await engine.streamingManager
        .authenticateWithCredentials(serviceId, email, password);
    await _refreshStreamingStatus();
    return result;
  }

  Future<StreamingAuthResult> startDeviceCodeFlow(String serviceId) =>
      engine.streamingManager.startDeviceCodeFlow(serviceId);

  Future<StreamingAuthResult> pollDeviceCodeFlow(
    String serviceId,
    StreamingDeviceCodeResult code,
  ) async {
    final result =
        await engine.streamingManager.pollDeviceCodeFlow(serviceId, code);
    await _refreshStreamingStatus();
    return result;
  }

  Future<void> logoutService(String serviceId) async {
    await engine.streamingManager.logout(serviceId);
    await _refreshStreamingStatus();
  }

  // ---------------------------------------------------------------------------
  // Devices / Sources
  // ---------------------------------------------------------------------------

  List<DiscoveredDevice> get discoveredDevices => engine.allDevices();

  /// Lance l'indexation récursive du ContentDirectory d'un serveur UPnP.
  Future<void> indexUPnPServer(DiscoveredDevice device) =>
      engine.indexUPnPDevice(device);

  /// Probe manuel d'un hôte pour découvrir un device UPnP.
  /// Retourne null si aucun device trouvé.
  Future<DiscoveredDevice?> probeDevice(String host, {int port = 49152}) async {
    final device = await engine.probeDevice(host, port: port);
    if (device != null) notifyListeners();
    return device;
  }

  /// Oublie un device (supprime de la DB + du cache mémoire).
  Future<void> forgetDevice(String id) async {
    await engine.forgetDevice(id);
    notifyListeners();
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
