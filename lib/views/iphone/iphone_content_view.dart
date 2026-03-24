import 'package:flutter/material.dart';

import '../components/mini_player_view.dart';
import '../helpers/tune_colors.dart';
import '../library/library_view.dart';
import '../radios/radios_view.dart';
import '../search/search_view.dart';
import '../settings/settings_view.dart';
import '../streaming/streaming_view.dart';

// ---------------------------------------------------------------------------
// T10.4 — iPhoneContentView
// BottomNavigationBar 5 onglets + MiniPlayerView au-dessus de la tab bar.
// Les pages seront remplacées par les vraies vues dans les phases 11-16.
// Miroir de iPhoneContentView.swift (TabView iOS)
// ---------------------------------------------------------------------------

class iPhoneContentView extends StatefulWidget {
  const iPhoneContentView({super.key});

  @override
  State<iPhoneContentView> createState() => _iPhoneContentViewState();
}

class _iPhoneContentViewState extends State<iPhoneContentView> {
  int _selectedIndex = 0;

  static const _tabs = [
    (
      icon: Icons.library_music_outlined,
      activeIcon: Icons.library_music_rounded,
      label: 'Bibliothèque',
    ),
    (
      icon: Icons.search_rounded,
      activeIcon: Icons.search_rounded,
      label: 'Recherche',
    ),
    (
      icon: Icons.cloud_outlined,
      activeIcon: Icons.cloud_rounded,
      label: 'Streaming',
    ),
    (
      icon: Icons.radio_outlined,
      activeIcon: Icons.radio_rounded,
      label: 'Radios',
    ),
    (
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Paramètres',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
        items: _tabs
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
    const SearchView(),
    const StreamingView(),
    const RadiosView(),
    const SettingsView(),
  ];
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
