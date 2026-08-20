import 'package:flutter/material.dart';

/// Point de partage entre la vue à onglets du téléphone et le `builder:` de
/// `MaterialApp`, pour que la barre d'onglets vive AU-DESSUS du Navigator.
///
/// ## Pourquoi
///
/// La `BottomNavigationBar` était portée par le `Scaffold` de
/// `iPhoneContentView`, qui est la route racine du Navigator racine. Toute
/// sous-page — album, artiste, genre, playlist, dossier — est poussée en plein
/// écran sur ce MÊME Navigator et recouvrait donc la barre : la navigation
/// principale disparaissait à chaque tap (#1950, Fabien).
///
/// La barre suit désormais le chemin déjà emprunté par la barre de lecture
/// (`PlayerSheetScaffold`, #1088) : montée dans le `builder:`, elle est peinte
/// au-dessus des routes plein écran au lieu d'être recouverte par elles.
///
/// ## Ce que ce fichier n'est PAS
///
/// Ce n'est pas un retour aux `Navigator` par onglet. Cette approche-là avait
/// laissé l'écran NOIR à la première image sur certains GPU Android (Elie,
/// Xiaomi/Android 16) : la route racine d'un Navigator imbriqué dans un
/// `IndexedStack` ne résolvait jamais sa transition d'entrée. Le commentaire de
/// `iphone_content_view.dart` en garde la trace, et rien ici ne le remet en
/// cause.
///
/// ## Le champ `mounted` n'est pas décoratif
///
/// Le `builder:` de `MaterialApp` enveloppe TOUT, y compris le sélecteur de
/// mode affiché avant d'entrer dans l'application. Afficher la barre
/// inconditionnellement la ferait apparaître sur des écrans qui n'ont pas
/// d'onglets. La vue à onglets signale donc sa présence, et la barre n'existe
/// que pendant ce temps.
class TabShell {
  TabShell._();

  /// Onglet actif. Écrit par la barre, lu par la vue.
  static final ValueNotifier<int> index = ValueNotifier<int>(0);

  /// La vue à onglets est-elle à l'écran ?
  static final ValueNotifier<bool> mounted = ValueNotifier<bool>(false);

  /// Les onglets à afficher, publiés par la vue qui connaît les traductions.
  ///
  /// `null` tant que rien n'est monté — la barre ne se dessine pas.
  static final ValueNotifier<List<TabShellItem>?> items =
      ValueNotifier<List<TabShellItem>?>(null);

  /// Remet tout à zéro quand la vue disparaît, pour qu'une barre orpheline ne
  /// survive pas à un changement de mode.
  static void detach() {
    mounted.value = false;
    items.value = null;
  }
}

/// Un onglet, indépendant de Material pour que la vue n'ait pas à importer le
/// widget qu'elle ne construit plus.
class TabShellItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const TabShellItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
