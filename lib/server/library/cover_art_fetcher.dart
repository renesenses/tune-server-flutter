import 'dart:convert';

import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// T7.3 — CoverArtFetcher
// Requête iTunes Search API → URL pochette haute résolution.
// Miroir de CoverArtFetcher.swift (iOS)
//
// iTunes Search API : gratuit, sans clé, 20 req/min par IP.
// Retourne l'URL 100x100 → remplacée par 600x600 (= même pattern iOS).
// ---------------------------------------------------------------------------

class CoverArtResult {
  final String artworkUrl;    // URL 600x600
  final String? artistName;
  final String? albumTitle;
  final int? releaseYear;

  const CoverArtResult({
    required this.artworkUrl,
    this.artistName,
    this.albumTitle,
    this.releaseYear,
  });
}

class CoverArtFetcher {
  static const _iTunesBase = 'https://itunes.apple.com/search';
  static const _musicBrainzBase =
      'https://coverartarchive.org/release';

  final http.Client _http;

  CoverArtFetcher({http.Client? client}) : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Recherche par artiste + album
  // ---------------------------------------------------------------------------

  /// Cherche la pochette pour un album.
  /// Essaie iTunes Search en premier, puis MusicBrainz/CAA en fallback.
  Future<CoverArtResult?> fetchForAlbum({
    required String album,
    String? artist,
  }) async {
    // 1. iTunes Search API
    final iTunesResult = await _searchITunes(album: album, artist: artist);
    if (iTunesResult != null) return iTunesResult;

    // 2. MusicBrainz / Cover Art Archive (sans clé)
    if (artist != null) {
      return _searchMusicBrainz(album: album, artist: artist);
    }
    return null;
  }

  /// Cherche la pochette pour un artiste (image artiste).
  Future<String?> fetchArtistImage(String artist) async {
    try {
      final uri = Uri.parse(_iTunesBase).replace(queryParameters: {
        'term': artist,
        'media': 'music',
        'entity': 'musicArtist',
        'limit': '1',
      });
      final response =
          await _http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List?)?.cast<Map<String, dynamic>>();
      if (results == null || results.isEmpty) return null;

      final url = results.first['artistLinkUrl'] as String?;
      return url;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // iTunes Search
  // ---------------------------------------------------------------------------

  Future<CoverArtResult?> _searchITunes({
    required String album,
    String? artist,
  }) async {
    try {
      final term = artist != null ? '$artist $album' : album;
      final uri = Uri.parse(_iTunesBase).replace(queryParameters: {
        'term': term,
        'media': 'music',
        'entity': 'album',
        'limit': '5',
      });

      final response =
          await _http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List?)?.cast<Map<String, dynamic>>();
      if (results == null || results.isEmpty) return null;

      // Trouve le meilleur résultat (correspondance exacte album si possible)
      final best = _bestMatch(results, album: album, artist: artist);
      if (best == null) return null;

      final artworkUrl100 = best['artworkUrl100'] as String?;
      if (artworkUrl100 == null) return null;

      // iOS pattern : remplace 100x100 → 600x600
      final artworkUrl600 = artworkUrl100
          .replaceFirst('100x100bb', '600x600bb')
          .replaceFirst('100x100', '600x600');

      final releaseDateStr = best['releaseDate'] as String?;
      final year = releaseDateStr != null
          ? int.tryParse(releaseDateStr.substring(0, 4))
          : null;

      return CoverArtResult(
        artworkUrl: artworkUrl600,
        artistName: best['artistName'] as String?,
        albumTitle: best['collectionName'] as String?,
        releaseYear: year,
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _bestMatch(
    List<Map<String, dynamic>> results, {
    required String album,
    String? artist,
  }) {
    if (results.isEmpty) return null;

    final albumLower = album.toLowerCase();
    final artistLower = artist?.toLowerCase();

    // Correspondance exacte album + artiste
    if (artistLower != null) {
      final exact = results.firstWhere(
        (r) =>
            (r['collectionName'] as String?)?.toLowerCase() == albumLower &&
            (r['artistName'] as String?)?.toLowerCase() == artistLower,
        orElse: () => {},
      );
      if (exact.isNotEmpty) return exact;
    }

    // Correspondance album seul
    final albumMatch = results.firstWhere(
      (r) =>
          (r['collectionName'] as String?)?.toLowerCase() == albumLower,
      orElse: () => {},
    );
    if (albumMatch.isNotEmpty) return albumMatch;

    return results.first;
  }

  // ---------------------------------------------------------------------------
  // MusicBrainz / Cover Art Archive (fallback)
  // ---------------------------------------------------------------------------

  Future<CoverArtResult?> _searchMusicBrainz({
    required String album,
    required String artist,
  }) async {
    try {
      // 1. Cherche le MBID de l'album
      final searchUri = Uri.parse(
              'https://musicbrainz.org/ws/2/release/')
          .replace(queryParameters: {
        'query': 'release:"$album" AND artist:"$artist"',
        'limit': '1',
        'fmt': 'json',
      });

      final mbResp = await _http.get(searchUri, headers: {
        'User-Agent': 'TuneServer/1.0 (flutter)',
      }).timeout(const Duration(seconds: 8));

      if (mbResp.statusCode != 200) return null;

      final mbData = jsonDecode(mbResp.body) as Map<String, dynamic>;
      final releases =
          (mbData['releases'] as List?)?.cast<Map<String, dynamic>>();
      if (releases == null || releases.isEmpty) return null;

      final mbid = releases.first['id'] as String?;
      if (mbid == null) return null;

      // 2. Récupère la pochette depuis Cover Art Archive
      final caUri =
          Uri.parse('$_musicBrainzBase/$mbid/front-500');
      final caResp = await _http
          .get(caUri)
          .timeout(const Duration(seconds: 8));

      if (caResp.statusCode == 200 || caResp.statusCode == 307) {
        final artUrl = caResp.headers['location'] ?? caUri.toString();
        return CoverArtResult(artworkUrl: artUrl);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  void close() => _http.close();
}
