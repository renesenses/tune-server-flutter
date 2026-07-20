import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/enums.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../../state/settings_state.dart';
import '../../state/zone_state.dart';
import '../../widgets/metadata_chips.dart';
import '../helpers/artwork_view.dart';
import '../helpers/skip_button.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/add_to_playlist_sheet.dart';
import '../library/albums_grid_view.dart';
import '../library/artists_list_view.dart';
import '../nowplaying/seek_bar_view.dart';
import '../nowplaying/sleep_timer_sheet.dart';
import '../nowplaying/smart_autoplay_sheet.dart';
import '../nowplaying/volume_control_view.dart';
import '../nowplaying/zone_management_view.dart';
import '../streaming/streaming_helpers.dart';

// ---------------------------------------------------------------------------
// PlayerSheet — unified mini / now-playing / queue bottom sheet
//
// 3 snap stops (as fractions of screen height):
//   _kMini     (~8%)   — collapsed mini player
//   _kNowPlaying(~52%) — Now Playing with artwork + transport
//   _kQueue    (~95%)  — full queue list
//
// Drag up to expand, drag/swipe down to collapse.
// Replaces MiniPlayerView + showNowPlaying() modal on iPhone.
// ---------------------------------------------------------------------------

const double _kMini = 0.09;
const double _kNowPlaying = 0.52;
const double _kQueue = 0.95;

/// Wraps the app content in a [Stack] with the [PlayerSheet] overlaid on top.
/// Insert this as the [body] of the iPhone scaffold.
class PlayerSheetScaffold extends StatelessWidget {
  final Widget child;

  /// Bottom padding applied to the player sheet only (not the content), so the
  /// mini-player floats ABOVE a persistent bottom bar — the iPhone tab bar —
  /// instead of covering it. Non-zero when the sheet is mounted globally (above
  /// the Navigator, so the mini-player survives sub-page pushes into folders —
  /// Rhorn, #1088): the inset equals the tab-bar height.
  final double sheetBottomInset;

  const PlayerSheetScaffold({
    super.key,
    required this.child,
    this.sheetBottomInset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Expand to the incoming (full-body) constraints. Without this the Stack
      // uses StackFit.loose and sizes itself to its only non-positioned child,
      // PlayerSheet — which collapses to SizedBox.shrink() when nothing is
      // playing. The Stack then shrank to zero height, the Positioned.fill
      // content got zero constraints, and the whole portrait screen was BLACK
      // on launch when no track was playing (Fabien, Android portrait; landscape
      // uses the iPad layout which has no PlayerSheetScaffold, hence never black).
      fit: StackFit.expand,
      children: [
        // Main content — pad bottom so content is never hidden behind mini player
        Positioned.fill(child: child),
        // Unified player sheet, padded up by sheetBottomInset so it clears a
        // persistent tab bar underneath (see field doc).
        Padding(
          padding: EdgeInsets.only(bottom: sheetBottomInset),
          child: const PlayerSheet(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// PlayerSheet
// ---------------------------------------------------------------------------

class PlayerSheet extends StatefulWidget {
  const PlayerSheet({super.key});

  @override
  State<PlayerSheet> createState() => _PlayerSheetState();
}

class _PlayerSheetState extends State<PlayerSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasTrack = context.select<ZoneState, bool>(
        (z) => z.currentTrack != null);
    final state = context.select<ZoneState, PlaybackState>(
        (z) => z.playbackState);

    if (!hasTrack && state == PlaybackState.stopped) {
      return const SizedBox.shrink();
    }

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: _kMini,
      minChildSize: _kMini,
      maxChildSize: _kQueue,
      snap: true,
      snapSizes: const [_kMini, _kNowPlaying, _kQueue],
      builder: (context, scrollController) {
        return _PlayerSheetContent(
          scrollController: scrollController,
          sheetController: _controller,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet content — switches between mini / now-playing / queue appearance
// ---------------------------------------------------------------------------

class _PlayerSheetContent extends StatelessWidget {
  final ScrollController scrollController;
  final DraggableScrollableController sheetController;

  const _PlayerSheetContent({
    required this.scrollController,
    required this.sheetController,
  });

  /// Fraction of the screen height currently occupied by the sheet.
  double _size(BuildContext context) {
    if (!sheetController.isAttached) return _kMini;
    return sheetController.size;
  }

  @override
  Widget build(BuildContext context) {
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;

    return AnimatedBuilder(
      animation: sheetController,
      builder: (context, _) {
        final currentSize = _size(context);
        final currentNpProgress = ((currentSize - _kMini) / (_kNowPlaying - _kMini)).clamp(0.0, 1.0);
        final currentQueueProgress = ((currentSize - _kNowPlaying) / (_kQueue - _kNowPlaying)).clamp(0.0, 1.0);
        final currentIsMini = currentSize < (_kMini + (_kNowPlaying - _kMini) * 0.3);
        final currentIsQueue = currentSize > (_kNowPlaying + (_kQueue - _kNowPlaying) * 0.5);

        return _SheetBody(
          track: track,
          scrollController: scrollController,
          sheetController: sheetController,
          npProgress: currentNpProgress,
          queueProgress: currentQueueProgress,
          isMini: currentIsMini,
          isQueue: currentIsQueue,
        );
      },
    );
  }
}

class _SheetBody extends StatelessWidget {
  final Track? track;
  final ScrollController scrollController;
  final DraggableScrollableController sheetController;
  final double npProgress;
  final double queueProgress;
  final bool isMini;
  final bool isQueue;

  const _SheetBody({
    required this.track,
    required this.scrollController,
    required this.sheetController,
    required this.npProgress,
    required this.queueProgress,
    required this.isMini,
    required this.isQueue,
  });

  @override
  Widget build(BuildContext context) {
    final coverPath = track?.coverPath;
    final isHttp = coverPath != null && coverPath.startsWith('http');

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16 * (1 - queueProgress * 0.7)),
      ),
      child: Stack(
        children: [
          // Background: blurred artwork when expanded, solid when mini
          Positioned.fill(
            child: isMini
                ? ColoredBox(color: TuneColors.miniPlayerBg)
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(color: TuneColors.background),
                      if (coverPath != null)
                        ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                          child: Opacity(
                            opacity: npProgress,
                            child: isHttp
                                ? Image.network(coverPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) =>
                                        const SizedBox.shrink())
                                : Image.file(File(coverPath),
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) =>
                                        const SizedBox.shrink()),
                          ),
                        ),
                      ColoredBox(
                        color: Colors.black.withValues(
                            alpha: 0.65 * npProgress)),
                    ],
                  ),
          ),

          // Scrollable content
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle — always visible at top
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isMini
                              ? TuneColors.textTertiary
                              : TuneColors.textTertiary
                                  .withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Mini player row (fades out as we expand)
                    if (npProgress < 0.8)
                      Opacity(
                        opacity: (1 - npProgress / 0.8).clamp(0.0, 1.0),
                        child: _MiniRow(
                          track: track,
                          sheetController: sheetController,
                        ),
                      ),

                    // Now Playing content (fades in as we expand, fades out as we go to queue)
                    if (npProgress > 0.1)
                      Opacity(
                        opacity: (npProgress * (1 - queueProgress * 0.3))
                            .clamp(0.0, 1.0),
                        child: _NowPlayingSection(
                          track: track,
                          sheetController: sheetController,
                        ),
                      ),

                    // Queue section header + list (fades in as we go toward queue)
                    if (queueProgress > 0.05)
                      Opacity(
                        opacity: queueProgress.clamp(0.0, 1.0),
                        child: const _QueueSection(),
                      ),

                    // Bottom safe area padding
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mini row — compact track info + transport (shown when nearly collapsed)
// ---------------------------------------------------------------------------

class _MiniRow extends StatelessWidget {
  final Track? track;
  final DraggableScrollableController sheetController;
  const _MiniRow({required this.track, required this.sheetController});

  /// Expand the sheet to the now-playing snap, which exposes the full
  /// interactive seek bar and the volume control. Tapping the track (or the
  /// volume icon) opens it — the 2px mini progress bar itself is not seekable
  /// (Fabien: "barre trop petite, impossible d'avancer" + "il faudrait une
  /// icône volume", Android v0.8.336).
  void _expand() {
    if (!sheetController.isAttached) return;
    sheetController.animateTo(
      _kNowPlaying,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final state =
        context.select<ZoneState, PlaybackState>((z) => z.playbackState);
    final isPlaying = state == PlaybackState.playing;
    final isBuffering = state == PlaybackState.buffering;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              // Tap the artwork + title area to open the full player (seek +
              // volume live in the now-playing section).
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _expand,
                  child: Row(
                    children: [
                      ArtworkView(
                        filePath: track?.coverPath,
                        size: 44,
                        cornerRadius: 6,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              track?.title ?? 'No track',
                              style: TuneFonts.miniTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (track?.artistName != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                track!.artistName!,
                                style: TuneFonts.miniArtist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded),
                iconSize: 22,
                color: TuneColors.textPrimary,
                tooltip: 'Volume',
                onPressed: _expand,
              ),
              SkipButton(
                isForward: false,
                size: 20,
                color: TuneColors.textPrimary,
                onPressed: () => app.previous(),
              ),
              if (isBuffering)
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.accent),
                    ),
                  ),
                )
              else
                IconButton(
                  icon: Icon(isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                  iconSize: 32,
                  color: TuneColors.textPrimary,
                  tooltip: isPlaying ? 'Pause' : 'Play',
                  onPressed:
                      isPlaying ? () => app.pause() : () => app.resume(),
                ),
              SkipButton(
                isForward: true,
                size: 20,
                color: TuneColors.textPrimary,
                onPressed: () => app.next(),
              ),
            ],
          ),
        ),
        // Progress bar at bottom of mini player
        _MiniProgressBar(),
      ],
    );
  }
}

class _MiniProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final positionMs =
        context.select<ZoneState, int>((z) => z.positionMs);
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;
    final durationMs = track?.durationMs ?? 0;
    final progress =
        durationMs > 0 ? (positionMs / durationMs).clamp(0.0, 1.0) : 0.0;

    return LinearProgressIndicator(
      value: progress,
      minHeight: 2,
      backgroundColor: TuneColors.divider,
      valueColor: const AlwaysStoppedAnimation<Color>(TuneColors.accent),
    );
  }
}

// ---------------------------------------------------------------------------
// Now Playing section — artwork, track info, transport
// ---------------------------------------------------------------------------

class _NowPlayingSection extends StatelessWidget {
  final Track? track;
  final DraggableScrollableController sheetController;

  const _NowPlayingSection({
    required this.track,
    required this.sheetController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),

          // Large artwork
          _LargeArtwork(track: track),
          const SizedBox(height: 24),

          // Service + quality badges
          if (track != null) _NowPlayingBadges(track: track!),

          // Track info
          _TrackInfo(track: track),

          const SizedBox(height: 16),

          // Seek bar
          const SeekBarView(),
          const SizedBox(height: 8),

          // Transport controls
          _TransportControls(),
          const SizedBox(height: 16),

          // Secondary controls: shuffle, repeat, queue arrow, zones
          _SecondaryControls(sheetController: sheetController),
          const SizedBox(height: 12),

          // Extra actions
          _ExtraActions(track: track),
          const SizedBox(height: 20),

          // Volume
          const VolumeControlView(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Large artwork
// ---------------------------------------------------------------------------

class _LargeArtwork extends StatelessWidget {
  final Track? track;
  const _LargeArtwork({required this.track});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width - 56;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ArtworkView(
        filePath: track?.coverPath,
        size: size,
        cornerRadius: 12,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Track info (title + artist + album + favorite)
// ---------------------------------------------------------------------------

class _TrackInfo extends StatelessWidget {
  final Track? track;
  const _TrackInfo({required this.track});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final isRadio = track?.source == Source.radio.rawValue;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track?.title ??
                    AppLocalizations.of(context).nowPlayingNoTrack,
                style: TuneFonts.title2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (track?.artistName != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    // Prefer the track's artistId (reliable even when the
                    // in-memory artist list isn't loaded or names don't match
                    // exactly); fall back to matching by name. Silent no-op if
                    // the artist isn't in the library (e.g. streaming track).
                    final artists = app.libraryState.artists;
                    final artist = artists.cast<Artist?>().firstWhere(
                      (a) => a?.id == track!.artistId,
                      orElse: () => artists.cast<Artist?>().firstWhere(
                        (a) => a?.name == track!.artistName,
                        orElse: () => null,
                      ),
                    );
                    if (artist != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ArtistDetailView(artist: artist),
                      ));
                    }
                  },
                  child: Text(
                    track!.artistName!,
                    style: TuneFonts.subheadline.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: TuneColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              if (track?.albumTitle != null) ...[
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () {
                    // Prefer the track's albumId; fall back to title+artist
                    // matching. Silent no-op if the album isn't in the library.
                    final albums = app.libraryState.albums;
                    final album = albums.cast<Album?>().firstWhere(
                      (a) => a?.id == track!.albumId,
                      orElse: () => albums.cast<Album?>().firstWhere(
                        (a) =>
                            a?.title == track!.albumTitle &&
                            a?.artistName == track!.artistName,
                        orElse: () => null,
                      ),
                    );
                    if (album != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AlbumDetailView(album: album),
                      ));
                    }
                  },
                  child: Text(
                    track!.albumTitle!,
                    style: TuneFonts.footnote.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: TuneColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
        // Favorite button
        if (isRadio)
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            color: TuneColors.textSecondary,
            iconSize: 28,
            tooltip: 'Favorite',
            onPressed: () {
              if (track != null) {
                final radios = app.libraryState.radios;
                final radio = radios.cast<dynamic>().where(
                  (r) => track!.sourceId == r.id.toString(),
                ).firstOrNull;
                if (radio != null) {
                  app.saveRadioFavorite(
                    title: track!.title,
                    artist: track!.artistName,
                    radio: radio,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ajouté aux favoris radio'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          )
        else if (track?.id != null && track!.id != 0)
          Consumer<LibraryState>(
            builder: (ctx, lib, _) {
              final isFav =
                  track!.favorite || lib.isTrackFavorite(track!.id);
              return IconButton(
                icon: Icon(isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded),
                color:
                    isFav ? TuneColors.accent : TuneColors.textSecondary,
                iconSize: 28,
                tooltip: 'Favorite',
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final l = AppLocalizations.of(context);
                  final added =
                      await app.toggleTrackFavorite(track!.id);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(added
                          ? l.favoriteAdded
                          : l.favoriteRemoved),
                      duration: const Duration(seconds: 2),
                      backgroundColor: added
                          ? TuneColors.accent
                          : TuneColors.surfaceHigh,
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Service + audio quality badges
// ---------------------------------------------------------------------------

class _NowPlayingBadges extends StatelessWidget {
  final Track track;
  const _NowPlayingBadges({required this.track});

  static bool _hasQuality(Track t) =>
      (t.format != null && t.format!.isNotEmpty) ||
      (t.sampleRate != null && t.sampleRate! > 0) ||
      (t.bitDepth != null && t.bitDepth! > 0);

  String _qualityLabel() {
    final parts = <String>[];
    final format = track.format;
    final sr = track.sampleRate;
    final bd = track.bitDepth;
    if (format != null && format.isNotEmpty) parts.add(format.toUpperCase());
    if (sr != null && sr > 0) {
      final kHz = sr / 1000.0;
      parts.add(kHz == kHz.truncateToDouble()
          ? '${kHz.toInt()} kHz'
          : '${kHz.toStringAsFixed(1)} kHz');
    }
    if (bd != null && bd > 0) parts.add('$bd-bit');
    return parts.join(' / ');
  }

  @override
  Widget build(BuildContext context) {
    final hasService = ServiceBadge.isStreaming(track.source);
    final hasQuality = _hasQuality(track);
    if (!hasService && !hasQuality) return const SizedBox.shrink();

    final badge = _qualityLabel();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasService) ServiceBadge(source: track.source),
          if (hasService && hasQuality) const SizedBox(width: 8),
          if (hasQuality && badge.isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: TuneColors.accent.withValues(alpha: 0.25)),
              ),
              child: Text(
                badge,
                style: TuneFonts.caption.copyWith(
                  color: TuneColors.accent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transport controls
// ---------------------------------------------------------------------------

class _TransportControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final state =
        context.select<ZoneState, PlaybackState>((z) => z.playbackState);
    final isPlaying = state == PlaybackState.playing;
    final isBuffering = state == PlaybackState.buffering;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SkipButton(
          isForward: false,
          size: 36,
          color: TuneColors.textPrimary,
          onPressed: () => app.previous(),
        ),
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: TuneColors.textPrimary,
            shape: BoxShape.circle,
          ),
          child: isBuffering
              ? const Padding(
                  padding: EdgeInsets.all(22),
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: TuneColors.background),
                )
              : IconButton(
                  icon: Icon(isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                  iconSize: 38,
                  color: TuneColors.background,
                  tooltip: isPlaying ? 'Pause' : 'Play',
                  onPressed:
                      isPlaying ? () => app.pause() : () => app.resume(),
                ),
        ),
        SkipButton(
          isForward: true,
          size: 36,
          color: TuneColors.textPrimary,
          onPressed: () => app.next(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Secondary controls: shuffle, repeat, queue (scroll-to-queue), zones
// ---------------------------------------------------------------------------

class _SecondaryControls extends StatelessWidget {
  final DraggableScrollableController sheetController;
  const _SecondaryControls({required this.sheetController});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ZoneState, AppState>(
      builder: (ctx, zone, app, _) {
        final shuffle = zone.shuffleEnabled;
        final repeat = zone.repeatMode;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Shuffle
            IconButton(
              icon: Icon(Icons.shuffle_rounded,
                  color: shuffle
                      ? TuneColors.accent
                      : TuneColors.textTertiary),
              tooltip: 'Shuffle',
              onPressed: () => app.setShuffle(enabled: !shuffle),
            ),
            // Repeat
            IconButton(
              icon: Icon(
                repeat == RepeatMode.one
                    ? Icons.repeat_one_rounded
                    : Icons.repeat_rounded,
                color: repeat != RepeatMode.off
                    ? TuneColors.accent
                    : TuneColors.textTertiary,
              ),
              tooltip: 'Repeat',
              onPressed: () => app.cycleRepeat(),
            ),
            // Queue — drag sheet up to queue view
            IconButton(
              icon: const Icon(Icons.queue_music_rounded,
                  color: TuneColors.textSecondary),
              tooltip: 'Queue',
              onPressed: () {
                sheetController.animateTo(
                  _kQueue,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                );
              },
            ),
            // Zones
            IconButton(
              icon: const Icon(Icons.speaker_group_rounded,
                  color: TuneColors.textSecondary),
              tooltip: 'Zones',
              onPressed: () => showModalBottomSheet(
                context: context,
                backgroundColor: TuneColors.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const ZoneManagementView(),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Extra actions
// ---------------------------------------------------------------------------

class _ExtraActions extends StatelessWidget {
  final Track? track;
  const _ExtraActions({required this.track});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.playlist_add_rounded,
              color: TuneColors.textSecondary),
          tooltip: AppLocalizations.of(context).playlistAddTo,
          onPressed: track?.id != null && track!.id != 0
              ? () => _showAddToPlaylist(context, track!)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.auto_awesome_rounded,
              color: TuneColors.textSecondary),
          tooltip: 'Smart AutoPlay',
          onPressed: () => showSmartAutoPlaySheet(context),
        ),
        IconButton(
          icon: const Icon(Icons.lyrics_rounded,
              color: TuneColors.textSecondary),
          tooltip: 'Lyrics',
          onPressed: track?.id != null && track!.id != 0
              ? () => _showLyrics(context, track!.id)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.alarm_rounded,
              color: TuneColors.textSecondary),
          tooltip: 'Alarm',
          onPressed: () => _showAlarmSheet(context),
        ),
        IconButton(
          icon: const Icon(Icons.bedtime_rounded,
              color: TuneColors.textSecondary),
          tooltip: 'Sleep Timer',
          onPressed: () => showSleepTimerSheet(context),
        ),
        IconButton(
          icon: const Icon(Icons.equalizer_rounded,
              color: TuneColors.textSecondary),
          tooltip: 'Equalizer',
          onPressed: () => _showEQSheet(context),
        ),
        IconButton(
          icon: const Icon(Icons.share_rounded,
              color: TuneColors.textSecondary),
          tooltip: 'Share',
          onPressed: () => _shareNowPlaying(context),
        ),
        IconButton(
          icon: const Icon(Icons.cast_rounded,
              color: TuneColors.textSecondary),
          tooltip: 'Transfer',
          onPressed: () => _showTransferDialog(context),
        ),
      ],
    );
  }

  void _showAddToPlaylist(BuildContext context, Track track) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TuneColors.surface,
      builder: (_) => AddToPlaylistSheet(track: track),
    );
  }

  void _showLyrics(BuildContext context, int trackId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _LyricsPlaceholderSheet(trackId: trackId),
    );
  }

  void _showAlarmSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _AlarmSheet(),
    );
  }

  void _showEQSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _EQSheet(),
    );
  }

  void _shareNowPlaying(BuildContext context) async {
    final app = context.read<AppState>();
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (app.apiClient == null || zoneId == null) {
      if (track != null) {
        final text = '${track!.title} - ${track!.artistName ?? ""}';
        Clipboard.setData(ClipboardData(text: text));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
        }
      }
      return;
    }
    try {
      final data = await app.apiClient!.shareNowPlaying(zoneId);
      final shareText = data['text'] as String? ??
          '${track?.title ?? ""} - ${track?.artistName ?? ""}';
      Clipboard.setData(ClipboardData(text: shareText));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      }
    } catch (e) {
      if (context.mounted && track != null) {
        final text = '${track!.title} - ${track!.artistName ?? ""}';
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      }
    }
  }

  void _showTransferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _TransferDialog(),
    );
  }
}

// ---------------------------------------------------------------------------
// Queue section — shown in the fully expanded state
// ---------------------------------------------------------------------------

class _QueueSection extends StatelessWidget {
  const _QueueSection();

  void _showClearConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).queueClearTitle),
        content: Text(AppLocalizations.of(context).queueClearBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).btnCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppState>().clearQueue();
            },
            child: Text(AppLocalizations.of(context).btnClear,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = context.watch<ZoneState>().queueSnapshot;
    final tracks = (snapshot?.tracks ?? []).cast<Track>();
    final currentPosition = snapshot?.position ?? -1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text(AppLocalizations.of(context).queueTitle,
                  style: TuneFonts.title3),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded,
                    color: TuneColors.textSecondary, size: 22),
                tooltip: 'Smart AutoPlay',
                onPressed: () => showSmartAutoPlaySheet(context),
              ),
              if (tracks.isNotEmpty) ...[
                TextButton(
                  onPressed: () => _showClearConfirm(context),
                  child: Text(AppLocalizations.of(context).btnClear,
                      style:
                          const TextStyle(color: TuneColors.error)),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<AppState>().setShuffle(enabled: true),
                  child: Text(AppLocalizations.of(context).btnShuffle,
                      style:
                          const TextStyle(color: TuneColors.accent)),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1),
        // Track list
        if (tracks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.queue_music_rounded,
                    size: 40, color: TuneColors.textTertiary),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context).queueEmpty,
                    style:
                        const TextStyle(color: TuneColors.textTertiary)),
              ],
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tracks.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              context.read<AppState>().moveQueueItem(oldIndex, newIndex);
            },
            itemBuilder: (_, i) {
              final t = tracks[i];
              final isCurrent = i == currentPosition;
              final gaplessIndices =
                  context.read<ZoneState>().gaplessIndices;
              final isGapless = gaplessIndices.contains(i);
              return _QueueItem(
                key: ValueKey('qs-$i-${t.id}'),
                track: t,
                index: i,
                isCurrent: isCurrent,
                showGaplessIndicator: isGapless,
              );
            },
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Queue item (identical logic to QueueView._QueueItem)
// ---------------------------------------------------------------------------

class _QueueItem extends StatelessWidget {
  final Track track;
  final int index;
  final bool isCurrent;
  final bool showGaplessIndicator;

  const _QueueItem({
    super.key,
    required this.track,
    required this.index,
    required this.isCurrent,
    this.showGaplessIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: TuneColors.error,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => context.read<AppState>().removeQueueItem(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: isCurrent
                ? TuneColors.accent.withValues(alpha: 0.12)
                : Colors.transparent,
            child: ListTile(
              onTap: isCurrent
                  ? null
                  : () => context
                      .read<AppState>()
                      .jumpToQueuePosition(index),
              onLongPress: track.id != 0
                  ? () => _showMenu(context, track)
                  : null,
              leading: ArtworkView(
                filePath: track.coverPath,
                size: 42,
                cornerRadius: 4,
              ),
              title: Text(
                track.title,
                style: TextStyle(
                  color: isCurrent
                      ? TuneColors.accent
                      : TuneColors.textPrimary,
                  fontWeight:
                      isCurrent ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: _buildSubtitle(context),
              trailing: isCurrent
                  ? const Icon(Icons.equalizer_rounded,
                      color: TuneColors.accent, size: 18)
                  : ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle_rounded,
                          color: TuneColors.textTertiary),
                    ),
            ),
          ),
          if (showGaplessIndicator)
            Container(
              height: 20,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 20,
                      height: 1,
                      color:
                          TuneColors.accent.withValues(alpha: 0.4)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.link_rounded,
                        size: 14,
                        color:
                            TuneColors.accent.withValues(alpha: 0.7)),
                  ),
                  Container(
                      width: 20,
                      height: 1,
                      color:
                          TuneColors.accent.withValues(alpha: 0.4)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    final metadataFields =
        context.read<SettingsState>().metadataDisplayFields;
    final hasArtist = track.artistName != null;
    final hasBadge = ServiceBadge.isStreaming(track.source);
    final hasChips = metadataFields.isNotEmpty;
    if (!hasArtist && !hasBadge && !hasChips) return null;

    if (!hasChips) {
      return Row(
        children: [
          if (hasArtist)
            Flexible(
              child: Text(track.artistName!,
                  style: TuneFonts.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          if (hasBadge) ...[
            if (hasArtist) const SizedBox(width: 6),
            ServiceBadge(source: track.source, compact: true),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasArtist || hasBadge)
          Row(
            children: [
              if (hasArtist)
                Flexible(
                  child: Text(track.artistName!,
                      style: TuneFonts.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              if (hasBadge) ...[
                if (hasArtist) const SizedBox(width: 6),
                ServiceBadge(source: track.source, compact: true),
              ],
            ],
          ),
        MetadataChips(track: track, selectedFields: metadataFields),
      ],
    );
  }

  void _showMenu(BuildContext context, Track track) {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.playlist_add_rounded,
                  color: TuneColors.accent),
              title: Text(l.playlistAddTo, style: TuneFonts.body),
              onTap: () {
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: TuneColors.surface,
                  builder: (_) => AddToPlaylistSheet(track: track),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lyrics placeholder sheet (delegates to NowPlayingView's _LyricsSheet
// via a re-export — same logic, kept local here to avoid circular imports)
// ---------------------------------------------------------------------------

class _LyricsPlaceholderSheet extends StatelessWidget {
  final int trackId;
  const _LyricsPlaceholderSheet({required this.trackId});

  @override
  Widget build(BuildContext context) {
    // Re-use NowPlayingView's lyrics sheet by launching it as a separate modal.
    // We just immediately pop and reshow — simpler: just show a stub that
    // delegates. Since the lyrics sheet is private in now_playing_view.dart,
    // we duplicate the minimum here (the full karaoke lyrics view is in
    // now_playing_view.dart and unchanged).
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, sc) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Lyrics', style: TuneFonts.title3),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text('Open from Now Playing for full lyrics',
                  style: TuneFonts.subheadline
                      .copyWith(color: TuneColors.textTertiary)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EQ sheet (copied from now_playing_view.dart — same presets)
// ---------------------------------------------------------------------------

class _EQSheet extends StatefulWidget {
  const _EQSheet();

  @override
  State<_EQSheet> createState() => _EQSheetState();
}

class _EQSheetState extends State<_EQSheet> {
  String? _selectedPreset;

  static const _presets = [
    'flat', 'bass_boost', 'treble_boost', 'vocal', 'rock',
    'jazz', 'classical', 'electronic', 'hip_hop', 'acoustic',
  ];

  static const _presetLabels = {
    'flat': 'Flat', 'bass_boost': 'Bass Boost', 'treble_boost': 'Treble Boost',
    'vocal': 'Vocal', 'rock': 'Rock', 'jazz': 'Jazz', 'classical': 'Classical',
    'electronic': 'Electronic', 'hip_hop': 'Hip Hop', 'acoustic': 'Acoustic',
  };

  Future<void> _applyPreset(String preset) async {
    final app = context.read<AppState>();
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (app.apiClient == null || zoneId == null) return;
    try {
      await app.apiClient!.setEqualizer(zoneId, preset);
      if (mounted) {
        setState(() => _selectedPreset = preset);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('EQ: ${_presetLabels[preset] ?? preset}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('EQ error: $e')),
        );
      }
    }
  }

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
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Equalizer', style: TuneFonts.title3),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presets.map((preset) {
              final selected = _selectedPreset == preset;
              return ChoiceChip(
                label: Text(_presetLabels[preset] ?? preset),
                selected: selected,
                selectedColor: TuneColors.accent.withValues(alpha: 0.25),
                backgroundColor: TuneColors.surfaceVariant,
                labelStyle: TextStyle(
                  color: selected ? TuneColors.accent : TuneColors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: selected
                    ? BorderSide(
                        color: TuneColors.accent.withValues(alpha: 0.5))
                    : BorderSide.none,
                onSelected: (_) => _applyPreset(preset),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Alarm sheet
// ---------------------------------------------------------------------------

class _AlarmSheet extends StatelessWidget {
  const _AlarmSheet();

  static const _times = [
    (label: '07:00', time: '07:00'),
    (label: '07:30', time: '07:30'),
    (label: '08:00', time: '08:00'),
    (label: '08:30', time: '08:30'),
  ];

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
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Alarm Clock', style: TuneFonts.title3),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._times.map((opt) => ActionChip(
                    label: Text(opt.label),
                    avatar: const Icon(Icons.alarm_rounded,
                        size: 16, color: TuneColors.accent),
                    backgroundColor: TuneColors.surfaceVariant,
                    labelStyle: const TextStyle(color: TuneColors.textPrimary),
                    side: BorderSide.none,
                    onPressed: () async {
                      final app = context.read<AppState>();
                      final zoneId =
                          context.read<ZoneState>().currentZoneId;
                      Navigator.pop(context);
                      if (app.apiClient != null && zoneId != null) {
                        try {
                          await app.apiClient!.setAlarm(zoneId, opt.time);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Alarm set for ${opt.label}')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Alarm error: $e')),
                            );
                          }
                        }
                      }
                    },
                  )),
              ActionChip(
                avatar: const Icon(Icons.alarm_off_rounded,
                    size: 16, color: TuneColors.error),
                label: const Text('Cancel'),
                backgroundColor: TuneColors.surfaceVariant,
                labelStyle:
                    const TextStyle(color: TuneColors.textSecondary),
                side: BorderSide.none,
                onPressed: () async {
                  final app = context.read<AppState>();
                  final zoneId =
                      context.read<ZoneState>().currentZoneId;
                  Navigator.pop(context);
                  if (app.apiClient != null && zoneId != null) {
                    try {
                      await app.apiClient!.cancelAlarm(zoneId);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Alarm cancelled')),
                        );
                      }
                    } catch (_) {}
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transfer dialog
// ---------------------------------------------------------------------------

class _TransferDialog extends StatelessWidget {
  const _TransferDialog();

  @override
  Widget build(BuildContext context) {
    final zoneState = context.read<ZoneState>();
    final currentZoneId = zoneState.currentZoneId;
    final zones =
        zoneState.zones.where((z) => z.id != currentZoneId).toList();

    return AlertDialog(
      backgroundColor: TuneColors.surface,
      title: Text('Transfer playback', style: TuneFonts.title3),
      content: zones.isEmpty
          ? Text('No other zones available', style: TuneFonts.subheadline)
          : SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: zones.length,
                itemBuilder: (_, i) {
                  final zone = zones[i];
                  return ListTile(
                    leading: const Icon(Icons.speaker_rounded,
                        color: TuneColors.accent),
                    title: Text(zone.name, style: TuneFonts.body),
                    onTap: () async {
                      Navigator.pop(context);
                      final app = context.read<AppState>();
                      if (app.apiClient != null && currentZoneId != null) {
                        try {
                          await app.apiClient!
                              .transferPlayback(currentZoneId, zone.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Transferred to ${zone.name}')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Transfer error: $e')),
                            );
                          }
                        }
                      }
                    },
                  );
                },
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
