// Smoke + invariant tests for ZoneState. Captures the observable
// behaviour BEFORE the upcoming refacto (split AppState god-object,
// reorganise sub-states). After refactor these tests must keep
// passing unchanged.
//
// Run with : flutter test test/state/zone_state_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/models/domain_models.dart';
import 'package:tune_server/models/enums.dart';
import 'package:tune_server/state/zone_state.dart';

void main() {
  group('ZoneState — initial', () {
    test('starts empty', () {
      final state = ZoneState();
      expect(state.zones, isEmpty);
      expect(state.currentZoneId, isNull);
      expect(state.currentZone, isNull);
      expect(state.playbackState, PlaybackState.stopped);
      expect(state.isPlaying, isFalse);
    });
  });

  group('ZoneState — setZones', () {
    test('auto-selects first zone if none selected', () {
      final state = ZoneState();
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
      ]);
      expect(state.currentZoneId, 1);
      expect(state.currentZone?.name, 'Salon');
    });

    test('keeps selected zone if still present', () {
      final state = ZoneState();
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
      ]);
      state.setCurrentZoneId(2);
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
        ZoneWithState(id: 3, name: 'Bureau'),
      ]);
      expect(state.currentZoneId, 2);
    });
  });

  group('ZoneState — playback derived', () {
    test('isPlaying mirrors currentZone state', () {
      final state = ZoneState();
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon', state: PlaybackState.playing),
      ]);
      expect(state.isPlaying, isTrue);
      expect(state.isBuffering, isFalse);
    });

    test('positionMs falls back to 0 when no zone', () {
      final state = ZoneState();
      expect(state.positionMs, 0);
    });
  });

  group('ZoneState — updateZone', () {
    test('replaces matching zone in place', () {
      final state = ZoneState();
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
      ]);
      state.updateZone(const ZoneWithState(
        id: 2,
        name: 'Cuisine renommée',
        state: PlaybackState.playing,
      ));
      expect(state.zones[1].name, 'Cuisine renommée');
      expect(state.zones[1].state, PlaybackState.playing);
    });

    test('ignores unknown zone id', () {
      final state = ZoneState();
      state.setZones(const [ZoneWithState(id: 1, name: 'Salon')]);
      state.updateZone(const ZoneWithState(id: 99, name: 'Nope'));
      expect(state.zones.length, 1);
      expect(state.zones[0].name, 'Salon');
    });
  });

  group('ZoneState — reset', () {
    test('clears everything', () {
      final state = ZoneState();
      state.setZones(const [ZoneWithState(id: 1, name: 'Salon')]);
      state.setCurrentZoneId(1);
      state.reset();
      expect(state.zones, isEmpty);
      expect(state.currentZoneId, isNull);
    });
  });

  group('ZoneState — dernière zone utilisée (#1952)', () {
    test('restaure la zone préférée quand elle existe encore', () {
      final state = ZoneState()..preferredZoneId = 2;
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
      ]);
      expect(state.currentZoneId, 2,
          reason: 'sans ça on retombe sur zones.first et la préférence ne sert à rien');
    });

    /// Le piège du ticket : les identifiants de zone ne sont PAS stables entre
    /// le mode local et le mode distant. Restaurer un id absent donnerait une
    /// zone fantôme — un état pire que l'heuristique qu'on remplace.
    test('ignore une zone préférée absente de la liste du serveur', () {
      final state = ZoneState()..preferredZoneId = 42;
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
      ]);
      expect(state.currentZoneId, 1, reason: 'repli sur la première zone');
    });

    test('sans préférence, garde le comportement d\'origine', () {
      final state = ZoneState();
      state.setZones(const [
        ZoneWithState(id: 7, name: 'Salon'),
        ZoneWithState(id: 8, name: 'Cuisine'),
      ]);
      expect(state.currentZoneId, 7);
    });

    test('un changement de zone est signalé une fois, et une seule', () {
      final vus = <int>[];
      final state = ZoneState()..onZoneChosen = vus.add;
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
      ]);
      state.setCurrentZoneId(2);
      state.setCurrentZoneId(2); // re-sélectionner la même : rien à mémoriser
      state.setCurrentZoneId(1);
      expect(vus, [2, 1]);
    });

    test('la restauration au démarrage ne réécrit pas la préférence', () {
      final vus = <int>[];
      final state = ZoneState()
        ..preferredZoneId = 2
        ..onZoneChosen = vus.add;
      state.setZones(const [
        ZoneWithState(id: 1, name: 'Salon'),
        ZoneWithState(id: 2, name: 'Cuisine'),
      ]);
      expect(state.currentZoneId, 2);
      expect(vus, isEmpty,
          reason: 'setZones ne passe pas par setCurrentZoneId : rien à réécrire');
    });
  });
}
