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
import 'albums_grid_view.dart';

// ---------------------------------------------------------------------------
// T12.3 — ArtistsListView + ArtistDetailView
// Liste des artistes alphabétique ; détail = horizontal scroll albums + pistes.
// Miroir de ArtistsView.swift + ArtistDetailView.swift (iOS)
// ---------------------------------------------------------------------------

class ArtistsListView extends StatelessWidget {
  const ArtistsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final artists = context.watch<LibraryState>().artists;
    if (artists.isEmpty) {
      return LibraryEmptyState(
        icon: Icons.people_rounded,
        message: l.libraryEmptyArtists,
      );
    }
    return ListView.separated(
      itemCount: artists.length,
      separatorBuilder: (_, __) => const Divider(
          height: 1, indent: 72, color: TuneColors.divider),
      itemBuilder: (_, i) => _ArtistTile(artist: artists[i]),
    );
  }
}

class _ArtistTile extends StatelessWidget {
  final Artist artist;
  const _ArtistTile({required this.artist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: TuneColors.surfaceVariant,
        child: artist.imagePath != null
            ? ClipOval(
                child: ArtworkView(
                    filePath: artist.imagePath, size: 44, cornerRadius: 22),
              )
            : const Icon(Icons.person_rounded,
                color: TuneColors.textTertiary),
      ),
      title: Text(artist.name,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ArtistDetailView(artist: artist)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ArtistDetailView — enriched with metadata from /api/v1/artists/:id/metadata
// ---------------------------------------------------------------------------

class ArtistDetailView extends StatefulWidget {
  final Artist artist;
  const ArtistDetailView({super.key, required this.artist});

  @override
  State<ArtistDetailView> createState() => _ArtistDetailViewState();
}

class _ArtistDetailViewState extends State<ArtistDetailView> {
  List<Album>? _albums;
  List<Track>? _tracks;
  Map<String, dynamic>? _metadata;
  bool _metadataLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final app = context.read<AppState>();

    // Load albums + tracks
    if (app.isRemoteMode && app.apiClient != null) {
      try {
        final albumsJson = await app.apiClient!.getArtistAlbums(widget.artist.id);
        final tracksJson = await app.apiClient!.getArtistTracks(widget.artist.id);
        if (mounted) setState(() {
          _albums = albumsJson.map((a) => albumFromJson(a as Map<String, dynamic>)).toList();
          _tracks = tracksJson.map((t) => trackFromJson(t as Map<String, dynamic>)).toList();
        });
      } catch (e) {
        debugPrint('[Remote] loadArtistData error: $e');
      }
    } else {
      final results = await Future.wait([
        app.engine.db.albumRepo.forArtist(widget.artist.id),
        app.engine.db.trackRepo.forArtist(widget.artist.id),
      ]);
      if (mounted) {
        setState(() {
          _albums = results[0] as List<Album>;
          _tracks = results[1] as List<Track>;
        });
      }
    }

    // Load metadata (remote mode only — needs API)
    if (app.isRemoteMode && app.apiClient != null) {
      try {
        final meta = await app.apiClient!.getArtistMetadata(widget.artist.id);
        if (mounted) setState(() {
          _metadata = meta;
          _metadataLoading = false;
        });
      } catch (e) {
        debugPrint('[Remote] loadArtistMetadata error: $e');
        if (mounted) setState(() => _metadataLoading = false);
      }
    } else {
      if (mounted) setState(() => _metadataLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final artist = widget.artist;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(artist.name,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      body: _albums == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // --- Artist header with image + name + origin ---
                SliverToBoxAdapter(child: _ArtistHeader(
                  artist: artist,
                  metadata: _metadata,
                )),

                // --- Enrichment status ---
                if (_metadataLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (_metadata != null &&
                    _metadata!['enrichment_status'] == 'pending')
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(l.artistEnriching,
                              style: TuneFonts.footnote),
                        ],
                      ),
                    ),
                  ),

                // --- Bio ---
                if (_metadata != null &&
                    _metadata!['bio_fr'] != null &&
                    (_metadata!['bio_fr'] as String).isNotEmpty) ...[
                  _sectionHeader(l.artistBio),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _metadata!['bio_fr'] as String,
                        style: TuneFonts.body.copyWith(
                            color: TuneColors.textSecondary),
                      ),
                    ),
                  ),
                ],

                // --- Anecdotes ---
                if (_metadata != null &&
                    _metadata!['anecdotes'] != null &&
                    (_metadata!['anecdotes'] as List).isNotEmpty)
                  SliverToBoxAdapter(
                    child: _ExpandableSection(
                      title: l.artistAnecdotes,
                      children: (_metadata!['anecdotes'] as List)
                          .map((a) => a.toString())
                          .toList(),
                    ),
                  ),

                // --- Artistes similaires ---
                if (_metadata != null &&
                    _metadata!['similar_artists'] != null &&
                    (_metadata!['similar_artists'] as List).isNotEmpty)
                  SliverToBoxAdapter(
                    child: _SimilarArtistsSection(
                      title: l.artistSimilarArtists,
                      artists: (_metadata!['similar_artists'] as List)
                          .cast<Map<String, dynamic>>(),
                      libraryArtists:
                          context.read<LibraryState>().artists,
                    ),
                  ),

                // --- Membres ---
                if (_metadata != null &&
                    _metadata!['members'] != null &&
                    (_metadata!['members'] as List).isNotEmpty)
                  SliverToBoxAdapter(
                    child: _ExpandableSection(
                      title: l.artistMembers,
                      children: (_metadata!['members'] as List)
                          .map((m) => m.toString())
                          .toList(),
                    ),
                  ),

                // --- Discographie ---
                if (_metadata != null &&
                    _metadata!['discography'] != null &&
                    (_metadata!['discography'] as List).isNotEmpty)
                  SliverToBoxAdapter(
                    child: _ExpandableSection(
                      title: l.artistDiscography,
                      children: (_metadata!['discography'] as List)
                          .map((d) {
                        if (d is Map<String, dynamic>) {
                          final title = d['title'] ?? '';
                          final year = d['year']?.toString() ?? '';
                          return year.isNotEmpty
                              ? '$title ($year)'
                              : title.toString();
                        }
                        return d.toString();
                      }).toList(),
                    ),
                  ),

                // --- Albums from library ---
                if (_albums!.isNotEmpty) ...[
                  _sectionHeader('Albums'),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _albums!.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            _AlbumCard(album: _albums![i]),
                      ),
                    ),
                  ),
                ],

                // --- Pistes ---
                if (_tracks != null && _tracks!.isNotEmpty) ...[
                  _sectionHeader(
                      '${_tracks!.length} piste${_tracks!.length > 1 ? "s" : ""}'),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _ArtistTrackTile(
                        track: _tracks![i],
                        onTap: () => context
                            .read<AppState>()
                            .playTracks(_tracks!, startIndex: i),
                      ),
                      childCount: _tracks!.length,
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(title, style: TuneFonts.title3),
        ),
      );
}

// ---------------------------------------------------------------------------
// _ArtistHeader — large image + name + origin + period
// ---------------------------------------------------------------------------

class _ArtistHeader extends StatelessWidget {
  final Artist artist;
  final Map<String, dynamic>? metadata;
  const _ArtistHeader({required this.artist, this.metadata});

  @override
  Widget build(BuildContext context) {
    final imageUrl = metadata?['image_url'] as String?;
    final origin = metadata?['origin'] as String?;
    final period = metadata?['period'] as String?;
    final initials = artist.name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Artist image
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipOval(
              child: Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _initialsAvatar(initials),
              ),
            )
          else if (artist.imagePath != null)
            ClipOval(
              child: ArtworkView(
                  filePath: artist.imagePath,
                  size: 120,
                  cornerRadius: 60),
            )
          else
            _initialsAvatar(initials),
          const SizedBox(height: 12),
          // Name
          Text(artist.name,
              style: TuneFonts.title1,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          // Origin + Period
          if (origin != null || period != null) ...[
            const SizedBox(height: 4),
            Text(
              [if (origin != null) origin, if (period != null) period]
                  .join(' \u2022 '),
              style: TuneFonts.subheadline,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _initialsAvatar(String initials) => CircleAvatar(
        radius: 60,
        backgroundColor: TuneColors.surfaceVariant,
        child: Text(
          initials.isEmpty ? '?' : initials,
          style: TuneFonts.title1
              .copyWith(color: TuneColors.textTertiary),
        ),
      );
}

// ---------------------------------------------------------------------------
// _ExpandableSection — collapsible list of strings
// ---------------------------------------------------------------------------

class _ExpandableSection extends StatefulWidget {
  final String title;
  final List<String> children;
  const _ExpandableSection({required this.title, required this.children});

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                Expanded(
                    child: Text(widget.title, style: TuneFonts.title3)),
                Icon(
                  _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: TuneColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children
                  .map((text) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(text,
                            style: TuneFonts.body.copyWith(
                                color: TuneColors.textSecondary)),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _SimilarArtistsSection — tappable chips for similar artists
// ---------------------------------------------------------------------------

class _SimilarArtistsSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> artists;
  final List<Artist> libraryArtists;
  const _SimilarArtistsSection({
    required this.title,
    required this.artists,
    required this.libraryArtists,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(title, style: TuneFonts.title3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: artists.map((similar) {
              final name = similar['name'] as String? ?? '';
              // Check if this artist exists in the library
              final libraryMatch = libraryArtists
                  .where((a) =>
                      a.name.toLowerCase() == name.toLowerCase())
                  .toList();
              final inLibrary = libraryMatch.isNotEmpty;

              return ActionChip(
                label: Text(name),
                labelStyle: TextStyle(
                  fontSize: 13,
                  color: inLibrary
                      ? TuneColors.accent
                      : TuneColors.textSecondary,
                ),
                backgroundColor: inLibrary
                    ? TuneColors.accent.withValues(alpha: 0.15)
                    : TuneColors.surfaceVariant,
                side: BorderSide.none,
                onPressed: inLibrary
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArtistDetailView(
                                artist: libraryMatch.first),
                          ),
                        )
                    : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sous-widgets
// ---------------------------------------------------------------------------

class _AlbumCard extends StatelessWidget {
  final Album album;
  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AlbumDetailView(album: album)),
      ),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArtworkView(
                filePath: album.coverPath, size: 130, cornerRadius: 8),
            const SizedBox(height: 4),
            Text(album.title,
                style: TuneFonts.footnote
                    .copyWith(color: TuneColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (album.year != null)
              Text(album.year.toString(), style: TuneFonts.caption),
          ],
        ),
      ),
    );
  }
}

class _ArtistTrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  const _ArtistTrackTile({required this.track, required this.onTap});

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
      subtitle: track.albumTitle != null
          ? Text(track.albumTitle!,
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: FormatBadge(format: track.format),
    );
  }
}
