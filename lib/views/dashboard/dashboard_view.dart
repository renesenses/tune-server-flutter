import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// DashboardView — Listen history dashboard
// Total plays, listening time, top artists/albums/tracks, hourly distribution,
// daily trend.
// Uses HistoryRepository via AppState.engine.db.historyRepo.
// Miroir de DashboardView.swift (iOS)
// ---------------------------------------------------------------------------

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  /// Period filter: null = all time, '7d', '30d', '90d'
  String? _period;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String? _sinceFromPeriod() {
    if (_period == null) return null;
    final days = switch (_period) {
      '7d' => 7,
      '30d' => 30,
      '90d' => 90,
      _ => null,
    };
    if (days == null) return null;
    return DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });

    try {
      final app = context.read<AppState>();

      // Remote mode: use API client
      if (app.isRemoteMode && app.apiClient != null) {
        final data = await app.apiClient!.getHistoryDashboard();
        if (!mounted) return;
        setState(() { _data = data; _loading = false; });
        return;
      }

      // Embedded mode: use repository directly
      final repo = app.engine.db.historyRepo;
      final since = _sinceFromPeriod();
      final data = await repo.dashboard(since: since);

      // Compute unique tracks/artists counts from top lists
      final topTracks = data['top_tracks'] as List? ?? [];
      final topArtists = data['top_artists'] as List? ?? [];

      data['unique_tracks'] = topTracks.length;
      data['unique_artists'] = topArtists.length;

      if (!mounted) return;
      setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _error = '$e'; });
    }
  }

  String _formatDuration(int ms) {
    final totalMinutes = ms ~/ 60000;
    if (totalMinutes < 60) return '${totalMinutes}m';
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours < 24) return '${hours}h ${mins}m';
    final days = hours ~/ 24;
    final remainingHours = hours % 24;
    return '${days}d ${remainingHours}h';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Dashboard', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                size: 22, color: TuneColors.textSecondary),
            tooltip: 'Refresh',
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: TuneColors.accent))
          : _error != null
              ? _ErrorState(error: _error!, onRetry: _load)
              : _data == null
                  ? const _EmptyDashboard()
                  : _buildContent(),
    );
  }

  Widget _buildContent() {
    final data = _data!;
    final totalListens = data['total_listens'] as int? ?? 0;
    final totalDurationMs = data['total_duration_ms'] as int? ?? 0;
    final uniqueTracks = data['unique_tracks'] as int? ?? 0;
    final uniqueArtists = data['unique_artists'] as int? ?? 0;
    final topTracks = (data['top_tracks'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final topArtists = (data['top_artists'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final topAlbums = (data['top_albums'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final hourly = (data['hourly_distribution'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (totalListens == 0) return const _EmptyDashboard();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Period filter
        _PeriodFilter(
          selected: _period,
          onChanged: (p) {
            _period = p;
            _load();
          },
        ),
        const SizedBox(height: 16),

        // Summary cards
        Row(
          children: [
            Expanded(child: _StatCard(
              icon: Icons.play_circle_rounded,
              label: 'Total Plays',
              value: '$totalListens',
            )),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(
              icon: Icons.timer_outlined,
              label: 'Listening Time',
              value: _formatDuration(totalDurationMs),
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(
              icon: Icons.music_note_rounded,
              label: 'Unique Tracks',
              value: '$uniqueTracks',
            )),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(
              icon: Icons.person_rounded,
              label: 'Unique Artists',
              value: '$uniqueArtists',
            )),
          ],
        ),

        // Top Artists
        if (topArtists.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text('TOP ARTISTS',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: TuneColors.textTertiary,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          _TopList(
            items: topArtists,
            titleKey: 'artist_name',
            subtitleKey: null,
            countKey: 'play_count',
            icon: Icons.person_rounded,
          ),
        ],

        // Top Albums
        if (topAlbums.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text('TOP ALBUMS',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: TuneColors.textTertiary,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          _TopList(
            items: topAlbums,
            titleKey: 'album_title',
            subtitleKey: 'artist_name',
            countKey: 'play_count',
            icon: Icons.album_rounded,
          ),
        ],

        // Top Tracks
        if (topTracks.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text('TOP TRACKS',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: TuneColors.textTertiary,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          _TopList(
            items: topTracks,
            titleKey: 'title',
            subtitleKey: 'artist_name',
            countKey: 'play_count',
            icon: Icons.music_note_rounded,
          ),
        ],

        // Hourly Distribution
        if (hourly.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text('LISTENING BY HOUR',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: TuneColors.textTertiary,
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          _HourlyChart(data: hourly),
        ],

        const SizedBox(height: 80),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _PeriodFilter
// ---------------------------------------------------------------------------

class _PeriodFilter extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _PeriodFilter({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('All Time', null),
        const SizedBox(width: 8),
        _chip('7 Days', '7d'),
        const SizedBox(width: 8),
        _chip('30 Days', '30d'),
        const SizedBox(width: 8),
        _chip('90 Days', '90d'),
      ],
    );
  }

  Widget _chip(String label, String? value) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? TuneColors.accent : TuneColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? TuneColors.textPrimary
                : TuneColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _StatCard
// ---------------------------------------------------------------------------

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: TuneColors.accent),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TuneColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: TuneFonts.caption),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TopList
// ---------------------------------------------------------------------------

class _TopList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String titleKey;
  final String? subtitleKey;
  final String countKey;
  final IconData icon;

  const _TopList({
    required this.items,
    required this.titleKey,
    this.subtitleKey,
    required this.countKey,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(
                  height: 1, indent: 52, color: TuneColors.divider),
            _TopListTile(
              rank: i + 1,
              title: '${items[i][titleKey] ?? 'Unknown'}',
              subtitle: subtitleKey != null
                  ? items[i][subtitleKey] as String?
                  : null,
              count: items[i][countKey] as int? ?? 0,
              icon: icon,
            ),
          ],
        ],
      ),
    );
  }
}

class _TopListTile extends StatelessWidget {
  final int rank;
  final String title;
  final String? subtitle;
  final int count;
  final IconData icon;

  const _TopListTile({
    required this.rank,
    required this.title,
    this.subtitle,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: rank <= 3 ? TuneColors.accent : TuneColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 18, color: TuneColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TuneFonts.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (subtitle != null)
                  Text(subtitle!,
                      style: TuneFonts.footnote,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: TuneColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: TuneColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _HourlyChart — simple bar chart using Container widgets
// ---------------------------------------------------------------------------

class _HourlyChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _HourlyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    // Build full 0-23 hour array
    final hourCounts = List<int>.filled(24, 0);
    for (final entry in data) {
      final hour = entry['hour'] as int? ?? 0;
      final count = entry['count'] as int? ?? 0;
      if (hour >= 0 && hour < 24) hourCounts[hour] = count;
    }

    final maxCount = hourCounts.reduce(math.max).clamp(1, double.maxFinite.toInt());

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int h = 0; h < 24; h++) ...[
                  if (h > 0) const SizedBox(width: 2),
                  Expanded(
                    child: Tooltip(
                      message: '${h.toString().padLeft(2, '0')}:00 - ${hourCounts[h]} plays',
                      child: Container(
                        height: (hourCounts[h] / maxCount * 100).clamp(2.0, 100.0),
                        decoration: BoxDecoration(
                          color: TuneColors.accent.withValues(
                            alpha: 0.4 + (hourCounts[h] / maxCount * 0.6),
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0h', style: TuneFonts.caption),
              Text('6h', style: TuneFonts.caption),
              Text('12h', style: TuneFonts.caption),
              Text('18h', style: TuneFonts.caption),
              Text('23h', style: TuneFonts.caption),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _EmptyDashboard
// ---------------------------------------------------------------------------

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart_rounded,
              size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text('No listening data yet',
              style: TuneFonts.subheadline),
          const SizedBox(height: 4),
          Text('Play some music to see your stats here.',
              style: TuneFonts.caption),
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
          Text('Failed to load dashboard',
              style: TuneFonts.subheadline),
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
