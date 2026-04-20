import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../server/discovery/discovery_manager.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../../state/zone_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// LibrarySetupView — Onboarding wizard (4 pages)
//
// Step 1: Welcome — "Bienvenue sur Tune !" + description + "Commencer"
// Step 2: Configuration — Music directory path input (local) or server
//         connection (remote), depending on mode
// Step 3: Zone — Show discovered devices, tap to create zone
// Step 4: Terminé — Summary + "Accéder au tableau de bord"
//
// Shows on first launch (setupCompleted flag). Gated in RootView.
// ---------------------------------------------------------------------------

class LibrarySetupView extends StatefulWidget {
  const LibrarySetupView({super.key});

  @override
  State<LibrarySetupView> createState() => _LibrarySetupViewState();
}

class _LibrarySetupViewState extends State<LibrarySetupView> {
  final PageController _pageCtrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_page < 3) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    await context.read<SettingsState>().completeSetup();
    if (mounted) {
      // Si la vue a été poussée via Navigator (depuis SettingsView), pop.
      // Sinon (onboarding initial), la RootView réagit via setupCompleted.
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Indicateurs de page
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? TuneColors.accent
                          : TuneColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _WelcomePage(onNext: _goNext),
                  _ConfigPage(onNext: _goNext),
                  _ZonePage(onNext: _goNext),
                  _DonePage(onDone: _complete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1 — Bienvenue
// ---------------------------------------------------------------------------

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_tethering_rounded,
              size: 84, color: TuneColors.accent),
          const SizedBox(height: 32),
          Text(
            l.onboardingWelcomeTitle,
            style: TuneFonts.largeTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l.onboardingWelcomeBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 52),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l.onboardingWelcomeStart,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2 — Configuration (dossier local ou serveur distant)
// ---------------------------------------------------------------------------

class _ConfigPage extends StatefulWidget {
  final VoidCallback onNext;
  const _ConfigPage({required this.onNext});

  @override
  State<_ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<_ConfigPage> {
  final _ctrl = TextEditingController();
  bool _adding = false;
  bool _added = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null && mounted) {
      setState(() {
        _ctrl.text = path;
        _error = null;
      });
    }
  }

  Future<void> _add() async {
    final path = _ctrl.text.trim();
    if (path.isEmpty) {
      setState(() => _error =
          AppLocalizations.of(context).setupFolderEmpty);
      return;
    }
    setState(() { _adding = true; _error = null; });
    await context.read<AppState>().addMusicFolder(path);
    if (mounted) setState(() { _adding = false; _added = true; });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_rounded,
              size: 64, color: TuneColors.accent),
          const SizedBox(height: 24),
          Text(l.onboardingConfigTitle, style: TuneFonts.title1),
          const SizedBox(height: 12),
          Text(
            l.onboardingConfigBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _ctrl,
            style: TuneFonts.body,
            enabled: !_added,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: TuneColors.surface,
              hintText: l.setupFolderHint,
              hintStyle: TuneFonts.footnote.copyWith(
                color: TuneColors.textSecondary.withValues(alpha: 0.45),
              ),
              labelText: l.setupFolderPath,
              border: const OutlineInputBorder(),
              errorText: _error,
              suffixIcon: _adding
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: TuneColors.accent),
                      ),
                    )
                  : _added
                      ? const Icon(Icons.check_circle_rounded,
                          color: TuneColors.success)
                      : null,
            ),
          ),
          const SizedBox(height: 8),
          if (!_added)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.folder_open_rounded, size: 18),
                label: Text(l.btnAddFolder),
                onPressed: _adding ? null : _pickFolder,
              ),
            ),
          const SizedBox(height: 4),
          if (!_added)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: TuneColors.accent),
                onPressed: _adding ? null : _add,
                child: Text(l.setupAddFolder),
              ),
            ),
          if (_added)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                l.setupFolderAdded,
                style: TuneFonts.footnote
                    .copyWith(color: TuneColors.success),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onNext,
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _added ? l.btnNext : l.btnSkip,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 3 — Zone (discovered devices)
// ---------------------------------------------------------------------------

class _ZonePage extends StatefulWidget {
  final VoidCallback onNext;
  const _ZonePage({required this.onNext});

  @override
  State<_ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<_ZonePage> {
  bool _zoneCreated = false;
  String? _createdZoneName;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final zoneState = context.watch<ZoneState>();
    final renderers = zoneState.renderers;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.speaker_group_rounded,
              size: 64, color: TuneColors.accent),
          const SizedBox(height: 24),
          Text(l.onboardingZoneTitle, style: TuneFonts.title1),
          const SizedBox(height: 12),
          Text(
            l.onboardingZoneBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Device list or empty state
          if (renderers.isEmpty && !_zoneCreated)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l.onboardingZoneEmpty,
                style: TuneFonts.footnote.copyWith(
                    color: TuneColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            )
          else if (!_zoneCreated)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: TuneColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: renderers.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, indent: 56, color: TuneColors.divider),
                itemBuilder: (ctx, i) {
                  final device = renderers[i];
                  return ListTile(
                    leading: const Icon(Icons.cast_rounded,
                        color: TuneColors.textSecondary),
                    title: Text(device.name,
                        style: const TextStyle(
                            color: TuneColors.textPrimary)),
                    subtitle: Text('${device.host}:${device.port}',
                        style: TuneFonts.caption),
                    trailing: const Icon(Icons.add_circle_rounded,
                        color: TuneColors.accent),
                    onTap: () => _createZone(device),
                  );
                },
              ),
            ),

          // Success state
          if (_zoneCreated) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TuneColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: TuneColors.accent.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: TuneColors.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.onboardingZoneCreated(_createdZoneName ?? ''),
                      style: TuneFonts.body
                          .copyWith(color: TuneColors.accent),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onNext,
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _zoneCreated ? l.btnNext : l.btnSkip,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createZone(DiscoveredDevice device) async {
    final appState = context.read<AppState>();
    await appState.createZoneFromDevice(device);
    if (mounted) {
      setState(() {
        _zoneCreated = true;
        _createdZoneName = device.name;
      });
    }
  }
}

// ---------------------------------------------------------------------------
// Page 4 — Terminé
// ---------------------------------------------------------------------------

class _DonePage extends StatelessWidget {
  final VoidCallback onDone;
  const _DonePage({required this.onDone});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 84, color: TuneColors.success),
          const SizedBox(height: 32),
          Text(
            l.onboardingDoneTitle,
            style: TuneFonts.largeTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l.onboardingDoneBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Summary
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: TuneColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  icon: Icons.wifi_find_rounded,
                  text: l.setupFeatureSsdp,
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  icon: Icons.folder_open_rounded,
                  text: l.setupFeatureContentDir,
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  icon: Icons.play_circle_outline_rounded,
                  text: l.setupFeaturePlayback,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDone,
              style: FilledButton.styleFrom(
                backgroundColor: TuneColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l.onboardingDoneButton,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SummaryRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: TuneColors.accent, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text, style: TuneFonts.body),
        ),
      ],
    );
  }
}
