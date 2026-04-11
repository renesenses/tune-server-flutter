import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/database/database.dart';
import '../../server/streaming/streaming_service.dart';
import '../../state/app_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T13.3 — StreamingAlbumDetailView
// Tracklist d'un album streaming + bouton "Lire l'album".
// Chargé via StreamingService.getAlbumTracks(albumId).
// Le albumId est déduit du premier résultat (raw['album_id'] ou fallback
// sur la recherche par titre d'album).
// Miroir de StreamingAlbumDetailView.swift (iOS)
// ---------------------------------------------------------------------------

class StreamingAlbumDetailView extends StatefulWidget {
  /// Résultat de recherche dont on veut voir l'album.
  final StreamingSearchResult track;

  const StreamingAlbumDetailView({super.key, required this.track});

  @override
  State<StreamingAlbumDetailView> createState() =>
      _StreamingAlbumDetailViewState();
}

class _StreamingAlbumDetailViewState
    extends State<StreamingAlbumDetailView> {
  List<StreamingSearchResult>? _tracks;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAlbum();
  }

  Future<void> _loadAlbum() async {
    try {
      final app = context.read<AppState>();
      final service = app.engine.streamingManager
          .service(widget.track.serviceId);
      if (service == null) throw Exception('Service introuvable');

      // Tente de récupérer l'album via l'id présent dans les données brutes
      final albumId = widget.track.raw['album_id']?.toString() ??
          widget.track.raw['album']?['id']?.toString();

      List<StreamingSearchResult> tracks;

      if (albumId != null) {
        tracks = await service.getAlbumTracks(albumId);
      } else {
        // Fallback : recherche par titre d'album
        final query = widget.track.album ?? widget.track.title;
        final results = await service.search(query, limit: 50);
        tracks = results
            .where((r) => r.album == widget.track.album)
            .toList();
        if (tracks.isEmpty) tracks = results;
      }

      if (mounted) setState(() {
        _tracks = tracks;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    final app = context.read<AppState>();

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(track.album ?? track.title,
            style: TuneFonts.title3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: _AlbumHeader(track: track),
          ),

          // Bouton lecture
          if (_tracks != null && _tracks!.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(AppLocalizations.of(context).libraryPlayAlbum),
                        style: FilledButton.styleFrom(
                            backgroundColor: TuneColors.accent),
                        onPressed: () => _playAll(app),
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
                      onPressed: () => _playAll(app, shuffle: true),
                    ),
                  ],
                ),
              ),
            ),

          // Contenu
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: _ErrorState(message: _error!, onRetry: _loadAlbum),
            )
          else if (_tracks!.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(AppLocalizations.of(context).playlistEmpty,
                    style: TuneFonts.subheadline),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _StreamTrackTile(
                  index: i,
                  result: _tracks![i],
                  onTap: () => _playFrom(app, i),
                ),
                childCount: _tracks!.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Future<void> _playAll(AppState app, {bool shuffle = false}) async {
    if (_tracks == null || _tracks!.isEmpty) return;
    final list = shuffle ? (List.of(_tracks!)..shuffle()) : List.of(_tracks!);
    await app.playStreamingList(list);
  }

  Future<void> _playFrom(AppState app, int index) async {
    if (_tracks == null || index >= _tracks!.length) return;
    await app.playStreamingList(_tracks!, startIndex: index);
  }
}

// ---------------------------------------------------------------------------
// Sous-widgets
// ---------------------------------------------------------------------------

class _AlbumHeader extends StatelessWidget {
  final StreamingSearchResult track;
  const _AlbumHeader({required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ArtworkView(url: track.coverUrl, size: 120, cornerRadius: 10),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(track.album ?? track.title,
                    style: TuneFonts.title3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                if (track.artist != null) ...[
                  const SizedBox(height: 4),
                  Text(track.artist!,
                      style: TuneFonts.subheadline
                          .copyWith(color: TuneColors.accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 2),
                _ServiceBadge(serviceId: track.serviceId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  final String serviceId;
  const _ServiceBadge({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final label = switch (serviceId) {
      'qobuz'   => 'Qobuz',
      'tidal'   => 'Tidal',
      'youtube' => 'YouTube',
      _         => serviceId,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: TuneColors.textTertiary)),
    );
  }
}

class _StreamTrackTile extends StatelessWidget {
  final int index;
  final StreamingSearchResult result;
  final VoidCallback onTap;
  const _StreamTrackTile(
      {required this.index, required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: 32,
        child: Center(
          child: Text(
            '${index + 1}',
            style: TuneFonts.footnote,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      title: Text(result.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: result.artist != null
          ? Text(result.artist!,
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: result.durationMs != null
          ? Text(
              _formatDuration(result.durationMs!),
              style: TuneFonts.caption,
            )
          : null,
    );
  }

  String _formatDuration(int ms) {
    final s = ms ~/ 1000;
    final m = s ~/ 60;
    final rem = s % 60;
    return '$m:${rem.toString().padLeft(2, '0')}';
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 48, color: TuneColors.error),
          const SizedBox(height: 12),
          Text(message,
              style: TuneFonts.subheadline,
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent),
            child: Text(AppLocalizations.of(context).btnRetry),
          ),
        ],
      ),
    );
  }
}
