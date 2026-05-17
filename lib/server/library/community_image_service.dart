import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// ---------------------------------------------------------------------------
// CommunityImageService
// Fetches and shares artist images via the mozaiklabs.fr community cache.
//
// Priority chain (matches Python server):
//   1. User-provided image (local override)
//   2. Discogs API
//   3. Community cache on mozaiklabs.fr
//   4. MusicBrainz
//   5. Wikipedia/Wikidata
//
// GET  https://mozaiklabs.fr/api/v1/artist-images/{artist_name}
//   → { "url": "https://...", "source": "discogs", "cached_at": "2026-..." }
//   → 404 if not found
//
// POST https://mozaiklabs.fr/api/v1/artist-images
//   body: { "artist_name": "Name", "image_url": "https://...", "source": "discogs" }
// ---------------------------------------------------------------------------

class CommunityImageService {
  static const _baseUrl = 'https://mozaiklabs.fr/api/v1/artist-images';
  static const _userAgent = 'TuneServer-Flutter/1.0';
  static const _timeout = Duration(seconds: 10);

  final http.Client _http;

  CommunityImageService({http.Client? client})
      : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Fetch from community cache
  // ---------------------------------------------------------------------------

  /// Checks the community cache for an artist image.
  /// Returns the local file path if found and downloaded, null otherwise.
  /// Never throws — community cache is optional.
  Future<String?> fetchArtistImage({
    required String artistName,
    required String cacheDir,
  }) async {
    if (artistName.isEmpty) return null;

    try {
      final encoded = Uri.encodeComponent(artistName);
      final uri = Uri.parse('$_baseUrl/$encoded');
      final response = await _http.get(uri, headers: {
        'User-Agent': _userAgent,
      }).timeout(_timeout);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final imageUrl = data['url'] as String?;
      if (imageUrl == null || imageUrl.isEmpty) return null;

      // Download the image
      final imgResponse = await _http.get(
        Uri.parse(imageUrl),
        headers: {'User-Agent': _userAgent},
      ).timeout(_timeout);

      if (imgResponse.statusCode != 200) return null;
      final imgData = imgResponse.bodyBytes;
      if (imgData.length < 1000) return null; // Too small, likely a placeholder

      // Save to local cache
      final hash = md5.convert(artistName.codeUnits).toString();
      final ext = _detectExtension(imgData);
      final cachePath = p.join(cacheDir, 'community_$hash$ext');
      final dir = Directory(cacheDir);
      if (!await dir.exists()) await dir.create(recursive: true);
      await File(cachePath).writeAsBytes(imgData);

      debugPrint('[CommunityImage] Cached artist image for "$artistName"');
      return cachePath;
    } catch (e) {
      debugPrint('[CommunityImage] Fetch failed for "$artistName": $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Share to community cache
  // ---------------------------------------------------------------------------

  /// Uploads a successfully fetched artist image URL to the community cache.
  /// Fire-and-forget — never blocks, never throws.
  Future<void> shareArtistImage({
    required String artistName,
    required String imageUrl,
    required String source,
  }) async {
    if (artistName.isEmpty || imageUrl.isEmpty) return;

    try {
      final uri = Uri.parse(_baseUrl);
      final body = jsonEncode({
        'artist_name': artistName,
        'image_url': imageUrl,
        'source': source,
      });
      final response = await _http.post(
        uri,
        headers: {
          'User-Agent': _userAgent,
          'Content-Type': 'application/json',
        },
        body: body,
      ).timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('[CommunityImage] Shared "$artistName" image ($source)');
      } else {
        debugPrint(
            '[CommunityImage] Share failed for "$artistName": ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('[CommunityImage] Share error for "$artistName": $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _detectExtension(List<int> data) {
    if (data.length >= 3 &&
        data[0] == 0xFF &&
        data[1] == 0xD8 &&
        data[2] == 0xFF) {
      return '.jpg';
    }
    if (data.length >= 8 &&
        data[0] == 0x89 &&
        data[1] == 0x50 &&
        data[2] == 0x4E &&
        data[3] == 0x47) {
      return '.png';
    }
    return '.jpg';
  }

  void close() => _http.close();
}
