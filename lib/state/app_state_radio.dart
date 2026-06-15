part of 'app_state.dart';

// Extension AppState — radios :
// - playRadio (remote API ou engine local + metadata polling)
// - CRUD (add/delete/update/toggleFavorite)
// - importM3UContent
// - saveRadioFavorite (remote ou DB)

extension AppStateRadio on AppState {

  // ---------------------------------------------------------------------------
  // Radio
  // ---------------------------------------------------------------------------

  Future<void> playRadio(Radio radio, {int? zoneId}) async {
    final id = zoneId ?? zoneState.currentZoneId;
    if (id == null) return;

    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.playRadio(radio.id, id);
      await refreshZonesRemote();
      return;
    }

    final httpUrl = radio.streamUrl.replaceFirst('https://', 'http://');
    final instance = engine.zoneManager.zone(id);
    if (instance == null) return;

    final track = Track(
      id: 0,
      title: radio.name,
      filePath: httpUrl,
      source: Source.radio.rawValue,
      sourceId: radio.id.toString(),
      favorite: false,
    );

    instance.queue.load([track], startIndex: 0);
    await instance.player.play();

    RadioMetadataService.instance.startPolling(
      stationName: radio.name,
      streamUrl: httpUrl,
    );
  }

  // ---------------------------------------------------------------------------
  // Radio — CRUD
  // ---------------------------------------------------------------------------

  Future<void> addRadio({
    required String name,
    required String streamUrl,
    String? logoUrl,
    String? genre,
  }) async {
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.createRadio(
        name: name,
        url: streamUrl,
        logoUrl: logoUrl,
        genre: genre,
      );
      await _refreshRadiosRemote();
      return;
    }
    await engine.db.radioRepo.insert(RadiosCompanion.insert(
      name: name,
      streamUrl: streamUrl,
      logoUrl: Value(logoUrl),
      genre: Value(genre),
    ));
    await _refreshRadios();
  }

  Future<void> deleteRadio(int id) async {
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.deleteRadio(id);
      await _refreshRadiosRemote();
      return;
    }
    await engine.db.radioRepo.delete(id);
    await _refreshRadios();
  }

  Future<void> updateRadio({
    required int id,
    required String name,
    required String streamUrl,
    String? logoUrl,
    String? genre,
  }) async {
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.updateRadio(id,
        name: name,
        url: streamUrl,
        logoUrl: logoUrl,
        genre: genre,
      );
      await _refreshRadiosRemote();
      return;
    }
    await (engine.db.update(engine.db.radios)
          ..where((r) => r.id.equals(id)))
        .write(RadiosCompanion(
      name: Value(name),
      streamUrl: Value(streamUrl),
      logoUrl: Value(logoUrl),
      genre: Value(genre),
    ));
    await _refreshRadios();
  }

  Future<void> toggleRadioFavorite(Radio radio) async {
    if (isRemoteMode && _apiClient != null) {
      await _apiClient!.toggleRadioFavorite(radio.id,
          favorite: !radio.favorite);
      await _refreshRadiosRemote();
      return;
    }
    await engine.db.radioRepo.setFavorite(radio.id, favorite: !radio.favorite);
    await _refreshRadios();
  }

  /// Importe des stations depuis du contenu M3U (texte brut).
  Future<int> importM3UContent(String content) async {
    if (isRemoteMode && _apiClient != null) {
      final stations = _parseM3UToStations(content);
      if (stations.isEmpty) return 0;
      final result = await _apiClient!.importRadioStations(stations);
      await _refreshRadiosRemote();
      return result['imported'] as int? ?? 0;
    }
    final dir = await getTemporaryDirectory();
    final tmp = File(
        '${dir.path}/import_${DateTime.now().millisecondsSinceEpoch}.m3u');
    await tmp.writeAsString(content);
    final added = await engine.db.radioRepo.importM3U(tmp.path);
    try { await tmp.delete(); } catch (_) {}
    await _refreshRadios();
    return added;
  }

  /// Parse M3U content into a list of station maps for the remote API.
  List<Map<String, dynamic>> _parseM3UToStations(String content) {
    final lines = content.split('\n').map((l) => l.trim()).toList();
    final stations = <Map<String, dynamic>>[];
    String? pendingName;
    for (final line in lines) {
      if (line.startsWith('#EXTINF:')) {
        final comma = line.indexOf(',');
        if (comma != -1) {
          pendingName = line.substring(comma + 1).trim();
        }
      } else if (line.isNotEmpty && !line.startsWith('#')) {
        stations.add({
          'name': pendingName ?? line,
          'url': line,
        });
        pendingName = null;
      }
    }
    return stations;
  }

  /// Sauvegarde le morceau en cours dans les favoris radio.
  Future<void> saveRadioFavorite({
    required String title,
    String? artist,
    required Radio radio,
  }) async {
    if (isRemoteMode && _apiClient != null) {
      try {
        await _apiClient!.saveRadioFavorite({
          'title': title,
          'artist': artist ?? '',
          'station_name': radio.name,
          'stream_url': radio.streamUrl,
        });
      } catch (e) {
        debugPrint('[Remote] saveRadioFavorite error: $e');
      }
      return;
    }
    await engine.db.radioRepo.insertFavorite(
      RadioFavoritesCompanion.insert(
        title: title,
        artist: artist ?? '',
        stationName: radio.name,
        streamUrl: radio.streamUrl,
        savedAt: DateTime.now().toIso8601String(),
      ),
    );
  }
}
