import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../utils/mime_utils.dart';
import 'output_target.dart';

// ---------------------------------------------------------------------------
// T4.3 — DLNAOutput
// Output DLNA via SOAP UPnP AVTransport.
// Miroir de DLNAOutput.swift (iOS)
//
// Actions implémentées :
//   SetAVTransportURI, Play, Pause, Stop, Seek, GetPositionInfo, SetVolume
// ---------------------------------------------------------------------------

class DLNAOutput implements OutputTarget {
  @override
  final String id;

  @override
  final String displayName;

  final String avTransportUrl;
  final String? renderingControlUrl;
  final http.Client _http;

  OutputReadyState _readyState = OutputReadyState.idle;
  double _volume = 0.5;
  bool _playing = false;

  DLNAOutput({
    required this.id,
    required this.displayName,
    required this.avTransportUrl,
    this.renderingControlUrl,
    http.Client? client,
  }) : _http = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> prepare() async {
    _readyState = OutputReadyState.ready;
    // Lire le volume réel du renderer DLNA
    await _fetchCurrentVolume();
    return const OutputSuccess();
  }

  /// Interroge le RenderingControl pour obtenir le volume actuel du renderer.
  Future<void> _fetchCurrentVolume() async {
    if (renderingControlUrl == null) return;
    try {
      final response = await _soapRequest(
        url: renderingControlUrl!,
        service: 'RenderingControl',
        action: 'GetVolume',
        args: {
          'InstanceID': '0',
          'Channel': 'Master',
        },
      );
      if (response == null) return;
      final doc = XmlDocument.parse(response);
      final volStr = doc.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.localName == 'CurrentVolume',
              orElse: () => XmlElement(XmlName('CurrentVolume')))
          .innerText
          .trim();
      final dlnaVol = int.tryParse(volStr);
      if (dlnaVol != null) {
        _volume = (dlnaVol / 100).clamp(0.0, 1.0);
      }
    } catch (e) {
      debugPrint('[DLNA] Error: $e');
    }
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
    String? albumArtUrl,
  }) async {
    // 1. SetAVTransportURI avec métadonnées DIDL-Lite
    final setResult = await _setAVTransportURI(
      url: url,
      title: title ?? 'Unknown',
      artist: artist,
      albumArtUrl: albumArtUrl,
    );
    if (setResult is OutputFailure) return setResult;

    // 2. Play
    final playResult = await _soapAction(
      url: avTransportUrl,
      service: 'AVTransport',
      action: 'Play',
      args: {'InstanceID': '0', 'Speed': '1'},
    );
    if (playResult) {
      _playing = true;
      return const OutputSuccess();
    }
    return const OutputFailure('DLNA Play failed');
  }

  @override
  Future<OutputResult> pause() async {
    final ok = await _soapAction(
      url: avTransportUrl,
      service: 'AVTransport',
      action: 'Pause',
      args: {'InstanceID': '0'},
    );
    if (ok) _playing = false;
    return ok ? const OutputSuccess() : const OutputFailure('DLNA Pause failed');
  }

  @override
  Future<OutputResult> resume() async {
    final ok = await _soapAction(
      url: avTransportUrl,
      service: 'AVTransport',
      action: 'Play',
      args: {'InstanceID': '0', 'Speed': '1'},
    );
    if (ok) _playing = true;
    return ok ? const OutputSuccess() : const OutputFailure('DLNA Play failed');
  }

  @override
  Future<OutputResult> stop() async {
    final ok = await _soapAction(
      url: avTransportUrl,
      service: 'AVTransport',
      action: 'Stop',
      args: {'InstanceID': '0'},
    );
    if (ok) _playing = false;
    return ok ? const OutputSuccess() : const OutputFailure('DLNA Stop failed');
  }

  @override
  Future<OutputResult> seek(Duration position) async {
    final hms = _formatDuration(position);
    final ok = await _soapAction(
      url: avTransportUrl,
      service: 'AVTransport',
      action: 'Seek',
      args: {
        'InstanceID': '0',
        'Unit': 'REL_TIME',
        'Target': hms,
      },
    );
    return ok ? const OutputSuccess() : const OutputFailure('DLNA Seek failed');
  }

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> setVolume(double volume) async {
    if (renderingControlUrl == null) {
      _volume = volume;
      return const OutputSuccess();
    }

    final dlnaVolume = (volume * 100).round().clamp(0, 100);
    final ok = await _soapAction(
      url: renderingControlUrl!,
      service: 'RenderingControl',
      action: 'SetVolume',
      args: {
        'InstanceID': '0',
        'Channel': 'Master',
        'DesiredVolume': '$dlnaVolume',
      },
    );
    if (ok) _volume = volume;
    return ok
        ? const OutputSuccess()
        : const OutputFailure('DLNA SetVolume failed');
  }

  @override
  double? get currentVolume => _volume;

  // ---------------------------------------------------------------------------
  // Position
  // ---------------------------------------------------------------------------

  @override
  Future<Duration?> currentPosition() async {
    try {
      final response = await _soapRequest(
        url: avTransportUrl,
        service: 'AVTransport',
        action: 'GetPositionInfo',
        args: {'InstanceID': '0'},
      );
      if (response == null) return null;

      final doc = XmlDocument.parse(response);
      final relTime = doc.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.localName == 'RelTime',
              orElse: () => XmlElement(XmlName('RelTime')))
          .innerText
          .trim();

      return _parseDuration(relTime);
    } catch (e) {
      debugPrint('[DLNA] Error: $e');
      return null;
    }
  }

  @override
  Future<Duration?> duration() async {
    try {
      final response = await _soapRequest(
        url: avTransportUrl,
        service: 'AVTransport',
        action: 'GetMediaInfo',
        args: {'InstanceID': '0'},
      );
      if (response == null) return null;

      final doc = XmlDocument.parse(response);
      final dur = doc.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.localName == 'MediaDuration',
              orElse: () => XmlElement(XmlName('MediaDuration')))
          .innerText
          .trim();

      return _parseDuration(dur);
    } catch (e) {
      debugPrint('[DLNA] Error: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // État
  // ---------------------------------------------------------------------------

  @override
  OutputReadyState get readyState => _readyState;

  @override
  bool get isPlaying => _playing;

  // ---------------------------------------------------------------------------
  // SetAVTransportURI avec métadonnées DIDL-Lite
  // ---------------------------------------------------------------------------

  Future<OutputResult> _setAVTransportURI({
    required String url,
    required String title,
    String? artist,
    String? albumArtUrl,
  }) async {
    final didl = _buildDIDLMetadata(
      url: url,
      title: title,
      artist: artist,
      albumArtUrl: albumArtUrl,
    );

    final ok = await _soapAction(
      url: avTransportUrl,
      service: 'AVTransport',
      action: 'SetAVTransportURI',
      args: {
        'InstanceID': '0',
        'CurrentURI': url,
        'CurrentURIMetaData': didl,
      },
    );
    return ok
        ? const OutputSuccess()
        : const OutputFailure('DLNA SetAVTransportURI failed');
  }

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
  // SOAP
  // ---------------------------------------------------------------------------

  Future<bool> _soapAction({
    required String url,
    required String service,
    required String action,
    required Map<String, String> args,
  }) async {
    final response = await _soapRequest(
        url: url, service: service, action: action, args: args);
    return response != null;
  }

  Future<String?> _soapRequest({
    required String url,
    required String service,
    required String action,
    required Map<String, String> args,
  }) async {
    try {
      final body = _buildSoapEnvelope(service: service, action: action, args: args);
      final response = await _http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'text/xml; charset=utf-8',
              'SOAPAction':
                  '"urn:schemas-upnp-org:service:$service:1#$action"',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body;
      }
      return null;
    } catch (e) {
      debugPrint('[DLNA] Error: $e');
      return null;
    }
  }

  String _buildSoapEnvelope({
    required String service,
    required String action,
    required Map<String, String> args,
  }) {
    final argXml = args.entries
        .map((e) => '<${e.key}>${_xmlEscape(e.value)}</${e.key}>')
        .join('');
    return '<?xml version="1.0" encoding="utf-8"?>'
        '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" '
        's:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
        '<s:Body>'
        '<u:$action xmlns:u="urn:schemas-upnp-org:service:$service:1">'
        '$argXml'
        '</u:$action>'
        '</s:Body>'
        '</s:Envelope>';
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Duration? _parseDuration(String raw) {
    if (raw.isEmpty || raw == 'NOT_IMPLEMENTED') return null;
    try {
      final parts = raw.split(':').map(double.parse).toList();
      if (parts.length == 3) {
        final ms =
            ((parts[0] * 3600 + parts[1] * 60 + parts[2]) * 1000).round();
        return Duration(milliseconds: ms);
      }
    } catch (e) {
      debugPrint('[DLNA] Error: $e');
    }
    return null;
  }

  String _xmlEscape(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
