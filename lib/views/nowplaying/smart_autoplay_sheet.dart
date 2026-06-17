import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// Smart AutoPlay mood picker bottom sheet
// ---------------------------------------------------------------------------

/// Mood descriptor: API key, display label, emoji, accent color.
class _Mood {
  final String key;
  final String label;
  final String emoji;
  final Color color;

  const _Mood({
    required this.key,
    required this.label,
    required this.emoji,
    required this.color,
  });
}

const _moods = [
  _Mood(
    key: 'calm',
    label: 'Chill',
    emoji: '🌙',
    color: Color(0xFF6366f1), // indigo
  ),
  _Mood(
    key: 'party',
    label: 'Party',
    emoji: '🎉',
    color: Color(0xFFf59e0b), // amber
  ),
  _Mood(
    key: 'focus',
    label: 'Focus',
    emoji: '🎯',
    color: Color(0xFF8b5cf6), // purple
  ),
  _Mood(
    key: 'energetic',
    label: 'Energetic',
    emoji: '⚡',
    color: Color(0xFFef4444), // red
  ),
];

/// Shows the Smart AutoPlay mood picker bottom sheet.
void showSmartAutoPlaySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: TuneColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const SmartAutoPlaySheet(),
  );
}

class SmartAutoPlaySheet extends StatefulWidget {
  const SmartAutoPlaySheet({super.key});

  @override
  State<SmartAutoPlaySheet> createState() => _SmartAutoPlaySheetState();
}

class _SmartAutoPlaySheetState extends State<SmartAutoPlaySheet> {
  String? _loadingMoodKey;

  Future<void> _selectMood(BuildContext context, _Mood mood) async {
    if (_loadingMoodKey != null) return;

    final app = context.read<AppState>();
    final zoneState = context.read<ZoneState>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final api = app.apiClient;
    final zoneId = zoneState.currentZoneId;

    if (api == null || zoneId == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Aucune zone disponible')),
      );
      return;
    }

    setState(() => _loadingMoodKey = mood.key);

    try {
      // 1. Call mood API
      final result = await api.getMoodTracks(mood.key, limit: 20);
      final tracks = (result['tracks'] as List?)
          ?.map((t) => t as Map<String, dynamic>)
          .toList() ?? [];

      if (tracks.isEmpty) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text('Aucun titre trouvé pour ${mood.label}')),
          );
        }
        return;
      }

      final trackIds = tracks
          .map((t) => t['id'] as int?)
          .whereType<int>()
          .toList();

      if (trackIds.isEmpty) {
        if (mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Erreur : IDs de pistes invalides')),
          );
        }
        return;
      }

      // 2. Play or add to queue depending on queue state
      final queueIsEmpty = (zoneState.queueSnapshot?.tracks ?? []).isEmpty;

      if (queueIsEmpty) {
        await api.play(zoneId, {'track_ids': trackIds});
      } else {
        await api.addToQueue(zoneId, {'track_ids': trackIds});
      }

      await app.refreshZonesRemote();

      if (mounted) {
        navigator.pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '${mood.label} Mix : ${trackIds.length} titres '
              '${queueIsEmpty ? "en lecture" : "ajoutés à la queue"}',
            ),
            backgroundColor: mood.color,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Erreur Smart AutoPlay : $e'),
            backgroundColor: TuneColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMoodKey = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title row
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: TuneColors.accent, size: 22),
              const SizedBox(width: 8),
              Text('Smart AutoPlay', style: TuneFonts.title3),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Choisissez une ambiance pour générer une playlist intelligente',
            style: TuneFonts.caption.copyWith(color: TuneColors.textSecondary),
          ),
          const SizedBox(height: 20),
          // 2x2 mood grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: _moods
                .map((mood) => _MoodButton(
                      mood: mood,
                      isLoading: _loadingMoodKey == mood.key,
                      isDisabled: _loadingMoodKey != null &&
                          _loadingMoodKey != mood.key,
                      onTap: () => _selectMood(context, mood),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual mood button
// ---------------------------------------------------------------------------

class _MoodButton extends StatelessWidget {
  final _Mood mood;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onTap;

  const _MoodButton({
    required this.mood,
    required this.isLoading,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = isDisabled ? 0.4 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: mood.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: mood.color.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (isLoading)
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: mood.color,
                    ),
                  )
                else
                  Text(mood.emoji,
                      style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Text(
                  mood.label,
                  style: TuneFonts.body.copyWith(
                    color: mood.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
