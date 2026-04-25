import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../components/mini_player_view.dart';
import '../dj/dj_view.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import '../library/library_view.dart';
import '../party/party_view.dart';
import '../podcasts/podcasts_view.dart';
import '../radios/radios_view.dart';
import '../settings/settings_view.dart';
import '../smart_playlists/smart_playlists_view.dart';
import '../streaming/streaming_view.dart';
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

    return Scaffold(
      backgroundColor: TuneColors.background,
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),
          const MiniPlayerView(),
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
    );
  }

  static final _pages = [
    const LibraryView(),
    const StreamingView(),
    const ZonesView(),
    const RadiosView(),
    const _MoreView(),
  ];
}

// ---------------------------------------------------------------------------
// More view — lists extra sections
// ---------------------------------------------------------------------------

class _MoreView extends StatelessWidget {
  const _MoreView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = [
      (icon: Icons.album_rounded,          label: 'DJ Mode',           page: const DJView()),
      (icon: Icons.celebration_rounded,    label: 'Party Mode',        page: const PartyView()),
      (icon: Icons.auto_awesome_rounded,   label: 'Smart Playlists',   page: const SmartPlaylistsView()),
      (icon: Icons.podcasts_rounded,       label: l.navPodcasts,       page: const PodcastsView()),
      (icon: Icons.settings_rounded,       label: l.navSettings,       page: const SettingsView()),
    ];

    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text('More', style: TuneFonts.title2),
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

// ---------------------------------------------------------------------------
// Placeholder (remplacé en phases 11-16)
// ---------------------------------------------------------------------------

class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlaceholderPage({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: TuneColors.textTertiary),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(color: TuneColors.textTertiary)),
          ],
        ),
      ),
    );
  }
}
