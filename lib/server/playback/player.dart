import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart' show ProcessingState, PlayerState;

import '../../models/enums.dart';
import '../audio/local_audio_output.dart';
import '../database/database.dart';
import '../event_bus.dart';
import '../outputs/dlna_output.dart';
import '../outputs/output_target.dart';
import 'play_queue.dart';

// ---------------------------------------------------------------------------
// T5.2 — Player
// Machine d'état : stopped / buffering / playing / paused.
// Orchestre OutputTarget + PlayQueue, timer de position, détection fin de piste.
// Miroir de Player.swift (iOS)
// ---------------------------------------------------------------------------

class Player {
  final String zoneId;
  final PlayQueue queue;

  OutputTarget? _output;

  PlaybackState _state = PlaybackState.stopped;
  Duration _position = Duration.zero;

  Timer? _positionTimer;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;

  // ---------------------------------------------------------------------------
  // Crossfade
  // ---------------------------------------------------------------------------

  bool crossfadeEnabled = false;
  double crossfadeDuration = 3.0; // seconds

  /// Second output used during crossfade transition.
  LocalAudioOutput? _crossfadeOutput;
  Timer? _crossfadeTimer;
  Timer? _crossfadeCheckTimer;
  bool _crossfading = false;

  /// Subscriptions for the crossfade output (transferred after swap).
  StreamSubscription<PlayerState>? _crossfadePlayerStateSub;
  StreamSubscription<Duration>? _crossfadePositionSub;

  Player({required this.zoneId, required this.queue});

  String? _resolveArtUrl(String? coverPath) {
    if (coverPath == null || coverPath.isEmpty) return null;
    if (coverPath.startsWith('http')) return coverPath;
    final filename = coverPath.split('/').last;
    return 'http://localhost:8888/api/v1/library/artwork/$filename';
  }

  // ---------------------------------------------------------------------------
  // Lecture seule
  // ---------------------------------------------------------------------------

  PlaybackState get state => _state;
  Duration get position => _position;
  bool get isPlaying => _state == PlaybackState.playing;
  OutputTarget? get output => _output;

  // ---------------------------------------------------------------------------
  // Output
  // ---------------------------------------------------------------------------

  Future<void> setOutput(OutputTarget output) async {
    final wasPlaying = isPlaying;
    final currentTrack = queue.currentTrack;

    // Arrête l'ancien output proprement
    await _teardownOutput();

    _output = output;
    final result = await output.prepare();
    if (result is OutputFailure) {
      _setState(PlaybackState.stopped);
      EventBus.instance.emit(ServerErrorEvent('Output prepare: ${result.message}'));
      return;
    }

    _hookOutput(output);

    // Reprend si une piste était en cours
    if (wasPlaying && currentTrack != null) {
      await _playTrack(currentTrack, startAt: _position);
    }
  }

  void _hookOutput(OutputTarget output) {
    if (output is LocalAudioOutput) {
      // just_audio : stream natif pour la position et l'état
      _positionSub = output.positionStream.listen((pos) {
        _position = pos;
        EventBus.instance.emit(PlaybackPositionEvent(zoneId, pos.inMilliseconds));

        // Crossfade check: monitor position to trigger crossfade
        if (crossfadeEnabled && !_crossfading && isPlaying) {
          _checkCrossfadeThreshold(pos);
        }
      });

      _playerStateSub = output.playerStateStream.listen((ps) {
        if (ps.processingState == ProcessingState.completed) {
          // If crossfade is active, the swap handles the transition —
          // don't trigger _onTrackCompleted again.
          if (!_crossfading) {
            _onTrackCompleted();
          }
        } else if (ps.processingState == ProcessingState.buffering ||
            ps.processingState == ProcessingState.loading) {
          _setState(PlaybackState.buffering);
        } else if (ps.processingState == ProcessingState.ready) {
          // just_audio repasse à "ready" après un buffering (streaming HTTP).
          // Sans ce cas, _state reste coincé sur buffering → pause() ignorée.
          _setState(ps.playing ? PlaybackState.playing : PlaybackState.paused);
        }
      });
    } else {
      // DLNA / AirPlay : polling toutes les 5 secondes
      // Les renderers DLNA (DMP-A8) sont sensibles aux requêtes SOAP fréquentes
      _positionTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
        if (!isPlaying) return;
        final pos = await output.currentPosition();
        if (pos != null) {
          _position = pos;
          EventBus.instance
              .emit(PlaybackPositionEvent(zoneId, pos.inMilliseconds));

          // Détection fin de piste par comparaison position / durée
          final dur = await output.duration();
          if (dur != null && dur > Duration.zero && pos >= dur - const Duration(seconds: 1)) {
            _onTrackCompleted();
          }
        }
      });
    }
  }

  Future<void> _teardownOutput() async {
    await _cancelCrossfade();
    _positionTimer?.cancel();
    _positionTimer = null;
    await _playerStateSub?.cancel();
    _playerStateSub = null;
    await _positionSub?.cancel();
    _positionSub = null;
    await _output?.stop();
    await _output?.dispose();
    _output = null;
  }

  // ---------------------------------------------------------------------------
  // Contrôles publics
  // ---------------------------------------------------------------------------

  /// Lance la lecture de la piste courante dans la queue.
  Future<void> play() async {
    final track = queue.currentTrack;
    if (track == null || _output == null) return;
    await _playTrack(track);
  }

  /// Lance la lecture d'une piste précise (sans modifier la queue).
  Future<void> playTrack(Track track) async {
    await _playTrack(track);
  }

  Future<void> pause() async {
    if (_state != PlaybackState.playing && _state != PlaybackState.buffering) return;
    final result = await _output?.pause();
    if (result is! OutputFailure) {
      _setState(PlaybackState.paused);
    }
  }

  Future<void> resume() async {
    if (_state != PlaybackState.paused) return;
    final result = await _output?.resume();
    if (result is! OutputFailure) {
      _setState(PlaybackState.playing);
    }
  }

  Future<void> stop() async {
    await _cancelCrossfade();
    await _output?.stop();
    _position = Duration.zero;
    _setState(PlaybackState.stopped);
    final zid = int.tryParse(zoneId);
    if (zid != null) {
      EventBus.instance.emit(PlaybackStoppedEvent(zid));
    }
  }

  Future<void> seek(Duration position) async {
    await _output?.seek(position);
    _position = position;
    EventBus.instance.emit(PlaybackPositionEvent(zoneId, position.inMilliseconds));
    if (isPlaying) {
      final zid = int.tryParse(zoneId);
      if (zid != null) {
        EventBus.instance.emit(PlaybackStartedEvent(
          zid,
          positionMs: position.inMilliseconds,
          durationMs: queue.currentTrack?.durationMs,
        ));
      }
    }
  }

  /// Passe à la piste suivante.
  Future<void> next() async {
    await _cancelCrossfade();
    final track = queue.next();
    if (track == null) {
      await stop();
      return;
    }
    await _playTrack(track);
    EventBus.instance.emit(QueueChangedEvent(zoneId));
  }

  /// Retourne à la piste précédente.
  /// Si position > 3 s, recommence la piste courante.
  Future<void> previous() async {
    await _cancelCrossfade();
    if (_position > const Duration(seconds: 3)) {
      await seek(Duration.zero);
      return;
    }
    final track = queue.previous();
    if (track == null) return;
    await _playTrack(track);
    EventBus.instance.emit(QueueChangedEvent(zoneId));
  }

  Future<void> setVolume(double volume) async {
    await _output?.setVolume(volume);
  }

  // ---------------------------------------------------------------------------
  // Crossfade — threshold detection
  // ---------------------------------------------------------------------------

  /// Called on every position update. Checks whether we're within
  /// [crossfadeDuration] seconds of the end, and if so, starts the crossfade.
  void _checkCrossfadeThreshold(Duration currentPos) {
    final output = _output;
    if (output is! LocalAudioOutput) return;

    // Use a separate async call so the position listener stays sync.
    _checkCrossfadeThresholdAsync(output, currentPos);
  }

  Future<void> _checkCrossfadeThresholdAsync(
    LocalAudioOutput output,
    Duration currentPos,
  ) async {
    if (_crossfading) return;

    final dur = await output.duration();
    if (dur == null || dur <= Duration.zero) return;

    final threshold = dur - Duration(milliseconds: (crossfadeDuration * 1000).round());
    if (threshold <= Duration.zero) return; // track too short for crossfade

    if (currentPos >= threshold) {
      final nextTrack = queue.nextTrack;
      if (nextTrack != null) {
        await _startCrossfade(nextTrack);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Crossfade — execution
  // ---------------------------------------------------------------------------

  /// Starts the crossfade: creates a second LocalAudioOutput for [nextTrack],
  /// fades out the current player and fades in the next, then swaps.
  Future<void> _startCrossfade(Track nextTrack) async {
    if (_crossfading) return;
    final currentOutput = _output;
    if (currentOutput is! LocalAudioOutput) return;

    final url = nextTrack.filePath;
    if (url == null) return;

    _crossfading = true;

    // Create a second LocalAudioOutput for the next track
    final nextOutput = LocalAudioOutput(
      id: 'crossfade_next',
      displayName: 'Crossfade',
    );
    final prepResult = await nextOutput.prepare();
    if (prepResult is OutputFailure) {
      _crossfading = false;
      return;
    }

    // Start the next track at volume 0
    await nextOutput.setVolume(0.0);
    final playResult = await nextOutput.play(
      url,
      title: nextTrack.title,
      artist: nextTrack.artistName,
      album: nextTrack.albumTitle,
      albumArtUrl: _resolveArtUrl(nextTrack.coverPath),
    );
    if (playResult is OutputFailure) {
      await nextOutput.dispose();
      _crossfading = false;
      return;
    }

    _crossfadeOutput = nextOutput;

    // Fade: 50ms tick interval for smooth volume transitions
    final totalSteps = (crossfadeDuration * 1000 / 50).round();
    var step = 0;

    _crossfadeTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      step++;
      final progress = (step / totalSteps).clamp(0.0, 1.0);

      // Fade out current, fade in next
      await currentOutput.setVolume((1.0 - progress).clamp(0.0, 1.0));
      await nextOutput.setVolume(progress.clamp(0.0, 1.0));

      if (progress >= 1.0) {
        timer.cancel();
        await _completeCrossfade(nextTrack, nextOutput);
      }
    });
  }

  /// Completes the crossfade: stops the old output, swaps to the new one,
  /// advances the queue, and re-hooks position/state streams.
  Future<void> _completeCrossfade(Track nextTrack, LocalAudioOutput nextOutput) async {
    // Teardown the old output's streams and player
    await _playerStateSub?.cancel();
    _playerStateSub = null;
    await _positionSub?.cancel();
    _positionSub = null;
    await _output?.stop();
    await _output?.dispose();

    // Advance queue
    queue.next();

    // Swap: the next output becomes the current output
    _output = nextOutput;
    _hookOutput(nextOutput);

    _crossfadeOutput = null;
    _crossfadeTimer = null;
    _crossfading = false;

    EventBus.instance.emit(TrackChangedEvent(zoneId, nextTrack));
    EventBus.instance.emit(QueueChangedEvent(zoneId));
  }

  /// Cancels any in-progress crossfade and cleans up the secondary output.
  Future<void> _cancelCrossfade() async {
    _crossfadeTimer?.cancel();
    _crossfadeTimer = null;
    _crossfadeCheckTimer?.cancel();
    _crossfadeCheckTimer = null;
    _crossfading = false;

    if (_crossfadeOutput != null) {
      await _crossfadeOutput!.stop();
      await _crossfadeOutput!.dispose();
      _crossfadeOutput = null;
    }

    await _crossfadePlayerStateSub?.cancel();
    _crossfadePlayerStateSub = null;
    await _crossfadePositionSub?.cancel();
    _crossfadePositionSub = null;
  }

  // ---------------------------------------------------------------------------
  // Fin de piste
  // ---------------------------------------------------------------------------

  Future<void> _onTrackCompleted() async {
    if (_output != null && _output!.hasPendingStream) {
      return;
    }
    final next = queue.next();
    if (next != null) {
      await _playTrack(next);
      EventBus.instance.emit(QueueChangedEvent(zoneId));
    } else {
      await stop();
    }
  }

  // ---------------------------------------------------------------------------
  // Lecture interne
  // ---------------------------------------------------------------------------

  Future<void> _playTrack(Track track, {Duration? startAt}) async {
    // Cancel any ongoing crossfade when starting a new track explicitly
    await _cancelCrossfade();

    final url = track.filePath;
    if (url == null || _output == null) return;

    _setState(PlaybackState.buffering);
    _position = startAt ?? Duration.zero;

    final result = await _output!.play(
      url,
      title: track.title,
      artist: track.artistName,
      album: track.albumTitle,
      albumArtUrl: _resolveArtUrl(track.coverPath),
    );

    if (result is OutputFailure) {
      _setState(PlaybackState.stopped);
      EventBus.instance.emit(ServerErrorEvent('Play failed: ${result.message}'));
      return;
    }

    if (startAt != null && startAt > Duration.zero) {
      await _output!.seek(startAt);
    }

    // Restore volume to 1.0 after a crossfade might have left it at 0
    if (_output is LocalAudioOutput) {
      await _output!.setVolume(1.0);
    }

    _setState(PlaybackState.playing);
    EventBus.instance.emit(TrackChangedEvent(zoneId, track));
    final zid = int.tryParse(zoneId);
    if (zid != null) {
      EventBus.instance.emit(PlaybackStartedEvent(
        zid,
        positionMs: startAt?.inMilliseconds ?? 0,
        durationMs: track.durationMs,
      ));
    }

    // Gapless: pre-load next track on DLNA renderers via SetNextAVTransportURI.
    // Works for all track types (local files + streaming URLs).
    if (_output is DLNAOutput) {
      _preloadNextTrackForDlna();
    }
  }

  /// Pre-loads the next track on a DLNA renderer for gapless playback.
  Future<void> _preloadNextTrackForDlna() async {
    final dlna = _output;
    if (dlna is! DLNAOutput) return;
    final nextTrack = queue.nextTrack;
    if (nextTrack == null) return;
    final url = nextTrack.filePath;
    if (url == null) return;

    final result = await dlna.setNextTrack(
      url: url,
      title: nextTrack.title,
      artist: nextTrack.artistName,
    );
    if (result is OutputSuccess) {
      debugPrint('[Player] gapless: pre-loaded next track "${nextTrack.title}"');
    }
  }

  // ---------------------------------------------------------------------------
  // Changement d'état
  // ---------------------------------------------------------------------------

  void _setState(PlaybackState newState) {
    if (_state == newState) return;
    _state = newState;
    EventBus.instance.emit(PlaybackStateChangedEvent(zoneId, newState.rawValue));
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  Future<void> dispose() async {
    await _teardownOutput();
    _setState(PlaybackState.stopped);
  }
}
