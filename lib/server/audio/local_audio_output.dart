import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../outputs/output_target.dart';

// ---------------------------------------------------------------------------
// T4.2 — LocalAudioOutput
// Lecture locale via just_audio (fichier ou HTTP).
// Miroir de LocalAudioOutput.swift (iOS / AVAudioEngine)
//
// [HI-RES-TODO] : vérifier support 24-bit/192kHz natif just_audio sur iOS et Android.
// Sur iOS, just_audio délègue à AVPlayer qui supporte nativement FLAC/ALAC Hi-Res.
// Sur Android, ExoPlayer (backend just_audio) supporte FLAC mais pas toujours 24-bit.
// ---------------------------------------------------------------------------

class LocalAudioOutput implements OutputTarget {
  @override
  final String id;

  @override
  final String displayName;

  final AudioPlayer _player;
  OutputReadyState _readyState = OutputReadyState.idle;

  LocalAudioOutput({
    this.id = 'local',
    this.displayName = 'Haut-parleurs',
  }) : _player = AudioPlayer();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> prepare() async {
    if (_readyState == OutputReadyState.ready) return const OutputSuccess();
    _readyState = OutputReadyState.preparing;

    try {
      // Configure la session audio iOS/Android
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      _readyState = OutputReadyState.ready;
      return const OutputSuccess();
    } catch (e) {
      _readyState = OutputReadyState.error;
      return OutputFailure(e.toString());
    }
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
    _readyState = OutputReadyState.idle;
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
    try {
      final AudioSource source;
      if (url.startsWith('http://') || url.startsWith('https://')) {
        source = AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: url,
            title: title ?? '',
            artist: artist,
            artUri: albumArtUrl != null ? Uri.tryParse(albumArtUrl) : null,
          ),
        );
      } else {
        source = AudioSource.file(
          url,
          tag: MediaItem(
            id: url,
            title: title ?? '',
            artist: artist,
          ),
        );
      }

      await _player.setAudioSource(source);
      await _player.play();
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure(e.toString());
    }
  }

  @override
  Future<OutputResult> pause() async {
    try {
      await _player.pause();
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure(e.toString());
    }
  }

  @override
  Future<OutputResult> resume() async {
    try {
      await _player.play();
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure(e.toString());
    }
  }

  @override
  Future<OutputResult> stop() async {
    try {
      await _player.stop();
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure(e.toString());
    }
  }

  @override
  Future<OutputResult> seek(Duration position) async {
    try {
      await _player.seek(position);
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  @override
  Future<OutputResult> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
      return const OutputSuccess();
    } catch (e) {
      return OutputFailure(e.toString());
    }
  }

  @override
  double? get currentVolume => _player.volume;

  // ---------------------------------------------------------------------------
  // Position
  // ---------------------------------------------------------------------------

  @override
  Future<Duration?> currentPosition() async => _player.position;

  @override
  Future<Duration?> duration() async => _player.duration;

  // ---------------------------------------------------------------------------
  // État
  // ---------------------------------------------------------------------------

  @override
  OutputReadyState get readyState => _readyState;

  @override
  bool get isPlaying => _player.playing;

  /// Stream des changements d'état just_audio (pour le Player en Phase 5).
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Stream de la position (pour le timer de position en Phase 5).
  Stream<Duration> get positionStream => _player.positionStream;
}
