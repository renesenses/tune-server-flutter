import 'dart:async';
import 'dart:io';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../event_bus.dart';
import '../utils/network_utils.dart';

// ---------------------------------------------------------------------------
// TuneDiscovery — DNS-SD peer discovery via mDNS (Bonsoir).
//
// Advertises this Tune instance as `_tune-server._tcp` and discovers other
// Tune servers on the LAN so they can browse each other's libraries and
// transfer playback.
//
// Port miroir de tune_server/discovery/tune_discovery.py (Python).
// ---------------------------------------------------------------------------

const _tuneServiceType = '_tune-server._tcp';
const _defaultPort = 8888;

/// A discovered Tune Server on the network.
class TunePeer {
  final String name;
  final String host;
  final int port;
  final String version;
  final int tracks;
  final int zones;
  final String serverId;

  const TunePeer({
    required this.name,
    required this.host,
    required this.port,
    this.version = '',
    this.tracks = 0,
    this.zones = 0,
    this.serverId = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'host': host,
        'port': port,
        'version': version,
        'tracks': tracks,
        'zones': zones,
        'server_id': serverId,
      };

  @override
  String toString() => 'TunePeer($name @ $host:$port v$version)';
}

class TuneDiscovery {
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;

  final _peers = <String, TunePeer>{}; // keyed by "host:port"
  String _localIp = '';
  int _localPort = _defaultPort;

  /// Currently discovered Tune peers (excluding self).
  Map<String, TunePeer> get peers => Map.unmodifiable(_peers);

  /// Start advertising this server and browsing for peers.
  ///
  /// [port] is the Tune API port this instance listens on.
  /// [trackCount] / [zoneCount] are initial TXT record values.
  Future<void> start({
    int port = _defaultPort,
    int trackCount = 0,
    int zoneCount = 0,
  }) async {
    _localPort = port;

    // Determine local IP for self-exclusion
    _localIp = await NetworkUtils.localIpAddress() ?? '';

    // Build TXT attributes
    String version;
    try {
      final info = await PackageInfo.fromPlatform();
      version = info.version;
    } catch (_) {
      version = '0.0.0';
    }

    final friendlyName = Platform.localHostname;

    final attributes = <String, String>{
      'version': version,
      'name': friendlyName,
      'zones': '$zoneCount',
      'tracks': '$trackCount',
      'server_id': Platform.localHostname,
    };

    // --- Register (advertise) this server ---
    final service = BonsoirService(
      name: friendlyName,
      type: _tuneServiceType,
      port: _localPort,
      attributes: attributes,
    );

    try {
      _broadcast = BonsoirBroadcast(service: service);
      await _broadcast!.ready;
      await _broadcast!.start();
      debugPrint('[TuneDiscovery] Registered: $friendlyName on $_localIp:$_localPort');
    } catch (e) {
      debugPrint('[TuneDiscovery] Broadcast start failed: $e');
      _broadcast = null;
    }

    // --- Browse for other Tune servers ---
    try {
      _discovery = BonsoirDiscovery(type: _tuneServiceType);
      await _discovery!.ready;
      _discovery!.eventStream?.listen(_onDiscoveryEvent);
      await _discovery!.start();
      debugPrint('[TuneDiscovery] Browsing for peers...');
    } catch (e) {
      debugPrint('[TuneDiscovery] Discovery start failed: $e');
      _discovery = null;
    }
  }

  /// Handle discovery events from Bonsoir.
  void _onDiscoveryEvent(BonsoirDiscoveryEvent event) {
    switch (event.type) {
      case BonsoirDiscoveryEventType.discoveryServiceFound:
        // Service found but not yet resolved — resolve it
        if (event.service != null && _discovery != null) {
          event.service!.resolve(_discovery!.serviceResolver);
        }
        break;

      case BonsoirDiscoveryEventType.discoveryServiceResolved:
        _onServiceResolved(event.service);
        break;

      case BonsoirDiscoveryEventType.discoveryServiceLost:
        _onServiceLost(event.service);
        break;

      default:
        break;
    }
  }

  void _onServiceResolved(BonsoirService? service) {
    if (service == null) return;

    // Bonsoir resolves to a ResolvedBonsoirService with host info
    final resolved = service as ResolvedBonsoirService;
    final host = resolved.host ?? '';
    final port = resolved.port;

    if (host.isEmpty) return;

    // Self-exclusion: skip if this is our own service
    if (_isSelf(host, port)) return;

    final attrs = resolved.attributes;
    final peerName = attrs['name'] ?? resolved.name;
    final serverId = attrs['server_id'] ?? peerName;
    final peerId = '$host:$port';

    final peer = TunePeer(
      name: peerName,
      host: host,
      port: port,
      version: attrs['version'] ?? '',
      tracks: int.tryParse(attrs['tracks'] ?? '') ?? 0,
      zones: int.tryParse(attrs['zones'] ?? '') ?? 0,
      serverId: serverId,
    );

    final isNew = !_peers.containsKey(peerId);
    _peers[peerId] = peer;

    EventBus.instance.emit(PeerDiscoveredEvent(
      name: peer.name,
      host: peer.host,
      port: peer.port,
      version: peer.version,
      trackCount: peer.tracks,
      zoneCount: peer.zones,
      serverId: peer.serverId,
    ));

    debugPrint(
      '[TuneDiscovery] Peer ${isNew ? "discovered" : "updated"}: '
      '${peer.name} @ $host:$port v${peer.version} '
      '(${peer.tracks} tracks, ${peer.zones} zones)',
    );
  }

  void _onServiceLost(BonsoirService? service) {
    if (service == null) return;

    // Find peer by matching the service name
    String? removedId;
    TunePeer? removedPeer;

    for (final entry in _peers.entries) {
      if (service.name == entry.value.name ||
          service.name.startsWith(entry.value.name)) {
        removedId = entry.key;
        removedPeer = entry.value;
        break;
      }
    }

    if (removedId != null && removedPeer != null) {
      _peers.remove(removedId);
      EventBus.instance.emit(PeerLostEvent(
        name: removedPeer.name,
        host: removedPeer.host,
      ));
      debugPrint('[TuneDiscovery] Peer lost: ${removedPeer.name} @ ${removedPeer.host}');
    }
  }

  /// Check if a discovered host:port is this server itself.
  bool _isSelf(String host, int port) {
    if (port != _localPort) return false;
    if (host == _localIp) return true;
    if (host == '127.0.0.1' || host == 'localhost') return true;
    return false;
  }

  /// Update the advertised TXT record properties (e.g. after a library scan).
  Future<void> updateProperties({int? trackCount, int? zoneCount}) async {
    if (_broadcast == null) return;

    // Bonsoir does not support updating TXT records in-place.
    // Re-broadcast with updated attributes.
    try {
      await _broadcast!.stop();

      String version;
      try {
        final info = await PackageInfo.fromPlatform();
        version = info.version;
      } catch (_) {
        version = '0.0.0';
      }

      final friendlyName = Platform.localHostname;
      final attributes = <String, String>{
        'version': version,
        'name': friendlyName,
        'zones': '${zoneCount ?? 0}',
        'tracks': '${trackCount ?? 0}',
        'server_id': Platform.localHostname,
      };

      final service = BonsoirService(
        name: friendlyName,
        type: _tuneServiceType,
        port: _localPort,
        attributes: attributes,
      );

      _broadcast = BonsoirBroadcast(service: service);
      await _broadcast!.ready;
      await _broadcast!.start();
      debugPrint('[TuneDiscovery] TXT updated: tracks=$trackCount zones=$zoneCount');
    } catch (e) {
      debugPrint('[TuneDiscovery] TXT update failed: $e');
    }
  }

  /// Stop advertising and browsing.
  Future<void> stop() async {
    try {
      await _discovery?.stop();
    } catch (_) {}
    _discovery = null;

    try {
      await _broadcast?.stop();
    } catch (_) {}
    _broadcast = null;

    _peers.clear();
    debugPrint('[TuneDiscovery] Stopped');
  }
}
