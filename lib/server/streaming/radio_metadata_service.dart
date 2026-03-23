import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../event_bus.dart';

// ---------------------------------------------------------------------------
// T8.1 — RadioMetadataService
// Récupère les métadonnées de la piste en cours sur une radio.
// Miroir de RadioMetadataService.swift (iOS)
//
// Deux stratégies :
//   1. ICY metadata — embarquée dans le flux HTTP (standard SHOUTcast/Icecast)
//      Requête avec `Icy-MetaData: 1`, parse l'en-tête `icy-metaint`, lit le
//      bloc de metadata dans le flux toutes les [metaint] octets.
//   2. RadioFrance API — polling HTTP dédié pour les stations RF publiques.
//
// Émet RadioMetadataEvent sur l'EventBus à chaque changement détecté.
// ---------------------------------------------------------------------------

/// Métadonnées courantes d'une radio.
class RadioMetadata {
  final String stationName;
  final String? title;
  final String? artist;
  final String? streamUrl;

  const RadioMetadata({
    required this.stationName,
    this.title,
    this.artist,
    this.streamUrl,
  });

  @override
  bool operator ==(Object other) =>
      other is RadioMetadata &&
      other.stationName == stationName &&
      other.title == title &&
      other.artist == artist;

  @override
  int get hashCode => Object.hash(stationName, title, artist);
}

class RadioMetadataService {
  RadioMetadataService._();
  static final RadioMetadataService instance = RadioMetadataService._();

  final Map<String, _StationPoller> _pollers = {};

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Démarre le polling de métadonnées pour une station.
  void startPolling({
    required String stationName,
    required String streamUrl,
  }) {
    stopPolling(stationName); // stoppe si déjà actif

    final poller = _StationPoller(
      stationName: stationName,
      streamUrl: streamUrl,
      onMetadata: (meta) {
        EventBus.instance.emit(RadioMetadataEvent(
          meta.stationName,
          title: meta.title,
          artist: meta.artist,
        ));
      },
    );

    _pollers[stationName] = poller;
    poller.start();
  }

  /// Arrête le polling pour une station.
  void stopPolling(String stationName) {
    _pollers.remove(stationName)?.stop();
  }

  /// Arrête tous les pollings actifs.
  void stopAll() {
    for (final p in _pollers.values) {
      p.stop();
    }
    _pollers.clear();
  }
}

// ---------------------------------------------------------------------------
// Poller interne par station
// ---------------------------------------------------------------------------

class _StationPoller {
  final String stationName;
  final String streamUrl;
  final void Function(RadioMetadata) onMetadata;

  Timer? _timer;
  HttpClient? _icyClient;
  RadioMetadata? _lastMetadata;
  bool _stopped = false;

  _StationPoller({
    required this.stationName,
    required this.streamUrl,
    required this.onMetadata,
  });

  void start() {
    // Essaie ICY d'abord, puis RadioFrance si applicable, puis polling HTTP
    _tryIcy();
  }

  void stop() {
    _stopped = true;
    _timer?.cancel();
    _timer = null;
    _icyClient?.close(force: true);
    _icyClient = null;
  }

  // ---------------------------------------------------------------------------
  // Stratégie 1 : ICY metadata dans le flux
  // ---------------------------------------------------------------------------

  Future<void> _tryIcy() async {
    if (_stopped) return;

    try {
      _icyClient = HttpClient();
      final request = await _icyClient!
          .getUrl(Uri.parse(streamUrl))
          .timeout(const Duration(seconds: 8));

      request.headers.set('Icy-MetaData', '1');
      request.headers.set('User-Agent', 'TuneServer/1.0');

      final response = await request.close()
          .timeout(const Duration(seconds: 8));

      final metaIntStr = response.headers.value('icy-metaint');
      final metaInt = int.tryParse(metaIntStr ?? '');
      final icyName = response.headers.value('icy-name');

      if (metaInt == null || metaInt <= 0) {
        // Pas d'ICY metadata → fallback polling
        _icyClient?.close(force: true);
        _icyClient = null;
        _startPollingFallback();
        return;
      }

      // Lit le flux ICY
      await _readIcyStream(response, metaInt, icyName);
    } catch (_) {
      if (!_stopped) {
        _icyClient?.close(force: true);
        _icyClient = null;
        _startPollingFallback();
      }
    }
  }

  Future<void> _readIcyStream(
    HttpClientResponse response,
    int metaInt,
    String? stationNameFromHeader,
  ) async {
    final buffer = <int>[];
    int audioByteCount = 0;

    await for (final chunk in response) {
      if (_stopped) break;
      for (final byte in chunk) {
        if (_stopped) break;

        if (audioByteCount < metaInt) {
          // Données audio — on skippe
          audioByteCount++;
        } else if (audioByteCount == metaInt) {
          // Premier octet après [metaInt] : taille du bloc metadata (×16)
          final metaLength = byte * 16;
          audioByteCount++;
          if (metaLength == 0) {
            audioByteCount = 0; // reset pour prochain bloc
          } else {
            buffer.clear();
            // Les prochains [metaLength] octets sont les metadata
            for (var i = 0; i < metaLength; i++) {
              // Ne peut pas lire byte par byte dans le stream async —
              // on accumule dans buffer jusqu'à avoir metaLength octets
              buffer.add(0); // placeholder, remplacé ci-dessous
            }
          }
        } else {
          // Dans le bloc metadata
          final idx = audioByteCount - metaInt - 1;
          if (idx < buffer.length) {
            buffer[idx] = byte;
          }
          audioByteCount++;

          if (audioByteCount >= metaInt + 1 + buffer.length) {
            // Bloc complet — parse
            final metaStr =
                latin1.decode(buffer).replaceAll('\x00', '').trim();
            _parseIcyMeta(metaStr, stationNameFromHeader);
            audioByteCount = 0;
            buffer.clear();
          }
        }
      }
    }
  }

  void _parseIcyMeta(String meta, String? stationNameOverride) {
    if (meta.isEmpty) return;

    // Format : "StreamTitle='Artist - Title';StreamUrl='url';"
    String? title;
    String? artist;

    final titleMatch =
        RegExp(r"StreamTitle='([^']*)'").firstMatch(meta);
    if (titleMatch != null) {
      final raw = titleMatch.group(1)?.trim() ?? '';
      // Tente "Artist - Title" split
      final parts = raw.split(' - ');
      if (parts.length >= 2) {
        artist = parts.first.trim();
        title = parts.sublist(1).join(' - ').trim();
      } else {
        title = raw;
      }
    }

    final metadata = RadioMetadata(
      stationName: stationNameOverride ?? stationName,
      title: title?.isNotEmpty == true ? title : null,
      artist: artist?.isNotEmpty == true ? artist : null,
    );

    if (metadata != _lastMetadata) {
      _lastMetadata = metadata;
      onMetadata(metadata);
    }
  }

  // ---------------------------------------------------------------------------
  // Stratégie 2 : polling HTTP (RadioFrance ou endpoint dédié)
  // ---------------------------------------------------------------------------

  void _startPollingFallback({Duration interval = const Duration(seconds: 15)}) {
    if (_stopped) return;

    // Détecte RadioFrance
    if (_isRadioFrance(streamUrl)) {
      _pollRadioFrance(interval);
    }
    // Autres radios : pas de polling possible sans API dédiée
  }

  bool _isRadioFrance(String url) =>
      url.contains('radiofrance') ||
      url.contains('franceinter') ||
      url.contains('franceinfo') ||
      url.contains('franceculture') ||
      url.contains('fip.fr') ||
      url.contains('mouv.fr');

  void _pollRadioFrance(Duration interval) {
    _timer = Timer.periodic(interval, (_) async {
      if (_stopped) return;
      await _fetchRadioFranceMeta();
    });
    // Premier appel immédiat
    _fetchRadioFranceMeta();
  }

  Future<void> _fetchRadioFranceMeta() async {
    try {
      // API RadioFrance Live (publique)
      final stationKey = _radioFranceStationKey(streamUrl);
      if (stationKey == null) return;

      final uri = Uri.parse(
          'https://www.radiofrance.fr/api/v2.1/stations/$stationKey/songs/now');

      final resp =
          await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) return;

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final song = data['song'] as Map<String, dynamic>?;
      if (song == null) return;

      final title = song['title'] as String?;
      final artist =
          (song['performers'] as List?)?.firstOrNull?['name'] as String? ??
          song['composer']?['name'] as String?;

      final metadata = RadioMetadata(
        stationName: stationName,
        title: title,
        artist: artist,
      );

      if (metadata != _lastMetadata) {
        _lastMetadata = metadata;
        onMetadata(metadata);
      }
    } catch (_) {}
  }

  String? _radioFranceStationKey(String url) {
    if (url.contains('franceinter')) return 'franceinter';
    if (url.contains('franceinfo'))  return 'franceinfo';
    if (url.contains('franceculture')) return 'franceculture';
    if (url.contains('fip'))         return 'fip';
    if (url.contains('mouv'))        return 'mouv';
    if (url.contains('francemusique')) return 'francemusique';
    return null;
  }
}
