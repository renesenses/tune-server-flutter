import 'package:flutter/material.dart';

import 'tune_colors.dart';

// ---------------------------------------------------------------------------
// AppTheme — ThemeData dark pour MaterialApp
// ---------------------------------------------------------------------------

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: TuneColors.background,
    colorScheme: const ColorScheme.dark(
      primary: TuneColors.accent,
      secondary: TuneColors.accentLight,
      surface: TuneColors.surface,
      error: TuneColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: TuneColors.textPrimary,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: TuneColors.background,
      foregroundColor: TuneColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 17, fontWeight: FontWeight.w600,
        color: TuneColors.textPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: TuneColors.miniPlayerBar,
      selectedItemColor: TuneColors.accent,
      unselectedItemColor: TuneColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: TuneColors.surface,
      selectedIconTheme: IconThemeData(color: TuneColors.accent),
      unselectedIconTheme: IconThemeData(color: TuneColors.textTertiary),
      selectedLabelTextStyle: TextStyle(
          color: TuneColors.accent, fontSize: 12),
      unselectedLabelTextStyle: TextStyle(
          color: TuneColors.textTertiary, fontSize: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: TuneColors.divider,
      thickness: 0.5,
      space: 0,
    ),
    cardTheme: const CardThemeData(
      color: TuneColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    iconTheme: const IconThemeData(color: TuneColors.textSecondary),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: TuneColors.textSecondary,
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: TuneColors.accent,
      inactiveTrackColor: TuneColors.surfaceVariant,
      thumbColor: Colors.white,
      overlayColor: Color(0x336C63FF),
      trackHeight: 3.0,
    ),
    useMaterial3: true,
  );
}
