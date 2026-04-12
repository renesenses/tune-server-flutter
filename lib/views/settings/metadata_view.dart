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
// T16.2 — MetadataView (enhanced)
// Completeness stats, metadata fix actions, suggestions, scan, folders,
// cleanup. Mirrors MetadataManagerView.swift (iOS).
// ---------------------------------------------------------------------------

class MetadataView extends StatefulWidget {
  const MetadataView({super.key});

  @override
  State<MetadataView> createState() => _MetadataViewState();
}

class _MetadataViewState extends State<MetadataView> {
  // Completeness stats
  Map<String, dynamic>? _completeness;
  bool _loadingCompleteness = false;

  // Folders
  List<MusicFolder> _folders = [];
  bool _loadingFolders = false;

  // Action loading states
  final Map<String, bool> _actionLoading = {};

  // Suggestions
  int _suggestionsCount = 0;
  bool _loadingSuggestions = false;

  // Status message
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    _loadFolders();
    _loadStats();
    _loadCompleteness();
    _loadSuggestionsCount();
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
        // Refresh completeness after action
        _loadCompleteness();
        _loadSuggestionsCount();
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
    // Try to extract common result fields
    final fixed = result['fixed'] ?? result['updated'] ?? result['merged'];
    final total = result['total'] ?? result['scanned'];
    final accepted = result['accepted'];
    if (accepted != null) return '$label : $accepted acceptées';
    if (fixed != null && total != null) return '$label : $fixed/$total corrigés';
    if (fixed != null) return '$label : $fixed corrigés';
    if (total != null) return '$label : $total traités';
    // Fallback: show result keys
    return '$label : terminé';
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
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          // ================================================================
          // 1. COMPLETENESS STATS CARDS
          // ================================================================
          _SectionHeader('Complétude métadonnées'),
          if (api != null) _buildCompletenessCards(),

          // ================================================================
          // 2. BASIC STATS (existing)
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
          // 3. METADATA ACTIONS
          // ================================================================
          if (api != null) ...[
            _SectionHeader('Actions métadonnées'),
            Container(
              color: TuneColors.surface,
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _ActionButton(
                    icon: Icons.merge_rounded,
                    label: 'Fusionner doublons',
                    loading: _actionLoading['merge'] == true,
                    onPressed: () => _runAction(
                      'merge',
                      'Fusion doublons',
                      () => api.mergeAlbumDuplicates(),
                    ),
                  ),
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
                ],
              ),
            ),

            // ================================================================
            // 4. SUGGESTIONS
            // ================================================================
            _SectionHeader('Suggestions'),
            Container(
              color: TuneColors.surface,
              padding: const EdgeInsets.all(16),
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
                            loading:
                                _actionLoading['acceptAll'] == true,
                            onPressed: () => _runAction(
                              'acceptAll',
                              'Suggestions',
                              () => api.acceptAllSuggestions(),
                            ),
                          ),
                      ],
                    ),
            ),
          ],

          // ================================================================
          // 5. STATUS MESSAGE
          // ================================================================
          if (_statusMessage != null) ...[
            _SectionHeader('Dernier résultat'),
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
          // 6. SCAN (existing)
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
                  subtitle: Text(l.metadataScanDesc,
                      style: TuneFonts.footnote),
                  enabled: !lib.isScanning,
                  onTap: () async {
                    await app.scanLibrary();
                    await _loadStats();
                    _loadCompleteness();
                  },
                ),
              ],
            ),
          ),

          // ================================================================
          // 7. MUSIC FOLDERS (existing)
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
                                padding:
                                    const EdgeInsets.only(right: 20),
                                color: Colors.red,
                                child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white),
                              ),
                              onDismissed: (_) async {
                                await app.engine
                                    .removeMusicFolder(folder.id);
                                await _loadFolders();
                              },
                              child: ListTile(
                                leading: const Icon(
                                    Icons.folder_rounded,
                                    color: TuneColors.accent),
                                title: Text(folder.path,
                                    style: TuneFonts.footnote
                                        .copyWith(
                                            color:
                                                TuneColors.textPrimary),
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
          // 8. CLEANUP (existing)
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
                    height: 1,
                    indent: 56,
                    color: TuneColors.divider),
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
    );
  }

  // ---------------------------------------------------------------------------
  // Completeness Cards
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
          ),
          _CompletenessCard(
            icon: Icons.category_rounded,
            label: 'Genre',
            missing: noGenre,
            total: totalAlbums,
            color: TuneColors.warning,
          ),
          _CompletenessCard(
            icon: Icons.calendar_today_rounded,
            label: 'Année',
            missing: noYear,
            total: totalAlbums,
            color: TuneColors.accentLight,
          ),
          _CompletenessCard(
            icon: Icons.person_rounded,
            label: 'Artiste',
            missing: noArtist,
            total: totalTracks,
            color: TuneColors.success,
          ),
        ],
      ),
    );
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

  Future<void> _confirmCleanup(
      BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.metadataCleanupOrphansTitle,
            style: TuneFonts.title3),
        content: Text(l.metadataCleanupOrphansBody, style: TuneFonts.body),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).metadataOrphansDeleted)),
        );
      }
    }
  }

  Future<void> _confirmClear(
      BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.metadataClearLibraryTitle,
            style: TuneFonts.title3),
        content: Text(l.metadataClearLibraryBody, style: TuneFonts.body),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context).metadataLibraryCleared)),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TuneFonts.title3
                  .copyWith(color: TuneColors.accent)),
          const SizedBox(height: 2),
          Text(label, style: TuneFonts.caption),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completeness card — shows missing/total with progress bar
// ---------------------------------------------------------------------------

class _CompletenessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int missing;
  final int total;
  final Color color;

  const _CompletenessCard({
    required this.icon,
    required this.label,
    required this.missing,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final complete = total > 0 ? (total - missing) / total : 1.0;
    final pct = (complete * 100).toStringAsFixed(0);

    return Container(
      width: 155,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
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
            style: TuneFonts.footnote.copyWith(color: TuneColors.textSecondary),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
