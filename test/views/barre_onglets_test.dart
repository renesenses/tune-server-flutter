// Le cœur de #1950 : la barre d'onglets doit SURVIVRE à une sous-page poussée
// en plein écran. C'est précisément ce qu'elle ne faisait pas quand elle vivait
// dans le `Scaffold` de la route racine.
//
// Ce test ne dit rien du rendu réel (position, zone de sécurité, appareil) —
// seulement que la barre est toujours dans l'arbre, et qu'elle réagit.
//
// flutter test test/views/barre_onglets_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tune_server/app_navigator.dart';
import 'package:tune_server/l10n/app_localizations.dart';
import 'package:tune_server/views/components/barre_onglets.dart';

Widget _app() => MaterialApp(
      navigatorKey: appNavigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => BarreOnglets(child: child ?? const SizedBox.shrink()),
      home: const Scaffold(body: Text('racine')),
    );

void main() {
  setUp(() {
    ongletActif.value = 0;
    // La vue à onglets est montée dans tous les cas ci-dessous, sauf là où le
    // contraire est explicitement testé.
    ongletsMontes.value = true;
  });

  tearDown(() => ongletsMontes.value = false);

  // Le `builder:` de `MaterialApp` enveloppe TOUTES les routes du téléphone, y
  // compris le sélecteur de mode du lancement. Sans ce drapeau, on remplacerait
  // une barre qui disparaît par une barre qui apparaît là où elle n'a rien à
  // faire — et ses cinq onglets ne mèneraient nulle part.
  testWidgets('aucune barre tant que la vue à onglets n\'est pas montée', (t) async {
    ongletsMontes.value = false;
    await t.pumpWidget(_app());
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(find.text('racine'), findsOneWidget,
        reason: 'le contenu reste affiché, seule la barre s\'efface');

    // Et elle apparaît dès que la vue à onglets se monte.
    ongletsMontes.value = true;
    await t.pumpAndSettle();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('la barre survit à une sous-page poussée en plein écran', (t) async {
    await t.pumpWidget(_app());
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('racine'), findsOneWidget);

    // Exactement le geste de Fabien : ouvrir un album depuis la bibliothèque.
    appNavigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => const Scaffold(body: Text('album'))),
    );
    await t.pumpAndSettle();

    expect(find.text('album'), findsOneWidget);
    expect(
      find.byType(BottomNavigationBar),
      findsOneWidget,
      reason: 'la barre d\'onglets doit rester visible sous la sous-page',
    );
  });

  testWidgets('changer d\'onglet dépile les sous-pages ouvertes', (t) async {
    await t.pumpWidget(_app());
    appNavigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => const Scaffold(body: Text('album'))),
    );
    await t.pumpAndSettle();
    expect(find.text('album'), findsOneWidget);

    // Sans le dépilage, l'onglet changerait SOUS la page affichée : rien ne
    // bougerait à l'écran et l'onglet actif ne correspondrait plus à la vue.
    allerAOnglet(2);
    await t.pumpAndSettle();

    expect(find.text('album'), findsNothing, reason: 'la sous-page doit être dépilée');
    expect(find.text('racine'), findsOneWidget);
    expect(ongletActif.value, 2);
  });

  testWidgets('taper un onglet met à jour l\'index partagé', (t) async {
    await t.pumpWidget(_app());
    expect(ongletActif.value, 0);

    await t.tap(find.byIcon(Icons.radio_outlined));
    await t.pumpAndSettle();

    expect(ongletActif.value, 3, reason: 'Radios est le 4e onglet');
  });
}
