/// Dart FFI bindings to the native Tune Server library (libtuneserver.so/.dylib).
///
/// This allows the Flutter app to embed the full Rust server engine,
/// running it as a background service on Android/iOS.

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

/// Native function signatures (C types)
typedef TuneServerStartC = Int32 Function(
    Uint16 port,
    Pointer<Utf8> dbPath,
    Pointer<Utf8> musicDirsJson,
    Pointer<Utf8> webDir);
typedef TuneServerStartDart = int Function(
    int port,
    Pointer<Utf8> dbPath,
    Pointer<Utf8> musicDirsJson,
    Pointer<Utf8> webDir);

typedef TuneServerStopC = Int32 Function();
typedef TuneServerStopDart = int Function();

typedef TuneServerStatusC = Pointer<Utf8> Function();
typedef TuneServerStatusDart = Pointer<Utf8> Function();

typedef TuneServerVersionC = Pointer<Utf8> Function();
typedef TuneServerVersionDart = Pointer<Utf8> Function();

typedef TuneFreeStringC = Void Function(Pointer<Utf8> ptr);
typedef TuneFreeStringDart = void Function(Pointer<Utf8> ptr);

class TuneNativeServer {
  static DynamicLibrary? _lib;
  static TuneServerStartDart? _start;
  static TuneServerStopDart? _stop;
  static TuneServerStatusDart? _status;
  static TuneServerVersionDart? _version;
  static TuneFreeStringDart? _freeString;

  static bool _initialized = false;

  /// Load the native library. Call once at app startup.
  static void initialize() {
    if (_initialized) return;

    try {
      if (Platform.isAndroid) {
        _lib = DynamicLibrary.open('libtuneserver.so');
      } else if (Platform.isIOS) {
        _lib = DynamicLibrary.process(); // statically linked
      } else if (Platform.isMacOS) {
        _lib = DynamicLibrary.open('libtuneserver.dylib');
      } else if (Platform.isLinux) {
        _lib = DynamicLibrary.open('libtuneserver.so');
      } else if (Platform.isWindows) {
        _lib = DynamicLibrary.open('tuneserver.dll');
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      _start = _lib!.lookupFunction<TuneServerStartC, TuneServerStartDart>(
          'tune_server_start');
      _stop = _lib!.lookupFunction<TuneServerStopC, TuneServerStopDart>(
          'tune_server_stop');
      _status =
          _lib!.lookupFunction<TuneServerStatusC, TuneServerStatusDart>(
              'tune_server_status');
      _version =
          _lib!.lookupFunction<TuneServerVersionC, TuneServerVersionDart>(
              'tune_server_version');
      _freeString =
          _lib!.lookupFunction<TuneFreeStringC, TuneFreeStringDart>(
              'tune_free_string');

      _initialized = true;
    } catch (e) {
      print('TuneNativeServer: failed to load native library: $e');
    }
  }

  /// Whether the native library was loaded successfully.
  static bool get isAvailable => _initialized;

  /// Start the embedded Tune server.
  ///
  /// Returns 0 on success, -1 if already running, -2 on error.
  static int start({
    int port = 8888,
    required String dbPath,
    List<String> musicDirs = const [],
    String? webDir,
  }) {
    if (!_initialized) return -2;

    final dbPathNative = dbPath.toNativeUtf8();
    final musicDirsJson =
        '[${musicDirs.map((d) => '"$d"').join(',')}]'.toNativeUtf8();
    final webDirNative = webDir?.toNativeUtf8() ?? nullptr;

    try {
      return _start!(port, dbPathNative, musicDirsJson,
          webDirNative == nullptr ? nullptr : webDirNative);
    } finally {
      calloc.free(dbPathNative);
      calloc.free(musicDirsJson);
      if (webDirNative != nullptr) calloc.free(webDirNative);
    }
  }

  /// Stop the embedded Tune server.
  static int stop() {
    if (!_initialized) return -1;
    return _stop!();
  }

  /// Get server status as a JSON string.
  static String status() {
    if (!_initialized) return '{"running": false, "error": "not initialized"}';
    final ptr = _status!();
    final result = ptr.toDartString();
    _freeString!(ptr);
    return result;
  }

  /// Get the Tune server version string.
  static String version() {
    if (!_initialized) return 'unknown';
    final ptr = _version!();
    final result = ptr.toDartString();
    _freeString!(ptr);
    return result;
  }
}
