import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../models/enums.dart';
import '../../server/discovery/discovery_manager.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T11.5 — ZoneManagementView
// Sélection de la zone active, liste des zones existantes,
// devices UPnP/DLNA découverts pour créer une nouvelle zone.
// AppState.createZone / deleteZone / setZoneOutput / selectZone
// Miroir de ZoneManagementView.swift (iOS)
// ---------------------------------------------------------------------------

class ZoneManagementView extends StatelessWidget {
  const ZoneManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: TuneColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text(AppLocalizations.of(context).zonesTitle, style: TuneFonts.title3),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text(AppLocalizations.of(context).zonesNew),
                style: TextButton.styleFrom(
                    foregroundColor: TuneColors.accent),
                onPressed: () => _showCreateZoneDialog(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(child: _ZoneList()),
        // Devices découverts
        _DiscoveredDevicesSection(),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showCreateZoneDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.zonesNew),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: TuneColors.textPrimary),
          decoration: InputDecoration(
            hintText: l.zonesNewName,
            hintStyle: const TextStyle(color: TuneColors.textTertiary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.btnCancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<AppState>().createZone(name);
                Navigator.pop(ctx);
              }
            },
            child: Text(l.btnCreate),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Liste des zones
// ---------------------------------------------------------------------------

class _ZoneList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZoneState>().zones;
    final currentId = context.watch<ZoneState>().currentZoneId;

    if (zones.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(AppLocalizations.of(context).zonesNone,
            style: const TextStyle(color: TuneColors.textTertiary)),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: zones.length,
      itemBuilder: (_, i) {
        final zone = zones[i];
        final isActive = zone.id == currentId;
        return ListTile(
          leading: Icon(
            _outputIcon(zone.outputType),
            color: isActive ? TuneColors.accent : TuneColors.textSecondary,
          ),
          title: Text(
            zone.name,
            style: TextStyle(
              color:
                  isActive ? TuneColors.accent : TuneColors.textPrimary,
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            _outputLabel(context, zone.outputType),
            style: TuneFonts.caption,
          ),
          trailing: isActive
              ? const Icon(Icons.check_circle_rounded,
                  color: TuneColors.accent)
              : null,
          onTap: () {
            context.read<AppState>().selectZone(zone.id);
            Navigator.pop(context);
          },
          onLongPress: () => _showZoneOptions(context, zone),
        );
      },
    );
  }

  void _showZoneOptions(BuildContext context, ZoneWithState zone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_rounded,
                color: TuneColors.error),
            title: Text(AppLocalizations.of(context).zonesDelete,
                style: const TextStyle(color: TuneColors.error)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              context.read<AppState>().deleteZone(zone.id);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static IconData _outputIcon(OutputType? type) {
    switch (type) {
      case OutputType.dlna:
        return Icons.cast_rounded;
      case OutputType.airplay:
        return Icons.airplay_rounded;
      case OutputType.bluetooth:
        return Icons.bluetooth_rounded;
      default:
        return Icons.speaker_rounded;
    }
  }

  String _outputLabel(BuildContext context, OutputType? type) {
    final l = AppLocalizations.of(context);
    switch (type) {
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

// ---------------------------------------------------------------------------
// Devices découverts (renderers)
// ---------------------------------------------------------------------------

class _DiscoveredDevicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final renderers = context.watch<ZoneState>().renderers;

    if (renderers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(AppLocalizations.of(context).zonesDevices,
              style: TuneFonts.subheadline),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: renderers.length,
          itemBuilder: (_, i) {
            final device = renderers[i];
            return ListTile(
              leading: const Icon(Icons.cast_rounded,
                  color: TuneColors.textSecondary),
              title: Text(device.name),
              subtitle: Text('${device.host}:${device.port}',
                  style: TuneFonts.caption),
              trailing: TextButton(
                onPressed: () =>
                    _assignDeviceToCurrentZone(context, device),
                child: Text(AppLocalizations.of(context).btnUse,
                    style: const TextStyle(color: TuneColors.accent)),
              ),
            );
          },
        ),
      ],
    );
  }

  void _assignDeviceToCurrentZone(
      BuildContext context, DiscoveredDevice device) {
    final app = context.read<AppState>();
    final currentId = context.read<ZoneState>().currentZoneId;
    if (currentId == null) return;
    app.setZoneOutput(currentId, OutputType.dlna,
        deviceId: device.id);
    Navigator.pop(context);
  }
}
