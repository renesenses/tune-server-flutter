part of 'app_state.dart';

// Extension AppState — zones + multi-room :
// - Zones (CRUD via zoneManager + setOutput)
// - Multi-room grouping (group/ungroup, syncDelay)
// - selectZone avec migration de la lecture en cours

extension AppStateZones on AppState {

  // ---------------------------------------------------------------------------
  // Zones
  // ---------------------------------------------------------------------------

  Future<void> createZone(String name, {String? outputType, String? outputDeviceId}) async {
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.createZoneRemote(name, outputType: outputType, outputDeviceId: outputDeviceId);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.createZone(name);
    await _refreshZones();
  }

  /// Creates a zone directly from a discovered device.
  /// The zone inherits the device's name and output type.
  Future<int> createZoneFromDevice(DiscoveredDevice device) async {
    final outputType = switch (device.type) {
      'bluos' => OutputType.bluos,
      'renderer' => OutputType.dlna,
      'openhome' => OutputType.openhome,
      'squeezebox' => OutputType.squeezebox,
      'oaat' => OutputType.oaat,
      'chromecast' => OutputType.chromecast,
      _ => OutputType.local,
    };
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
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.deleteZoneRemote(zoneId);
      await refreshZonesRemote();
      return;
    }
    await engine.zoneManager.deleteZone(zoneId);
    await _refreshZones();
  }

  Future<void> renameZone(int zoneId, String newName) async {
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.renameZoneRemote(zoneId, newName);
      await refreshZonesRemote();
      return;
    }
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
      zoneState.stopSeekTimer();
      zoneState.setCurrentZoneId(newZoneId);
      try {
        await refreshZonesRemote();
      } catch (e) {
        debugPrint('selectZone refreshZonesRemote error: $e');
      }
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
}
