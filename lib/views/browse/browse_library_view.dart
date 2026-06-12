import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/domain_models.dart';
import '../../server/database/database.dart' show Track;
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// BrowseLibraryView
// Navigation par dossiers dans la bibliotheque locale (mode remote).
// Affiche les racines musicales, puis permet de naviguer dans l'arborescence.
// Miroir de BrowseView.swift (iPadOS) pour la navigation fichiers.
// ---------------------------------------------------------------------------

class BrowseLibraryView extends StatefulWidget {
  const BrowseLibraryView({super.key});

  @override
  State<BrowseLibraryView> createState() => _BrowseLibraryViewState();
}

class _BrowseLibraryViewState extends State<BrowseLibraryView> {
  List<_BrowseRoot>? _roots;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRoots();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _loadRoots() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.getBrowseRoots();
      final roots = (data['roots'] as List? ?? []).map((r) {
        final m = r as Map<String, dynamic>;
        return _BrowseRoot(
          path: m['path'] as String? ?? '',
          name: m['name'] as String? ?? '',
          trackCount: m['track_count'] as int? ?? 0,
        );
      }).toList();
      if (mounted) setState(() { _roots = roots; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Repertoires', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Actualiser',
            onPressed: _loadRoots,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text('Erreur de chargement', style: TuneFonts.subheadline),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(_error!, style: TuneFonts.caption, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadRoots,
              child: const Text('Reessayer',
                  style: TextStyle(color: TuneColors.accent)),
            ),
          ],
        ),
      );
    }

    final roots = _roots;
    if (roots == null || roots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder_open_rounded,
                size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text('Aucun dossier', style: TuneFonts.subheadline),
            const SizedBox(height: 4),
            Text('Ajoutez des dossiers musicaux dans les reglages',
                style: TuneFonts.caption),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: TuneColors.accent,
      onRefresh: _loadRoots,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: roots.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, indent: 56, color: TuneColors.divider),
        itemBuilder: (_, i) {
          final root = roots[i];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.folder_rounded,
                  color: TuneColors.accent, size: 22),
            ),
            title: Text(root.name,
                style: TuneFonts.body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(root.path,
                style: TuneFonts.footnote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (root.trackCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: TuneColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${root.trackCount}',
                        style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary)),
                  ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded,
                    color: TuneColors.textTertiary),
              ],
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => _BrowseDirectoryView(
                path: root.path,
                title: root.name,
              ),
            )),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _BrowseRoot — modele pour une racine musicale
// ---------------------------------------------------------------------------

class _BrowseRoot {
  final String path;
  final String name;
  final int trackCount;
  const _BrowseRoot({required this.path, required this.name, required this.trackCount});
}

// ---------------------------------------------------------------------------
// _BrowseDirectoryView — navigation recursive dans un dossier
// ---------------------------------------------------------------------------

class _BrowseDirectoryView extends StatefulWidget {
  final String path;
  final String title;

  const _BrowseDirectoryView({
    required this.path,
    required this.title,
  });

  @override
  State<_BrowseDirectoryView> createState() => _BrowseDirectoryViewState();
}

class _BrowseDirectoryViewState extends State<_BrowseDirectoryView> {
  List<_BrowseDir>? _directories;
  List<Track>? _tracks;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDirectory();
  }

  TuneApiClient? get _api => context.read<AppState>().apiClient;

  Future<void> _loadDirectory() async {
    final api = _api;
    if (api == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.browseDirectory(widget.path);
      final dirs = (data['directories'] as List? ?? []).map((d) {
        final m = d as Map<String, dynamic>;
        return _BrowseDir(
          name: m['name'] as String? ?? '',
          path: m['path'] as String? ?? '',
          trackCount: m['track_count'] as int? ?? 0,
        );
      }).toList();
      final tracks = (data['tracks'] as List? ?? []).map((t) {
        return trackFromJson(t as Map<String, dynamic>);
      }).toList();
      if (mounted) {
        setState(() {
          _directories = dirs;
          _tracks = tracks;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.title, style: TuneFonts.title3),
        actions: [
          if (_tracks != null && _tracks!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded,
                  color: TuneColors.accent),
              tooltip: 'Tout lire',
              onPressed: _playAll,
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Actualiser',
            onPressed: _loadDirectory,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text('Erreur de chargement', style: TuneFonts.subheadline),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(_error!, style: TuneFonts.caption, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadDirectory,
              child: const Text('Reessayer',
                  style: TextStyle(color: TuneColors.accent)),
            ),
          ],
        ),
      );
    }

    final dirs = _directories ?? [];
    final tracks = _tracks ?? [];

    if (dirs.isEmpty && tracks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open_rounded,
                size: 48, color: TuneColors.textTertiary),
            SizedBox(height: 12),
            Text('Dossier vide', style: TuneFonts.subheadline),
          ],
        ),
      );
    }

    // Build sections: directories first, then tracks
    final hasDirectories = dirs.isNotEmpty;
    final hasTracks = tracks.isNotEmpty;
    // Total items: optional header + dirs + optional header + tracks
    final items = <_ListEntry>[];
    if (hasDirectories) {
      items.add(_ListEntry.header('Dossiers'));
      for (final dir in dirs) {
        items.add(_ListEntry.directory(dir));
      }
    }
    if (hasTracks) {
      items.add(_ListEntry.header('Pistes (${tracks.length})'));
      for (int i = 0; i < tracks.length; i++) {
        items.add(_ListEntry.track(tracks[i], i));
      }
    }

    return RefreshIndicator(
      color: TuneColors.accent,
      onRefresh: _loadDirectory,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final entry = items[i];
          switch (entry.type) {
            case _EntryType.header:
              return _SectionHeader(title: entry.headerTitle!);
            case _EntryType.directory:
              return _DirectoryTile(dir: entry.dir!);
            case _EntryType.track:
              return _TrackTile(
                track: entry.track!,
                index: entry.trackIndex!,
                allTracks: tracks,
              );
          }
        },
      ),
    );
  }

  void _playAll() {
    final tracks = _tracks;
    if (tracks == null || tracks.isEmpty) return;
    context.read<AppState>().playTracks(tracks);
  }
}

// ---------------------------------------------------------------------------
// _BrowseDir — modele pour un sous-dossier
// ---------------------------------------------------------------------------

class _BrowseDir {
  final String name;
  final String path;
  final int trackCount;
  const _BrowseDir({required this.name, required this.path, required this.trackCount});
}

// ---------------------------------------------------------------------------
// _ListEntry — union type for section headers, directories, and tracks
// ---------------------------------------------------------------------------

enum _EntryType { header, directory, track }

class _ListEntry {
  final _EntryType type;
  final String? headerTitle;
  final _BrowseDir? dir;
  final Track? track;
  final int? trackIndex;

  const _ListEntry._({
    required this.type,
    this.headerTitle,
    this.dir,
    this.track,
    this.trackIndex,
  });

  factory _ListEntry.header(String title) =>
      _ListEntry._(type: _EntryType.header, headerTitle: title);

  factory _ListEntry.directory(_BrowseDir dir) =>
      _ListEntry._(type: _EntryType.directory, dir: dir);

  factory _ListEntry.track(Track track, int index) =>
      _ListEntry._(type: _EntryType.track, track: track, trackIndex: index);
}

// ---------------------------------------------------------------------------
// _SectionHeader
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title,
          style: TuneFonts.footnote.copyWith(
            fontWeight: FontWeight.w600,
            color: TuneColors.textSecondary,
          )),
    );
  }
}

// ---------------------------------------------------------------------------
// _DirectoryTile — dossier navigable
// ---------------------------------------------------------------------------

class _DirectoryTile extends StatelessWidget {
  final _BrowseDir dir;
  const _DirectoryTile({required this.dir});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder_rounded,
          color: TuneColors.accent, size: 28),
      title: Text(dir.name,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dir.trackCount > 0)
            Text('${dir.trackCount}',
                style: TuneFonts.footnote),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded,
              color: TuneColors.textTertiary),
        ],
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => _BrowseDirectoryView(
          path: dir.path,
          title: dir.name,
        ),
      )),
    );
  }
}

// ---------------------------------------------------------------------------
// _TrackTile — piste jouable
// ---------------------------------------------------------------------------

class _TrackTile extends StatelessWidget {
  final Track track;
  final int index;
  final List<Track> allTracks;

  const _TrackTile({
    required this.track,
    required this.index,
    required this.allTracks,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return ListTile(
      onTap: () => app.playTracks(allTracks, startIndex: index),
      leading: const Icon(Icons.music_note_rounded,
          color: TuneColors.textTertiary, size: 24),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _subtitle,
      trailing: _buildMenu(context),
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (track.artistName != null && track.artistName!.isNotEmpty)
        track.artistName!,
      if (track.durationMs != null && track.durationMs! > 0) _formatDuration(track.durationMs!),
    ];
    if (parts.isEmpty) return null;
    return Text(parts.join(' - '),
        style: TuneFonts.footnote,
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }

  Widget _buildMenu(BuildContext context) {
    final app = context.read<AppState>();
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded,
          color: TuneColors.textTertiary, size: 20),
      color: TuneColors.surface,
      onSelected: (value) {
        switch (value) {
          case 'play':
            app.playTracks(allTracks, startIndex: index);
          case 'play_from_here':
            app.playTracks(allTracks, startIndex: index);
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'play',
          child: Text('Lire', style: TuneFonts.body),
        ),
        const PopupMenuItem(
          value: 'play_from_here',
          child: Text('Lire a partir d\'ici', style: TuneFonts.body),
        ),
      ],
    );
  }

  static String _formatDuration(int ms) {
    final s = ms ~/ 1000;
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }
}
