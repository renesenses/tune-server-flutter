// Tests for GenreTree: parent genre lookup, hierarchy integrity,
// case insensitivity.
// Ported from tune-core/src/library/genre_tree.rs
//
// The build() tests require a TuneDatabase and are documented as integration
// tests to be enabled when an in-memory DB factory is available.
//
// Run with : flutter test test/server/genre_tree_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/server/library/genre_tree.dart';

void main() {
  group('GenreTree -- parentFor (child lookup)', () {
    test('maps child rock genres to Rock', () {
      expect(GenreTree.parentFor('Indie Rock'), 'Rock');
      expect(GenreTree.parentFor('Grunge'), 'Rock');
      expect(GenreTree.parentFor('Progressive Rock'), 'Rock');
    });

    test('maps child jazz genres to Jazz', () {
      expect(GenreTree.parentFor('Bebop'), 'Jazz');
      expect(GenreTree.parentFor('Fusion'), 'Jazz');
    });

    test('maps child electronic genres to Electronic', () {
      expect(GenreTree.parentFor('House'), 'Electronic');
      expect(GenreTree.parentFor('Ambient'), 'Electronic');
    });
  });

  group('GenreTree -- parentFor (top-level)', () {
    test('parent genre maps to itself', () {
      expect(GenreTree.parentFor('Jazz'), 'Jazz');
      expect(GenreTree.parentFor('Electronic'), 'Electronic');
      expect(GenreTree.parentFor('Rock'), 'Rock');
      expect(GenreTree.parentFor('Metal'), 'Metal');
    });
  });

  group('GenreTree -- parentFor (unknown)', () {
    test('unknown genre returns Other', () {
      expect(GenreTree.parentFor('Polka'), 'Other');
      expect(GenreTree.parentFor('Zydeco'), 'Other');
    });
  });

  group('GenreTree -- parentFor (case insensitive)', () {
    test('matches regardless of case', () {
      expect(GenreTree.parentFor('indie rock'), 'Rock');
      expect(GenreTree.parentFor('INDIE ROCK'), 'Rock');
      expect(GenreTree.parentFor('jazz'), 'Jazz');
      expect(GenreTree.parentFor('JAZZ'), 'Jazz');
      expect(GenreTree.parentFor('Bebop'), 'Jazz');
      expect(GenreTree.parentFor('bebop'), 'Jazz');
    });
  });

  group('GenreTree -- hierarchy integrity', () {
    test('no duplicate genres across hierarchy', () {
      final allGenres = <String>[];
      for (final parent in GenreTree.parentGenres) {
        allGenres.add(parent.toLowerCase());
      }
      // We can't easily access the children list from the public API,
      // but we can verify parent genres are unique.
      final uniqueParents = allGenres.toSet();
      expect(
        allGenres.length,
        uniqueParents.length,
        reason: 'duplicate parent genres in hierarchy',
      );
    });

    test('parentGenres returns all 14 categories', () {
      final parents = GenreTree.parentGenres;
      expect(parents.length, 14);
      expect(parents, contains('Rock'));
      expect(parents, contains('Jazz'));
      expect(parents, contains('Electronic'));
      expect(parents, contains('Classical'));
      expect(parents, contains('Hip-Hop'));
      expect(parents, contains('R&B'));
      expect(parents, contains('Pop'));
      expect(parents, contains('Folk'));
      expect(parents, contains('Blues'));
      expect(parents, contains('Country'));
      expect(parents, contains('Metal'));
      expect(parents, contains('Reggae'));
      expect(parents, contains('World'));
      expect(parents, contains('Soundtrack'));
    });
  });

  group('GenreNode -- totalAlbumCount', () {
    test('leaf node total equals its own count', () {
      final node = GenreNode(name: 'Rock', albumCount: 42);
      expect(node.totalAlbumCount, 42);
    });

    test('parent total includes children', () {
      final node = GenreNode(
        name: 'Rock',
        albumCount: 10,
        children: [
          GenreNode(name: 'Indie Rock', albumCount: 5),
          GenreNode(name: 'Grunge', albumCount: 3),
        ],
      );
      expect(node.totalAlbumCount, 18); // 10 + 5 + 3
    });

    test('empty node has zero total', () {
      final node = GenreNode(name: 'Empty');
      expect(node.totalAlbumCount, 0);
    });
  });

  group('GenreNode -- toJson', () {
    test('serializes correctly', () {
      final node = GenreNode(
        name: 'Jazz',
        albumCount: 15,
        children: [GenreNode(name: 'Bebop', albumCount: 3)],
      );
      final json = node.toJson();
      expect(json['name'], 'Jazz');
      expect(json['album_count'], 15);
      expect(json['total_album_count'], 18);
      expect((json['children'] as List).length, 1);
    });
  });

  // ---------------------------------------------------------------------------
  // Integration tests (require in-memory TuneDatabase)
  //
  // Mirrors the Rust test: genre_tree_empty_db
  //   build(db) on empty DB -> empty list
  //
  // Uncomment when TuneDatabase.inMemory() is available.
  // ---------------------------------------------------------------------------

  // group('GenreTree -- build (empty DB)', () {
  //   test('returns empty tree for empty database', () async {
  //     final db = TuneDatabase.inMemory();
  //     final tree = await GenreTree.build(db);
  //     expect(tree, isEmpty);
  //     await db.close();
  //   });
  // });
}
