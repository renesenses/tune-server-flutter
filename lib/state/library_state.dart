import 'package:flutter/foundation.dart';

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
