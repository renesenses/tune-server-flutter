import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/embarque/moteur_natif.dart';

void main() {
  test(
    'les répertoires partent en JSON valide, caractères spéciaux compris',
    () {
      const dossiers = [
        '/storage/emulated/0/Music',
        '/storage/emulated/0/Musique "live"',
        r'/storage/emulated/0/a\b',
        '/storage/emulated/0/Été',
      ];
      final json = repertoiresEnJson(dossiers);
      // L'ancienne concaténation produisait ici un JSON invalide : le moteur
      // retombait alors en silence sur une liste vide.
      expect(jsonDecode(json), dossiers);
    },
  );

  test('aucun répertoire : un tableau vide', () {
    expect(repertoiresEnJson(const []), '[]');
  });
}
