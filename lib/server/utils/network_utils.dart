import 'dart:io';

// ---------------------------------------------------------------------------
// T2.3 — NetworkUtils
// IP locale WiFi + scan subnet — miroir de NetworkUtils.swift (iOS)
// ---------------------------------------------------------------------------

class NetworkUtils {
  NetworkUtils._();

  // ---------------------------------------------------------------------------
  // IP locale
  // ---------------------------------------------------------------------------

  /// Retourne la première adresse IPv4 non-loopback trouvée sur les interfaces
  /// réseau actives. Préfère les interfaces WiFi/en0 mais accepte toutes.
  static Future<String?> localIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );

      // Priorité : interfaces dont le nom commence par 'wlan', 'en', 'wifi'
      final preferred = interfaces.where((i) {
        final name = i.name.toLowerCase();
        return name.startsWith('wlan') ||
            name.startsWith('en') ||
            name.startsWith('wifi');
      });

      final all = [...preferred, ...interfaces];
      for (final iface in all) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  // ---------------------------------------------------------------------------
  // Scan subnet
  // ---------------------------------------------------------------------------

  /// Déduit le sous-réseau /24 à partir d'une IP (ex: "192.168.1.42" → "192.168.1").
  static String? subnetPrefix(String ipAddress) {
    final parts = ipAddress.split('.');
    if (parts.length != 4) return null;
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  /// Scanne les 254 hôtes d'un sous-réseau /24 en tentant une connexion TCP
  /// sur [port]. Retourne la liste des IP qui ont répondu.
  ///
  /// [timeout] : délai max par hôte (défaut 300 ms — compromis vitesse/fiabilité).
  /// [concurrency] : nombre de sondes simultanées (défaut 50).
  static Future<List<String>> scanSubnet(
    String subnetPrefix, {
    int port = 80,
    Duration timeout = const Duration(milliseconds: 300),
    int concurrency = 50,
  }) async {
    final results = <String>[];
    final hosts = List.generate(254, (i) => '$subnetPrefix.${i + 1}');

    // Traite les hôtes par lots de [concurrency]
    for (var offset = 0; offset < hosts.length; offset += concurrency) {
      final batch = hosts.skip(offset).take(concurrency);
      final futures = batch.map((host) => _probeHost(host, port, timeout));
      final reachable = await Future.wait(futures);
      results.addAll(reachable.whereType<String>());
    }

    return results;
  }

  /// Retourne l'adresse si le port TCP est accessible, null sinon.
  static Future<String?> _probeHost(
      String host, int port, Duration timeout) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      await socket.close();
      return host;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Vérifie si une chaîne est une adresse IPv4 valide.
  static bool isValidIpv4(String address) {
    final parts = address.split('.');
    if (parts.length != 4) return false;
    return parts.every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255;
    });
  }

  /// Formate un port pour affichage (ex: 8080 → ":8080", 80 → "").
  static String formatPort(int port) => port == 80 ? '' : ':$port';
}
