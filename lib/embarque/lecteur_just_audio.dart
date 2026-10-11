/// Le lecteur du téléphone : just_audio (ExoPlayer sur Android).
library;

import 'package:just_audio/just_audio.dart';

import 'sortie_telephone.dart';

class LecteurJustAudio implements Lecteur {
  LecteurJustAudio([AudioPlayer? lecteur]) : _l = lecteur ?? AudioPlayer();

  final AudioPlayer _l;
  String? _url;

  @override
  String? get url => _url;

  @override
  bool get joue => _l.playing;

  @override
  Stream<void> get fini => _l.processingStateStream
      .where((s) => s == ProcessingState.completed)
      .map((_) {});

  @override
  Future<void> charger(String url) async {
    _url = url;
    try {
      await _l.setUrl(url);
      // `play()` ne rend la main qu'à la pause ou à la fin : on ne l'attend pas.
      _l.play();
    } catch (_) {
      // Flux refusé : on oublie l'adresse pour que le tour suivant réessaie.
      _url = null;
    }
  }

  @override
  Future<void> reprendre() async {
    // Après une longue pause, le serveur a pu fermer le flux : on recharge.
    if (_l.processingState == ProcessingState.idle && _url != null) {
      return charger(_url!);
    }
    _l.play();
  }

  @override
  Future<void> suspendre() => _l.pause();

  @override
  Future<void> couper() async {
    _url = null;
    await _l.stop();
  }

  @override
  Future<void> volume(double v) async {
    if ((_l.volume - v).abs() > 0.001) await _l.setVolume(v);
  }

  @override
  Future<void> liberer() => _l.dispose();
}
