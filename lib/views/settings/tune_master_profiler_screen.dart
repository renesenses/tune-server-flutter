import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/tune_api_client.dart';
import '../../state/app_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// TuneMasterProfilerScreen
//
// 2-step perceptual room correction wizard.
//   Step 1 — 3 visual questions (listening mode, room size, speaker placement)
//   Step 2 — 3 sliders (Bass, Voice, Treble) with perceptual labels
//
// Sends EQ profile to server via POST /zones/{id}/dsp.
// ---------------------------------------------------------------------------

class TuneMasterProfilerScreen extends StatefulWidget {
  /// When true the widget is rendered without its own Scaffold (embedded in
  /// the tabbed EqualizerView). When false (default) it shows as a standalone
  /// screen with an AppBar.
  final bool embedded;

  const TuneMasterProfilerScreen({super.key, this.embedded = false});

  @override
  State<TuneMasterProfilerScreen> createState() =>
      _TuneMasterProfilerScreenState();
}

class _TuneMasterProfilerScreenState extends State<TuneMasterProfilerScreen> {
  // ── Wizard state ──────────────────────────────────────────────────────────
  int _step = 0; // 0 = questions, 1 = sliders

  EqProfile _profile = const EqProfile();

  bool _loading = true;
  bool _saving = false;
  String? _error;
  bool _saved = false;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await api.getDspProfile(zoneId);
      if (mounted) {
        setState(() {
          if (data != null) {
            final raw = data['eq_profile'];
            if (raw is Map<String, dynamic>) {
              _profile = EqProfile.fromJson(raw);
            }
          }
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _applyProfile() async {
    final api = context.read<AppState>().apiClient;
    final zoneId = context.read<ZoneState>().currentZoneId;
    if (api == null || zoneId == null) return;

    setState(() { _saving = true; _error = null; _saved = false; });
    try {
      await api.setDspProfile(zoneId, _profile);
      if (mounted) setState(() { _saving = false; _saved = true; });
    } catch (e) {
      if (mounted) setState(() { _saving = false; _error = '$e'; });
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _update(EqProfile updated) => setState(() {
    _profile = updated;
    _saved = false;
  });

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildBody();
    }
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: const Text('Master Profiler', style: TuneFonts.title3),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: TuneColors.accent));
    }
    return Column(
      children: [
        // ── Step indicator ────────────────────────────────────────────────
        _StepIndicator(currentStep: _step),
        // ── Content ───────────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: _step == 0
                ? _Step1Questions(
                    profile: _profile,
                    onUpdate: _update,
                    onNext: () => setState(() => _step = 1),
                  )
                : _Step2Sliders(
                    profile: _profile,
                    onUpdate: _update,
                    onBack: () => setState(() => _step = 0),
                    onApply: _applyProfile,
                    saving: _saving,
                    saved: _saved,
                    error: _error,
                  ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step indicator
// ---------------------------------------------------------------------------

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          _StepDot(index: 0, current: currentStep, label: 'Configuration'),
          Expanded(
            child: Container(
              height: 2,
              color: currentStep >= 1 ? TuneColors.accent : TuneColors.surfaceVariant,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          _StepDot(index: 1, current: currentStep, label: 'Réglages fins'),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final int current;
  final String label;
  const _StepDot({required this.index, required this.current, required this.label});

  @override
  Widget build(BuildContext context) {
    final isActive = current == index;
    final isDone = current > index;
    final color = isDone || isActive ? TuneColors.accent : TuneColors.surfaceHigh;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? TuneColors.accent : TuneColors.textTertiary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 1 — 3 visual questions
// ---------------------------------------------------------------------------

class _Step1Questions extends StatelessWidget {
  final EqProfile profile;
  final ValueChanged<EqProfile> onUpdate;
  final VoidCallback onNext;

  const _Step1Questions({
    required this.profile,
    required this.onUpdate,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Question 1: Listening mode ────────────────────────────────────
        _QuestionSection(
          title: 'Comment écoutez-vous ?',
          subtitle: 'Le profil sera adapté à votre configuration d\'écoute',
          child: Row(
            children: [
              Expanded(
                child: _ChoiceCard(
                  icon: Icons.speaker_rounded,
                  label: 'Enceintes',
                  sublabel: 'Salle de musique',
                  selected: profile.listening == ListeningMode.speakers,
                  onTap: () => onUpdate(
                      profile.copyWith(listening: ListeningMode.speakers)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ChoiceCard(
                  icon: Icons.headphones_rounded,
                  label: 'Casque',
                  sublabel: 'Écoute personnelle',
                  selected: profile.listening == ListeningMode.headphones,
                  onTap: () => onUpdate(
                      profile.copyWith(listening: ListeningMode.headphones)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Question 2: Room size (hidden for headphones) ─────────────────
        if (profile.listening == ListeningMode.speakers) ...[
          _QuestionSection(
            title: 'Quelle est la taille de la pièce ?',
            subtitle: 'Influence les fréquences basses et la réverbération',
            child: Row(
              children: [
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.chair_rounded,
                    label: 'Petite',
                    sublabel: '< 15 m²',
                    selected: profile.roomSize == RoomSize.small,
                    onTap: () =>
                        onUpdate(profile.copyWith(roomSize: RoomSize.small)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.living_rounded,
                    label: 'Moyenne',
                    sublabel: '15 – 30 m²',
                    selected: profile.roomSize == RoomSize.medium,
                    onTap: () =>
                        onUpdate(profile.copyWith(roomSize: RoomSize.medium)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.domain_rounded,
                    label: 'Grande',
                    sublabel: '> 30 m²',
                    selected: profile.roomSize == RoomSize.large,
                    onTap: () =>
                        onUpdate(profile.copyWith(roomSize: RoomSize.large)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ── Question 3: Speaker placement ──────────────────────────────
          _QuestionSection(
            title: 'Placement des enceintes',
            subtitle: 'L\'emplacement affecte les réflexions de basses',
            child: Row(
              children: [
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.align_horizontal_left_rounded,
                    label: 'Près d\'un mur',
                    sublabel: '< 50 cm',
                    selected: profile.speakerPlacement ==
                        SpeakerPlacement.nearWall,
                    onTap: () => onUpdate(profile.copyWith(
                        speakerPlacement: SpeakerPlacement.nearWall)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.open_in_full_rounded,
                    label: 'En espace libre',
                    sublabel: '> 50 cm',
                    selected: profile.speakerPlacement ==
                        SpeakerPlacement.freeStanding,
                    onTap: () => onUpdate(profile.copyWith(
                        speakerPlacement: SpeakerPlacement.freeStanding)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ] else
          const SizedBox(height: 20),

        // ── Next button ───────────────────────────────────────────────────
        FilledButton.icon(
          onPressed: onNext,
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: const Text('Régler le son'),
          style: FilledButton.styleFrom(
            backgroundColor: TuneColors.accent,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2 — 3 perceptual sliders
// ---------------------------------------------------------------------------

class _Step2Sliders extends StatelessWidget {
  final EqProfile profile;
  final ValueChanged<EqProfile> onUpdate;
  final VoidCallback onBack;
  final VoidCallback onApply;
  final bool saving;
  final bool saved;
  final String? error;

  const _Step2Sliders({
    required this.profile,
    required this.onUpdate,
    required this.onBack,
    required this.onApply,
    required this.saving,
    required this.saved,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Profile enable toggle ─────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: TuneColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SwitchListTile(
            title: const Text('Correction active', style: TuneFonts.body),
            subtitle: Text(
              'Applique le profil à la zone en cours',
              style: TuneFonts.footnote,
            ),
            value: profile.enabled,
            onChanged: (v) => onUpdate(profile.copyWith(enabled: v)),
            activeThumbColor: TuneColors.accent,
          ),
        ),

        const SizedBox(height: 20),

        // ── Bass slider ───────────────────────────────────────────────────
        _PerceptualSlider(
          label: 'Graves',
          description: 'Poids, chaleur, corps du son',
          lowLabel: 'Maigre',
          highLabel: 'Lourd',
          value: profile.bassGainDb,
          onChanged: (v) => onUpdate(profile.copyWith(bassGainDb: v)),
          iconData: Icons.graphic_eq_rounded,
        ),

        const SizedBox(height: 16),

        // ── Mid / Voice slider ────────────────────────────────────────────
        _PerceptualSlider(
          label: 'Voix / Médiums',
          description: 'Présence, clarté, intelligibilité',
          lowLabel: 'En retrait',
          highLabel: 'En avant',
          value: profile.midGainDb,
          onChanged: (v) => onUpdate(profile.copyWith(midGainDb: v)),
          iconData: Icons.mic_rounded,
        ),

        const SizedBox(height: 16),

        // ── Treble slider ─────────────────────────────────────────────────
        _PerceptualSlider(
          label: 'Aigus',
          description: 'Brillance, détail, air dans le son',
          lowLabel: 'Sombre',
          highLabel: 'Brillant',
          value: profile.trebleGainDb,
          onChanged: (v) => onUpdate(profile.copyWith(trebleGainDb: v)),
          iconData: Icons.equalizer_rounded,
        ),

        const SizedBox(height: 24),

        // ── Error / success feedback ──────────────────────────────────────
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              error!,
              style: const TextStyle(color: TuneColors.error, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        if (saved)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle_rounded,
                    size: 16, color: TuneColors.success),
                SizedBox(width: 6),
                Text(
                  'Profil appliqué',
                  style: TextStyle(color: TuneColors.success, fontSize: 13),
                ),
              ],
            ),
          ),

        // ── Apply button ──────────────────────────────────────────────────
        FilledButton.icon(
          onPressed: saving ? null : onApply,
          icon: saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.check_rounded, size: 18),
          label: Text(saving ? 'Application...' : 'Appliquer le profil'),
          style: FilledButton.styleFrom(
            backgroundColor: TuneColors.accent,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),

        const SizedBox(height: 12),

        // ── Back button ───────────────────────────────────────────────────
        OutlinedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded, size: 16),
          label: const Text('Retour aux questions'),
          style: OutlinedButton.styleFrom(
            foregroundColor: TuneColors.textSecondary,
            side: const BorderSide(color: TuneColors.surfaceVariant),
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _QuestionSection — titled container for a group of question cards
// ---------------------------------------------------------------------------

class _QuestionSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _QuestionSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TuneFonts.callout.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text(subtitle, style: TuneFonts.caption),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _ChoiceCard — tappable card for a wizard option
// ---------------------------------------------------------------------------

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? TuneColors.accent.withValues(alpha: 0.18)
              : TuneColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? TuneColors.accent : TuneColors.divider,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30,
              color: selected ? TuneColors.accent : TuneColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    selected ? TuneColors.accent : TuneColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              sublabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10, color: TuneColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PerceptualSlider — labelled slider with perceptual min/max labels
// ---------------------------------------------------------------------------

class _PerceptualSlider extends StatelessWidget {
  final String label;
  final String description;
  final String lowLabel;
  final String highLabel;
  final double value;
  final ValueChanged<double> onChanged;
  final IconData iconData;

  const _PerceptualSlider({
    required this.label,
    required this.description,
    required this.lowLabel,
    required this.highLabel,
    required this.value,
    required this.onChanged,
    required this.iconData,
  });

  String get _dbLabel {
    if (value == 0) return '0 dB';
    return '${value > 0 ? "+" : ""}${value.toStringAsFixed(1)} dB';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: TuneColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconData,
                  size: 18,
                  color: value != 0 ? TuneColors.accent : TuneColors.textTertiary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TuneFonts.body
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(description, style: TuneFonts.caption),
                  ],
                ),
              ),
              // dB readout
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: value != 0
                      ? TuneColors.accent.withValues(alpha: 0.15)
                      : TuneColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _dbLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: value != 0
                        ? TuneColors.accent
                        : TuneColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              activeTrackColor: TuneColors.accent,
              inactiveTrackColor: TuneColors.surfaceVariant,
              thumbColor: TuneColors.accent,
              overlayColor: TuneColors.accent.withValues(alpha: 0.15),
            ),
            child: Slider(
              value: value,
              min: -12,
              max: 12,
              divisions: 48,
              onChanged: onChanged,
            ),
          ),
          // Perceptual min/max labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lowLabel,
                    style: const TextStyle(
                        fontSize: 10, color: TuneColors.textTertiary)),
                Text(highLabel,
                    style: const TextStyle(
                        fontSize: 10, color: TuneColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
