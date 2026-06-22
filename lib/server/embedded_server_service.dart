import 'dart:convert';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tune_native_server.dart';

/// Manages the embedded Tune Server as an Android foreground service.
///
/// The Rust server runs inside [libtuneserver.so] via FFI, started from
/// a foreground service so Android doesn't kill it when the app is backgrounded.
class EmbeddedServerService {
  static bool _initialized = false;
  static int _port = 8888;

  /// Initialize the foreground task (call once at app startup).
  static Future<void> init() async {
    if (_initialized) return;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'tune_server',
        channelName: 'Tune Server',
        channelDescription: 'Tune music server is running',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: null,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    _initialized = true;
  }

  /// Start the embedded server in a foreground service.
  static Future<bool> start({int port = 8888, List<String> musicDirs = const []}) async {
    _port = port;

    if (!TuneNativeServer.isAvailable) {
      TuneNativeServer.initialize();
      if (!TuneNativeServer.isAvailable) return false;
    }

    // Determine paths
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = '${appDir.path}/tune.db';
    final webDir = '${appDir.path}/web';

    // Resolve music directories
    final dirs = musicDirs.isNotEmpty
        ? musicDirs
        : await _defaultMusicDirs();

    // Start foreground service
    await FlutterForegroundTask.startService(
      notificationTitle: 'Tune Server',
      notificationText: 'Running on port $port',
      serviceId: 256,
      callback: _serviceCallback,
    );

    // Start Rust server via FFI
    final result = TuneNativeServer.start(
      port: port,
      dbPath: dbPath,
      musicDirs: dirs,
      webDir: webDir,
    );

    if (result == 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('embedded_server_running', true);
      await prefs.setInt('embedded_server_port', port);
      return true;
    }

    return result == -1; // -1 = already running = success
  }

  /// Stop the embedded server.
  static Future<void> stop() async {
    TuneNativeServer.stop();
    await FlutterForegroundTask.stopService();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('embedded_server_running', false);
  }

  /// Check if the server is currently running.
  static bool get isRunning {
    if (!TuneNativeServer.isAvailable) return false;
    final status = TuneNativeServer.status();
    try {
      final json = jsonDecode(status);
      return json['running'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Get the server URL for the remote API client.
  static String get serverUrl => 'http://127.0.0.1:$_port';

  /// Get server status as a map.
  static Map<String, dynamic> get status {
    if (!TuneNativeServer.isAvailable) {
      return {'running': false, 'error': 'native library not available'};
    }
    try {
      return jsonDecode(TuneNativeServer.status());
    } catch (_) {
      return {'running': false, 'error': 'status parse error'};
    }
  }

  /// Was the server running before the app was killed?
  static Future<bool> wasRunning() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('embedded_server_running') ?? false;
  }

  static Future<List<String>> _defaultMusicDirs() async {
    final dirs = <String>[];

    // Android external storage
    if (Platform.isAndroid) {
      final extDir = Directory('/storage/emulated/0/Music');
      if (await extDir.exists()) dirs.add(extDir.path);

      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) dirs.add(downloadDir.path);
    }

    // iOS Documents
    if (Platform.isIOS) {
      final appDir = await getApplicationDocumentsDirectory();
      dirs.add(appDir.path);
    }

    return dirs;
  }
}

// Foreground service callback (runs in isolate on Android)
@pragma('vm:entry-point')
void _serviceCallback() {
  FlutterForegroundTask.setTaskHandler(_TuneServerTaskHandler());
}

class _TuneServerTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    TuneNativeServer.stop();
  }
}
