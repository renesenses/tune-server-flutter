/// Le serveur Tune embarqué : démarrer le moteur natif derrière un service au
/// premier plan, puis attendre qu'il réponde sur `127.0.0.1`.
library;

import 'dart:async';

import 'package:http/http.dart' as http;

import 'moteur_natif.dart';

/// Le port du serveur embarqué. Celui de tout serveur Tune : la télécommande
/// d'un autre appareil le trouve là, comme un serveur de bureau.
const portServeur = 8888;

/// L'adresse à laquelle l'interface parle au moteur du téléphone.
const adresseLocale = 'http://127.0.0.1:$portServeur';

/// Le service au premier plan (Android) qui garde le processus en vie quand
/// l'écran s'éteint ou que l'application passe derrière une autre.
abstract class ServiceAvantPlan {
  /// `true` si le service tourne (ou tournait déjà).
  Future<bool> demarrer();
  Future<void> arreter();
}

/// L'issue d'un démarrage.
sealed class Demarrage {
  const Demarrage();
}

/// Le serveur répond.
class Pret extends Demarrage {
  /// Version du moteur (`1.0.0-rc3`).
  final String version;

  /// `false` si le service au premier plan n'a pas pu démarrer (notifications
  /// refusées) : le serveur tourne, mais Android pourra l'arrêter dès que
  /// l'application passera en arrière-plan.
  final bool serviceActif;
  const Pret(this.version, {required this.serviceActif});
}

/// Le serveur n'a pas démarré ; [raison] est montrée telle quelle.
class Echec extends Demarrage {
  final String raison;
  const Echec(this.raison);
}

class ServeurEmbarque {
  ServeurEmbarque({
    required this.moteur,
    required this.service,
    required this.dossierDonnees,
    required this.repertoires,
    http.Client? client,
    this.delaiMax = const Duration(seconds: 90),
    this.intervalle = const Duration(milliseconds: 300),
  }) : _client = client ?? http.Client();

  /// Fabrique du moteur, appelée au démarrage : charger la bibliothèque
  /// native peut échouer (ABI absente), et cet échec doit devenir un [Echec],
  /// pas un plantage.
  final Moteur Function() moteur;
  final ServiceAvantPlan service;

  /// Le dossier privé, inscriptible, où vivent la base et les caches.
  final Future<String> Function() dossierDonnees;

  /// Les dossiers de musique à indexer.
  final Future<List<String>> Function() repertoires;

  final http.Client _client;

  /// Le premier démarrage applique toutes les migrations de la base : sur un
  /// téléphone lent, plusieurs dizaines de secondes.
  final Duration delaiMax;
  final Duration intervalle;

  Future<Demarrage> demarrer() async {
    final Moteur m;
    try {
      m = moteur();
    } catch (e) {
      return Echec('Bibliothèque du serveur introuvable : $e');
    }
    final serviceActif = await service.demarrer();
    final rc = m.demarrer(
      port: portServeur,
      base: '${await dossierDonnees()}/tune.db',
      repertoires: await repertoires(),
    );
    // -1 : il tournait déjà (retour dans l'application, service resté vivant).
    if (rc != 0 && rc != -1) {
      return Echec('Le moteur a refusé de démarrer (code $rc).');
    }
    if (!await attendreReponse()) {
      return Echec(
        'Le serveur ne répond pas sur le port $portServeur après '
        '${delaiMax.inSeconds} s.',
      );
    }
    return Pret(m.version(), serviceActif: serviceActif);
  }

  /// Interroge `/api/v1/system/health` jusqu'à un 200, ou jusqu'à [delaiMax].
  Future<bool> attendreReponse() async {
    final fin = DateTime.now().add(delaiMax);
    final url = Uri.parse('$adresseLocale/api/v1/system/health');
    while (DateTime.now().isBefore(fin)) {
      try {
        final r = await _client.get(url).timeout(const Duration(seconds: 2));
        if (r.statusCode == 200) return true;
      } catch (_) {
        // Pas encore à l'écoute : connexion refusée, on réessaie.
      }
      await Future<void>.delayed(intervalle);
    }
    return false;
  }

  /// Demande un scan de la bibliothèque (`POST /system/scan`).
  ///
  /// Le moteur en bibliothèque ne scanne pas tout seul au démarrage (le scan
  /// de démarrage est lancé par le binaire, pas par `tune-ffi`) : sans cet
  /// appel, la musique du téléphone n'apparaissait qu'après un scan demandé à
  /// la main. Le scan est incrémental : le relancer à chaque ouverture ne
  /// relit que ce qui a changé. `false` si le serveur a refusé.
  Future<bool> lancerScan() async {
    try {
      final r = await _client
          .post(Uri.parse('$adresseLocale/api/v1/system/scan'))
          .timeout(const Duration(seconds: 10));
      return r.statusCode >= 200 && r.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<void> arreter() async {
    try {
      moteur().arreter();
    } catch (_) {}
    await service.arreter();
  }
}
