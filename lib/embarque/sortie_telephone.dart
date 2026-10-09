/// La sortie « Ce téléphone » : une zone de type `browser` que l'application
/// joue elle-même, avec just_audio.
///
/// Le moteur Rust n'a pas de sortie audio Android (`local-audio` est hors du
/// build mobile). Il a en revanche la zone `browser`, celle du client web :
/// une zone sans appareil, dont le CLIENT tire le flux (`stream_url`) et le
/// joue. L'application crée cette zone, suit son état, et joue le flux.
/// Toute l'interface (lecture, pause, file, volume) passe par le serveur,
/// comme pour n'importe quelle zone.
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'serveur_embarque.dart';

/// Le nom de la zone créée par l'application.
const nomZoneTelephone = 'Ce téléphone';

/// Ce que le serveur dit de la zone.
class EtatZone {
  const EtatZone({required this.etat, this.flux, this.volume = 1});

  /// `playing`, `paused`, `stopped`.
  final String etat;

  /// L'adresse du flux à tirer, telle que le serveur l'annonce.
  final String? flux;

  /// 0..1.
  final double volume;

  factory EtatZone.depuisJson(Map<String, dynamic> j) => EtatZone(
    etat: j['state'] as String? ?? 'stopped',
    flux: j['stream_url'] as String?,
    volume: ((j['volume'] as num?) ?? 1).toDouble().clamp(0, 1),
  );
}

/// Ce que le lecteur du téléphone doit faire pour rejoindre l'état du serveur.
sealed class Geste {
  const Geste();
}

class Charger extends Geste {
  const Charger(this.url);
  final String url;
}

class Reprendre extends Geste {
  const Reprendre();
}

class Suspendre extends Geste {
  const Suspendre();
}

class Couper extends Geste {
  const Couper();
}

class Rien extends Geste {
  const Rien();
}

/// L'adresse que le téléphone doit ouvrir pour un flux annoncé par son propre
/// serveur.
///
/// Le serveur annonce son IP de réseau (`http://192.168.1.20:8888/stream/…`),
/// qui change avec le Wi-Fi et disparaît hors réseau : pour un flux DE TUNE,
/// on passe par `127.0.0.1`. La règle est celle du client web
/// (`urlDeFluxNavigateur.ts`) : seul `/stream/<un segment>` est une adresse de
/// Tune ; toute autre URL (radio, Bandcamp) garde son domaine.
String? urlLocale(String? flux, {String base = adresseLocale}) {
  if (flux == null || flux.isEmpty) return null;
  final u = Uri.tryParse(flux);
  if (u == null) return null;
  if (!u.hasScheme) return '$base${flux.startsWith('/') ? '' : '/'}$flux';
  if (RegExp(r'^/stream/[^/]+$').hasMatch(u.path)) {
    return '$base${u.path}${u.hasQuery ? '?${u.query}' : ''}';
  }
  return flux;
}

/// Le geste qui amène le lecteur à l'état de la zone.
Geste decider(EtatZone zone, {String? urlChargee, required bool joue}) {
  final url = urlLocale(zone.flux);
  switch (zone.etat) {
    case 'playing' when url != null:
      if (url != urlChargee) return Charger(url);
      return joue ? const Rien() : const Reprendre();
    case 'paused':
      return joue ? const Suspendre() : const Rien();
    default:
      return urlChargee != null ? const Couper() : const Rien();
  }
}

/// Le lecteur audio du téléphone. Abstrait pour les essais ;
/// `LecteurJustAudio` est le vrai.
abstract class Lecteur {
  String? get url;
  bool get joue;

  /// Émet quand la piste chargée est arrivée au bout.
  Stream<void> get fini;

  Future<void> charger(String url);
  Future<void> reprendre();
  Future<void> suspendre();
  Future<void> couper();
  Future<void> volume(double v);
  Future<void> liberer();
}

class SortieTelephone {
  SortieTelephone({
    required this.lecteur,
    http.Client? client,
    this.base = adresseLocale,
    this.cadence = const Duration(seconds: 1),
  }) : _client = client ?? http.Client();

  final Lecteur lecteur;
  final String base;
  final Duration cadence;
  final http.Client _client;

  int? _zone;
  int? get zone => _zone;
  Timer? _minuterie;
  StreamSubscription<void>? _finAbonnement;
  bool _enCours = false;

  Uri _u(String chemin) => Uri.parse('$base/api/v1$chemin');

  /// La zone « Ce téléphone » : retrouvée si elle existe, créée sinon.
  Future<int?> assurerZone() async {
    try {
      final r = await _client.get(_u('/zones'));
      if (r.statusCode == 200) {
        final zones = (jsonDecode(r.body) as List).cast<Map<String, dynamic>>();
        for (final z in zones) {
          if (z['output_type'] == 'browser' &&
              (z['name'] as String? ?? '').startsWith(nomZoneTelephone)) {
            return _zone = (z['id'] as num).toInt();
          }
        }
      }
      final c = await _client.post(
        _u('/zones'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': nomZoneTelephone, 'output_type': 'browser'}),
      );
      if (c.statusCode >= 200 && c.statusCode < 300) {
        final z = jsonDecode(c.body) as Map<String, dynamic>;
        return _zone = (z['id'] as num).toInt();
      }
    } catch (_) {}
    return null;
  }

  /// Crée la zone si besoin, puis suit son état à [cadence].
  Future<void> demarrer() async {
    await assurerZone();
    _finAbonnement = lecteur.fini.listen((_) => pisteFinie());
    _minuterie = Timer.periodic(cadence, (_) => tour());
  }

  /// Un tour : lire la zone, rejoindre son état.
  Future<void> tour() async {
    if (_enCours) return;
    _enCours = true;
    try {
      final id = _zone ?? await assurerZone();
      if (id == null) return;
      final r = await _client.get(_u('/zones/$id'));
      if (r.statusCode == 404) {
        // La zone a été supprimée depuis l'interface : on la recrée au tour
        // suivant, et on se tait d'ici là.
        _zone = null;
        if (lecteur.url != null) await lecteur.couper();
        return;
      }
      if (r.statusCode != 200) return;
      final etat = EtatZone.depuisJson(
        jsonDecode(r.body) as Map<String, dynamic>,
      );
      await lecteur.volume(etat.volume);
      switch (decider(etat, urlChargee: lecteur.url, joue: lecteur.joue)) {
        case Charger(:final url):
          await lecteur.charger(url);
        case Reprendre():
          await lecteur.reprendre();
        case Suspendre():
          await lecteur.suspendre();
        case Couper():
          await lecteur.couper();
        case Rien():
          break;
      }
    } catch (_) {
      // Serveur momentanément injoignable : on réessaie au tour suivant.
    } finally {
      _enCours = false;
    }
  }

  /// La piste est jouée jusqu'au bout : comme le client web, c'est le
  /// lecteur qui demande la suivante — le serveur ne sait pas quand une zone
  /// navigateur a fini.
  Future<void> pisteFinie() async {
    final id = _zone;
    if (id == null) return;
    try {
      await _client.post(_u('/zones/$id/next'));
    } catch (_) {}
    await tour();
  }

  Future<void> arreter() async {
    _minuterie?.cancel();
    await _finAbonnement?.cancel();
    await lecteur.liberer();
  }
}
