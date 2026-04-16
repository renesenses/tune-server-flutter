import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../state/settings_state.dart';
import 'helpers/tune_colors.dart';
import 'helpers/tune_fonts.dart';
import 'ipad/ipad_content_view.dart';
import 'iphone/iphone_content_view.dart';
import 'settings/library_setup_view.dart';

// ---------------------------------------------------------------------------
// T10.3 — RootView
// Point d'entrée UI : splash pendant le démarrage, routing iPhone vs iPad,
// affichage d'erreur avec bouton réessayer.
// Miroir de RootView.swift (iOS) — @Observable AppState
// ---------------------------------------------------------------------------

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  bool _starting = true;

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  Future<void> _startServer() async {
    setState(() => _starting = true);
    final app = context.read<AppState>();
    if (app.settingsState.isRemoteMode) {
      await app.connectRemote();
    } else {
      await app.startServer();
    }
    if (mounted) setState(() => _starting = false);
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select<AppState, String?>((a) => a.errorMessage);

    if (_starting) return const _SplashView();
    if (error != null) return _ErrorView(message: error, onRetry: _startServer);

    final setupCompleted =
        context.select<SettingsState, bool>((s) => s.setupCompleted);

    // Premier lancement : onboarding
    if (!setupCompleted) return const LibrarySetupView();

    // Routing iPhone vs iPad selon la largeur disponible
    return _PlaybackErrorListener(
      child: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth >= 768) {
            return const iPadContentView();
          }
          return const iPhoneContentView();
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PlaybackErrorListener — surface lastPlaybackError via SnackBar
// ---------------------------------------------------------------------------

class _PlaybackErrorListener extends StatefulWidget {
  final Widget child;
  const _PlaybackErrorListener({required this.child});

  @override
  State<_PlaybackErrorListener> createState() =>
      _PlaybackErrorListenerState();
}

class _PlaybackErrorListenerState extends State<_PlaybackErrorListener> {
  AppState? _app;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final app = context.read<AppState>();
    if (!identical(app, _app)) {
      _app?.removeListener(_onAppChanged);
      _app = app;
      app.addListener(_onAppChanged);
    }
  }

  @override
  void dispose() {
    _app?.removeListener(_onAppChanged);
    super.dispose();
  }

  void _onAppChanged() {
    final err = _app?.lastPlaybackError;
    if (err == null || !mounted) return;
    final l = AppLocalizations.of(context);
    final msg = switch (err) {
      'no_zone' => l.playbackErrorNoZone,
      'zone_not_found' => l.playbackErrorZoneNotFound,
      'playback_failed' => l.playbackErrorFailed,
      _ => err,
    };
    _app!.clearPlaybackError();
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),
        backgroundColor: TuneColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

// ---------------------------------------------------------------------------
// Splash
// ---------------------------------------------------------------------------

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: TuneColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_tethering_rounded,
                size: 64, color: TuneColors.accent),
            SizedBox(height: 24),
            Text('Tune Server', style: TuneFonts.title1),
            SizedBox(height: 20),
            SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: TuneColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuneColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 48, color: TuneColors.error),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).rootStartError, style: TuneFonts.title3),
              const SizedBox(height: 8),
              Text(message,
                  style: TuneFonts.footnote,
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context).btnRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
