import 'package:flutter/widgets.dart';
import 'package:tune_remote/tune_remote.dart';

import 'embarque/android.dart';
import 'embarque/demarrage.dart';
import 'embarque/preferences.dart';

// ---------------------------------------------------------------------------
// Tune serveur — le serveur Tune dans le téléphone.
//
// Le moteur est le serveur Rust (libtuneserver.so, Dart FFI), lancé derrière
// un service au premier plan. L'interface est CELLE DE LA TÉLÉCOMMANDE
// (tune-remote-flutter), prise en dépendance et non recopiée : elle parle au
// moteur sur 127.0.0.1:8888, exactement comme à un serveur du réseau.
// ---------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final serveur = serveurAndroid();
  runApp(
    EcranDemarrage(
      demarrer: serveur.demarrer,
      quandPret: (_) async {
        await preparerTelecommande();
        // Remplace l'écran de démarrage par l'interface de la télécommande.
        await lancerTune(paquet: 'tune_remote');
      },
    ),
  );
}
