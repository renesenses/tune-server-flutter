import 'package:flutter/material.dart';

import '../helpers/tune_colors.dart';
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

  static const _navItems = [
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
      body: Row(
        children: [
          _Sidebar(
            selectedIndex: _selectedIndex,
            items: _navItems
                .map((n) => _SidebarItem(
                      icon: n.icon,
                      activeIcon: n.activeIcon,
                      label: n.label,
                    ))
                .toList(),
            onItemTap: (i) => setState(() => _selectedIndex = i),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  static final _pages = [
    const _PlaceholderDetail(icon: Icons.library_music_rounded,
        label: 'Bibliothèque'),
    const _PlaceholderDetail(icon: Icons.search_rounded,
        label: 'Recherche'),
    const _PlaceholderDetail(icon: Icons.cloud_rounded, label: 'Streaming'),
    const _PlaceholderDetail(icon: Icons.radio_rounded, label: 'Radios'),
    const _PlaceholderDetail(icon: Icons.settings_rounded,
        label: 'Paramètres'),
  ];
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

// ---------------------------------------------------------------------------
// Placeholder (remplacé en phases 11-16)
// ---------------------------------------------------------------------------

class _PlaceholderDetail extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlaceholderDetail({required this.icon, required this.label});

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
