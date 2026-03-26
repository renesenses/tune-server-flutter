import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/discovery/discovery_manager.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// SourcesView — Paramètres → Sources & Appareils
//
// Affiche les devices UPnP/DLNA découverts, groupés par type :
//   • Serveurs de contenu → bouton "Indexer la bibliothèque"
//   • Renderers DLNA      → info seulement
// Actions :
//   • Swipe-to-forget : oublie un device
//   • FAB "Ajouter manuellement" : dialog IP+port → probeDevice()
// ---------------------------------------------------------------------------

class SourcesView extends StatelessWidget {
  const SourcesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.sourcesTitle, style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: AppLocalizations.of(context).btnRefresh,
            onPressed: () {
              context.read<AppState>().engine.discoveryManager.refresh();
            },
          ),
        ],
      ),
      body: const _SourcesList(),
      floatingActionButton: _AddManuallyFab(),
    );
  }
}

// ---------------------------------------------------------------------------
// Liste principale
// ---------------------------------------------------------------------------

class _SourcesList extends StatelessWidget {
  const _SourcesList();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final l = AppLocalizations.of(context);
    final devices = app.discoveredDevices;

    final servers =
        devices.where((d) => d.type == 'server').toList();
    final renderers =
        devices.where((d) => d.type == 'renderer').toList();

    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.devices_other_rounded,
                size: 56, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(l.sourcesNoDevices,
                style: TuneFonts.body
                    .copyWith(color: TuneColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        if (servers.isNotEmpty) ...[
          _SectionHeader(l.sourcesServersSection),
          Container(
            color: TuneColors.surface,
            child: Column(
              children: [
                for (int i = 0; i < servers.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 72),
                  _ServerTile(device: servers[i]),
                ],
              ],
            ),
          ),
        ],
        if (renderers.isNotEmpty) ...[
          _SectionHeader(l.sourcesRenderersSection),
          Container(
            color: TuneColors.surface,
            child: Column(
              children: [
                for (int i = 0; i < renderers.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 72),
                  _RendererTile(device: renderers[i]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tuile serveur UPnP
// ---------------------------------------------------------------------------

class _ServerTile extends StatelessWidget {
  final DiscoveredDevice device;
  const _ServerTile({required this.device});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lib = context.watch<LibraryState>();

    return Dismissible(
      key: ValueKey(device.id),
      direction: DismissDirection.endToStart,
      background: _ForgetBackground(label: l.sourcesForget),
      confirmDismiss: (_) => _confirmForget(context),
      onDismissed: (_) => context.read<AppState>().forgetDevice(device.id),
      child: ListTile(
        tileColor: TuneColors.surface,
        leading: _DeviceIcon(
          icon: Icons.storage_rounded,
          available: device.available,
        ),
        title: Text(device.name, style: TuneFonts.body),
        subtitle: Text(
          '${device.host}:${device.port}',
          style: TuneFonts.caption,
        ),
        trailing: lib.isScanning
            ? _ScanProgress(progress: lib.scanProgress)
            : _IndexButton(
                onTap: () => context.read<AppState>().indexUPnPServer(device),
                label: l.sourcesIndexBtn,
              ),
      ),
    );
  }

  Future<bool> _confirmForget(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.sourcesForget, style: TuneFonts.title3),
        content: Text(device.name, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.sourcesForget,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    return ok == true;
  }
}

// ---------------------------------------------------------------------------
// Tuile renderer DLNA
// ---------------------------------------------------------------------------

class _RendererTile extends StatelessWidget {
  final DiscoveredDevice device;
  const _RendererTile({required this.device});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final zones = context.watch<ZoneState>().zones;
    final assignedZone = zones.cast<dynamic>().firstWhere(
      (z) => z.outputDeviceId == device.id,
      orElse: () => null,
    );
    final isAssigned = assignedZone != null;

    // Label et couleur du badge
    final String badgeLabel;
    final Color badgeColor;
    final Color badgeBg;
    if (isAssigned) {
      badgeLabel = assignedZone.name;
      badgeColor = TuneColors.accent;
      badgeBg = TuneColors.accent.withValues(alpha: 0.12);
    } else if (device.available) {
      badgeLabel = l.sourcesAvailable;
      badgeColor = TuneColors.accent;
      badgeBg = TuneColors.accent.withValues(alpha: 0.12);
    } else {
      badgeLabel = l.sourcesUnavailable;
      badgeColor = TuneColors.textTertiary;
      badgeBg = TuneColors.surfaceVariant;
    }

    return Dismissible(
      key: ValueKey(device.id),
      direction: DismissDirection.endToStart,
      background: _ForgetBackground(label: l.sourcesForget),
      confirmDismiss: (_) => _confirmForget(context),
      onDismissed: (_) => context.read<AppState>().forgetDevice(device.id),
      child: ListTile(
        tileColor: TuneColors.surface,
        leading: _DeviceIcon(
          icon: Icons.cast_rounded,
          available: device.available || isAssigned,
        ),
        title: Text(device.name, style: TuneFonts.body),
        subtitle: Text(
          '${device.host}:${device.port}',
          style: TuneFonts.caption,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            badgeLabel,
            style: TuneFonts.caption.copyWith(color: badgeColor),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmForget(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.sourcesForget, style: TuneFonts.title3),
        content: Text(device.name, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.sourcesForget,
                style: const TextStyle(color: TuneColors.error)),
          ),
        ],
      ),
    );
    return ok == true;
  }
}

// ---------------------------------------------------------------------------
// FAB — Ajouter manuellement
// ---------------------------------------------------------------------------

class _AddManuallyFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FloatingActionButton.extended(
      backgroundColor: TuneColors.accent,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: Text(l.sourcesAddManually,
          style: const TextStyle(color: Colors.white)),
      onPressed: () => _showAddDialog(context),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final ipCtrl = TextEditingController();
    final portCtrl = TextEditingController(text: '49152');

    await showDialog<void>(
      context: context,
      builder: (ctx) => _ProbeDialog(
        ipCtrl: ipCtrl,
        portCtrl: portCtrl,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog de sonde manuelle
// ---------------------------------------------------------------------------

class _ProbeDialog extends StatefulWidget {
  final TextEditingController ipCtrl;
  final TextEditingController portCtrl;

  const _ProbeDialog({
    required this.ipCtrl,
    required this.portCtrl,
  });

  @override
  State<_ProbeDialog> createState() => _ProbeDialogState();
}

class _ProbeDialogState extends State<_ProbeDialog> {
  bool _probing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: TuneColors.surface,
      title: Text(l.sourcesAddTitle, style: TuneFonts.title3),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.ipCtrl,
            style: TuneFonts.body,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: l.sourcesIpLabel,
              hintText: l.sourcesIpHint,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.portCtrl,
            style: TuneFonts.body,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l.sourcesPortLabel,
              hintText: l.sourcesPortHint,
            ),
          ),
          if (_probing) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: TuneColors.accent),
                ),
                const SizedBox(width: 10),
                Text(l.sourcesProbing, style: TuneFonts.caption),
              ],
            ),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: TuneFonts.caption
                  .copyWith(color: TuneColors.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _probing ? null : () => Navigator.pop(context),
          child: Text(l.btnCancel),
        ),
        TextButton(
          onPressed: _probing ? null : () => _probe(context),
          child: Text(l.btnConnect,
              style: const TextStyle(color: TuneColors.accent)),
        ),
      ],
    );
  }

  Future<void> _probe(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final host = widget.ipCtrl.text.trim();
    final port = int.tryParse(widget.portCtrl.text.trim()) ?? 49152;
    if (host.isEmpty) return;

    final navigator = Navigator.of(context);
    final notFound = l.sourcesNotFound;

    setState(() {
      _probing = true;
      _errorMessage = null;
    });

    final device =
        await context.read<AppState>().probeDevice(host, port: port);

    if (!mounted) return;

    if (device != null) {
      navigator.pop();
    } else {
      setState(() {
        _probing = false;
        _errorMessage = notFound;
      });
    }
  }
}

// ---------------------------------------------------------------------------
// Composants partagés
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

class _DeviceIcon extends StatelessWidget {
  final IconData icon;
  final bool available;
  const _DeviceIcon({required this.icon, required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: available
            ? TuneColors.accent.withValues(alpha: 0.12)
            : TuneColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        size: 20,
        color: available ? TuneColors.accent : TuneColors.textTertiary,
      ),
    );
  }
}

class _ForgetBackground extends StatelessWidget {
  final String label;
  const _ForgetBackground({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.error,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_rounded, color: Colors.white, size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: TuneFonts.caption.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _IndexButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const _IndexButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: TuneColors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(
          color: onTap != null
              ? TuneColors.accent.withValues(alpha: 0.4)
              : TuneColors.textTertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(label, style: TuneFonts.caption),
    );
  }
}

class _ScanProgress extends StatelessWidget {
  final int progress;
  const _ScanProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: TuneColors.accent),
        ),
        const SizedBox(width: 6),
        Text('$progress', style: TuneFonts.caption),
      ],
    );
  }
}
