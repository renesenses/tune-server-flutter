import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../server/utils/network_utils.dart';

// ---------------------------------------------------------------------------
// ServerDiscovery — scan the local subnet for Tune servers.
// Tries GET /api/v1/system/health on port 8888 for each reachable host.
// Mirrors the Linux remote mode discovery + Swift NetworkScanner.
// ---------------------------------------------------------------------------

/// A discovered Tune server on the LAN.
class DiscoveredServer {
  final String host;
  final int port;
  final String? version;
  final String? serverName;

  const DiscoveredServer({
    required this.host,
    required this.port,
    this.version,
    this.serverName,
  });

  String get displayName =>
      serverName != null && serverName!.isNotEmpty
          ? '$serverName ($host)'
          : host;

  @override
  String toString() => 'DiscoveredServer($host:$port v$version)';
}

class ServerDiscovery {
  ServerDiscovery._();

  /// Default Tune server port.
  static const int defaultPort = 8888;

  /// Scan the local /24 subnet for Tune servers.
  ///
  /// 1. Detect local IP
  /// 2. TCP-probe port [port] on all 254 hosts (fast parallel scan)
  /// 3. For each reachable host, try GET /api/v1/system/health
  /// 4. Return list of responding servers with version info
  ///
  /// [onProgress] is called with (scanned, total) counts.
  static Future<List<DiscoveredServer>> scan({
    int port = defaultPort,
    void Function(int scanned, int total)? onProgress,
  }) async {
    final localIp = await NetworkUtils.localIpAddress();
    if (localIp == null) {
      debugPrint('[Discovery] No local IP found');
      return [];
    }

    final prefix = NetworkUtils.subnetPrefix(localIp);
    if (prefix == null) {
      debugPrint('[Discovery] Cannot derive subnet from $localIp');
      return [];
    }

    debugPrint('[Discovery] Scanning $prefix.0/24 on port $port...');

    // Phase 1: TCP probe to find reachable hosts
    final reachable = await NetworkUtils.scanSubnet(
      prefix,
      port: port,
      timeout: const Duration(milliseconds: 500),
      concurrency: 50,
    );

    debugPrint('[Discovery] ${reachable.length} hosts reachable on port $port');

    if (reachable.isEmpty) return [];

    // Phase 2: HTTP health check on each reachable host
    final servers = <DiscoveredServer>[];
    final client = http.Client();
    try {
      final total = reachable.length;
      var scanned = 0;
      final futures = reachable.map((host) async {
        final server = await _checkHealth(client, host, port);
        scanned++;
        onProgress?.call(scanned, total);
        return server;
      });
      final results = await Future.wait(futures);
      servers.addAll(results.whereType<DiscoveredServer>());
    } finally {
      client.close();
    }

    debugPrint('[Discovery] Found ${servers.length} Tune server(s)');
    return servers;
  }

  /// Probe a single host for a Tune server (used by manual host entry too).
  static Future<DiscoveredServer?> probe(String host, {int port = defaultPort}) async {
    final client = http.Client();
    try {
      return await _checkHealth(client, host, port);
    } finally {
      client.close();
    }
  }

  /// Try GET /api/v1/system/health on [host]:[port].
  /// Returns a DiscoveredServer if the endpoint responds with valid JSON,
  /// null otherwise.
  static Future<DiscoveredServer?> _checkHealth(
    http.Client client,
    String host,
    int port,
  ) async {
    try {
      final uri = Uri.parse('http://$host:$port/api/v1/system/health');
      final resp = await client.get(uri).timeout(const Duration(seconds: 3));
      if (resp.statusCode == 200) {
        String? version;
        String? serverName;
        try {
          final data = jsonDecode(resp.body);
          if (data is Map<String, dynamic>) {
            version = data['version'] as String?;
            serverName = data['server_name'] as String? ?? data['name'] as String?;
          }
        } catch (_) {
          // Body wasn't JSON — still a valid server (older version)
        }
        return DiscoveredServer(
          host: host,
          port: port,
          version: version,
          serverName: serverName,
        );
      }
    } catch (_) {
      // Not a Tune server or unreachable
    }
    return null;
  }
}
