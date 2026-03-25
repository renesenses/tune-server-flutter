import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/discovery/content_directory_client.dart';
import '../../server/discovery/discovery_manager.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T15.4 — BrowseView
// Navigation UPnP/DLNA : liste des serveurs découverts + arborescence.
// Miroir de BrowseView.swift (iOS)
// ---------------------------------------------------------------------------

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    final hasServers = context.watch<ZoneState>().servers.isNotEmpty;

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Parcourir', style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            tooltip: 'Actualiser',
            onPressed: () =>
                context.read<AppState>().engine.discoveryManager.refresh(),
          ),
        ],
      ),
      body: hasServers ? const _ServerList() : const _NoServers(),
    );
  }
}

// ---------------------------------------------------------------------------
// _ServerList
// ---------------------------------------------------------------------------

class _ServerList extends StatelessWidget {
  const _ServerList();

  @override
  Widget build(BuildContext context) {
    final servers = context.watch<ZoneState>().servers;
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: servers.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: TuneColors.divider),
      itemBuilder: (_, i) {
        final server = servers[i];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TuneColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.dns_rounded,
                color: TuneColors.accent, size: 22),
          ),
          title: Text(server.name,
              style: TuneFonts.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text('${server.host}:${server.port}',
              style: TuneFonts.footnote),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: TuneColors.textTertiary),
          onTap: () {
            final cdUrl =
                server.capabilities.contentDirectoryControlUrl;
            if (cdUrl == null) return;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BrowseContainerView(
                device: server,
                contentDirectoryUrl: cdUrl,
                containerId: '0',
                title: server.name,
              ),
            ));
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// BrowseContainerView — arborescence d'un conteneur UPnP
// ---------------------------------------------------------------------------

class BrowseContainerView extends StatefulWidget {
  final DiscoveredDevice device;
  final String contentDirectoryUrl;
  final String containerId;
  final String title;

  const BrowseContainerView({
    super.key,
    required this.device,
    required this.contentDirectoryUrl,
    required this.containerId,
    required this.title,
  });

  @override
  State<BrowseContainerView> createState() => _BrowseContainerViewState();
}

class _BrowseContainerViewState extends State<BrowseContainerView> {
  BrowseResult? _result;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final client =
          ContentDirectoryClient(widget.contentDirectoryUrl);
      final result = await client.browseChildren(widget.containerId);
      if (mounted) {
        setState(() {
          _result = result;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.title, style: TuneFonts.title3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: TuneColors.textSecondary),
            onPressed: _load,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text('Erreur de navigation', style: TuneFonts.subheadline),
            const SizedBox(height: 4),
            TextButton(
                onPressed: _load,
                child: const Text('Réessayer',
                    style: TextStyle(color: TuneColors.accent))),
          ],
        ),
      );
    }

    final result = _result!;
    final containers = result.containers;
    final items = result.items;
    final total = containers.length + items.length;

    if (total == 0) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open_rounded,
                size: 48, color: TuneColors.textTertiary),
            SizedBox(height: 12),
            Text('Dossier vide', style: TuneFonts.subheadline),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: total,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 56, color: TuneColors.divider),
      itemBuilder: (_, i) {
        if (i < containers.length) {
          return _ContainerTile(
            container: containers[i],
            device: widget.device,
            contentDirectoryUrl: widget.contentDirectoryUrl,
          );
        } else {
          return _ItemTile(item: items[i - containers.length]);
        }
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _ContainerTile — dossier navigable
// ---------------------------------------------------------------------------

class _ContainerTile extends StatelessWidget {
  final DIDLContainer container;
  final DiscoveredDevice device;
  final String contentDirectoryUrl;

  const _ContainerTile({
    required this.container,
    required this.device,
    required this.contentDirectoryUrl,
  });

  @override
  Widget build(BuildContext context) {
    final count = container.childCount;
    return ListTile(
      leading: const Icon(Icons.folder_rounded,
          color: TuneColors.accent, size: 28),
      title: Text(container.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: count != null
          ? Text('$count éléments', style: TuneFonts.footnote)
          : null,
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TuneColors.textTertiary),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BrowseContainerView(
          device: device,
          contentDirectoryUrl: contentDirectoryUrl,
          containerId: container.id,
          title: container.title,
        ),
      )),
    );
  }
}

// ---------------------------------------------------------------------------
// _ItemTile — piste jouable
// ---------------------------------------------------------------------------

class _ItemTile extends StatelessWidget {
  final DIDLItem item;
  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return ListTile(
      onTap: () => app.playDlnaItem(item),
      leading: const Icon(Icons.music_note_rounded,
          color: TuneColors.textTertiary, size: 24),
      title: Text(item.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _subtitle,
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (item.artist != null) item.artist!,
      if (item.album != null) item.album!,
      if (item.durationMs != null) _formatDuration(item.durationMs!),
    ];
    if (parts.isEmpty) return null;
    return Text(parts.join(' · '),
        style: TuneFonts.footnote,
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }

  static String _formatDuration(int ms) {
    final s = ms ~/ 1000;
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }
}

// ---------------------------------------------------------------------------
// Placeholder
// ---------------------------------------------------------------------------

class _NoServers extends StatelessWidget {
  const _NoServers();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.dns_rounded,
              size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          const Text('Aucun serveur DLNA détecté',
              style: TuneFonts.subheadline),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context
                .read<AppState>()
                .engine
                .discoveryManager
                .refresh(),
            child: const Text('Actualiser',
                style: TextStyle(color: TuneColors.accent)),
          ),
        ],
      ),
    );
  }
}
