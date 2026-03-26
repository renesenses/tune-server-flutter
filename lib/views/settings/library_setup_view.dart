import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../state/settings_state.dart';
import '../helpers/tune_colors.dart';
import '../helpers/tune_fonts.dart';

// ---------------------------------------------------------------------------
// T16.3 — LibrarySetupView
// Onboarding premier lancement : 3 pages (bienvenue, dossier local, UPnP).
// Marque setupCompleted = true à la fin.
// Miroir de LibrarySetupView.swift (iOS)
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
    if (_page < 2) {
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
                children: List.generate(3, (i) {
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
                  _LocalFolderPage(onNext: _goNext),
                  _UPnPPage(onDone: _complete),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_tethering_rounded,
              size: 84, color: TuneColors.accent),
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context).setupWelcomeTitle,
            style: TuneFonts.largeTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).setupWelcomeBody,
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
              child: Text(AppLocalizations.of(context).setupStart,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2 — Dossier local
// ---------------------------------------------------------------------------

class _LocalFolderPage extends StatefulWidget {
  final VoidCallback onNext;
  const _LocalFolderPage({required this.onNext});

  @override
  State<_LocalFolderPage> createState() => _LocalFolderPageState();
}

class _LocalFolderPageState extends State<_LocalFolderPage> {
  final _ctrl = TextEditingController();
  bool _adding = false;
  bool _added = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null && mounted) {
      setState(() => _ctrl.text = path);
    }
  }

  Future<void> _add() async {
    final path = _ctrl.text.trim();
    if (path.isEmpty) return;
    setState(() => _adding = true);
    await context.read<AppState>().addMusicFolder(path);
    if (mounted) setState(() { _adding = false; _added = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_rounded,
              size: 64, color: TuneColors.accent),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context).setupLocalTitle,
              style: TuneFonts.title1),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).setupLocalBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _ctrl,
            style: TuneFonts.body,
            enabled: !_added,
            decoration: InputDecoration(
              filled: true,
              fillColor: TuneColors.surface,
              hintText: AppLocalizations.of(context).setupFolderHint,
              labelText: AppLocalizations.of(context).setupFolderPath,
              border: const OutlineInputBorder(),
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
                label: Text(AppLocalizations.of(context).btnAddFolder),
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
                child: Text(AppLocalizations.of(context).setupAddFolder),
              ),
            ),
          if (_added)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                AppLocalizations.of(context).setupFolderAdded,
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
                _added
                    ? AppLocalizations.of(context).btnNext
                    : AppLocalizations.of(context).btnSkip,
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
// Page 3 — UPnP / DLNA
// ---------------------------------------------------------------------------

class _UPnPPage extends StatelessWidget {
  final VoidCallback onDone;
  const _UPnPPage({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.router_rounded,
              size: 64, color: TuneColors.accent),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context).setupUPnPTitle,
              style: TuneFonts.title1),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).setupUPnPBody,
            style: TuneFonts.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: TuneColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _FeatureRow(
                  icon: Icons.wifi_find_rounded,
                  text: AppLocalizations.of(context).setupFeatureSsdp,
                ),
                const SizedBox(height: 12),
                _FeatureRow(
                  icon: Icons.folder_open_rounded,
                  text: AppLocalizations.of(context).setupFeatureContentDir,
                ),
                const SizedBox(height: 12),
                _FeatureRow(
                  icon: Icons.play_circle_outline_rounded,
                  text: AppLocalizations.of(context).setupFeaturePlayback,
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
              child: Text(AppLocalizations.of(context).setupFinish,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

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
