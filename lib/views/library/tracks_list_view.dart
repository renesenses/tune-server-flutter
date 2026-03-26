import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'add_to_playlist_sheet.dart';
import 'albums_grid_view.dart';
import 'edit_track_sheet.dart';

// ---------------------------------------------------------------------------
// T12.4 — TracksListView
// Liste des pistes avec filtres par format et qualité.
// ---------------------------------------------------------------------------

class TracksListView extends StatefulWidget {
  const TracksListView({super.key});

  @override
  State<TracksListView> createState() => _TracksListViewState();
}

class _TracksListViewState extends State<TracksListView> {
  bool _loaded = false;
  String? _formatFilter;   // null = tous, 'flac', 'mp3', etc.
  String? _qualityFilter;  // null = tous, 'hires', 'lossless', 'lossy'

  @override
  void initState() {
    super.initState();
    _ensureLoaded();
  }

  Future<void> _ensureLoaded() async {
    final lib = context.read<LibraryState>();
    if (lib.tracks.isEmpty) {
      await context.read<AppState>().refreshTracks();
    }
    if (mounted) setState(() => _loaded = true);
  }

  List<Track> _applyFilters(List<Track> tracks) {
    var result = tracks;

    if (_formatFilter != null) {
      result = result.where((t) =>
          t.format?.toLowerCase() == _formatFilter).toList();
    }

    if (_qualityFilter != null) {
      result = result.where((t) {
        final fmt = t.format?.toLowerCase() ?? '';
        final rate = t.sampleRate ?? 0;
        final depth = t.bitDepth ?? 0;
        switch (_qualityFilter) {
          case 'hires':
            return (fmt == 'flac' || fmt == 'alac' || fmt == 'wav' || fmt == 'aiff' || fmt == 'dsf' || fmt == 'dsd')
                && (rate > 48000 || depth > 16);
          case 'lossless':
            return fmt == 'flac' || fmt == 'alac' || fmt == 'wav' || fmt == 'aiff';
          case 'lossy':
            return fmt == 'mp3' || fmt == 'aac' || fmt == 'ogg' || fmt == 'opus' || fmt == 'wma';
          default:
            return true;
        }
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final allTracks = context.watch<LibraryState>().tracks;

    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (allTracks.isEmpty) {
      return LibraryEmptyState(
        icon: Icons.music_note_rounded,
        message: l.libraryEmptyTracks,
      );
    }

    // Extraire les formats disponibles
    final formats = allTracks
        .map((t) => t.format?.toLowerCase())
        .whereType<String>()
        .toSet()
        .toList()..sort();

    final filtered = _applyFilters(allTracks);

    return Column(
      children: [
        // ---- Barre de filtres ----
        _FilterBar(
          formats: formats,
          selectedFormat: _formatFilter,
          selectedQuality: _qualityFilter,
          trackCount: filtered.length,
          totalCount: allTracks.length,
          onFormatChanged: (f) => setState(() => _formatFilter = f),
          onQualityChanged: (q) => setState(() => _qualityFilter = q),
        ),
        // ---- Liste ----
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text('Aucune piste avec ce filtre',
                      style: TuneFonts.subheadline))
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1, indent: 72, color: TuneColors.divider),
                  itemBuilder: (_, i) => _TrackTile(
                    track: filtered[i],
                    onTap: () => context
                        .read<AppState>()
                        .playTracks(filtered, startIndex: i),
                    onEdit: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: TuneColors.surface,
                      builder: (_) => EditTrackSheet(track: filtered[i]),
                    ),
                    onAddToPlaylist: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: TuneColors.surface,
                      builder: (_) =>
                          AddToPlaylistSheet(track: filtered[i]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Barre de filtres
// ---------------------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  final List<String> formats;
  final String? selectedFormat;
  final String? selectedQuality;
  final int trackCount;
  final int totalCount;
  final ValueChanged<String?> onFormatChanged;
  final ValueChanged<String?> onQualityChanged;

  const _FilterBar({
    required this.formats,
    required this.selectedFormat,
    required this.selectedQuality,
    required this.trackCount,
    required this.totalCount,
    required this.onFormatChanged,
    required this.onQualityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilter = selectedFormat != null || selectedQuality != null;

    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne qualité
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip('Tous', null, selectedQuality, onQualityChanged,
                    alsoReset: onFormatChanged),
                _chip('Hi-Res', 'hires', selectedQuality, onQualityChanged,
                    color: TuneColors.accent),
                _chip('Lossless', 'lossless', selectedQuality, onQualityChanged,
                    color: Colors.tealAccent),
                _chip('Lossy', 'lossy', selectedQuality, onQualityChanged,
                    color: Colors.orangeAccent),
                const SizedBox(width: 12),
                // Chips format
                ...formats.map((f) => _chip(
                      f.toUpperCase(),
                      f,
                      selectedFormat,
                      onFormatChanged,
                      isFormat: true,
                    )),
              ],
            ),
          ),
          if (hasFilter)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '$trackCount / $totalCount pistes',
                style: TuneFonts.caption.copyWith(color: TuneColors.textTertiary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(
    String label,
    String? value,
    String? selected,
    ValueChanged<String?> onChanged, {
    Color? color,
    bool isFormat = false,
    ValueChanged<String?>? alsoReset,
  }) {
    final isSelected = value == selected;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? (color ?? TuneColors.accent)
                  : TuneColors.textSecondary,
            )),
        selected: isSelected,
        selectedColor: (color ?? TuneColors.accent).withValues(alpha: 0.15),
        backgroundColor: TuneColors.surfaceVariant,
        showCheckmark: false,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onSelected: (_) {
          if (isSelected) {
            onChanged(null);
          } else {
            onChanged(value);
            // Si on clique sur un chip qualité, reset le format et vice versa
            if (!isFormat) alsoReset?.call(null);
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TrackTile
// ---------------------------------------------------------------------------

class _TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onAddToPlaylist;

  const _TrackTile({
    required this.track,
    required this.onTap,
    required this.onEdit,
    required this.onAddToPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ArtworkView(
          filePath: track.coverPath, size: 44, cornerRadius: 4),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QualityBadge(track: track),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                size: 18, color: TuneColors.textTertiary),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (track.artistName != null) track.artistName!,
      if (track.albumTitle != null) track.albumTitle!,
    ];
    if (parts.isEmpty) return null;
    return Text(
      parts.join(' · '),
      style: TuneFonts.footnote,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      builder: (_) => _TrackMenu(
        track: track,
        onEdit: onEdit,
        onAddToPlaylist: onAddToPlaylist,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Badge qualité enrichi (format + sample rate + bit depth)
// ---------------------------------------------------------------------------

class _QualityBadge extends StatelessWidget {
  final Track track;
  const _QualityBadge({required this.track});

  @override
  Widget build(BuildContext context) {
    final fmt = track.format?.toLowerCase() ?? '';
    final rate = track.sampleRate;
    final depth = track.bitDepth;
    final isHiRes = (fmt == 'flac' || fmt == 'alac' || fmt == 'wav' || fmt == 'aiff' || fmt == 'dsf')
        && (rate != null && rate > 48000 || depth != null && depth > 16);
    final isLossless = fmt == 'flac' || fmt == 'alac' || fmt == 'wav' || fmt == 'aiff';

    // Texte du badge
    String label = fmt.toUpperCase();
    if (rate != null && rate >= 1000) {
      final kHz = rate >= 1000 ? '${(rate / 1000).toStringAsFixed(rate % 1000 == 0 ? 0 : 1)} kHz' : '$rate Hz';
      label += ' · $kHz';
    }
    if (depth != null && depth > 0) {
      label += ' · ${depth}bit';
    }

    final Color color;
    if (isHiRes) {
      color = TuneColors.accent;
    } else if (isLossless) {
      color = Colors.tealAccent;
    } else {
      color = TuneColors.textTertiary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu contextuel
// ---------------------------------------------------------------------------

class _TrackMenu extends StatelessWidget {
  final Track track;
  final VoidCallback onEdit;
  final VoidCallback onAddToPlaylist;

  const _TrackMenu({
    required this.track,
    required this.onEdit,
    required this.onAddToPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading:
                const Icon(Icons.play_arrow_rounded, color: TuneColors.accent),
            title: Text(AppLocalizations.of(context).libraryPlay, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              app.playTracks([track]);
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_rounded,
                color: TuneColors.textSecondary),
            title: Text(AppLocalizations.of(context).libraryPlayNext, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              final zoneId = app.zoneState.currentZoneId;
              if (zoneId != null) {
                final inst = app.engine.zoneManager.zone(zoneId);
                inst?.queue.addNext(track);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add_rounded,
                color: TuneColors.textSecondary),
            title: Text(AppLocalizations.of(context).playlistAddTo, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              onAddToPlaylist();
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_rounded,
                color: TuneColors.textSecondary),
            title: Text(AppLocalizations.of(context).libraryEditTrack, style: TuneFonts.body),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
