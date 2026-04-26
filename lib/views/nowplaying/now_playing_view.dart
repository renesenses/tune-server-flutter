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
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/skip_button.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/albums_grid_view.dart';
import '../library/artists_list_view.dart';
import 'queue_view.dart';
import 'seek_bar_view.dart';
import 'volume_control_view.dart';
import 'zone_management_view.dart';

// ---------------------------------------------------------------------------
// T11.1 — NowPlayingView
// Vue plein écran : fond artwork flouté, pochette large, contrôles complets.
// Présentée en modal bottom sheet depuis MiniPlayerView ou iPadNowPlayingBar.
// Miroir de NowPlayingView.swift (iOS)
// ---------------------------------------------------------------------------

/// Ouvre NowPlayingView en modal plein écran.
void showNowPlaying(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    builder: (_) => const NowPlayingView(),
  );
}

class NowPlayingView extends StatelessWidget {
  const NowPlayingView({super.key});

  @override
  Widget build(BuildContext context) {
    final track =
        context.select<ZoneState, dynamic>((z) => z.currentTrack) as Track?;

    return Stack(
      children: [
        // --- Fond : artwork flouté ---
        Positioned.fill(child: _BlurredBackground(track: track)),

        // --- Contenu ---
        SafeArea(
          child: Column(
            children: [
              _DismissHandle(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Pochette large
                        _LargeArtwork(track: track),
                        const SizedBox(height: 28),

                        // Titre + artiste + bouton options
                        _TrackInfo(track: track),
                        const SizedBox(height: 20),

                        // Seek bar
                        const SeekBarView(),
                        const SizedBox(height: 8),

                        // Contrôles transport
                        _TransportControls(),
                        const SizedBox(height: 20),

                        // Ligne secondaire : shuffle, repeat, queue, zones
                        _SecondaryControls(context),
                        const SizedBox(height: 16),

                        // Extra actions: Lyrics, EQ, Share, Transfer
                        _ExtraActions(track: track),
                        const SizedBox(height: 24),

                        // Volume
                        const VolumeControlView(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _DismissHandle(BuildContext ctx) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: TuneColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      );

  static Widget _SecondaryControls(BuildContext ctx) {
    return Consumer2<ZoneState, AppState>(
      builder: (_, zone, app, __) {
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
              onPressed: () =>
                  app.setShuffle(enabled: !shuffle),
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
            // Queue
            IconButton(
              icon: const Icon(Icons.queue_music_rounded,
                  color: TuneColors.textSecondary),
              tooltip: 'Queue',
              onPressed: () => showModalBottomSheet(
                context: ctx,
                backgroundColor: TuneColors.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const QueueView(),
              ),
            ),
            // Zones
            IconButton(
              icon: const Icon(Icons.speaker_group_rounded,
                  color: TuneColors.textSecondary),
              tooltip: 'Zones',
              onPressed: () => showModalBottomSheet(
                context: ctx,
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
// Fond flouté
// ---------------------------------------------------------------------------

class _BlurredBackground extends StatelessWidget {
  final Track? track;

  const _BlurredBackground({required this.track});

  @override
  Widget build(BuildContext context) {
    final coverPath = track?.coverPath;
    final isHttp = coverPath != null && coverPath.startsWith('http');
    return Stack(
      fit: StackFit.expand,
      children: [
        // Couleur de base
        ColoredBox(color: TuneColors.background),
        // Image floue (si disponible)
        if (coverPath != null)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: isHttp
                ? Image.network(coverPath, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink())
                : Image.file(File(coverPath), fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink()),
          ),
        // Overlay sombre
        ColoredBox(
            color: Colors.black.withValues(alpha: 0.65)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pochette large
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
// Infos piste
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
                track?.title ?? AppLocalizations.of(context).nowPlayingNoTrack,
                style: TuneFonts.title2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (track?.artistName != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    final artists = app.libraryState.artists;
                    final artist = artists.cast<Artist?>().where(
                      (a) => a?.name == track!.artistName,
                    ).firstOrNull;
                    if (artist != null) {
                      Navigator.of(context).pop();
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
                    final albums = app.libraryState.albums;
                    final album = albums.cast<Album?>().where(
                      (a) => a?.title == track!.albumTitle && a?.artistName == track!.artistName,
                    ).firstOrNull;
                    if (album != null) {
                      Navigator.of(context).pop();
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
        // Heart / favorite button
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
              final isFav = track!.favorite || lib.isTrackFavorite(track!.id);
              return IconButton(
                icon: Icon(isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded),
                color: isFav ? TuneColors.accent : TuneColors.textSecondary,
                iconSize: 28,
                tooltip: 'Favorite',
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final l = AppLocalizations.of(context);
                  final added = await app.toggleTrackFavorite(track!.id);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(added
                          ? l.favoriteAdded
                          : l.favoriteRemoved),
                      duration: const Duration(seconds: 2),
                      backgroundColor:
                          added ? TuneColors.accent : TuneColors.surfaceHigh,
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
// Extra actions — Lyrics, EQ, Share, Transfer
// ---------------------------------------------------------------------------

class _ExtraActions extends StatelessWidget {
  final Track? track;
  const _ExtraActions({required this.track});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Lyrics
        IconButton(
          icon: const Icon(Icons.lyrics_rounded, color: TuneColors.textSecondary),
          tooltip: 'Lyrics',
          onPressed: track?.id != null && track!.id != 0
              ? () => _showLyrics(context, track!.id)
              : null,
        ),
        // Sleep Timer
        IconButton(
          icon: const Icon(Icons.bedtime_rounded, color: TuneColors.textSecondary),
          tooltip: 'Sleep Timer',
          onPressed: () => _showSleepTimerSheet(context),
        ),
        // DSP Crossfeed
        IconButton(
          icon: const Icon(Icons.headphones_rounded, color: TuneColors.textSecondary),
          tooltip: 'DSP Crossfeed',
          onPressed: () => _showDSPSheet(context),
        ),
        // EQ
        IconButton(
          icon: const Icon(Icons.equalizer_rounded, color: TuneColors.textSecondary),
          tooltip: 'Equalizer',
          onPressed: () => _showEQSheet(context),
        ),
        // Share
        IconButton(
          icon: const Icon(Icons.share_rounded, color: TuneColors.textSecondary),
          tooltip: 'Share',
          onPressed: () => _shareNowPlaying(context),
        ),
        // Transfer
        IconButton(
          icon: const Icon(Icons.cast_rounded, color: TuneColors.textSecondary),
          tooltip: 'Transfer',
          onPressed: () => _showTransferDialog(context),
        ),
      ],
    );
  }

  void _showLyrics(BuildContext context, int trackId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _LyricsSheet(trackId: trackId),
    );
  }

  void _showSleepTimerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _SleepTimerSheet(),
    );
  }

  void _showDSPSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _DSPSheet(),
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
      // Fallback: copy track info
      if (track != null) {
        final text = '${track!.title} - ${track!.artistName ?? ""}';
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      }
      return;
    }
    try {
      final data = await app.apiClient!.shareNowPlaying(zoneId);
      final shareText = data['text'] as String? ?? '${track?.title ?? ""} - ${track?.artistName ?? ""}';
      Clipboard.setData(ClipboardData(text: shareText));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Fallback
        if (track != null) {
          final text = '${track!.title} - ${track!.artistName ?? ""}';
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
        }
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
// Lyrics bottom sheet
// ---------------------------------------------------------------------------

class _LyricsSheet extends StatefulWidget {
  final int trackId;
  const _LyricsSheet({required this.trackId});

  @override
  State<_LyricsSheet> createState() => _LyricsSheetState();
}

class _LyricsSheetState extends State<_LyricsSheet> {
  String? _lyrics;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLyrics();
  }

  Future<void> _loadLyrics() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() { _loading = false; _error = 'Not connected'; });
      return;
    }
    try {
      final data = await api.getTrackLyrics(widget.trackId);
      if (!mounted) return;
      setState(() {
        _lyrics = data['lyrics'] as String?;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'No lyrics found'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // Handle
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
            child: Text('Lyrics', style: TuneFonts.title3),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: TuneFonts.subheadline))
                    : _lyrics == null || _lyrics!.isEmpty
                        ? Center(child: Text('No lyrics available', style: TuneFonts.subheadline))
                        : SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            child: Text(_lyrics!,
                                style: TuneFonts.body.copyWith(height: 1.6)),
                          ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EQ bottom sheet
// ---------------------------------------------------------------------------

class _EQSheet extends StatefulWidget {
  const _EQSheet();

  @override
  State<_EQSheet> createState() => _EQSheetState();
}

class _EQSheetState extends State<_EQSheet> {
  String? _selectedPreset;

  static const _presets = [
    'flat',
    'bass_boost',
    'treble_boost',
    'vocal',
    'rock',
    'jazz',
    'classical',
    'electronic',
    'hip_hop',
    'acoustic',
  ];

  static const _presetLabels = {
    'flat': 'Flat',
    'bass_boost': 'Bass Boost',
    'treble_boost': 'Treble Boost',
    'vocal': 'Vocal',
    'rock': 'Rock',
    'jazz': 'Jazz',
    'classical': 'Classical',
    'electronic': 'Electronic',
    'hip_hop': 'Hip Hop',
    'acoustic': 'Acoustic',
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
              width: 36, height: 4,
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
                    ? BorderSide(color: TuneColors.accent.withValues(alpha: 0.5))
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
// Sleep Timer bottom sheet
// ---------------------------------------------------------------------------

class _SleepTimerSheet extends StatelessWidget {
  const _SleepTimerSheet();

  static const _options = [
    (label: '15 min', minutes: 15),
    (label: '30 min', minutes: 30),
    (label: '45 min', minutes: 45),
    (label: '1h', minutes: 60),
    (label: '1h30', minutes: 90),
    (label: '2h', minutes: 120),
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
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Sleep Timer', style: TuneFonts.title3),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._options.map((opt) => ActionChip(
                label: Text(opt.label),
                backgroundColor: TuneColors.surfaceVariant,
                labelStyle: const TextStyle(color: TuneColors.textPrimary),
                side: BorderSide.none,
                onPressed: () async {
                  final app = context.read<AppState>();
                  final zoneId = context.read<ZoneState>().currentZoneId;
                  Navigator.pop(context);
                  if (app.apiClient != null && zoneId != null) {
                    try {
                      await app.apiClient!.setSleepTimer(zoneId, opt.minutes);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sleep timer: ${opt.label}')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sleep timer error: $e')),
                        );
                      }
                    }
                  }
                },
              )),
              // Cancel timer
              ActionChip(
                avatar: const Icon(Icons.timer_off_rounded, size: 16, color: TuneColors.error),
                label: const Text('Off'),
                backgroundColor: TuneColors.surfaceVariant,
                labelStyle: const TextStyle(color: TuneColors.textSecondary),
                side: BorderSide.none,
                onPressed: () async {
                  final app = context.read<AppState>();
                  final zoneId = context.read<ZoneState>().currentZoneId;
                  Navigator.pop(context);
                  if (app.apiClient != null && zoneId != null) {
                    try {
                      await app.apiClient!.setSleepTimer(zoneId, 0);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sleep timer cancelled')),
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
// DSP Crossfeed bottom sheet
// ---------------------------------------------------------------------------

class _DSPSheet extends StatefulWidget {
  const _DSPSheet();

  @override
  State<_DSPSheet> createState() => _DSPSheetState();
}

class _DSPSheetState extends State<_DSPSheet> {
  String? _selectedCrossfeed;

  static const _crossfeedOptions = [
    (label: 'Off', value: null),
    (label: 'Light', value: 'light'),
    (label: 'Medium', value: 'medium'),
    (label: 'Strong', value: 'strong'),
  ];

  Future<void> _applyCrossfeed(String? value) async {
    final app = context.read<AppState>();
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (app.apiClient == null || zoneId == null) return;
    try {
      await app.apiClient!.setDSP(zoneId, value);
      if (mounted) {
        setState(() => _selectedCrossfeed = value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Crossfeed: ${value ?? "off"}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('DSP error: $e')),
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
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('DSP Crossfeed', style: TuneFonts.title3),
          const SizedBox(height: 4),
          Text(
            'Blends stereo channels for a more natural headphone experience',
            style: TuneFonts.caption,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _crossfeedOptions.map((opt) {
              final selected = _selectedCrossfeed == opt.value;
              return ChoiceChip(
                label: Text(opt.label),
                selected: selected,
                selectedColor: TuneColors.accent.withValues(alpha: 0.25),
                backgroundColor: TuneColors.surfaceVariant,
                labelStyle: TextStyle(
                  color: selected ? TuneColors.accent : TuneColors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: selected
                    ? BorderSide(color: TuneColors.accent.withValues(alpha: 0.5))
                    : BorderSide.none,
                onSelected: (_) => _applyCrossfeed(opt.value),
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
// Transfer dialog — pick target zone
// ---------------------------------------------------------------------------

class _TransferDialog extends StatelessWidget {
  const _TransferDialog();

  @override
  Widget build(BuildContext context) {
    final zoneState = context.read<ZoneState>();
    final currentZoneId = zoneState.currentZoneId;
    final zones = zoneState.zones.where((z) => z.id != currentZoneId).toList();

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
                          await app.apiClient!.transferPlayback(
                              currentZoneId, zone.id);
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
                              SnackBar(content: Text('Transfer error: $e')),
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

// ---------------------------------------------------------------------------
// Contrôles transport
// ---------------------------------------------------------------------------

class _TransportControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final state = context.select<ZoneState, PlaybackState>(
        (z) => z.playbackState);
    final isPlaying = state == PlaybackState.playing;
    final isBuffering = state == PlaybackState.buffering;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Précédent
        SkipButton(
          isForward: false,
          size: 36,
          color: TuneColors.textPrimary,
          onPressed: () => app.previous(),
        ),

        // Play / Pause
        Container(
          width: 72, height: 72,
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
                  onPressed: isPlaying
                      ? () => app.pause()
                      : () => app.resume(),
                ),
        ),

        // Suivant
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
