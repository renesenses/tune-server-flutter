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
                    color: const Color(0xFF1DB954)),
      'youtube' => (name: 'YouTube', icon: Icons.smart_display_rounded,
                    color: const Color(0xFFFF0000)),
      _         => (name: serviceId, icon: Icons.cloud_rounded,
                    color: TuneColors.accent),
    };
