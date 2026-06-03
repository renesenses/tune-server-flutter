import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../database/database.dart';

// ---------------------------------------------------------------------------
// AutoDJ
// Generate queue based on seed track's genre/year, fallback to random.
// Miroir de auto_dj.rs (Rust)
// ---------------------------------------------------------------------------

class AutoDJ {
  final TuneDatabase _db;
  final Random _random = Random();

  /// How many tracks ahead to keep in the auto-generated queue.
  int lookahead;

  /// Range in years around the seed track's album year (e.g. +/- 5).
  int yearRange;

  AutoDJ(this._db, {this.lookahead = 20, this.yearRange = 5});

  // ---------------------------------------------------------------------------
  // Generate queue from a seed track
  // ---------------------------------------------------------------------------

  /// Generates a list of tracks similar to [seed] by genre and year.
  /// Falls back to random if not enough genre/year matches are found.
  Future<List<Track>> generate(Track seed, {int? count}) async {
    final targetCount = count ?? lookahead;
    final results = <Track>[];

    // 1. Try genre + year match
    final genreTracks = await _byGenreAndYear(seed, limit: targetCount);
    results.addAll(genreTracks);

    // 2. If not enough, try genre only
    if (results.length < targetCount) {
      final genreOnly = await _byGenre(seed, limit: targetCount - results.length);
      final existingIds = results.map((t) => t.id).toSet();
      for (final t in genreOnly) {
        if (!existingIds.contains(t.id)) {
          results.add(t);
          existingIds.add(t.id);
        }
      }
    }

    // 3. Fallback to random
    if (results.length < targetCount) {
      final randomTracks = await _db.trackRepo.random(
        limit: targetCount - results.length,
      );
      final existingIds = results.map((t) => t.id).toSet();
      for (final t in randomTracks) {
        if (!existingIds.contains(t.id)) {
          results.add(t);
        }
      }
    }

    // Remove the seed track itself
    results.removeWhere((t) => t.id == seed.id);

    // Shuffle for variety
    results.shuffle(_random);

    return results.take(targetCount).toList();
  }

  // ---------------------------------------------------------------------------
  // Internal queries
  // ---------------------------------------------------------------------------

  Future<List<Track>> _byGenreAndYear(Track seed, {int limit = 20}) async {
    // Get genre from the seed's album
    Album? album;
    if (seed.albumId != null) {
      album = await _db.albumRepo.byId(seed.albumId!);
    }

    if (album?.genre == null || album!.genre!.isEmpty) return [];

    final genre = album.genre!;
    final year = album.year;

    if (year == null) return _byGenre(seed, limit: limit);

    final minYear = year - yearRange;
    final maxYear = year + yearRange;

    final rows = await _db.customSelect(
      'SELECT t.* FROM tracks t '
      'INNER JOIN albums a ON t.album_id = a.id '
      'WHERE a.genre = ? AND a.year BETWEEN ? AND ? '
      'AND t.id != ? '
      'ORDER BY RANDOM() '
      'LIMIT ?',
      variables: [
        Variable(genre),
        Variable(minYear),
        Variable(maxYear),
        Variable(seed.id),
        Variable(limit),
      ],
      readsFrom: {_db.tracks, _db.albums},
    ).get();

    return Future.wait(rows.map((row) => _db.tracks.mapFromRow(row)));
  }

  Future<List<Track>> _byGenre(Track seed, {int limit = 20}) async {
    Album? album;
    if (seed.albumId != null) {
      album = await _db.albumRepo.byId(seed.albumId!);
    }

    if (album?.genre == null || album!.genre!.isEmpty) return [];

    final rows = await _db.customSelect(
      'SELECT t.* FROM tracks t '
      'INNER JOIN albums a ON t.album_id = a.id '
      'WHERE a.genre = ? AND t.id != ? '
      'ORDER BY RANDOM() '
      'LIMIT ?',
      variables: [
        Variable(album.genre!),
        Variable(seed.id),
        Variable(limit),
      ],
      readsFrom: {_db.tracks, _db.albums},
    ).get();

    return Future.wait(rows.map((row) => _db.tracks.mapFromRow(row)));
  }
}
