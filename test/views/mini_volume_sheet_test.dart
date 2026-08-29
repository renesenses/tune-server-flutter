// #2309 : ouvrir le volume ajoutait une ligne au mini-player sans agrandir le
// DraggableScrollableSheet. Le contrôle existait donc hors du viewport.
//
// flutter test test/views/mini_volume_sheet_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/views/components/player_sheet.dart';

void main() {
  group('tailleMiniAvecVolume', () {
    test('ajoute la hauteur réelle de la ligne sur un téléphone courant', () {
      final taille = tailleMiniAvecVolume(800);

      expect(taille, closeTo(0.16, 0.000001));
      expect((taille - 0.09) * 800, closeTo(56, 0.001));
    });

    test('reste distincte du cran Lecture en cours sur un écran très court', () {
      final taille = tailleMiniAvecVolume(100);

      expect(taille, greaterThan(0.09));
      expect(taille, lessThan(0.52));
    });

    test('retombe sur le mini-player pour une contrainte inexploitable', () {
      expect(tailleMiniAvecVolume(0), 0.09);
      expect(tailleMiniAvecVolume(-1), 0.09);
      expect(tailleMiniAvecVolume(double.nan), 0.09);
      expect(tailleMiniAvecVolume(double.infinity), 0.09);
    });
  });
}
