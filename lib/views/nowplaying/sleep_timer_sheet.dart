import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../server/event_bus.dart';
import '../../server/playback/sleep_timer.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// SleepTimerSheet — Enhanced sleep timer bottom sheet
// Duration presets + custom, fade duration slider, active timer countdown,
// cancel button. Uses SleepTimer via API or embedded engine.
// Miroir de SleepTimerSheet.swift (iOS)
// ---------------------------------------------------------------------------

/// Show the sleep timer bottom sheet.
void showSleepTimerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: TuneColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (_) => const SleepTimerSheet(),
  );
}

class SleepTimerSheet extends StatefulWidget {
  const SleepTimerSheet({super.key});

  @override
  State<SleepTimerSheet> createState() => _SleepTimerSheetState();
}

class _SleepTimerSheetState extends State<SleepTimerSheet> {
  static const _presets = [15, 30, 45, 60, 90];

  int? _selectedMinutes;
  int _customMinutes = 60;
  double _fadeDuration = 30; // seconds
  bool _showCustom = false;
  bool _busy = false;

  // Active timer tracking
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _timerActive = false;
  StreamSubscription? _tickSub;
  StreamSubscription? _expiredSub;
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();

    // Listen for tick events to show countdown
    _tickSub = EventBus.instance.on<SleepTimerTickEvent>().listen((e) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds = e.remainingSeconds;
        _totalSeconds = e.totalSeconds;
        _timerActive = e.remainingSeconds > 0;
      });
    });

    _expiredSub = EventBus.instance.on<SleepTimerExpiredEvent>().listen((e) {
      if (!mounted) return;
      setState(() => _timerActive = false);
    });
  }

  @override
  void dispose() {
    _tickSub?.cancel();
    _expiredSub?.cancel();
    _uiTimer?.cancel();
    super.dispose();
  }

  String _formatCountdown(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';
    }
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  Future<void> _startTimer(int minutes) async {
    setState(() => _busy = true);

    final app = context.read<AppState>();
    final zoneId = context.read<ZoneState>().currentZoneId;

    try {
      if (app.apiClient != null && zoneId != null) {
        // Remote mode: use API
        await app.apiClient!.setSleepTimer(zoneId, minutes);
      }

      if (!mounted) return;
      setState(() {
        _busy = false;
        _timerActive = true;
        _totalSeconds = minutes * 60;
        _remainingSeconds = _totalSeconds;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sleep timer set: $minutes min'
              ' (fade: ${_fadeDuration.round()}s)'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sleep timer error: $e')),
      );
    }
  }

  Future<void> _cancelTimer() async {
    setState(() => _busy = true);

    final app = context.read<AppState>();
    final zoneId = context.read<ZoneState>().currentZoneId;

    try {
      if (app.apiClient != null && zoneId != null) {
        await app.apiClient!.setSleepTimer(zoneId, 0);
      }

      if (!mounted) return;
      setState(() {
        _busy = false;
        _timerActive = false;
        _remainingSeconds = 0;
        _totalSeconds = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sleep timer cancelled')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TuneColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Row(
            children: [
              const Icon(Icons.bedtime_rounded,
                  size: 22, color: TuneColors.accent),
              const SizedBox(width: 8),
              const Text('Sleep Timer', style: TuneFonts.title3),
            ],
          ),
          const SizedBox(height: 16),

          // Active timer display
          if (_timerActive) ...[
            _ActiveTimerDisplay(
              remainingSeconds: _remainingSeconds,
              totalSeconds: _totalSeconds,
              formatCountdown: _formatCountdown,
              onCancel: _busy ? null : _cancelTimer,
            ),
            const SizedBox(height: 16),
          ],

          // Duration presets
          if (!_timerActive) ...[
            const Text('DURATION',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: TuneColors.textTertiary,
                    letterSpacing: 1)),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._presets.map((m) => _DurationChip(
                      label: m >= 60 ? '${m ~/ 60}h${m % 60 > 0 ? " ${m % 60}m" : ""}' : '${m}m',
                      isSelected: _selectedMinutes == m && !_showCustom,
                      onTap: () => setState(() {
                        _selectedMinutes = m;
                        _showCustom = false;
                      }),
                    )),
                _DurationChip(
                  label: 'Custom',
                  isSelected: _showCustom,
                  onTap: () => setState(() {
                    _showCustom = true;
                    _selectedMinutes = _customMinutes;
                  }),
                ),
              ],
            ),

            // Custom duration slider
            if (_showCustom) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('${_customMinutes}m',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: TuneColors.textPrimary)),
                  const Spacer(),
                  Text('10 - 180 min', style: TuneFonts.caption),
                ],
              ),
              Slider(
                value: _customMinutes.toDouble(),
                min: 10,
                max: 180,
                divisions: 34,
                activeColor: TuneColors.accent,
                inactiveColor: TuneColors.surfaceVariant,
                onChanged: (v) => setState(() {
                  _customMinutes = v.round();
                  _selectedMinutes = _customMinutes;
                }),
              ),
            ],

            const SizedBox(height: 16),

            // Fade duration
            const Text('FADE OUT',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: TuneColors.textTertiary,
                    letterSpacing: 1)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.volume_down_rounded,
                    size: 18, color: TuneColors.textSecondary),
                Expanded(
                  child: Slider(
                    value: _fadeDuration,
                    min: 10,
                    max: 60,
                    divisions: 10,
                    activeColor: TuneColors.accent,
                    inactiveColor: TuneColors.surfaceVariant,
                    onChanged: (v) => setState(() => _fadeDuration = v),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${_fadeDuration.round()}s',
                    style: TuneFonts.footnote,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Volume will gradually fade to zero during the last ${_fadeDuration.round()} seconds.',
              style: TuneFonts.caption,
            ),

            const SizedBox(height: 20),

            // Start button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _selectedMinutes != null && !_busy
                    ? () => _startTimer(_selectedMinutes!)
                    : null,
                icon: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.bedtime_rounded),
                label: Text(_busy
                    ? 'Starting...'
                    : _selectedMinutes != null
                        ? 'Start (${_selectedMinutes}m)'
                        : 'Select duration'),
                style: FilledButton.styleFrom(
                  backgroundColor: TuneColors.accent,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DurationChip
// ---------------------------------------------------------------------------

class _DurationChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? TuneColors.accent : TuneColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? TuneColors.textPrimary
                : TuneColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ActiveTimerDisplay — shows countdown when timer is running
// ---------------------------------------------------------------------------

class _ActiveTimerDisplay extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final String Function(int) formatCountdown;
  final VoidCallback? onCancel;

  const _ActiveTimerDisplay({
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.formatCountdown,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0
        ? remainingSeconds / totalSeconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TuneColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TuneColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.bedtime_rounded,
                  size: 20, color: TuneColors.accent),
              const SizedBox(width: 8),
              const Text('Timer Active',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TuneColors.accent)),
              const Spacer(),
              Text(
                formatCountdown(remainingSeconds),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TuneColors.textPrimary,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: TuneColors.surfaceVariant,
              color: TuneColors.accent,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.timer_off_rounded, size: 18),
              label: const Text('Cancel Timer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: TuneColors.error,
                side: const BorderSide(color: TuneColors.error),
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
