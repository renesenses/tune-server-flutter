import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../state/library_state.dart';
import '../../state/zone_state.dart';
import '../browse/browse_view.dart';
import '../helpers/artwork_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'history_view.dart';

// ---------------------------------------------------------------------------
// T15.2 — HomeView
// Affiché dans SearchView quand aucune requête n'est active.
// Récents, statistiques, accès rapide.
// Miroir de HomeView.swift (iOS)
// ---------------------------------------------------------------------------

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lib = context.watch<LibraryState>();
    final zones = context.watch<ZoneState>();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // ---- Récents ----
        if (lib.history.isNotEmpty) ...[
          _SectionTitle(
            title: l.homeRecentlyPlayed,
            trailingLabel: l.btnSeeAll,
            onTrailingTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryView()),
            ),
          ),
          _RecentsList(tracks: lib.history),
          const SizedBox(height: 16),
        ],

        // ---- Statistiques bibliothèque ----
        if (lib.stats != null || lib.totalTracks > 0) ...[
          _SectionTitle(title: l.homeLibrary),
          _StatsRow(lib: lib),
          const SizedBox(height: 16),
        ],

        // ---- Accès rapide ----
        _SectionTitle(title: l.homeQuickAccess),
        _QuickAccessGrid(
          hasServers: zones.servers.isNotEmpty,
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section title
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  const _SectionTitle({
    required this.title,
    this.trailingLabel,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 12, 8),
      child: Row(
        children: [
          Text(title,
              style: TuneFonts.subheadline
                  .copyWith(color: TuneColors.textPrimary)),
          const Spacer(),
          if (trailingLabel != null)
            TextButton(
              onPressed: onTrailingTap,
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4)),
              child: Text(trailingLabel!,
                  style: const TextStyle(
                      color: TuneColors.accent, fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Récents — défilement horizontal
// ---------------------------------------------------------------------------

class _RecentsList extends StatelessWidget {
  final List tracks;
  const _RecentsList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final items = tracks.take(12).toList();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final track = items[i];
          return GestureDetector(
            onTap: () => app.playTracks([track]),
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ArtworkView(filePath: track.coverPath, size: 80),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    track.title,
                    style: TuneFonts.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Statistiques
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  final LibraryState lib;
  const _StatsRow({required this.lib});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatChip(
              icon: Icons.music_note_rounded,
              value: lib.totalTracks,
              label: l.homeStatTracks),
          const SizedBox(width: 8),
          _StatChip(
              icon: Icons.album_rounded,
              value: lib.totalAlbums,
              label: l.homeStatAlbums),
          const SizedBox(width: 8),
          _StatChip(
              icon: Icons.people_rounded,
              value: lib.totalArtists,
              label: l.homeStatArtists),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _StatChip(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: TuneColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: TuneColors.accent),
            const SizedBox(width: 6),
            Text(
              '$value $label',
              style: TuneFonts.footnote
                  .copyWith(color: TuneColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Accès rapide
// ---------------------------------------------------------------------------

class _QuickAccessGrid extends StatelessWidget {
  final bool hasServers;
  const _QuickAccessGrid({required this.hasServers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _QuickCard(
            icon: Icons.history_rounded,
            label: AppLocalizations.of(context).homeHistory,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryView()),
            ),
          ),
          if (hasServers)
            _QuickCard(
              icon: Icons.devices_rounded,
              label: AppLocalizations.of(context).homeBrowseDlna,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BrowseView()),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickCard(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: TuneColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TuneColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: TuneColors.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: TuneFonts.footnote
                      .copyWith(color: TuneColors.textPrimary),
                  maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}
