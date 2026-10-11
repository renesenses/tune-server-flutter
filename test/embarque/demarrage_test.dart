import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/embarque/demarrage.dart';
import 'package:tune_server/embarque/serveur_embarque.dart';

void main() {
  testWidgets('attente, puis interface quand le serveur répond', (t) async {
    final issue = Completer<Demarrage>();
    Pret? recu;
    await t.pumpWidget(
      EcranDemarrage(
        demarrer: () => issue.future,
        quandPret: (p) async => recu = p,
      ),
    );
    expect(find.byKey(const Key('demarrage_en_cours')), findsOneWidget);

    issue.complete(const Pret('1.0.0-rc3', serviceActif: true));
    await t.pump();
    expect(recu?.version, '1.0.0-rc3');
  });

  testWidgets('un échec se lit, et « Réessayer » relance', (t) async {
    var essais = 0;
    Pret? recu;
    await t.pumpWidget(
      EcranDemarrage(
        demarrer: () async => ++essais == 1
            ? const Echec('Le moteur a refusé de démarrer (code -2).')
            : const Pret('1.0.0-rc3', serviceActif: true),
        quandPret: (p) async => recu = p,
      ),
    );
    await t.pump();
    expect(
      find.text('Le moteur a refusé de démarrer (code -2).'),
      findsOneWidget,
    );
    expect(recu, isNull);

    await t.tap(find.text('Réessayer'));
    await t.pump();
    expect(essais, 2);
    expect(recu, isNotNull);
  });
}
