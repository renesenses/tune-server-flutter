import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T16.2 — MetadataView (enhanced v2)
// Three sections: Enrichir / Doublons / Corriger
// Unified album cards with inline edit, filter chips, search, cover upload.
// Mirrors MetadataView.svelte (web client).
// ---------------------------------------------------------------------------

class MetadataView extends StatefulWidget {
  const MetadataView({super.key});

  @override
  State<MetadataView> createState() => _MetadataViewState();
}

enum _MetaFilter { all, noCover, noGenre, noYear, noArtist, doubtful }

class _MetadataViewState extends State<MetadataView> {
  // ── Completeness stats ──
  Map<String, dynamic>? _completeness;
  bool _loadingCompleteness = false;

  // ── Folders ──
  List<MusicFolder> _folders = [];
  bool _loadingFolders = false;

  // ── Action loading states ──
  final Map<String, bool> _actionLoading = {};

  // ── Suggestions ──
  int _suggestionsCount = 0;
  bool _loadingSuggestions = false;

  // ── Status message ──
  String? _statusMessage;

  // ── Albums data (for Corriger section) ──
  List<Map<String, dynamic>> _allAlbums = [];
  bool _loadingAlbums = false;

  // ── Doubtful albums ──
  List<Map<String, dynamic>> _doubtfulAlbums = [];
  bool _loadingDoubtful = false;

  // ── Duplicates ──
  List<List<Map<String, dynamic>>> _duplicateGroups = [];

  // ── Filter & search ──
  _MetaFilter _filter = _MetaFilter.noCover;
  final TextEditingController _searchCtrl = TextEditingController();
  String _filterArtist = '';
  String _filterGenre = '';

  // ── Inline edit state ──
  int? _editingAlbumId;
  final TextEditingController _editArtist = TextEditingController();
  final TextEditingController _editTitle = TextEditingController();
  final TextEditingController _editGenre = TextEditingController();
  final TextEditingController _editYear = TextEditingController();
  int? _savedAlbumId; // shows "Write Tags" button after save

  // ── Cover zoom ──
  String? _zoomCoverUrl;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _editArtist.dispose();
    _editTitle.dispose();
    _editGenre.dispose();
    _editYear.dispose();
    super.dispose();
  }

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

  // ---------------------------------------------------------------------------
  // Run a metadata action with loading state + snackbar result
  // ---------------------------------------------------------------------------

  Future<void> _runAction(
    String key,
    String label,
    Future<Map<String, dynamic>> Function() action,
  ) async {
    if (_actionLoading[key] == true) return;
    setState(() => _actionLoading[key] = true);
    try {
      final result = await action();
      if (mounted) {
        final msg = _formatResult(label, result);
        setState(() => _statusMessage = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
        _loadCompleteness();
        _loadSuggestionsCount();
        _loadAlbums();
      }
    } catch (e) {
      if (mounted) {
        final msg = '$label : erreur - $e';
        setState(() => _statusMessage = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _actionLoading[key] = false);
    }
  }

  String _formatResult(String label, Map<String, dynamic> result) {
    final fixed = result['fixed'] ?? result['updated'] ?? result['merged'];
    final total = result['total'] ?? result['scanned'];
    final accepted = result['accepted'];
    if (accepted != null) return '$label : $accepted acceptées';
    if (fixed != null && total != null) return '$label : $fixed/$total corrigés';
    if (fixed != null) return '$label : $fixed corrigés';
    if (total != null) return '$label : $total traités';
    return '$label : terminé';
  }

  // ---------------------------------------------------------------------------
  // Inline edit actions
  // ---------------------------------------------------------------------------

  void _startEdit(Map<String, dynamic> album) {
    setState(() {
      _editingAlbumId = album['id'] as int;
      _editArtist.text = album['artist_name'] ?? '';
      _editTitle.text = album['title'] ?? '';
      _editGenre.text = album['genre'] ?? '';
      _editYear.text =
          (album['year'] != null && album['year'] != 0) ? '${album['year']}' : '';
      _savedAlbumId = null;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingAlbumId = null;
      _savedAlbumId = null;
    });
  }

  Future<void> _saveEdit() async {
    if (_editingAlbumId == null) return;
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    final albumId = _editingAlbumId!;
    final updates = <String, dynamic>{};

    // Find the current album
    final album = _allAlbums.firstWhere(
      (a) => a['id'] == albumId,
      orElse: () => _doubtfulAlbums.firstWhere(
        (a) => a['id'] == albumId,
        orElse: () => <String, dynamic>{},
      ),
    );
    if (album.isEmpty) return;

    if (_editArtist.text != (album['artist_name'] ?? '')) {
      updates['artist_name'] = _editArtist.text;
    }
    if (_editTitle.text != (album['title'] ?? '')) {
      updates['title'] = _editTitle.text;
    }
    if (_editGenre.text != (album['genre'] ?? '')) {
      updates['genre'] = _editGenre.text;
    }
    final newYear = _editYear.text.isNotEmpty ? int.tryParse(_editYear.text) : null;
    if (newYear != album['year']) {
      updates['year'] = newYear;
    }

    if (updates.isNotEmpty) {
      try {
        await api.updateAlbumMetadata(albumId, updates);
        // Update local state
        setState(() {
          _allAlbums = _allAlbums.map((a) {
            if (a['id'] == albumId) {
              return {...a, ...updates};
            }
            return a;
          }).toList();
          _doubtfulAlbums = _doubtfulAlbums.map((a) {
            if (a['id'] == albumId) {
              return {...a, ...updates};
            }
            return a;
          }).toList();
          _savedAlbumId = albumId;
        });
        _loadCompleteness();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Album enregistré'),
              backgroundColor: TuneColors.surfaceHigh,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur : $e'),
              backgroundColor: TuneColors.error,
            ),
          );
        }
      }
    } else {
      setState(() => _editingAlbumId = null);
    }
  }

  Future<void> _writeAlbumTags(int albumId) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      final r = await api.writeAlbumTags(albumId);
      final count = r['updated'] ?? r['tracks_processed'] ?? 0;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tags gravés : $count fichiers'),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
        setState(() {
          _editingAlbumId = null;
          _savedAlbumId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur gravure : $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Cover upload
  // ---------------------------------------------------------------------------

  Future<void> _uploadCover(int albumId) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.first.path;
    if (path == null) return;

    try {
      final updated = await api.uploadAlbumArtwork(albumId, path);
      final coverPath = updated['cover_path'];
      setState(() {
        _allAlbums = _allAlbums.map((a) {
          if (a['id'] == albumId) return {...a, 'cover_path': coverPath};
          return a;
        }).toList();
        _doubtfulAlbums = _doubtfulAlbums.map((a) {
          if (a['id'] == albumId) return {...a, 'cover_path': coverPath};
          return a;
        }).toList();
        _savedAlbumId = albumId;
        if (_editingAlbumId == null) _startEdit(_allAlbums.firstWhere((a) => a['id'] == albumId, orElse: () => <String, dynamic>{}));
      });
      _loadCompleteness();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cover uploadée'),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur upload : $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Merge duplicate group
  // ---------------------------------------------------------------------------

  Future<void> _mergeGroup(List<Map<String, dynamic>> group) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    final ids = group.map((a) => a['id'] as int).toList();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text('Fusionner ${group.length} albums ?', style: TuneFonts.title3),
        content: Text(
          "L'album avec le plus de pistes sera conservé, les autres seront supprimés.",
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Fusionner',
                style: TextStyle(color: TuneColors.warning)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final result = await api.mergeAlbums(ids);
      final masterId = result['master_id'];
      final mergedIds = ids.where((id) => id != masterId).toSet();
      setState(() {
        _allAlbums = _allAlbums.where((a) => !mergedIds.contains(a['id'])).toList();
        _allAlbums = _allAlbums.map((a) {
          if (a['id'] == masterId) {
            return {...a, 'track_count': result['total_tracks']};
          }
          return a;
        }).toList();
        _computeDuplicateGroups();
      });
      _loadCompleteness();
      if (mounted) {
        final moved = result['tracks_moved'] ?? 0;
        final total = result['total_tracks'] ?? 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fusionné : $moved pistes déplacées, $total au total'),
            backgroundColor: TuneColors.surfaceHigh,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur fusion : $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Cover URL helper
  // ---------------------------------------------------------------------------

  String? _coverUrl(Map<String, dynamic> album) {
    final api = context.read<AppState>().apiClient;
    if (api == null) return null;
    final cover = album['cover_path']?.toString() ?? '';
    if (cover.isEmpty) return null;
    return api.artworkUrl(cover);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lib = context.watch<LibraryState>();
    final app = context.read<AppState>();
    final api = app.apiClient;
    final stats = lib.stats;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.metadataTitle, style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: l.metadataRefreshStats,
            onPressed: () => _loadAll(),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              // ================================================================
              // 1. COMPLETENESS STATS CARDS (clickable to filter)
              // ================================================================
              const _SectionHeader('Complétude métadonnées'),
              if (api != null) _buildCompletenessCards(),

              // ================================================================
              // 2. BASIC STATS
              // ================================================================
              _SectionHeader(l.metadataSectionStats),
              Container(
                color: TuneColors.surface,
                padding: const EdgeInsets.all(16),
                child: stats == null
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: TuneColors.accent),
                      )
                    : Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _StatChip(
                              label: l.metadataStatTracks,
                              value: stats.trackCount.toString()),
                          _StatChip(
                              label: l.metadataStatAlbums,
                              value: stats.albumCount.toString()),
                          _StatChip(
                              label: l.metadataStatArtists,
                              value: stats.artistCount.toString()),
                          _StatChip(
                              label: l.metadataStatPlaylists,
                              value: stats.playlistCount.toString()),
                          _StatChip(
                              label: l.metadataStatRadios,
                              value: stats.radioCount.toString()),
                          _StatChip(
                              label: l.metadataStatArtwork,
                              value: _formatBytes(stats.artworkCacheBytes)),
                        ],
                      ),
              ),

              // ================================================================
              // 3. ENRICHIR section
              // ================================================================
              if (api != null) ...[
                const _SectionHeader('ENRICHIR'),
                Container(
                  color: TuneColors.surface,
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _ActionButton(
                        icon: Icons.auto_fix_high_rounded,
                        label: 'Enrichir MusicBrainz',
                        loading: _actionLoading['autofix'] == true,
                        onPressed: () => _runAction(
                          'autofix',
                          'Enrichissement MusicBrainz',
                          () => api.startAutoFix(),
                        ),
                      ),
                      _ActionButton(
                        icon: Icons.calendar_today_rounded,
                        label: 'Fix années Tidal',
                        loading: _actionLoading['yearsTidal'] == true,
                        onPressed: () => _runAction(
                          'yearsTidal',
                          'Fix années Tidal',
                          () => api.fixYearsTidal(),
                        ),
                      ),
                      _ActionButton(
                        icon: Icons.album_rounded,
                        label: 'Fix années Discogs',
                        loading: _actionLoading['yearsDiscogs'] == true,
                        onPressed: () => _runAction(
                          'yearsDiscogs',
                          'Fix années Discogs',
                          () => api.fixYearsDiscogs(),
                        ),
                      ),
                      _ActionButton(
                        icon: Icons.category_rounded,
                        label: 'Fix genres',
                        loading: _actionLoading['genres'] == true,
                        onPressed: () => _runAction(
                          'genres',
                          'Fix genres',
                          () => api.fixGenres(),
                        ),
                      ),
                      _ActionButton(
                        icon: Icons.auto_awesome_rounded,
                        label: 'Auto-fix albums',
                        loading: _actionLoading['autofixAlbums'] == true,
                        onPressed: () => _runAction(
                          'autofixAlbums',
                          'Auto-fix albums',
                          () => api.autoFixAlbums(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Suggestions
                Container(
                  color: TuneColors.surface,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _loadingSuggestions
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                                color: TuneColors.accent),
                          ),
                        )
                      : Row(
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded,
                                color: TuneColors.warning, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _suggestionsCount > 0
                                    ? '$_suggestionsCount suggestion${_suggestionsCount > 1 ? 's' : ''} en attente'
                                    : 'Aucune suggestion en attente',
                                style: TuneFonts.body,
                              ),
                            ),
                            if (_suggestionsCount > 0)
                              _ActionButton(
                                icon: Icons.check_circle_rounded,
                                label: 'Accepter tout',
                                loading: _actionLoading['acceptAll'] == true,
                                onPressed: () => _runAction(
                                  'acceptAll',
                                  'Suggestions',
                                  () => api.acceptAllSuggestions(),
                                ),
                              ),
                          ],
                        ),
                ),

                // ================================================================
                // 4. DOUBLONS section
                // ================================================================
                const _SectionHeader('DOUBLONS'),
                Container(
                  color: TuneColors.surface,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _ActionButton(
                            icon: Icons.find_replace_rounded,
                            label: 'Scan doublons',
                            loading: _actionLoading['scanDupes'] == true,
                            onPressed: () => _runAction(
                              'scanDupes',
                              'Scan doublons',
                              () => api.scanDuplicates(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _ActionButton(
                            icon: Icons.merge_rounded,
                            label: 'Fusionner auto',
                            loading: _actionLoading['merge'] == true,
                            onPressed: () => _runAction(
                              'merge',
                              'Fusion doublons',
                              () => api.mergeAlbumDuplicates(),
                            ),
                          ),
                        ],
                      ),
                      if (_duplicateGroups.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          '$_duplicateCount albums en double (${_duplicateGroups.length} groupes)',
                          style: TuneFonts.footnote
                              .copyWith(color: TuneColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        ..._duplicateGroups.take(20).map(
                              (group) => _buildDuplicateGroup(group),
                            ),
                        if (_duplicateGroups.length > 20)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '... et ${_duplicateGroups.length - 20} autres groupes',
                              style: TuneFonts.caption,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),

                // ================================================================
                // 5. CORRIGER section
                // ================================================================
                const _SectionHeader('CORRIGER'),
                _buildFilterChips(),
                _buildSearchAndDropdowns(),
                _buildAlbumList(),
              ],

              // ================================================================
              // 6. STATUS MESSAGE
              // ================================================================
              if (_statusMessage != null) ...[
                const _SectionHeader('Dernier résultat'),
                Container(
                  color: TuneColors.surface,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: TuneColors.accent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: TuneFonts.footnote
                              .copyWith(color: TuneColors.textPrimary),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: TuneColors.textTertiary),
                        onPressed: () =>
                            setState(() => _statusMessage = null),
                      ),
                    ],
                  ),
                ),
              ],

              // ================================================================
              // 7. SCAN
              // ================================================================
              _SectionHeader(l.metadataSectionScan),
              Container(
                color: TuneColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (lib.isScanning)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.metadataScanInProgress(
                                  lib.scanProgress, lib.scanTotal),
                              style: TuneFonts.footnote,
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: lib.scanTotal > 0
                                  ? lib.scanProgress / lib.scanTotal
                                  : null,
                              color: TuneColors.accent,
                              backgroundColor: TuneColors.surfaceVariant,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      )
                    else if (lib.scanTracksAdded > 0 ||
                        lib.scanTracksUpdated > 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          l.metadataScanResult(
                              lib.scanTracksAdded, lib.scanTracksUpdated),
                          style: TuneFonts.footnote
                              .copyWith(color: TuneColors.success),
                        ),
                      ),
                    ListTile(
                      leading: Icon(
                        Icons.sync_rounded,
                        color: lib.isScanning
                            ? TuneColors.textTertiary
                            : TuneColors.accent,
                      ),
                      title: Text(l.metadataScanBtn, style: TuneFonts.body),
                      subtitle:
                          Text(l.metadataScanDesc, style: TuneFonts.footnote),
                      enabled: !lib.isScanning,
                      onTap: () async {
                        await app.scanLibrary();
                        await _loadStats();
                        _loadCompleteness();
                        _loadAlbums();
                      },
                    ),
                  ],
                ),
              ),

              // ================================================================
              // 8. MUSIC FOLDERS
              // ================================================================
              _SectionHeader(l.metadataSectionFolders),
              Container(
                color: TuneColors.surface,
                child: _loadingFolders
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: TuneColors.accent),
                        ),
                      )
                    : Column(
                        children: [
                          if (_folders.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              child: Text(l.metadataFoldersNone,
                                  style: const TextStyle(
                                      color: TuneColors.textTertiary)),
                            ),
                          ..._folders.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final folder = entry.value;
                            return Column(
                              children: [
                                if (idx > 0)
                                  const Divider(
                                      height: 1,
                                      indent: 56,
                                      color: TuneColors.divider),
                                Dismissible(
                                  key: ValueKey(folder.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    color: Colors.red,
                                    child: const Icon(Icons.delete_rounded,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (_) async {
                                    await app.engine
                                        .removeMusicFolder(folder.id);
                                    await _loadFolders();
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.folder_rounded,
                                        color: TuneColors.accent),
                                    title: Text(folder.path,
                                        style: TuneFonts.footnote.copyWith(
                                            color: TuneColors.textPrimary),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    subtitle: Text(
                                      l.metadataFolderAddedOn(
                                          _formatDate(folder.addedAt)),
                                      style: TuneFonts.footnote,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          if (_folders.isNotEmpty)
                            const Divider(
                                height: 1, color: TuneColors.divider),
                          ListTile(
                            leading: const Icon(Icons.add_rounded,
                                color: TuneColors.accent),
                            title: Text(l.metadataAddFolder,
                                style: TuneFonts.body),
                            onTap: () => _addFolder(context, app),
                          ),
                        ],
                      ),
              ),

              // ================================================================
              // 9. CLEANUP
              // ================================================================
              _SectionHeader(l.metadataSectionCleanup),
              Container(
                color: TuneColors.surface,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cleaning_services_rounded,
                          color: TuneColors.warning),
                      title: Text(l.metadataCleanupOrphans,
                          style: TuneFonts.body),
                      subtitle: Text(l.metadataCleanupOrphansDesc,
                          style: TuneFonts.footnote),
                      onTap: () => _confirmCleanup(context, app),
                    ),
                    const Divider(
                        height: 1, indent: 56, color: TuneColors.divider),
                    ListTile(
                      leading: const Icon(Icons.delete_forever_rounded,
                          color: TuneColors.error),
                      title: Text(l.metadataClearLibrary,
                          style: TuneFonts.body),
                      subtitle: Text(l.metadataClearLibraryDesc,
                          style: TuneFonts.footnote),
                      onTap: () => _confirmClear(context, app),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Cover zoom overlay
          if (_zoomCoverUrl != null)
            GestureDetector(
              onTap: () => setState(() => _zoomCoverUrl = null),
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: Image.network(
                    _zoomCoverUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image_rounded,
                      color: TuneColors.textTertiary,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Completeness Cards (clickable)
  // ---------------------------------------------------------------------------

  Widget _buildCompletenessCards() {
    if (_loadingCompleteness && _completeness == null) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: TuneColors.accent),
        ),
      );
    }
    if (_completeness == null) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(16),
        child: Text(
          'Statistiques indisponibles',
          style: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary),
        ),
      );
    }

    final totalAlbums = (_completeness!['total_albums'] ?? 0) as int;
    final totalTracks = (_completeness!['total_tracks'] ?? 0) as int;
    final noCover = (_completeness!['albums_without_cover'] ?? 0) as int;
    final noGenre = (_completeness!['albums_without_genre'] ?? 0) as int;
    final noYear = (_completeness!['albums_without_year'] ?? 0) as int;
    final noArtist = (_completeness!['tracks_without_artist'] ?? 0) as int;

    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _CompletenessCard(
            icon: Icons.image_rounded,
            label: 'Cover',
            missing: noCover,
            total: totalAlbums,
            color: TuneColors.accent,
            active: _filter == _MetaFilter.noCover,
            onTap: () => setState(() => _filter = _MetaFilter.noCover),
          ),
          _CompletenessCard(
            icon: Icons.category_rounded,
            label: 'Genre',
            missing: noGenre,
            total: totalAlbums,
            color: TuneColors.warning,
            active: _filter == _MetaFilter.noGenre,
            onTap: () => setState(() => _filter = _MetaFilter.noGenre),
          ),
          _CompletenessCard(
            icon: Icons.calendar_today_rounded,
            label: 'Année',
            missing: noYear,
            total: totalAlbums,
            color: TuneColors.accentLight,
            active: _filter == _MetaFilter.noYear,
            onTap: () => setState(() => _filter = _MetaFilter.noYear),
          ),
          _CompletenessCard(
            icon: Icons.person_rounded,
            label: 'Artiste',
            missing: noArtist,
            total: totalTracks,
            color: TuneColors.success,
            active: _filter == _MetaFilter.noArtist,
            onTap: () => setState(() => _filter = _MetaFilter.noArtist),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filter chips for Corriger section
  // ---------------------------------------------------------------------------

  Widget _buildFilterChips() {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip('Tous', _MetaFilter.all),
            _filterChip('Covers manquantes', _MetaFilter.noCover),
            _filterChip('Genre manquant', _MetaFilter.noGenre),
            _filterChip('Année manquante', _MetaFilter.noYear),
            _filterChip('Artiste manquant', _MetaFilter.noArtist),
            _filterChip('Douteux', _MetaFilter.doubtful),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, _MetaFilter filter) {
    final selected = _filter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: TuneFonts.caption.copyWith(
          color: selected ? TuneColors.textPrimary : TuneColors.textSecondary,
        )),
        selected: selected,
        selectedColor: TuneColors.accent.withValues(alpha: 0.3),
        backgroundColor: TuneColors.surfaceVariant,
        side: BorderSide.none,
        onSelected: (_) {
          setState(() {
            _filter = filter;
            if (filter == _MetaFilter.doubtful && _doubtfulAlbums.isEmpty) {
              _loadDoubtful();
            }
          });
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search + Artist/Genre dropdowns
  // ---------------------------------------------------------------------------

  Widget _buildSearchAndDropdowns() {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          // Search text field
          TextField(
            controller: _searchCtrl,
            style: TuneFonts.body,
            decoration: InputDecoration(
              hintText: 'Rechercher des albums\u2026',
              hintStyle: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: TuneColors.textTertiary, size: 20),
              filled: true,
              fillColor: TuneColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 18, color: TuneColors.textTertiary),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          // Dropdowns row
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: _filterArtist.isEmpty ? null : _filterArtist,
                  hint: 'Tous les artistes',
                  items: _distinctArtists,
                  onChanged: (v) => setState(() => _filterArtist = v ?? ''),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  value: _filterGenre.isEmpty ? null : _filterGenre,
                  hint: 'Tous les genres',
                  items: _distinctGenres,
                  onChanged: (v) => setState(() => _filterGenre = v ?? ''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary)),
          isExpanded: true,
          dropdownColor: TuneColors.surfaceHigh,
          style: TuneFonts.caption.copyWith(color: TuneColors.textPrimary),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: TuneColors.textTertiary, size: 18),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(hint, style: TuneFonts.caption
                  .copyWith(color: TuneColors.textTertiary)),
            ),
            ...items.map((s) => DropdownMenuItem(value: s, child: Text(s))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Album cards list (unified view)
  // ---------------------------------------------------------------------------

  Widget _buildAlbumList() {
    if (_loadingAlbums && _allAlbums.isEmpty) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: TuneColors.accent),
        ),
      );
    }
    if (_filter == _MetaFilter.doubtful && _loadingDoubtful) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: TuneColors.accent),
        ),
      );
    }

    final albums = _filteredAlbums;
    if (albums.isEmpty) {
      return Container(
        color: TuneColors.surface,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Aucun album correspondant',
            style: TuneFonts.body.copyWith(color: TuneColors.textTertiary),
          ),
        ),
      );
    }

    return Container(
      color: TuneColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              '${albums.length} albums',
              style: TuneFonts.caption,
            ),
          ),
          // Show max 50 at a time for performance
          ...albums.take(50).map((album) => _buildAlbumCard(album)),
          if (albums.length > 50)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '... et ${albums.length - 50} autres albums (filtrez pour affiner)',
                style: TuneFonts.caption,
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Single album card
  // ---------------------------------------------------------------------------

  Widget _buildAlbumCard(Map<String, dynamic> album) {
    final albumId = album['id'] as int;
    final isEditing = _editingAlbumId == albumId;
    final coverUrl = _coverUrl(album);
    final title = album['title'] ?? '';
    final artist = album['artist_name'] ?? '';
    final genre = album['genre'] ?? '';
    final year = album['year'];
    final folderPath = album['folder_path'] ?? '';
    final trackCount = album['track_count'];

    // Missing metadata tags
    final missingTags = <String>[];
    final coverPath = album['cover_path']?.toString() ?? '';
    if (coverPath.isEmpty) {
      missingTags.add('Cover');
    }
    if (genre.isEmpty) missingTags.add('Genre');
    if (year == null || year == 0) missingTags.add('Année');
    if (artist.isEmpty || artist == 'Unknown Artist') {
      missingTags.add('Artiste');
    }

    // Doubtful reasons
    final reasons = album['reasons'];

    return Column(
      children: [
        const Divider(height: 1, color: TuneColors.divider),
        if (isEditing) _buildEditMode(album) else
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover thumbnail (tappable)
              GestureDetector(
                onTap: () {
                  if (coverUrl != null) {
                    setState(() => _zoomCoverUrl = coverUrl);
                  } else {
                    _uploadCover(albumId);
                  }
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: TuneColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: coverUrl != null
                      ? Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.album_rounded,
                            color: TuneColors.textTertiary,
                            size: 28,
                          ),
                        )
                      : const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: TuneColors.textTertiary,
                          size: 28,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TuneFonts.callout
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (artist.isNotEmpty)
                      Text(
                        artist,
                        style: TuneFonts.footnote,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Row(
                      children: [
                        if (genre.isNotEmpty)
                          Text('$genre', style: TuneFonts.caption),
                        if (genre.isNotEmpty &&
                            year != null &&
                            year != 0)
                          Text(' \u00b7 ', style: TuneFonts.caption),
                        if (year != null && year != 0)
                          Text('$year', style: TuneFonts.caption),
                        if (trackCount != null) ...[
                          Text(' \u00b7 ', style: TuneFonts.caption),
                          Text('$trackCount pistes',
                              style: TuneFonts.caption),
                        ],
                      ],
                    ),
                    if (folderPath.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          folderPath,
                          style: TuneFonts.caption.copyWith(
                              color: TuneColors.textTertiary, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    // Missing metadata tags
                    if (missingTags.isNotEmpty || reasons != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            ...missingTags.map((tag) => _MetadataTag(tag)),
                            if (reasons != null)
                              ...(reasons as List).map(
                                (r) => _MetadataTag(
                                    _reasonLabel(r.toString())),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded,
                        size: 18, color: TuneColors.accent),
                    tooltip: 'Modifier',
                    onPressed: () => _startEdit(album),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined,
                        size: 18, color: TuneColors.textSecondary),
                    tooltip: 'Upload cover',
                    onPressed: () => _uploadCover(albumId),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Edit mode for album card
  // ---------------------------------------------------------------------------

  Widget _buildEditMode(Map<String, dynamic> album) {
    final albumId = album['id'] as int;
    final coverUrl = _coverUrl(album);

    return Container(
      padding: const EdgeInsets.all(16),
      color: TuneColors.surfaceVariant.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              GestureDetector(
                onTap: () => _uploadCover(albumId),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TuneColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: coverUrl != null
                      ? Image.network(coverUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.album_rounded,
                              color: TuneColors.textTertiary,
                              size: 32))
                      : const Icon(Icons.add_photo_alternate_outlined,
                          color: TuneColors.textTertiary, size: 32),
                ),
              ),
              const SizedBox(width: 12),
              // Fields
              Expanded(
                child: Column(
                  children: [
                    _editField('Artiste', _editArtist),
                    const SizedBox(height: 6),
                    _editField('Album', _editTitle),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: _editField('Genre', _editGenre)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: _editField('Année', _editYear,
                              keyboardType: TextInputType.number),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.check_rounded, size: 16),
                label: Text('Enregistrer', style: TuneFonts.footnote
                    .copyWith(color: Colors.white)),
                onPressed: _saveEdit,
              ),
              const SizedBox(width: 8),
              if (_savedAlbumId == albumId)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TuneColors.warning.withValues(alpha: 0.2),
                    foregroundColor: TuneColors.warning,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.save_alt_rounded, size: 16),
                  label:
                      Text('Graver tags', style: TuneFonts.footnote),
                  onPressed: () => _writeAlbumTags(albumId),
                ),
              const Spacer(),
              TextButton(
                onPressed: _cancelEdit,
                child: Text('Annuler',
                    style: TuneFonts.footnote
                        .copyWith(color: TuneColors.textSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editField(String label, TextEditingController ctrl,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      style: TuneFonts.footnote.copyWith(color: TuneColors.textPrimary),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TuneFonts.caption,
        filled: true,
        fillColor: TuneColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        isDense: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Duplicate group card
  // ---------------------------------------------------------------------------

  Widget _buildDuplicateGroup(List<Map<String, dynamic>> group) {
    final first = group.first;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${first['title'] ?? ''} \u2014 ${first['artist_name'] ?? ''}',
                    style: TuneFonts.callout
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _ActionButton(
                  icon: Icons.merge_rounded,
                  label: 'Fusionner',
                  loading: false,
                  onPressed: () => _mergeGroup(group),
                ),
              ],
            ),
          ),
          ...group.map((a) {
            final tc = a['track_count'] ?? '?';
            final fp = a['folder_path'] ?? '';
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
              child: Row(
                children: [
                  const Icon(Icons.album_rounded,
                      size: 14, color: TuneColors.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$tc pistes${fp.isNotEmpty ? ' \u2014 $fp' : ''}',
                      style: TuneFonts.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _reasonLabel(String reason) {
    const labels = {
      'artist_uppercase': 'Artiste MAJ',
      'artist_placeholder': 'Artiste provisoire',
      'artist_has_year': 'Artiste = dossier',
      'genre_placeholder': 'Genre provisoire',
      'year_suspicious': 'Année suspecte',
      'title_uppercase': 'Titre MAJ',
      'artist_mismatch': 'Artiste différent',
    };
    return labels[reason] ?? reason;
  }

  // ---------------------------------------------------------------------------
  // Actions (existing, preserved)
  // ---------------------------------------------------------------------------

  Future<void> _addFolder(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController();

    final picked = await FilePicker.platform.getDirectoryPath();
    if (picked != null) {
      ctrl.text = picked;
    }

    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.metadataAddFolder, style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              style: TuneFonts.body,
              decoration: InputDecoration(
                labelText: l.metadataFolderPath,
                hintText: l.metadataFolderHint,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.folder_open_rounded, size: 16),
                label: Text(l.btnAddFolder),
                onPressed: () async {
                  final p = await FilePicker.platform.getDirectoryPath();
                  if (p != null) ctrl.text = p;
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.btnAdd,
                style: const TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );
    if (result == true && mounted) {
      final path = ctrl.text.trim();
      if (path.isNotEmpty) {
        await app.addMusicFolder(path);
        await _loadFolders();
        await _loadStats();
      }
    }
  }

  Future<void> _confirmCleanup(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title:
            Text(l.metadataCleanupOrphansTitle, style: TuneFonts.title3),
        content:
            Text(l.metadataCleanupOrphansBody, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.metadataDeleteBtn,
                style: const TextStyle(color: TuneColors.warning)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await app.cleanupOrphans();
      await _loadStats();
      _loadAlbums();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).metadataOrphansDeleted)),
        );
      }
    }
  }

  Future<void> _confirmClear(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title:
            Text(l.metadataClearLibraryTitle, style: TuneFonts.title3),
        content:
            Text(l.metadataClearLibraryBody, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.metadataClearBtn,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await app.clearLibrary();
      await _loadStats();
      _loadAlbums();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).metadataLibraryCleared)),
        );
      }
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes o';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} Ko';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  String _formatDate(String iso) {
    try {
      return iso.split('T').first;
    } catch (_) {
      return iso;
    }
  }
}

// ---------------------------------------------------------------------------
// Composants
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TuneFonts.footnote.copyWith(
          color: TuneColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style:
                  TuneFonts.title3.copyWith(color: TuneColors.accent)),
          const SizedBox(height: 2),
          Text(label, style: TuneFonts.caption),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completeness card — clickable, shows active state
// ---------------------------------------------------------------------------

class _CompletenessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int missing;
  final int total;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const _CompletenessCard({
    required this.icon,
    required this.label,
    required this.missing,
    required this.total,
    required this.color,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final complete = total > 0 ? (total - missing) / total : 1.0;
    final pct = (complete * 100).toStringAsFixed(0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active
              ? color.withValues(alpha: 0.15)
              : TuneColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: active
              ? Border.all(color: color.withValues(alpha: 0.5), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(label,
                      style: TuneFonts.callout
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$missing / $total',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textSecondary),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: complete,
                minHeight: 6,
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$pct% complet',
              style: TuneFonts.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Metadata tag chip (for missing fields)
// ---------------------------------------------------------------------------

class _MetadataTag extends StatelessWidget {
  final String label;
  const _MetadataTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: TuneColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TuneFonts.caption.copyWith(
          color: TuneColors.warning,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action button with loading spinner
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: TuneColors.surfaceVariant,
        foregroundColor: TuneColors.textPrimary,
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: TuneColors.accent,
              ),
            )
          : Icon(icon, size: 18, color: TuneColors.accent),
      label: Text(label, style: TuneFonts.footnote),
      onPressed: loading ? null : onPressed,
    );
  }
}
