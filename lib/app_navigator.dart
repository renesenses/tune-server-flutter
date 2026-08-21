import 'package:flutter/material.dart';

/// Key to the app's root [Navigator].
///
/// The phone player sheet ([PlayerSheet]) is mounted as a sibling of the
/// Navigator via `MaterialApp.builder`, so it has **no Navigator in its own
/// ancestors**. Navigating or opening modals with the sheet's local `context`
/// therefore failed silently in release: the volume popup never opened and the
/// artist/title links did nothing (Fabien, recurring on Android). Route those
/// through this key instead of the local context.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Onglet actif de la barre du bas, sur téléphone.
///
/// Hissé hors du `Navigator` pour la MÊME raison que le tiroir de lecture
/// (#1088) : la barre d'onglets vivait dans le `Scaffold` de la route racine,
/// donc toute sous-page poussée en plein écran la recouvrait. On perdait ses
/// repères de navigation dès qu'on ouvrait un album, un artiste ou le volume
/// (Fabien, #1950).
///
/// Un `ValueNotifier` plutôt qu'un état local : la barre et le contenu des
/// onglets ne sont plus dans le même arbre de widgets, il leur faut donc une
/// source commune.
final ValueNotifier<int> ongletActif = ValueNotifier<int>(0);

/// La vue à onglets est-elle à l'écran ?
///
/// Nécessaire parce que le `builder:` de `MaterialApp` enveloppe TOUTES les
/// routes du téléphone, y compris le sélecteur de mode affiché au lancement
/// avant d'entrer dans l'application. Dessiner la barre inconditionnellement y
/// ferait apparaître cinq onglets qui ne mènent nulle part — on remplacerait la
/// barre qui disparaît (#1950) par une barre qui apparaît là où elle n'a rien à
/// faire.
///
/// `iPhoneContentView` lève ce drapeau tant qu'elle est montée.
final ValueNotifier<bool> ongletsMontes = ValueNotifier<bool>(false);

/// Change d'onglet, en dépilant d'abord les sous-pages ouvertes.
///
/// Sans le dépilage, taper un onglet pendant qu'un album est ouvert changerait
/// l'onglet SOUS la page affichée : rien ne bougerait à l'écran, et l'onglet
/// actif ne correspondrait plus à ce qu'on voit. C'est la contrepartie directe
/// d'avoir sorti la barre du `Navigator`.
void allerAOnglet(int index) {
  appNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  ongletActif.value = index;
}
