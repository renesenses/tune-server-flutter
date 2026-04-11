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

  factory ZoneWithState.fromJson(Map<String, dynamic> json) {
    final stateStr = json['state'] as String? ?? 'stopped';
    final outputTypeStr = json['output_type'] as String?;
    return ZoneWithState(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      outputType: outputTypeStr != null ? OutputType.fromRawValue(outputTypeStr) : null,
      outputDeviceId: json['output_device_id'] as String?,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.5,
      groupId: json['group_id'] as String?,
      syncDelayMs: json['sync_delay_ms'] as int? ?? 0,
      state: PlaybackState.fromRawValue(stateStr) ?? PlaybackState.stopped,
      positionMs: json['position_ms'] as int? ?? 0,
      queueLength: json['queue_length'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ZoneWithState && other.id == id);

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

// ---------------------------------------------------------------------------
// AlbumAudioInfo — audio quality metadata for an album (derived from tracks)
// ---------------------------------------------------------------------------

enum AudioQuality {
  dsd,
  hiRes,
  cd,
  lossy;

  String get label {
    switch (this) {
      case AudioQuality.dsd:   return 'DSD';
      case AudioQuality.hiRes: return 'Hi-Res';
      case AudioQuality.cd:    return 'CD';
      case AudioQuality.lossy: return 'Lossy';
    }
  }
}

class AlbumAudioInfo {
  final int albumId;
  final String? format;       // dominant format (FLAC, MP3, etc.)
  final int? sampleRate;      // max sample rate across tracks
  final int? bitDepth;        // max bit depth across tracks
  final AudioQuality quality; // computed quality tier

  const AlbumAudioInfo({
    required this.albumId,
    this.format,
    this.sampleRate,
    this.bitDepth,
    required this.quality,
  });

  /// Compute quality from format / sampleRate / bitDepth.
  /// Same logic as the Tune server: DSD format = dsd, mp3/aac/ogg/opus/wma =
  /// lossy, >48kHz or >16bit = hi-res, otherwise cd.
  static AudioQuality computeQuality(String? format, int? sampleRate, int? bitDepth) {
    final lo = format?.toLowerCase() ?? '';
    if (lo == 'dsd' || lo == 'dsf' || lo == 'dff') return AudioQuality.dsd;
    if (lo == 'mp3' || lo == 'aac' || lo == 'ogg' || lo == 'opus' || lo == 'wma') {
      return AudioQuality.lossy;
    }
    if ((sampleRate != null && sampleRate > 48000) ||
        (bitDepth != null && bitDepth > 16)) {
      return AudioQuality.hiRes;
    }
    return AudioQuality.cd;
  }
}
