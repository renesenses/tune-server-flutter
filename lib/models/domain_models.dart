import 'enums.dart';

// ---------------------------------------------------------------------------
// domain_models.dart — types NON-DB uniquement
//
// Les types DB (Artist, Album, Track, Playlist, PlaylistTrack, Zone,
// QueueItem, Radio, MusicFolder, RadioFavorite) sont générés par drift
// dans database.g.dart et utilisés directement.
//
// Ce fichier contient :
//   - ZoneWithState    : Zone DB + état runtime (playback, currentTrack…)
//   - DiscoveredDevice : device UPnP/DLNA découvert sur le réseau
//   - QueueSnapshot    : snapshot de la file de lecture
//   - HistoryEntry     : entrée d'historique de lecture
//   - GenreInfo        : genre + compteur pour la vue Genres
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// ZoneWithState
// Wraps la Zone drift (champs DB) + état runtime non persisté.
// Miroir de Zone.swift (iOS) qui mixait DB + runtime dans une seule struct.
// ---------------------------------------------------------------------------

/// Zone drift DB + état runtime (non persisté).
class ZoneWithState {
  /// Champs persistés (drift Zone data class)
  final int id;
  final String name;
  final OutputType? outputType;
  final String? outputDeviceId;
  final double volume;
  final String? groupId;
  final int syncDelayMs;

  /// Champs runtime uniquement
  final PlaybackState state;
  // NOTE: currentTrack est importé comme type drift Track via database.g.dart.
  // On utilise dynamic ici pour éviter l'import circulaire dans ce fichier.
  // L'AppState (qui importe les deux) fera le cast.
  final dynamic currentTrack; // Track | null
  final int positionMs;
  final int queueLength;

  const ZoneWithState({
    required this.id,
    required this.name,
    this.outputType,
    this.outputDeviceId,
    this.volume = 0.5,
    this.groupId,
    this.syncDelayMs = 0,
    this.state = PlaybackState.stopped,
    this.currentTrack,
    this.positionMs = 0,
    this.queueLength = 0,
  });

  ZoneWithState copyWith({
    int? id,
    String? name,
    OutputType? outputType,
    String? outputDeviceId,
    double? volume,
    String? groupId,
    int? syncDelayMs,
    PlaybackState? state,
    dynamic currentTrack,
    int? positionMs,
    int? queueLength,
  }) =>
      ZoneWithState(
        id: id ?? this.id,
        name: name ?? this.name,
        outputType: outputType ?? this.outputType,
        outputDeviceId: outputDeviceId ?? this.outputDeviceId,
        volume: volume ?? this.volume,
        groupId: groupId ?? this.groupId,
        syncDelayMs: syncDelayMs ?? this.syncDelayMs,
        state: state ?? this.state,
        currentTrack: currentTrack ?? this.currentTrack,
        positionMs: positionMs ?? this.positionMs,
        queueLength: queueLength ?? this.queueLength,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ZoneWithState && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------
// DiscoveredDevice
// ---------------------------------------------------------------------------

class DiscoveredDevice {
  final String id;
  final String name;
  final OutputType type;
  final String host;
  final int port;
  final bool? available;
  final Map<String, dynamic>? capabilities;

  const DiscoveredDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.host,
    required this.port,
    this.available,
    this.capabilities,
  });

  DiscoveredDevice copyWith({
    String? id,
    String? name,
    OutputType? type,
    String? host,
    int? port,
    bool? available,
    Map<String, dynamic>? capabilities,
  }) =>
      DiscoveredDevice(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        host: host ?? this.host,
        port: port ?? this.port,
        available: available ?? this.available,
        capabilities: capabilities ?? this.capabilities,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is DiscoveredDevice && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------
// QueueSnapshot
// ---------------------------------------------------------------------------

class QueueSnapshot {
  final List<dynamic> tracks; // List<Track> (drift type, typed dynamically)
  final int position;
  final bool shuffleEnabled;
  final RepeatMode repeatMode;

  const QueueSnapshot({
    required this.tracks,
    required this.position,
    required this.shuffleEnabled,
    required this.repeatMode,
  });
}

// ---------------------------------------------------------------------------
// HistoryEntry
// ---------------------------------------------------------------------------

class HistoryEntry {
  final dynamic track; // Track (drift type)
  final String playedAt;
  final String zoneName;

  const HistoryEntry({
    required this.track,
    required this.playedAt,
    required this.zoneName,
  });
}

// ---------------------------------------------------------------------------
// GenreInfo
// ---------------------------------------------------------------------------

class GenreInfo {
  final String name;
  final int count;

  const GenreInfo({required this.name, required this.count});

  String get id => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is GenreInfo && other.name == name);

  @override
  int get hashCode => name.hashCode;
}
