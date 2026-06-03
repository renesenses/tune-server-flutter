import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// RatingRepository
// Album ratings (1-5 stars per album+profile, UPSERT, top rated, import/export)
// Miroir de rating_repository.rs (Rust)
// ---------------------------------------------------------------------------

class RatingRepository {
  final TuneDatabase _db;

  const RatingRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Get rating for a specific album + profile.
  Future<AlbumRating?> get(int albumId, String profileId) =>
      (_db.select(_db.albumRatings)
            ..where((r) => r.albumId.equals(albumId) & r.profileId.equals(profileId)))
          .getSingleOrNull();

  /// Upsert a rating (insert or update on conflict).
  Future<void> upsert({
    required int albumId,
    required String profileId,
    required int rating,
    String? note,
  }) async {
    final existing = await get(albumId, profileId);
    final now = DateTime.now().toIso8601String();

    if (existing != null) {
      await (_db.update(_db.albumRatings)
            ..where((r) => r.id.equals(existing.id)))
          .write(AlbumRatingsCompanion(
        rating: Value(rating.clamp(1, 5)),
        note: Value(note),
        createdAt: Value(now),
      ));
    } else {
      await _db.into(_db.albumRatings).insert(AlbumRatingsCompanion.insert(
        albumId: albumId,
        profileId: profileId,
        rating: rating.clamp(1, 5),
        note: Value(note),
        createdAt: now,
      ));
    }
  }

  /// Delete a rating.
  Future<int> delete(int albumId, String profileId) =>
      (_db.delete(_db.albumRatings)
            ..where((r) => r.albumId.equals(albumId) & r.profileId.equals(profileId)))
          .go();

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// All ratings for a profile, ordered by rating descending.
  Future<List<AlbumRating>> forProfile(String profileId, {int limit = 500}) =>
      (_db.select(_db.albumRatings)
            ..where((r) => r.profileId.equals(profileId))
            ..orderBy([
              (r) => OrderingTerm(expression: r.rating, mode: OrderingMode.desc),
              (r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc),
            ])
            ..limit(limit))
          .get();

  /// Top rated albums (average rating across all profiles).
  Future<List<Map<String, dynamic>>> topRated({int limit = 50}) async {
    final rows = await _db.customSelect(
      'SELECT album_id, AVG(rating) AS avg_rating, COUNT(*) AS rating_count '
      'FROM album_ratings '
      'GROUP BY album_id '
      'HAVING rating_count > 0 '
      'ORDER BY avg_rating DESC, rating_count DESC '
      'LIMIT ?',
      variables: [Variable(limit)],
      readsFrom: {_db.albumRatings},
    ).get();

    return rows.map((row) => {
      'album_id': row.read<int>('album_id'),
      'avg_rating': row.read<double>('avg_rating'),
      'rating_count': row.read<int>('rating_count'),
    }).toList();
  }

  /// Count all ratings.
  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM album_ratings')
        .getSingle();
    return result.read<int>('c');
  }

  // ---------------------------------------------------------------------------
  // Import / Export
  // ---------------------------------------------------------------------------

  /// Export all ratings as a list of maps (for backup/sync).
  Future<List<Map<String, dynamic>>> exportAll() async {
    final ratings = await (_db.select(_db.albumRatings)).get();
    return ratings.map((r) => {
      'album_id': r.albumId,
      'profile_id': r.profileId,
      'rating': r.rating,
      'note': r.note,
      'created_at': r.createdAt,
    }).toList();
  }

  /// Import ratings from a list of maps (upsert semantics).
  Future<int> importAll(List<Map<String, dynamic>> data) async {
    int imported = 0;
    for (final entry in data) {
      final albumId = entry['album_id'] as int?;
      final profileId = entry['profile_id'] as String?;
      final rating = entry['rating'] as int?;
      if (albumId == null || profileId == null || rating == null) continue;

      await upsert(
        albumId: albumId,
        profileId: profileId,
        rating: rating,
        note: entry['note'] as String?,
      );
      imported++;
    }
    return imported;
  }
}
