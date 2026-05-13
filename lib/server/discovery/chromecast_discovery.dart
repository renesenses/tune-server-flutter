import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../event_bus.dart';
import '../utils/network_utils.dart';
import 'discovery_manager.dart';
import 'upnp_device_parser.dart';

// ---------------------------------------------------------------------------
// ChromecastDiscovery
// Discovers Google Cast / Chromecast devices on the local network.
//
// Cast devices expose a device info endpoint at port 8008 (HTTP) and
// communicate via Cast V2 on port 8009 (TLS). We probe port 8008 and
// query GET /setup/eureka_info to identify Cast devices and retrieve
// their friendly name.
//
// This uses subnet scanning (same pattern as BluOSDiscovery) to avoid
// adding an mDNS dependency. In production, Cast devices are also
// discoverable via mDNS as _googlecast._tcp.
// ---------------------------------------------------------------------------

class ChromecastDiscovery {
  final http.Client _http;
  final Map<String, DiscoveredDevice> _devices = {};
  Timer? _refreshTimer;

  ChromecastDiscovery({http.Client? client})
      : _http = client ?? http.Client();

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

      debugPrint('[chromecast_discovery] scanning $prefix.0/24 on port 8008');

      final reachable = await NetworkUtils.scanSubnet(
        prefix,
        port: 8008,
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
            debugPrint(
                '[chromecast_discovery] found: ${device.name} at $host');
          }
        }
      }

      // Mark lost devices
      final lostIds =
          _devices.keys.where((id) => !foundIds.contains(id)).toList();
      for (final id in lostIds) {
        _devices.remove(id);
        EventBus.instance.emit(DeviceLostEvent(id));
        debugPrint('[chromecast_discovery] lost: $id');
      }
    } catch (e) {
      debugPrint('[chromecast_discovery] scan error: $e');
    }
  }

  /// Probe a single host on port 8008 for Chromecast /setup/eureka_info.
  Future<DiscoveredDevice?> _probeDevice(String host) async {
    try {
      // Cast devices expose device info at this endpoint
      final uri = Uri.parse(
          'http://$host:8008/setup/eureka_info?params=name,build_info,detail,device_info,opt_in');
      final response = await _http.get(uri, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) return null;

      // Verify this is actually a Cast device by checking for expected fields
      final body = response.body;
      if (!body.contains('"name"') || !body.contains('"build_info"')) {
        return null;
      }

      // Parse the JSON response to get the device name
      String friendlyName = 'Chromecast ($host)';
      try {
        // Simple JSON name extraction without adding a json dependency
        // (we already import dart:convert via the output)
        final nameMatch =
            RegExp(r'"name"\s*:\s*"([^"]+)"').firstMatch(body);
        if (nameMatch != null && nameMatch.group(1)!.isNotEmpty) {
          friendlyName = nameMatch.group(1)!;
        }
      } catch (_) {}

      final deviceId = 'chromecast-${host.replaceAll('.', '-')}';

      return DiscoveredDevice(
        id: deviceId,
        name: friendlyName,
        type: 'chromecast',
        host: host,
        port: 8009, // Cast V2 control port
        available: true,
        capabilities: const UPnPCapabilities(), // No UPnP capabilities
      );
    } catch (_) {
      return null;
    }
  }
}
