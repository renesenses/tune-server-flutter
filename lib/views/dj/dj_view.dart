import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// DJView — DJ mode with two decks, crossfade, auto-crossfade
// ---------------------------------------------------------------------------

class DJView extends StatefulWidget {
  const DJView({super.key});

  @override
  State<DJView> createState() => _DJViewState();
}

class _DJViewState extends State<DJView> {
  bool _enabled = false;
  bool _autoCrossfade = false;
  double _crossfadeDuration = 5.0;
  Map<String, dynamic>? _deckA;
  Map<String, dynamic>? _deckB;
  Timer? _pollTimer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  int? get _zoneId => context.read<ZoneState>().currentZoneId;

  Future<void> _loadStatus() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final status = await api.getDJStatus(zoneId);
      if (!mounted) return;
      setState(() {
        _enabled = status['enabled'] as bool? ?? false;
        _autoCrossfade = status['auto_crossfade'] as bool? ?? false;
        _crossfadeDuration = (status['crossfade_duration'] as num?)?.toDouble() ?? 5.0;
        _deckA = status['deck_a'] as Map<String, dynamic>?;
        _deckB = status['deck_b'] as Map<String, dynamic>?;
        _loading = false;
      });
      _startPolling();
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    if (!_enabled) return;
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) => _pollStatus());
  }

  Future<void> _pollStatus() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) return;
    try {
      final status = await api.getDJStatus(zoneId);
      if (!mounted) return;
      setState(() {
        _enabled = status['enabled'] as bool? ?? false;
        _autoCrossfade = status['auto_crossfade'] as bool? ?? false;
        _deckA = status['deck_a'] as Map<String, dynamic>?;
        _deckB = status['deck_b'] as Map<String, dynamic>?;
      });
      if (!_enabled) _pollTimer?.cancel();
    } catch (_) {}
  }

  Future<void> _toggleDJ() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No zone selected')),
      );
      return;
    }
    try {
      if (_enabled) {
        await api.disableDJ(zoneId);
        _pollTimer?.cancel();
      } else {
        await api.enableDJ(zoneId);
      }
      await _loadStatus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _loadTrackOnDeck(String deck) async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) return;

    final controller = TextEditingController();
    final trackId = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text('Load track on Deck ${deck.toUpperCase()}',
            style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              style: TuneFonts.body,
              decoration: InputDecoration(
                hintText: 'Search tracks...',
                hintStyle: TuneFonts.subheadline,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: TuneColors.textTertiary),
              ),
            ),
            const SizedBox(height: 12),
            Text('Enter a track name and press Search',
                style: TuneFonts.caption),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final query = controller.text.trim();
              if (query.isEmpty) return;
              try {
                final results = await api.searchLibrary(query, limit: 10);
                if (results is Map<String, dynamic>) {
                  final tracks = results['tracks'] as List? ?? [];
                  if (tracks.isNotEmpty) {
                    final first = tracks.first as Map<String, dynamic>;
                    Navigator.pop(ctx, first['id'] as int?);
                    return;
                  }
                }
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('No tracks found')),
                  );
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Search error: $e')),
                  );
                }
              }
            },
            child: const Text('Search & Load'),
          ),
        ],
      ),
    );

    if (trackId != null) {
      try {
        await api.loadDeck(zoneId, deck, trackId);
        await _pollStatus();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Load error: $e')),
          );
        }
      }
    }
  }

  Future<void> _playDeck(String deck) async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) return;
    try {
      await api.playDeck(zoneId, deck);
      await _pollStatus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Play error: $e')),
        );
      }
    }
  }

  Future<void> _pauseDeck(String deck) async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) return;
    try {
      await api.pauseDeck(zoneId, deck);
      await _pollStatus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pause error: $e')),
        );
      }
    }
  }

  Future<void> _crossfade() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) return;
    try {
      await api.startCrossfade(zoneId, duration: _crossfadeDuration);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Crossfade error: $e')),
        );
      }
    }
  }

  Future<void> _toggleAutoCrossfade(bool value) async {
    final api = context.read<AppState>().apiClient;
    final zoneId = _zoneId;
    if (api == null || zoneId == null) return;
    try {
      await api.toggleAutoCrossfade(zoneId, value);
      if (mounted) setState(() => _autoCrossfade = value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 600;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text('DJ Mode', style: TuneFonts.title2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              icon: Icon(_enabled ? Icons.stop_rounded : Icons.play_arrow_rounded),
              label: Text(_enabled ? 'Disable' : 'Enable'),
              style: FilledButton.styleFrom(
                backgroundColor: _enabled ? TuneColors.error : TuneColors.accent,
              ),
              onPressed: _toggleDJ,
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_enabled
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.album_rounded,
                          size: 64, color: TuneColors.textTertiary),
                      const SizedBox(height: 16),
                      Text('DJ Mode is disabled',
                          style: TuneFonts.subheadline),
                      const SizedBox(height: 8),
                      Text('Enable it to start mixing',
                          style: TuneFonts.caption),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Decks
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _DeckCard(
                              label: 'Deck A',
                              data: _deckA,
                              onLoad: () => _loadTrackOnDeck('a'),
                              onPlay: () => _playDeck('a'),
                              onPause: () => _pauseDeck('a'),
                            )),
                            const SizedBox(width: 16),
                            Expanded(child: _DeckCard(
                              label: 'Deck B',
                              data: _deckB,
                              onLoad: () => _loadTrackOnDeck('b'),
                              onPlay: () => _playDeck('b'),
                              onPause: () => _pauseDeck('b'),
                            )),
                          ],
                        )
                      else ...[
                        _DeckCard(
                          label: 'Deck A',
                          data: _deckA,
                          onLoad: () => _loadTrackOnDeck('a'),
                          onPlay: () => _playDeck('a'),
                          onPause: () => _pauseDeck('a'),
                        ),
                        const SizedBox(height: 16),
                        _DeckCard(
                          label: 'Deck B',
                          data: _deckB,
                          onLoad: () => _loadTrackOnDeck('b'),
                          onPlay: () => _playDeck('b'),
                          onPause: () => _pauseDeck('b'),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Crossfade controls
                      Card(
                        color: TuneColors.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Crossfade', style: TuneFonts.title3),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text('Duration: ${_crossfadeDuration.toStringAsFixed(1)}s',
                                      style: TuneFonts.body),
                                  Expanded(
                                    child: Slider(
                                      value: _crossfadeDuration,
                                      min: 1.0,
                                      max: 30.0,
                                      activeColor: TuneColors.accent,
                                      onChanged: (v) => setState(() => _crossfadeDuration = v),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  icon: const Icon(Icons.swap_horiz_rounded),
                                  label: const Text('Start Crossfade'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: TuneColors.accent,
                                  ),
                                  onPressed: _crossfade,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Auto-crossfade', style: TuneFonts.body),
                                  Switch(
                                    value: _autoCrossfade,
                                    activeColor: TuneColors.accent,
                                    onChanged: _toggleAutoCrossfade,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

// ---------------------------------------------------------------------------
// Deck Card
// ---------------------------------------------------------------------------

class _DeckCard extends StatelessWidget {
  final String label;
  final Map<String, dynamic>? data;
  final VoidCallback onLoad;
  final VoidCallback onPlay;
  final VoidCallback onPause;

  const _DeckCard({
    required this.label,
    required this.data,
    required this.onLoad,
    required this.onPlay,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    final title = data?['title'] as String? ?? 'No track loaded';
    final artist = data?['artist'] as String?;
    final cover = data?['cover_path'] as String?;
    final isPlaying = data?['state'] == 'playing';
    final positionMs = data?['position_ms'] as int? ?? 0;
    final durationMs = data?['duration_ms'] as int? ?? 1;
    final gain = (data?['gain'] as num?)?.toDouble() ?? 0.0;

    final posStr = _formatMs(positionMs);
    final durStr = _formatMs(durationMs);

    return Card(
      color: TuneColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(label,
                    style: TuneFonts.title3.copyWith(color: TuneColors.accent)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  color: TuneColors.textSecondary,
                  tooltip: 'Load track',
                  onPressed: onLoad,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Track info
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: TuneColors.surfaceVariant,
                  child: cover != null
                      ? ClipOval(
                          child: ArtworkView(filePath: cover, size: 56),
                        )
                      : const Icon(Icons.music_note_rounded,
                          color: TuneColors.textTertiary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TuneFonts.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (artist != null)
                        Text(artist,
                            style: TuneFonts.footnote,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Position
            Text('$posStr / $durStr', style: TuneFonts.caption),
            const SizedBox(height: 4),

            // Gain bar
            Row(
              children: [
                Text('Gain', style: TuneFonts.caption),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: gain.clamp(0.0, 1.0),
                    backgroundColor: TuneColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation(TuneColors.accent),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Play/Pause
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 48,
                    color: TuneColors.accent,
                  ),
                  onPressed: isPlaying ? onPause : onPlay,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatMs(int ms) {
    final s = (ms ~/ 1000) % 60;
    final m = ms ~/ 60000;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
