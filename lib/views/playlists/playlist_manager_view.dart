import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

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
  bool _loading = false;

  // Backup
  bool _backingUp = false;
  Map<String, dynamic>? _backupResult;

  // Batch
  String _batchSource = '';
  bool _batching = false;
  Map<String, dynamic>? _batchResult;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
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
      if (_tabCtrl.index == 1) {
        final data = await app.apiClient!.getTransferHistory();
        _history = data.cast<Map<String, dynamic>>();
      } else if (_tabCtrl.index == 2) {
        final data = await app.apiClient!.getPlaylistLinks();
        _links = data.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Gestionnaire', style: TuneFonts.title3),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: TuneColors.accent,
          labelColor: TuneColors.accent,
          unselectedLabelColor: TuneColors.textSecondary,
          tabs: const [
            Tab(text: 'Playlists'),
            Tab(text: 'Transferts'),
            Tab(text: 'Sync'),
            Tab(text: 'Backup'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _PlaylistsTab(),
          _buildHistoryTab(),
          _buildSyncTab(),
          _buildBackupTab(),
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
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz_rounded, size: 48, color: TuneColors.textTertiary),
            SizedBox(height: 12),
            Text('Aucun transfert', style: TuneFonts.body),
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: TuneColors.accent));
    }
    if (_links.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sync_rounded, size: 48, color: TuneColors.textTertiary),
            SizedBox(height: 12),
            Text('Aucun lien de sync', style: TuneFonts.body),
            SizedBox(height: 4),
            Text('Créez des liens depuis le transfert', style: TuneFonts.footnote),
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
            title: Text('Playlist #${link['local_playlist_id']}', style: TuneFonts.body),
            subtitle: Text('${link['service']} · ${link['sync_direction']}', style: TuneFonts.footnote),
            trailing: FilledButton(
              onPressed: () async {
                final app = context.read<AppState>();
                await app.apiClient?.triggerPlaylistSync(link['id'] as int);
                _loadTab();
              },
              style: FilledButton.styleFrom(backgroundColor: TuneColors.accent, minimumSize: const Size(60, 32)),
              child: const Text('Sync', style: TextStyle(fontSize: 12)),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Backup
          const Text('BACKUP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
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
                } catch (_) {}
                setState(() => _backingUp = false);
              },
              icon: const Icon(Icons.backup_rounded),
              label: Text(_backingUp ? 'Backup en cours...' : 'Backup toutes les playlists'),
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
                  Text('${_backupResult!['playlists_backed_up']} playlists · ${_backupResult!['total_tracks_snapshot']} tracks',
                      style: TuneFonts.footnote),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(color: TuneColors.divider),
          const SizedBox(height: 16),

          // Batch Transfer
          const Text('BATCH TRANSFER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TuneColors.textTertiary, letterSpacing: 1)),
          const SizedBox(height: 8),
          const Text('Transférer toutes les playlists d\'un service', style: TuneFonts.footnote),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _batchSource.isEmpty ? null : _batchSource,
                  decoration: InputDecoration(
                    labelText: 'Source',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true, fillColor: TuneColors.surface,
                  ),
                  dropdownColor: TuneColors.surfaceVariant,
                  items: authServices.map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
                  onChanged: (v) => setState(() => _batchSource = v ?? ''),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.arrow_forward, color: TuneColors.textTertiary)),
              const Text('Local', style: TuneFonts.body),
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
              label: Text(_batching ? 'Transfert...' : 'Transférer tout'),
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
              child: Text('${_batchResult!['total_playlists']} playlists — ${_batchResult!['status']}', style: TuneFonts.footnote),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Playlists Tab (placeholder — reuses existing PlaylistsView)
// ---------------------------------------------------------------------------

class _PlaylistsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Voir l\'onglet Playlists dans Bibliothèque', style: TuneFonts.body),
    );
  }
}
