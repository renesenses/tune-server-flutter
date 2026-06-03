import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../event_bus.dart';

// ---------------------------------------------------------------------------
// FileSystemWatcher
// Poll music dirs every 2s, detect added/modified/deleted audio files,
// trigger incremental scan.
// Miroir de file_system_watcher.rs (Rust)
// ---------------------------------------------------------------------------

const _audioExtensions = {
  '.flac', '.mp3', '.m4a', '.aac', '.alac',
  '.ogg', '.opus', '.wav', '.aiff', '.aif',
  '.dsf', '.dff', '.dst', '.ape', '.wv', '.wma',
};

/// Event emitted when filesystem changes are detected.
class FileSystemChangeEvent extends AppEvent {
  final List<String> added;
  final List<String> modified;
  final List<String> deleted;
  const FileSystemChangeEvent({
    required this.added,
    required this.modified,
    required this.deleted,
  });

  bool get hasChanges => added.isNotEmpty || modified.isNotEmpty || deleted.isNotEmpty;
}

class FileSystemWatcher {
  final List<String> _watchPaths;
  final Duration _pollInterval;

  Timer? _timer;
  bool _running = false;

  /// Snapshot of (path -> mtime) from last poll.
  final Map<String, int> _lastSnapshot = {};

  /// Callback invoked when changes are detected.
  void Function(FileSystemChangeEvent event)? onChanges;

  FileSystemWatcher({
    required List<String> watchPaths,
    Duration pollInterval = const Duration(seconds: 2),
    this.onChanges,
  })  : _watchPaths = List.of(watchPaths),
        _pollInterval = pollInterval;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  bool get isRunning => _running;

  void start() {
    if (_running) return;
    _running = true;

    // Build initial snapshot
    _buildSnapshot().then((_) {
      debugPrint('[FileSystemWatcher] Started watching ${_watchPaths.length} dirs');
    });

    _timer = Timer.periodic(_pollInterval, (_) => _poll());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    debugPrint('[FileSystemWatcher] Stopped');
  }

  /// Update the list of watched directories.
  void updatePaths(List<String> paths) {
    _watchPaths
      ..clear()
      ..addAll(paths);
    _lastSnapshot.clear();
    if (_running) {
      _buildSnapshot();
    }
  }

  void dispose() {
    stop();
    _lastSnapshot.clear();
  }

  // ---------------------------------------------------------------------------
  // Polling
  // ---------------------------------------------------------------------------

  Future<void> _poll() async {
    if (!_running) return;

    try {
      final currentSnapshot = await _scanAll();
      final changes = _diff(currentSnapshot);

      if (changes.hasChanges) {
        debugPrint('[FileSystemWatcher] Changes detected: '
            '+${changes.added.length} ~${changes.modified.length} '
            '-${changes.deleted.length}');

        // Update snapshot
        _lastSnapshot
          ..clear()
          ..addAll(currentSnapshot);

        // Notify
        EventBus.instance.emit(changes);
        onChanges?.call(changes);
      }
    } catch (e) {
      debugPrint('[FileSystemWatcher] Poll error: $e');
    }
  }

  Future<void> _buildSnapshot() async {
    final snapshot = await _scanAll();
    _lastSnapshot
      ..clear()
      ..addAll(snapshot);
  }

  // ---------------------------------------------------------------------------
  // Scan directories
  // ---------------------------------------------------------------------------

  Future<Map<String, int>> _scanAll() async {
    final result = <String, int>{};

    for (final dirPath in _watchPaths) {
      final dir = Directory(dirPath);
      if (!dir.existsSync()) continue;

      try {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is! File) continue;
          final ext = p.extension(entity.path).toLowerCase();
          if (!_audioExtensions.contains(ext)) continue;

          try {
            final stat = entity.statSync();
            result[entity.path] = stat.modified.millisecondsSinceEpoch;
          } catch (_) {
            // File may have been deleted between list and stat
          }
        }
      } catch (e) {
        debugPrint('[FileSystemWatcher] Cannot scan $dirPath: $e');
      }
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Diff
  // ---------------------------------------------------------------------------

  FileSystemChangeEvent _diff(Map<String, int> current) {
    final added = <String>[];
    final modified = <String>[];
    final deleted = <String>[];

    // Check for added and modified files
    for (final entry in current.entries) {
      final oldMtime = _lastSnapshot[entry.key];
      if (oldMtime == null) {
        added.add(entry.key);
      } else if (oldMtime != entry.value) {
        modified.add(entry.key);
      }
    }

    // Check for deleted files
    for (final path in _lastSnapshot.keys) {
      if (!current.containsKey(path)) {
        deleted.add(path);
      }
    }

    return FileSystemChangeEvent(
      added: added,
      modified: modified,
      deleted: deleted,
    );
  }
}
