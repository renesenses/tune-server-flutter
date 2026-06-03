import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/settings_state.dart';
import '../collections/collections_view.dart';
import '../collections/smart_collections_view.dart';
import '../dj/dj_view.dart';
import '../helpers/tune_colors.dart';
import '../library/library_view.dart';
import '../party/party_view.dart';
import '../podcasts/podcasts_view.dart';
import '../radios/radio_favorites_view.dart';
import '../radios/radios_view.dart';
import '../settings/settings_view.dart';
import '../smart_playlists/smart_playlists_view.dart';
import '../streaming/streaming_view.dart';
import '../admin/admin_dashboard_view.dart';
import '../alarms/alarms_view.dart';
import '../dashboard/dashboard_view.dart';
import '../diagnostics/diagnostics_view.dart';
import '../library/duplicates_view.dart';
import '../library/genre_tree_view.dart';
import '../zones/zones_view.dart';
import 'ipad_now_playing_bar.dart';

// ---------------------------------------------------------------------------
// T10.5 — iPadContentView
// Sidebar NavigationRail + zone de contenu + iPadNowPlayingBar en bas de sidebar.
// Les pages seront remplacées par les vraies vues dans les phases 11-16.
// Miroir de iPadContentView.swift (NavigationSplitView iOS)
// ---------------------------------------------------------------------------

class iPadContentView extends StatefulWidget {
  const iPadContentView({super.key});

  @override
  State<iPadContentView> createState() => _iPadContentViewState();
}

class _iPadContentViewState extends State<iPadContentView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isRemote = context.watch<SettingsState>().isRemoteMode;

    // Sidebar entries: each carries its destination so filtering for
    // Party/DJ keeps nav and pages aligned without manual index math.
    final entries = <_NavEntry>[
      _NavEntry(Icons.library_music_outlined, Icons.library_music_rounded, l.navLibrary, const LibraryView()),
      _NavEntry(Icons.cloud_outlined, Icons.cloud_rounded, l.navStreaming, const StreamingView()),
      _NavEntry(Icons.speaker_group_outlined, Icons.speaker_group_rounded, l.navZones, const ZonesView()),
      _NavEntry(Icons.radio_outlined, Icons.radio_rounded, l.navRadios, const RadiosView()),
      _NavEntry(Icons.collections_bookmark_outlined, Icons.collections_bookmark_rounded, 'Collections', const CollectionsView()),
      _NavEntry(Icons.auto_awesome_motion_outlined, Icons.auto_awesome_motion_rounded, 'Smart Collections', const SmartCollectionsView()),
      _NavEntry(Icons.favorite_outline_rounded, Icons.favorite_rounded, 'Favoris Radio', const RadioFavoritesView()),
      // Party + DJ require server-side routes only the Python (remote)
      // server provides — hidden when running standalone.
      if (isRemote) _NavEntry(Icons.album_outlined, Icons.album_rounded, 'DJ', const DJView()),
      if (isRemote) _NavEntry(Icons.celebration_outlined, Icons.celebration_rounded, 'Party', const PartyView()),
      _NavEntry(Icons.auto_awesome_outlined, Icons.auto_awesome_rounded, 'Smart Playlists', const SmartPlaylistsView()),
      _NavEntry(Icons.podcasts_outlined, Icons.podcasts_rounded, l.navPodcasts, const PodcastsView()),
      if (isRemote) _NavEntry(Icons.alarm_outlined, Icons.alarm_rounded, 'Alarmes', const AlarmsView()),
      if (isRemote) _NavEntry(Icons.account_tree_outlined, Icons.account_tree_rounded, 'Genre Tree', const GenreTreeView()),
      _NavEntry(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Dashboard', const DashboardView()),
      _NavEntry(Icons.find_replace_outlined, Icons.find_replace_rounded, 'Duplicates', const DuplicatesView()),
      if (isRemote) _NavEntry(Icons.monitor_heart_outlined, Icons.monitor_heart_rounded, 'Diagnostics', const DiagnosticsView()),
      if (isRemote) _NavEntry(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Admin', const AdminDashboardView()),
      _NavEntry(Icons.settings_outlined, Icons.settings_rounded, l.navSettings, const SettingsView()),
    ];

    // Clamp the selection if entries shrank (mode switch hid the active page).
    final safeIndex = _selectedIndex < entries.length ? _selectedIndex : 0;

    return Scaffold(
      backgroundColor: TuneColors.background,
      body: Row(
        children: [
          _Sidebar(
            selectedIndex: safeIndex,
            items: entries
                .map((e) => _SidebarItem(
                      icon: e.icon,
                      activeIcon: e.activeIcon,
                      label: e.label,
                    ))
                .toList(),
            onItemTap: (i) => setState(() => _selectedIndex = i),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: entries[safeIndex].page),
        ],
      ),
    );
  }
}

class _NavEntry {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget page;

  const _NavEntry(this.icon, this.activeIcon, this.label, this.page);
}

// ---------------------------------------------------------------------------
// Sidebar
// ---------------------------------------------------------------------------

class _SidebarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _SidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final List<_SidebarItem> items;
  final ValueChanged<int> onItemTap;

  const _Sidebar({
    required this.selectedIndex,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: TuneColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête application
          const SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Icon(Icons.wifi_tethering_rounded,
                      color: TuneColors.accent, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Tune Server',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: TuneColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final selected = i == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      selected ? item.activeIcon : item.icon,
                      color: selected
                          ? TuneColors.accent
                          : TuneColors.textTertiary,
                      size: 22,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: selected
                            ? TuneColors.accent
                            : TuneColors.textPrimary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    selected: selected,
                    selectedTileColor:
                        TuneColors.accent.withValues(alpha: 0.12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onTap: () => onItemTap(i),
                  ),
                );
              },
            ),
          ),
          // Barre lecteur persistante en bas de la sidebar
          const iPadNowPlayingBar(),
        ],
      ),
    );
  }
}

