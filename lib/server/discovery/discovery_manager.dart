import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../event_bus.dart';
import '../database/database.dart';
import 'ssdp_discovery.dart';
import 'upnp_device_parser.dart';

// ---------------------------------------------------------------------------
// T3.4 — DiscoveryManager
// Orchestre SSDPDiscovery + UPnPDeviceParser + cache devices.
// Miroir de DiscoveryManager.swift (iOS)
//
// - Démarre SSDP, parse les LOCATION reçues, déduplique par UDN
// - Persiste les devices connus dans saved_devices (DB)
// - Émet DeviceDiscoveredEvent / DeviceLostEvent sur l'EventBus
// ---------------------------------------------------------------------------

/// Device découvert et parsé — vue unifiée pour l'UI et les outputs.
class DiscoveredDevice {
  final String id;          // UDN du device
  final String name;        // friendlyName
  final String type;        // 'renderer' | 'server' | 'unknown'
  final String host;        // IP ou hostname
  final int port;
  final bool available;
  final UPnPCapabilities capabilities;
  final String? iconUrl;

  const DiscoveredDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.host,
    required this.port,
    required this.available,
    required this.capabilities,
    this.iconUrl,
  });

  DiscoveredDevice copyWith({bool? available}) => DiscoveredDevice(
        id: id,
        name: name,
        type: type,
        host: host,
        port: port,
        available: available ?? this.available,
        capabilities: capabilities,
        iconUrl: iconUrl,
      );
}

class DiscoveryManager {
  final TuneDatabase _db;
  final http.Client _http;

  DiscoveryManager(this._db, {http.Client? client})
      : _http = client ?? http.Client();

  final _cache = <String, DiscoveredDevice>{}; // keyed by UDN
  final _seen = <String>{};                     // LOCATION URLs déjà traitées
  StreamSubscription<SSDPResponse>? _ssdpSub;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> start() async {
    await _loadSavedDevices();
    _ssdpSub = SSDPDiscovery.instance.responses.listen(_onSSDPResponse);
    await SSDPDiscovery.instance.start();
  }

  void stop() {
    _ssdpSub?.cancel();
    _ssdpSub = null;
    SSDPDiscovery.instance.stop();
  }

  Future<void> refresh() async {
    _seen.clear();
    SSDPDiscovery.instance.refresh();
  }

  // ---------------------------------------------------------------------------
  // Accès aux devices
  // ---------------------------------------------------------------------------

  List<DiscoveredDevice> allDevices() => List.unmodifiable(_cache.values);

  List<DiscoveredDevice> renderers() =>
      _cache.values.where((d) => d.type == 'renderer').toList();

  List<DiscoveredDevice> servers() =>
      _cache.values.where((d) => d.type == 'server').toList();

  DiscoveredDevice? deviceById(String id) => _cache[id];

  /// Probe manuel d'un hôte (port 49152 par défaut UPnP).
  Future<DiscoveredDevice?> probeHost(String host,
      {int port = 49152}) async {
    // Tente de récupérer un device description XML directement
    final urls = [
      'http://$host:$port/description.xml',
      'http://$host:$port/device.xml',
      'http://$host:$port/DeviceDescription.xml',
    ];
    for (final url in urls) {
      try {
        final resp =
            await _http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
        if (resp.statusCode == 200) {
          final device = UPnPDeviceParser.parse(resp.body, url);
          if (device != null) {
            return _registerDevice(device, url);
          }
        }
      } catch (_) {}
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Réception SSDP
  // ---------------------------------------------------------------------------

  Future<void> _onSSDPResponse(SSDPResponse response) async {
    final location = response.location;
    if (_seen.contains(location)) return;
    _seen.add(location);

    try {
      final resp = await _http
          .get(Uri.parse(location))
          .timeout(const Duration(seconds: 5));

      if (resp.statusCode != 200) return;

      final device = UPnPDeviceParser.parse(resp.body, location);
      if (device == null) return;

      await _registerDevice(device, location);
    } catch (_) {}
  }

  Future<DiscoveredDevice> _registerDevice(
      UPnPDevice parsed, String location) async {
    final uri = Uri.tryParse(location);
    final host = uri?.host ?? '';
    final port = uri?.port ?? 80;

    final type = parsed.capabilities.isRenderer
        ? 'renderer'
        : parsed.capabilities.isServer
            ? 'server'
            : 'unknown';

    final discovered = DiscoveredDevice(
      id: parsed.id,
      name: parsed.friendlyName,
      type: type,
      host: host,
      port: port,
      available: true,
      capabilities: parsed.capabilities,
      iconUrl: parsed.iconUrl,
    );

    final isNew = !_cache.containsKey(parsed.id);
    _cache[parsed.id] = discovered;

    await _persistDevice(discovered);

    if (isNew) {
      EventBus.instance.emit(DeviceDiscoveredEvent(discovered));
    }

    return discovered;
  }

  // ---------------------------------------------------------------------------
  // Persistance (saved_devices)
  // ---------------------------------------------------------------------------

  Future<void> _loadSavedDevices() async {
    final rows = await _db.select(_db.savedDevices).get();
    for (final row in rows) {
      Map<String, dynamic>? caps;
      try {
        if (row.capabilitiesJson != null) {
          caps = jsonDecode(row.capabilitiesJson!) as Map<String, dynamic>;
        }
      } catch (_) {}

      final capabilities = caps != null
          ? UPnPCapabilities.fromJson(caps)
          : const UPnPCapabilities();

      _cache[row.deviceId] = DiscoveredDevice(
        id: row.deviceId,
        name: row.name,
        type: row.type,
        host: row.host,
        port: row.port,
        available: false, // sera confirmé par SSDP
        capabilities: capabilities,
      );
    }
  }

  Future<void> _persistDevice(DiscoveredDevice d) async {
    await _db.into(_db.savedDevices).insertOnConflictUpdate(
          SavedDevicesCompanion.insert(
            deviceId: d.id,
            name: d.name,
            type: d.type,
            host: d.host,
            port: d.port,
            capabilitiesJson:
                Value(jsonEncode(d.capabilities.toJson())),
            addedAt: DateTime.now().toIso8601String(),
          ),
        );
  }

  Future<void> forgetDevice(String id) async {
    _cache.remove(id);
    await (_db.delete(_db.savedDevices)
          ..where((s) => s.deviceId.equals(id)))
        .go();
    EventBus.instance.emit(DeviceLostEvent(id));
  }
}
