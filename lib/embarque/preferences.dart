/// Ce que l'interface de la télécommande doit savoir avant son premier
/// dessin, quand elle est embarquée dans le serveur.
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tune_remote/etat/etat.dart' show AdresseServeur;

import 'serveur_embarque.dart';

/// La clé sous laquelle la télécommande retient que l'écran de bienvenue a
/// été passé (`onboardingProvider`, `lib/etat/guide.dart` de tune-remote).
const cleBienvenueFaite = 'onboarding_fait';

/// Pointe l'interface sur le moteur du téléphone et saute l'écran de
/// bienvenue : il sert à TROUVER un serveur, et le serveur est ici.
///
/// Rejoué à chaque lancement : si l'on a pointé l'interface vers un autre
/// serveur dans les Paramètres, l'application « Tune serveur » revient au
/// sien au démarrage suivant.
Future<void> preparerTelecommande() async {
  final p = await SharedPreferences.getInstance();
  await p.setString(AdresseServeur.cle, adresseLocale);
  await p.setBool(cleBienvenueFaite, true);
}
