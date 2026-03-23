import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// TuneColors — palette design system
// Inspiré du design iOS sombre (UIColor.systemBackground, systemGray…)
// ---------------------------------------------------------------------------

abstract final class TuneColors {
  // --- Fonds ---
  static const Color background     = Color(0xFF0F0F0F);
  static const Color surface        = Color(0xFF1C1C1E);
  static const Color surfaceVariant = Color(0xFF2C2C2E);
  static const Color surfaceHigh    = Color(0xFF3A3A3C);

  // --- Accent (indigo/violet — signature Tune Server) ---
  static const Color accent         = Color(0xFF6C63FF);
  static const Color accentLight    = Color(0xFF9C95FF);

  // --- Textes ---
  static const Color textPrimary    = Color(0xFFFFFFFF);
  static const Color textSecondary  = Color(0xFF8E8E93); // iOS systemGray
  static const Color textTertiary   = Color(0xFF636366);

  // --- Feedback ---
  static const Color error          = Color(0xFFFF453A);
  static const Color success        = Color(0xFF30D158);
  static const Color warning        = Color(0xFFFFD60A);

  // --- Séparateur ---
  static const Color divider        = Color(0xFF38383A);

  // --- Mini player ---
  static const Color miniPlayerBg   = Color(0xFF1C1C1E);
  static const Color miniPlayerBar  = Color(0xFF242426);
}
