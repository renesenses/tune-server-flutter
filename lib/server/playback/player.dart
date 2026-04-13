import 'dart:async';

import 'package:just_audio/just_audio.dart' show ProcessingState, PlayerState;

import '../../models/enums.dart';
import '../audio/local_audio_output.dart';
import '../database/database.dart';
import '../event_bus.dart';
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

  Player({required this.zoneId, required this.queue});

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
      });

      _playerStateSub = output.playerStateStream.listen((ps) {
        if (ps.processingState == ProcessingState.completed) {
          _onTrackCompleted();
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
    await _output?.stop();
    _position = Duration.zero;
    _setState(PlaybackState.stopped);
  }

  Future<void> seek(Duration position) async {
    await _output?.seek(position);
    _position = position;
    EventBus.instance.emit(PlaybackPositionEvent(zoneId, position.inMilliseconds));
  }

  /// Passe à la piste suivante.
  Future<void> next() async {
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
  // Fin de piste
  // ---------------------------------------------------------------------------

  Future<void> _onTrackCompleted() async {
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
    final url = track.filePath;
    if (url == null || _output == null) return;

    _setState(PlaybackState.buffering);
    _position = startAt ?? Duration.zero;

    final result = await _output!.play(
      url,
      title: track.title,
      artist: track.artistName,
    );

    if (result is OutputFailure) {
      _setState(PlaybackState.stopped);
      EventBus.instance.emit(ServerErrorEvent('Play failed: ${result.message}'));
      return;
    }

    if (startAt != null && startAt > Duration.zero) {
      await _output!.seek(startAt);
    }

    _setState(PlaybackState.playing);
    EventBus.instance.emit(TrackChangedEvent(zoneId, track));
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
