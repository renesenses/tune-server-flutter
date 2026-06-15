import 'package:flutter/material.dart';

import '../helpers/tune_colors.dart';

// ---------------------------------------------------------------------------
// Helpers partagés — vues streaming
// ---------------------------------------------------------------------------

/// Informations affichées pour chaque service de streaming.
({String name, IconData icon, Color color}) serviceInfo(String serviceId) =>
    switch (serviceId) {
      'qobuz'   => (name: 'Qobuz',   icon: Icons.album_rounded,
                    color: const Color(0xFF2563EB)),
      'tidal'   => (name: 'Tidal',   icon: Icons.waves_rounded,
                    color: const Color(0xFF00FFFF)),
      'spotify' => (name: 'Spotify', icon: Icons.music_note_rounded,
                    color: const Color(0xFF1DB954)),
      'deezer'  => (name: 'Deezer',  icon: Icons.equalizer_rounded,
                    color: const Color(0xFFA238FF)),
      'amazon'  => (name: 'Amazon',  icon: Icons.shopping_bag_rounded,
                    color: const Color(0xFFFF9900)),
      'youtube' => (name: 'YouTube', icon: Icons.smart_display_rounded,
                    color: const Color(0xFFFF0000)),
      _         => (name: serviceId, icon: Icons.cloud_rounded,
                    color: TuneColors.accent),
    };
