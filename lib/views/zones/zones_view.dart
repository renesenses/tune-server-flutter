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
// ZonesView — onglet dédié à la gestion des zones audio.
//
// Fonctionnalités :
//   - Liste des zones avec sortie courante + indicateur zone active
//   - Sélection de la zone active (tap sur la zone)
//   - Changement de sortie : Local / Bluetooth / DLNA (picto)
//   - Création / suppression de zones
//   - Liste des renderers UPnP/DLNA découverts
// ---------------------------------------------------------------------------

class ZonesView extends StatelessWidget {
  const ZonesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.zonesTitle, style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: TuneColors.accent),
            tooltip: l.zonesNew,
            onPressed: () => _showCreateZoneDialog(context),
          ),
        ],
      ),
      body: const _ZonesBody(),
    );
  }

  void _showCreateZoneDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.zonesNew, style: TuneFonts.title3),
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
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
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
// Body
// ---------------------------------------------------------------------------

class _ZonesBody extends StatelessWidget {
  const _ZonesBody();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final zones = context.watch<ZoneState>().zones;
    final currentId = context.watch<ZoneState>().currentZoneId;
    final renderers = context.watch<ZoneState>().renderers;

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // ---- Zone active ----
        if (currentId != null) ...[
          _SectionHeader(l.zonesTitle),
          _ActiveZoneBanner(
            zone: zones.firstWhere(
              (z) => z.id == currentId,
              orElse: () => zones.first,
            ),
          ),
        ],

        // ---- Toutes les zones ----
        _SectionHeader(l.zonesTitle),
        if (zones.isEmpty)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                l.zonesNone,
                style: const TextStyle(color: TuneColors.textTertiary),
              ),
            ),
          )
        else
          Container(
            color: TuneColors.surface,
            child: Column(
              children: zones.asMap().entries.map((entry) {
                final idx = entry.key;
                final zone = entry.value;
                final isActive = zone.id == currentId;
                return Column(
                  children: [
                    if (idx > 0)
                      const Divider(
                          height: 1, indent: 56, color: TuneColors.divider),
                    _ZoneTile(zone: zone, isActive: isActive),
                  ],
                );
              }).toList(),
            ),
          ),

        // ---- Appareils UPnP/DLNA ----
        if (renderers.isNotEmpty) ...[
          _SectionHeader(l.zonesDevices),
          Container(
            color: TuneColors.surface,
            child: Column(
              children: renderers.asMap().entries.map((entry) {
                final idx = entry.key;
                final device = entry.value;
                return Column(
                  children: [
                    if (idx > 0)
                      const Divider(
                          height: 1, indent: 56, color: TuneColors.divider),
                    _DeviceTile(device: device, zones: zones),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bannière zone active
// ---------------------------------------------------------------------------

class _ActiveZoneBanner extends StatelessWidget {
  final ZoneWithState zone;
  const _ActiveZoneBanner({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: TuneColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TuneColors.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(_outputIcon(zone.outputType), color: TuneColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(zone.name,
                    style: TuneFonts.subheadline
                        .copyWith(color: TuneColors.accent)),
                Text(
                  _outputLabel(context, zone.outputType),
                  style:
                      TuneFonts.caption.copyWith(color: TuneColors.accent.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: TuneColors.accent),
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
        return Icons.speaker_phone_rounded;
    }
  }

  static String _outputLabel(BuildContext context, OutputType? type) {
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
// Tuile zone
// ---------------------------------------------------------------------------

class _ZoneTile extends StatelessWidget {
  final ZoneWithState zone;
  final bool isActive;

  const _ZoneTile({required this.zone, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Dismissible(
      key: ValueKey(zone.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        final zones = context.read<ZoneState>().zones;
        if (zones.length <= 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Impossible de supprimer la dernière zone')),
          );
          return false;
        }
        return true;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => context.read<AppState>().deleteZone(zone.id),
      child: ListTile(
        leading: Icon(
          _outputIcon(zone.outputType),
          color: isActive ? TuneColors.accent : TuneColors.textSecondary,
        ),
        title: Text(
          zone.name,
          style: TextStyle(
            color: isActive ? TuneColors.accent : TuneColors.textPrimary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          _outputLabel(context, zone.outputType),
          style: TuneFonts.caption,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.check_circle_rounded,
                    color: TuneColors.accent, size: 20),
              ),
            IconButton(
              icon: const Icon(Icons.tune_rounded,
                  color: TuneColors.textTertiary, size: 20),
              tooltip: l.zonesChangeOutput,
              onPressed: () => _showOutputPicker(context),
            ),
          ],
        ),
        onTap: () {
          context.read<AppState>().selectZone(zone.id);
          final zoneName = zone.name;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.zonesActivated(zoneName)),
              duration: const Duration(seconds: 2),
              backgroundColor: TuneColors.accent,
            ),
          );
        },
        onLongPress: () => _showZoneActions(context),
      ),
    );
  }

  void _showOutputPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      // On passe uniquement l'ID pour que la sheet lise ZoneState en direct
      builder: (ctx) => _OutputPickerSheet(zoneId: zone.id),
    );
  }

  void _showZoneActions(BuildContext context) {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.edit_rounded,
                  color: TuneColors.textSecondary),
              title: Text(l.zonesRename),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded,
                  color: TuneColors.error),
              title: Text(l.zonesDelete,
                  style: const TextStyle(color: TuneColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController(text: zone.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.zonesRename, style: TuneFonts.title3),
        content: TextField(
          controller: ctrl,
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
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) {
                context.read<AppState>().renameZone(zone.id, name);
                Navigator.pop(ctx);
              }
            },
            child: Text(l.btnEdit),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final zones = context.read<ZoneState>().zones;
    if (zones.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Impossible de supprimer la dernière zone')),
      );
      return;
    }
    context.read<AppState>().deleteZone(zone.id);
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
        return Icons.speaker_phone_rounded;
    }
  }

  static String _outputLabel(BuildContext context, OutputType? type) {
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
// Output picker — Local, Bluetooth, DLNA
// ---------------------------------------------------------------------------

class _OutputPickerSheet extends StatelessWidget {
  final int zoneId;

  const _OutputPickerSheet({required this.zoneId});

  @override
  Widget build(BuildContext context) {
    // Lit ZoneState en direct → re-render immédiat après setZoneOutput
    final zoneState = context.watch<ZoneState>();
    final zone = zoneState.zones.firstWhere(
      (z) => z.id == zoneId,
      orElse: () => zoneState.zones.first,
    );
    final renderers = zoneState.renderers;
    final l = AppLocalizations.of(context);
    final currentType = zone.outputType ?? OutputType.local;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(l.zonesOutputTitle, style: TuneFonts.title3),
                ),
                Text(zone.name,
                    style: TuneFonts.footnote
                        .copyWith(color: TuneColors.textTertiary)),
              ],
            ),
          ),
          const Divider(height: 1),

          // Local
          _OutputOption(
            icon: Icons.speaker_phone_rounded,
            label: l.zonesOutputLocal,
            subtitle: 'Haut-parleurs du téléphone',
            isSelected: currentType == OutputType.local,
            onTap: () {
              context
                  .read<AppState>()
                  .setZoneOutput(zone.id, OutputType.local);
              Navigator.pop(context);
            },
          ),
          const Divider(height: 1, indent: 56),

          // Bluetooth
          _OutputOption(
            icon: Icons.bluetooth_rounded,
            label: l.zonesOutputBluetooth,
            subtitle: 'Casque ou enceinte Bluetooth',
            isSelected: currentType == OutputType.bluetooth,
            onTap: () {
              context
                  .read<AppState>()
                  .setZoneOutput(zone.id, OutputType.bluetooth);
              Navigator.pop(context);
            },
          ),

          // DLNA renderers
          if (renderers.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l.zonesDevices.toUpperCase(),
                  style: TuneFonts.caption.copyWith(
                    color: TuneColors.textTertiary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
            ...renderers.map((device) => Column(
                  children: [
                    const Divider(height: 1, indent: 56),
                    _OutputOption(
                      icon: Icons.cast_rounded,
                      label: device.name,
                      subtitle: '${device.host}:${device.port}',
                      isSelected: currentType == OutputType.dlna &&
                          zone.outputDeviceId == device.id,
                      onTap: () {
                        context.read<AppState>().setZoneOutput(
                              zone.id,
                              OutputType.dlna,
                              deviceId: device.id,
                            );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _OutputOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _OutputOption({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? TuneColors.accent : TuneColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? TuneColors.accent : TuneColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TuneFonts.caption)
          : null,
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: TuneColors.accent)
          : null,
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// Tuile appareil DLNA
// ---------------------------------------------------------------------------

class _DeviceTile extends StatelessWidget {
  final DiscoveredDevice device;
  final List<ZoneWithState> zones;

  const _DeviceTile({required this.device, required this.zones});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.cast_rounded, color: TuneColors.textSecondary),
      title: Text(device.name),
      subtitle: Text('${device.host}:${device.port}',
          style: TuneFonts.caption),
      trailing: zones.isEmpty
          ? null
          : zones.length == 1
              ? TextButton(
                  onPressed: () {
                    context.read<AppState>().setZoneOutput(
                          zones.first.id,
                          OutputType.dlna,
                          deviceId: device.id,
                        );
                    context.read<AppState>().selectZone(zones.first.id);
                  },
                  child: Text(l.btnUse,
                      style: const TextStyle(color: TuneColors.accent)),
                )
              : PopupMenuButton<int>(
                  color: TuneColors.surfaceVariant,
                  tooltip: l.zonesAssignDevice,
                  onSelected: (zoneId) {
                    context.read<AppState>().setZoneOutput(
                          zoneId,
                          OutputType.dlna,
                          deviceId: device.id,
                        );
                  },
                  itemBuilder: (_) => zones
                      .map((z) => PopupMenuItem<int>(
                            value: z.id,
                            child: Text(z.name),
                          ))
                      .toList(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(l.zonesAssignDevice,
                        style: const TextStyle(color: TuneColors.accent)),
                  ),
                ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TuneFonts.footnote.copyWith(
          color: TuneColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
