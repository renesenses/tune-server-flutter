import 'package:flutter/foundation.dart';

import '../models/domain_models.dart';
import '../server/database/database.dart';
import '../server/server_engine.dart';
import '../server/streaming/streaming_service.dart';

// ---------------------------------------------------------------------------
// T9.3 — LibraryState
// ChangeNotifier pour la bibliothèque locale et les services streaming.
// Miroir de LibraryState.swift (iOS / @Observable)
// ---------------------------------------------------------------------------

/// Sort field for album list.
enum AlbumSortField {
  title,
  artist,
  year,
  originalYear,
  addedDate,
}

class LibraryState extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // Albums
  // ---------------------------------------------------------------------------

  List<Album> _albums = [];
  List<Album> get albums => _sortedAlbums;

  List<Album> _recentAlbums = [];
  List<Album> get recentAlbums => List.unmodifiable(_recentAlbums);

  void setAlbums(List<Album> albums) {
    _albums = albums;
    notifyListeners();
  }

  void setRecentAlbums(List<Album> albums) {
    _recentAlbums = albums;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Album sort
  // ---------------------------------------------------------------------------

  AlbumSortField _albumSortField = AlbumSortField.title;
  AlbumSortField get albumSortField => _albumSortField;

  // Ascending = A→Z / chronological (oldest first) / oldest added first.
  // Descending reverses it (Z→A / newest first). Defaults to ascending so the
  // year sorts read chronologically.
  bool _albumSortAscending = true;
  bool get albumSortAscending => _albumSortAscending;

  void setAlbumSort(AlbumSortField field) {
    if (_albumSortField == field) return;
    _albumSortField = field;
    notifyListeners();
  }

  void setAlbumSortAscending(bool ascending) {
    if (_albumSortAscending == ascending) return;
    _albumSortAscending = ascending;
    notifyListeners();
  }

  void toggleAlbumSortDirection() {
    _albumSortAscending = !_albumSortAscending;
    notifyListeners();
  }

  List<Album> get _sortedAlbums {
    final sorted = List<Album>.from(_albums);
    // Compare in ascending order; reverse below for descending.
    switch (_albumSortField) {
      case AlbumSortField.title:
        sorted.sort((a, b) => (a.title).compareTo(b.title));
      case AlbumSortField.artist:
        sorted.sort((a, b) =>
            (a.artistName ?? '').compareTo(b.artistName ?? ''));
      case AlbumSortField.year:
        sorted.sort((a, b) => (a.year ?? 0).compareTo(b.year ?? 0));
      case AlbumSortField.originalYear:
        sorted.sort((a, b) =>
            (a.originalYear ?? a.year ?? 0)
                .compareTo(b.originalYear ?? b.year ?? 0));
      case AlbumSortField.addedDate:
        sorted.sort((a, b) => a.id.compareTo(b.id)); // higher ID = added later
    }
    return _albumSortAscending ? sorted : sorted.reversed.toList();
  }

  // ---------------------------------------------------------------------------
  // Album audio info (format, sample rate, quality — derived from tracks)
  // ---------------------------------------------------------------------------

  Map<int, AlbumAudioInfo> _albumAudioInfo = {};
  Map<int, AlbumAudioInfo> get albumAudioInfo => _albumAudioInfo;

  void setAlbumAudioInfo(Map<int, AlbumAudioInfo> info) {
    _albumAudioInfo = info;
    notifyListeners();
  }

  /// Convenience: get audio info for a specific album.
  AlbumAudioInfo? audioInfoFor(int albumId) => _albumAudioInfo[albumId];

  // ---------------------------------------------------------------------------
  // Album filters
  // ---------------------------------------------------------------------------

  AudioQuality? _selectedQuality;
  String? _selectedFormat;
  int? _selectedMinSampleRate;

  AudioQuality? get selectedQuality => _selectedQuality;
  String? get selectedFormat => _selectedFormat;
  int? get selectedMinSampleRate => _selectedMinSampleRate;

  void setQualityFilter(AudioQuality? quality) {
    _selectedQuality = (_selectedQuality == quality) ? null : quality;
    notifyListeners();
  }

  void setFormatFilter(String? format) {
    _selectedFormat = (_selectedFormat == format) ? null : format;
    notifyListeners();
  }

  void setSampleRateFilter(int? minRate) {
    _selectedMinSampleRate = (_selectedMinSampleRate == minRate) ? null : minRate;
    notifyListeners();
  }

  void clearFilters() {
    _selectedQuality = null;
    _selectedFormat = null;
    _selectedMinSampleRate = null;
    notifyListeners();
  }

  bool get hasActiveFilters =>
      _selectedQuality != null ||
      _selectedFormat != null ||
      _selectedMinSampleRate != null;

  /// Returns albums filtered by current quality/format/sampleRate filters.
  List<Album> get filteredAlbums {
    if (!hasActiveFilters) return albums;
    return _sortedAlbums.where((album) {
      final info = _albumAudioInfo[album.id];
      if (info == null) return false;

      if (_selectedQuality != null && info.quality != _selectedQuality) {
        return false;
      }
      if (_selectedFormat != null &&
          info.format?.toUpperCase() != _selectedFormat) {
        return false;
      }
      if (_selectedMinSampleRate != null) {
        if (info.sampleRate == null ||
            info.sampleRate! < _selectedMinSampleRate!) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Available formats derived from album audio info.
  List<String> get availableFormats {
    final formats = <String>{};
    for (final info in _albumAudioInfo.values) {
      if (info.format != null && info.format!.isNotEmpty) {
        formats.add(info.format!.toUpperCase());
      }
    }
    final list = formats.toList()..sort();
    return list;
  }

  /// Count of albums matching a given quality.
  int countForQuality(AudioQuality quality) =>
      _albumAudioInfo.values.where((i) => i.quality == quality).length;

  /// Count of albums matching a given format.
  int countForFormat(String format) =>
      _albumAudioInfo.values
          .where((i) => i.format?.toUpperCase() == format)
          .length;

  /// Count of albums with sample rate >= minRate.
  int countForMinSampleRate(int minRate) =>
      _albumAudioInfo.values
          .where((i) => i.sampleRate != null && i.sampleRate! >= minRate)
          .length;

  // ---------------------------------------------------------------------------
  // Artistes
  // ---------------------------------------------------------------------------

  List<Artist> _artists = [];
  List<Artist> get artists => List.unmodifiable(_artists);

  void setArtists(List<Artist> artists) {
    _artists = artists;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Pistes
  // ---------------------------------------------------------------------------

  List<Track> _tracks = [];
  List<Track> get tracks => List.unmodifiable(_tracks);

  void setTracks(List<Track> tracks) {
    _tracks = tracks;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Favoris pistes
  // ---------------------------------------------------------------------------

  List<Track> _favoriteTracks = [];
  List<Track> get favoriteTracks => List.unmodifiable(_favoriteTracks);

  void setFavoriteTracks(List<Track> tracks) {
    _favoriteTracks = tracks;
    notifyListeners();
  }

  /// Vrai si l'ID de piste est dans la liste des favoris chargée.
  /// Pour une vérification live sur une piste spécifique, préférer le champ
  /// `favorite` du modèle Track lui-même si chargé.
  bool isTrackFavorite(int trackId) =>
      _favoriteTracks.any((t) => t.id == trackId);

  // Favoris streaming (Qobuz/Tidal/… « cœur » par profil), en cache mémoire pour
  // qu'une ligne réponde en O(1) sans appel API. Clé = `itemType:service:serviceId`.
  Set<String> _streamingFavKeys = {};

  String streamingFavKey(String itemType, String service, String serviceId) =>
      '$itemType:$service:$serviceId';

  bool isStreamingFavorite(String itemType, String service, String serviceId) =>
      _streamingFavKeys.contains(streamingFavKey(itemType, service, serviceId));

  void setStreamingFavKeys(Set<String> keys) {
    _streamingFavKeys = keys;
    notifyListeners();
  }

  void addStreamingFavKey(String key) {
    if (_streamingFavKeys.add(key)) notifyListeners();
  }

  void removeStreamingFavKey(String key) {
    if (_streamingFavKeys.remove(key)) notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Playlists
  // ---------------------------------------------------------------------------

  List<Playlist> _playlists = [];
  List<Playlist> get playlists => List.unmodifiable(_playlists);

  void setPlaylists(List<Playlist> playlists) {
    _playlists = playlists;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Radios
  // ---------------------------------------------------------------------------

  List<Radio> _radios = [];
  List<Radio> get radios => List.unmodifiable(_radios);

  void setRadios(List<Radio> radios) {
    _radios = radios;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Historique de lecture
  // ---------------------------------------------------------------------------

  List<HistoryEntry> _history = [];
  List<HistoryEntry> get history => List.unmodifiable(_history);

  /// Wall-clock start time per zone for accurate listened_ms tracking.
  final Map<String, ({Track track, String zoneName, DateTime startTime})>
      _zonePlayStart = {};

  void prependHistory(Track track, {required String zoneName}) {
    // Flush previous track for this zone with actual elapsed time
    flushZoneHistory(zoneName);

    // Store start time for wall-clock elapsed tracking
    _zonePlayStart[zoneName] = (
      track: track,
      zoneName: zoneName,
      startTime: DateTime.now(),
    );
  }

  /// Flush the currently tracked track for a zone, saving actual listened time.
  void flushZoneHistory(String zoneName) {
    final prev = _zonePlayStart.remove(zoneName);
    if (prev == null) return;
    final elapsedMs =
        DateTime.now().difference(prev.startTime).inMilliseconds;
    if (elapsedMs < 2000) return;

    // Avoid duplicate if same track already at top
    if (_history.isNotEmpty) {
      final first = _history.first.track as Track;
      if (first.id == prev.track.id) return;
    }

    final entry = HistoryEntry(
      track: prev.track,
      zoneName: prev.zoneName,
      playedAt: prev.startTime.toIso8601String(),
      listenedMs: elapsedMs,
    );
    _history = [
      entry,
      ..._history
          .where((e) => (e.track as Track).id != prev.track.id)
          .take(99),
    ];
    notifyListeners();
  }

  void setHistory(List<HistoryEntry> history) {
    _history = history;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Recherche
  // ---------------------------------------------------------------------------

  List<SearchResult> _searchResults = [];
  String _lastQuery = '';
  bool _searching = false;

  List<SearchResult> get searchResults => List.unmodifiable(_searchResults);
  String get lastQuery => _lastQuery;
  bool get isSearching => _searching;

  void setSearchResults(String query, List<SearchResult> results) {
    _lastQuery = query;
    _searchResults = results;
    _searching = false;
    notifyListeners();
  }

  void setSearching(bool value) {
    if (_searching == value) return;
    _searching = value;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _lastQuery = '';
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Streaming services
  // ---------------------------------------------------------------------------

  List<StreamingServiceStatus> _streamingServices = [];
  List<StreamingServiceStatus> get streamingServices =>
      List.unmodifiable(_streamingServices);

  void setStreamingServices(List<StreamingServiceStatus> services) {
    _streamingServices = services;
    notifyListeners();
  }

  void updateStreamingService(StreamingServiceStatus status) {
    final idx =
        _streamingServices.indexWhere((s) => s.serviceId == status.serviceId);
    if (idx >= 0) {
      _streamingServices = List.of(_streamingServices)..[idx] = status;
    } else {
      _streamingServices = [..._streamingServices, status];
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Scan progression
  // ---------------------------------------------------------------------------

  bool _scanning = false;
  String? _scanningDeviceId;
  int _scanProgress = 0;
  int _scanTotal = 0;
  int _scanTracksAdded = 0;
  int _scanTracksUpdated = 0;
  final Set<String> _indexedDeviceIds = {};

  bool get isScanning => _scanning;
  /// ID du device UPnP actuellement en cours d'indexation, null pour un scan local/SMB.
  String? get scanningDeviceId => _scanningDeviceId;
  int get scanProgress => _scanProgress;
  int get scanTotal => _scanTotal;
  int get scanTracksAdded => _scanTracksAdded;
  int get scanTracksUpdated => _scanTracksUpdated;

  /// Vrai si ce device UPnP a déjà été indexé au moins une fois dans la session.
  bool isDeviceIndexed(String deviceId) =>
      _indexedDeviceIds.contains(deviceId);

  void setScanStarted({String? deviceId}) {
    _scanning = true;
    _scanningDeviceId = deviceId;
    _scanProgress = 0;
    _scanTotal = 0;
    _scanTracksAdded = 0;
    _scanTracksUpdated = 0;
    notifyListeners();
  }

  void setScanProgress(int progress, int total) {
    _scanProgress = progress;
    _scanTotal = total;
    notifyListeners();
  }

  void setScanCompleted(int added, int updated) {
    _scanning = false;
    if (_scanningDeviceId != null) {
      _indexedDeviceIds.add(_scanningDeviceId!);
    }
    _scanningDeviceId = null;
    _scanTracksAdded = added;
    _scanTracksUpdated = updated;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Statistiques bibliothèque
  // ---------------------------------------------------------------------------

  LibraryStats? _stats;
  LibraryStats? get stats => _stats;

  void setStats(LibraryStats stats) {
    _stats = stats;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool get isEmpty => _albums.isEmpty && _tracks.isEmpty;

  int get totalTracks => _stats?.trackCount ?? _tracks.length;
  int get totalAlbums => _stats?.albumCount ?? _albums.length;
  int get totalArtists => _stats?.artistCount ?? _artists.length;
}
