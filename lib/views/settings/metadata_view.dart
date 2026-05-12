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

part 'metadata_view_widgets.dart';
part 'metadata_view_data.dart';
part 'metadata_view_actions.dart';
part 'metadata_view_builders.dart';

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


}
