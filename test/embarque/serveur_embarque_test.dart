import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tune_server/embarque/moteur_natif.dart';
import 'package:tune_server/embarque/serveur_embarque.dart';

class _Moteur implements Moteur {
  _Moteur(this.code);
  final int code;
  final appels = <Map<String, Object?>>[];
  int arrets = 0;

  @override
  int demarrer({
    required int port,
    required String base,
    List<String> repertoires = const [],
    String? web,
  }) {
    appels.add({'port': port, 'base': base, 'repertoires': repertoires});
    return code;
  }

  @override
  int arreter() => ++arrets;

  @override
  String version() => '1.0.0-rc3';
}

class _Service implements ServiceAvantPlan {
  _Service({this.accepte = true});
  final bool accepte;
  int demarrages = 0;
  int arrets = 0;
  @override
  Future<bool> demarrer() async {
    demarrages++;
    return accepte;
  }

  @override
  Future<void> arreter() async => arrets++;
}

ServeurEmbarque _serveur(
  Moteur Function() moteur, {
  ServiceAvantPlan? service,
  required http.Client client,
  Duration delai = const Duration(seconds: 2),
}) => ServeurEmbarque(
  moteur: moteur,
  service: service ?? _Service(),
  dossierDonnees: () async => '/data/user/0/com.mozaiklabs.tune/files',
  repertoires: () async => ['/storage/emulated/0/Music'],
  client: client,
  delaiMax: delai,
  intervalle: const Duration(milliseconds: 10),
);

void main() {
  test('démarre le service, puis le moteur, et attend la santé', () async {
    final moteur = _Moteur(0);
    final service = _Service();
    var requetes = 0;
    final client = MockClient((r) async {
      expect(r.url.toString(), '$adresseLocale/api/v1/system/health');
      // Les deux premières requêtes trouvent la porte close.
      if (++requetes < 3) throw http.ClientException('refusé');
      return http.Response('{"status":"ok"}', 200);
    });

    final d = await _serveur(
      () => moteur,
      service: service,
      client: client,
    ).demarrer();

    expect(d, isA<Pret>());
    expect((d as Pret).version, '1.0.0-rc3');
    expect(d.serviceActif, isTrue);
    expect(service.demarrages, 1);
    expect(moteur.appels.single, {
      'port': 8888,
      'base': '/data/user/0/com.mozaiklabs.tune/files/tune.db',
      'repertoires': ['/storage/emulated/0/Music'],
    });
    expect(requetes, 3);
  });

  test(
    '« tournait déjà » (-1) est un succès : retour dans l\'application',
    () async {
      final d = await _serveur(
        () => _Moteur(-1),
        client: MockClient((_) async => http.Response('ok', 200)),
      ).demarrer();
      expect(d, isA<Pret>());
    },
  );

  test('un refus du moteur (-2) est un échec nommé', () async {
    final d = await _serveur(
      () => _Moteur(-2),
      client: MockClient((_) async => http.Response('ok', 200)),
    ).demarrer();
    expect(d, isA<Echec>());
    expect((d as Echec).raison, contains('code -2'));
  });

  test(
    'une bibliothèque introuvable devient un échec, pas un plantage',
    () async {
      final d = await _serveur(
        () => throw ArgumentError('dlopen failed: libtuneserver.so'),
        client: MockClient((_) async => http.Response('ok', 200)),
      ).demarrer();
      expect(d, isA<Echec>());
      expect((d as Echec).raison, contains('dlopen failed'));
    },
  );

  test('un serveur muet échoue au bout du délai', () async {
    final d = await _serveur(
      () => _Moteur(0),
      client: MockClient((_) async => http.Response('', 503)),
      delai: const Duration(milliseconds: 100),
    ).demarrer();
    expect(d, isA<Echec>());
    expect((d as Echec).raison, contains('ne répond pas'));
  });

  test('notifications refusées : le serveur tourne, et on le sait', () async {
    final d = await _serveur(
      () => _Moteur(0),
      service: _Service(accepte: false),
      client: MockClient((_) async => http.Response('ok', 200)),
    ).demarrer();
    expect((d as Pret).serviceActif, isFalse);
  });

  test('arrêter coupe le moteur ET le service', () async {
    final moteur = _Moteur(0);
    final service = _Service();
    await _serveur(
      () => moteur,
      service: service,
      client: MockClient((_) async => http.Response('ok', 200)),
    ).arreter();
    expect(moteur.arrets, 1);
    expect(service.arrets, 1);
  });
}
