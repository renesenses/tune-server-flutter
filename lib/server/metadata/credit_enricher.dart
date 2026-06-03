import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// CreditEnricher
// MusicBrainz recording lookup + credits extraction (performers,
// producers, engineers).
// Miroir de credit_enricher.rs (Rust)
// ---------------------------------------------------------------------------

/// A single credit entry for a recording.
class Credit {
  final String name;
  final String role;        // 'performer', 'producer', 'engineer', 'mix', 'vocal', etc.
  final String? instrument; // e.g. 'guitar', 'drums', null for non-performers

  const Credit({
    required this.name,
    required this.role,
    this.instrument,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
        if (instrument != null) 'instrument': instrument,
      };
}

/// Full credits for a recording.
class RecordingCredits {
  final String recordingId;
  final String? title;
  final List<Credit> credits;

  const RecordingCredits({
    required this.recordingId,
    this.title,
    required this.credits,
  });

  List<Credit> get performers =>
      credits.where((c) => c.role == 'performer' || c.instrument != null).toList();

  List<Credit> get producers =>
      credits.where((c) => c.role == 'producer').toList();

  List<Credit> get engineers =>
      credits.where((c) => c.role == 'engineer' || c.role == 'mix' || c.role == 'mastering').toList();

  Map<String, dynamic> toJson() => {
        'recording_id': recordingId,
        'title': title,
        'credit_count': credits.length,
        'credits': credits.map((c) => c.toJson()).toList(),
      };
}

class CreditEnricher {
  static const _baseUrl = 'https://musicbrainz.org/ws/2';
  static const _userAgent = 'Tune/1.0 (https://mozaiklabs.fr)';

  final http.Client _http;

  /// Rate limit: MusicBrainz allows 1 request per second
  DateTime _lastRequest = DateTime(2000);
  static const _minInterval = Duration(milliseconds: 1100);

  CreditEnricher({http.Client? client}) : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Lookup
  // ---------------------------------------------------------------------------

  /// Fetch credits for a MusicBrainz recording ID.
  Future<RecordingCredits?> lookup(String recordingId) async {
    if (recordingId.isEmpty) return null;

    await _rateLimit();

    try {
      final url = '$_baseUrl/recording/$recordingId'
          '?inc=artist-rels+work-rels&fmt=json';

      final response = await _http.get(
        Uri.parse(url),
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode != 200) {
        debugPrint('[CreditEnricher] MusicBrainz returned ${response.statusCode} '
            'for recording $recordingId');
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return _parseCredits(recordingId, json);
    } catch (e) {
      debugPrint('[CreditEnricher] Error fetching credits for $recordingId: $e');
      return null;
    }
  }

  /// Batch lookup for multiple recording IDs.
  /// Respects MusicBrainz rate limits (1 req/s).
  Future<List<RecordingCredits>> lookupBatch(List<String> recordingIds) async {
    final results = <RecordingCredits>[];
    for (final id in recordingIds) {
      final credits = await lookup(id);
      if (credits != null) {
        results.add(credits);
      }
    }
    return results;
  }

  // ---------------------------------------------------------------------------
  // Parse
  // ---------------------------------------------------------------------------

  RecordingCredits _parseCredits(
    String recordingId,
    Map<String, dynamic> json,
  ) {
    final title = json['title'] as String?;
    final relations = json['relations'] as List<dynamic>? ?? [];
    final credits = <Credit>[];

    for (final rel in relations) {
      final relMap = rel as Map<String, dynamic>;
      final type = relMap['type'] as String? ?? '';
      final artist = relMap['artist'] as Map<String, dynamic>?;
      if (artist == null) continue;

      final name = artist['name'] as String? ?? '';
      if (name.isEmpty) continue;

      final attributes = (relMap['attributes'] as List<dynamic>?)
          ?.map((a) => a.toString())
          .toList() ?? [];

      // Map MusicBrainz relationship types to our credit roles
      final role = _mapRole(type);
      final instrument = _extractInstrument(type, attributes);

      credits.add(Credit(
        name: name,
        role: role,
        instrument: instrument,
      ));
    }

    return RecordingCredits(
      recordingId: recordingId,
      title: title,
      credits: credits,
    );
  }

  String _mapRole(String mbType) {
    switch (mbType.toLowerCase()) {
      case 'performer':
      case 'instrument':
      case 'vocal':
        return 'performer';
      case 'producer':
        return 'producer';
      case 'engineer':
      case 'recording':
        return 'engineer';
      case 'mix':
      case 'audio':
        return 'mix';
      case 'mastering':
        return 'mastering';
      case 'conductor':
        return 'conductor';
      case 'composer':
      case 'writer':
      case 'lyricist':
        return 'composer';
      case 'arranger':
      case 'orchestrator':
        return 'arranger';
      default:
        return mbType.isEmpty ? 'other' : mbType;
    }
  }

  String? _extractInstrument(String type, List<String> attributes) {
    if (type == 'instrument' || type == 'performer') {
      // Attributes often contain the instrument name
      for (final attr in attributes) {
        final lower = attr.toLowerCase();
        if (lower != 'lead vocals' &&
            lower != 'background vocals' &&
            lower != 'guest' &&
            lower != 'additional') {
          return attr;
        }
      }
      // For vocal performers
      if (type == 'vocal' || attributes.any((a) => a.toLowerCase().contains('vocal'))) {
        return attributes.isNotEmpty ? attributes.first : 'vocals';
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Rate limiting
  // ---------------------------------------------------------------------------

  Future<void> _rateLimit() async {
    final elapsed = DateTime.now().difference(_lastRequest);
    if (elapsed < _minInterval) {
      await Future.delayed(_minInterval - elapsed);
    }
    _lastRequest = DateTime.now();
  }

  void dispose() {
    _http.close();
  }
}
