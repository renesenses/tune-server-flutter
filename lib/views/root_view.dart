import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/track_notification_service.dart';
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
    return _TrackNotificationListener(
      child: _PlaybackErrorListener(
        child: LayoutBuilder(
          builder: (_, constraints) {
            if (constraints.maxWidth >= 768) {
              return const iPadContentView();
            }
            return const iPhoneContentView();
          },
        ),
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
// _TrackNotificationListener — show in-app notification on track change
// Uses WebSocket events via TrackNotificationService in AppState.
// ---------------------------------------------------------------------------

class _TrackNotificationListener extends StatefulWidget {
  final Widget child;
  const _TrackNotificationListener({required this.child});

  @override
  State<_TrackNotificationListener> createState() =>
      _TrackNotificationListenerState();
}

class _TrackNotificationListenerState
    extends State<_TrackNotificationListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final app = context.read<AppState>();
    app.onTrackChangeNotification = _showTrackNotification;
  }

  void _showTrackNotification(TrackChangeInfo info) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final subtitle = [
      if (info.artist != null) info.artist!,
      if (info.album != null) info.album!,
    ].join(' - ');

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.music_note_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: TuneColors.accent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

class _ErrorView extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  State<_ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<_ErrorView> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>();
    _hostController.text = settings.remoteHost;
    _portController.text = settings.remotePort.toString();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _saveAndRetry() async {
    final host = _hostController.text.trim();
    if (host.isEmpty) return;
    setState(() => _connecting = true);
    final app = context.read<AppState>();
    await app.settingsState.setRemoteHost(host);
    final port = int.tryParse(_portController.text.trim());
    if (port != null) await app.settingsState.setRemotePort(port);
    widget.onRetry();
  }

  @override
  Widget build(BuildContext context) {
    final isRemote = context.read<AppState>().isRemoteMode;
    final l = AppLocalizations.of(context);

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
              Text(l.rootStartError, style: TuneFonts.title3),
              const SizedBox(height: 8),
              Text(widget.message,
                  style: TuneFonts.footnote,
                  textAlign: TextAlign.center),
              if (isRemote) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: 280,
                  child: TextField(
                    controller: _hostController,
                    style: TuneFonts.body,
                    decoration: InputDecoration(
                      hintText: '192.168.1.100',
                      hintStyle: TuneFonts.footnote,
                      labelText: 'Adresse du serveur',
                      labelStyle: TuneFonts.footnote,
                      prefixIcon: const Icon(Icons.dns_outlined, size: 20),
                      filled: true,
                      fillColor: TuneColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 280,
                  child: TextField(
                    controller: _portController,
                    style: TuneFonts.body,
                    decoration: InputDecoration(
                      hintText: '8888',
                      hintStyle: TuneFonts.footnote,
                      labelText: 'Port',
                      labelStyle: TuneFonts.footnote,
                      prefixIcon: const Icon(Icons.numbers_outlined, size: 20),
                      filled: true,
                      fillColor: TuneColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _saveAndRetry(),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _connecting
                  ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: TuneColors.accent))
                  : FilledButton(
                      onPressed: isRemote ? _saveAndRetry : widget.onRetry,
                      child: Text(isRemote ? 'Connexion' : l.btnRetry),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
