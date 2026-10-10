import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// TroubleshootingView — FAQ depannage avec sections extensibles.
// Accessible depuis Reglages > Aide > Depannage.
// ---------------------------------------------------------------------------

class TroubleshootingView extends StatelessWidget {
  const TroubleshootingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TuneColors.background,
      appBar: AppBar(
        backgroundColor: TuneColors.surface,
        title: Text(l.miscTroubleshootingTitle, style: TuneFonts.title3),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          _SectionHeader(l.miscFaqHeader),
          _FaqItem(
            icon: Icons.wifi_off_rounded,
            title: l.miscFaq1Title,
            steps: [
              l.miscFaq1Step1,
              l.miscFaq1Step2,
              l.miscFaq1Step3,
              l.miscFaq1Step4,
              l.miscFaq1Step5,
              l.miscFaq1Step6,
            ],
          ),
          _FaqItem(
            icon: Icons.music_off_rounded,
            title: l.miscFaq2Title,
            steps: [
              l.miscFaq2Step1,
              l.miscFaq2Step2,
              l.miscFaq2Step3,
              l.miscFaq2Step4,
              l.miscFaq2Step5,
              l.miscFaq2Step6,
            ],
          ),
          _FaqItem(
            icon: Icons.broken_image_rounded,
            title: l.miscFaq3Title,
            steps: [
              l.miscFaq3Step1,
              l.miscFaq3Step2,
              l.miscFaq3Step3,
              l.miscFaq3Step4,
              l.miscFaq3Step5,
            ],
          ),
          _FaqItem(
            icon: Icons.hourglass_top_rounded,
            title: l.miscFaq4Title,
            steps: [
              l.miscFaq4Step1,
              l.miscFaq4Step2,
              l.miscFaq4Step3,
              l.miscFaq4Step4,
              l.miscFaq4Step5,
            ],
          ),
          _FaqItem(
            icon: Icons.cast_rounded,
            title: l.miscFaq5Title,
            steps: [
              l.miscFaq5Step1,
              l.miscFaq5Step2,
              l.miscFaq5Step3,
              l.miscFaq5Step4,
              l.miscFaq5Step5,
              l.miscFaq5Step6,
            ],
          ),
          _FaqItem(
            icon: Icons.cloud_off_rounded,
            title: l.miscFaq6Title,
            steps: [
              l.miscFaq6Step1,
              l.miscFaq6Step2,
              l.miscFaq6Step3,
              l.miscFaq6Step4,
              l.miscFaq6Step5,
              l.miscFaq6Step6,
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header — matches settings_view.dart style
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TuneFonts.footnote.copyWith(
          color: TuneColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FAQ item — expandable tile with numbered steps
// ---------------------------------------------------------------------------

class _FaqItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> steps;

  const _FaqItem({
    required this.icon,
    required this.title,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TuneColors.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: TuneColors.accent, size: 22),
          title: Text(title, style: TuneFonts.body),
          iconColor: TuneColors.textTertiary,
          collapsedIconColor: TuneColors.textTertiary,
          childrenPadding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: steps.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '$idx.',
                      style: TuneFonts.footnote.copyWith(
                        color: TuneColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      step,
                      style: TuneFonts.footnote.copyWith(
                        color: TuneColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
