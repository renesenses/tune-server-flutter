import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/library/duplicate_detector.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// DuplicatesView — Duplicate track scanner
// Start scan, progress indicator, list duplicate groups with expandable
// details (title, artist, file path per track).
// Uses DuplicateDetector from lib/server/library/duplicate_detector.dart.
// Miroir de DuplicatesView.swift (iOS)
// ---------------------------------------------------------------------------

class DuplicatesView extends StatefulWidget {
  const DuplicatesView({super.key});

  @override
  State<DuplicatesView> createState() => _DuplicatesViewState();
}

class _DuplicatesViewState extends State<DuplicatesView> {
  List<DuplicateGroup>? _groups;
  bool _scanning = false;
  int _processed = 0;
  int _total = 0;
  String? _error;

  /// Tracks which groups are expanded in the UI.
  final Set<String> _expandedHashes = {};

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _processed = 0;
      _total = 0;
      _groups = null;
      _error = null;
      _expandedHashes.clear();
    });

    try {
      final app = context.read<AppState>();
      final detector = DuplicateDetector(app.engine.db);

      final groups = await detector.detect(
        onProgress: (processed, total) {
          if (mounted) {
            setState(() {
              _processed = processed;
              _total = total;
            });
          }
        },
      );

      if (!mounted) return;
      setState(() { _groups = groups; _scanning = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _scanning = false; _error = '$e'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Duplicate Scanner', style: TuneFonts.title3),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Initial state: no scan run yet
    if (_groups == null && !_scanning && _error == null) {
      return _InitialState(onScan: _startScan);
    }

    // Scanning
    if (_scanning) {
      return _ScanningState(processed: _processed, total: _total);
    }

    // Error
    if (_error != null) {
      return _ErrorState(error: _error!, onRetry: _startScan);
    }

    // Results
    final groups = _groups!;

    if (groups.isEmpty) {
      return _NoDuplicates(onRescan: _startScan);
    }

    return Column(
      children: [
        // Summary bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: TuneColors.surface,
          child: Row(
            children: [
              Icon(Icons.content_copy_rounded,
                  size: 18, color: TuneColors.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${groups.length} duplicate group${groups.length > 1 ? 's' : ''} found '
                  '(${groups.fold<int>(0, (sum, g) => sum + g.tracks.length)} tracks total)',
                  style: TuneFonts.footnote,
                ),
              ),
              TextButton(
                onPressed: _startScan,
                child: const Text('Rescan',
                    style: TextStyle(color: TuneColors.accent, fontSize: 13)),
              ),
            ],
          ),
        ),

        // Groups list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: groups.length,
            itemBuilder: (_, i) => _DuplicateGroupTile(
              group: groups[i],
              index: i,
              isExpanded: _expandedHashes.contains(groups[i].hash),
              onToggle: () {
                setState(() {
                  if (_expandedHashes.contains(groups[i].hash)) {
                    _expandedHashes.remove(groups[i].hash);
                  } else {
                    _expandedHashes.add(groups[i].hash);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _DuplicateGroupTile
// ---------------------------------------------------------------------------

class _DuplicateGroupTile extends StatelessWidget {
  final DuplicateGroup group;
  final int index;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _DuplicateGroupTile({
    required this.group,
    required this.index,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final firstTrack = group.tracks.first;

    return Column(
      children: [
        // Group header
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: TuneColors.divider, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: TuneColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${group.tracks.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: TuneColors.warning,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstTrack.title,
                        style: TuneFonts.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          if (firstTrack.artistName != null)
                            Flexible(
                              child: Text(
                                firstTrack.artistName!,
                                style: TuneFonts.footnote,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Text(
                            ' | ${group.hash.substring(0, 8)}',
                            style: TuneFonts.caption.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 22,
                  color: TuneColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        // Expanded details
        if (isExpanded)
          Container(
            color: TuneColors.surfaceVariant.withValues(alpha: 0.3),
            child: Column(
              children: [
                for (int i = 0; i < group.tracks.length; i++)
                  _TrackDetailRow(track: group.tracks[i], index: i),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _TrackDetailRow — single track within an expanded group
// ---------------------------------------------------------------------------

class _TrackDetailRow extends StatelessWidget {
  final dynamic track; // Track from database
  final int index;

  const _TrackDetailRow({required this.track, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 44), // indent
          Icon(Icons.audio_file_rounded,
              size: 16, color: TuneColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(track.title,
                    style: TuneFonts.callout,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (track.artistName != null)
                  Text(track.artistName!,
                      style: TuneFonts.footnote,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                if (track.filePath != null)
                  Text(track.filePath!,
                      style: TuneFonts.caption.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                if (track.format != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        _badge(track.format!),
                        if (track.sampleRate != null) ...[
                          const SizedBox(width: 4),
                          _badge('${(track.sampleRate! / 1000).toStringAsFixed(1)}kHz'),
                        ],
                        if (track.bitDepth != null) ...[
                          const SizedBox(width: 4),
                          _badge('${track.bitDepth}bit'),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 9,
              fontFamily: 'monospace',
              color: TuneColors.textSecondary)),
    );
  }
}

// ---------------------------------------------------------------------------
// _InitialState — before any scan
// ---------------------------------------------------------------------------

class _InitialState extends StatelessWidget {
  final VoidCallback onScan;
  const _InitialState({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.find_replace_rounded,
              size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 16),
          Text('Find duplicate tracks',
              style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Scans audio content hashes to find identical tracks '
              'in your library.',
              style: TuneFonts.caption,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onScan,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Start Scan'),
            style: FilledButton.styleFrom(
              backgroundColor: TuneColors.accent,
              minimumSize: const Size(180, 48),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ScanningState
// ---------------------------------------------------------------------------

class _ScanningState extends StatelessWidget {
  final int processed;
  final int total;

  const _ScanningState({required this.processed, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? processed / total : 0.0;
    final pct = (progress * 100).round();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: total > 0 ? progress : null,
              color: TuneColors.accent,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 20),
          Text('Scanning...', style: TuneFonts.title3),
          const SizedBox(height: 8),
          Text(
            total > 0
                ? '$processed / $total tracks ($pct%)'
                : 'Loading tracks...',
            style: TuneFonts.footnote,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _NoDuplicates
// ---------------------------------------------------------------------------

class _NoDuplicates extends StatelessWidget {
  final VoidCallback onRescan;
  const _NoDuplicates({required this.onRescan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 56, color: TuneColors.success),
          const SizedBox(height: 12),
          Text('No duplicates found', style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Text('Your library is clean.',
              style: TuneFonts.caption),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onRescan,
            child: const Text('Scan Again',
                style: TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ErrorState
// ---------------------------------------------------------------------------

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline,
              size: 48, color: TuneColors.error),
          const SizedBox(height: 12),
          Text('Scan failed', style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(error,
                style: TuneFonts.caption,
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: FilledButton.styleFrom(
              backgroundColor: TuneColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
