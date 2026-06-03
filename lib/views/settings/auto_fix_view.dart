import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/event_bus.dart';
import '../../server/metadata/auto_fix.dart';
import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// AutoFixView — Auto-fix metadata via MusicBrainz
// Start scan, progress indicator, list of suggested fixes with
// apply/reject per item + apply-all for high-confidence fixes.
// Uses AutoFix from lib/server/metadata/auto_fix.dart.
// Miroir de AutoFixView.swift (iOS)
// ---------------------------------------------------------------------------

class AutoFixView extends StatefulWidget {
  const AutoFixView({super.key});

  @override
  State<AutoFixView> createState() => _AutoFixViewState();
}

class _AutoFixViewState extends State<AutoFixView> {
  List<MetadataFix>? _fixes;
  final Set<int> _rejected = {}; // indices of rejected fixes
  bool _scanning = false;
  bool _applying = false;
  int _processed = 0;
  int _total = 0;
  int _fixesFound = 0;
  String? _error;
  String? _applyResult;

  StreamSubscription? _progressSub;

  @override
  void initState() {
    super.initState();
    _progressSub = EventBus.instance.on<AutoFixProgressEvent>().listen((e) {
      if (mounted) {
        setState(() {
          _processed = e.processed;
          _total = e.total;
          _fixesFound = e.fixesFound;
        });
      }
    });
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }

  AutoFix get _autoFix => context.read<AppState>().engine.autoFix;

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _processed = 0;
      _total = 0;
      _fixesFound = 0;
      _fixes = null;
      _rejected.clear();
      _error = null;
      _applyResult = null;
    });

    try {
      final fixes = await _autoFix.scan();
      if (!mounted) return;
      setState(() { _fixes = fixes; _scanning = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _scanning = false; _error = '$e'; });
    }
  }

  void _cancelScan() {
    _autoFix.cancel();
  }

  Future<void> _applySingle(int index) async {
    final fix = _fixes![index];
    setState(() => _applying = true);

    try {
      final count = await _autoFix.apply([fix]);
      if (!mounted) return;
      setState(() {
        _applying = false;
        _rejected.add(index); // remove from actionable list
        _applyResult = 'Applied $count fix${count != 1 ? 'es' : ''}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_applyResult!)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() { _applying = false; _error = '$e'; });
    }
  }

  void _rejectSingle(int index) {
    setState(() => _rejected.add(index));
  }

  Future<void> _applyAllHighConfidence() async {
    final fixes = _fixes;
    if (fixes == null) return;

    final highConfidence = <MetadataFix>[];
    for (int i = 0; i < fixes.length; i++) {
      if (!_rejected.contains(i) && fixes[i].confidence >= 0.8) {
        highConfidence.add(fixes[i]);
      }
    }

    if (highConfidence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No high-confidence fixes remaining')),
      );
      return;
    }

    setState(() => _applying = true);

    try {
      final count = await _autoFix.apply(highConfidence);
      if (!mounted) return;

      // Mark applied indices as rejected
      for (int i = 0; i < fixes.length; i++) {
        if (!_rejected.contains(i) && fixes[i].confidence >= 0.8) {
          _rejected.add(i);
        }
      }

      setState(() {
        _applying = false;
        _applyResult = 'Applied $count fix${count != 1 ? 'es' : ''}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_applyResult!)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() { _applying = false; _error = '$e'; });
    }
  }

  int get _remainingCount {
    if (_fixes == null) return 0;
    return _fixes!.length - _rejected.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Auto Fix Metadata', style: TuneFonts.title3),
        actions: [
          if (_scanning)
            IconButton(
              icon: const Icon(Icons.cancel_rounded,
                  size: 22, color: TuneColors.error),
              tooltip: 'Cancel',
              onPressed: _cancelScan,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Initial state
    if (_fixes == null && !_scanning && _error == null) {
      return _InitialState(onScan: _startScan);
    }

    // Scanning
    if (_scanning) {
      return _ScanningState(
        processed: _processed,
        total: _total,
        fixesFound: _fixesFound,
      );
    }

    // Error
    if (_error != null && _fixes == null) {
      return _ErrorState(error: _error!, onRetry: _startScan);
    }

    // Results
    final fixes = _fixes!;
    if (fixes.isEmpty) {
      return _NoFixesFound(onRescan: _startScan);
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
              Icon(Icons.auto_fix_high_rounded,
                  size: 18, color: TuneColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$_remainingCount suggestion${_remainingCount != 1 ? 's' : ''} remaining',
                  style: TuneFonts.footnote,
                ),
              ),
              if (_remainingCount > 0 && !_applying)
                TextButton(
                  onPressed: _applyAllHighConfidence,
                  child: const Text('Apply High Conf.',
                      style: TextStyle(color: TuneColors.accent, fontSize: 13)),
                ),
            ],
          ),
        ),

        if (_error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: TuneColors.error.withValues(alpha: 0.12),
            child: Text(_error!,
                style: TuneFonts.caption.copyWith(color: TuneColors.error)),
          ),

        if (_applying)
          const LinearProgressIndicator(
            color: TuneColors.accent,
            backgroundColor: TuneColors.surface,
          ),

        // Fixes list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: fixes.length,
            itemBuilder: (_, i) {
              if (_rejected.contains(i)) return const SizedBox.shrink();
              return _FixTile(
                fix: fixes[i],
                onApply: _applying ? null : () => _applySingle(i),
                onReject: _applying ? null : () => _rejectSingle(i),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _FixTile — single suggested fix
// ---------------------------------------------------------------------------

class _FixTile extends StatelessWidget {
  final MetadataFix fix;
  final VoidCallback? onApply;
  final VoidCallback? onReject;

  const _FixTile({
    required this.fix,
    this.onApply,
    this.onReject,
  });

  String _fieldLabel(String field) {
    return switch (field) {
      'genre' => 'Genre',
      'year' => 'Year',
      'isrc' => 'ISRC',
      'musicbrainz_recording_id' => 'MBID',
      _ => field,
    };
  }

  Color _confidenceColor(double c) {
    if (c >= 0.9) return TuneColors.success;
    if (c >= 0.7) return TuneColors.warning;
    return TuneColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final confPct = (fix.confidence * 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: field + confidence
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TuneColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _fieldLabel(fix.field),
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TuneColors.accent),
                ),
              ),
              const SizedBox(width: 8),
              Text('Track #${fix.trackId}',
                  style: TuneFonts.caption),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _confidenceColor(fix.confidence),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text('$confPct%',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _confidenceColor(fix.confidence))),
            ],
          ),
          const SizedBox(height: 8),

          // Current -> Suggested
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current',
                        style: TuneFonts.caption
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      fix.oldValue ?? '(empty)',
                      style: TuneFonts.footnote.copyWith(
                        fontStyle: fix.oldValue == null
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 16, color: TuneColors.textTertiary),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Suggested',
                        style: TuneFonts.caption
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(fix.newValue,
                        style: TuneFonts.footnote.copyWith(
                          color: TuneColors.accent,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onReject,
                style: TextButton.styleFrom(
                  foregroundColor: TuneColors.textTertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Skip'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onApply,
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(0, 32),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _InitialState
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
          const Icon(Icons.auto_fix_high_rounded,
              size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 16),
          Text('Fix missing metadata', style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Scans tracks with missing genre, year, or MusicBrainz IDs '
              'and suggests fixes from MusicBrainz.',
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
  final int fixesFound;

  const _ScanningState({
    required this.processed,
    required this.total,
    required this.fixesFound,
  });

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
          Text('Scanning MusicBrainz...', style: TuneFonts.title3),
          const SizedBox(height: 8),
          Text(
            total > 0
                ? '$processed / $total tracks ($pct%)'
                : 'Loading tracks...',
            style: TuneFonts.footnote,
          ),
          const SizedBox(height: 4),
          Text(
            '$fixesFound fix${fixesFound != 1 ? 'es' : ''} found so far',
            style: TuneFonts.caption.copyWith(color: TuneColors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            'Rate limited to 1 req/s (MusicBrainz policy)',
            style: TuneFonts.caption,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _NoFixesFound
// ---------------------------------------------------------------------------

class _NoFixesFound extends StatelessWidget {
  final VoidCallback onRescan;
  const _NoFixesFound({required this.onRescan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 56, color: TuneColors.success),
          const SizedBox(height: 12),
          Text('No fixes needed', style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Text('All tracks have complete metadata.',
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
