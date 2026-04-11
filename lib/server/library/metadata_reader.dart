import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

// ---------------------------------------------------------------------------
// T7.1 — MetadataReader
// Lecture des tags audio via platform channel (AVFoundation iOS /
// MediaMetadataRetriever Android), traitement en Isolate.
// Miroir de MetadataReader.swift (iOS / AVFoundation)
//
// Architecture :
//   - Les appels platform channel (I/O bloquant) restent sur le main isolate.
//   - Le traitement / mapping des données brutes → TrackMetadata se fait en
//     Isolate.run() pour ne pas bloquer l'event loop Flutter.
//
// iOS : AVFoundation retourne sampleRate et bitDepth natifs pour FLAC/ALAC.
// Android : MediaMetadataRetriever ne les expose pas — on utilise MediaExtractor
// dans MainActivity pour obtenir sampleRate, channels et bitDepth.
// ---------------------------------------------------------------------------

const _channel = MethodChannel('com.mozaiklabs.tuneserver/library');

/// Métadonnées extraites d'un fichier audio.
class TrackMetadata {
  final String filePath;
  final String title;
  final String? artist;
  final String? albumArtist;
  final String? album;
  final int? trackNumber;
  final int? discNumber;
  final int? year;
  final String? genre;
  final int? durationMs;
  final String? format;    // 'flac' | 'mp3' | 'aac' | 'alac' …
  final int? sampleRate;   // Hz
  final int? bitDepth;     // bits
  final int? channels;
  final int? bitrate;      // kbps
  final bool hasCoverData;

  const TrackMetadata({
    required this.filePath,
    required this.title,
    this.artist,
    this.albumArtist,
    this.album,
    this.trackNumber,
    this.discNumber,
    this.year,
    this.genre,
    this.durationMs,
    this.format,
    this.sampleRate,
    this.bitDepth,
    this.channels,
    this.bitrate,
    this.hasCoverData = false,
  });
}

class MetadataReader {
  MetadataReader._();

  // ---------------------------------------------------------------------------
  // Lecture d'un fichier unique
  // ---------------------------------------------------------------------------

  /// Lit les tags d'un fichier audio. Toujours appelé depuis le main isolate.
  static Future<TrackMetadata?> read(String filePath) async {
    try {
      final raw = await _channel.invokeMapMethod<String, dynamic>(
        'readMetadata',
        {'path': filePath},
      );
      if (raw == null) return null;
      // Traitement dans un isolate (même pour un fichier — cohérence)
      return await Isolate.run(() => _mapMetadata(filePath, raw));
    } on PlatformException {
      return _fallbackMetadata(filePath);
    }
  }

  // ---------------------------------------------------------------------------
  // Lecture en lot (batch) — optimisé pour des centaines de fichiers
  // ---------------------------------------------------------------------------

  /// Lit les tags de [filePaths] par lots de [batchSize].
  /// Les appels au channel restent sur le main isolate ;
  /// le mapping vers TrackMetadata se fait en Isolate.run() par lot.
  static Stream<TrackMetadata> readBatch(
    List<String> filePaths, {
    int batchSize = 50,
    void Function(int done, int total)? onProgress,
  }) async* {
    int done = 0;
    final total = filePaths.length;

    for (var offset = 0; offset < total; offset += batchSize) {
      final batch = filePaths.skip(offset).take(batchSize).toList();

      // Appel platform channel sur le main isolate
      List<dynamic>? rawList;
      try {
        rawList = await _channel.invokeListMethod<dynamic>(
          'readMetadataBatch',
          {'paths': batch},
        );
      } on PlatformException {
        rawList = null;
      }

      // Mapping en Isolate.run (CPU : parsing, normalisation)
      final results = await Isolate.run(() {
        final metas = <TrackMetadata>[];
        if (rawList == null) {
          for (final path in batch) {
            final m = _fallbackMetadata(path);
            if (m != null) metas.add(m);
          }
          return metas;
        }
        for (var i = 0; i < rawList.length; i++) {
          final raw = rawList[i];
          if (raw is Map) {
            final path = batch[i];
            final m = _mapMetadata(path, Map<String, dynamic>.from(raw));
            if (m != null) metas.add(m);
          }
        }
        return metas;
      });

      for (final meta in results) {
        yield meta;
      }

      done += batch.length;
      onProgress?.call(done, total);
    }
  }

  // ---------------------------------------------------------------------------
  // Artwork
  // ---------------------------------------------------------------------------

  /// Retourne les données brutes de la pochette embarquée, ou null.
  static Future<List<int>?> readCoverData(String filePath) async {
    try {
      final data = await _channel.invokeListMethod<int>(
        'readCoverData',
        {'path': filePath},
      );
      return data;
    } on PlatformException {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers — top-level pour compatibilité Isolate.run()
  // ---------------------------------------------------------------------------

  static TrackMetadata? _mapMetadata(
      String filePath, Map<String, dynamic> raw) {
    final title = raw['title'] as String? ??
        p.basenameWithoutExtension(filePath);

    return TrackMetadata(
      filePath: filePath,
      title: title,
      artist: raw['artist'] as String?,
      albumArtist: raw['albumArtist'] as String?,
      album: raw['album'] as String?,
      trackNumber: _parseInt(raw['trackNumber']),
      discNumber: _parseInt(raw['discNumber']),
      year: _parseInt(raw['year']),
      genre: raw['genre'] as String?,
      durationMs: _parseInt(raw['durationMs']),
      format: raw['format'] as String? ??
          _formatFromExtension(filePath),
      sampleRate: _parseInt(raw['sampleRate']),
      bitDepth: _parseInt(raw['bitDepth']),
      channels: _parseInt(raw['channels']),
      bitrate: _parseInt(raw['bitrate']),
      hasCoverData: raw['hasCoverData'] == true,
    );
  }

  static TrackMetadata? _fallbackMetadata(String filePath) {
    // Dernière chance : nom de fichier comme titre, format déduit
    return TrackMetadata(
      filePath: filePath,
      title: p.basenameWithoutExtension(filePath),
      format: _formatFromExtension(filePath),
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static String? _formatFromExtension(String path) {
    switch (p.extension(path).toLowerCase()) {
      case '.flac': return 'flac';
      case '.mp3':  return 'mp3';
      case '.m4a':  return 'aac';
      case '.alac': return 'alac';
      case '.aac':  return 'aac';
      case '.ogg':  return 'ogg';
      case '.opus': return 'opus';
      case '.wav':  return 'wav';
      case '.aiff':
      case '.aif':  return 'aiff';
      case '.dsf':
      case '.dff':  return 'dsd';
      default:      return null;
    }
  }
}
