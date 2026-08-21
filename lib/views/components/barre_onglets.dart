import 'package:flutter/material.dart';

import '../../app_navigator.dart';
import '../../l10n/app_localizations.dart';

/// Barre d'onglets du bas, montée AU-DESSUS du `Navigator`.
///
/// Elle vivait dans le `Scaffold` de la route racine, donc toute sous-page
/// poussée en plein écran la recouvrait : ouvrir un album, un artiste ou le
/// popup de volume faisait disparaître la navigation principale (Fabien,
/// #1950). C'est le même défaut, et le même remède, que pour le tiroir de
/// lecture (#1088).
///
/// ⚠️ Ordre d'empilement : cette barre se place ENTRE le `Navigator` et le
/// tiroir de lecture. Au-dessus du tiroir, elle tronquerait la vue « en cours
/// de lecture » une fois dépliée.
class BarreOnglets extends StatelessWidget {
  const BarreOnglets({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final onglets = [
      (icon: Icons.library_music_outlined, activeIcon: Icons.library_music_rounded, label: l.navLibrary),
      (icon: Icons.cloud_outlined, activeIcon: Icons.cloud_rounded, label: l.navStreaming),
      (icon: Icons.speaker_group_outlined, activeIcon: Icons.speaker_group_rounded, label: l.navZones),
      (icon: Icons.radio_outlined, activeIcon: Icons.radio_rounded, label: l.navRadios),
      (icon: Icons.more_horiz_rounded, activeIcon: Icons.more_horiz_rounded, label: 'More'),
    ];

    return Stack(
      children: [
        Positioned.fill(child: child),
        // L'`Overlay` occupe TOUT l'écran, et la barre s'y aligne en bas à sa
        // taille naturelle.
        //
        // Deux contraintes se combinent ici, et chacune a coûté un échec :
        //
        // 1. `BottomNavigationBar` exige un `Overlay` parmi ses ancêtres (effets
        //    d'encre). Celui-ci est normalement fourni par le `Navigator`, qui
        //    est désormais SOUS nous — sans cet `Overlay`, l'application plante
        //    au premier rendu (« No Overlay widget found »). Même piège que le
        //    tiroir de lecture, déjà documenté dans `app_navigator.dart`.
        //
        // 2. Un `Overlay` a besoin de contraintes bornées. La première version
        //    lui donnait une hauteur calculée — et la barre débordait de 2 px,
        //    faute de place pour son propre rembourrage. D'où `Positioned.fill`
        //    plus `Align` : la barre se dimensionne elle-même, exactement comme
        //    dans un `Scaffold`, y compris sa zone de sécurité du bas.
        //
        // Une entrée d'`Overlay` pleine taille n'absorbe pas les touchers là où
        // elle n'a pas d'enfant : le contenu sous la barre reste cliquable.
        Positioned.fill(
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Align(
                  alignment: Alignment.bottomCenter,
                  // Rien tant que la vue à onglets n'est pas montée : le
                  // `builder:` enveloppe aussi le sélecteur de mode du
                  // lancement, où cinq onglets ne mèneraient nulle part.
                  child: ValueListenableBuilder<bool>(
                    valueListenable: ongletsMontes,
                    builder: (context, montes, _) {
                      if (!montes) return const SizedBox.shrink();
                      return ValueListenableBuilder<int>(
                        valueListenable: ongletActif,
                        builder: (context, index, _) => BottomNavigationBar(
                          currentIndex: index,
                          // `allerAOnglet` et non une simple affectation : il
                          // faut dépiler les sous-pages ouvertes, sinon on
                          // changerait l'onglet SOUS la page affichée et rien
                          // ne bougerait.
                          onTap: allerAOnglet,
                          items: onglets
                              .map((t) => BottomNavigationBarItem(
                                    icon: Icon(t.icon),
                                    activeIcon: Icon(t.activeIcon),
                                    label: t.label,
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
