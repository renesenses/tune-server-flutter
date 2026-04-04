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

class LibraryState extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // Albums
  // ---------------------------------------------------------------------------

  List<Album> _albums = [];
  List<Album> get albums => List.unmodifiable(_albums);

  void setAlbums(List<Album> albums) {
    _albums = albums;
    notifyListeners();
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
    return _albums.where((album) {
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

  List<Track> _history = [];
  List<Track> get history => List.unmodifiable(_history);

  void prependHistory(Track track) {
    _history = [track, ..._history.where((t) => t.id != track.id).take(99)];
    notifyListeners();
  }

  void setHistory(List<Track> history) {
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
  int _scanProgress = 0;
  int _scanTotal = 0;
  int _scanTracksAdded = 0;
  int _scanTracksUpdated = 0;

  bool get isScanning => _scanning;
  int get scanProgress => _scanProgress;
  int get scanTotal => _scanTotal;
  int get scanTracksAdded => _scanTracksAdded;
  int get scanTracksUpdated => _scanTracksUpdated;

  void setScanStarted() {
    _scanning = true;
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
