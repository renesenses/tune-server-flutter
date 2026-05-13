import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../event_bus.dart';
import '../utils/network_utils.dart';
import 'discovery_manager.dart';
import 'upnp_device_parser.dart';

// ---------------------------------------------------------------------------
// BluOSDiscovery
// Discovers BluOS (Bluesound) devices on the local network by probing
// port 11000 across the subnet and querying /SyncStatus for device info.
//
// BluOS devices expose an HTTP API at port 11000. We do not use mDNS here
// to avoid adding a dependency; instead we use subnet scanning (same
// pattern as DiscoveryManager._subnetProbe).
// ---------------------------------------------------------------------------

class BluOSDiscovery {
  final http.Client _http;
  final Map<String, DiscoveredDevice> _devices = {};
  Timer? _refreshTimer;

  BluOSDiscovery({http.Client? client}) : _http = client ?? http.Client();

  List<DiscoveredDevice> get devices => List.unmodifiable(_devices.values);

  DiscoveredDevice? deviceById(String id) => _devices[id];

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> start() async {
    await _scan();
    // Re-scan every 60 seconds for new/lost devices
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _scan(),
    );
  }

  void stop() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _devices.clear();
  }

  Future<void> refresh() async {
    await _scan();
  }

  // ---------------------------------------------------------------------------
  // Scanning
  // ---------------------------------------------------------------------------

  Future<void> _scan() async {
    try {
      final ip = await NetworkUtils.localIpAddress();
      if (ip == null) return;
      final prefix = NetworkUtils.subnetPrefix(ip);
      if (prefix == null) return;

      debugPrint('[bluos_discovery] scanning $prefix.0/24 on port 11000');

      final reachable = await NetworkUtils.scanSubnet(
        prefix,
        port: 11000,
        timeout: const Duration(milliseconds: 500),
        concurrency: 30,
      );

      final foundIds = <String>{};

      for (final host in reachable) {
        final device = await _probeDevice(host);
        if (device != null) {
          foundIds.add(device.id);
          final isNew = !_devices.containsKey(device.id);
          _devices[device.id] = device;
          if (isNew) {
            EventBus.instance.emit(DeviceDiscoveredEvent(device));
            debugPrint('[bluos_discovery] found: ${device.name} at $host');
          }
        }
      }

      // Mark lost devices
      final lostIds = _devices.keys
          .where((id) => !foundIds.contains(id))
          .toList();
      for (final id in lostIds) {
        _devices.remove(id);
        EventBus.instance.emit(DeviceLostEvent(id));
        debugPrint('[bluos_discovery] lost: $id');
      }
    } catch (e) {
      debugPrint('[bluos_discovery] scan error: $e');
    }
  }

  /// Probe a single host on port 11000 for BluOS /SyncStatus.
  Future<DiscoveredDevice?> _probeDevice(String host) async {
    try {
      final uri = Uri.parse('http://$host:11000/SyncStatus');
      final response = await _http
          .get(uri)
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) return null;

      // Parse device name from SyncStatus XML
      String friendlyName = 'BluOS ($host)';
      try {
        final doc = XmlDocument.parse(response.body);
        final nameEl = doc.descendants
            .whereType<XmlElement>()
            .where((e) => e.localName == 'name')
            .firstOrNull;
        if (nameEl != null && nameEl.innerText.trim().isNotEmpty) {
          friendlyName = nameEl.innerText.trim();
        }
      } catch (_) {}

      final deviceId = 'bluos-${host.replaceAll('.', '-')}';

      return DiscoveredDevice(
        id: deviceId,
        name: friendlyName,
        type: 'bluos',
        host: host,
        port: 11000,
        available: true,
        capabilities: const UPnPCapabilities(),
      );
    } catch (_) {
      return null;
    }
  }
}
