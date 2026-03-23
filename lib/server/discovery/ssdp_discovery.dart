import 'dart:async';
import 'dart:io';

// ---------------------------------------------------------------------------
// T3.1 — SSDPDiscovery
// UDP multicast SSDP (Simple Service Discovery Protocol).
// Miroir de SSDPDiscovery.swift (iOS / Network.framework)
//
// - Envoie M-SEARCH sur 239.255.255.250:1900
// - Écoute les réponses unicast sur le port lié
// - Émet les LOCATION URL trouvées (description XML du device UPnP)
// ---------------------------------------------------------------------------

const _ssdpMulticastAddress = '239.255.255.250';
const _ssdpPort = 1900;

/// Cibles de recherche SSDP (ST header).
const ssdpTargets = [
  'urn:schemas-upnp-org:device:MediaRenderer:1',
  'urn:schemas-upnp-org:device:MediaServer:1',
  'ssdp:all',
];

/// Résultat brut d'une réponse SSDP.
class SSDPResponse {
  final String location;    // URL vers le XML de description du device
  final String usn;         // Unique Service Name
  final String server;      // ex: "Linux/3.4 UPnP/1.0 Platinum/1.0.5.13"
  final String st;          // Search Target retourné
  final InternetAddress from;

  const SSDPResponse({
    required this.location,
    required this.usn,
    required this.server,
    required this.st,
    required this.from,
  });
}

class SSDPDiscovery {
  SSDPDiscovery._();
  static final SSDPDiscovery instance = SSDPDiscovery._();

  RawDatagramSocket? _socket;
  StreamSubscription<RawSocketEvent>? _sub;
  final StreamController<SSDPResponse> _controller =
      StreamController<SSDPResponse>.broadcast();

  /// Stream des réponses SSDP reçues.
  Stream<SSDPResponse> get responses => _controller.stream;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Démarre l'écoute et envoie les requêtes M-SEARCH pour chaque [ssdpTargets].
  /// [mx] : délai max (secondes) que les devices peuvent attendre avant de répondre.
  Future<void> start({int mx = 3}) async {
    if (_socket != null) return;

    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0, // port dynamique
      reuseAddress: true,
      reusePort: false,
    );

    _socket!.multicastHops = 4;

    _sub = _socket!.listen(_onSocketEvent);

    // Envoie M-SEARCH pour chaque type de service
    for (final st in ssdpTargets) {
      _sendMSearch(st, mx);
    }
  }

  /// Arrête l'écoute.
  void stop() {
    _sub?.cancel();
    _sub = null;
    _socket?.close();
    _socket = null;
  }

  /// Relance une recherche sans redémarrer le socket.
  void refresh({int mx = 3}) {
    if (_socket == null) return;
    for (final st in ssdpTargets) {
      _sendMSearch(st, mx);
    }
  }

  void dispose() {
    stop();
    _controller.close();
  }

  // ---------------------------------------------------------------------------
  // Envoi M-SEARCH
  // ---------------------------------------------------------------------------

  void _sendMSearch(String st, int mx) {
    final message = [
      'M-SEARCH * HTTP/1.1',
      'HOST: $_ssdpMulticastAddress:$_ssdpPort',
      'MAN: "ssdp:discover"',
      'MX: $mx',
      'ST: $st',
      '',
      '',
    ].join('\r\n');

    final data = message.codeUnits;
    final destination = InternetAddress(_ssdpMulticastAddress);

    try {
      _socket?.send(data, destination, _ssdpPort);
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Réception et parsing
  // ---------------------------------------------------------------------------

  void _onSocketEvent(RawSocketEvent event) {
    if (event != RawSocketEvent.read) return;
    final datagram = _socket?.receive();
    if (datagram == null) return;

    final raw = String.fromCharCodes(datagram.data);
    final response = _parseResponse(raw, datagram.address);
    if (response != null && !_controller.isClosed) {
      _controller.add(response);
    }
  }

  SSDPResponse? _parseResponse(String raw, InternetAddress from) {
    // Vérifie que c'est bien une réponse HTTP 200 SSDP
    final lines = raw.split(RegExp(r'\r?\n'));
    if (lines.isEmpty) return null;
    final statusLine = lines.first.trim().toUpperCase();
    if (!statusLine.startsWith('HTTP/1') && !statusLine.contains('NOTIFY')) {
      // On accepte aussi les NOTIFY (announce passif)
      if (!statusLine.startsWith('NOTIFY') &&
          !statusLine.startsWith('HTTP/1.1 200')) {
        return null;
      }
    }

    final headers = <String, String>{};
    for (final line in lines.skip(1)) {
      final idx = line.indexOf(':');
      if (idx < 0) continue;
      final key = line.substring(0, idx).trim().toUpperCase();
      final value = line.substring(idx + 1).trim();
      headers[key] = value;
    }

    final location = headers['LOCATION'];
    if (location == null || location.isEmpty) return null;

    return SSDPResponse(
      location: location,
      usn: headers['USN'] ?? '',
      server: headers['SERVER'] ?? '',
      st: headers['ST'] ?? headers['NT'] ?? '',
      from: from,
    );
  }
}
