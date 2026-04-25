import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// PartyView — Party mode: add tracks, vote on queue, share link
// ---------------------------------------------------------------------------

class PartyView extends StatefulWidget {
  const PartyView({super.key});

  @override
  State<PartyView> createState() => _PartyViewState();
}

class _PartyViewState extends State<PartyView> {
  final _searchController = TextEditingController();
  Map<String, dynamic>? _partyStatus;
  List<dynamic> _queue = [];
  Timer? _pollTimer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  int? get _zoneId => context.read<ZoneState>().currentZoneId;

  Future<void> _loadStatus() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final status = await api.getPartyStatus();
      final queue = await api.getPartyQueue(zoneId: _zoneId);
      if (!mounted) return;
      setState(() {
        _partyStatus = status;
        _queue = queue;
        _loading = false;
      });
      _startPolling();
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
  }

  Future<void> _poll() async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      final status = await api.getPartyStatus();
      final queue = await api.getPartyQueue(zoneId: _zoneId);
      if (!mounted) return;
      setState(() {
        _partyStatus = status;
        _queue = queue;
      });
    } catch (_) {}
  }

  Future<void> _addTrack() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      await api.partyAddTrack(query, zoneId: _zoneId);
      _searchController.clear();
      await _poll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding track: $e')),
        );
      }
    }
  }

  Future<void> _vote(int position) async {
    final api = context.read<AppState>().apiClient;
    if (api == null) return;
    try {
      await api.partyVote(position, zoneId: _zoneId);
      await _poll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vote error: $e')),
        );
      }
    }
  }

  void _sharePartyLink() {
    final host = context.read<AppState>().settingsState.remoteHost;
    final port = context.read<AppState>().settingsState.remotePort;
    final link = 'http://$host:$port/party';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Party link copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text('Party Mode', style: TuneFonts.title2),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            color: TuneColors.textSecondary,
            tooltip: 'Share party link',
            onPressed: _sharePartyLink,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Current track card
                if (_partyStatus != null) _CurrentTrackCard(status: _partyStatus!),

                // Add track input
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TuneFonts.body,
                          decoration: InputDecoration(
                            hintText: 'Add a track...',
                            hintStyle: TuneFonts.subheadline,
                            filled: true,
                            fillColor: TuneColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          onSubmitted: (_) => _addTrack(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: TuneColors.accent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        onPressed: _addTrack,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),

                // Queue header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text('Queue',
                          style: TuneFonts.title3),
                      const Spacer(),
                      Text('${_queue.length} tracks',
                          style: TuneFonts.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Queue list
                Expanded(
                  child: _queue.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.queue_music_rounded,
                                  size: 48, color: TuneColors.textTertiary),
                              const SizedBox(height: 8),
                              Text('Queue is empty',
                                  style: TuneFonts.subheadline),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _queue.length,
                          itemBuilder: (_, i) {
                            final item = _queue[i] as Map<String, dynamic>;
                            return _QueueItemTile(
                              item: item,
                              position: i,
                              onVote: () => _vote(i),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Current Track Card
// ---------------------------------------------------------------------------

class _CurrentTrackCard extends StatelessWidget {
  final Map<String, dynamic> status;
  const _CurrentTrackCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final current = status['current_track'] as Map<String, dynamic>?;
    final zoneName = status['zone_name'] as String? ?? 'Unknown zone';

    if (current == null) return const SizedBox.shrink();

    final title = current['title'] as String? ?? 'Unknown';
    final artist = current['artist'] as String?;
    final cover = current['cover_path'] as String?;

    return Card(
      margin: const EdgeInsets.all(16),
      color: TuneColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ArtworkView(filePath: cover, size: 64, cornerRadius: 8),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Now playing', style: TuneFonts.caption),
                  Text(title,
                      style: TuneFonts.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (artist != null)
                    Text(artist,
                        style: TuneFonts.footnote,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  Text(zoneName, style: TuneFonts.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Queue Item Tile
// ---------------------------------------------------------------------------

class _QueueItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final int position;
  final VoidCallback onVote;

  const _QueueItemTile({
    required this.item,
    required this.position,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final title = item['title'] as String? ?? 'Unknown';
    final artist = item['artist'] as String?;
    final votes = item['votes'] as int? ?? 0;
    final cover = item['cover_path'] as String?;

    return ListTile(
      leading: ArtworkView(filePath: cover, size: 44, cornerRadius: 6),
      title: Text(title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: artist != null
          ? Text(artist,
              style: TuneFonts.footnote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vote count badge
          if (votes > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('$votes',
                  style: TuneFonts.caption.copyWith(color: TuneColors.accent)),
            ),
          // Vote button
          IconButton(
            icon: const Icon(Icons.arrow_upward_rounded),
            color: TuneColors.accent,
            tooltip: 'Upvote',
            onPressed: onVote,
          ),
        ],
      ),
    );
  }
}
