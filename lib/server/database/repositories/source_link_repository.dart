import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// SourceLinkRepository
// Track-to-streaming-service mapping (upsert with confidence,
// get_by_track, count_by_service).
// Miroir de source_link_repository.rs (Rust)
// ---------------------------------------------------------------------------

class SourceLinkRepository {
  final TuneDatabase _db;

  const SourceLinkRepository(this._db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Upsert a track-to-service link. Replaces on conflict (trackId, service).
  Future<void> upsert({
    required int trackId,
    required String service,
    required String serviceTrackId,
    double confidence = 1.0,
    String? matchMethod,
  }) async {
    final now = DateTime.now().toIso8601String();
    final existing = await getByTrackAndService(trackId, service);

    if (existing != null) {
      await (_db.update(_db.trackSourceLinks)
            ..where((l) => l.id.equals(existing.id)))
          .write(TrackSourceLinksCompanion(
        serviceTrackId: Value(serviceTrackId),
        confidence: Value(confidence),
        matchMethod: Value(matchMethod),
        linkedAt: Value(now),
      ));
    } else {
      await _db.into(_db.trackSourceLinks).insert(
        TrackSourceLinksCompanion.insert(
          trackId: trackId,
          service: service,
          serviceTrackId: serviceTrackId,
          confidence: Value(confidence),
          matchMethod: Value(matchMethod),
          linkedAt: now,
        ),
      );
    }
  }

  /// Get link for a specific track + service.
  Future<TrackSourceLink?> getByTrackAndService(int trackId, String service) =>
      (_db.select(_db.trackSourceLinks)
            ..where((l) => l.trackId.equals(trackId) & l.service.equals(service)))
          .getSingleOrNull();

  /// Get all links for a track.
  Future<List<TrackSourceLink>> getByTrack(int trackId) =>
      (_db.select(_db.trackSourceLinks)
            ..where((l) => l.trackId.equals(trackId))
            ..orderBy([(l) => OrderingTerm(expression: l.confidence, mode: OrderingMode.desc)]))
          .get();

  /// Delete a link.
  Future<int> delete(int trackId, String service) =>
      (_db.delete(_db.trackSourceLinks)
            ..where((l) => l.trackId.equals(trackId) & l.service.equals(service)))
          .go();

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Count links per service.
  Future<Map<String, int>> countByService() async {
    final rows = await _db.customSelect(
      'SELECT service, COUNT(*) AS count '
      'FROM track_source_links '
      'GROUP BY service '
      'ORDER BY count DESC',
      readsFrom: {_db.trackSourceLinks},
    ).get();

    return {
      for (final row in rows)
        row.read<String>('service'): row.read<int>('count'),
    };
  }

  /// Total link count.
  Future<int> count() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM track_source_links')
        .getSingle();
    return result.read<int>('c');
  }

  /// Get all links for a service (e.g. for export).
  Future<List<TrackSourceLink>> forService(String service, {int limit = 10000}) =>
      (_db.select(_db.trackSourceLinks)
            ..where((l) => l.service.equals(service))
            ..limit(limit))
          .get();
}
