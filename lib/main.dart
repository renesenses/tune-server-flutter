import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'state/app_state.dart';
import 'state/library_state.dart';
import 'state/settings_state.dart';
import 'state/zone_state.dart';
import 'views/helpers/app_theme.dart';
import 'views/root_view.dart';

// ---------------------------------------------------------------------------
// Tune Server — point d'entrée Flutter
// Crée l'AppState via sa factory async, expose les sous-états via Provider.
// ---------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Phase 1: show UI immediately, start server in background
  runApp(const _BootstrapApp());
}

class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp();

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  AppState? _appState;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  @override
  void dispose() {
    _appState?.dispose();
    super.dispose();
  }

  Future<void> _initServer() async {
    try {
      final appState = await AppState.create();
      if (mounted) setState(() => _appState = appState);
    } catch (e, stack) {
      debugPrint('=== STARTUP ERROR ===\n$e\n$stack');
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: SelectableText(
                'Startup error:\n$_error',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }

    if (_appState == null) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 24),
                Text('Tune Server starting…',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: _appState!),
        ChangeNotifierProvider<ZoneState>.value(value: _appState!.zoneState),
        ChangeNotifierProvider<LibraryState>.value(
            value: _appState!.libraryState),
        ChangeNotifierProvider<SettingsState>.value(
            value: _appState!.settingsState),
      ],
      child: const TuneServerApp(),
    );
  }
}

class TuneServerApp extends StatelessWidget {
  const TuneServerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tune Server',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const RootView(),
    );
  }
}
