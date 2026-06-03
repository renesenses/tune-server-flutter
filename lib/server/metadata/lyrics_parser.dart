import 'dart:io';

import 'package:path/path.dart' as p;

// ---------------------------------------------------------------------------
// LyricsParser
// LRC format parser (synced lyrics with timestamps), sidecar .lrc file lookup.
// Miroir de lyrics_parser.rs (Rust)
// ---------------------------------------------------------------------------

/// A single synced lyric line with timestamp.
class LyricLine {
  final Duration timestamp;
  final String text;

  const LyricLine({required this.timestamp, required this.text});

  Map<String, dynamic> toJson() => {
        'timestamp_ms': timestamp.inMilliseconds,
        'text': text,
      };
}

/// Parsed lyrics result (synced or plain).
class ParsedLyrics {
  final bool synced;
  final List<LyricLine> lines;
  final Map<String, String> metadata; // [ar], [ti], [al], [by], [offset], etc.

  const ParsedLyrics({
    required this.synced,
    required this.lines,
    this.metadata = const {},
  });

  /// Plain text version of the lyrics.
  String get plainText => lines.map((l) => l.text).join('\n');

  Map<String, dynamic> toJson() => {
        'synced': synced,
        'line_count': lines.length,
        'metadata': metadata,
        'lines': lines.map((l) => l.toJson()).toList(),
      };
}

class LyricsParser {
  LyricsParser._();

  // ---------------------------------------------------------------------------
  // LRC format regex
  // [mm:ss.xx] text  OR  [mm:ss:xx] text
  // ---------------------------------------------------------------------------

  static final _timestampRegex =
      RegExp(r'\[(\d{1,3}):(\d{2})[\.:]+(\d{1,3})\]');

  /// Metadata tags like [ar:Artist], [ti:Title], etc.
  static final _metadataRegex = RegExp(r'\[([a-z]+):(.+)\]', caseSensitive: false);

  // ---------------------------------------------------------------------------
  // Parse LRC content
  // ---------------------------------------------------------------------------

  /// Parse LRC-formatted text into synced lyrics.
  static ParsedLyrics parse(String lrcContent) {
    final lines = <LyricLine>[];
    final metadata = <String, String>{};

    for (final rawLine in lrcContent.split('\n')) {
      final trimmed = rawLine.trim();
      if (trimmed.isEmpty) continue;

      // Check for metadata tag
      final metaMatch = _metadataRegex.firstMatch(trimmed);
      if (metaMatch != null &&
          !_timestampRegex.hasMatch(trimmed)) {
        final key = metaMatch.group(1)!.toLowerCase();
        final value = metaMatch.group(2)!.trim();
        metadata[key] = value;
        continue;
      }

      // Parse timestamp(s) — some LRC files have multiple timestamps per line
      final timestamps = <Duration>[];
      String text = trimmed;

      for (final match in _timestampRegex.allMatches(trimmed)) {
        final minutes = int.parse(match.group(1)!);
        final seconds = int.parse(match.group(2)!);
        var centiseconds = int.parse(match.group(3)!);

        // If centiseconds has 3 digits, it's milliseconds
        if (centiseconds >= 100) {
          centiseconds = centiseconds ~/ 10;
        }

        timestamps.add(Duration(
          minutes: minutes,
          seconds: seconds,
          milliseconds: centiseconds * 10,
        ));

        // Remove timestamp from text
        text = text.replaceFirst(match.group(0)!, '');
      }

      text = text.trim();
      if (text.isEmpty && timestamps.isEmpty) continue;

      // Apply offset if specified
      final offsetMs = int.tryParse(metadata['offset'] ?? '0') ?? 0;
      final offset = Duration(milliseconds: offsetMs);

      // Create a line for each timestamp (multiple timestamps = same lyric at different times)
      for (final ts in timestamps) {
        var adjusted = ts + offset;
        if (adjusted.isNegative) adjusted = Duration.zero;
        lines.add(LyricLine(timestamp: adjusted, text: text));
      }

      // If no timestamps found, add as a plain line
      if (timestamps.isEmpty && text.isNotEmpty) {
        lines.add(LyricLine(timestamp: Duration.zero, text: text));
      }
    }

    // Sort by timestamp
    lines.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final synced = lines.any((l) => l.timestamp > Duration.zero);

    return ParsedLyrics(
      synced: synced,
      lines: lines,
      metadata: metadata,
    );
  }

  // ---------------------------------------------------------------------------
  // Sidecar .lrc file lookup
  // ---------------------------------------------------------------------------

  /// Look for a sidecar .lrc file next to the audio file.
  /// Checks: same name with .lrc extension, then lowercase.
  static Future<ParsedLyrics?> findSidecar(String audioFilePath) async {
    final dir = p.dirname(audioFilePath);
    final baseName = p.basenameWithoutExtension(audioFilePath);

    // Try exact case
    final lrcPath = p.join(dir, '$baseName.lrc');
    final lrcFile = File(lrcPath);
    if (lrcFile.existsSync()) {
      final content = await lrcFile.readAsString();
      return parse(content);
    }

    // Try lowercase
    final lrcPathLower = p.join(dir, '${baseName.toLowerCase()}.lrc');
    final lrcFileLower = File(lrcPathLower);
    if (lrcFileLower.existsSync()) {
      final content = await lrcFileLower.readAsString();
      return parse(content);
    }

    // Try uppercase extension
    final lrcPathUpper = p.join(dir, '$baseName.LRC');
    final lrcFileUpper = File(lrcPathUpper);
    if (lrcFileUpper.existsSync()) {
      final content = await lrcFileUpper.readAsString();
      return parse(content);
    }

    return null;
  }

  /// Get the lyric line active at a given position.
  static LyricLine? lineAt(List<LyricLine> lines, Duration position) {
    if (lines.isEmpty) return null;

    LyricLine? active;
    for (final line in lines) {
      if (line.timestamp <= position) {
        active = line;
      } else {
        break;
      }
    }
    return active;
  }
}
