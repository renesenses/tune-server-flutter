import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../utils/mime_utils.dart';
import 'output_target.dart';

// ---------------------------------------------------------------------------
// OpenHomeOutput
// Output OpenHome via SOAP (Transport, Playlist, Volume, Info, Time, Product).
// Miroir de OpenHomeOutput.swift (iOS)
//
// OpenHome is a modern UPnP-based protocol used by Linn, Naim, and others.
// Services used:
//   - Product:1      — source selection, standby
//   - Volume:3       — volume control
//   - Transport:1    — play, pause, stop, seek (newer devices)
//   - Playlist:1     — SetUri + Play (older devices, fallback)
//   - Info:1         — track metadata
//   - Time:1         — playback position
// ---------------------------------------------------------------------------

class OpenHomeOutput implements OutputTarget {
  @override
  final String id;

  @override
  final String displayName;

  final String host;
  final int port;
  final http.Client _http;

  /// Service control URLs discovered from the device description.
  String? _productUrl;
  String? _volumeUrl;
  String? _transportUrl;
  String? _playlistUrl;
  String? _timeUrl;

  OutputReadyState _readyState = OutputReadyState.idle;
  double _volume = 0.5;
  bool _playing = false;

  OpenHomeOutput({
    required this.id,
    required this.displayName,
    required this.host,
    required this.port,
    String? productUrl,
    String? volumeUrl,
    String? transportUrl,
    String? playlistUrl,
    String? timeUrl,
    http.Client? client,
  })  : _productUrl = productUrl,
        _volumeUrl = volumeUrl,
        _transportUrl = transportUrl,
        _playlistUrl = playlistUrl,
        _timeUrl = timeUrl,
        _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> prepare() async {
    // Discover service URLs if not already set
    if (_productUrl == null) {
      await _discoverServices();
    }

    if (_productUrl == null && _transportUrl == null && _playlistUrl == null) {
      _readyState = OutputReadyState.error;
      return const OutputFailure('OpenHome: no services found');
    }

    _readyState = OutputReadyState.ready;

    // Take device out of standby
    await _setStandby(false);

    // Select a Playlist source if available
    await _selectPlaylistSource();

    // Fetch current volume
    await _fetchCurrentVolume();

    return const OutputSuccess();
  }

  @override
  Future<void> dispose() async {
    _http.close();
    _readyState = OutputReadyState.idle;
    _playing = false;
  }

  // ---------------------------------------------------------------------------
  // Transport
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> play(
    String url, {
    String? title,
    String? artist,
    String? album,
    String? albumArtUrl,
  }) async {
    final didl = _buildDIDLMetadata(
      url: url,
      title: title ?? 'Unknown',
      artist: artist,
      albumArtUrl: albumArtUrl,
    );

    // Strategy: try Transport service first, fall back to Playlist service
    if (_transportUrl != null) {
      return _playViaTransport(url, didl);
    } else if (_playlistUrl != null) {
      return _playViaPlaylist(url, didl);
    }

    return const OutputFailure('OpenHome: no transport or playlist service');
  }

  Future<OutputResult> _playViaTransport(String url, String didl) async {
    // Stop current, set URI, then play
    await _soapAction(
      url: _transportUrl!,
      service: 'Transport',
      serviceVersion: 1,
      action: 'Stop',
      args: {},
      ns: 'av-openhome-org',
    );

    final setOk = await _soapAction(
      url: _transportUrl!,
      service: 'Transport',
      serviceVersion: 1,
      action: 'SetUri',
      args: {'Uri': url, 'Metadata': didl},
      ns: 'av-openhome-org',
    );
    if (!setOk) return const OutputFailure('OpenHome Transport SetUri failed');

    final playOk = await _soapAction(
      url: _transportUrl!,
      service: 'Transport',
      serviceVersion: 1,
      action: 'Play',
      args: {},
      ns: 'av-openhome-org',
    );
    if (playOk) {
      _playing = true;
      return const OutputSuccess();
    }
    return const OutputFailure('OpenHome Transport Play failed');
  }

  Future<OutputResult> _playViaPlaylist(String url, String didl) async {
    // Clear playlist, insert track, then play
    await _soapAction(
      url: _playlistUrl!,
      service: 'Playlist',
      serviceVersion: 1,
      action: 'DeleteAll',
      args: {},
      ns: 'av-openhome-org',
    );

    // Insert track at position 0
    final insertResponse = await _soapRequest(
      url: _playlistUrl!,
      service: 'Playlist',
      serviceVersion: 1,
      action: 'Insert',
      args: {
        'AfterId': '0',
        'Uri': url,
        'Metadata': didl,
      },
      ns: 'av-openhome-org',
    );

    if (insertResponse == null) {
      return const OutputFailure('OpenHome Playlist Insert failed');
    }

    // Extract new track ID from response
    String newId = '0';
    try {
      final doc = XmlDocument.parse(insertResponse);
      final newIdEl = doc.descendants
          .whereType<XmlElement>()
          .where((e) => e.localName == 'NewId')
          .firstOrNull;
      if (newIdEl != null) {
        newId = newIdEl.innerText.trim();
      }
    } catch (_) {}

    // Seek to the inserted track
    await _soapAction(
      url: _playlistUrl!,
      service: 'Playlist',
      serviceVersion: 1,
      action: 'SeekId',
      args: {'Value': newId},
      ns: 'av-openhome-org',
    );

    // Play
    final playOk = await _soapAction(
      url: _playlistUrl!,
      service: 'Playlist',
      serviceVersion: 1,
      action: 'Play',
      args: {},
      ns: 'av-openhome-org',
    );
    if (playOk) {
      _playing = true;
      return const OutputSuccess();
    }
    return const OutputFailure('OpenHome Playlist Play failed');
  }

  @override
  Future<OutputResult> pause() async {
    final serviceUrl = _transportUrl ?? _playlistUrl;
    final serviceName = _transportUrl != null ? 'Transport' : 'Playlist';
    if (serviceUrl == null) return const OutputFailure('No OpenHome service');

    final ok = await _soapAction(
      url: serviceUrl,
      service: serviceName,
      serviceVersion: 1,
      action: 'Pause',
      args: {},
      ns: 'av-openhome-org',
    );
    if (ok) _playing = false;
    return ok
        ? const OutputSuccess()
        : const OutputFailure('OpenHome Pause failed');
  }

  @override
  Future<OutputResult> resume() async {
    final serviceUrl = _transportUrl ?? _playlistUrl;
    final serviceName = _transportUrl != null ? 'Transport' : 'Playlist';
    if (serviceUrl == null) return const OutputFailure('No OpenHome service');

    final ok = await _soapAction(
      url: serviceUrl,
      service: serviceName,
      serviceVersion: 1,
      action: 'Play',
      args: {},
      ns: 'av-openhome-org',
    );
    if (ok) _playing = true;
    return ok
        ? const OutputSuccess()
        : const OutputFailure('OpenHome Resume failed');
  }

  @override
  Future<OutputResult> stop() async {
    final serviceUrl = _transportUrl ?? _playlistUrl;
    final serviceName = _transportUrl != null ? 'Transport' : 'Playlist';
    if (serviceUrl == null) return const OutputFailure('No OpenHome service');

    final ok = await _soapAction(
      url: serviceUrl,
      service: serviceName,
      serviceVersion: 1,
      action: 'Stop',
      args: {},
      ns: 'av-openhome-org',
    );
    if (ok) _playing = false;
    return ok
        ? const OutputSuccess()
        : const OutputFailure('OpenHome Stop failed');
  }

  @override
  Future<OutputResult> seek(Duration position) async {
    final serviceUrl = _transportUrl ?? _playlistUrl;
    final serviceName = _transportUrl != null ? 'Transport' : 'Playlist';
    if (serviceUrl == null) return const OutputFailure('No OpenHome service');

    final seconds = position.inSeconds;
    final ok = await _soapAction(
      url: serviceUrl,
      service: serviceName,
      serviceVersion: 1,
      action: 'SeekSecondAbsolute',
      args: {'Value': '$seconds'},
      ns: 'av-openhome-org',
    );
    return ok
        ? const OutputSuccess()
        : const OutputFailure('OpenHome Seek failed');
  }

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> setVolume(double volume) async {
    if (_volumeUrl == null) {
      _volume = volume;
      return const OutputSuccess();
    }

    // OpenHome Volume is typically 0-100
    final ohVolume = (volume * 100).round().clamp(0, 100);
    final ok = await _soapAction(
      url: _volumeUrl!,
      service: 'Volume',
      serviceVersion: 3,
      action: 'SetVolume',
      args: {'Value': '$ohVolume'},
      ns: 'av-openhome-org',
    );
    if (ok) _volume = volume;
    return ok
        ? const OutputSuccess()
        : const OutputFailure('OpenHome SetVolume failed');
  }

  @override
  double? get currentVolume => _volume;

  Future<void> _fetchCurrentVolume() async {
    if (_volumeUrl == null) return;
    try {
      final response = await _soapRequest(
        url: _volumeUrl!,
        service: 'Volume',
        serviceVersion: 3,
        action: 'Volume',
        args: {},
        ns: 'av-openhome-org',
      );
      if (response == null) return;
      final doc = XmlDocument.parse(response);
      final volEl = doc.descendants
          .whereType<XmlElement>()
          .where((e) => e.localName == 'Value')
          .firstOrNull;
      if (volEl != null) {
        final vol = int.tryParse(volEl.innerText.trim());
        if (vol != null) {
          _volume = (vol / 100).clamp(0.0, 1.0);
        }
      }
    } catch (e) {
      debugPrint('[OpenHome] fetchVolume error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Position
  // ---------------------------------------------------------------------------

  @override
  Future<Duration?> currentPosition() async {
    if (_timeUrl == null) return null;
    try {
      final response = await _soapRequest(
        url: _timeUrl!,
        service: 'Time',
        serviceVersion: 1,
        action: 'Time',
        args: {},
        ns: 'av-openhome-org',
      );
      if (response == null) return null;
      final doc = XmlDocument.parse(response);
      final secsEl = doc.descendants
          .whereType<XmlElement>()
          .where((e) => e.localName == 'TrackCount' || e.localName == 'Seconds')
          .firstOrNull;
      if (secsEl != null) {
        final secs = int.tryParse(secsEl.innerText.trim());
        if (secs != null) return Duration(seconds: secs);
      }
    } catch (e) {
      debugPrint('[OpenHome] currentPosition error: $e');
    }
    return null;
  }

  @override
  Future<Duration?> duration() async {
    if (_timeUrl == null) return null;
    try {
      final response = await _soapRequest(
        url: _timeUrl!,
        service: 'Time',
        serviceVersion: 1,
        action: 'Time',
        args: {},
        ns: 'av-openhome-org',
      );
      if (response == null) return null;
      final doc = XmlDocument.parse(response);
      final durEl = doc.descendants
          .whereType<XmlElement>()
          .where((e) => e.localName == 'Duration')
          .firstOrNull;
      if (durEl != null) {
        final secs = int.tryParse(durEl.innerText.trim());
        if (secs != null) return Duration(seconds: secs);
      }
    } catch (e) {
      debugPrint('[OpenHome] duration error: $e');
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  @override
  OutputReadyState get readyState => _readyState;

  @override
  bool get isPlaying => _playing;

  @override
  bool get hasPendingStream => _playing;

  // ---------------------------------------------------------------------------
  // Product — standby & source selection
  // ---------------------------------------------------------------------------

  Future<void> _setStandby(bool standby) async {
    if (_productUrl == null) return;
    await _soapAction(
      url: _productUrl!,
      service: 'Product',
      serviceVersion: 1,
      action: 'SetStandby',
      args: {'Value': standby ? '1' : '0'},
      ns: 'av-openhome-org',
    );
  }

  Future<void> _selectPlaylistSource() async {
    if (_productUrl == null) return;
    try {
      // Query available sources
      final response = await _soapRequest(
        url: _productUrl!,
        service: 'Product',
        serviceVersion: 1,
        action: 'SourceXml',
        args: {},
        ns: 'av-openhome-org',
      );
      if (response == null) return;

      final doc = XmlDocument.parse(response);
      final valueEl = doc.descendants
          .whereType<XmlElement>()
          .where((e) => e.localName == 'Value')
          .firstOrNull;
      if (valueEl == null) return;

      // The Value contains XML-escaped source list
      final sourcesXml = valueEl.innerText;
      if (sourcesXml.isEmpty) return;

      try {
        final sourcesDoc = XmlDocument.parse(sourcesXml);
        int playlistIndex = -1;
        int index = 0;
        for (final source in sourcesDoc.findAllElements('Source')) {
          final type = source.findElements('Type').firstOrNull?.innerText ?? '';
          if (type == 'Playlist') {
            playlistIndex = index;
            break;
          }
          index++;
        }
        if (playlistIndex >= 0) {
          await _soapAction(
            url: _productUrl!,
            service: 'Product',
            serviceVersion: 1,
            action: 'SetSourceIndex',
            args: {'Value': '$playlistIndex'},
            ns: 'av-openhome-org',
          );
        }
      } catch (_) {
        // Source XML parsing failed — not critical
      }
    } catch (e) {
      debugPrint('[OpenHome] selectPlaylistSource error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // DIDL-Lite metadata
  // ---------------------------------------------------------------------------

  String _buildDIDLMetadata({
    required String url,
    required String title,
    String? artist,
    String? albumArtUrl,
  }) {
    final artistXml = artist != null
        ? '<dc:creator>${_xmlEscape(artist)}</dc:creator>'
            '<upnp:artist>${_xmlEscape(artist)}</upnp:artist>'
        : '';
    final artXml = albumArtUrl != null
        ? '<upnp:albumArtURI>${_xmlEscape(albumArtUrl)}</upnp:albumArtURI>'
        : '';
    final mime = mimeTypeForAudioPath(url);
    return '<DIDL-Lite xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/" '
        'xmlns:dc="http://purl.org/dc/elements/1.1/" '
        'xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/">'
        '<item id="1" parentID="0" restricted="1">'
        '<dc:title>${_xmlEscape(title)}</dc:title>'
        '$artistXml'
        '$artXml'
        '<upnp:class>object.item.audioItem.musicTrack</upnp:class>'
        '<res protocolInfo="http-get:*:$mime:*">${_xmlEscape(url)}</res>'
        '</item>'
        '</DIDL-Lite>';
  }

  // ---------------------------------------------------------------------------
  // SOAP — OpenHome uses urn:av-openhome-org:service:<Service>:<Version>
  // ---------------------------------------------------------------------------

  Future<bool> _soapAction({
    required String url,
    required String service,
    required int serviceVersion,
    required String action,
    required Map<String, String> args,
    required String ns,
  }) async {
    final response = await _soapRequest(
      url: url,
      service: service,
      serviceVersion: serviceVersion,
      action: action,
      args: args,
      ns: ns,
    );
    return response != null;
  }

  Future<String?> _soapRequest({
    required String url,
    required String service,
    required int serviceVersion,
    required String action,
    required Map<String, String> args,
    required String ns,
  }) async {
    try {
      final urn = 'urn:$ns:service:$service:$serviceVersion';
      final argXml = args.entries
          .map((e) => '<${e.key}>${_xmlEscape(e.value)}</${e.key}>')
          .join('');
      final body = '<?xml version="1.0" encoding="utf-8"?>'
          '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" '
          's:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
          '<s:Body>'
          '<u:$action xmlns:u="$urn">'
          '$argXml'
          '</u:$action>'
          '</s:Body>'
          '</s:Envelope>';

      final response = await _http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'text/xml; charset=utf-8',
              'SOAPAction': '"$urn#$action"',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body;
      }
      return null;
    } catch (e) {
      debugPrint('[OpenHome] SOAP error ($service/$action): $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Service discovery from device description XML
  // ---------------------------------------------------------------------------

  Future<void> _discoverServices() async {
    final descPaths = [
      '/description.xml',
      '/DeviceDescription.xml',
      '/rootDesc.xml',
    ];

    for (final path in descPaths) {
      try {
        final resp = await _http
            .get(Uri.parse('http://$host:$port$path'))
            .timeout(const Duration(seconds: 5));
        if (resp.statusCode != 200) continue;
        if (!resp.body.contains('av-openhome-org')) continue;

        _parseServiceUrls(resp.body);
        if (_productUrl != null || _transportUrl != null) {
          debugPrint('[OpenHome] Discovered services from $path');
          return;
        }
      } catch (_) {}
    }
  }

  void _parseServiceUrls(String xml) {
    // Extract OpenHome service controlURLs from device description
    final serviceBlockRegex =
        RegExp(r'<service>(.*?)</service>', dotAll: true);
    for (final match in serviceBlockRegex.allMatches(xml)) {
      final block = match.group(1) ?? '';
      final typeMatch =
          RegExp(r'<serviceType>([^<]+)</serviceType>').firstMatch(block);
      final ctrlMatch =
          RegExp(r'<controlURL>([^<]+)</controlURL>').firstMatch(block);
      if (typeMatch == null || ctrlMatch == null) continue;

      final type = typeMatch.group(1)!;
      var ctrlPath = ctrlMatch.group(1)!;
      if (!ctrlPath.startsWith('/')) ctrlPath = '/$ctrlPath';
      final fullUrl = 'http://$host:$port$ctrlPath';

      if (type.contains('Product')) _productUrl = fullUrl;
      if (type.contains('Volume')) _volumeUrl = fullUrl;
      if (type.contains('Transport')) _transportUrl = fullUrl;
      if (type.contains('Playlist')) _playlistUrl = fullUrl;
      if (type.contains('Time')) _timeUrl = fullUrl;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _xmlEscape(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
