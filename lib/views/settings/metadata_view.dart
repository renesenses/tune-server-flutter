import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T16.2 — MetadataView
// Statistiques bibliothèque, scan, gestion dossiers musique,
// nettoyage orphelins, vidage bibliothèque.
// Miroir de MetadataView.swift (iOS)
// ---------------------------------------------------------------------------

class MetadataView extends StatefulWidget {
  const MetadataView({super.key});

  @override
  State<MetadataView> createState() => _MetadataViewState();
}

class _MetadataViewState extends State<MetadataView> {
  List<MusicFolder> _folders = [];
  bool _loadingFolders = false;

  @override
  void initState() {
    super.initState();
    _loadFolders();
    _loadStats();
  }

  Future<void> _loadFolders() async {
    setState(() => _loadingFolders = true);
    final folders =
        await context.read<AppState>().engine.musicFolders();
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lib = context.watch<LibraryState>();
    final app = context.read<AppState>();
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
            onPressed: () async {
              await _loadStats();
              await _loadFolders();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          // ---- Statistiques ----
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

          // ---- Scan ----
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
                  },
                ),
              ],
            ),
          ),

          // ---- Dossiers musique ----
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

          // ---- Nettoyage ----
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
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _addFolder(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController();

    // Essaie d'ouvrir le sélecteur de dossier natif
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
              content: Text(AppLocalizations.of(context).metadataOrphansDeleted)),
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
              content: Text(AppLocalizations.of(context).metadataLibraryCleared)),
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
