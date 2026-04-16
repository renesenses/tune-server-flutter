import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../models/enums.dart';
import '../../server/discovery/discovery_manager.dart';
import '../../services/bluetooth_service.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'zone_manager_view.dart';

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
          if (context.read<AppState>().apiClient != null)
            IconButton(
              icon: const Icon(Icons.dashboard_customize_rounded,
                  color: TuneColors.accent),
              tooltip: 'Zone Manager',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ZoneManagerView()),
              ),
            ),
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
    final zoneState = context.watch<ZoneState>();
    final zones = zoneState.zones;
    final currentId = zoneState.currentZoneId;
    final renderers = zoneState.unboundRenderers;
    final groups = zoneState.groups;

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

        // ---- Multi-Room ----
        _SectionHeader(l.zonesMultiRoom),
        if (groups.isEmpty)
          Container(
            color: TuneColors.surface,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                l.zonesGroupNoZones,
                style: const TextStyle(color: TuneColors.textTertiary),
              ),
            ),
          )
        else
          Container(
            color: TuneColors.surface,
            child: Column(
              children: groups.asMap().entries.map((entry) {
                final idx = entry.key;
                final group = entry.value;
                return Column(
                  children: [
                    if (idx > 0)
                      const Divider(
                          height: 1, indent: 56, color: TuneColors.divider),
                    _GroupTile(group: group, zones: zones),
                  ],
                );
              }).toList(),
            ),
          ),
        if (zones.length >= 2)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                minimumSize: const Size.fromHeight(44),
              ),
              icon: const Icon(Icons.group_add_rounded, size: 20),
              label: Text(l.zonesCreateGroup),
              onPressed: () => _showCreateGroupDialog(context),
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

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const _CreateGroupDialog(),
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
        leading: _buildLeadingIcon(context),
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

  Widget _buildLeadingIcon(BuildContext context) {
    final group = context.read<ZoneState>().groupForZone(zone.id);
    final baseColor = isActive ? TuneColors.accent : TuneColors.textSecondary;
    final icon = Icon(_outputIcon(zone.outputType), color: baseColor);

    if (group == null) return icon;

    final isLeader = group.leaderId == zone.id;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          right: -4,
          bottom: -4,
          child: Icon(
            isLeader ? Icons.star_rounded : Icons.link_rounded,
            size: 14,
            color: TuneColors.accent,
          ),
        ),
      ],
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
    final renderers = zoneState.unboundRenderers;
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

          // Bluetooth — on Android we list connected BT outputs via
          // AudioManager.getDevices. On iOS/macOS the system picks the
          // active device (Centre de contrôle).
          _OutputOption(
            icon: Icons.bluetooth_rounded,
            label: l.zonesOutputBluetooth,
            subtitle: Platform.isAndroid
                ? 'Sorties Bluetooth connectées'
                : 'Utilise la sortie système (Centre de contrôle)',
            isSelected: currentType == OutputType.bluetooth,
            onTap: () async {
              if (Platform.isAndroid) {
                await _showBluetoothDevicesSheet(context, zone);
              } else {
                context
                    .read<AppState>()
                    .setZoneOutput(zone.id, OutputType.bluetooth);
                Navigator.pop(context);
              }
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

  Future<void> _showBluetoothDevicesSheet(BuildContext context, ZoneWithState zone) async {
    final svc = BluetoothService();
    final devices = await svc.listDevices();
    if (!context.mounted) return;
    Navigator.pop(context); // close the output picker
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: TuneColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sorties Bluetooth', style: TuneFonts.title3),
                const SizedBox(height: 12),
                if (devices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Aucun périphérique Bluetooth connecté. Jumelle un appareil dans les paramètres système.',
                      style: TuneFonts.footnote,
                    ),
                  )
                else
                  ...devices.map((d) => ListTile(
                        leading: const Icon(Icons.bluetooth_rounded, color: TuneColors.accent),
                        title: Text(d.name, style: TuneFonts.body),
                        subtitle: Text(d.type.toUpperCase(), style: TuneFonts.footnote),
                        onTap: () {
                          context.read<AppState>().setZoneOutput(
                                zone.id,
                                OutputType.bluetooth,
                                deviceId: d.id,
                              );
                          Navigator.pop(ctx);
                        },
                      )),
                const SizedBox(height: 8),
                Text(
                  'Le routage actif dépend des paramètres système Android.',
                  style: TuneFonts.footnote.copyWith(color: TuneColors.textTertiary),
                ),
              ],
            ),
          ),
        );
      },
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
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_rounded, color: TuneColors.accent),
        tooltip: l.zonesNew,
        onPressed: () async {
          final appState = context.read<AppState>();
          await appState.createZoneFromDevice(device);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.zonesActivated(device.name)),
                duration: const Duration(seconds: 2),
                backgroundColor: TuneColors.accent,
              ),
            );
          }
        },
      ),
      onTap: () async {
        final appState = context.read<AppState>();
        await appState.createZoneFromDevice(device);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.zonesActivated(device.name)),
              duration: const Duration(seconds: 2),
              backgroundColor: TuneColors.accent,
            ),
          );
        }
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Tuile groupe multi-room
// ---------------------------------------------------------------------------

class _GroupTile extends StatelessWidget {
  final ZoneGroup group;
  final List<ZoneWithState> zones;

  const _GroupTile({required this.group, required this.zones});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    // Résout les noms des zones du groupe
    String zoneName(int id) {
      final z = zones.cast<ZoneWithState?>().firstWhere(
        (z) => z!.id == id,
        orElse: () => null,
      );
      return z?.name ?? '#$id';
    }

    final leaderName = zoneName(group.leaderId);
    final followerNames = group.zoneIds
        .where((id) => id != group.leaderId)
        .map(zoneName)
        .join(', ');

    return Dismissible(
      key: ValueKey('group_${group.groupId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<AppState>().ungroupZones(group.groupId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.zonesGroupDissolved),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: ListTile(
        leading: const Icon(Icons.speaker_group_rounded,
            color: TuneColors.accent),
        title: Row(
          children: [
            const Icon(Icons.star_rounded,
                size: 16, color: TuneColors.accent),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                leaderName,
                style: const TextStyle(
                  color: TuneColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.link_rounded,
                size: 14, color: TuneColors.textTertiary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                followerNames,
                style: TuneFonts.caption,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.tune_rounded,
              color: TuneColors.textTertiary, size: 20),
          tooltip: l.zonesGroupSyncDelay,
          onPressed: () => _showSyncDelaySheet(context),
        ),
        onTap: () => _showSyncDelaySheet(context),
      ),
    );
  }

  void _showSyncDelaySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TuneColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _SyncDelaySheet(group: group),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog de création de groupe
// ---------------------------------------------------------------------------

class _CreateGroupDialog extends StatefulWidget {
  const _CreateGroupDialog();

  @override
  State<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<_CreateGroupDialog> {
  final Set<int> _selectedIds = {};
  int? _leaderId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final zones = context.read<ZoneState>().zones;

    return AlertDialog(
      backgroundColor: TuneColors.surface,
      title: Text(l.zonesCreateGroup, style: TuneFonts.title3),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone selection
            Text(
              l.zonesGroupSelectZones,
              style: TuneFonts.subheadline,
            ),
            const SizedBox(height: 8),
            ...zones.map((zone) => CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: TuneColors.accent,
                  checkColor: TuneColors.textPrimary,
                  value: _selectedIds.contains(zone.id),
                  title: Text(
                    zone.name,
                    style: const TextStyle(color: TuneColors.textPrimary),
                  ),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedIds.add(zone.id);
                      } else {
                        _selectedIds.remove(zone.id);
                        if (_leaderId == zone.id) _leaderId = null;
                      }
                    });
                  },
                )),

            // Leader selection
            if (_selectedIds.length >= 2) ...[
              const SizedBox(height: 16),
              Text(
                l.zonesGroupSelectLeader,
                style: TuneFonts.subheadline,
              ),
              const SizedBox(height: 8),
              ...zones
                  .where((z) => _selectedIds.contains(z.id))
                  .map((zone) => RadioListTile<int>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: TuneColors.accent,
                        value: zone.id,
                        groupValue: _leaderId,
                        title: Text(
                          zone.name,
                          style: const TextStyle(
                              color: TuneColors.textPrimary),
                        ),
                        onChanged: (id) => setState(() => _leaderId = id),
                      )),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.btnCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
          onPressed: _canCreate ? _onCreate : null,
          child: Text(l.btnCreate),
        ),
      ],
    );
  }

  bool get _canCreate => _selectedIds.length >= 2 && _leaderId != null;

  void _onCreate() {
    final l = AppLocalizations.of(context);
    final leaderId = _leaderId!;
    final followerIds =
        _selectedIds.where((id) => id != leaderId).toList();
    context.read<AppState>().groupZones(leaderId, followerIds);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.zonesGroupCreated),
        duration: const Duration(seconds: 2),
        backgroundColor: TuneColors.accent,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom sheet sync delay
// ---------------------------------------------------------------------------

class _SyncDelaySheet extends StatefulWidget {
  final ZoneGroup group;
  const _SyncDelaySheet({required this.group});

  @override
  State<_SyncDelaySheet> createState() => _SyncDelaySheetState();
}

class _SyncDelaySheetState extends State<_SyncDelaySheet> {
  // Copie locale des valeurs de delay pour le slider
  final Map<int, int> _delays = {};
  bool _initialized = false;

  void _initDelays(List<ZoneWithState> zones) {
    if (_initialized) return;
    _initialized = true;
    for (final id in widget.group.zoneIds) {
      final zone = zones.cast<ZoneWithState?>().firstWhere(
        (z) => z!.id == id,
        orElse: () => null,
      );
      _delays[id] = zone?.syncDelayMs ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final zones = context.watch<ZoneState>().zones;
    _initDelays(zones);

    String zoneName(int id) {
      final z = zones.cast<ZoneWithState?>().firstWhere(
        (z) => z!.id == id,
        orElse: () => null,
      );
      return z?.name ?? '#$id';
    }

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
                  child:
                      Text(l.zonesGroupSyncDelay, style: TuneFonts.title3),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<AppState>()
                        .ungroupZones(widget.group.groupId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.zonesGroupDissolved),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    l.zonesGroupDissolve,
                    style: const TextStyle(color: TuneColors.error),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...widget.group.zoneIds.map((id) {
            final isLeader = id == widget.group.leaderId;
            final delay = _delays[id] ?? 0;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isLeader ? Icons.star_rounded : Icons.link_rounded,
                        size: 16,
                        color: TuneColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          zoneName(id),
                          style: TextStyle(
                            color: TuneColors.textPrimary,
                            fontWeight: isLeader
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        l.zonesGroupSyncDelayMs(delay),
                        style: TuneFonts.caption,
                      ),
                    ],
                  ),
                  Slider(
                    value: delay.toDouble(),
                    min: 0,
                    max: 500,
                    divisions: 50,
                    activeColor: TuneColors.accent,
                    inactiveColor: TuneColors.surfaceHigh,
                    onChanged: (value) {
                      setState(() => _delays[id] = value.round());
                    },
                    onChangeEnd: (value) {
                      context
                          .read<AppState>()
                          .updateSyncDelay(id, value.round());
                    },
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
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
