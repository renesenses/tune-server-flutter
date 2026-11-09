/// « Ce téléphone » vu de l'interface embarquée.
///
/// Depuis sa 1.0.14, la télécommande joue elle-même la zone `browser` du
/// téléphone (just_audio + audio_service). Ici, c'est l'application qui la
/// joue déjà ([SortieTelephone]) : si l'interface la jouait aussi, le même
/// morceau sortirait deux fois. Les surcharges ci-dessous gardent UN seul
/// lecteur :
/// - le lecteur de l'interface ne joue rien ;
/// - le nom de l'appareil est celui de la zone de l'application, pour que
///   « Écouter sur ce téléphone » reprenne cette zone au lieu d'en créer une
///   autre.
///
/// Et une troisième, pour « Sources du réseau » (#8189) : le moteur tourne
/// DANS ce téléphone. Quand la découverte ne trouve rien, l'écran conseille
/// alors de mettre le téléphone sur le même Wi-Fi que le NAS, au lieu de
/// parler du réseau d'un serveur de bureau.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_remote/etat/sources_reseau.dart';
import 'package:tune_remote/etat/telephone.dart';
import 'package:tune_remote/modele/zone.dart' show Piste;
import 'package:tune_remote/service/pont.dart' show SourceFlux;
import 'package:tune_remote/service/telephone.dart' show LecteurLocal;

import 'sortie_telephone.dart' show nomZoneTelephone;

/// Un lecteur qui ne joue rien : le son vient de [SortieTelephone].
class LecteurMuet implements LecteurLocal {
  const LecteurMuet();

  @override
  Future<void> jouer(
    SourceFlux source, {
    required Piste? piste,
    int positionInitialeMs = 0,
  }) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> reprendre() async {}

  @override
  Future<void> arreter() async {}
}

/// Les surcharges passées à `lancerTune`.
List<Override> surchargesTelephone() => [
  fabriqueLecteurProvider.overrideWithValue(
    (commande, rappels) async => const LecteurMuet(),
  ),
  nomAppareilProvider.overrideWithValue(() async => nomZoneTelephone),
  contexteDecouverteProvider.overrideWithValue(
    const ContexteDecouverte(moteurSurCetAppareil: true),
  ),
];
