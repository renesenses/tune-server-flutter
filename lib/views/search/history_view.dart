import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/domain_models.dart';
import '../../server/database/database.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T15.3 — HistoryView
// Historique des pistes récemment jouées (en mémoire, max 100).
// Miroir de HistoryView.swift (iOS)
// ---------------------------------------------------------------------------

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final history = context.watch<LibraryState>().history;
    final app = context.read<AppState>();

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.historyTitle, style: TuneFonts.title3),
        actions: [
          if (history.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, app),
              child: Text(l.historyClear,
                  style: const TextStyle(color: TuneColors.accent)),
            ),
        ],
      ),
      body: history.isEmpty
          ? const _EmptyHistory()
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: history.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 72, color: TuneColors.divider),
              itemBuilder: (_, i) => _HistoryTile(
                entry: history[i],
                onTap: () => app.playTracks([history[i].track as Track]),
              ),
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, AppState app) async {
    final l = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TuneColors.surface,
        title: Text(l.historyClearTitle, style: TuneFonts.title3),
        content: Text(l.actionIrreversible, style: TuneFonts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.btnCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.historyClear,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) app.clearHistory();
  }
}

// ---------------------------------------------------------------------------
// _HistoryTile
// ---------------------------------------------------------------------------

class _HistoryTile extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onTap;
  const _HistoryTile({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final track = entry.track as Track;
    final badge = _audioBadge(track);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: ArtworkView(filePath: track.coverPath, size: 44),
      ),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (track.artistName != null)
            Text(track.artistName!,
                style: TuneFonts.footnote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          Row(
            children: [
              Text(entry.zoneName,
                  style: TuneFonts.caption
                      .copyWith(color: TuneColors.textTertiary)),
              const Text(' · ',
                  style: TextStyle(
                      fontSize: 10, color: TuneColors.textTertiary)),
              Text(_formatDate(entry.playedAt),
                  style: TuneFonts.caption
                      .copyWith(color: TuneColors.textTertiary)),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: TuneColors.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(badge,
                  style: const TextStyle(
                      fontSize: 9,
                      fontFamily: 'monospace',
                      color: TuneColors.textSecondary)),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.play_circle_outline_rounded,
              size: 24, color: TuneColors.accent),
        ],
      ),
    );
  }

  static String? _audioBadge(Track track) {
    final fmt = track.format?.toLowerCase() ?? '';
    if (fmt == 'dsd' || fmt == 'dsf' || fmt == 'dff') return 'DSD';
    if (fmt == 'flac' || fmt == 'alac') {
      final sr = track.sampleRate ?? 0;
      final bd = track.bitDepth ?? 0;
      if (sr > 48000 || bd > 16) return 'Hi-Res';
      if (fmt == 'flac') return 'FLAC';
      if (fmt == 'alac') return 'ALAC';
    }
    return null;
  }

  static String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'À l\'instant';
      if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
      if (diff.inDays == 1) return 'Hier';
      if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

// ---------------------------------------------------------------------------
// _EmptyHistory
// ---------------------------------------------------------------------------

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history_rounded,
              size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).historyEmpty,
              style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}
