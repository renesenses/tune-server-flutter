import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/track_notification_service.dart';
import '../server/license/license_manager.dart';
import '../state/app_state.dart';
import '../state/library_state.dart';
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
    // ModeSelectorView already established the connection — skip if connected.
    if (!app.serverStarted) {
      try {
        if (app.settingsState.isRemoteMode) {
          await app.connectRemote();
        } else {
          await app.startServer().timeout(const Duration(seconds: 10));
        }
      } on TimeoutException {
        debugPrint('[RootView] startServer timed out — continuing with UI');
      } catch (e) {
        debugPrint('[RootView] startServer error: $e');
      }
    }
    if (mounted) setState(() => _starting = false);
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select<AppState, String?>((a) => a.errorMessage);

    if (_starting) return const _SplashView();
    if (error != null) return _ErrorView(message: error, onRetry: _startServer);

    final isRemote = context.select<SettingsState, bool>((s) => s.isRemoteMode);
    final setupCompleted =
        context.select<SettingsState, bool>((s) => s.setupCompleted);

    // Premier lancement : onboarding (skip en mode remote — pas de dossiers locaux)
    if (!setupCompleted && !isRemote) return const LibrarySetupView();

    // Routing iPhone vs iPad selon la largeur disponible
    return _WhatsNewDialogListener(
      child: _TrackNotificationListener(
        child: _PlaybackErrorListener(
          child: _StartupStatusBanner(
            child: LayoutBuilder(
              builder: (_, constraints) {
                if (constraints.maxWidth >= 768) {
                  return const iPadContentView();
                }
                return const iPhoneContentView();
              },
            ),
          ),
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
    if (!mounted) return;

    // Zone limit (Free tier) — surfaced as a paywall-style notice.
    final zoneErr = _app?.lastZoneError;
    if (zoneErr != null) {
      final l = AppLocalizations.of(context);
      _app!.clearZoneError();
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        SnackBar(
          content: Text(zoneErr == 'zone_limit_reached'
              ? l.zoneLimitReached(LicenseManager.freeMaxZones)
              : zoneErr),
          duration: const Duration(seconds: 4),
          backgroundColor: TuneColors.accent,
        ),
      );
    }

    final err = _app?.lastPlaybackError;
    if (err == null) return;
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
// _StartupStatusBanner — thin animated banner for scan & streaming init
// ---------------------------------------------------------------------------

class _StartupStatusBanner extends StatefulWidget {
  final Widget child;
  const _StartupStatusBanner({required this.child});

  @override
  State<_StartupStatusBanner> createState() => _StartupStatusBannerState();
}

class _StartupStatusBannerState extends State<_StartupStatusBanner> {
  // Show streaming init banner for a short window right after startup.
  final bool _showStreamingInit = true;
  bool _streamingDismissed = false;

  @override
  void initState() {
    super.initState();
    // Auto-hide the streaming init banner after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _streamingDismissed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isScanning = context.select<LibraryState, bool>((l) => l.isScanning);
    final scanProgress =
        context.select<LibraryState, int>((l) => l.scanProgress);
    final scanTotal =
        context.select<LibraryState, int>((l) => l.scanTotal);

    final showScan = isScanning;
    final showStreaming = !showScan && !_streamingDismissed && _showStreamingInit;
    final show = showScan || showStreaming;

    // Once we've shown streaming init and scan is now active, mark streaming done
    if (isScanning && !_streamingDismissed) {
      _streamingDismissed = true;
    }

    String? label;
    String? sub;
    if (showScan) {
      label = 'Synchronisation de la bibliothèque…';
      if (scanTotal > 0) sub = '$scanProgress / $scanTotal pistes';
    } else if (showStreaming) {
      label = 'Connexion aux services streaming…';
    }

    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: show ? 0 : -64,
          left: 0,
          right: 0,
          child: _StatusBannerWidget(label: label ?? '', sub: sub),
        ),
      ],
    );
  }
}

class _StatusBannerWidget extends StatelessWidget {
  final String label;
  final String? sub;
  const _StatusBannerWidget({required this.label, this.sub});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: TuneColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: TuneColors.accent.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: TuneColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: TuneColors.textPrimary,
                      ),
                    ),
                    if (sub != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        sub!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: TuneColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _WhatsNewDialogListener — show a What's New dialog after update
// ---------------------------------------------------------------------------

class _WhatsNewDialogListener extends StatefulWidget {
  final Widget child;
  const _WhatsNewDialogListener({required this.child});

  @override
  State<_WhatsNewDialogListener> createState() =>
      _WhatsNewDialogListenerState();
}

class _WhatsNewDialogListenerState extends State<_WhatsNewDialogListener> {
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final app = context.read<AppState>();
    if (app.showWhatsNew && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog(app));
    }
  }

  void _showDialog(AppState app) {
    if (!mounted) return;
    final version = app.whatsNewVersion ?? '';
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TuneColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.auto_awesome_rounded,
                color: TuneColors.accent, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Nouveau dans v$version',
                style: TuneFonts.title3,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              _WhatsNewItem(
                icon: Icons.library_music_rounded,
                text: 'Synchronisation de bibliothèque améliorée',
              ),
              _WhatsNewItem(
                icon: Icons.speaker_group_rounded,
                text: 'Multi-room et gestion des zones optimisés',
              ),
              _WhatsNewItem(
                icon: Icons.bug_report_rounded,
                text: 'Corrections de bugs et améliorations de stabilité',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              app.dismissWhatsNew();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Re-check in case showWhatsNew changes after initial build
    final showWhatsNew =
        context.select<AppState, bool>((a) => a.showWhatsNew);
    if (showWhatsNew && !_dialogShown) {
      _dialogShown = true;
      final app = context.read<AppState>();
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog(app));
    }
    return widget.child;
  }
}

class _WhatsNewItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _WhatsNewItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: TuneColors.accent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TuneFonts.body),
          ),
        ],
      ),
    );
  }
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
