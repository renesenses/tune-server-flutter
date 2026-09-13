// #4077 — le sort des zones déjà créées au-delà du plafond gratuit.
//
// Le plafond du gratuit passe de 10 à 3 pour s'aligner sur le serveur Rust
// (`DEFAULT_FREE_MAX_ZONES`, tune-core/src/license.rs). Des installations
// Android portent légitimement jusqu'à dix zones : elles les CONSERVENT.
// Seule la création d'une zone supplémentaire est refusée, avec un message qui
// le dit.
//
// Ce fichier tient les deux témoins de cette promesse :
//   1. le message montré à quelqu'un qui a sept zones ;
//   2. l'absence de toute garde de licence dans `ZoneManager.bootstrap`, qui
//      est ce qui empêche les zones excédentaires de disparaître au démarrage.
//
// Le témoin 2 est un contrôle de source : ce dépôt n'a pas de fabrique de base
// en mémoire (cf. la note en tête de test/server/auto_dj_test.dart), on ne peut
// donc pas exécuter `bootstrap()` en test. Il extrait le corps EXACT de la
// méthode par équilibrage d'accolades, pas par un grep du fichier entier.
//
// Run with : flutter test test/server/zone_cap_grandfathering_test.dart

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/l10n/app_localizations_en.dart';
import 'package:tune_server/l10n/app_localizations_fr.dart';
import 'package:tune_server/server/license/license_manager.dart';
import 'package:tune_server/state/app_state.dart';

/// Extrait le corps de `bootstrap()` dans zone_manager.dart en équilibrant les
/// accolades depuis sa signature. Lève si la méthode a disparu ou été renommée
/// — un test qui ne trouve plus sa cible doit rougir, pas passer.
String _bootstrapBody() {
  final src = File('lib/server/zones/zone_manager.dart').readAsStringSync();
  const sig = 'Future<void> bootstrap() async {';
  final start = src.indexOf(sig);
  if (start < 0) {
    throw StateError(
        'ZoneManager.bootstrap introuvable : signature changée ? Ce témoin '
        'garde la conservation des zones excédentaires (#4077), il doit être '
        'remis à jour, pas supprimé.');
  }
  var i = start + sig.length - 1; // sur l'accolade ouvrante
  var depth = 0;
  do {
    if (src[i] == '{') depth++;
    if (src[i] == '}') depth--;
    i++;
  } while (depth > 0 && i < src.length);
  expect(depth, 0, reason: 'accolades non équilibrées dans zone_manager.dart');
  return src.substring(start, i);
}

void main() {
  group('#4077 — ce que voit un utilisateur qui a déjà sept zones', () {
    test('la création est refusée, avec le compte réel dans l\'exception', () {
      const e = ZoneLimitException(LicenseManager.freeMaxZones, 7);
      expect(e.isGrandfathered, isTrue);
      expect(zoneErrorKeyFor(e), 'zone_limit_over_cap');
    });

    test('quelqu\'un pile au plafond reçoit le message ordinaire', () {
      const e = ZoneLimitException(LicenseManager.freeMaxZones, 3);
      expect(zoneErrorKeyFor(e), 'zone_limit_reached');
    });

    test('le message nomme SES sept zones et ne prétend pas qu\'il en a 3', () {
      final en = AppLocalizationsEn();
      final msg = en.zoneLimitOverCap(7, LicenseManager.freeMaxZones);
      expect(msg, contains('7'));
      expect(msg, contains('3'));
      expect(msg.toLowerCase(), contains('keep working'));
      // Le message ordinaire, lui, serait faux ici : il n'annonce que le
      // plafond, sans dire que les zones existantes restent.
      expect(en.zoneLimitReached(LicenseManager.freeMaxZones), isNot(msg));
    });

    test('le message existe aussi en français', () {
      final fr = AppLocalizationsFr();
      final msg = fr.zoneLimitOverCap(7, LicenseManager.freeMaxZones);
      expect(msg, contains('7'));
      expect(msg, contains('3'));
      expect(msg.toLowerCase(), contains('continuent de fonctionner'));
    });
  });

  group('#4077 — les zones excédentaires survivent au démarrage', () {
    test('bootstrap() n\'applique AUCUNE garde de licence', () {
      final body = _bootstrapBody();
      expect(body, contains('for (final zone in zones)'),
          reason: 'bootstrap doit instancier toutes les zones persistées');
      expect(body, isNot(contains('checkZoneLimit(')),
          reason: 'une garde de plafond au démarrage supprimerait des zones '
              'en service chez des utilisateurs gratuits (#4077)');
      expect(body, isNot(contains('.take(')),
          reason: 'tronquer la liste des zones au démarrage = les faire '
              'disparaître (#4077)');
      expect(body, isNot(contains('deleteZone(')),
          reason: 'bootstrap ne doit jamais supprimer une zone (#4077)');
      expect(body, isNot(contains('zoneRepo.delete')),
          reason: 'bootstrap ne doit jamais supprimer une zone (#4077)');
    });

    test('le témoin sait retrouver sa cible', () {
      // Contre-épreuve du témoin lui-même : s'il n'extrayait rien, les
      // `isNot(contains(...))` ci-dessus passeraient sur du vide.
      expect(_bootstrapBody().length, greaterThan(200));
      expect(_bootstrapBody(), startsWith('Future<void> bootstrap() async {'));
    });
  });
}
