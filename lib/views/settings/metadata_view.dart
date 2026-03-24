import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final lib = context.watch<LibraryState>();
    final app = context.read<AppState>();
    final stats = lib.stats;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title:
            const Text('Musique & Métadonnées', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Actualiser les stats',
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
          const _SectionHeader('Statistiques'),
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
                          label: 'Pistes',
                          value: stats.trackCount.toString()),
                      _StatChip(
                          label: 'Albums',
                          value: stats.albumCount.toString()),
                      _StatChip(
                          label: 'Artistes',
                          value: stats.artistCount.toString()),
                      _StatChip(
                          label: 'Playlists',
                          value: stats.playlistCount.toString()),
                      _StatChip(
                          label: 'Radios',
                          value: stats.radioCount.toString()),
                      _StatChip(
                          label: 'Cache pochettes',
                          value: _formatBytes(
                              stats.artworkCacheBytes)),
                    ],
                  ),
          ),

          // ---- Scan ----
          const _SectionHeader('Scan bibliothèque'),
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
                          'Scan en cours… ${lib.scanProgress}/${lib.scanTotal}',
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
                      'Dernier scan : +${lib.scanTracksAdded} ajoutées, '
                      '${lib.scanTracksUpdated} mises à jour',
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
                  title: const Text('Scanner la bibliothèque',
                      style: TuneFonts.body),
                  subtitle: const Text(
                      'Indexe tous les dossiers configurés',
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
          const _SectionHeader('Dossiers musique'),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Text('Aucun dossier configuré',
                              style: TextStyle(
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
                                  'Ajouté le ${_formatDate(folder.addedAt)}',
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
                        title: const Text('Ajouter un dossier',
                            style: TuneFonts.body),
                        onTap: () => _addFolder(context, app),
                      ),
                    ],
                  ),
          ),

          // ---- Nettoyage ----
          const _SectionHeader('Nettoyage'),
          Container(
            color: TuneColors.surface,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services_rounded,
                      color: TuneColors.warning),
                  title: const Text('Supprimer les orphelins',
                      style: TuneFonts.body),
                  subtitle: const Text(
                      'Albums et artistes sans pistes associées',
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
                  title: const Text('Vider la bibliothèque',
                      style: TuneFonts.body),
                  subtitle: const Text(
                      'Supprime toutes les pistes locales',
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
    final ctrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title:
            const Text('Ajouter un dossier', style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
          style: TuneFonts.body,
          decoration: const InputDecoration(
            labelText: 'Chemin du dossier',
            hintText: '/storage/emulated/0/Music',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ajouter',
                style: TextStyle(color: TuneColors.accent)),
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Supprimer les orphelins ?',
            style: TuneFonts.title3),
        content: const Text(
          'Les albums et artistes sans aucune piste associée seront supprimés de la base de données.',
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer',
                style: TextStyle(color: TuneColors.warning)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await app.cleanupOrphans();
      await _loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orphelins supprimés')),
        );
      }
    }
  }

  Future<void> _confirmClear(
      BuildContext context, AppState app) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('Vider la bibliothèque ?',
            style: TuneFonts.title3),
        content: const Text(
          'Toutes les pistes locales, albums et artistes seront supprimés de la base de données. Cette action est irréversible.',
          style: TuneFonts.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vider',
                style: TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await app.clearLibrary();
      await _loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bibliothèque vidée')),
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
