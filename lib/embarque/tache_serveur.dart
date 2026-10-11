/// Ce que fait le service au premier plan, dans son propre isolat.
library;

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:verrou_multicast/verrou_multicast.dart';

/// Tourne dans l'isolat du service. Il ne démarre pas le moteur — c'est
/// l'interface qui le lance — mais il tient ce qui doit vivre AUSSI
/// LONGTEMPS QUE LE SERVICE :
///
/// - le verrou multicast Wi-Fi, pris au démarrage du service et rendu à son
///   arrêt. Sans lui, un téléphone filtre le multicast : plus de SSDP ni de
///   mDNS, la découverte des lecteurs reste aveugle ;
/// - l'arrêt du moteur quand le service s'arrête (bouton « Arrêter » de la
///   notification, arrêt par le système) : le serveur ne survit pas à sa
///   notification.
class TacheServeur extends TaskHandler {
  TacheServeur({
    required this.verrou,
    required this.arreterMoteur,
    required this.arreterService,
  });

  final VerrouMulticast verrou;
  final void Function() arreterMoteur;
  final Future<Object?> Function() arreterService;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await verrou.prendre();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'arreter') arreterService();
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    try {
      arreterMoteur();
    } catch (_) {}
    await verrou.rendre();
  }
}
