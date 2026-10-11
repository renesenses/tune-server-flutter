import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tune_remote/etat/etat.dart' show AdresseServeur;
import 'package:tune_server/embarque/preferences.dart';
import 'package:tune_server/embarque/serveur_embarque.dart';

void main() {
  test(
    "l'interface pointe sur le moteur du téléphone, sans bienvenue",
    () async {
      // Quelqu'un avait pointé l'interface vers un serveur du réseau.
      SharedPreferences.setMockInitialValues({
        AdresseServeur.cle: 'http://192.168.1.18:8888',
        cleBienvenueFaite: false,
      });

      await preparerTelecommande();

      // Lu par le code même de la télécommande, celui qui tourne avant son
      // premier dessin : c'est lui qui doit trouver 127.0.0.1.
      expect(await AdresseServeur.lire(), adresseLocale);
      final p = await SharedPreferences.getInstance();
      expect(p.getBool(cleBienvenueFaite), isTrue);
    },
  );
}
