import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/enums.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// ZoneManagementView — sheet "Diffuser sur…" depuis NowPlayingView.
//
// Affiche toutes les zones avec distinction visuelle :
//   • Zone où la lecture se passe actuellement  → mise en avant accent, badge
//     "En cours ici", non tappable (déjà là).
//   • Autres zones → tap pour basculer la lecture (queue + position).
// ---------------------------------------------------------------------------

class ZoneManagementView extends StatelessWidget {
  const ZoneManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final zoneState = context.watch<ZoneState>();
    final zones = zoneState.zones;

    // Zone où l'audio est effectivement en cours.
    // On utilise currentZoneId + playbackState (même source que _TransportControls)
    // plutôt que de scanner les états des snapshots, qui peuvent être obsolètes.
    final isActive = zoneState.isPlaying || zoneState.isBuffering;
    final playingZoneId = isActive ? zoneState.currentZoneId : null;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Titre
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l.zonesTransferTitle, style: TuneFonts.title3),
            ),
          ),
          const Divider(height: 1),

          if (zones.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(l.zonesNone,
                  style: const TextStyle(color: TuneColors.textTertiary)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: zones.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (_, i) {
                final zone = zones[i];
                final isHere = zone.id == playingZoneId;
                return _ZoneRow(
                  zone: zone,
                  isHere: isHere,
                  onTransfer: isHere
                      ? null
                      : () {
                          context.read<AppState>().selectZone(zone.id);
                          Navigator.pop(context);
                        },
                );
              },
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tuile zone
// ---------------------------------------------------------------------------

class _ZoneRow extends StatelessWidget {
  final dynamic zone; // ZoneWithState
  final bool isHere;
  final VoidCallback? onTransfer;

  const _ZoneRow({
    required this.zone,
    required this.isHere,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (isHere) {
      // ---- Zone où ça joue actuellement ----
      return Container(
        color: TuneColors.accent.withValues(alpha: 0.08),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TuneColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.volume_up_rounded,
                color: TuneColors.accent, size: 22),
          ),
          title: Text(
            zone.name,
            style: const TextStyle(
              color: TuneColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            _outputLabel(context, zone.outputType),
            style: TuneFonts.caption.copyWith(
              color: TuneColors.accent.withValues(alpha: 0.8),
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: TuneColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l.zonesNowPlaying,
              style: TuneFonts.caption.copyWith(
                color: TuneColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    // ---- Zone cible (tap pour basculer) ----
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: TuneColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          _outputIcon(zone.outputType),
          color: TuneColors.textSecondary,
          size: 20,
        ),
      ),
      title: Text(zone.name, style: TuneFonts.body),
      subtitle: Text(
        _outputLabel(context, zone.outputType),
        style: TuneFonts.caption,
      ),
      trailing: const Icon(Icons.cast_rounded,
          color: TuneColors.textTertiary, size: 20),
      onTap: onTransfer,
    );
  }

  static IconData _outputIcon(dynamic type) {
    switch (type as OutputType?) {
      case OutputType.dlna:
        return Icons.cast_rounded;
      case OutputType.airplay:
        return Icons.airplay_rounded;
      case OutputType.bluetooth:
        return Icons.bluetooth_rounded;
      default:
        return Icons.phone_android_rounded;
    }
  }

  static String _outputLabel(BuildContext context, dynamic type) {
    final l = AppLocalizations.of(context);
    switch (type as OutputType?) {
      case OutputType.dlna:
        return l.zonesOutputDlna;
      case OutputType.airplay:
        return l.zonesOutputAirplay;
      case OutputType.bluetooth:
        return l.zonesOutputBluetooth;
      default:
        return l.zonesOutputLocal;
    }
  }
}
