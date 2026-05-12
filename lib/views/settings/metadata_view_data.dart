// ignore_for_file: invalid_use_of_protected_member

part of 'metadata_view.dart';

// Extension _MetadataViewState — chargement des données + getters computed :
// - _loadAll orchestre folders/stats/completeness/suggestions/albums
// - _loadFolders / _loadStats / _loadCompleteness / _loadSuggestionsCount
//   / _loadAlbums / _loadDoubtful : appels API + setState
// - _computeDuplicateGroups : groupe par (title, artist, sample_rate, bit_depth)
// - getters _filteredAlbums / _distinctArtists / _distinctGenres /
//   _duplicateCount pour la section Corriger

extension _MetadataViewStateData on _MetadataViewState {

  // ---------------------------------------------------------------------------
  // Data loading
  // ---------------------------------------------------------------------------

  Future<void> _loadAll() async {
    _loadFolders();
    _loadStats();
    _loadCompleteness();
    _loadSuggestionsCount();
    _loadAlbums();
  }

  Future<void> _loadFolders() async {
    setState(() => _loadingFolders = true);
    final folders = await context.read<AppState>().engine.musicFolders();
    if (mounted) {
      setState(() {
        _folders = folders;
        _loadingFolders = false;
      });
    }
  }

  Future<void> _loadStats() async {
    final stats = await context.read<AppState>().engine.stats();
    if (mounted) context.read<LibraryState>().setStats(stats);
  }

  Future<void> _loadCompleteness() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() => _loadingCompleteness = true);
    try {
      final data = await api.getCompletenessStats();
      if (mounted) setState(() => _completeness = data);
    } catch (e) {
      debugPrint('Completeness stats error: $e');
    } finally {
      if (mounted) setState(() => _loadingCompleteness = false);
    }
  }

  Future<void> _loadSuggestionsCount() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() => _loadingSuggestions = true);
    try {
      final suggestions = await api.getMetadataSuggestions();
      if (mounted) {
        setState(() {
          _suggestionsCount = suggestions.length;
          _loadingSuggestions = false;
        });
      }
    } catch (e) {
      debugPrint('Suggestions count error: $e');
      if (mounted) setState(() => _loadingSuggestions = false);
    }
  }

  Future<void> _loadAlbums() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() => _loadingAlbums = true);
    try {
      final albums = await api.getAllAlbums();
      if (mounted) {
        setState(() {
          _allAlbums = albums.cast<Map<String, dynamic>>();
          _loadingAlbums = false;
          _computeDuplicateGroups();
        });
      }
    } catch (e) {
      debugPrint('Load albums error: $e');
      if (mounted) setState(() => _loadingAlbums = false);
    }
  }

  Future<void> _loadDoubtful() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    setState(() => _loadingDoubtful = true);
    try {
      final data = await api.getDoubtfulAlbums();
      if (mounted) {
        setState(() {
          _doubtfulAlbums = data.cast<Map<String, dynamic>>();
          _loadingDoubtful = false;
        });
      }
    } catch (e) {
      debugPrint('Load doubtful error: $e');
      if (mounted) setState(() => _loadingDoubtful = false);
    }
  }

  void _computeDuplicateGroups() {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final a in _allAlbums) {
      final title = (a['title'] ?? '').toString().toLowerCase().trim();
      final artist = (a['artist_name'] ?? '').toString().toLowerCase().trim();
      final sr = a['sample_rate'] ?? 0;
      final bd = a['bit_depth'] ?? 0;
      final key = '$title||$artist||$sr||$bd';
      groups.putIfAbsent(key, () => []).add(a);
    }
    _duplicateGroups =
        groups.values.where((g) => g.length > 1).toList();
  }

  // ---------------------------------------------------------------------------
  // Filtered albums for Corriger section
  // ---------------------------------------------------------------------------

  List<Map<String, dynamic>> get _filteredAlbums {
    List<Map<String, dynamic>> result;
    switch (_filter) {
      case _MetaFilter.noCover:
        result = _allAlbums
            .where((a) =>
                (a['cover_path']?.toString() ?? '').isEmpty ||
                a['id'] == _editingAlbumId)
            .toList();
      case _MetaFilter.noGenre:
        result = _allAlbums
            .where((a) =>
                (a['genre']?.toString() ?? '').isEmpty ||
                a['id'] == _editingAlbumId)
            .toList();
      case _MetaFilter.noYear:
        result = _allAlbums
            .where((a) =>
                a['year'] == null ||
                a['year'] == 0 ||
                a['id'] == _editingAlbumId)
            .toList();
      case _MetaFilter.noArtist:
        result = _allAlbums
            .where((a) {
                final name = a['artist_name']?.toString() ?? '';
                return name.isEmpty ||
                    name == 'Unknown Artist' ||
                    a['id'] == _editingAlbumId;
            })
            .toList();
      case _MetaFilter.doubtful:
        result = _doubtfulAlbums;
      case _MetaFilter.all:
        result = List.from(_allAlbums);
    }

    // Text search
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result.where((a) {
        final title = (a['title'] ?? '').toString().toLowerCase();
        final artist = (a['artist_name'] ?? '').toString().toLowerCase();
        final genre = (a['genre'] ?? '').toString().toLowerCase();
        return title.contains(q) || artist.contains(q) || genre.contains(q);
      }).toList();
    }

    // Artist dropdown
    if (_filterArtist.isNotEmpty) {
      result = result.where((a) => a['artist_name'] == _filterArtist).toList();
    }
    // Genre dropdown
    if (_filterGenre.isNotEmpty) {
      result = result.where((a) => a['genre'] == _filterGenre).toList();
    }

    return result;
  }

  // Distinct artist/genre lists for dropdowns
  List<String> get _distinctArtists {
    final s = <String>{};
    for (final a in _allAlbums) {
      final n = a['artist_name'];
      if (n != null && (n as String).isNotEmpty) s.add(n);
    }
    return s.toList()..sort((a, b) => a.compareTo(b));
  }

  List<String> get _distinctGenres {
    final s = <String>{};
    for (final a in _allAlbums) {
      final g = a['genre'];
      if (g != null && (g as String).isNotEmpty) s.add(g);
    }
    return s.toList()..sort((a, b) => a.compareTo(b));
  }

  int get _duplicateCount {
    int count = 0;
    for (final g in _duplicateGroups) {
      count += g.length - 1;
    }
    return count;
  }
}
