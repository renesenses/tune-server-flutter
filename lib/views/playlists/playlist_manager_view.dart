import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../ai/ai_chat_screen.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'package:tune_server/services/tune_api_client.dart';

/// Playlist Manager — Transfer, Sync, Backup tabs
/// Mirrors PlaylistManagerView.swift (iOS) and web client
class PlaylistManagerView extends StatefulWidget {
  const PlaylistManagerView({super.key});

  @override
  State<PlaylistManagerView> createState() => _PlaylistManagerViewState();
}

class _PlaylistManagerViewState extends State<PlaylistManagerView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> _links = [];
  List<Map<String, dynamic>> _snapshots = [];
  bool _loading = false;

  // Backup
  bool _backingUp = false;
  Map<String, dynamic>? _backupResult;
  int? _restoringSnapshotId;
  String _restoreMessage = '';

  // Batch
  String _batchSource = '';
  bool _batching = false;
  Map<String, dynamic>? _batchResult;

  // Compare
  List<Map<String, dynamic>> _allPlaylists = [];
  bool _loadingPlaylists = false;
  String _compareSourceService = '';
  String _compareSourceId = '';
  String _compareTargetService = '';
  String _compareTargetId = '';
  bool _comparing = false;
  Map<String, dynamic>? _compareResult;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 6, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) _loadTab();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTab() async {
    final app = context.read<AppState>();
    if (!app.isRemoteMode || app.apiClient == null) return;
    setState(() => _loading = true);
    try {
      if (_tabCtrl.index == 2) {
        final data = await app.apiClient!.getTransferHistory();
        _history = data.cast<Map<String, dynamic>>();
      } else if (_tabCtrl.index == 3) {
        final data = await app.apiClient!.getPlaylistLinks();
        _links = data.cast<Map<String, dynamic>>();
      } else if (_tabCtrl.index == 4) {
        final data = await app.apiClient!.listPlaylistSnapshots();
        _snapshots = data.cast<Map<String, dynamic>>();
      } else if (_tabCtrl.index == 5) {
        await _loadAllPlaylistsForCompare();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _restoreSnapshot(Map<String, dynamic> snap) async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    final l = AppLocalizations.of(context);
    final nameController = TextEditingController(text: snap['playlist_name'] as String? ?? '');
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.plRestoreSnapshotTitle, style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.plLocalPlaylistNameLabel, style: TuneFonts.footnote),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              style: TuneFonts.body,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: TuneColors.surfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: Text(l.btnCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, nameController.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            child: Text(l.plRestore),
          ),
        ],
      ),
    );
    if (result == null) return;

    setState(() {
      _restoringSnapshotId = snap['id'] as int;
      _restoreMessage = '';
    });

    Future<dynamic> doRestore(bool overwrite) {
      return app.apiClient!.restorePlaylistSnapshot(
        snap['id'] as int,
        targetName: result.isEmpty ? null : result,
        overwriteExisting: overwrite,
      );
    }

    try {
      final r = await doRestore(false);
      setState(() {
        _restoreMessage = l.plRestoreDone('${r['name']}', '${r['tracks_matched']}', '${r['tracks_not_found']}');
      });
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('already exists') || msg.contains('409')) {
        if (!mounted) return;
        final overwrite = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: TuneColors.surface,
            title: Text(l.plExistingTitle, style: TuneFonts.title3),
            content: Text(l.plExistingBody('${result.isEmpty ? snap['playlist_name'] : result}'), style: TuneFonts.body),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.btnCancel)),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(backgroundColor: TuneColors.error),
                child: Text(l.plReplace),
              ),
            ],
          ),
        );
        if (overwrite == true) {
          try {
            final r = await doRestore(true);
            setState(() {
              _restoreMessage = l.plRestoreReplaced('${r['name']}', '${r['tracks_matched']}', '${r['tracks_not_found']}');
            });
          } catch (e2) {
            setState(() => _restoreMessage = l.errorWith(e2.toString()));
          }
        }
      } else {
        setState(() => _restoreMessage = l.errorWith(e.toString()));
      }
    }

    setState(() => _restoringSnapshotId = null);
  }

  Future<void> _deleteSnapshot(Map<String, dynamic> snap) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.btnDelete, style: TuneFonts.title3),
        content: Text(l.plDeleteSnapshotBody('${snap['playlist_name']}'), style: TuneFonts.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.btnCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: TuneColors.error),
            child: Text(l.btnDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final app = context.read<AppState>();
    await app.apiClient?.deletePlaylistSnapshot(snap['id'] as int);
    if (!mounted) return;
    setState(() {
      _snapshots.removeWhere((s) => s['id'] == snap['id']);
    });
  }

  Future<void> _editSyncInterval(Map<String, dynamic> link) async {
    final current = link['sync_interval_minutes'] as int? ?? 0;
    final controller = TextEditingController(text: current.toString());
    final l = AppLocalizations.of(context);
    final result = await showDialog<int?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.plSyncIntervalTitle, style: TuneFonts.title3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.plSyncIntervalLabel, style: TuneFonts.footnote),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TuneFonts.body,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: true,
                fillColor: TuneColors.surfaceVariant,
                hintText: l.plSyncIntervalHint,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: Text(l.btnCancel)),
          FilledButton(
            onPressed: () {
              final v = int.tryParse(controller.text) ?? 0;
              Navigator.pop(ctx, v < 0 ? 0 : v);
            },
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            child: Text(l.btnSave),
          ),
        ],
      ),
    );
    if (result == null || !mounted) return;
    final app = context.read<AppState>();
    try {
      await app.apiClient?.updatePlaylistLink(link['id'] as int, syncIntervalMinutes: result);
      await _loadTab();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.plHubTitle, style: TuneFonts.title3),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          tabs: [
            Tab(text: l.tabPlaylists),
            Tab(text: l.plTabSmartAi),
            Tab(text: l.plTabTransfers),
            Tab(text: l.plSync),
            Tab(text: l.plTabBackup),
            Tab(text: l.plCompare),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          const _PlaylistsTab(),
          const AIChatScreen(embedded: true),
          _buildHistoryTab(),
          _buildSyncTab(),
          _buildBackupTab(),
          _buildCompareTab(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Compare Tab — compare playlists between services
  // ---------------------------------------------------------------------------

  Future<void> _loadAllPlaylistsForCompare() async {
    if (_loadingPlaylists) return;
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    _loadingPlaylists = true;
    final items = <Map<String, dynamic>>[];

    try {
      final local = await app.apiClient!.getPlaylists();
      for (final p in local) {
        final m = p as Map<String, dynamic>;
        items.add({
          'service': 'local',
          'id': '${m['id']}',
          'name': m['name'] as String? ?? '',
        });
      }
    } catch (_) {}

    final services = context.read<LibraryState>().streamingServices
        .where((s) => s.authenticated)
        .map((s) => s.serviceId)
        .toList();
    await Future.wait(services.map((svc) async {
      try {
        final pls = await app.apiClient!.getStreamingPlaylists(svc);
        for (final p in pls) {
          final m = p as Map<String, dynamic>;
          items.add({
            'service': svc,
            'id': '${m['source_id'] ?? m['id'] ?? ''}',
            'name': m['name'] as String? ?? '',
          });
        }
      } catch (_) {}
    }));

    if (mounted) {
      setState(() {
        _allPlaylists = items;
        _loadingPlaylists = false;
      });
    }
  }

  Future<void> _doCompare() async {
    if (_compareSourceService.isEmpty || _compareSourceId.isEmpty ||
        _compareTargetService.isEmpty || _compareTargetId.isEmpty) return;
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    setState(() { _comparing = true; _compareResult = null; });
    try {
      final result = await app.apiClient!.comparePlaylists(
        sourceService: _compareSourceService,
        sourcePlaylistId: _compareSourceId,
        targetService: _compareTargetService,
        targetPlaylistId: _compareTargetId,
      );
      if (mounted) setState(() { _compareResult = result; _comparing = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _comparing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).plCompareError(e.toString()))),
        );
      }
    }
  }

  List<Map<String, dynamic>> _playlistsForService(String service) {
    return _allPlaylists.where((p) => p['service'] == service).toList();
  }

  List<String> get _compareAvailableServices {
    final set = <String>{};
    for (final p in _allPlaylists) {
      set.add(p['service'] as String);
    }
    return set.toList();
  }

  Widget _buildCompareTab() {
    final l = AppLocalizations.of(context);
    if (_loadingPlaylists && _allPlaylists.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }
    if (_allPlaylists.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.compare_arrows_rounded, size: 48, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(l.plNoPlaylistsAvailable, style: TuneFonts.body),
          ],
        ),
      );
    }

    final services = _compareAvailableServices;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.plSectionSource, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _compareSourceService.isEmpty ? null : _compareSourceService,
                  decoration: InputDecoration(
                    labelText: l.plServiceLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true, fillColor: TuneColors.surface,
                  ),
                  dropdownColor: TuneColors.surfaceVariant,
                  items: services.map((s) => DropdownMenuItem(value: s, child: Text(s == 'local' ? l.plLocal : s.toUpperCase()))).toList(),
                  onChanged: (v) => setState(() {
                    _compareSourceService = v ?? '';
                    _compareSourceId = '';
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _compareSourceId.isEmpty ? null : _compareSourceId,
                  decoration: InputDecoration(
                    labelText: l.plPlaylistLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true, fillColor: TuneColors.surface,
                  ),
                  dropdownColor: TuneColors.surfaceVariant,
                  items: _playlistsForService(_compareSourceService).map((p) =>
                    DropdownMenuItem(value: p['id'] as String, child: Text(p['name'] as String, overflow: TextOverflow.ellipsis))
                  ).toList(),
                  onChanged: (v) => setState(() => _compareSourceId = v ?? ''),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l.plSectionTarget, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _compareTargetService.isEmpty ? null : _compareTargetService,
                  decoration: InputDecoration(
                    labelText: l.plServiceLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true, fillColor: TuneColors.surface,
                  ),
                  dropdownColor: TuneColors.surfaceVariant,
                  items: services.map((s) => DropdownMenuItem(value: s, child: Text(s == 'local' ? l.plLocal : s.toUpperCase()))).toList(),
                  onChanged: (v) => setState(() {
                    _compareTargetService = v ?? '';
                    _compareTargetId = '';
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _compareTargetId.isEmpty ? null : _compareTargetId,
                  decoration: InputDecoration(
                    labelText: l.plPlaylistLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true, fillColor: TuneColors.surface,
                  ),
                  dropdownColor: TuneColors.surfaceVariant,
                  items: _playlistsForService(_compareTargetService).map((p) =>
                    DropdownMenuItem(value: p['id'] as String, child: Text(p['name'] as String, overflow: TextOverflow.ellipsis))
                  ).toList(),
                  onChanged: (v) => setState(() => _compareTargetId = v ?? ''),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _comparing || _compareSourceId.isEmpty || _compareTargetId.isEmpty
                  ? null
                  : _doCompare,
              icon: _comparing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.compare_arrows_rounded),
              label: Text(_comparing ? l.plComparing : l.plCompare),
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
          if (_compareResult != null) ...[
            const SizedBox(height: 20),
            _CompareResultCard(result: _compareResult!),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // History Tab
  // ---------------------------------------------------------------------------

  Widget _buildHistoryTab() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }
    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_horiz_rounded, size: 48, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context).plNoTransfers, style: TuneFonts.body),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _history.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: TuneColors.divider),
      itemBuilder: (_, i) {
        final e = _history[i];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: TuneColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              (e['operation'] as String? ?? 'transfer').toUpperCase(),
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: TuneColors.accent),
            ),
          ),
          title: Text(e['source_playlist_name'] as String? ?? '—', style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${e['source_service']} → ${e['target_service']}', style: TuneFonts.footnote),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${e['matched'] ?? 0}', style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              Text('${e['not_found'] ?? 0}', style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Sync Tab
  // ---------------------------------------------------------------------------

  Widget _buildSyncTab() {
    final l = AppLocalizations.of(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }
    if (_links.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sync_rounded, size: 48, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(l.plNoSyncLinks, style: TuneFonts.body),
            const SizedBox(height: 4),
            Text(l.plNoSyncLinksHint, style: TuneFonts.footnote),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _links.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: TuneColors.divider),
      itemBuilder: (_, i) {
        final link = _links[i];
        return Dismissible(
          key: ValueKey(link['id']),
          direction: DismissDirection.endToStart,
          background: Container(color: TuneColors.error, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
          onDismissed: (_) async {
            final app = context.read<AppState>();
            await app.apiClient?.deletePlaylistLink(link['id'] as int);
            _links.removeAt(i);
          },
          child: ListTile(
            leading: const Icon(Icons.sync_rounded, color: TuneColors.accent),
            title: Text(
              (link['service_playlist_name'] as String?)?.isNotEmpty == true
                  ? link['service_playlist_name'] as String
                  : l.plPlaylistNumber('${link['local_playlist_id']}'),
              style: TuneFonts.body,
            ),
            subtitle: Text(
              '${link['service']} · ${link['sync_direction']}'
              '${(link['sync_interval_minutes'] as int? ?? 0) > 0 ? ' · ${l.plAutoEveryMinutes('${link['sync_interval_minutes']}')}' : ''}'
              '${link['last_synced_at'] != null ? ' · ${(link['last_synced_at'] as String).split('T').first}' : ''}',
              style: TuneFonts.footnote,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.schedule, size: 18, color: TuneColors.textSecondary),
                  tooltip: l.plSyncIntervalTitle,
                  onPressed: () => _editSyncInterval(link),
                ),
                FilledButton(
                  onPressed: () async {
                    final app = context.read<AppState>();
                    try {
                      final result = await app.apiClient?.syncPlaylistLink(link['id'] as int);
                      if (!mounted || result == null) return;
                      final addedLocal = result['added_to_local'] ?? 0;
                      final removedLocal = result['removed_from_local'] ?? 0;
                      final addedRemote = result['added_to_remote'] ?? 0;
                      final removedRemote = result['removed_from_remote'] ?? 0;
                      final conflicts = (result['conflicts'] as List?)?.length ?? 0;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                          l.plSyncDone('$addedLocal', '$removedLocal', '$addedRemote', '$removedRemote') +
                              (conflicts > 0 ? l.plSyncConflicts(conflicts) : ''),
                        )),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l.plSyncError(e.toString()))),
                      );
                    }
                    _loadTab();
                  },
                  style: FilledButton.styleFrom(backgroundColor: TuneColors.accent, minimumSize: const Size(60, 32)),
                  child: Text(l.plSync, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Backup Tab
  // ---------------------------------------------------------------------------

  Widget _buildBackupTab() {
    final services = context.watch<LibraryState>().streamingServices;
    final authServices = services.where((s) => s.authenticated).map((s) => s.serviceId).toList();
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Backup
          Text(l.plSectionBackup, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _backingUp ? null : () async {
                setState(() => _backingUp = true);
                final app = context.read<AppState>();
                try {
                  final r = await app.apiClient?.backupPlaylists();
                  setState(() => _backupResult = r as Map<String, dynamic>?);
                  // Reload snapshots list
                  final snaps = await app.apiClient?.listPlaylistSnapshots();
                  if (snaps != null) {
                    setState(() => _snapshots = snaps.cast<Map<String, dynamic>>());
                  }
                } catch (_) {}
                setState(() => _backingUp = false);
              },
              icon: const Icon(Icons.backup_rounded),
              label: Text(_backingUp ? l.plBackingUp : l.plBackupAll),
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent, minimumSize: const Size.fromHeight(48)),
            ),
          ),
          if (_backupResult != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: TuneColors.surface, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(l.plBackupResult('${_backupResult!['playlists_backed_up']}', '${_backupResult!['total_tracks_snapshot']}'),
                      style: TuneFonts.footnote),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          Text(l.plSectionSnapshots, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 8),
          if (_restoreMessage.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: TuneColors.surface, borderRadius: BorderRadius.circular(8)),
              child: Text(_restoreMessage, style: TuneFonts.footnote),
            ),
          ],
          if (_snapshots.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l.plNoSnapshots, style: TuneFonts.footnote),
            )
          else
            ..._snapshots.map((snap) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: TuneColors.surface, borderRadius: BorderRadius.circular(6)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snap['playlist_name'] as String? ?? '—',
                            style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          '${snap['source_service']} · ${l.plTracksCount(int.tryParse('${snap['track_count'] ?? 0}') ?? 0)}'
                          '${snap['created_at'] != null ? ' · ${(snap['created_at'] as String).split('T').first}' : ''}',
                          style: TuneFonts.footnote,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: _restoringSnapshotId == snap['id']
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: TuneColors.accent))
                        : const Icon(Icons.restore, color: TuneColors.accent, size: 20),
                    tooltip: l.plRestore,
                    onPressed: _restoringSnapshotId == snap['id'] ? null : () => _restoreSnapshot(snap),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: TuneColors.textSecondary, size: 20),
                    tooltip: l.btnDelete,
                    onPressed: () => _deleteSnapshot(snap),
                  ),
                ],
              ),
            )),

          const SizedBox(height: 24),
          const Divider(color: TuneColors.divider),
          const SizedBox(height: 16),

          // Batch Transfer
          Text(l.plSectionBatchTransfer, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text(l.plBatchTransferHint, style: TuneFonts.footnote),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _batchSource.isEmpty ? null : _batchSource,
                  decoration: InputDecoration(
                    labelText: l.plSourceLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true, fillColor: TuneColors.surface,
                  ),
                  dropdownColor: TuneColors.surfaceVariant,
                  items: authServices.map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
                  onChanged: (v) => setState(() => _batchSource = v ?? ''),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.arrow_forward, color: TuneColors.textTertiary)),
              Text(l.plLocal, style: TuneFonts.body),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _batchSource.isEmpty || _batching ? null : () async {
                setState(() => _batching = true);
                final app = context.read<AppState>();
                try {
                  final r = await app.apiClient?.batchTransfer(sourceService: _batchSource);
                  setState(() => _batchResult = r as Map<String, dynamic>?);
                } catch (_) {}
                setState(() => _batching = false);
              },
              icon: const Icon(Icons.download_rounded),
              label: Text(_batching ? l.plTransferring : l.plTransferAll),
              style: FilledButton.styleFrom(
                backgroundColor: _batchSource.isEmpty ? Colors.grey : TuneColors.accent,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
          if (_batchResult != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: TuneColors.surface, borderRadius: BorderRadius.circular(8)),
              child: Text(l.plBatchResult('${_batchResult!['total_playlists']}', '${_batchResult!['status']}'), style: TuneFonts.footnote),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Playlists Tab — unified list (local + streaming) with search, filter,
// merge mode, and per-item detail navigation.
// ---------------------------------------------------------------------------

class _PlaylistItem {
  final String service; // 'local' or streaming service name
  final String id; // stringified id
  final String name;
  final int trackCount;
  final String? coverPath;
  final Map<String, dynamic> raw;

  _PlaylistItem({
    required this.service,
    required this.id,
    required this.name,
    required this.trackCount,
    this.coverPath,
    required this.raw,
  });

  bool get isLocal => service == 'local';
  String get key => '$service:$id';
}

class _PlaylistsTab extends StatefulWidget {
  const _PlaylistsTab();

  @override
  State<_PlaylistsTab> createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<_PlaylistsTab> {
  bool _loading = false;
  List<_PlaylistItem> _all = [];
  String _search = '';
  String _filter = 'all';
  final TextEditingController _searchCtrl = TextEditingController();

  // Merge
  bool _mergeMode = false;
  final Set<String> _mergeSelected = {};
  final TextEditingController _mergeNameCtrl = TextEditingController();
  bool _mergeDedup = true;
  bool _merging = false;

  LibraryState? _libraryState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _libraryState = context.read<LibraryState>();
      _libraryState!.addListener(_onLibraryChanged);
      _load();
    });
  }

  void _onLibraryChanged() {
    // Reload when local playlists are created/deleted/modified.
    if (mounted) _load();
  }

  @override
  void dispose() {
    _libraryState?.removeListener(_onLibraryChanged);
    _searchCtrl.dispose();
    _mergeNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final app = context.read<AppState>();
    setState(() => _loading = true);
    final items = <_PlaylistItem>[];

    // Local — use API in remote mode, LibraryState (drift) in embedded mode
    if (app.apiClient != null) {
      try {
        final local = await app.apiClient!.getPlaylists();
        for (final p in local) {
          final m = p as Map<String, dynamic>;
          items.add(_PlaylistItem(
            service: 'local',
            id: '${m['id']}',
            name: m['name'] as String? ?? '—',
            trackCount: m['track_count'] as int? ?? 0,
            coverPath: m['cover_path'] as String?,
            raw: m,
          ));
        }
      } catch (_) {}
    } else {
      // Embedded server mode: read directly from local DB via LibraryState
      final localPlaylists = context.read<LibraryState>().playlists;
      for (final p in localPlaylists) {
        items.add(_PlaylistItem(
          service: 'local',
          id: '${p.id}',
          name: p.name,
          trackCount: p.trackCount,
          coverPath: null,
          raw: {'id': p.id, 'name': p.name, 'track_count': p.trackCount},
        ));
      }
    }

    // Streaming — only available when apiClient is connected
    if (app.apiClient != null) {
      final services = context.read<LibraryState>().streamingServices
          .where((s) => s.authenticated)
          .map((s) => s.serviceId)
          .toList();
      await Future.wait(services.map((svc) async {
        try {
          final pls = await app.apiClient!.getStreamingPlaylists(svc);
          for (final p in pls) {
            final m = p as Map<String, dynamic>;
            items.add(_PlaylistItem(
              service: svc,
              id: '${m['source_id'] ?? m['id'] ?? ''}',
              name: m['name'] as String? ?? '—',
              trackCount: m['track_count'] as int? ?? 0,
              coverPath: m['cover_path'] as String? ?? m['artwork_url'] as String?,
              raw: m,
            ));
          }
        } catch (_) {}
      }));
    }

    if (!mounted) return;
    setState(() {
      _all = items;
      _loading = false;
    });
  }

  List<String> get _availableServices {
    final set = <String>{'local'};
    set.addAll(_all.map((p) => p.service));
    return set.toList();
  }

  List<_PlaylistItem> get _filtered {
    return _all.where((p) {
      if (_filter != 'all' && p.service != _filter) return false;
      if (_search.trim().isEmpty) return true;
      return p.name.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  Color _serviceColor(String svc) {
    switch (svc.toLowerCase()) {
      case 'tidal': return const Color(0xFF00FFFF);
      case 'qobuz': return const Color(0xFF0066CC);
      case 'spotify': return const Color(0xFF1DB954);
      case 'youtube': return const Color(0xFFFF0000);
      case 'deezer': return const Color(0xFFA238FF);
      case 'amazon': return const Color(0xFFFF9900);
      case 'local': return TuneColors.accent;
      default: return TuneColors.textSecondary;
    }
  }

  void _toggleMergeSelect(String key) {
    setState(() {
      if (_mergeSelected.contains(key)) {
        _mergeSelected.remove(key);
      } else {
        _mergeSelected.add(key);
      }
    });
  }

  Future<void> _doMerge() async {
    if (_mergeSelected.length < 2 || _mergeNameCtrl.text.trim().isEmpty) return;
    final app = context.read<AppState>();
    final selected = _all.where((p) => _mergeSelected.contains(p.key)).toList();
    final payload = selected.map((p) => {'service': p.service, 'playlist_id': p.id}).toList();
    final l = AppLocalizations.of(context);
    setState(() => _merging = true);
    try {
      await app.apiClient?.mergePlaylists(
        playlists: payload,
        targetName: _mergeNameCtrl.text.trim(),
        deduplicate: _mergeDedup,
      );
      if (!mounted) return;
      setState(() {
        _mergeMode = false;
        _mergeSelected.clear();
        _mergeNameCtrl.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.plMergeDone)),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.plMergeError(e.toString()))),
      );
    }
    if (mounted) setState(() => _merging = false);
  }

  Future<void> _createPlaylist() async {
    final nameCtrl = TextEditingController();
    final l = AppLocalizations.of(context);
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.playlistNewPlaylist, style: TuneFonts.title3),
        content: TextField(
          controller: nameCtrl,
          decoration: InputDecoration(
            labelText: l.plNameLabel,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            filled: true, fillColor: TuneColors.surfaceVariant,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: Text(l.btnCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, nameCtrl.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
            child: Text(l.btnCreate),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty || !mounted) return;
    final app = context.read<AppState>();
    try {
      await app.apiClient?.createPlaylist(result);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.errorWith(e.toString()))),
      );
    }
  }

  Future<void> _deletePlaylist(_PlaylistItem item) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.btnDelete, style: TuneFonts.title3),
        content: Text(l.plDeleteNamed(item.name), style: TuneFonts.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.btnCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: TuneColors.error),
            child: Text(l.btnDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final app = context.read<AppState>();
    try {
      await app.apiClient?.deletePlaylist(int.parse(item.id));
      if (!mounted) return;
      setState(() => _all.removeWhere((p) => p.key == item.key));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.errorWith(e.toString()))),
      );
    }
  }

  Future<void> _importStreamingPlaylist(_PlaylistItem item) async {
    final app = context.read<AppState>();
    final l = AppLocalizations.of(context);
    try {
      await app.apiClient?.importStreamingPlaylist(
        service: item.service,
        sourcePlaylistId: item.id,
        name: item.name,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.plImportedLocal(item.name))),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.plImportError(e.toString()))),
      );
    }
  }

  void _openDetail(_PlaylistItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PlaylistDetailPage(item: item, onChanged: _load),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final services = _availableServices;
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      floatingActionButton: _mergeMode
          ? null
          : FloatingActionButton(
              backgroundColor: TuneColors.accent,
              onPressed: _createPlaylist,
              child: const Icon(Icons.add),
            ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search, color: TuneColors.textSecondary),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: TuneColors.textSecondary),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: TuneColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                isDense: true,
              ),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                ...['all', ...services].map((f) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(f == 'all' ? l.plFilterAll : f.toUpperCase()),
                        selected: _filter == f,
                        onSelected: (_) => setState(() => _filter = f),
                        backgroundColor: TuneColors.surface,
                        selectedColor: _serviceColor(f).withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: _filter == f ? _serviceColor(f) : TuneColors.textSecondary,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: _filter == f ? _serviceColor(f) : TuneColors.divider,
                        ),
                      ),
                    )),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(_mergeMode ? l.plCancelMerge : l.plMerge),
                  selected: _mergeMode,
                  onSelected: (_) => setState(() {
                    _mergeMode = !_mergeMode;
                    if (!_mergeMode) {
                      _mergeSelected.clear();
                      _mergeNameCtrl.clear();
                    }
                  }),
                  backgroundColor: TuneColors.surface,
                  selectedColor: TuneColors.accent.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: _mergeMode ? TuneColors.accent : TuneColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: TuneColors.accent))
                : _filtered.isEmpty
                    ? Center(child: Text(l.libraryEmptyPlaylists, style: TuneFonts.body))
                    : ListView.separated(
                        padding: EdgeInsets.only(
                          top: 8,
                          bottom: _mergeMode && _mergeSelected.isNotEmpty ? 180 : 80,
                        ),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 16, color: TuneColors.divider),
                        itemBuilder: (_, i) {
                          final p = _filtered[i];
                          final selected = _mergeSelected.contains(p.key);
                          return Container(
                            color: selected ? TuneColors.accent.withValues(alpha: 0.08) : null,
                            child: ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_mergeMode)
                                    Checkbox(
                                      value: selected,
                                      onChanged: (_) => _toggleMergeSelect(p.key),
                                      activeColor: TuneColors.accent,
                                    ),
                                  p.coverPath != null
                                      ? ArtworkView(filePath: p.coverPath!, size: 44, cornerRadius: 6)
                                      : Container(
                                          width: 44, height: 44,
                                          decoration: BoxDecoration(
                                            color: TuneColors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Icon(Icons.queue_music, color: TuneColors.textSecondary),
                                        ),
                                ],
                              ),
                              title: Text(p.name, style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Row(
                                children: [
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(
                                      color: _serviceColor(p.service),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${p.service == 'local' ? l.plLocal : p.service.toUpperCase()} · ${l.plTracksCount(p.trackCount)}',
                                    style: TuneFonts.footnote,
                                  ),
                                ],
                              ),
                              trailing: _mergeMode
                                  ? null
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (!p.isLocal)
                                          IconButton(
                                            icon: const Icon(Icons.download, size: 20, color: TuneColors.accent),
                                            tooltip: l.plImportToLocal,
                                            onPressed: () => _importStreamingPlaylist(p),
                                          ),
                                        if (p.isLocal)
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, size: 20, color: TuneColors.textSecondary),
                                            tooltip: l.btnDelete,
                                            onPressed: () => _deletePlaylist(p),
                                          ),
                                        const Icon(Icons.chevron_right_rounded, color: TuneColors.textTertiary),
                                      ],
                                    ),
                              onTap: _mergeMode ? () => _toggleMergeSelect(p.key) : () => _openDetail(p),
                            ),
                          );
                        },
                      ),
          ),
          // Merge action bar
          if (_mergeMode && _mergeSelected.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                border: Border(top: BorderSide(color: TuneColors.divider)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(l.plSelectedCount(_mergeSelected.length),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: TuneColors.textPrimary)),
                      const Spacer(),
                      Row(children: [
                        Switch(
                          value: _mergeDedup,
                          onChanged: (v) => setState(() => _mergeDedup = v),
                          activeThumbColor: TuneColors.accent,
                        ),
                        Text(l.plDedup, style: TuneFonts.footnote),
                      ]),
                    ],
                  ),
                  TextField(
                    controller: _mergeNameCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l.plMergedNameHint,
                      filled: true,
                      fillColor: TuneColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _merging || _mergeSelected.length < 2 || _mergeNameCtrl.text.trim().isEmpty
                          ? null
                          : _doMerge,
                      icon: _merging
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.merge),
                      label: Text(_merging ? l.plMerging : l.plMerge),
                      style: FilledButton.styleFrom(
                        backgroundColor: TuneColors.accent,
                        minimumSize: const Size.fromHeight(44),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Compare result card
// ---------------------------------------------------------------------------

class _CompareResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  const _CompareResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final common = result['common'] as List? ?? [];
    final onlyInSource = result['only_in_source'] as List? ?? [];
    final onlyInTarget = result['only_in_target'] as List? ?? [];
    final matchRate = result['match_rate'] as num? ?? 0;
    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.plSectionResults, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatBadge(label: l.plCommon, count: common.length, color: TuneColors.success),
              const SizedBox(width: 8),
              _StatBadge(label: l.plSourceOnly, count: onlyInSource.length, color: TuneColors.warning),
              const SizedBox(width: 8),
              _StatBadge(label: l.plTargetOnly, count: onlyInTarget.length, color: TuneColors.error),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: matchRate / 100,
            backgroundColor: TuneColors.surfaceVariant,
            color: TuneColors.accent,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 4),
          Text(l.plMatchRate(matchRate.toStringAsFixed(1)), style: TuneFonts.caption),
          if (onlyInSource.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l.plOnlyInSource(onlyInSource.length), style: TuneFonts.footnote.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            for (int i = 0; i < onlyInSource.length && i < 10; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  _trackLabel(onlyInSource[i]),
                  style: TuneFonts.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (onlyInSource.length > 10)
              Text(l.plMoreCount(onlyInSource.length - 10), style: TuneFonts.caption),
          ],
          if (onlyInTarget.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l.plOnlyInTarget(onlyInTarget.length), style: TuneFonts.footnote.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            for (int i = 0; i < onlyInTarget.length && i < 10; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  _trackLabel(onlyInTarget[i]),
                  style: TuneFonts.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (onlyInTarget.length > 10)
              Text(l.plMoreCount(onlyInTarget.length - 10), style: TuneFonts.caption),
          ],
        ],
      ),
    );
  }

  String _trackLabel(dynamic track) {
    if (track is Map<String, dynamic>) {
      final title = track['title'] as String? ?? '';
      final artist = track['artist_name'] as String? ?? track['artist'] as String? ?? '';
      return artist.isEmpty ? title : '$artist - $title';
    }
    return track.toString();
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatBadge({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TuneFonts.caption.copyWith(color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Playlist detail page — tracks + actions (Transfer, Diff, Recover)
// ---------------------------------------------------------------------------

class _PlaylistDetailPage extends StatefulWidget {
  final _PlaylistItem item;
  final Future<void> Function() onChanged;
  const _PlaylistDetailPage({required this.item, required this.onChanged});

  @override
  State<_PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<_PlaylistDetailPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _tracks = [];

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final app = context.read<AppState>();
    if (app.apiClient == null) return;
    setState(() => _loading = true);
    try {
      final list = widget.item.isLocal
          ? await app.apiClient!.getPlaylistTracks(int.parse(widget.item.id))
          : await app.apiClient!.getStreamingPlaylistTracks(widget.item.service, widget.item.id);
      _tracks = list.cast<Map<String, dynamic>>();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _transfer() async {
    final app = context.read<AppState>();
    final authServices = context.read<LibraryState>().streamingServices
        .where((s) => s.authenticated)
        .map((s) => s.serviceId)
        .toList();
    final allTargets = ['local', ...authServices.where((s) => s != widget.item.service)];

    String target = 'local';
    final l = AppLocalizations.of(context);
    String targetName = widget.item.name;
    bool createOnTarget = false;

    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: TuneColors.surface,
          title: Text(l.plTransferPlaylistTitle, style: TuneFonts.title3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: target,
                isExpanded: true,
                dropdownColor: TuneColors.surfaceVariant,
                items: allTargets.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s == 'local' ? l.plLocal : s.toUpperCase()),
                )).toList(),
                onChanged: (v) => setD(() {
                  target = v ?? 'local';
                  createOnTarget = target != 'local';
                }),
              ),
              TextField(
                controller: TextEditingController(text: targetName),
                onChanged: (v) => targetName = v,
                decoration: InputDecoration(labelText: l.plNameLabel),
              ),
              if (target != 'local') ...[
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: createOnTarget,
                  onChanged: (v) => setD(() => createOnTarget = v ?? false),
                  title: Text(l.plCreateOnRemote, style: TuneFonts.footnote),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.btnCancel)),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent),
              child: Text(l.plTransfer),
            ),
          ],
        ),
      ),
    );
    if (go != true || !mounted) return;

    try {
      final result = await app.apiClient!.transferPlaylist(
        sourceService: widget.item.service,
        sourcePlaylistId: widget.item.id,
        targetService: target,
        targetName: targetName,
        createOnTarget: createOnTarget,
      ) as Map<String, dynamic>?;
      if (!mounted) return;
      final matched = result?['matched'] ?? 0;
      final approx = result?['approximate'] ?? 0;
      final notFound = result?['not_found'] ?? 0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.plTransferDone('$matched', '$approx', '$notFound'))),
      );
      widget.onChanged();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.errorWith(e.toString()))));
    }
  }

  Future<void> _recover() async {
    if (!widget.item.isLocal) return;
    final app = context.read<AppState>();
    final l = AppLocalizations.of(context);
    try {
      final result = await app.apiClient!.recoverPlaylist(int.parse(widget.item.id));
      if (!mounted) return;
      final alternatives = (result['alternatives'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final available = (result['available'] as int?) ?? 0;
      final recovered = alternatives.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.plRecoverDone(available, recovered))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.errorWith(e.toString()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(widget.item.name, style: TuneFonts.title3, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: l.plTransfer,
            onPressed: _transfer,
          ),
          if (widget.item.isLocal)
            IconButton(
              icon: const Icon(Icons.healing),
              tooltip: l.plRecover,
              onPressed: _recover,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: TuneColors.accent))
          : _tracks.isEmpty
              ? Center(child: Text(l.playlistEmpty, style: TuneFonts.body))
              : ListView.separated(
                  itemCount: _tracks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: TuneColors.divider),
                  itemBuilder: (_, i) {
                    final t = _tracks[i];
                    return ListTile(
                      dense: true,
                      leading: Text('${i + 1}', style: TuneFonts.footnote),
                      title: Text(t['title'] as String? ?? '—', style: TuneFonts.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(t['artist_name'] as String? ?? '', style: TuneFonts.footnote, maxLines: 1, overflow: TextOverflow.ellipsis),
                    );
                  },
                ),
    );
  }
}
