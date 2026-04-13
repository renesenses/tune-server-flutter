import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

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

  HttpAudioStreamer({this.preferredPort = 8081});

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
      ..get('/cover/<coverPath>', _serveCover);

    final handler = Pipeline()
        .addMiddleware(_corsMiddleware())
        .addHandler(router.call);

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, preferredPort);
    } on SocketException {
      // Port in use — let the OS assign an available port
      debugPrint('[HttpAudioStreamer] Port $preferredPort in use, using OS-assigned port');
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 0);
    }
    _server!.autoCompress = false;
    debugPrint('[HttpAudioStreamer] Listening on port ${_server!.port}');
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
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
