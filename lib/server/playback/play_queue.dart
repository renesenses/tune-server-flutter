import 'dart:math';

import '../../models/domain_models.dart';
import '../../models/enums.dart';
import '../database/database.dart';

// ---------------------------------------------------------------------------
// T5.1 — PlayQueue
// File de lecture avec shuffle, repeat et snapshot.
// Miroir de PlayQueue.swift (iOS)
// ---------------------------------------------------------------------------

class PlayQueue {
  final List<Track> _tracks = [];
  List<Track>? _originalOrder; // sauvegarde pour désactiver le shuffle
  int _currentIndex = -1;
  bool _shuffleEnabled = false;
  RepeatMode _repeatMode = RepeatMode.off;

  // ---------------------------------------------------------------------------
  // Lecture seule
  // ---------------------------------------------------------------------------

  List<Track> get tracks => List.unmodifiable(_tracks);
  int get currentIndex => _currentIndex;
  int get length => _tracks.length;
  bool get isEmpty => _tracks.isEmpty;
  bool get shuffleEnabled => _shuffleEnabled;
  RepeatMode get repeatMode => _repeatMode;

  Track? get currentTrack =>
      _currentIndex >= 0 && _currentIndex < _tracks.length
          ? _tracks[_currentIndex]
          : null;

  Track? get nextTrack {
    final next = _nextIndex;
    return next != null ? _tracks[next] : null;
  }

  // ---------------------------------------------------------------------------
  // Chargement
  // ---------------------------------------------------------------------------

  /// Remplace la queue avec [tracks] et se positionne sur [startIndex].
  void load(List<Track> tracks, {int startIndex = 0}) {
    _tracks
      ..clear()
      ..addAll(tracks);
    _originalOrder = null;
    _shuffleEnabled = false;
    _currentIndex = tracks.isEmpty ? -1 : startIndex.clamp(0, tracks.length - 1);
  }

  /// Vide complètement la queue.
  void clear() {
    _tracks.clear();
    _originalOrder = null;
    _currentIndex = -1;
    _shuffleEnabled = false;
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Avance d'une piste. Retourne la nouvelle piste ou null si fin de queue.
  Track? next() {
    final idx = _nextIndex;
    if (idx == null) return null;
    _currentIndex = idx;
    return currentTrack;
  }

  /// Recule d'une piste. Si en début de queue, retourne la piste actuelle.
  Track? previous() {
    if (_tracks.isEmpty) return null;
    if (_currentIndex > 0) {
      _currentIndex--;
    }
    return currentTrack;
  }

  /// Saute directement à l'index [index].
  Track? jumpTo(int index) {
    if (index < 0 || index >= _tracks.length) return null;
    _currentIndex = index;
    return currentTrack;
  }

  // ---------------------------------------------------------------------------
  // Modification
  // ---------------------------------------------------------------------------

  /// Ajoute [track] en fin de queue.
  void addToEnd(Track track) {
    _tracks.add(track);
    if (_currentIndex < 0) _currentIndex = 0;
  }

  /// Insère [track] immédiatement après la piste courante.
  void addNext(Track track) {
    if (_tracks.isEmpty) {
      _tracks.add(track);
      _currentIndex = 0;
    } else {
      final insertAt = (_currentIndex + 1).clamp(0, _tracks.length);
      _tracks.insert(insertAt, track);
    }
  }

  /// Supprime la piste à [index].
  void remove(int index) {
    if (index < 0 || index >= _tracks.length) return;
    _tracks.removeAt(index);
    if (_currentIndex >= _tracks.length) {
      _currentIndex = _tracks.length - 1;
    } else if (index < _currentIndex) {
      _currentIndex--;
    }
  }

  /// Déplace la piste de [fromIndex] vers [toIndex].
  void move(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    if (fromIndex < 0 ||
        fromIndex >= _tracks.length ||
        toIndex < 0 ||
        toIndex >= _tracks.length) return;

    final track = _tracks.removeAt(fromIndex);
    _tracks.insert(toIndex, track);

    // Met à jour l'index courant
    if (fromIndex == _currentIndex) {
      _currentIndex = toIndex;
    } else if (fromIndex < _currentIndex && toIndex >= _currentIndex) {
      _currentIndex--;
    } else if (fromIndex > _currentIndex && toIndex <= _currentIndex) {
      _currentIndex++;
    }
  }

  // ---------------------------------------------------------------------------
  // Shuffle
  // ---------------------------------------------------------------------------

  void setShuffle({required bool enabled}) {
    if (enabled == _shuffleEnabled) return;

    if (enabled) {
      _originalOrder = List.of(_tracks);
      final current = currentTrack;

      // Mélange tout sauf la piste courante
      final remaining = List.of(_tracks)..removeAt(_currentIndex);
      remaining.shuffle(Random());

      _tracks.clear();
      if (current != null) {
        _tracks.add(current);
        _tracks.addAll(remaining);
        _currentIndex = 0;
      } else {
        _tracks.addAll(remaining);
      }
    } else {
      // Restaure l'ordre original en conservant la piste courante
      final current = currentTrack;
      if (_originalOrder != null) {
        _tracks
          ..clear()
          ..addAll(_originalOrder!);
        _originalOrder = null;
        if (current != null) {
          final idx = _tracks.indexWhere((t) => t.id == current.id);
          _currentIndex = idx >= 0 ? idx : 0;
        }
      }
    }

    _shuffleEnabled = enabled;
  }

  // ---------------------------------------------------------------------------
  // Repeat
  // ---------------------------------------------------------------------------

  void setRepeat(RepeatMode mode) => _repeatMode = mode;

  /// Cycle : off → all → one → off
  RepeatMode cycleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
    }
    return _repeatMode;
  }

  // ---------------------------------------------------------------------------
  // Snapshot
  // ---------------------------------------------------------------------------

  QueueSnapshot snapshot() => QueueSnapshot(
        tracks: List.of(_tracks),
        position: _currentIndex,
        shuffleEnabled: _shuffleEnabled,
        repeatMode: _repeatMode,
      );

  // ---------------------------------------------------------------------------
  // Helpers internes
  // ---------------------------------------------------------------------------

  int? get _nextIndex {
    if (_tracks.isEmpty) return null;

    switch (_repeatMode) {
      case RepeatMode.one:
        return _currentIndex; // reste sur la même piste
      case RepeatMode.all:
        return (_currentIndex + 1) % _tracks.length;
      case RepeatMode.off:
        final next = _currentIndex + 1;
        return next < _tracks.length ? next : null;
    }
  }
}
