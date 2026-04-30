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
}
