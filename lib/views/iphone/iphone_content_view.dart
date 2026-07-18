import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/settings_state.dart';
import '../dj/dj_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/library_view.dart';
import '../party/party_view.dart';
import '../podcasts/podcasts_view.dart';
import '../radios/radios_view.dart';
import '../collections/collections_view.dart';
import '../collections/smart_collections_view.dart';
import '../settings/settings_view.dart';
import '../smart_playlists/smart_playlists_view.dart';
import '../streaming/streaming_view.dart';
import '../admin/admin_dashboard_view.dart';
import '../alarms/alarms_view.dart';
import '../browse/browse_library_view.dart';
import '../dashboard/dashboard_view.dart';
import '../diagnostics/diagnostics_view.dart';
import '../library/duplicates_view.dart';
import '../library/genre_tree_view.dart';
import '../search/global_search_overlay.dart';
import '../zones/zones_view.dart';

// ---------------------------------------------------------------------------
// T10.4 — iPhoneContentView
// BottomNavigationBar 5 onglets + MiniPlayerView au-dessus de la tab bar.
// More tab lists DJ, Party, Smart Playlists, Podcasts, Settings.
// Miroir de iPhoneContentView.swift (TabView iOS)
// ---------------------------------------------------------------------------

class iPhoneContentView extends StatefulWidget {
  const iPhoneContentView({super.key});

  @override
  State<iPhoneContentView> createState() => _iPhoneContentViewState();
}

class _iPhoneContentViewState extends State<iPhoneContentView> {
  int _selectedIndex = 0;

  static const _rootPages = [
    LibraryView(),
    StreamingView(),
    ZonesView(),
    RadiosView(),
    _MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tabs = [
      (icon: Icons.library_music_outlined,   activeIcon: Icons.library_music_rounded,   label: l.navLibrary),
      (icon: Icons.cloud_outlined,           activeIcon: Icons.cloud_rounded,           label: l.navStreaming),
      (icon: Icons.speaker_group_outlined,   activeIcon: Icons.speaker_group_rounded,   label: l.navZones),
      (icon: Icons.radio_outlined,           activeIcon: Icons.radio_rounded,           label: l.navRadios),
      (icon: Icons.more_horiz_rounded,       activeIcon: Icons.more_horiz_rounded,      label: 'More'),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (nav.canPop()) nav.pop();
      },
      child: Scaffold(
        backgroundColor: TuneColors.background,
        // The player sheet is now mounted globally (above the Navigator) in
        // main.dart so the mini-player survives sub-page pushes into folders
        // (#1088). The body is just the tab content here.
        body: Column(
          children: [
              Expanded(
                // Tab pages: IndexedStack keeps every tab alive and shows only
                // the active one, laying all children out at full size — the
                // active page always has proper constraints.
                //
                // The pages are placed DIRECTLY (no per-tab Navigator). The
                // previous approach wrapped each tab in a Navigator whose root
                // route was a MaterialPageRoute: nested inside an IndexedStack,
                // that route left the content BLACK on the first frame on some
                // Android GPUs (Elie, Xiaomi/Android 16, portrait) — its
                // entrance transition/opacity never resolved for a non-top-level
                // Navigator. The iPad layout renders the page straight into an
                // Expanded and never shows the black; this mirrors it. Sub-page
                // pushes now go to the root Navigator (full-screen), which is
                // fine and matches the iPad behaviour.
                child: IndexedStack(
                  index: _selectedIndex,
                  sizing: StackFit.expand,
                  children: _rootPages,
                ),
              ),
              // Reserve space for the mini player at the bottom so content
              // is not hidden behind the sheet when collapsed.
              const SizedBox(height: 72),
            ],
          ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: tabs
              .map((t) => BottomNavigationBarItem(
                    icon: Icon(t.icon),
                    activeIcon: Icon(t.activeIcon),
                    label: t.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// More view — lists extra sections
// ---------------------------------------------------------------------------

class _MoreView extends StatelessWidget {
  const _MoreView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isRemote = context.watch<SettingsState>().isRemoteMode;
    final items = [
      if (isRemote)
        (icon: Icons.folder_rounded,           label: 'Repertoires',       page: const BrowseLibraryView()),
      (icon: Icons.collections_bookmark_rounded, label: 'Collections',  page: const CollectionsView()),
      (icon: Icons.auto_awesome_motion_rounded, label: 'Smart Collections', page: const SmartCollectionsView()),
      // Party + DJ require routes only the remote Python server provides.
      if (isRemote)
        (icon: Icons.album_rounded,          label: 'DJ Mode',           page: const DJView()),
      if (isRemote)
        (icon: Icons.celebration_rounded,    label: 'Party Mode',        page: const PartyView()),
      (icon: Icons.auto_awesome_rounded,   label: 'Smart Playlists',   page: const SmartPlaylistsView()),
      (icon: Icons.podcasts_rounded,       label: l.navPodcasts,       page: const PodcastsView()),
      if (isRemote)
        (icon: Icons.alarm_rounded,        label: 'Alarmes',           page: const AlarmsView()),
      if (isRemote)
        (icon: Icons.account_tree_rounded, label: 'Genre Tree',        page: const GenreTreeView()),
      (icon: Icons.bar_chart_rounded,       label: 'Dashboard',         page: const DashboardView()),
      (icon: Icons.find_replace_rounded,   label: 'Duplicates',        page: const DuplicatesView()),
      if (isRemote)
        (icon: Icons.monitor_heart_rounded, label: 'Diagnostics',      page: const DiagnosticsView()),
      if (isRemote)
        (icon: Icons.dashboard_rounded,     label: 'Admin',            page: const AdminDashboardView()),
      (icon: Icons.settings_rounded,       label: l.navSettings,       page: const SettingsView()),
    ];

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text('More', style: TuneFonts.title2),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.search_rounded,
                  color: TuneColors.textSecondary),
              tooltip: AppLocalizations.of(ctx).navSearch,
              onPressed: () => showGlobalSearch(ctx),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: TuneColors.divider, indent: 56),
        itemBuilder: (_, i) {
          final item = items[i];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: TuneColors.accent, size: 22),
            ),
            title: Text(item.label, style: TuneFonts.body),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TuneColors.textTertiary),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item.page),
            ),
          );
        },
      ),
    );
  }
}

