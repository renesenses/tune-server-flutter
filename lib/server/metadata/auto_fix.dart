import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../database/database.dart';
import '../event_bus.dart';

// ---------------------------------------------------------------------------
// AutoFix
// Scan tracks with missing metadata, query MusicBrainz for genre/year/ISRC
// suggestions.
// Miroir de auto_fix.rs (Rust)
// ---------------------------------------------------------------------------

/// A suggested fix for a track's metadata.
class MetadataFix {
  final int trackId;
  final String field;     // 'genre', 'year', 'isrc', 'musicbrainz_recording_id'
  final String? oldValue;
  final String newValue;
  final double confidence;

  const MetadataFix({
    required this.trackId,
    required this.field,
    this.oldValue,
    required this.newValue,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
        'track_id': trackId,
        'field': field,
        'old_value': oldValue,
        'new_value': newValue,
        'confidence': confidence,
      };
}

/// Progress event for auto-fix scan.
class AutoFixProgressEvent extends AppEvent {
  final int processed;
  final int total;
  final int fixesFound;
  const AutoFixProgressEvent(this.processed, this.total, this.fixesFound);
}

class AutoFix {
  static const _baseUrl = 'https://musicbrainz.org/ws/2';
  static const _userAgent = 'Tune/1.0 (https://mozaiklabs.fr)';

  final TuneDatabase _db;
  final http.Client _http;

  /// Rate limit: MusicBrainz allows 1 request per second
  DateTime _lastRequest = DateTime(2000);
  static const _minInterval = Duration(milliseconds: 1100);

  bool _cancelRequested = false;

  AutoFix(this._db, {http.Client? client}) : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Scan for fixable tracks
  // ---------------------------------------------------------------------------

  /// Find tracks with missing metadata that could be enriched.
  Future<List<Map<String, dynamic>>> findIncomplete({int limit = 1000}) async {
    final rows = await _db.customSelect(
      'SELECT t.* FROM tracks t '
      'LEFT JOIN albums a ON t.album_id = a.id '
      "WHERE (a.genre IS NULL OR a.genre = '' "
      'OR a.year IS NULL) '
      "AND t.source = 'local' "
      'LIMIT ?',
      variables: [Variable(limit)],
      readsFrom: {_db.tracks, _db.albums},
    ).get();

    return rows.map((row) => row.data).toList();
  }

  // ---------------------------------------------------------------------------
  // Auto-fix scan
  // ---------------------------------------------------------------------------

  /// Scan incomplete tracks and generate suggested fixes from MusicBrainz.
  /// Returns a list of suggested fixes (not yet applied).
  Future<List<MetadataFix>> scan({int limit = 200}) async {
    _cancelRequested = false;
    final tracks = await findIncomplete(limit: limit);
    final fixes = <MetadataFix>[];
    int processed = 0;

    for (final track in tracks) {
      if (_cancelRequested) break;

      try {
        final trackFixes = await _lookupTrack(track);
        fixes.addAll(trackFixes);
      } catch (e) {
        debugPrint('[AutoFix] Error processing track ${track['id']}: $e');
      }

      processed++;
      if (processed % 10 == 0) {
        EventBus.instance.emit(
          AutoFixProgressEvent(processed, tracks.length, fixes.length),
        );
      }
    }

    EventBus.instance.emit(
      AutoFixProgressEvent(tracks.length, tracks.length, fixes.length),
    );

    debugPrint('[AutoFix] Scan complete: ${fixes.length} fixes found '
        'for ${tracks.length} tracks');
    return fixes;
  }

  /// Cancel a running scan.
  void cancel() => _cancelRequested = true;

  // ---------------------------------------------------------------------------
  // Apply fixes
  // ---------------------------------------------------------------------------

  /// Apply a list of fixes to the database.
  Future<int> apply(List<MetadataFix> fixes) async {
    int applied = 0;

    for (final fix in fixes) {
      try {
        final track = await _db.trackRepo.byId(fix.trackId);
        if (track == null) continue;

        switch (fix.field) {
          case 'musicbrainz_recording_id':
            await _db.customUpdate(
              'UPDATE tracks SET musicbrainz_recording_id = ? WHERE id = ?',
              variables: [Variable(fix.newValue), Variable(fix.trackId)],
              updates: {_db.tracks},
            );
            applied++;

          case 'genre':
            if (track.albumId != null) {
              await _db.customUpdate(
                "UPDATE albums SET genre = ? WHERE id = ? AND (genre IS NULL OR genre = '')",
                variables: [Variable(fix.newValue), Variable(track.albumId!)],
                updates: {_db.albums},
              );
              applied++;
            }

          case 'year':
            if (track.albumId != null) {
              final year = int.tryParse(fix.newValue);
              if (year != null) {
                await _db.customUpdate(
                  'UPDATE albums SET year = ? WHERE id = ? AND year IS NULL',
                  variables: [Variable(year), Variable(track.albumId!)],
                  updates: {_db.albums},
                );
                applied++;
              }
            }
        }
      } catch (e) {
        debugPrint('[AutoFix] Error applying fix for track ${fix.trackId}: $e');
      }
    }

    return applied;
  }

  // ---------------------------------------------------------------------------
  // MusicBrainz lookup
  // ---------------------------------------------------------------------------

  Future<List<MetadataFix>> _lookupTrack(Map<String, dynamic> track) async {
    final fixes = <MetadataFix>[];

    // Build a search query from track metadata
    final query = StringBuffer();
    query.write('recording:"${_escape(track['title'])}"');
    if (track['artist_name'] != null) {
      query.write(' AND artist:"${_escape(track['artist_name']!)}"');
    }
    if (track['album_title'] != null) {
      query.write(' AND release:"${_escape(track['album_title']!)}"');
    }

    await _rateLimit();

    try {
      final url = '$_baseUrl/recording/?query=${Uri.encodeQueryComponent(query.toString())}'
          '&fmt=json&limit=3';

      final response = await _http.get(
        Uri.parse(url),
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode != 200) return fixes;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final recordings = json['recordings'] as List<dynamic>? ?? [];

      if (recordings.isEmpty) return fixes;

      // Take the best match
      final best = recordings.first as Map<String, dynamic>;
      final score = best['score'] as int? ?? 0;
      if (score < 80) return fixes; // Too low confidence

      final confidence = score / 100.0;

      // MusicBrainz recording ID
      final mbId = best['id'] as String?;
      if (mbId != null && (track['musicbrainz_recording_id'] == null || track['musicbrainz_recording_id']!.isEmpty)) {
        fixes.add(MetadataFix(
          trackId: track['id'],
          field: 'musicbrainz_recording_id',
          oldValue: track['musicbrainz_recording_id'],
          newValue: mbId,
          confidence: confidence,
        ));
      }

      // Extract genre from tags
      final tags = best['tags'] as List<dynamic>? ?? [];
      if (tags.isNotEmpty) {
        // Get album to check if genre is missing
        Album? album;
        if (track['album_id'] != null) {
          album = await _db.albumRepo.byId(track['album_id']!);
        }

        if (album != null && (album.genre == null || album.genre!.isEmpty)) {
          final genreTag = tags.first as Map<String, dynamic>;
          final genreName = genreTag['name'] as String?;
          if (genreName != null) {
            fixes.add(MetadataFix(
              trackId: track['id'],
              field: 'genre',
              oldValue: album.genre,
              newValue: _capitalizeGenre(genreName),
              confidence: confidence * 0.8, // lower confidence for genre
            ));
          }
        }
      }

      // Extract year from first release
      final releases = best['releases'] as List<dynamic>? ?? [];
      if (releases.isNotEmpty) {
        Album? album;
        if (track['album_id'] != null) {
          album = await _db.albumRepo.byId(track['album_id']!);
        }

        if (album != null && album.year == null) {
          final release = releases.first as Map<String, dynamic>;
          final date = release['date'] as String?;
          if (date != null && date.length >= 4) {
            final year = date.substring(0, 4);
            fixes.add(MetadataFix(
              trackId: track['id'],
              field: 'year',
              oldValue: null,
              newValue: year,
              confidence: confidence * 0.9,
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('[AutoFix] MusicBrainz lookup error: $e');
    }

    return fixes;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _escape(String s) => s.replaceAll('"', '\\"');

  String _capitalizeGenre(String genre) {
    return genre.split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1);
    }).join(' ');
  }

  Future<void> _rateLimit() async {
    final elapsed = DateTime.now().difference(_lastRequest);
    if (elapsed < _minInterval) {
      await Future.delayed(_minInterval - elapsed);
    }
    _lastRequest = DateTime.now();
  }

  void dispose() {
    _http.close();
  }
}
