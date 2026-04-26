import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'add_to_playlist_sheet.dart';
import 'edit_album_sheet.dart';

// ---------------------------------------------------------------------------
// T12.2 — AlbumsGridView + AlbumDetailView
// Grille de covers, détail album avec tracklist + bouton lecture.
// Filter chips: Quality (DSD/Hi-Res/CD/Lossy), Format, Sample Rate.
// Miroir de AlbumsView.swift + AlbumDetailView.swift (iOS)
// ---------------------------------------------------------------------------

class AlbumsGridView extends StatelessWidget {
  const AlbumsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lib = context.watch<LibraryState>();
    final allAlbums = lib.albums;

    if (allAlbums.isEmpty) {
      return LibraryEmptyState(
        icon: Icons.album_rounded,
        message: l.libraryEmptyAlbums,
      );
    }

    final displayedAlbums = lib.filteredAlbums;
    final hasAudioInfo = lib.albumAudioInfo.isNotEmpty;

    return Column(
      children: [
        // Filter chips row
        if (hasAudioInfo) _AlbumFilterChips(lib: lib),

        // Album grid
        Expanded(
          child: displayedAlbums.isEmpty
              ? LibraryEmptyState(
                  icon: Icons.filter_list_off_rounded,
                  message: l.libraryNoFilterResults,
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: displayedAlbums.length,
                  itemBuilder: (_, i) =>
                      _AlbumCard(album: displayedAlbums[i]),
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _AlbumFilterChips — Quality / Format / Sample Rate filter row
// ---------------------------------------------------------------------------

class _AlbumFilterChips extends StatelessWidget {
  final LibraryState lib;
  const _AlbumFilterChips({required this.lib});

  static const _sampleRateThresholds = [
    (label: '44.1kHz+', minRate: 44100),
    (label: '96kHz+', minRate: 96000),
    (label: '192kHz+', minRate: 192000),
  ];

  @override
  Widget build(BuildContext context) {
    final formats = lib.availableFormats;
    final hasFilters = lib.hasActiveFilters;

    return Container(
      color: TuneColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                // Clear all button
                if (hasFilters) ...[
                  ActionChip(
                    avatar: const Icon(Icons.clear_rounded, size: 16),
                    label: const Text('Clear'),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      color: TuneColors.textSecondary,
                    ),
                    backgroundColor: TuneColors.surfaceVariant,
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                    onPressed: lib.clearFilters,
                  ),
                  const SizedBox(width: 6),
                ],

                // Quality chips
                for (final quality in AudioQuality.values) ...[
                  _buildQualityChip(quality),
                  const SizedBox(width: 6),
                ],

                // Divider
                if (formats.isNotEmpty) ...[
                  Container(
                    width: 1,
                    height: 24,
                    color: TuneColors.divider,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ],

                // Format chips
                for (final fmt in formats) ...[
                  _buildFormatChip(fmt),
                  const SizedBox(width: 6),
                ],

                // Sample rate chips (with divider if any are visible)
                if (_sampleRateThresholds.any(
                    (sr) => lib.countForMinSampleRate(sr.minRate) > 0)) ...[
                  Container(
                    width: 1,
                    height: 24,
                    color: TuneColors.divider,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  for (final sr in _sampleRateThresholds)
                    if (lib.countForMinSampleRate(sr.minRate) > 0) ...[
                      _buildSampleRateChip(sr.label, sr.minRate),
                      const SizedBox(width: 6),
                    ],
                ],
              ],
            ),
          ),

          // Result count when filters active
          if (hasFilters)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 6),
              child: Text(
                '${lib.filteredAlbums.length} / ${lib.albums.length} albums',
                style: TuneFonts.caption,
              ),
            ),

          const Divider(height: 1, color: TuneColors.divider),
        ],
      ),
    );
  }

  Widget _buildQualityChip(AudioQuality quality) {
    final count = lib.countForQuality(quality);
    if (count == 0) return const SizedBox.shrink();
    final selected = lib.selectedQuality == quality;

    return FilterChip(
      label: Text('${quality.label} ($count)'),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        color: selected ? TuneColors.textPrimary : TuneColors.textSecondary,
      ),
      selected: selected,
      selectedColor: _qualityColor(quality).withValues(alpha: 0.25),
      backgroundColor: TuneColors.surfaceVariant,
      checkmarkColor: _qualityColor(quality),
      side: selected
          ? BorderSide(color: _qualityColor(quality).withValues(alpha: 0.5))
          : BorderSide.none,
      visualDensity: VisualDensity.compact,
      showCheckmark: false,
      avatar: selected
          ? Icon(Icons.check_rounded, size: 14, color: _qualityColor(quality))
          : null,
      onSelected: (_) => lib.setQualityFilter(quality),
    );
  }

  Widget _buildFormatChip(String format) {
    final count = lib.countForFormat(format);
    if (count == 0) return const SizedBox.shrink();
    final selected = lib.selectedFormat == format;

    return FilterChip(
      label: Text('$format ($count)'),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        color: selected ? TuneColors.textPrimary : TuneColors.textSecondary,
      ),
      selected: selected,
      selectedColor: TuneColors.accent.withValues(alpha: 0.25),
      backgroundColor: TuneColors.surfaceVariant,
      checkmarkColor: TuneColors.accent,
      side: selected
          ? BorderSide(color: TuneColors.accent.withValues(alpha: 0.5))
          : BorderSide.none,
      visualDensity: VisualDensity.compact,
      showCheckmark: false,
      avatar: selected
          ? const Icon(Icons.check_rounded,
              size: 14, color: TuneColors.accent)
          : null,
      onSelected: (_) => lib.setFormatFilter(format),
    );
  }

  Widget _buildSampleRateChip(String label, int minRate) {
    final count = lib.countForMinSampleRate(minRate);
    final selected = lib.selectedMinSampleRate == minRate;

    return FilterChip(
      label: Text('$label ($count)'),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        color: selected ? TuneColors.textPrimary : TuneColors.textSecondary,
      ),
      selected: selected,
      selectedColor: TuneColors.accentLight.withValues(alpha: 0.25),
      backgroundColor: TuneColors.surfaceVariant,
      checkmarkColor: TuneColors.accentLight,
      side: selected
          ? BorderSide(
              color: TuneColors.accentLight.withValues(alpha: 0.5))
          : BorderSide.none,
      visualDensity: VisualDensity.compact,
      showCheckmark: false,
      avatar: selected
          ? const Icon(Icons.check_rounded,
              size: 14, color: TuneColors.accentLight)
          : null,
      onSelected: (_) => lib.setSampleRateFilter(minRate),
    );
  }

  Color _qualityColor(AudioQuality quality) {
    switch (quality) {
      case AudioQuality.dsd:   return const Color(0xFFFFD700); // gold
      case AudioQuality.hiRes: return TuneColors.accent;
      case AudioQuality.cd:    return TuneColors.success;
      case AudioQuality.lossy: return TuneColors.textSecondary;
    }
  }
}

class _AlbumCard extends StatelessWidget {
  final Album album;
  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AlbumDetailView(album: album)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pochette carrée
          Expanded(
            child: LayoutBuilder(
              builder: (_, c) => ArtworkView(
                filePath: album.coverPath,
                size: c.maxWidth,
                cornerRadius: 8,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(album.title,
              style: TuneFonts.callout,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (album.artistName != null)
            Text(album.artistName!,
                style: TuneFonts.footnote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AlbumDetailView
// ---------------------------------------------------------------------------

class AlbumDetailView extends StatefulWidget {
  final Album album;
  const AlbumDetailView({super.key, required this.album});

  @override
  State<AlbumDetailView> createState() => _AlbumDetailViewState();
}

class _AlbumDetailViewState extends State<AlbumDetailView> {
  List<Track>? _tracks;
  int _rating = 0;
  bool _isFav = false;
  List<dynamic>? _collections;

  @override
  void initState() {
    super.initState();
    _loadTracks();
    _loadRating();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final data = await app.apiClient!.getCollections();
      if (mounted) setState(() => _collections = data);
    } catch (_) {}
  }

  Future<void> _quickFavAlbum() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      await app.apiClient!.quickFavAlbum(widget.album.id);
      if (mounted) {
        setState(() => _isFav = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Favorite error: $e')),
        );
      }
    }
  }

  void _showAddToCollection() {
    if (_collections == null || _collections!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No collections yet')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _AddToCollectionSheet(
        albumId: widget.album.id,
        collections: _collections!,
      ),
    );
  }

  Future<void> _loadRating() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    try {
      final data = await app.apiClient!.getAlbumRating(widget.album.id);
      if (mounted) setState(() => _rating = (data['rating'] as num?)?.toInt() ?? 0);
    } catch (_) {}
  }

  Future<void> _setRating(int value) async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    final newRating = value == _rating ? 0 : value; // tap same star to clear
    setState(() => _rating = newRating);
    try {
      await app.apiClient!.rateAlbum(widget.album.id, newRating);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rating error: $e')),
        );
      }
    }
  }

  void _showAlbumBio(BuildContext context, Album album) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AlbumBioSheet(albumId: album.id, albumTitle: album.title),
    );
  }

  Future<void> _loadTracks() async {
    final app = context.read<AppState>();
    if (app.isRemoteMode && app.apiClient != null) {
      try {
        final data = await app.apiClient!.getAlbumTracks(widget.album.id);
        final tracks = data.map((t) => trackFromJson(t as Map<String, dynamic>)).toList();
        if (mounted) setState(() => _tracks = tracks);
      } catch (e) {
        debugPrint('[Remote] loadAlbumTracks error: $e');
      }
      return;
    }
    final tracks =
        await app.engine.db.trackRepo.forAlbum(widget.album.id);
    if (mounted) setState(() => _tracks = tracks);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final album = widget.album;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(album.title,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        actions: [
          // Quick Fav
          IconButton(
            icon: Icon(
              _isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFav ? TuneColors.accent : null,
            ),
            tooltip: 'Quick Favorite',
            onPressed: _quickFavAlbum,
          ),
          // Add to Collection
          IconButton(
            icon: const Icon(Icons.collections_bookmark_rounded),
            tooltip: 'Add to Collection',
            onPressed: _showAddToCollection,
          ),
          IconButton(
            icon: const Icon(Icons.notes_rounded),
            tooltip: 'Album notes',
            onPressed: () => _showAlbumBio(context, album),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: TuneColors.surface,
              builder: (_) => EditAlbumSheet(album: album),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header artwork + méta
          SliverToBoxAdapter(child: _AlbumHeader(album: album)),

          // Star rating
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () => _setRating(i),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          i <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: i <= _rating ? TuneColors.accent : TuneColors.textTertiary,
                          size: 28,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (_rating > 0)
                    Text(
                      '$_rating/5',
                      style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
                    ),
                ],
              ),
            ),
          ),

          // Boutons lecture
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(AppLocalizations.of(context).libraryPlayAlbum),
                      style: FilledButton.styleFrom(
                          backgroundColor: TuneColors.accent),
                      onPressed: _tracks == null || _tracks!.isEmpty
                          ? null
                          : () => app.playTracks(_tracks!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.shuffle_rounded),
                    label: Text(AppLocalizations.of(context).btnShuffle),
                    style: FilledButton.styleFrom(
                      backgroundColor: TuneColors.surfaceVariant,
                      foregroundColor: TuneColors.textPrimary,
                    ),
                    onPressed: _tracks == null || _tracks!.isEmpty
                        ? null
                        : () async {
                            await app.setShuffle(enabled: true);
                            final shuffled = List.of(_tracks!)..shuffle();
                            await app.playTracks(shuffled);
                          },
                  ),
                ],
              ),
            ),
          ),

          // Pistes
          if (_tracks == null)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_tracks!.isEmpty)
            SliverFillRemaining(
              child: LibraryEmptyState(
                  icon: Icons.music_off_rounded,
                  message: AppLocalizations.of(context).playlistEmpty),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _AlbumTrackTile(
                  track: _tracks![i],
                  onTap: () => app.playTracks(_tracks!, startIndex: i),
                  onAddToPlaylist: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: TuneColors.surface,
                    builder: (_) =>
                        AddToPlaylistSheet(track: _tracks![i]),
                  ),
                ),
                childCount: _tracks!.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sous-widgets privés
// ---------------------------------------------------------------------------

class _AlbumHeader extends StatelessWidget {
  final Album album;
  const _AlbumHeader({required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ArtworkView(filePath: album.coverPath, size: 120, cornerRadius: 10),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(album.title,
                    style: TuneFonts.title3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                if (album.artistName != null) ...[
                  const SizedBox(height: 4),
                  Text(album.artistName!,
                      style: TuneFonts.subheadline
                          .copyWith(color: TuneColors.accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
                if (album.year != null) ...[
                  const SizedBox(height: 2),
                  Text(album.year.toString(), style: TuneFonts.caption),
                ],
                if (album.genre != null) ...[
                  const SizedBox(height: 2),
                  Text(album.genre!, style: TuneFonts.caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumTrackTile extends StatefulWidget {
  final Track track;
  final VoidCallback onTap;
  final VoidCallback onAddToPlaylist;

  const _AlbumTrackTile({
    required this.track,
    required this.onTap,
    required this.onAddToPlaylist,
  });

  @override
  State<_AlbumTrackTile> createState() => _AlbumTrackTileState();
}

class _AlbumTrackTileState extends State<_AlbumTrackTile> {
  bool _showCredits = false;
  List<Map<String, dynamic>>? _credits;

  void _toggleCredits() async {
    setState(() => _showCredits = !_showCredits);
    if (_showCredits && _credits == null && widget.track.id != null) {
      final app = Provider.of<AppState>(context, listen: false);
      if (app.apiClient != null) {
        try {
          final result = await app.apiClient!.getTrackCredits(widget.track.id!);
          if (mounted) setState(() => _credits = result.cast<Map<String, dynamic>>());
        } catch (_) {
          if (mounted) setState(() => _credits = []);
        }
      }
    }
  }

  String _localizeRole(String role) {
    switch (role) {
      case 'performer': return 'Musicien';
      case 'composer': return 'Compositeur';
      case 'conductor': return "Chef d'orch.";
      case 'lyricist': return 'Parolier';
      case 'producer': return 'Producteur';
      default: return role[0].toUpperCase() + role.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: widget.onTap,
          leading: SizedBox(
            width: 32,
            child: Center(
              child: Text(
                widget.track.trackNumber?.toString() ?? '–',
                style: TuneFonts.footnote,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          title: Text(widget.track.title,
              style: TuneFonts.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: widget.track.artistName != null
              ? Text(widget.track.artistName!,
                  style: TuneFonts.footnote,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormatBadge(format: widget.track.format),
              IconButton(
                icon: Icon(Icons.people_outline_rounded,
                    size: 16,
                    color: _showCredits ? TuneColors.accent : TuneColors.textTertiary),
                onPressed: _toggleCredits,
                tooltip: 'Crédits',
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded,
                    size: 18, color: TuneColors.textTertiary),
                onPressed: widget.onAddToPlaylist,
              ),
            ],
          ),
        ),
        if (_showCredits && _credits != null && _credits!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 64, right: 16, bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _credits!.map((c) {
                final name = c['artist_name'] ?? '';
                final instrument = c['instrument'];
                final role = c['role'] ?? 'performer';
                return Chip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    instrument != null ? '$name ($instrument)' : name,
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: TuneColors.accent.withOpacity(0.08),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                );
              }).toList(),
            ),
          ),
        if (_showCredits && _credits != null && _credits!.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 64, bottom: 8),
            child: Text('Aucun crédit', style: TextStyle(fontSize: 11, color: TuneColors.textTertiary)),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Album Bio Sheet
// ---------------------------------------------------------------------------

class _AlbumBioSheet extends StatefulWidget {
  final int albumId;
  final String albumTitle;
  const _AlbumBioSheet({required this.albumId, required this.albumTitle});

  @override
  State<_AlbumBioSheet> createState() => _AlbumBioSheetState();
}

class _AlbumBioSheetState extends State<_AlbumBioSheet> {
  String? _bio;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBio();
  }

  Future<void> _loadBio() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() { _loading = false; _error = 'Not connected'; });
      return;
    }
    try {
      final data = await api.getAlbumBio(widget.albumId);
      if (!mounted) return;
      setState(() {
        _bio = data['bio'] as String? ?? data['review'] as String? ?? data['summary'] as String?;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'No album notes available'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(widget.albumTitle,
                style: TuneFonts.title3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: TuneFonts.subheadline))
                    : _bio == null || _bio!.isEmpty
                        ? Center(child: Text('No notes available',
                            style: TuneFonts.subheadline))
                        : SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            child: Text(_bio!,
                                style: TuneFonts.body.copyWith(height: 1.5)),
                          ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets partagés (publics — réutilisés par les autres vues bibliothèque)
// ---------------------------------------------------------------------------

/// Badge de format audio (FLAC, MP3, AAC…). Hi-res = couleur accent.
class FormatBadge extends StatelessWidget {
  final String? format;
  const FormatBadge({super.key, this.format});

  @override
  Widget build(BuildContext context) {
    if (format == null) return const SizedBox.shrink();
    final lo = format!.toLowerCase();
    final isHiRes = lo == 'flac' || lo == 'alac';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHiRes
            ? TuneColors.accent.withValues(alpha: 0.15)
            : TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        format!.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color:
              isHiRes ? TuneColors.accentLight : TuneColors.textTertiary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Add to Collection bottom sheet
// ---------------------------------------------------------------------------

class _AddToCollectionSheet extends StatelessWidget {
  final int albumId;
  final List<dynamic> collections;

  const _AddToCollectionSheet({
    required this.albumId,
    required this.collections,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Add to Collection', style: TuneFonts.title3),
          const SizedBox(height: 12),
          ...collections.map((c) {
            final col = c as Map<String, dynamic>;
            final name = col['name'] as String? ?? '';
            final colorHex = col['color'] as String? ?? '#6366f1';
            final colId = col['id'] as int;
            final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
            return ListTile(
              leading: Container(
                width: 12, height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              title: Text(name, style: TuneFonts.body),
              onTap: () async {
                Navigator.pop(context);
                final app = context.read<AppState>();
                if (app.apiClient == null) return;
                try {
                  await app.apiClient!.addAlbumToCollection(colId, albumId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to $name')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Empty state générique bibliothèque.
class LibraryEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const LibraryEmptyState(
      {super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(message, style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}
