import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tune_remote/etat/sources_reseau.dart';
import 'package:tune_remote/etat/telephone.dart';
import 'package:tune_remote/service/telephone.dart' show RappelsLecteur;
import 'package:tune_server/embarque/sortie_telephone.dart';
import 'package:tune_server/embarque/telephone_interface.dart';

/// Un seul lecteur pour « Ce téléphone » : celui de l'application.
void main() {
  test("l'interface reçoit un lecteur muet, pas le sien", () async {
    final c = ProviderContainer(overrides: surchargesTelephone());
    addTearDown(c.dispose);
    final lecteur = await c.read(fabriqueLecteurProvider)(
      (_) async {},
      RappelsLecteur(
        progression: (_, _, _) async {},
        position: (_, _) {},
        fin: (_) {},
      ),
    );
    expect(lecteur, isA<LecteurMuet>());
  });

  test("l'interface reprend la zone de l'application, par son nom", () async {
    final c = ProviderContainer(overrides: surchargesTelephone());
    addTearDown(c.dispose);
    expect(await c.read(nomAppareilProvider)(), nomZoneTelephone);
  });

  test('« Sources du réseau » sait que le moteur est dans ce téléphone (#8189)',
      () {
    final c = ProviderContainer(overrides: surchargesTelephone());
    addTearDown(c.dispose);
    expect(c.read(contexteDecouverteProvider).moteurSurCetAppareil, isTrue);
  });
}
