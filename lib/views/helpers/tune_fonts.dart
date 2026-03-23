import 'package:flutter/material.dart';

import 'tune_colors.dart';

// ---------------------------------------------------------------------------
// TuneFonts — typographie miroir SF Pro iOS
// ---------------------------------------------------------------------------

abstract final class TuneFonts {
  // --- Titres ---
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 0.4,
    color: TuneColors.textPrimary,
  );
  static const TextStyle title1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold,
    color: TuneColors.textPrimary,
  );
  static const TextStyle title2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w600,
    color: TuneColors.textPrimary,
  );
  static const TextStyle title3 = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600,
    color: TuneColors.textPrimary,
  );

  // --- Corps ---
  static const TextStyle body = TextStyle(
    fontSize: 17, fontWeight: FontWeight.normal,
    color: TuneColors.textPrimary,
  );
  static const TextStyle callout = TextStyle(
    fontSize: 16, fontWeight: FontWeight.normal,
    color: TuneColors.textPrimary,
  );
  static const TextStyle subheadline = TextStyle(
    fontSize: 15, fontWeight: FontWeight.normal,
    color: TuneColors.textSecondary,
  );
  static const TextStyle footnote = TextStyle(
    fontSize: 13, fontWeight: FontWeight.normal,
    color: TuneColors.textSecondary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.normal,
    color: TuneColors.textTertiary,
  );

  // --- Mini player ---
  static const TextStyle miniTitle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: TuneColors.textPrimary,
  );
  static const TextStyle miniArtist = TextStyle(
    fontSize: 13, fontWeight: FontWeight.normal,
    color: TuneColors.textSecondary,
  );
}
