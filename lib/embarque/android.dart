/// Les pièces propres à Android : le service au premier plan
/// (`flutter_foreground_task`, type `mediaPlayback`) et les dossiers.
library;

import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:path_provider/path_provider.dart';

import 'package:verrou_multicast/verrou_multicast.dart';

import 'moteur_natif.dart';
import 'tache_serveur.dart';
import 'serveur_embarque.dart';

/// Le serveur tel que l'application le lance sur un téléphone.
ServeurEmbarque serveurAndroid() => ServeurEmbarque(
  moteur: MoteurNatif.charger,
  service: ServiceAvantPlanAndroid(),
  dossierDonnees: () async => (await getApplicationSupportDirectory()).path,
  repertoires: repertoiresParDefaut,
);

/// Les dossiers de musique habituels d'un téléphone, s'ils existent.
Future<List<String>> repertoiresParDefaut() async {
  const candidats = [
    '/storage/emulated/0/Music',
    '/storage/emulated/0/Download',
  ];
  return [
    for (final c in candidats)
      if (await Directory(c).exists()) c,
  ];
}

class ServiceAvantPlanAndroid implements ServiceAvantPlan {
  static bool _initialise = false;

  static void _initialiser() {
    if (_initialise) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'tune_server',
        channelName: 'Serveur Tune',
        channelDescription: 'Le serveur Tune tourne sur ce téléphone',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        // Jamais au démarrage du téléphone : Android 15 refuse un service
        // `mediaPlayback` lancé depuis BOOT_COMPLETED.
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    _initialise = true;
  }

  @override
  Future<bool> demarrer() async {
    _initialiser();
    // Android 13+ : sans POST_NOTIFICATIONS, le service au premier plan ne
    // démarre pas (et l'ancien code plantait l'application — Levente).
    try {
      final p = await FlutterForegroundTask.checkNotificationPermission();
      if (p != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
    } catch (_) {}
    try {
      if (await FlutterForegroundTask.isRunningService) return true;
      final r = await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Serveur Tune',
        notificationText: 'Tune sert votre musique depuis ce téléphone',
        notificationButtons: const [
          NotificationButton(id: 'arreter', text: 'Arrêter'),
        ],
        callback: _rappelDuService,
      );
      return r is ServiceRequestSuccess;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> arreter() async {
    try {
      await FlutterForegroundTask.stopService();
    } catch (_) {}
  }
}

@pragma('vm:entry-point')
void _rappelDuService() {
  FlutterForegroundTask.setTaskHandler(
    TacheServeur(
      verrou: const VerrouMulticast(),
      arreterMoteur: () => MoteurNatif.charger().arreter(),
      arreterService: FlutterForegroundTask.stopService,
    ),
  );
}
