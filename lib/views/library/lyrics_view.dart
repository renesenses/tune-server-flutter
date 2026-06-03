import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/metadata/lyrics_parser.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// LyricsView — Synced lyrics display
// Takes a track file path, loads sidecar .lrc, highlights current line,
// auto-scrolls to playback position.
// Uses LyricsParser from lib/server/metadata/lyrics_parser.dart.
// Miroir de LyricsView.swift (iOS)
// ---------------------------------------------------------------------------

class LyricsView extends StatefulWidget {
  final String filePath;

  const LyricsView({super.key, required this.filePath});

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  ParsedLyrics? _lyrics;
  bool _loading = true;
  String? _error;

  int _currentLineIndex = -1;
  Timer? _scrollTimer;
  final ScrollController _scrollCtrl = ScrollController();

  /// Estimated line height for auto-scroll offset calculation.
  static const double _lineHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _loadLyrics();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLyrics() async {
    setState(() { _loading = true; _error = null; });

    try {
      final lyrics = await LyricsParser.findSidecar(widget.filePath);
      if (!mounted) return;

      if (lyrics == null) {
        setState(() { _loading = false; _lyrics = null; });
        return;
      }

      setState(() { _lyrics = lyrics; _loading = false; });

      // Start position tracking if synced
      if (lyrics.synced) {
        _startPositionTracking();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _error = '$e'; });
    }
  }

  void _startPositionTracking() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted || _lyrics == null || !_lyrics!.synced) return;

      final zone = context.read<ZoneState>();
      final positionMs = zone.positionMs;
      final position = Duration(milliseconds: positionMs);

      final lines = _lyrics!.lines;
      int newIndex = -1;

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].timestamp <= position) {
          newIndex = i;
        } else {
          break;
        }
      }

      if (newIndex != _currentLineIndex) {
        setState(() => _currentLineIndex = newIndex);
        _scrollToLine(newIndex);
      }
    });
  }

  void _scrollToLine(int index) {
    if (index < 0 || !_scrollCtrl.hasClients) return;

    // Scroll to put current line roughly in the center
    final viewportHeight = _scrollCtrl.position.viewportDimension;
    final targetOffset = (index * _lineHeight) - (viewportHeight / 2) + _lineHeight;
    final clampedOffset = targetOffset.clamp(
      0.0,
      _scrollCtrl.position.maxScrollExtent,
    );

    _scrollCtrl.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(
          _lyrics?.metadata['ti'] ?? 'Lyrics',
          style: TuneFonts.title3,
        ),
        actions: [
          if (_lyrics != null && _lyrics!.metadata.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.info_outline_rounded,
                  size: 22, color: TuneColors.textSecondary),
              tooltip: 'Metadata',
              onPressed: _showMetadata,
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: TuneColors.accent))
          : _error != null
              ? _ErrorBody(error: _error!)
              : _lyrics == null
                  ? const _NoLyricsFound()
                  : _buildLyrics(),
    );
  }

  Widget _buildLyrics() {
    final lines = _lyrics!.lines;
    final synced = _lyrics!.synced;

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      itemCount: lines.length,
      itemBuilder: (_, i) {
        final line = lines[i];
        final isCurrent = synced && i == _currentLineIndex;
        final isPast = synced && i < _currentLineIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: isCurrent ? 22 : 17,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
              color: isCurrent
                  ? TuneColors.accent
                  : isPast
                      ? TuneColors.textTertiary
                      : TuneColors.textPrimary,
              height: 1.4,
            ),
            child: Text(
              line.text.isEmpty ? '...' : line.text,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  void _showMetadata() {
    final meta = _lyrics?.metadata ?? {};
    if (meta.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: const Text('LRC Metadata', style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: meta.entries.map((e) {
            final label = switch (e.key) {
              'ar' => 'Artist',
              'ti' => 'Title',
              'al' => 'Album',
              'by' => 'Created by',
              'offset' => 'Offset (ms)',
              _ => e.key.toUpperCase(),
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(label,
                        style: TuneFonts.caption
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Expanded(child: Text(e.value, style: TuneFonts.footnote)),
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _NoLyricsFound
// ---------------------------------------------------------------------------

class _NoLyricsFound extends StatelessWidget {
  const _NoLyricsFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lyrics_rounded,
              size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text('No lyrics found', style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Place a .lrc file next to the audio file with the same name.',
              style: TuneFonts.caption,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ErrorBody
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  final String error;
  const _ErrorBody({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline,
              size: 48, color: TuneColors.error),
          const SizedBox(height: 12),
          Text('Failed to load lyrics', style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(error,
                style: TuneFonts.caption, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
