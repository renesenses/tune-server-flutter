import '../../models/domain_models.dart';
import '../../models/enums.dart';
import '../database/database.dart';
import '../outputs/output_target.dart';
import '../playback/play_queue.dart';
import '../playback/player.dart';

// ---------------------------------------------------------------------------
// T5.3 — ZoneInstance
// Lie un Player + une PlayQueue à une Zone persistée en DB.
// Produit des ZoneWithState (snapshot) pour l'UI et l'AppState.
// Miroir de ZoneInstance.swift (iOS)
// ---------------------------------------------------------------------------

class ZoneInstance {
  /// Données persistées (drift Zone data class)
  final Zone zone;

  final PlayQueue queue;
  late final Player player;

  ZoneInstance({required this.zone})
      : queue = PlayQueue() {
    player = Player(zoneId: zone.id.toString(), queue: queue);
  }

  // ---------------------------------------------------------------------------
  // Délégués pratiques
  // ---------------------------------------------------------------------------

  String get id => zone.id.toString();
  String get name => zone.name;

  PlaybackState get playbackState => player.state;
  Track? get currentTrack => queue.currentTrack;
  Duration get position => player.position;
  bool get isPlaying => player.isPlaying;

  OutputTarget? get output => player.output;

  // ---------------------------------------------------------------------------
  // Output
  // ---------------------------------------------------------------------------

  Future<void> setOutput(OutputTarget output) => player.setOutput(output);

  // ---------------------------------------------------------------------------
  // Snapshot — vue unifiée pour l'UI
  // ---------------------------------------------------------------------------

  ZoneWithState snapshot() => ZoneWithState(
        id: zone.id,
        name: zone.name,
        outputType: zone.outputType != null
            ? OutputType.fromRawValue(zone.outputType!)
            : null,
        outputDeviceId: zone.outputDeviceId,
        volume: zone.volume,
        groupId: zone.groupId,
        syncDelayMs: zone.syncDelayMs,
        state: player.state,
        currentTrack: queue.currentTrack,
        positionMs: player.position.inMilliseconds,
        queueLength: queue.length,
      );

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  Future<void> dispose() => player.dispose();
}
