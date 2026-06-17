import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/domain_models.dart';
import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../../state/settings_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// SearchFilterView
// Shown inside HomeView (no query) when the user has metadata display fields
// enabled in Settings. Displays one filter row per enabled field, each with
// horizontally-scrollable chips. Tapping a chip queries
// GET /api/v1/library/tracks with the appropriate params and shows results.
// ---------------------------------------------------------------------------

class SearchFilterView extends StatefulWidget {
  const SearchFilterView({super.key});

  @override
  State<SearchFilterView> createState() => _SearchFilterViewState();
}

class _SearchFilterViewState extends State<SearchFilterView> {
  // Active filter per field (at most one chip selected per row).
  final Map<String, String> _activeFilters = {};

  // Fetched track results + meta.
  List<Map<String, dynamic>> _results = [];
  int _totalCount = 0;
  bool _loading = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Filter data — static options for each field
  // ---------------------------------------------------------------------------

  static const Map<String, List<String>> _staticChips = {
    'format': ['FLAC', 'WAV', 'MP3', 'AAC', 'DSD', 'ALAC', 'AIFF', 'OGG'],
    'sample_rate': [
      '44100', '48000', '88200', '96000', '176400', '192000', '352800', '384000'
    ],
    'bit_depth': ['16', '24', '32'],
    'source': ['local', 'tidal', 'qobuz', 'deezer', 'youtube'],
    'duration': ['<3', '3-5', '5-10', '>10'],
  };

  static const Map<String, String> _sampleRateLabels = {
    '44100': '44.1kHz',
    '48000': '48kHz',
    '88200': '88.2kHz',
    '96000': '96kHz',
    '176400': '176.4kHz',
    '192000': '192kHz',
    '352800': '352.8kHz',
    '384000': '384kHz',
  };

  static const Map<String, String> _bitDepthLabels = {
    '16': '16-bit',
    '24': '24-bit',
    '32': '32-bit',
  };

  static const Map<String, String> _sourceLabels = {
    'local': 'Local',
    'tidal': 'Tidal',
    'qobuz': 'Qobuz',
    'deezer': 'Deezer',
    'youtube': 'YouTube',
  };

  static const Map<String, String> _durationLabels = {
    '<3': '< 3min',
    '3-5': '3–5min',
    '5-10': '5–10min',
    '>10': '> 10min',
  };

  static const Map<String, String> _fieldLabels = {
    'format': 'Format',
    'sample_rate': 'Sample Rate',
    'bit_depth': 'Bit Depth',
    'genre': 'Genre',
    'year': 'Year',
    'source': 'Source',
    'duration': 'Duration',
  };

  // ---------------------------------------------------------------------------
  // Build chip lists dynamically (static + dynamic from library)
  // ---------------------------------------------------------------------------

  List<String> _chipsFor(String field, LibraryState lib) {
    if (field == 'genre') {
      // Derive genres from library albums, sorted alphabetically.
      final genres = <String>{};
      for (final album in lib.albums) {
        final g = album.genre?.trim();
        if (g != null && g.isNotEmpty) genres.add(g);
      }
      return genres.toList()..sort();
    }
    if (field == 'year') {
      // Derive years from library albums, descending, top 20.
      final years = <int>{};
      for (final album in lib.albums) {
        final y = album.year;
        if (y != null && y > 0) years.add(y);
      }
      final sorted = years.toList()..sort((a, b) => b.compareTo(a));
      return sorted.take(20).map((y) => y.toString()).toList();
    }
    return _staticChips[field] ?? [];
  }

  String _labelFor(String field, String value) {
    switch (field) {
      case 'sample_rate':
        return _sampleRateLabels[value] ?? value;
      case 'bit_depth':
        return _bitDepthLabels[value] ?? value;
      case 'source':
        return _sourceLabels[value] ?? value;
      case 'duration':
        return _durationLabels[value] ?? value;
      default:
        return value;
    }
  }

  // ---------------------------------------------------------------------------
  // Toggle chip → run query
  // ---------------------------------------------------------------------------

  void _toggleFilter(String field, String value) {
    setState(() {
      if (_activeFilters[field] == value) {
        _activeFilters.remove(field);
      } else {
        _activeFilters[field] = value;
      }
      // Clear results immediately on filter change.
      _results = [];
      _totalCount = 0;
    });
    if (_activeFilters.isEmpty) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _runQuery);
  }

  Future<void> _runQuery() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;

    final params = <String, String>{'limit': '50'};

    for (final entry in _activeFilters.entries) {
      switch (entry.key) {
        case 'format':
          params['format'] = entry.value.toLowerCase();
          break;
        case 'sample_rate':
          params['sample_rate'] = entry.value;
          break;
        case 'bit_depth':
          params['bit_depth'] = entry.value;
          break;
        case 'genre':
          params['genre'] = entry.value;
          break;
        case 'year':
          params['year'] = entry.value;
          break;
        case 'source':
          params['source'] = entry.value;
          break;
        case 'duration':
          _addDurationParams(params, entry.value);
          break;
      }
    }

    setState(() => _loading = true);
    try {
      final data = await api.getTracksFiltered(params);
      if (!mounted) return;
      final items = data['items'] as List? ?? [];
      final total = data['total'] as int? ?? items.length;
      setState(() {
        _results = items.cast<Map<String, dynamic>>();
        _totalCount = total;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _addDurationParams(Map<String, String> params, String value) {
    switch (value) {
      case '<3':
        params['max_duration_ms'] = '180000';
        break;
      case '3-5':
        params['min_duration_ms'] = '180000';
        params['max_duration_ms'] = '300000';
        break;
      case '5-10':
        params['min_duration_ms'] = '300000';
        params['max_duration_ms'] = '600000';
        break;
      case '>10':
        params['min_duration_ms'] = '600000';
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final enabledFields =
        context.watch<SettingsState>().metadataDisplayFields;
    final lib = context.watch<LibraryState>();

    // Only show fields that have at least one chip available.
    final activeFields = enabledFields
        .where((f) => _chipsFor(f, lib).isNotEmpty)
        .toList();

    if (activeFields.isEmpty) return const SizedBox.shrink();

    final hasActiveFilter = _activeFilters.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Filter rows ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Text(
            'Filter',
            style: TuneFonts.subheadline
                .copyWith(color: TuneColors.textPrimary),
          ),
        ),
        for (final field in activeFields)
          _FilterRow(
            field: field,
            label: _fieldLabels[field] ?? field,
            chips: _chipsFor(field, lib),
            selectedValue: _activeFilters[field],
            onChipSelected: (value) => _toggleFilter(field, value),
            labelFor: (v) => _labelFor(field, v),
          ),

        // --- Results section ---
        if (hasActiveFilter) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (_loading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: TuneColors.accent),
                  )
                else
                  Text(
                    '$_totalCount track${_totalCount != 1 ? "s" : ""}',
                    style: TuneFonts.footnote
                        .copyWith(color: TuneColors.textSecondary),
                  ),
                const Spacer(),
                if (_activeFilters.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _activeFilters.clear();
                        _results = [];
                        _totalCount = 0;
                      });
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4)),
                    child: const Text('Clear',
                        style: TextStyle(
                            color: TuneColors.accent, fontSize: 13)),
                  ),
              ],
            ),
          ),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 4),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              itemBuilder: (_, i) =>
                  _FilterResultTile(json: _results[i]),
            ),
          ],
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _FilterRow — one row: label + horizontal chip scroll
// ---------------------------------------------------------------------------

class _FilterRow extends StatelessWidget {
  final String field;
  final String label;
  final List<String> chips;
  final String? selectedValue;
  final void Function(String) onChipSelected;
  final String Function(String) labelFor;

  const _FilterRow({
    required this.field,
    required this.label,
    required this.chips,
    required this.selectedValue,
    required this.onChipSelected,
    required this.labelFor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left label
          SizedBox(
            width: 90,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                label,
                style: TuneFonts.caption.copyWith(
                    color: TuneColors.textSecondary,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Scrollable chips
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 16),
                itemCount: chips.length,
                itemBuilder: (_, i) {
                  final value = chips[i];
                  final isSelected = selectedValue == value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => onChipSelected(value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? TuneColors.accent
                              : TuneColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: TuneColors.divider, width: 1),
                        ),
                        child: Text(
                          labelFor(value),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : TuneColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FilterResultTile — single track row in filter results
// ---------------------------------------------------------------------------

class _FilterResultTile extends StatelessWidget {
  final Map<String, dynamic> json;
  const _FilterResultTile({required this.json});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final title = json['title'] as String? ?? '';
    final artist = json['artist_name'] as String? ?? '';
    final coverPath = json['cover_path'] as String?;
    final format = json['format'] as String?;
    final sampleRate = json['sample_rate'] as int?;

    final subtitle = [
      if (artist.isNotEmpty) artist,
      if (format != null) format.toUpperCase(),
      if (sampleRate != null) _formatSr(sampleRate),
    ].join(' · ');

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ArtworkView(filePath: coverPath, size: 40),
      ),
      title: Text(title,
          style: TuneFonts.footnote.copyWith(color: TuneColors.textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle,
              style: TuneFonts.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      onTap: () {
        final track = trackFromJson(json);
        app.playTracks([track]);
      },
    );
  }

  static String _formatSr(int hz) {
    if (hz >= 1000) {
      final k = hz / 1000.0;
      return k == k.truncateToDouble() ? '${k.toInt()}kHz' : '${k.toStringAsFixed(1)}kHz';
    }
    return '${hz}Hz';
  }
}
