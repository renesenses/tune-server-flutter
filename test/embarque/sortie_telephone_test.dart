import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tune_server/embarque/serveur_embarque.dart';
import 'package:tune_server/embarque/sortie_telephone.dart';

class _Lecteur implements Lecteur {
  @override
  String? url;
  @override
  bool joue = false;
  double vol = 1;
  final journal = <String>[];
  final _fin = StreamController<void>.broadcast();
  void finir() => _fin.add(null);

  @override
  Stream<void> get fini => _fin.stream;
  @override
  Future<void> charger(String u) async {
    journal.add('charger $u');
    url = u;
    joue = true;
  }

  @override
  Future<void> reprendre() async {
    journal.add('reprendre');
    joue = true;
  }

  @override
  Future<void> suspendre() async {
    journal.add('suspendre');
    joue = false;
  }

  @override
  Future<void> couper() async {
    journal.add('couper');
    url = null;
    joue = false;
  }

  @override
  Future<void> volume(double v) async => vol = v;
  @override
  Future<void> liberer() async => journal.add('libérer');
}

const _flux = 'http://192.168.1.20:8888/stream/abc-123.flac';
const _local = '$adresseLocale/stream/abc-123.flac';

void main() {
  group('urlLocale', () {
    test('un flux de Tune passe par 127.0.0.1', () {
      expect(urlLocale(_flux), _local);
      expect(urlLocale('/stream/s-2'), '$adresseLocale/stream/s-2');
      expect(
        urlLocale('http://10.0.2.16:8888/stream/x.mp3?t=1'),
        '$adresseLocale/stream/x.mp3?t=1',
      );
    });

    test("une URL tierce garde son domaine", () {
      const bandcamp = 'https://t4.bcbits.com/stream/abc/mp3-128/42';
      expect(urlLocale(bandcamp), bandcamp);
      const radio = 'https://icecast.radiofrance.fr/fip-hifi.aac';
      expect(urlLocale(radio), radio);
    });

    test('rien à jouer', () {
      expect(urlLocale(null), isNull);
      expect(urlLocale(''), isNull);
    });
  });

  group('decider', () {
    const joue = EtatZone(etat: 'playing', flux: _flux);
    test('lecture d\'une nouvelle piste : charger', () {
      final g = decider(joue, urlChargee: null, joue: false);
      expect((g as Charger).url, _local);
    });
    test('même piste déjà en lecture : rien', () {
      expect(decider(joue, urlChargee: _local, joue: true), isA<Rien>());
    });
    test('même piste en pause côté téléphone : reprendre', () {
      expect(decider(joue, urlChargee: _local, joue: false), isA<Reprendre>());
    });
    test('pause demandée : suspendre', () {
      const p = EtatZone(etat: 'paused', flux: _flux);
      expect(decider(p, urlChargee: _local, joue: true), isA<Suspendre>());
      expect(decider(p, urlChargee: _local, joue: false), isA<Rien>());
    });
    test('arrêt : couper, une seule fois', () {
      const s = EtatZone(etat: 'stopped');
      expect(decider(s, urlChargee: _local, joue: true), isA<Couper>());
      expect(decider(s, urlChargee: null, joue: false), isA<Rien>());
    });
  });

  group('SortieTelephone', () {
    late _Lecteur lecteur;
    late Map<String, dynamic> zone;
    late List<String> requetes;
    late bool zoneExiste;

    MockClient serveur() => MockClient((r) async {
      requetes.add('${r.method} ${r.url.path}');
      if (r.url.path == '/api/v1/zones' && r.method == 'GET') {
        return http.Response(
          jsonEncode([
            {'id': 3, 'name': 'Salon', 'output_type': 'dlna'},
            if (zoneExiste)
              {'id': 9, 'name': nomZoneTelephone, 'output_type': 'browser'},
          ]),
          200,
        );
      }
      if (r.url.path == '/api/v1/zones' && r.method == 'POST') {
        final corps = jsonDecode(r.body) as Map<String, dynamic>;
        expect(corps, {'name': nomZoneTelephone, 'output_type': 'browser'});
        zoneExiste = true;
        return http.Response(jsonEncode({'id': 9, ...corps}), 200);
      }
      if (r.url.path == '/api/v1/zones/9' && r.method == 'GET') {
        return zoneExiste
            ? http.Response(jsonEncode(zone), 200)
            : http.Response('{}', 404);
      }
      if (r.url.path == '/api/v1/zones/9/next') {
        return http.Response('{"status":"playing"}', 200);
      }
      return http.Response('', 404);
    });

    setUp(() {
      lecteur = _Lecteur();
      requetes = [];
      zoneExiste = false;
      zone = {'id': 9, 'state': 'stopped', 'volume': 0.5};
    });

    test(
      'crée la zone « Ce téléphone » si elle manque, puis la retrouve',
      () async {
        final s = SortieTelephone(lecteur: lecteur, client: serveur());
        expect(await s.assurerZone(), 9);
        expect(requetes, ['GET /api/v1/zones', 'POST /api/v1/zones']);

        requetes.clear();
        expect(await s.assurerZone(), 9);
        expect(requetes, ['GET /api/v1/zones'], reason: 'pas de doublon');
      },
    );

    test('suit lecture, pause, reprise, arrêt et volume du serveur', () async {
      zoneExiste = true;
      final s = SortieTelephone(lecteur: lecteur, client: serveur());

      zone = {'id': 9, 'state': 'playing', 'stream_url': _flux, 'volume': 0.3};
      await s.tour();
      expect(lecteur.journal, ['charger $_local']);
      expect(lecteur.vol, 0.3);

      await s.tour();
      expect(lecteur.journal, ['charger $_local'], reason: 'rien à refaire');

      zone = {...zone, 'state': 'paused'};
      await s.tour();
      zone = {...zone, 'state': 'playing'};
      await s.tour();
      zone = {'id': 9, 'state': 'stopped', 'volume': 0.3};
      await s.tour();
      expect(lecteur.journal, [
        'charger $_local',
        'suspendre',
        'reprendre',
        'couper',
      ]);
    });

    test(
      'fin de piste : le téléphone demande la suivante au serveur',
      () async {
        zoneExiste = true;
        final s = SortieTelephone(
          lecteur: lecteur,
          client: serveur(),
          cadence: const Duration(hours: 1),
        );
        await s.demarrer();
        requetes.clear();

        zone = {
          'id': 9,
          'state': 'playing',
          'stream_url': 'http://10.0.2.16:8888/stream/suivante.flac',
          'volume': 1,
        };
        lecteur.finir();
        await pumpEventQueue();

        expect(requetes.first, 'POST /api/v1/zones/9/next');
        expect(lecteur.url, '$adresseLocale/stream/suivante.flac');
        await s.arreter();
        expect(lecteur.journal.last, 'libérer');
      },
    );

    test(
      'zone supprimée depuis l\'interface : on coupe, puis on la recrée',
      () async {
        zoneExiste = true;
        final s = SortieTelephone(lecteur: lecteur, client: serveur());
        zone = {'id': 9, 'state': 'playing', 'stream_url': _flux, 'volume': 1};
        await s.tour();
        expect(lecteur.url, isNotNull);

        zoneExiste = false;
        await s.tour();
        expect(lecteur.journal.last, 'couper');
        expect(s.zone, isNull);

        await s.tour();
        expect(requetes, contains('POST /api/v1/zones'));
        expect(s.zone, 9);
      },
    );

    test('serveur injoignable : aucun plantage', () async {
      final s = SortieTelephone(
        lecteur: lecteur,
        client: MockClient((_) async => throw http.ClientException('refusé')),
      );
      await s.tour();
      expect(lecteur.journal, isEmpty);
    });
  });
}
