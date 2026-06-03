import 'package:drift/drift.dart';

import '../database.dart';

// ---------------------------------------------------------------------------
// TagRepository
// Tags with colors, tag/untag items (albums/tracks/artists),
// tags_for_item, items_by_tag.
// Miroir de tag_repository.rs (Rust)
// ---------------------------------------------------------------------------

class TagRepository {
  final TuneDatabase _db;

  const TagRepository(this._db);

  // ---------------------------------------------------------------------------
  // Tag CRUD
  // ---------------------------------------------------------------------------

  Future<Tag?> byId(int id) =>
      (_db.select(_db.tags)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Tag?> byName(String name) =>
      (_db.select(_db.tags)..where((t) => t.name.equals(name)))
          .getSingleOrNull();

  Future<int> create({required String name, String? color}) =>
      _db.into(_db.tags).insert(TagsCompanion.insert(
        name: name,
        color: Value(color),
      ));

  Future<bool> update(Tag tag) => _db.update(_db.tags).replace(tag);

  Future<int> delete(int tagId) async {
    // Also remove all item_tags references
    await (_db.delete(_db.itemTags)..where((it) => it.tagId.equals(tagId))).go();
    return (_db.delete(_db.tags)..where((t) => t.id.equals(tagId))).go();
  }

  Future<List<Tag>> allTags() =>
      (_db.select(_db.tags)
            ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)]))
          .get();

  // ---------------------------------------------------------------------------
  // Tagging items
  // ---------------------------------------------------------------------------

  /// Tag an item (album/track/artist). No-op if already tagged.
  Future<void> tagItem({
    required int tagId,
    required String itemType,
    required String itemId,
  }) async {
    final existing = await (_db.select(_db.itemTags)
          ..where((it) =>
              it.tagId.equals(tagId) &
              it.itemType.equals(itemType) &
              it.itemId.equals(itemId)))
        .getSingleOrNull();

    if (existing != null) return;

    await _db.into(_db.itemTags).insert(ItemTagsCompanion.insert(
      tagId: tagId,
      itemType: itemType,
      itemId: itemId,
    ));
  }

  /// Remove a tag from an item.
  Future<int> untagItem({
    required int tagId,
    required String itemType,
    required String itemId,
  }) =>
      (_db.delete(_db.itemTags)
            ..where((it) =>
                it.tagId.equals(tagId) &
                it.itemType.equals(itemType) &
                it.itemId.equals(itemId)))
          .go();

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Get all tags for a specific item.
  Future<List<Tag>> tagsForItem({
    required String itemType,
    required String itemId,
  }) async {
    final rows = await _db.customSelect(
      'SELECT t.* FROM tags t '
      'INNER JOIN item_tags it ON it.tag_id = t.id '
      'WHERE it.item_type = ? AND it.item_id = ? '
      'ORDER BY t.name',
      variables: [Variable(itemType), Variable(itemId)],
      readsFrom: {_db.tags, _db.itemTags},
    ).get();

    return Future.wait(rows.map((row) => _db.tags.mapFromRow(row)));
  }

  /// Get all item IDs for a given tag and item type.
  Future<List<String>> itemsByTag({
    required int tagId,
    required String itemType,
  }) async {
    final rows = await (_db.select(_db.itemTags)
          ..where((it) => it.tagId.equals(tagId) & it.itemType.equals(itemType)))
        .get();
    return rows.map((it) => it.itemId).toList();
  }

  /// Count items for a specific tag.
  Future<int> countItems(int tagId) async {
    final result = await _db.customSelect(
      'SELECT COUNT(*) AS c FROM item_tags WHERE tag_id = ?',
      variables: [Variable(tagId)],
    ).getSingle();
    return result.read<int>('c');
  }
}
