import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

// ---------------------------------------------------------------------------
// T3.3 — ContentDirectoryClient
// Client SOAP pour le service ContentDirectory UPnP.
// Miroir de ContentDirectoryClient.swift (iOS)
//
// - Browse (BrowseDirectChildren / BrowseMetadata)
// - Parser DIDL-Lite → DIDLItem / DIDLContainer
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Types DIDL-Lite
// ---------------------------------------------------------------------------

/// Un item DIDL-Lite (fichier audio, vidéo, image…).
class DIDLItem {
  final String id;
  final String parentId;
  final String title;
  final String? artist;
  final String? album;
  final String? genre;
  final int? trackNumber;
  final int? year;
  final int? durationMs;
  final String? resourceUrl;
  final String? mimeType;
  final String? albumArtUrl;
  final int? sampleRate;
  final int? bitDepth;
  final int? channels;
  final int? bitrate;

  const DIDLItem({
    required this.id,
    required this.parentId,
    required this.title,
    this.artist,
    this.album,
    this.genre,
    this.trackNumber,
    this.year,
    this.durationMs,
    this.resourceUrl,
    this.mimeType,
    this.albumArtUrl,
    this.sampleRate,
    this.bitDepth,
    this.channels,
    this.bitrate,
  });
}

/// Un conteneur DIDL-Lite (dossier, album, artiste…).
class DIDLContainer {
  final String id;
  final String parentId;
  final String title;
  final int? childCount;

  const DIDLContainer({
    required this.id,
    required this.parentId,
    required this.title,
    this.childCount,
  });
}

/// Résultat d'un Browse.
class BrowseResult {
  final List<DIDLItem> items;
  final List<DIDLContainer> containers;
  final int totalMatches;
  final int numberReturned;

  const BrowseResult({
    required this.items,
    required this.containers,
    required this.totalMatches,
    required this.numberReturned,
  });

  bool get hasMore => numberReturned < totalMatches;
}

// ---------------------------------------------------------------------------
// Client SOAP
// ---------------------------------------------------------------------------

class ContentDirectoryClient {
  final String controlUrl;
  final http.Client _http;

  ContentDirectoryClient(this.controlUrl, {http.Client? client})
      : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Browse
  // ---------------------------------------------------------------------------

  /// Browse les enfants directs d'un conteneur.
  Future<BrowseResult> browseChildren(
    String objectId, {
    int startIndex = 0,
    int requestedCount = 200,
    String sortCriteria = '+dc:title',
  }) =>
      _browse(
        objectId: objectId,
        browseFlag: 'BrowseDirectChildren',
        startIndex: startIndex,
        requestedCount: requestedCount,
        sortCriteria: sortCriteria,
      );

  /// Browse les métadonnées d'un objet précis.
  Future<BrowseResult> browseMetadata(String objectId) =>
      _browse(
        objectId: objectId,
        browseFlag: 'BrowseMetadata',
        startIndex: 0,
        requestedCount: 1,
      );

  // ---------------------------------------------------------------------------
  // Implémentation SOAP
  // ---------------------------------------------------------------------------

  Future<BrowseResult> _browse({
    required String objectId,
    required String browseFlag,
    int startIndex = 0,
    int requestedCount = 200,
    String sortCriteria = '',
  }) async {
    final body = _buildSoapEnvelope(
      action: 'Browse',
      arguments: {
        'ObjectID': objectId,
        'BrowseFlag': browseFlag,
        'Filter': '*',
        'StartingIndex': '$startIndex',
        'RequestedCount': '$requestedCount',
        'SortCriteria': sortCriteria,
      },
    );

    final response = await _http
        .post(
          Uri.parse(controlUrl),
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': '"urn:schemas-upnp-org:service:ContentDirectory:1#Browse"',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
          'SOAP Browse failed: HTTP ${response.statusCode} for $objectId');
    }

    return _parseBrowseResponse(response.body);
  }

  // ---------------------------------------------------------------------------
  // Construction SOAP
  // ---------------------------------------------------------------------------

  String _buildSoapEnvelope(
      {required String action, required Map<String, String> arguments}) {
    final args = arguments.entries
        .map((e) => '<${e.key}>${_xmlEscape(e.value)}</${e.key}>')
        .join('');

    return '<?xml version="1.0" encoding="utf-8"?>'
        '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" '
        's:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
        '<s:Body>'
        '<u:$action xmlns:u="urn:schemas-upnp-org:service:ContentDirectory:1">'
        '$args'
        '</u:$action>'
        '</s:Body>'
        '</s:Envelope>';
  }

  // ---------------------------------------------------------------------------
  // Parsing réponse SOAP + DIDL-Lite
  // ---------------------------------------------------------------------------

  BrowseResult _parseBrowseResponse(String soapXml) {
    final doc = XmlDocument.parse(soapXml);

    final resultEl = doc.descendants
        .whereType<XmlElement>()
        .firstWhere((e) => e.localName == 'Result',
            orElse: () => throw Exception('No Result element in SOAP response'));

    final totalEl = doc.descendants
        .whereType<XmlElement>()
        .firstWhere((e) => e.localName == 'TotalMatches',
            orElse: () => XmlElement(XmlName('TotalMatches')));

    final returnedEl = doc.descendants
        .whereType<XmlElement>()
        .firstWhere((e) => e.localName == 'NumberReturned',
            orElse: () => XmlElement(XmlName('NumberReturned')));

    final totalMatches = int.tryParse(totalEl.innerText) ?? 0;
    final numberReturned = int.tryParse(returnedEl.innerText) ?? 0;

    // Le contenu DIDL-Lite est encodé en XML dans le texte de Result
    final didlXml = resultEl.innerText;
    final (items, containers) = _parseDIDL(didlXml);

    return BrowseResult(
      items: items,
      containers: containers,
      totalMatches: totalMatches,
      numberReturned: numberReturned,
    );
  }

  (List<DIDLItem>, List<DIDLContainer>) _parseDIDL(String didlXml) {
    if (didlXml.trim().isEmpty) return ([], []);

    final items = <DIDLItem>[];
    final containers = <DIDLContainer>[];

    try {
      final doc = XmlDocument.parse(didlXml);

      // Items (fichiers audio)
      for (final el in doc.findAllElements('item')) {
        final item = _parseItem(el);
        if (item != null) items.add(item);
      }

      // Containers (dossiers, albums, artistes…)
      for (final el in doc.findAllElements('container')) {
        final container = _parseContainer(el);
        if (container != null) containers.add(container);
      }
    } catch (_) {}

    return (items, containers);
  }

  DIDLItem? _parseItem(XmlElement el) {
    final id = el.getAttribute('id');
    final parentId = el.getAttribute('parentID');
    if (id == null || parentId == null) return null;

    final title = _dcText(el, 'title') ?? 'Unknown';
    final artist = _dcText(el, 'creator') ?? _upnpText(el, 'artist');
    final album = _upnpText(el, 'album');
    final genre = _upnpText(el, 'genre');
    final trackNumberStr = _upnpText(el, 'originalTrackNumber');
    final albumArtUrl = _upnpText(el, 'albumArtURI');

    // Resource
    final resEl = el.findElements('res').firstOrNull;
    final resourceUrl = resEl?.innerText.trim();
    final mimeType = resEl?.getAttribute('protocolInfo')
        ?.split(':')
        .elementAtOrNull(2);

    // Duration "H:MM:SS.mmm" → ms
    final durationStr = resEl?.getAttribute('duration');
    final durationMs = _parseDuration(durationStr);

    // Audio attributes
    final sampleFrequency =
        int.tryParse(resEl?.getAttribute('sampleFrequency') ?? '');
    final bitsPerSample =
        int.tryParse(resEl?.getAttribute('bitsPerSample') ?? '');
    final nrAudioChannels =
        int.tryParse(resEl?.getAttribute('nrAudioChannels') ?? '');
    final bitrate = int.tryParse(resEl?.getAttribute('bitrate') ?? '');

    // Year (dc:date → YYYY-MM-DD ou YYYY)
    final dateStr = _dcText(el, 'date');
    final year = dateStr != null ? int.tryParse(dateStr.split('-').first) : null;

    return DIDLItem(
      id: id,
      parentId: parentId,
      title: title,
      artist: artist,
      album: album,
      genre: genre,
      trackNumber: int.tryParse(trackNumberStr ?? ''),
      year: year,
      durationMs: durationMs,
      resourceUrl: resourceUrl,
      mimeType: mimeType,
      albumArtUrl: albumArtUrl,
      sampleRate: sampleFrequency,
      bitDepth: bitsPerSample,
      channels: nrAudioChannels,
      bitrate: bitrate,
    );
  }

  DIDLContainer? _parseContainer(XmlElement el) {
    final id = el.getAttribute('id');
    final parentId = el.getAttribute('parentID');
    if (id == null || parentId == null) return null;

    final title = _dcText(el, 'title') ?? 'Unknown';
    final childCount = int.tryParse(el.getAttribute('childCount') ?? '');

    return DIDLContainer(
      id: id,
      parentId: parentId,
      title: title,
      childCount: childCount,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers DIDL / Dublin Core
  // ---------------------------------------------------------------------------

  String? _dcText(XmlElement el, String name) {
    try {
      return el.findAllElements('dc:$name').first.innerText.trim();
    } catch (_) {
      try {
        return el
            .descendants
            .whereType<XmlElement>()
            .firstWhere((e) => e.localName == name)
            .innerText
            .trim();
      } catch (_) {
        return null;
      }
    }
  }

  String? _upnpText(XmlElement el, String name) {
    try {
      return el.findAllElements('upnp:$name').first.innerText.trim();
    } catch (_) {
      try {
        return el
            .descendants
            .whereType<XmlElement>()
            .firstWhere((e) => e.localName == name)
            .innerText
            .trim();
      } catch (_) {
        return null;
      }
    }
  }

  /// Parse "H:MM:SS.mmm" ou "MM:SS" → millisecondes.
  int? _parseDuration(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final parts = raw.split(':').map(double.parse).toList();
      if (parts.length == 3) {
        return ((parts[0] * 3600 + parts[1] * 60 + parts[2]) * 1000).round();
      } else if (parts.length == 2) {
        return ((parts[0] * 60 + parts[1]) * 1000).round();
      }
    } catch (_) {}
    return null;
  }

  String _xmlEscape(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');

  void close() => _http.close();
}
