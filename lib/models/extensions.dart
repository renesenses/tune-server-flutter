import '../server/database/database.dart';
import 'enums.dart';

// ---------------------------------------------------------------------------
// extensions.dart
// Propriétés calculées sur les types drift générés — miroir des computed
// properties de DomainModels.swift (iOS).
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Track extensions
// ---------------------------------------------------------------------------

extension TrackExtensions on Track {
  /// Identifiant stable cross-source.
  String get stableId {
    if (source == 'local') return 'local-$id';
    if (sourceId != null) return '${source}-$sourceId';
    return '$title-${artistName ?? ''}-${albumTitle ?? ''}';
  }

  bool get isRadio => source == Source.radio.rawValue;

  String get durationFormatted {
    if (durationMs == null) return '--:--';
    final totalSeconds = durationMs! ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Badge audio ex: "FLAC / 96 kHz / 24-bit" ou "DSD128 / 2.8 MHz"
  String? get audioBadge {
    if (format == AudioFormat.dsd.rawValue) {
      if (sampleRate != null) {
        final hz = sampleRate!.toDouble();
        if (hz >= 1000000) {
          final multiplier = (hz / 2822400).round().clamp(1, 8);
          return 'DSD${multiplier * 64} / ${(hz / 1000000).toStringAsFixed(1)} MHz';
        } else {
          final String level;
          if (sampleRate! <= 96000) {
            level = 'DSD64';
          } else if (sampleRate! <= 192000) {
            level = 'DSD128';
          } else if (sampleRate! <= 384000) {
            level = 'DSD256';
          } else {
            level = 'DSD512';
          }
          return '$level / 2.8 MHz';
        }
      }
      return 'DSD';
    }

    final parts = <String>[];
    if (format != null) parts.add(format!.toUpperCase());
    if (sampleRate != null) {
      final kHz = sampleRate! / 1000.0;
      parts.add(sampleRate! % 1000 == 0
          ? '${kHz.toStringAsFixed(0)} kHz'
          : '${kHz.toStringAsFixed(1)} kHz');
    }
    if (bitDepth != null) parts.add('$bitDepth-bit');
    return parts.isEmpty ? null : parts.join(' / ');
  }

  // source est non-nullable (withDefault 'local') — pas de null check nécessaire
  Source? get sourceEnum => Source.fromRawValue(source);
  AudioFormat? get formatEnum => format != null ? AudioFormat.fromRawValue(format!) : null;
}

// ---------------------------------------------------------------------------
// Album extensions
// ---------------------------------------------------------------------------

extension AlbumExtensions on Album {
  String get stableId {
    if (source == 'local') return 'local-$id';
    if (sourceId != null) return '${source}-$sourceId';
    return '$title-${artistName ?? ''}';
  }

  Source? get sourceEnum => source != null ? Source.fromRawValue(source!) : null;
}

// ---------------------------------------------------------------------------
// Artist extensions
// ---------------------------------------------------------------------------

extension ArtistExtensions on Artist {
  /// "The Beatles" → "Beatles, The"
  static String makeSortName(String name) {
    const prefixes = ['The ', 'Le ', 'La ', 'Les ', "L'", 'A '];
    for (final prefix in prefixes) {
      if (name.startsWith(prefix)) {
        final rest = name.substring(prefix.length);
        return '$rest, ${prefix.trim()}';
      }
    }
    return name;
  }
}

// ---------------------------------------------------------------------------
// Radio extensions (drift's Radio = RadioStation iOS)
// ---------------------------------------------------------------------------

extension RadioExtensions on Radio {
  /// URL HTTP forcée (remplace https:// → http:// comme dans l'app iOS)
  String get httpStreamUrl => streamUrl.replaceFirst('https://', 'http://');
}

// ---------------------------------------------------------------------------
// RadioFavorite extensions
// ---------------------------------------------------------------------------

extension RadioFavoriteExtensions on RadioFavorite {
  String get savedDateFormatted {
    try {
      final dt = DateTime.parse(savedAt);
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return savedAt;
    }
  }
}
