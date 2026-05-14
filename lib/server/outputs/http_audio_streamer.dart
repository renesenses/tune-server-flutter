import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../database/database.dart';
import '../utils/mime_utils.dart';

// ---------------------------------------------------------------------------
// T2.4 — HttpAudioStreamer
// Serveur HTTP shelf embarqué qui sert les fichiers audio locaux.
// Utilisé par les outputs DLNA/AirPlay pour streamer depuis la bibliothèque
// locale vers un renderer externe (équivalent de HttpAudioStreamer.swift).
//
// Routes :
//   GET /track/:id       → stream du fichier audio (Range support)
//   GET /cover/:path     → image pochette (base64url-encoded path)
//   GET /health          → 200 OK
// ---------------------------------------------------------------------------

class HttpAudioStreamer {
  final int preferredPort;
  final TuneDatabase? _db;

  HttpAudioStreamer({this.preferredPort = 8081, TuneDatabase? db}) : _db = db;

  HttpServer? _server;

  bool get isRunning => _server != null;

  /// Actual port the server is listening on (may differ from preferredPort).
  int get port => _server?.port ?? preferredPort;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> start() async {
    if (_server != null) return;

    final router = Router()
      ..get('/health', _health)
      ..get('/track/<filePath>', _serveTrack)
      ..get('/cover/<coverPath>', _serveCover)
      ..get('/api/v1/export/albums.csv', _exportAlbumsCsv)
      ..get('/api/v1/export/tracks.csv', _exportTracksCsv)
      ..get('/api/v1/export/artists.csv', _exportArtistsCsv);

    final handler = Pipeline()
        .addMiddleware(_corsMiddleware())
        .addHandler(router.call);

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, preferredPort);
    } on SocketException {
      // Port in use — let the OS assign an available port
      print('[HttpAudioStreamer] Port $preferredPort in use, using OS-assigned port');
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 0);
    }
    _server!.autoCompress = false;
    print('[HttpAudioStreamer] Listening on port ${_server!.port}');
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  // ---------------------------------------------------------------------------
  // Handlers
  // ---------------------------------------------------------------------------

  Response _health(Request request) =>
      Response.ok('OK', headers: {'Content-Type': 'text/plain'});

  Future<Response> _serveTrack(Request request, String filePath) async {
    final decoded = Uri.decodeComponent(filePath);

    if (decoded.contains('..') || !decoded.startsWith('/')) {
      return Response.forbidden('Invalid path');
    }

    final file = File(decoded);

    if (!await file.exists()) {
      return Response.notFound('Track not found');
    }

    final fileSize = await file.length();
    final mimeType = mimeTypeForAudioPath(decoded);
    final rangeHeader = request.headers['range'];

    if (rangeHeader != null) {
      return _serveRange(file, fileSize, mimeType, rangeHeader);
    }

    return Response.ok(
      file.openRead(),
      headers: {
        'Content-Type': mimeType,
        'Content-Length': '$fileSize',
        'Accept-Ranges': 'bytes',
        'transferMode.dlna.org': 'Streaming',
      },
    );
  }

  Future<Response> _serveCover(Request request, String coverPath) async {
    final decoded = Uri.decodeComponent(coverPath);
    final file = File(decoded);

    if (!await file.exists()) {
      return Response.notFound('Cover not found');
    }

    final mimeType = decoded.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';

    return Response.ok(
      file.openRead(),
      headers: {
        'Content-Type': mimeType,
        'Content-Length': '${await file.length()}',
        'Cache-Control': 'public, max-age=86400',
      },
    );
  }

  // ---------------------------------------------------------------------------
  // CSV Export
  // ---------------------------------------------------------------------------

  static const _bom = '﻿';

  String _csvEscape(Object? value) {
    if (value == null) return '';
    final s = value.toString();
    if (s.contains(';') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }

  String _formatDuration(int? ms) {
    if (ms == null || ms <= 0) return '';
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<Response> _exportAlbumsCsv(Request request) async {
    if (_db == null) return Response.internalServerError(body: 'Database not available');

    final albums = await _db.albumRepo.all();
    final audioInfoMap = await _db.albumRepo.allAudioInfo();

    final buf = StringBuffer()
      ..write(_bom)
      ..writeln('id;title;artistName;year;originalYear;releaseDate;originalDate;genre;trackCount;format;sampleRate;bitDepth;source');

    for (final a in albums) {
      final info = audioInfoMap[a.id];
      buf.writeln([
        _csvEscape(a.id),
        _csvEscape(a.title),
        _csvEscape(a.artistName),
        _csvEscape(a.year),
        _csvEscape(a.originalYear),
        _csvEscape(a.releaseDate),
        _csvEscape(a.originalDate),
        _csvEscape(a.genre),
        _csvEscape(a.trackCount),
        _csvEscape(info?.format),
        _csvEscape(info?.sampleRate),
        _csvEscape(info?.bitDepth),
        _csvEscape(a.source),
      ].join(';'));
    }

    return Response.ok(buf.toString(), headers: {
      'Content-Type': 'text/csv; charset=utf-8',
      'Content-Disposition': 'attachment; filename="albums.csv"',
    });
  }

  Future<Response> _exportTracksCsv(Request request) async {
    if (_db == null) return Response.internalServerError(body: 'Database not available');

    final tracks = await _db.trackRepo.all(limit: 999999);

    final buf = StringBuffer()
      ..write(_bom)
      ..writeln('id;title;artistName;albumTitle;trackNumber;discNumber;discSubtitle;durationMs;duration;format;sampleRate;bitDepth;channels;filePath;source');

    for (final t in tracks) {
      buf.writeln([
        _csvEscape(t.id),
        _csvEscape(t.title),
        _csvEscape(t.artistName),
        _csvEscape(t.albumTitle),
        _csvEscape(t.trackNumber),
        _csvEscape(t.discNumber),
        _csvEscape(t.discSubtitle),
        _csvEscape(t.durationMs),
        _csvEscape(_formatDuration(t.durationMs)),
        _csvEscape(t.format),
        _csvEscape(t.sampleRate),
        _csvEscape(t.bitDepth),
        _csvEscape(t.channels),
        _csvEscape(t.filePath),
        _csvEscape(t.source),
      ].join(';'));
    }

    return Response.ok(buf.toString(), headers: {
      'Content-Type': 'text/csv; charset=utf-8',
      'Content-Disposition': 'attachment; filename="tracks.csv"',
    });
  }

  Future<Response> _exportArtistsCsv(Request request) async {
    if (_db == null) return Response.internalServerError(body: 'Database not available');

    final artists = await _db.artistRepo.all();

    final buf = StringBuffer()
      ..write(_bom)
      ..writeln('id;name;sortName;musicbrainzId');

    for (final a in artists) {
      buf.writeln([
        _csvEscape(a.id),
        _csvEscape(a.name),
        _csvEscape(a.sortName),
        _csvEscape(a.musicbrainzId),
      ].join(';'));
    }

    return Response.ok(buf.toString(), headers: {
      'Content-Type': 'text/csv; charset=utf-8',
      'Content-Disposition': 'attachment; filename="artists.csv"',
    });
  }

  // ---------------------------------------------------------------------------
  // Range requests (HTTP/1.1 §14.35) — requis par la majorité des renderers DLNA
  // ---------------------------------------------------------------------------

  Future<Response> _serveRange(
    File file,
    int fileSize,
    String mimeType,
    String rangeHeader,
  ) async {
    // Parse "bytes=start-end"
    final match = RegExp(r'bytes=(\d*)-(\d*)').firstMatch(rangeHeader);
    if (match == null) {
      return Response(416, headers: {
        'Content-Range': 'bytes */$fileSize',
      });
    }

    final startStr = match.group(1)!;
    final endStr = match.group(2)!;

    final start = startStr.isEmpty ? 0 : int.parse(startStr);
    final end = endStr.isEmpty ? fileSize - 1 : int.parse(endStr);

    if (start >= fileSize || end >= fileSize || start > end) {
      return Response(416, headers: {
        'Content-Range': 'bytes */$fileSize',
      });
    }

    final length = end - start + 1;

    return Response(
      206,
      body: file.openRead(start, end + 1),
      headers: {
        'Content-Type': mimeType,
        'Content-Range': 'bytes $start-$end/$fileSize',
        'Content-Length': '$length',
        'Accept-Ranges': 'bytes',
        'transferMode.dlna.org': 'Streaming',
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// URL d'accès à un fichier audio local depuis le réseau.
  String trackUrl(String localIp, String filePath) {
    final encoded = Uri.encodeComponent(filePath);
    return 'http://$localIp:$port/track/$encoded';
  }

  /// URL d'accès à une pochette locale depuis le réseau.
  String coverUrl(String localIp, String coverPath) {
    final encoded = Uri.encodeComponent(coverPath);
    return 'http://$localIp:$port/cover/$encoded';
  }

  Middleware _corsMiddleware() {
    return (Handler innerHandler) {
      return (Request request) async {
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: _corsHeaders);
        }
        final response = await innerHandler(request);
        return response.change(headers: _corsHeaders);
      };
    };
  }

  static const _corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
    'Access-Control-Allow-Headers': 'Range, Content-Type',
  };
}
