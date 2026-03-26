import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../models/enums.dart';
import '../database/database.dart';
import '../discovery/discovery_manager.dart';
import '../event_bus.dart';
import '../outputs/output_factory.dart';
import 'zone_instance.dart';

// ---------------------------------------------------------------------------
// T5.4 — ZoneManager
// Bootstrap depuis DB, cycle de vie des ZoneInstances, volume persisté.
// Miroir de ZoneManager.swift (iOS)
// ---------------------------------------------------------------------------

class ZoneManager {
  final TuneDatabase _db;
  final DiscoveryManager _discovery;

  final Map<int, ZoneInstance> _instances = {};

  ZoneManager(this._db, this._discovery);

  // ---------------------------------------------------------------------------
  // Bootstrap
  // ---------------------------------------------------------------------------

  /// Charge toutes les zones depuis la DB et crée une ZoneInstance par zone.
  /// Appelé au démarrage par ServerEngine (Phase 9).
  Future<void> bootstrap() async {
    final zones = await _db.zoneRepo.all();

    if (zones.isEmpty) {
      // Aucune zone → crée la zone locale par défaut
      await createZone('Zone principale', outputType: OutputType.local);
      return;
    }

    for (final zone in zones) {
      await _instantiate(zone);
    }
  }

  // ---------------------------------------------------------------------------
  // Accès
  // ---------------------------------------------------------------------------

  ZoneInstance? zone(int id) => _instances[id];

  List<ZoneInstance> allZones() => List.unmodifiable(_instances.values);

  ZoneInstance? get defaultZone =>
      _instances.values.isNotEmpty ? _instances.values.first : null;

  // ---------------------------------------------------------------------------
  // CRUD zones
  // ---------------------------------------------------------------------------

  /// Crée une nouvelle zone, la persiste en DB et démarre son instance.
  Future<ZoneInstance> createZone(
    String name, {
    OutputType outputType = OutputType.local,
    DiscoveredDevice? device,
    double volume = 0.5,
  }) async {
    final id = await _db.zoneRepo.insert(
      ZonesCompanion.insert(
        name: name,
        outputType: Value(outputType.rawValue),
        outputDeviceId: Value(device?.id),
        volume: Value(volume),
      ),
    );

    final zone = await _db.zoneRepo.byId(id);
    if (zone == null) throw StateError('Zone $id introuvable après insertion');

    final instance = await _instantiate(zone, device: device);
    EventBus.instance.emit(ZoneCreatedEvent(id, name));
    return instance;
  }

  /// Supprime une zone de la DB et dispose son instance.
  /// Refuse de supprimer la dernière zone.
  Future<void> deleteZone(int id) async {
    if (_instances.length <= 1) {
      debugPrint('[zone_manager] cannot delete last zone');
      return;
    }
    final instance = _instances.remove(id);
    await instance?.dispose();
    await _db.zoneRepo.delete(id);
    EventBus.instance.emit(ZoneDeletedEvent(id));
  }

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  /// Règle le volume d'une zone : persist en DB + mémoire + output.
  Future<void> setVolume(int zoneId, double volume) async {
    await _db.zoneRepo.setVolume(zoneId, volume);
    final instance = _instances[zoneId];
    if (instance != null) {
      instance.zone = instance.zone.copyWith(volume: volume);
      await instance.player.setVolume(volume);
    }
  }

  // ---------------------------------------------------------------------------
  // Output
  // ---------------------------------------------------------------------------

  /// Change l'output d'une zone (ex: DLNA → Local).
  Future<void> setOutput(
    int zoneId, {
    required OutputType type,
    DiscoveredDevice? device,
  }) async {
    final instance = _instances[zoneId];
    if (instance == null) return;

    final output = OutputFactory.create(type: type, device: device);
    await instance.setOutput(output);

    await _db.zoneRepo.setOutput(zoneId, type.rawValue, device?.id);

    // Met à jour le modèle en mémoire pour que snapshot() reflète le changement
    // immédiatement, sans attendre un prochain chargement depuis la DB.
    instance.zone = instance.zone.copyWith(
      outputType: Value(type.rawValue),
      outputDeviceId: Value(device?.id),
    );
    EventBus.instance.emit(ZoneUpdatedEvent(zoneId));
  }

  /// Renomme une zone (DB + mémoire + événement).
  Future<void> renameZone(int zoneId, String newName) async {
    await _db.zoneRepo.rename(zoneId, newName);
    final instance = _instances[zoneId];
    if (instance != null) {
      instance.zone = instance.zone.copyWith(name: newName);
    }
    EventBus.instance.emit(ZoneUpdatedEvent(zoneId));
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  Future<void> dispose() async {
    for (final instance in _instances.values) {
      await instance.dispose();
    }
    _instances.clear();
  }

  // ---------------------------------------------------------------------------
  // Helpers internes
  // ---------------------------------------------------------------------------

  Future<ZoneInstance> _instantiate(Zone zone,
      {DiscoveredDevice? device}) async {
    final instance = ZoneInstance(zone: zone);

    // Reconstruit le device depuis le cache discovery si non fourni
    final targetDevice = device ??
        (zone.outputDeviceId != null
            ? _discovery.deviceById(zone.outputDeviceId!)
            : null);

    final outputType = zone.outputType != null
        ? OutputType.fromRawValue(zone.outputType!) ?? OutputType.local
        : OutputType.local;

    final output = OutputFactory.create(
      type: outputType,
      device: targetDevice,
    );

    await instance.setOutput(output);

    // Synchronise le volume de la zone avec celui lu du renderer DLNA
    final rendererVolume = output.currentVolume;
    if (rendererVolume != null && (rendererVolume - zone.volume).abs() > 0.01) {
      instance.zone = instance.zone.copyWith(volume: rendererVolume);
      await _db.zoneRepo.setVolume(zone.id, rendererVolume);
    }

    _instances[zone.id] = instance;

    EventBus.instance.emit(DeviceDiscoveredEvent(instance.snapshot()));
    return instance;
  }
}
