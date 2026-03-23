import 'enums.dart';

/// Domain models — miroir de DomainModels.swift (iOS)
/// Pas de dépendance drift ici : ce sont des plain Dart objects.
/// drift les utilise via les DataClasses générées dans database/schema.dart.

// ---------------------------------------------------------------------------
// Artist
// ---------------------------------------------------------------------------

class Artist {
  final int? id;
  final String name;
  final String? sortName;
  final String? musicbrainzId;
  final String? discogsId;
  final String? bio;
  final String? imagePath;

  const Artist({
    this.id,
    required this.name,
    this.sortName,
    this.musicbrainzId,
    this.discogsId,
    this.bio,
    this.imagePath,
  });

  Artist copyWith({
    int? id,
    String? name,
    String? sortName,
    String? musicbrainzId,
    String? discogsId,
    String? bio,
    String? imagePath,
  }) =>
      Artist(
        id: id ?? this.id,
        name: name ?? this.name,
        sortName: sortName ?? this.sortName,
        musicbrainzId: musicbrainzId ?? this.musicbrainzId,
        discogsId: discogsId ?? this.discogsId,
        bio: bio ?? this.bio,
        imagePath: imagePath ?? this.imagePath,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Artist && other.id == id && other.name == name);

  @override
  int get hashCode => Object.hash(id, name);
}

// ---------------------------------------------------------------------------
// Album
// ---------------------------------------------------------------------------

class Album {
  final int? id;
  final String title;
  final int? artistId;
  final String? artistName;
  final int? year;
  final String? genre;
  final int? discCount;
  final int? trackCount;
  final String? coverPath;
  final Source? source;
  final String? sourceId;

  const Album({
    this.id,
    required this.title,
    this.artistId,
    this.artistName,
    this.year,
    this.genre,
    this.discCount,
    this.trackCount,
    this.coverPath,
    this.source,
    this.sourceId,
  });

  String get stableId {
    if (id != null) return 'local-$id';
    if (sourceId != null) return '${source?.rawValue ?? 'unknown'}-$sourceId';
    return '$title-${artistName ?? ''}';
  }

  Album copyWith({
    int? id,
    String? title,
    int? artistId,
    String? artistName,
    int? year,
    String? genre,
    int? discCount,
    int? trackCount,
    String? coverPath,
    Source? source,
    String? sourceId,
  }) =>
      Album(
        id: id ?? this.id,
        title: title ?? this.title,
        artistId: artistId ?? this.artistId,
        artistName: artistName ?? this.artistName,
        year: year ?? this.year,
        genre: genre ?? this.genre,
        discCount: discCount ?? this.discCount,
        trackCount: trackCount ?? this.trackCount,
        coverPath: coverPath ?? this.coverPath,
        source: source ?? this.source,
        sourceId: sourceId ?? this.sourceId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Album && other.stableId == stableId);

  @override
  int get hashCode => stableId.hashCode;
}

// ---------------------------------------------------------------------------
// Track
// ---------------------------------------------------------------------------

class Track {
  final int? id;
  final String title;
  final int? albumId;
  final String? albumTitle;
  final int? artistId;
  final String? artistName;
  final int? discNumber;
  final int? trackNumber;
  final int? durationMs;
  final String? filePath;
  final AudioFormat? format;
  final int? sampleRate;
  final int? bitDepth;
  final int? channels;
  final String? coverPath;
  final Source? source;
  final String? sourceId;

  const Track({
    this.id,
    required this.title,
    this.albumId,
    this.albumTitle,
    this.artistId,
    this.artistName,
    this.discNumber,
    this.trackNumber,
    this.durationMs,
    this.filePath,
    this.format,
    this.sampleRate,
    this.bitDepth,
    this.channels,
    this.coverPath,
    this.source,
    this.sourceId,
  });

  String get stableId {
    if (id != null) return 'local-$id';
    if (sourceId != null) return '${source?.rawValue ?? 'unknown'}-$sourceId';
    return '$title-${artistName ?? ''}-${albumTitle ?? ''}';
  }

  bool get isRadio => source == Source.radio;

  String get durationFormatted {
    if (durationMs == null) return '--:--';
    final totalSeconds = durationMs! ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Badge ex: "FLAC / 96 kHz / 24-bit" ou "DSD128 / 2.8 MHz"
  /// [HI-RES-TODO] : cette logique sera utilisée dès que les outputs Hi-Res seront implémentés
  String? get audioBadge {
    if (format == AudioFormat.dsd) {
      if (sampleRate != null) {
        final hz = sampleRate!.toDouble();
        if (hz >= 1000000) {
          final multiplier = (hz / 2822400).round().clamp(1, 8);
          return 'DSD${multiplier * 64} / ${(hz / 1000000).toStringAsFixed(1)} MHz';
        } else {
          final String level;
          if (sampleRate! <= 48000)       level = 'DSD64';
          else if (sampleRate! <= 96000)  level = 'DSD64';
          else if (sampleRate! <= 192000) level = 'DSD128';
          else if (sampleRate! <= 384000) level = 'DSD256';
          else                            level = 'DSD512';
          return '$level / 2.8 MHz';
        }
      }
      return 'DSD';
    }

    final parts = <String>[];
    if (format != null) parts.add(format!.name.toUpperCase());
    if (sampleRate != null) {
      final kHz = sampleRate! / 1000.0;
      parts.add(sampleRate! % 1000 == 0
          ? '${kHz.toStringAsFixed(0)} kHz'
          : '${kHz.toStringAsFixed(1)} kHz');
    }
    if (bitDepth != null) parts.add('$bitDepth-bit');
    return parts.isEmpty ? null : parts.join(' / ');
  }

  Track copyWith({
    int? id,
    String? title,
    int? albumId,
    String? albumTitle,
    int? artistId,
    String? artistName,
    int? discNumber,
    int? trackNumber,
    int? durationMs,
    String? filePath,
    AudioFormat? format,
    int? sampleRate,
    int? bitDepth,
    int? channels,
    String? coverPath,
    Source? source,
    String? sourceId,
  }) =>
      Track(
        id: id ?? this.id,
        title: title ?? this.title,
        albumId: albumId ?? this.albumId,
        albumTitle: albumTitle ?? this.albumTitle,
        artistId: artistId ?? this.artistId,
        artistName: artistName ?? this.artistName,
        discNumber: discNumber ?? this.discNumber,
        trackNumber: trackNumber ?? this.trackNumber,
        durationMs: durationMs ?? this.durationMs,
        filePath: filePath ?? this.filePath,
        format: format ?? this.format,
        sampleRate: sampleRate ?? this.sampleRate,
        bitDepth: bitDepth ?? this.bitDepth,
        channels: channels ?? this.channels,
        coverPath: coverPath ?? this.coverPath,
        source: source ?? this.source,
        sourceId: sourceId ?? this.sourceId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Track && other.stableId == stableId);

  @override
  int get hashCode => stableId.hashCode;
}

// ---------------------------------------------------------------------------
// Playlist
// ---------------------------------------------------------------------------

class Playlist {
  final int? id;
  final String name;
  final String? description;
  final int? trackCount;

  const Playlist({
    this.id,
    required this.name,
    this.description,
    this.trackCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Playlist && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------
// Zone
// ---------------------------------------------------------------------------

class Zone {
  final int? id;
  final String name;
  final OutputType? outputType;
  final String? outputDeviceId;
  final double? volume;
  final String? groupId;
  final int? syncDelayMs;

  // Runtime-only (non persistés en DB)
  final PlaybackState? state;
  final Track? currentTrack;
  final int? positionMs;
  final int? queueLength;

  const Zone({
    this.id,
    required this.name,
    this.outputType,
    this.outputDeviceId,
    this.volume,
    this.groupId,
    this.syncDelayMs,
    this.state,
    this.currentTrack,
    this.positionMs,
    this.queueLength,
  });

  Zone copyWith({
    int? id,
    String? name,
    OutputType? outputType,
    String? outputDeviceId,
    double? volume,
    String? groupId,
    int? syncDelayMs,
    PlaybackState? state,
    Track? currentTrack,
    int? positionMs,
    int? queueLength,
  }) =>
      Zone(
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
      identical(this, other) || (other is Zone && other.id == id);

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is DiscoveredDevice && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------
// RadioStation
// ---------------------------------------------------------------------------

class RadioStation {
  final int? id;
  final String name;
  final String streamUrl;
  final String? logoUrl;
  final String? genre;
  final String? tags;
  final String? codec;
  final String? country;
  final String? homepageUrl;
  final bool favorite;

  const RadioStation({
    this.id,
    required this.name,
    required this.streamUrl,
    this.logoUrl,
    this.genre,
    this.tags,
    this.codec,
    this.country,
    this.homepageUrl,
    this.favorite = false,
  });

  RadioStation copyWith({
    int? id,
    String? name,
    String? streamUrl,
    String? logoUrl,
    String? genre,
    String? tags,
    String? codec,
    String? country,
    String? homepageUrl,
    bool? favorite,
  }) =>
      RadioStation(
        id: id ?? this.id,
        name: name ?? this.name,
        streamUrl: streamUrl ?? this.streamUrl,
        logoUrl: logoUrl ?? this.logoUrl,
        genre: genre ?? this.genre,
        tags: tags ?? this.tags,
        codec: codec ?? this.codec,
        country: country ?? this.country,
        homepageUrl: homepageUrl ?? this.homepageUrl,
        favorite: favorite ?? this.favorite,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is RadioStation && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------
// QueueSnapshot
// ---------------------------------------------------------------------------

class QueueSnapshot {
  final List<Track> tracks;
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
  final Track track;
  final String playedAt;
  final String zoneName;

  const HistoryEntry({
    required this.track,
    required this.playedAt,
    required this.zoneName,
  });

  String get id => '$playedAt-${track.id ?? 0}';
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
// RadioFavorite
// ---------------------------------------------------------------------------

class RadioFavorite {
  final int? id;
  final String title;
  final String artist;
  final String stationName;
  final String streamUrl;
  final String? coverPath;
  final String savedAt;

  const RadioFavorite({
    this.id,
    required this.title,
    required this.artist,
    required this.stationName,
    required this.streamUrl,
    this.coverPath,
    required this.savedAt,
  });

  String get savedDateFormatted {
    try {
      final dt = DateTime.parse(savedAt);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return savedAt;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is RadioFavorite && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------
// MusicFolder
// ---------------------------------------------------------------------------

class MusicFolder {
  final int? id;
  final String path;
  final String addedAt;

  const MusicFolder({
    this.id,
    required this.path,
    required this.addedAt,
  });
}
