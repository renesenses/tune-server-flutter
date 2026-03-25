import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
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
                track: history[i],
                onTap: () => app.playTracks([history[i]]),
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
  final dynamic track;
  final VoidCallback onTap;
  const _HistoryTile({required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ArtworkView(filePath: track.coverPath, size: 44),
      ),
      title: Text(track.title,
          style: TuneFonts.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: _subtitle,
    );
  }

  Widget? get _subtitle {
    final parts = <String>[
      if (track.artistName != null) track.artistName as String,
      if (track.albumTitle != null) track.albumTitle as String,
    ];
    if (parts.isEmpty) return null;
    return Text(parts.join(' · '),
        style: TuneFonts.footnote,
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }
}

// ---------------------------------------------------------------------------
// Placeholder
// ---------------------------------------------------------------------------

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history_rounded, size: 56, color: TuneColors.textTertiary),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).historyEmpty, style: TuneFonts.subheadline),
        ],
      ),
    );
  }
}
