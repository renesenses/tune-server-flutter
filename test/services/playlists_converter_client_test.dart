// Liens de synchronisation et copies datées : le client parle au greffon
// « Playlists converter », plus aux routes doublons `/playlist-manager/links*`
// et `/playlist-manager/backup(s)*`. Un refus Premium (402) arrive typé, avec
// son code et son adresse d'offre, et l'écran choisit la bonne explication.
//
// flutter test test/services/playlists_converter_client_test.dart

import 'dart:convert';

import 'dart:io';
import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tune_server/l10n/app_localizations.dart';
import 'package:tune_server/services/tune_api_client.dart';
import 'package:tune_server/views/playlists/refus_playlists.dart';

const _base = 'http://test.local/api/v1';
const _greffon = '/api/v1/plugins/playlists-converter';

/// Un client simulé qui note chaque requête et répond selon `repondre`.
(TuneApiClient, List<http.Request>) _client(
  http.Response Function(http.Request) repondre,
) {
  final vues = <http.Request>[];
  final mock = MockClient((req) async {
    vues.add(req);
    return repondre(req);
  });
  return (TuneApiClient.withClient(_base, mock), vues);
}

http.Response _json(Object corps, [int statut = 200]) =>
    http.Response(jsonEncode(corps), statut,
        headers: {'content-type': 'application/json; charset=utf-8'});

void _aucuneRouteDoublon(List<http.Request> vues) {
  for (final r in vues) {
    expect(r.url.path, isNot(contains('/playlist-manager/links')),
        reason: '${r.method} ${r.url.path} vise encore une route doublon');
    expect(r.url.path, isNot(contains('/playlist-manager/backup')),
        reason: '${r.method} ${r.url.path} vise encore une route doublon');
  }
}

void main() {
  group('Liens : routes du greffon', () {
    test('la liste vient de GET /liens', () async {
      final (api, vues) = _client((_) => _json({
            'count': 1,
            'liens': [
              {'lien_id': 'lien-1', 'sens': 'a_vers_b'}
            ]
          }));
      final liens = await api.getPlaylistLinks();
      expect(vues.single.method, 'GET');
      expect(vues.single.url.path, '$_greffon/liens');
      expect(liens.single['lien_id'], 'lien-1');
      _aucuneRouteDoublon(vues);
    });

    test('synchroniser = aperçu puis synchro avec accord', () async {
      final (api, vues) = _client((req) => req.url.path.endsWith('/lien/apercu')
          ? _json({'plan': {'ajouts': []}})
          : _json({'lien': {}, 'entree': {'ajoutees': 3}}));
      final r = await api.syncPlaylistLink('lien-7');
      expect(vues.map((v) => '${v.method} ${v.url.path}').toList(), [
        'POST $_greffon/lien/apercu',
        'POST $_greffon/lien/synchroniser',
      ]);
      expect(jsonDecode(vues[0].body), {'lien_id': 'lien-7'});
      expect(jsonDecode(vues[1].body), {'lien_id': 'lien-7', 'accord': true});
      expect((r['entree'] as Map)['ajoutees'], 3);
      _aucuneRouteDoublon(vues);
    });

    test('supprimer et régler la cadence passent par le greffon', () async {
      final (api, vues) = _client((_) => _json({'lien': {}}));
      await api.deletePlaylistLink('lien-2');
      await api.setPlaylistLinkInterval('lien-2', 5);
      expect(vues[0].url.path, '$_greffon/lien/supprimer');
      expect(jsonDecode(vues[0].body), {'lien_id': 'lien-2'});
      expect(vues[1].url.path, '$_greffon/lien/reglages');
      // 5 min est hors bornes pour le greffon (15…10 080) : ramené à 15.
      expect(jsonDecode(vues[1].body), {'lien_id': 'lien-2', 'cadence_minutes': 15});
      expect(vues.every((v) => v.method == 'POST'), isTrue);
      _aucuneRouteDoublon(vues);
    });

    test('créer un lien vise POST /liens', () async {
      final (api, vues) = _client((_) => _json({'lien': {}}, 201));
      await api.createPlaylistLink(
          localPlaylistId: 12, service: 'qobuz', servicePlaylistId: 'q-9');
      expect(vues.single.url.path, '$_greffon/liens');
      _aucuneRouteDoublon(vues);
    });
  });

  group('Liens : correspondance des sens', () {
    const local = {'service': 'local', 'playlist_id': '12'};
    const distant = {'service': 'tidal', 'playlist_id': 't-1'};
    Map<String, dynamic> corps(String sens) => TuneApiClient.corpsDuLien(
        localPlaylistId: 12,
        service: 'tidal',
        servicePlaylistId: 't-1',
        syncDirection: sens,
        syncIntervalMinutes: 60);

    test('pull : le service alimente la bibliothèque', () {
      expect(corps('pull'),
          {'a': distant, 'b': local, 'sens': 'a_vers_b', 'cadence_minutes': 60});
    });
    test('push : la bibliothèque alimente le service', () {
      expect(corps('push'),
          {'a': local, 'b': distant, 'sens': 'a_vers_b', 'cadence_minutes': 60});
    });
    test('bidirectional : deux sens', () {
      expect(corps('bidirectional'),
          {'a': distant, 'b': local, 'sens': 'deux_sens', 'cadence_minutes': 60});
    });
    test('bornes de cadence', () {
      expect(TuneApiClient.cadenceDuLien(0), 0);
      expect(TuneApiClient.cadenceDuLien(-3), 0);
      expect(TuneApiClient.cadenceDuLien(1), 15);
      expect(TuneApiClient.cadenceDuLien(15), 15);
      expect(TuneApiClient.cadenceDuLien(90), 90);
      expect(TuneApiClient.cadenceDuLien(99999), 10080);
    });
  });

  group('Copies datées : routes du greffon', () {
    test('la liste vient de GET /snapshots', () async {
      final (api, vues) = _client((_) => _json({
            'count': 1,
            'playlists': [
              {'service': 'local', 'playlist_id': '4', 'nom': 'Jazz', 'snapshots': 2}
            ],
            'retention_par_playlist': 10,
          }));
      final l = await api.listPlaylistSnapshots();
      expect(vues.single.url.path, '$_greffon/snapshots');
      expect(l.single['nom'], 'Jazz');
      _aucuneRouteDoublon(vues);
    });

    test('sauvegarder une playlist = POST /snapshot', () async {
      final (api, vues) = _client((_) => _json({'snapshot': {'snapshot_id': 'snap-1-1'}}));
      await api.snapshotPlaylist(service: 'qobuz', playlistId: 'q-1', name: 'Rock');
      expect(vues.single.url.path, '$_greffon/snapshot');
      expect(jsonDecode(vues.single.body),
          {'service': 'qobuz', 'playlist_id': 'q-1', 'nom': 'Rock'});
      _aucuneRouteDoublon(vues);
    });

    test('restaurer = copie la plus récente, aperçu « recreer », puis accord', () async {
      final (api, vues) = _client((req) {
        final p = req.url.path;
        if (p.endsWith('/snapshots')) {
          return _json({
            'count': 2,
            'snapshots': [
              {'snapshot_id': 'snap-3-2'},
              {'snapshot_id': 'snap-3-1'},
            ],
          });
        }
        if (p.endsWith('/restauration/apercu')) {
          return _json({'plan': {'plan_id': 'plan-5'}, 'a_rajouter': [], 'a_retirer_par_vous': []});
        }
        return _json({'plan': {'plan_id': 'plan-5'}, 'a_retirer_par_vous': []});
      });
      await api.restoreLatestSnapshot(service: 'tidal', playlistId: 't 1');
      expect(vues.map((v) => '${v.method} ${v.url.path}').toList(), [
        'GET $_greffon/snapshots',
        'POST $_greffon/snapshot/restauration/apercu',
        'POST $_greffon/snapshot/restauration',
      ]);
      expect(vues[0].url.queryParameters, {'service': 'tidal', 'playlist_id': 't 1'});
      expect(jsonDecode(vues[1].body), {'snapshot_id': 'snap-3-2', 'mode': 'recreer'});
      expect(jsonDecode(vues[2].body), {'plan_id': 'plan-5', 'accord': true});
      _aucuneRouteDoublon(vues);
    });
  });

  group('Refus Premium et greffon absent', () {
    test('402 du greffon : exception typée avec code et adresse d’offre', () async {
      final (api, _) = _client((_) => _json({
            'error': 'premium_required',
            'code': 'plugin_marketplace',
            'message': 'Plugin Marketplace requires Tune Premium',
            'upgrade_url': 'https://example.test/premium',
          }, 402));
      Object? erreur;
      try {
        await api.getPlaylistLinks();
      } catch (e) {
        erreur = e;
      }
      expect(erreur, isA<TunePremiumRequiredException>());
      final p = erreur as TunePremiumRequiredException;
      expect(p.statusCode, 402);
      expect(p.code, 'plugin_marketplace');
      expect(p.upgradeUrlSure, 'https://example.test/premium');
      expect(classerRefus(p), RefusPlaylist.greffonPremium);
    });

    test('402 du transfert : explication du transfert', () async {
      final (api, _) = _client((_) => _json({
            'error': 'premium_required',
            'code': 'playlist_transfer',
            'upgrade_url': 'https://example.test/premium',
          }, 402));
      Object? erreur;
      try {
        await api.transferPlaylist(sourceService: 'qobuz', sourcePlaylistId: 'q-1');
      } catch (e) {
        erreur = e;
      }
      expect(classerRefus(erreur!), RefusPlaylist.transfertPremium);
    });

    test('une adresse d’offre qui n’est pas un lien web n’est jamais gardée', () {
      const p = TunePremiumRequiredException('x', upgradeUrl: 'javascript:alert(1)');
      expect(p.upgradeUrlSure, isNull);
      const q = TunePremiumRequiredException('x', upgradeUrl: 'tune://premium');
      expect(q.upgradeUrlSure, isNull);
      const r = TunePremiumRequiredException('x', upgradeUrl: 'http://example.test/p');
      expect(r.upgradeUrlSure, 'http://example.test/p');
    });

    test('404 « plugin not found » : greffon absent', () async {
      final (api, _) = _client(
          (_) => _json({'error': 'plugin not found', 'id': 'playlists-converter'}, 404));
      Object? erreur;
      try {
        await api.listPlaylistSnapshots();
      } catch (e) {
        erreur = e;
      }
      expect(classerRefus(erreur!), RefusPlaylist.greffonAbsent);
    });

    test('une autre panne reste générique', () async {
      final (api, _) = _client((_) => http.Response('boom', 500));
      Object? erreur;
      try {
        await api.getPlaylistLinks();
      } catch (e) {
        erreur = e;
      }
      expect(erreur, isA<TuneHttpException>());
      expect(classerRefus(erreur!), RefusPlaylist.autre);
    });
  });

  group('L’explication montrée', () {
    final fr = lookupAppLocalizations(const Locale('fr'));
    test('chaque refus a sa phrase', () {
      expect(expliquerRefus(const TunePremiumRequiredException('x', code: 'playlist_transfer'), fr),
          contains('Dupliquer une playlist de la bibliothèque reste gratuit'));
      expect(expliquerRefus(const TunePremiumRequiredException('x', code: 'plugin_marketplace'), fr),
          contains('liens de synchronisation'));
      expect(expliquerRefus(const TuneHttpException('x', 404, error: 'wasm plugins not loaded'), fr),
          contains('Playlists converter'));
    });

    test('les écrans de transfert, de liens et de copies passent par l’explication', () {
      final gestion = File('lib/views/playlists/playlist_manager_view.dart').readAsStringSync();
      final liste = File('lib/views/library/playlists_view.dart').readAsStringSync();
      expect(RegExp(r'montrerRefus\(').allMatches(gestion).length, greaterThanOrEqualTo(4),
          reason: 'transfert, synchro, suppression de lien, cadence');
      expect(gestion, contains('expliquerRefus('));
      expect(RegExp(r'montrerRefus\(').allMatches(liste).length, 2,
          reason: 'transfert vers la bibliothèque et menu de playlist locale');
      expect(gestion, isNot(contains('batchTransfer')));
    });
  });
}
