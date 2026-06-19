import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';
import 'tune_master_profiler_screen.dart';

// ---------------------------------------------------------------------------
// EqualizerView — tabbed EQ screen
//
//   "Assistant" tab  →  TuneMasterProfilerScreen (perceptual 2-step wizard)
//   "Expert" tab     →  10-band parametric EQ with vertical sliders
//
// API:
//   GET/POST /zones/{zoneId}/eq        (10-band)
//   GET/POST /zones/{zoneId}/dsp       (EQ profile)
// ---------------------------------------------------------------------------

class EqualizerView extends StatelessWidget {
  const EqualizerView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: TuneColors.background,
        appBar: AppBar(
          backgroundColor: TuneColors.surface,
          title: const Text('Equalizer', style: TuneFonts.title3),
          bottom: TabBar(
            indicatorColor: TuneColors.accent,
            indicatorWeight: 2.5,
            labelColor: TuneColors.accent,
            unselectedLabelColor: TuneColors.textSecondary,
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(
                icon: Icon(Icons.auto_fix_high_rounded, size: 18),
                text: 'Assistant',
              ),
              Tab(
                icon: Icon(Icons.tune_rounded, size: 18),
                text: 'Expert',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // ── Tab 0: Assistant (Master Profiler) ──────────────────────
            TuneMasterProfilerScreen(embedded: true),
            // ── Tab 1: Expert (10-band parametric EQ) ───────────────────
            _ParametricEqTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ParametricEqTab — 10-band parametric EQ (previously the full EqualizerView)
// ---------------------------------------------------------------------------

class _ParametricEqTab extends StatefulWidget {
  const _ParametricEqTab();

  @override
  State<_ParametricEqTab> createState() => _ParametricEqTabState();
}

class _ParametricEqTabState extends State<_ParametricEqTab> {
  static const _bandLabels = [
    '31', '63', '125', '250', '500', '1k', '2k', '4k', '8k', '16k',
  ];

  List<double> _gains = List.filled(10, 0.0);
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEQ();
  }

  Future<void> _loadEQ() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getEqualizerBands(zoneId);
      if (mounted) {
        setState(() {
          final bands = data['bands'];
          if (bands is List && bands.length == 10) {
            _gains = bands.map((b) => (b as num).toDouble()).toList();
          }
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = '$e'; });
    }
  }

  Future<void> _applyGains() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) return;
    try {
      await api.setEqualizerBands(zoneId, _gains);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur EQ: $e'), backgroundColor: TuneColors.error),
        );
      }
    }
  }

  void _resetFlat() {
    setState(() => _gains = List.filled(10, 0.0));
    _applyGains();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: TuneColors.accent));
    }
    if (_error != null) {
      return Center(
          child: Text(_error!, style: const TextStyle(color: TuneColors.error)));
    }
    return Column(
      children: [
        // Flat button
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12, top: 8),
            child: TextButton(
              onPressed: _resetFlat,
              child: const Text('Flat',
                  style: TextStyle(color: TuneColors.accent)),
            ),
          ),
        ),
        // dB scale labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('+12 dB',
                  style: TextStyle(
                      color: TuneColors.textTertiary, fontSize: 11)),
              Text('0 dB',
                  style: TextStyle(
                      color: TuneColors.textTertiary, fontSize: 11)),
              Text('-12 dB',
                  style: TextStyle(
                      color: TuneColors.textTertiary, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Sliders
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              10,
              (i) => _BandSlider(
                label: _bandLabels[i],
                value: _gains[i],
                onChanged: (v) => setState(() => _gains[i] = v),
                onChangeEnd: (_) => _applyGains(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Presets row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _PresetChip(label: 'Flat', onTap: _resetFlat),
              _PresetChip(label: 'Bass Boost', onTap: () {
                setState(() => _gains = [8, 6, 4, 2, 0, 0, 0, 0, 0, 0]);
                _applyGains();
              }),
              _PresetChip(label: 'Rock', onTap: () {
                setState(() => _gains = [4, 3, -1, -2, 0, 2, 4, 5, 4, 3]);
                _applyGains();
              }),
              _PresetChip(label: 'Jazz', onTap: () {
                setState(() => _gains = [2, 3, 1, 2, -1, -1, 0, 1, 2, 3]);
                _applyGains();
              }),
              _PresetChip(label: 'Classique', onTap: () {
                setState(() => _gains = [0, 0, 0, 0, 0, 0, -2, -3, -2, 0]);
                _applyGains();
              }),
              _PresetChip(label: 'Vocal', onTap: () {
                setState(() => _gains = [-2, -1, 0, 2, 4, 4, 2, 0, -1, -2]);
                _applyGains();
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Single vertical band slider
// ---------------------------------------------------------------------------

class _BandSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  const _BandSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(
            color: value == 0 ? TuneColors.textTertiary : TuneColors.accent,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                activeTrackColor: TuneColors.accent,
                inactiveTrackColor: TuneColors.surfaceVariant,
                thumbColor: TuneColors.accent,
                overlayColor: TuneColors.accent.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: value,
                min: -12,
                max: 12,
                divisions: 24,
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
              ),
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: TuneColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Preset chip
// ---------------------------------------------------------------------------

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        backgroundColor: TuneColors.surfaceVariant,
        labelStyle:
            const TextStyle(color: TuneColors.textPrimary, fontSize: 12),
        side: BorderSide.none,
        onPressed: onTap,
      ),
    );
  }
}
