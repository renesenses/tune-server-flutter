import 'package:flutter/material.dart';

import '../helpers/tune_colors.dart';

// ---------------------------------------------------------------------------
// Helpers partagés — vues streaming
// ---------------------------------------------------------------------------

/// Informations affichées pour chaque service de streaming.
({String name, IconData icon, Color color}) serviceInfo(String serviceId) =>
    switch (serviceId) {
      'qobuz'   => (name: 'Qobuz',   icon: Icons.album_rounded,
                    color: const Color(0xFF2C54A5)),
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

// ---------------------------------------------------------------------------
// ServiceBadge — small branded pill for streaming sources
// Shows "TIDAL", "QOBUZ", etc. with service-branded colors.
// Returns SizedBox.shrink() for "local" or null sources.
// ---------------------------------------------------------------------------

class ServiceBadge extends StatelessWidget {
  /// The source string from a Track (e.g. "tidal", "qobuz", "local").
  final String? source;

  /// Compact mode uses smaller font/padding (for mini player, queue items).
  final bool compact;

  const ServiceBadge({super.key, required this.source, this.compact = false});

  /// Streaming service IDs that should display a badge.
  static const _streamingSources = {
    'tidal', 'qobuz', 'deezer', 'spotify', 'youtube', 'amazon',
  };

  /// Whether the given source is a streaming service (badge-worthy).
  static bool isStreaming(String? source) =>
      source != null && _streamingSources.contains(source);

  @override
  Widget build(BuildContext context) {
    if (source == null || !_streamingSources.contains(source)) {
      return const SizedBox.shrink();
    }

    final info = serviceInfo(source!);
    final bgColor = info.color;
    // Tidal uses dark text on cyan background for readability.
    final textColor = source == 'tidal' ? const Color(0xFF0A0A0A) : Colors.white;

    final fontSize = compact ? 8.0 : 9.0;
    final hPad = compact ? 4.0 : 6.0;
    final vPad = compact ? 1.0 : 2.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        info.name.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.3,
          height: 1.2,
        ),
      ),
    );
  }
}
