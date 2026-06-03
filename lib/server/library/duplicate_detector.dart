import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../database/database.dart';

// ---------------------------------------------------------------------------
// DuplicateDetector
// MD5 hash of audio content (skip 8KB header, read 1MB), group by hash.
// Miroir de duplicate_detector.rs (Rust)
// ---------------------------------------------------------------------------

/// A group of duplicate tracks sharing the same content hash.
class DuplicateGroup {
  final String hash;
  final List<Track> tracks;

  const DuplicateGroup({required this.hash, required this.tracks});

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'count': tracks.length,
        'tracks': tracks.map((t) => {
          'id': t.id,
          'title': t.title,
          'artist_name': t.artistName,
          'album_title': t.albumTitle,
          'file_path': t.filePath,
          'format': t.format,
          'sample_rate': t.sampleRate,
          'bit_depth': t.bitDepth,
        }).toList(),
      };
}

class DuplicateDetector {
  final TuneDatabase _db;

  /// How many bytes to skip at the start of the file (tags/headers).
  static const int _headerSkipBytes = 8 * 1024; // 8 KB

  /// How many bytes of audio content to read for hashing.
  static const int _readBytes = 1024 * 1024; // 1 MB

  DuplicateDetector(this._db);

  // ---------------------------------------------------------------------------
  // Detect duplicates
  // ---------------------------------------------------------------------------

  /// Scan all local tracks for duplicates.
  /// Returns groups of tracks that share the same content hash.
  Future<List<DuplicateGroup>> detect({
    void Function(int processed, int total)? onProgress,
  }) async {
    final tracks = await _db.trackRepo.all();
    final localTracks = tracks.where((t) =>
        t.filePath != null &&
        t.source == 'local' &&
        !t.filePath!.startsWith('http')).toList();

    final hashMap = <String, List<Track>>{};
    int processed = 0;

    for (final track in localTracks) {
      try {
        final hash = await _hashFile(track.filePath!);
        if (hash != null) {
          hashMap.putIfAbsent(hash, () => []).add(track);
        }
      } catch (e) {
        debugPrint('[DuplicateDetector] Error hashing ${track.filePath}: $e');
      }

      processed++;
      if (onProgress != null && processed % 50 == 0) {
        onProgress(processed, localTracks.length);
      }
    }

    onProgress?.call(localTracks.length, localTracks.length);

    // Filter to groups with 2+ tracks
    return hashMap.entries
        .where((e) => e.value.length > 1)
        .map((e) => DuplicateGroup(hash: e.key, tracks: e.value))
        .toList()
      ..sort((a, b) => b.tracks.length.compareTo(a.tracks.length));
  }

  /// Hash a single file's audio content (skip header, read 1MB).
  /// Returns null if file is too small or unreadable.
  Future<String?> _hashFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) return null;

    final length = file.lengthSync();
    if (length <= _headerSkipBytes) return null;

    final raf = file.openSync();
    try {
      // Skip header (tags, metadata)
      raf.setPositionSync(_headerSkipBytes);

      // Read up to 1MB of audio content
      final bytesToRead = (length - _headerSkipBytes).clamp(0, _readBytes);
      final bytes = raf.readSync(bytesToRead);

      if (bytes.isEmpty) return null;

      return md5.convert(bytes).toString();
    } finally {
      raf.closeSync();
    }
  }

  /// Quick check: hash two specific files and compare.
  Future<bool> areDuplicates(String path1, String path2) async {
    final hash1 = await _hashFile(path1);
    final hash2 = await _hashFile(path2);
    if (hash1 == null || hash2 == null) return false;
    return hash1 == hash2;
  }
}
