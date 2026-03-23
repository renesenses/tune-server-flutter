import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'metadata_reader.dart';

// ---------------------------------------------------------------------------
// T7.2 — ArtworkManager
// Cache des pochettes sur disque + URL locale via HttpAudioStreamer.
// Miroir de ArtworkManager.swift (iOS)
//
// Stratégie :
//   1. Hash MD5 de la clé (filePath ou "artist-album") → nom de fichier cache
//   2. Extrait la pochette embarquée si absente du cache
//   3. Retourne le chemin local pour l'HttpAudioStreamer (serve cover)
// ---------------------------------------------------------------------------

class ArtworkManager {
  ArtworkManager._();
  static final ArtworkManager instance = ArtworkManager._();

  Directory? _cacheDir;
  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // Init
  // ---------------------------------------------------------------------------

  Future<void> initialize() async {
    if (_initialized) return;
    final support = await getApplicationSupportDirectory();
    _cacheDir = Directory(p.join(support.path, 'artwork_cache'));
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // Accès pochette
  // ---------------------------------------------------------------------------

  /// Retourne le chemin local de la pochette pour [filePath].
  /// Extrait et met en cache si nécessaire.
  Future<String?> coverPathForTrack(String filePath) async {
    await _ensureInit();
    final key = _md5Key(filePath);
    final cached = await _cachedPath(key);
    if (cached != null) return cached;

    // Extrait la pochette embarquée depuis le fichier audio
    final coverData = await MetadataReader.readCoverData(filePath);
    if (coverData == null || coverData.isEmpty) return null;

    return _writeToDisk(key, coverData);
  }

  /// Retourne le chemin d'une pochette déjà téléchargée par URL,
  /// ou télécharge et met en cache depuis [remoteUrl].
  Future<String?> coverPathForUrl(String remoteUrl) async {
    await _ensureInit();
    final key = _md5Key(remoteUrl);
    final cached = await _cachedPath(key);
    if (cached != null) return cached;

    try {
      final uri = Uri.parse(remoteUrl);
      // Téléchargement simple (pas de http.Client ici — évite la dépendance)
      final socket = await Socket.connect(uri.host, uri.port != 0 ? uri.port : 80)
          .timeout(const Duration(seconds: 5));

      // Utilise HttpClient de dart:io pour éviter une dépendance circulaire
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(remoteUrl));
      request.headers.add('User-Agent', 'TuneServer/1.0');
      final response = await request.close();
      if (response.statusCode != 200) {
        client.close();
        socket.destroy();
        return null;
      }

      final bytes = <int>[];
      await for (final chunk in response) {
        bytes.addAll(chunk);
      }
      client.close();
      socket.destroy();

      if (bytes.isEmpty) return null;
      return _writeToDisk(key, bytes);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Nettoyage
  // ---------------------------------------------------------------------------

  /// Supprime toutes les pochettes en cache.
  Future<void> clearCache() async {
    await _ensureInit();
    if (_cacheDir != null && await _cacheDir!.exists()) {
      await _cacheDir!.delete(recursive: true);
      await _cacheDir!.create();
    }
  }

  /// Supprime les pochettes orphelines (non référencées par la liste de clés).
  Future<void> cleanup(Set<String> activeFilePaths) async {
    await _ensureInit();
    if (_cacheDir == null) return;

    final activeKeys = activeFilePaths.map(_md5Key).toSet();
    final files = _cacheDir!.listSync();
    for (final file in files) {
      final name = p.basenameWithoutExtension(file.path);
      if (!activeKeys.contains(name)) {
        await file.delete();
      }
    }
  }

  /// Taille totale du cache en octets.
  Future<int> cacheSize() async {
    await _ensureInit();
    if (_cacheDir == null || !await _cacheDir!.exists()) return 0;
    int total = 0;
    await for (final entity in _cacheDir!.list()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  // ---------------------------------------------------------------------------
  // Helpers internes
  // ---------------------------------------------------------------------------

  Future<void> _ensureInit() async {
    if (!_initialized) await initialize();
  }

  Future<String?> _cachedPath(String key) async {
    for (final ext in ['.jpg', '.png', '.jpeg']) {
      final file = File(p.join(_cacheDir!.path, '$key$ext'));
      if (await file.exists()) return file.path;
    }
    return null;
  }

  Future<String?> _writeToDisk(String key, List<int> data) async {
    // Détecte le format par magic bytes
    final ext = _detectImageExtension(data);
    final file = File(p.join(_cacheDir!.path, '$key$ext'));
    await file.writeAsBytes(data);
    return file.path;
  }

  String _md5Key(String input) {
    final bytes = input.codeUnits;
    return md5.convert(bytes).toString();
  }

  String _detectImageExtension(List<int> data) {
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
    return '.jpg'; // défaut
  }
}
