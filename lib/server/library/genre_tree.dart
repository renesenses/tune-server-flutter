import '../database/database.dart';

// ---------------------------------------------------------------------------
// GenreTree
// Build 2-level genre hierarchy from DB: 14 parent genres, 80+ children,
// "Other" bucket for unmapped genres.
// Miroir de genre_tree.rs (Rust)
// ---------------------------------------------------------------------------

/// A genre node in the hierarchy tree.
class GenreNode {
  final String name;
  final List<GenreNode> children;
  int albumCount;

  GenreNode({required this.name, List<GenreNode>? children, this.albumCount = 0})
      : children = children ?? [];

  int get totalAlbumCount =>
      albumCount + children.fold(0, (sum, c) => sum + c.totalAlbumCount);

  Map<String, dynamic> toJson() => {
        'name': name,
        'album_count': albumCount,
        'total_album_count': totalAlbumCount,
        'children': children.map((c) => c.toJson()).toList(),
      };
}

class GenreTree {
  GenreTree._();

  // ---------------------------------------------------------------------------
  // Parent genre → children mapping (14 parents, 80+ children)
  // ---------------------------------------------------------------------------

  static const Map<String, List<String>> _hierarchy = {
    'Rock': [
      'Alternative Rock', 'Classic Rock', 'Hard Rock', 'Indie Rock',
      'Progressive Rock', 'Punk Rock', 'Psychedelic Rock', 'Grunge',
      'Post-Rock', 'Garage Rock', 'Stoner Rock', 'Shoegaze',
      'Soft Rock', 'Southern Rock', 'Art Rock',
    ],
    'Pop': [
      'Synth-Pop', 'Indie Pop', 'Dream Pop', 'Electropop',
      'Dance Pop', 'Art Pop', 'Baroque Pop', 'Chamber Pop',
      'Power Pop', 'Twee Pop', 'K-Pop', 'J-Pop',
    ],
    'Jazz': [
      'Bebop', 'Cool Jazz', 'Free Jazz', 'Fusion',
      'Smooth Jazz', 'Swing', 'Bossa Nova', 'Latin Jazz',
      'Acid Jazz', 'Modal Jazz', 'Vocal Jazz', 'Big Band',
    ],
    'Classical': [
      'Baroque', 'Romantic', 'Contemporary Classical', 'Opera',
      'Chamber Music', 'Orchestral', 'Choral', 'Minimalism',
      'Avant-Garde', 'Impressionism',
    ],
    'Electronic': [
      'House', 'Techno', 'Ambient', 'Trance', 'Drum and Bass',
      'Dubstep', 'IDM', 'Downtempo', 'Trip-Hop', 'Synthwave',
      'Electronica', 'Breakbeat', 'Garage', 'Electro',
    ],
    'Hip-Hop': [
      'Rap', 'Trap', 'Boom Bap', 'Conscious Hip-Hop',
      'Gangsta Rap', 'Old School', 'Underground Hip-Hop',
      'Cloud Rap', 'Drill',
    ],
    'R&B': [
      'Soul', 'Funk', 'Neo-Soul', 'Contemporary R&B',
      'Quiet Storm', 'New Jack Swing', 'Motown',
    ],
    'Blues': [
      'Delta Blues', 'Chicago Blues', 'Electric Blues',
      'Country Blues', 'Blues Rock', 'Rhythm and Blues',
    ],
    'Country': [
      'Bluegrass', 'Americana', 'Country Rock', 'Alt-Country',
      'Outlaw Country', 'Honky Tonk', 'Country Pop',
    ],
    'Folk': [
      'Indie Folk', 'Contemporary Folk', 'Folk Rock',
      'Celtic', 'Traditional Folk', 'Neofolk',
    ],
    'Metal': [
      'Heavy Metal', 'Death Metal', 'Black Metal', 'Thrash Metal',
      'Doom Metal', 'Power Metal', 'Progressive Metal',
      'Symphonic Metal', 'Nu Metal', 'Metalcore',
    ],
    'Reggae': [
      'Dub', 'Dancehall', 'Ska', 'Roots Reggae', 'Rocksteady',
    ],
    'World': [
      'African', 'Latin', 'Asian', 'Middle Eastern',
      'Caribbean', 'Flamenco', 'Fado', 'Afrobeat',
    ],
    'Soundtrack': [
      'Film Score', 'Video Game Music', 'Musical Theatre',
      'Television', 'Anime',
    ],
  };

  /// Reverse lookup: child genre -> parent genre.
  static final Map<String, String> _childToParent = () {
    final map = <String, String>{};
    for (final entry in _hierarchy.entries) {
      for (final child in entry.value) {
        map[child.toLowerCase()] = entry.key;
      }
      // Parent maps to itself
      map[entry.key.toLowerCase()] = entry.key;
    }
    return map;
  }();

  // ---------------------------------------------------------------------------
  // Build tree from database
  // ---------------------------------------------------------------------------

  /// Build the full genre tree from album genres in the database.
  static Future<List<GenreNode>> build(TuneDatabase db) async {
    // Get all genres with album counts
    final rows = await db.customSelect(
      'SELECT genre, COUNT(*) AS count FROM albums '
      "WHERE genre IS NOT NULL AND genre != '' "
      'GROUP BY genre '
      'ORDER BY count DESC',
      readsFrom: {db.albums},
    ).get();

    // Build parent nodes
    final parentNodes = <String, GenreNode>{};
    final otherNode = GenreNode(name: 'Other');

    for (final parentName in _hierarchy.keys) {
      parentNodes[parentName] = GenreNode(name: parentName);
    }

    // Classify each genre
    for (final row in rows) {
      final genre = row.read<String>('genre');
      final count = row.read<int>('count');
      final genreLower = genre.toLowerCase();

      final parentName = _childToParent[genreLower];
      if (parentName != null) {
        final parent = parentNodes[parentName]!;

        // Check if this is the parent genre itself
        if (genreLower == parentName.toLowerCase()) {
          parent.albumCount += count;
        } else {
          // It's a child genre
          final existingChild = parent.children
              .where((c) => c.name.toLowerCase() == genreLower)
              .firstOrNull;
          if (existingChild != null) {
            existingChild.albumCount += count;
          } else {
            parent.children.add(GenreNode(name: genre, albumCount: count));
          }
        }
      } else {
        // Unmapped genre goes to "Other"
        otherNode.children.add(GenreNode(name: genre, albumCount: count));
      }
    }

    // Collect non-empty parent nodes
    final result = <GenreNode>[];
    for (final node in parentNodes.values) {
      if (node.totalAlbumCount > 0) {
        // Sort children by count descending
        node.children.sort((a, b) => b.albumCount.compareTo(a.albumCount));
        result.add(node);
      }
    }

    // Sort parents by total count descending
    result.sort((a, b) => b.totalAlbumCount.compareTo(a.totalAlbumCount));

    // Add "Other" if non-empty
    if (otherNode.totalAlbumCount > 0) {
      otherNode.children.sort((a, b) => b.albumCount.compareTo(a.albumCount));
      result.add(otherNode);
    }

    return result;
  }

  /// Returns the parent genre for a given genre string, or "Other" if unmapped.
  static String parentFor(String genre) {
    return _childToParent[genre.toLowerCase()] ?? 'Other';
  }

  /// Returns all known parent genre names.
  static List<String> get parentGenres => _hierarchy.keys.toList();
}
