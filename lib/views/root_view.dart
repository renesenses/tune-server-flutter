import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'helpers/tune_colors.dart';
import 'helpers/tune_fonts.dart';
import 'ipad/ipad_content_view.dart';
import 'iphone/iphone_content_view.dart';

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
    await context.read<AppState>().startServer();
    if (mounted) setState(() => _starting = false);
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select<AppState, String?>((a) => a.errorMessage);

    if (_starting) return const _SplashView();
    if (error != null) return _ErrorView(message: error, onRetry: _startServer);

    // Routing iPhone vs iPad selon la largeur disponible
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= 768) {
          return const iPadContentView();
        }
        return const iPhoneContentView();
      },
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
              const Text('Erreur de démarrage', style: TuneFonts.title3),
              const SizedBox(height: 8),
              Text(message,
                  style: TuneFonts.footnote,
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
