import 'package:flutter/material.dart';

import '../server/database/database.dart';
import '../views/helpers/tune_colors.dart';

// ---------------------------------------------------------------------------
// MetadataChips — compact inline metadata row under track tiles.
//
// Takes a Track and a list of selected field names (from SharedPreferences
// key `metadata_display_fields`). Renders a single line of text chips
// separated by " · ".
//
// Available fields:
//   format      — e.g. "FLAC"
//   sample_rate — e.g. "96kHz"  (combined with bit_depth when both selected)
//   bit_depth   — e.g. "24bit"
//   genre       — from track (not available on local Track model, ignored)
//   year        — from track (not available on local Track model, ignored)
//   label       — not in Track model, ignored
//   composer    — not in Track model, ignored
//   duration    — e.g. "3:45"
//   source      — e.g. "tidal", "local"
// ---------------------------------------------------------------------------

class MetadataChips extends StatelessWidget {
  final Track track;
  final List<String> selectedFields;

  const MetadataChips({
    super.key,
    required this.track,
    required this.selectedFields,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedFields.isEmpty) return const SizedBox.shrink();

    final chips = _buildChips();
    if (chips.isEmpty) return const SizedBox.shrink();

    return Text(
      chips.join(' · '),
      style: const TextStyle(
        fontSize: 11,
        color: TuneColors.textTertiary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<String> _buildChips() {
    final result = <String>[];
    final hasSampleRate = selectedFields.contains('sample_rate');
    final hasBitDepth = selectedFields.contains('bit_depth');

    for (final field in selectedFields) {
      switch (field) {
        case 'format':
          final fmt = track.format;
          if (fmt != null && fmt.isNotEmpty) {
            result.add(fmt.toUpperCase());
          }
          break;

        case 'sample_rate':
          // Combine with bit_depth in one chip if both selected
          if (hasBitDepth) {
            // Will be handled together under 'sample_rate' (first occurrence)
            final chip = _audioQualityChip();
            if (chip != null) result.add(chip);
          } else {
            final sr = track.sampleRate;
            if (sr != null) {
              result.add(_formatSampleRate(sr));
            }
          }
          break;

        case 'bit_depth':
          // Skip if sample_rate is also selected (already combined above)
          if (!hasSampleRate) {
            final bd = track.bitDepth;
            if (bd != null && bd > 0) {
              result.add('${bd}bit');
            }
          }
          break;

        case 'duration':
          final ms = track.durationMs;
          if (ms != null && ms > 0) {
            result.add(_formatDuration(ms));
          }
          break;

        case 'source':
          final src = track.source;
          if (src.isNotEmpty && src != 'local') {
            result.add(src[0].toUpperCase() + src.substring(1));
          }
          break;

        // Fields not on the Track model — silently ignored
        // genre, year, label, composer come from Album, not Track
        case 'genre':
        case 'year':
        case 'label':
        case 'composer':
          break;
      }
    }

    return result;
  }

  /// Returns "96kHz/24bit" when both sample_rate and bit_depth are selected,
  /// or just the sample rate / bit depth individually.
  String? _audioQualityChip() {
    final sr = track.sampleRate;
    final bd = track.bitDepth;
    if (sr == null && bd == null) return null;
    if (sr != null && bd != null && bd > 0) {
      return '${_formatSampleRate(sr)}/${bd}bit';
    }
    if (sr != null) return _formatSampleRate(sr);
    if (bd != null && bd > 0) return '${bd}bit';
    return null;
  }

  static String _formatSampleRate(int hz) {
    if (hz >= 1000) {
      final khz = hz / 1000.0;
      return khz == khz.truncateToDouble()
          ? '${khz.toInt()}kHz'
          : '${khz.toStringAsFixed(1)}kHz';
    }
    return '${hz}Hz';
  }

  static String _formatDuration(int ms) {
    final total = ms ~/ 1000;
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
