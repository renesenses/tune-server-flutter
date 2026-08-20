// #1951 : la barre de progression compacte est devenue utilisable pour se
// positionner. Ici on ne teste que le CALCUL de la position visée — c'est là
// que vivent les erreurs de bornes, et le widget privé dépend de deux
// `Provider` qui ne se testent pas à ce grain.
//
// flutter test test/views/mini_progress_bar_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/views/components/player_sheet.dart';

void main() {
  group('fractionVisee', () {
    test('rend la fraction attendue au milieu et aux extrémités', () {
      expect(fractionVisee(0, 200), 0.0);
      expect(fractionVisee(100, 200), 0.5);
      expect(fractionVisee(200, 200), 1.0);
    });

    test('borne un toucher hors de la barre', () {
      // Un glissement continue au-delà des bords : la valeur doit rester dans
      // le morceau, pas le dépasser.
      expect(fractionVisee(-50, 200), 0.0);
      expect(fractionVisee(1000, 200), 1.0);
    });

    // Le cas qui ferait planter l'application : `dx / 0` donne NaN, `.clamp()`
    // le propage, et `.round()` LÈVE UNE EXCEPTION en Dart. `LayoutBuilder`
    // peut produire une largeur nulle pendant une passe de mise en page.
    test('une largeur nulle ne produit ni NaN ni exception', () {
      final v = fractionVisee(42, 0);
      expect(v.isNaN, isFalse, reason: 'NaN ferait lever .round() plus loin');
      expect(v, 0.0);
      expect(() => (v * 300000).round(), returnsNormally);
    });

    test('une largeur négative est traitée comme nulle', () {
      expect(fractionVisee(42, -10), 0.0);
    });

    test('le résultat est toujours convertible en millisecondes', () {
      for (final dx in [-1e9, -1.0, 0.0, 37.5, 1e9]) {
        for (final largeur in [0.0, -5.0, 1.0, 360.0]) {
          final v = fractionVisee(dx, largeur);
          expect(v >= 0.0 && v <= 1.0, isTrue,
              reason: 'dx=$dx largeur=$largeur → $v');
          expect(() => (v * 300000).round(), returnsNormally);
        }
      }
    });
  });
}
