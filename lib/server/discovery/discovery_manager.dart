import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../event_bus.dart';
import '../database/database.dart';
import '../utils/network_utils.dart';
import 'chromecast_discovery.dart';
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
  final String? manufacturer;
  final String? modelName;
  final bool isDsdCapable;

  /// AirPlay version (1 or 2). Null for non-AirPlay devices.
  final int? airplayVersion;

  /// MAC address of the device (from AirPlay TXT records or UPnP).
  final String? macAddress;

  const DiscoveredDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.host,
    required this.port,
    required this.available,
    required this.capabilities,
    this.iconUrl,
    this.manufacturer,
    this.modelName,
    this.isDsdCapable = false,
    this.airplayVersion,
    this.macAddress,
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
        manufacturer: manufacturer,
        modelName: modelName,
        isDsdCapable: isDsdCapable,
        airplayVersion: airplayVersion,
        macAddress: macAddress,
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
  ChromecastDiscovery? _chromecastDiscovery;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> start() async {
    await _loadSavedDevices();
    _ssdpSub = SSDPDiscovery.instance.responses.listen(_onSSDPResponse);
    await SSDPDiscovery.instance.start();
    _chromecastDiscovery = ChromecastDiscovery(client: _http);
    unawaited(_chromecastDiscovery!.start());
    // Fallback: probe direct après un délai (laisse SSDP une chance)
    Future.delayed(const Duration(seconds: 3), () => _subnetProbe());
  }

  void stop() {
    _ssdpSub?.cancel();
    _ssdpSub = null;
    SSDPDiscovery.instance.stop();
    _chromecastDiscovery?.stop();
    _chromecastDiscovery = null;
  }

  Future<void> refresh() async {
    _seen.clear();
    SSDPDiscovery.instance.refresh();
    unawaited(_chromecastDiscovery?.refresh() ?? Future.value());
    // Fallback: probe direct du sous-réseau si SSDP ne trouve rien
    // (iOS bloque souvent le multicast UDP silencieusement)
    unawaited(_subnetProbe());
  }

  /// Scan les ports UPnP courants du sous-réseau local pour trouver des devices.
  Future<void> _subnetProbe() async {
    try {
      final ip = await NetworkUtils.localIpAddress();
      if (ip == null) return;
      final prefix = NetworkUtils.subnetPrefix(ip);
      if (prefix == null) return;

      debugPrint('[discovery] subnet probe: $prefix.0/24');

      // Ports UPnP/DLNA/AirPlay courants + Asset UPnP
      const ports = [1400, 1432, 2870, 7000, 8080, 26125, 42300, 49152, 49153, 60006];

      for (final port in ports) {
        final reachable = await NetworkUtils.scanSubnet(
          prefix,
          port: port,
          timeout: const Duration(milliseconds: 400),
          concurrency: 30,
        );
        for (final host in reachable) {
          if (_cache.values.any((d) => d.host == host && d.port == port)) {
            continue; // déjà connu
          }
          // Tente de parser le description XML UPnP
          final urls = [
            'http://$host:$port/description.xml',
            'http://$host:$port/device.xml',
            'http://$host:$port/DeviceDescription.xml',
            'http://$host:$port/xml/device_description.xml',
          ];
          for (final url in urls) {
            try {
              final resp = await _http
                  .get(Uri.parse(url))
                  .timeout(const Duration(seconds: 3));
              if (resp.statusCode == 200 && resp.body.contains('<device>')) {
                final device = UPnPDeviceParser.parse(resp.body, url);
                if (device != null) {
                  await _registerDevice(device, url);
                  debugPrint('[discovery] probe found: ${device.friendlyName} at $host:$port');
                  break;
                }
              }
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      debugPrint('[discovery] subnet probe error: $e');
    }
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

  List<DiscoveredDevice> get chromecastDevices => _chromecastDiscovery?.devices ?? [];

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
      if (device != null) {
        await _registerDevice(device, location);
        return;
      }

      // XML parsing failed — try SOAP probe fallback for quirky devices
      final uri = Uri.tryParse(location);
      if (uri == null) return;
      await _soapProbeFallback(uri.host, uri.port, location, resp.body);
    } catch (_) {}
  }

  Future<void> _soapProbeFallback(
      String host, int port, String location, String xmlBody) async {
    // Try to extract friendly name from raw XML even if structured parsing failed
    String name = 'Unknown DLNA';
    final nameMatch = RegExp(r'<friendlyName>([^<]+)</friendlyName>').firstMatch(xmlBody);
    if (nameMatch != null) name = nameMatch.group(1)!;

    // Extract UDN if possible
    String udn = '';
    final udnMatch = RegExp(r'<UDN>([^<]+)</UDN>').firstMatch(xmlBody);
    if (udnMatch != null) udn = udnMatch.group(1)!;

    // Try extracting control URLs via regex (bypass strict XML parsing)
    String? avtUrl, rcUrl;
    final serviceBlocks = RegExp(r'<service>(.*?)</service>', dotAll: true);
    for (final m in serviceBlocks.allMatches(xmlBody)) {
      final block = m.group(1) ?? '';
      final ctrlMatch = RegExp(r'<controlURL>([^<]+)</controlURL>').firstMatch(block);
      if (ctrlMatch == null) continue;
      var path = ctrlMatch.group(1)!;
      if (!path.startsWith('/')) path = '/$path';
      final fullUrl = 'http://$host:$port$path';
      if (block.contains('AVTransport')) avtUrl = fullUrl;
      if (block.contains('RenderingControl')) rcUrl = fullUrl;
    }

    // If regex didn't find AVTransport, blind-probe common paths
    if (avtUrl == null) {
      const paths = [
        '/AVTransport/control',
        '/MediaRenderer/AVTransport/Control',
        '/upnp/control/AVTransport',
        '/ctl/AVTransport',
        '/upnp/control/rendertransport1',
        '/dev/AVTransport/ctrl',
      ];
      for (final path in paths) {
        if (await _testSoapEndpoint('http://$host:$port$path')) {
          avtUrl = 'http://$host:$port$path';
          break;
        }
      }
    }

    if (avtUrl == null) return;

    final id = udn.isNotEmpty ? udn : '${host}_$port';
    final caps = UPnPCapabilities(
      avTransportControlUrl: avtUrl,
      renderingControlUrl: rcUrl,
    );
    final discovered = DiscoveredDevice(
      id: id,
      name: name,
      type: 'renderer',
      host: host,
      port: port,
      available: true,
      capabilities: caps,
    );
    _cache[id] = discovered;
    await _persistDevice(discovered);
    EventBus.instance.emit(DeviceDiscoveredEvent(discovered));
    debugPrint('[discovery] SOAP probe fallback: $name at $host:$port');
  }

  Future<bool> _testSoapEndpoint(String url) async {
    const body = '<?xml version="1.0" encoding="utf-8"?>'
        '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" '
        's:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
        '<s:Body><u:GetTransportInfo '
        'xmlns:u="urn:schemas-upnp-org:service:AVTransport:1">'
        '<InstanceID>0</InstanceID>'
        '</u:GetTransportInfo></s:Body></s:Envelope>';
    try {
      final resp = await _http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'text/xml; charset="utf-8"',
          'SOAPAction': '"urn:schemas-upnp-org:service:AVTransport:1#GetTransportInfo"',
        },
        body: body,
      ).timeout(const Duration(seconds: 5));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
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

    final dsdCapable = detectDsdFromDeviceInfo(
      parsed.friendlyName,
      parsed.modelName,
      parsed.manufacturer,
    );

    final discovered = DiscoveredDevice(
      id: parsed.id,
      name: parsed.friendlyName,
      type: type,
      host: host,
      port: port,
      available: true,
      capabilities: parsed.capabilities,
      iconUrl: parsed.iconUrl,
      manufacturer: parsed.manufacturer,
      modelName: parsed.modelName,
      isDsdCapable: dsdCapable,
    );

    final existing = _cache[parsed.id];
    final wasOffline = existing != null && !existing.available;
    _cache[parsed.id] = discovered;

    await _persistDevice(discovered);

    // Émet un événement si le device est nouveau OU s'il repasse en ligne
    if (existing == null || wasOffline) {
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

      final manufacturer = caps?['manufacturer'] as String?;
      final modelName = caps?['modelName'] as String?;
      final dsdCapable = detectDsdFromDeviceInfo(
        row.name,
        modelName,
        manufacturer,
      );

      _cache[row.deviceId] = DiscoveredDevice(
        id: row.deviceId,
        name: row.name,
        type: row.type,
        host: row.host,
        port: row.port,
        available: false, // sera confirmé par SSDP
        capabilities: capabilities,
        manufacturer: manufacturer,
        modelName: modelName,
        isDsdCapable: dsdCapable,
      );
    }
  }

  Future<void> _persistDevice(DiscoveredDevice d) async {
    final capsJson = <String, dynamic>{
      ...d.capabilities.toJson(),
      if (d.manufacturer != null) 'manufacturer': d.manufacturer,
      if (d.modelName != null) 'modelName': d.modelName,
    };
    await _db.into(_db.savedDevices).insertOnConflictUpdate(
          SavedDevicesCompanion.insert(
            deviceId: d.id,
            name: d.name,
            type: d.type,
            host: d.host,
            port: d.port,
            capabilitiesJson:
                Value(jsonEncode(capsJson)),
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
