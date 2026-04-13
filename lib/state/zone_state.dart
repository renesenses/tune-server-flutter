import 'package:flutter/foundation.dart';

import '../models/domain_models.dart';
import '../models/enums.dart';
import '../server/database/database.dart';
import '../server/discovery/discovery_manager.dart';

// ---------------------------------------------------------------------------
// T9.2 — ZoneState
// ChangeNotifier pour les zones, la lecture en cours et les devices découverts.
// Consommé via Provider dans l'UI.
// Miroir de ZoneState.swift (iOS / @Observable)
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// ZoneGroup — modèle léger pour un groupe multi-room
// ---------------------------------------------------------------------------

class ZoneGroup {
  final String groupId;
  final int leaderId;
  final List<int> zoneIds;

  const ZoneGroup({
    required this.groupId,
    required this.leaderId,
    required this.zoneIds,
  });
}

class ZoneState extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // Zones
  // ---------------------------------------------------------------------------

  List<ZoneWithState> _zones = [];
  int? _currentZoneId;

  List<ZoneWithState> get zones => List.unmodifiable(_zones);

  int? get currentZoneId => _currentZoneId;

  ZoneWithState? get currentZone {
    if (_currentZoneId == null) return null;
    try {
      return _zones.firstWhere((z) => z.id == _currentZoneId);
    } catch (_) {
      return _zones.isNotEmpty ? _zones.first : null;
    }
  }

  void reset() {
    _zones = [];
    _currentZoneId = null;
    _queueSnapshot = null;
    notifyListeners();
  }

  void setZones(List<ZoneWithState> zones) {
    _zones = zones;
    if (_currentZoneId == null && zones.isNotEmpty) {
      _currentZoneId = zones.first.id;
    }
    notifyListeners();
  }

  void updateZone(ZoneWithState updated) {
    final idx = _zones.indexWhere((z) => z.id == updated.id);
    if (idx >= 0) {
      _zones = List.of(_zones)..[idx] = updated;
      notifyListeners();
    }
  }

  void setCurrentZoneId(int id) {
    if (_currentZoneId == id) return;
    _currentZoneId = id;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Playback (zone courante)
  // ---------------------------------------------------------------------------

  PlaybackState get playbackState =>
      currentZone?.state ?? PlaybackState.stopped;

  Track? get currentTrack => currentZone?.currentTrack as Track?;

  int get positionMs => currentZone?.positionMs ?? 0;

  Duration get position => Duration(milliseconds: positionMs);

  int get queueLength => currentZone?.queueLength ?? 0;

  bool get isPlaying => playbackState == PlaybackState.playing;

  bool get isBuffering => playbackState == PlaybackState.buffering;

  // ---------------------------------------------------------------------------
  // Queue snapshot
  // ---------------------------------------------------------------------------

  QueueSnapshot? _queueSnapshot;

  QueueSnapshot? get queueSnapshot => _queueSnapshot;

  void setQueueSnapshot(QueueSnapshot snapshot) {
    _queueSnapshot = snapshot;
    notifyListeners();
  }

  List<dynamic> get queueTracks => _queueSnapshot?.tracks ?? [];

  bool get shuffleEnabled => _queueSnapshot?.shuffleEnabled ?? false;

  RepeatMode get repeatMode => _queueSnapshot?.repeatMode ?? RepeatMode.off;

  // ---------------------------------------------------------------------------
  // Devices découverts
  // ---------------------------------------------------------------------------

  List<DiscoveredDevice> _devices = [];

  List<DiscoveredDevice> get devices => List.unmodifiable(_devices);

  List<DiscoveredDevice> get renderers =>
      _devices.where((d) => d.type == 'renderer').toList();

  List<DiscoveredDevice> get servers =>
      _devices.where((d) => d.type == 'server').toList();

  /// Renderers non encore assignés à une zone.
  List<DiscoveredDevice> get unboundRenderers {
    final boundIds = _zones
        .where((z) => z.outputDeviceId != null)
        .map((z) => z.outputDeviceId!)
        .toSet();
    return renderers.where((d) => !boundIds.contains(d.id)).toList();
  }

  void setDevices(List<DiscoveredDevice> devices) {
    _devices = devices;
    notifyListeners();
  }

  void addOrUpdateDevice(DiscoveredDevice device) {
    final idx = _devices.indexWhere((d) => d.id == device.id);
    if (idx >= 0) {
      _devices = List.of(_devices)..[idx] = device;
    } else {
      _devices = [..._devices, device];
    }
    notifyListeners();
  }

  void removeDevice(String deviceId) {
    _devices = _devices.where((d) => d.id != deviceId).toList();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Multi-room groups
  // ---------------------------------------------------------------------------

  /// Groupes actifs calculés à partir des zones courantes.
  /// Le leader est la première zone du groupe (plus petit ID dans le groupe).
  List<ZoneGroup> get groups {
    final Map<String, List<int>> map = {};
    for (final zone in _zones) {
      final gid = zone.groupId;
      if (gid != null && gid.isNotEmpty) {
        map.putIfAbsent(gid, () => []).add(zone.id);
      }
    }
    return map.entries.map((e) {
      final ids = e.value..sort();
      return ZoneGroup(
        groupId: e.key,
        leaderId: ids.first,
        zoneIds: ids,
      );
    }).toList();
  }

  /// Retourne le groupe auquel appartient une zone, ou null.
  ZoneGroup? groupForZone(int zoneId) {
    final zone = _zones.cast<ZoneWithState?>().firstWhere(
      (z) => z!.id == zoneId,
      orElse: () => null,
    );
    if (zone == null || zone.groupId == null || zone.groupId!.isEmpty) {
      return null;
    }
    return groups.cast<ZoneGroup?>().firstWhere(
      (g) => g!.groupId == zone.groupId,
      orElse: () => null,
    );
  }

  // ---------------------------------------------------------------------------
  // Position (mise à jour fréquente — évite notifyListeners inutiles)
  // ---------------------------------------------------------------------------

  void updatePosition(int zoneId, int positionMs) {
    final idx = _zones.indexWhere((z) => z.id == zoneId);
    if (idx < 0) return;
    _zones = List.of(_zones)
      ..[idx] = _zones[idx].copyWith(positionMs: positionMs);
    // Notification uniquement pour la zone courante (évite rebuild inutile)
    if (zoneId == _currentZoneId) notifyListeners();
  }
}
