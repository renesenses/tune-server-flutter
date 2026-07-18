import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'services/auth_service.dart';
import 'state/app_state.dart';
import 'state/library_state.dart';
import 'state/settings_state.dart';
import 'state/zone_state.dart';
import 'views/components/player_sheet.dart';
import 'views/helpers/app_theme.dart';
import 'views/mode_selector_view.dart';

// ---------------------------------------------------------------------------
// Tune Server — point d'entrée Flutter
// Crée l'AppState via sa factory async, expose les sous-états via Provider.
// ---------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error boundary: log framework and uncaught async errors instead of
  // letting them surface as fatal "Unhandled Exception" (Fabien: remote-mode
  // APK, black screen after a dropped connection on resume). Returning true
  // from onError marks the async error as handled so it never destabilizes the
  // app; the error is still logged for diagnostics.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('[uncaught:flutter] ${details.exception}');
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    debugPrint('[uncaught:async] $error');
    return true;
  };

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
  final AuthService _authService = AuthService();
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
      await _authService.init();
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
        ChangeNotifierProvider<AuthService>.value(value: _authService),
      ],
      child: const TuneServerApp(),
    );
  }
}

class TuneServerApp extends StatelessWidget {
  const TuneServerApp({super.key});

  ThemeMode _themeModeFrom(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Locale? _localeFrom(String? code) {
    if (code == null || code.isEmpty || code == 'system') return null;
    return Locale(code);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    return MaterialApp(
      title: 'Tune Server',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeModeFrom(settings.theme),
      locale: _localeFrom(settings.language),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Mount the player sheet ABOVE the Navigator so the mini-player stays
      // visible while browsing into sub-pages / folders — pushing a full-screen
      // route no longer hides it (Rhorn, #1088). Phone only: the iPad layout has
      // its own now-playing bar. The inset keeps the mini-player above the iPhone
      // tab bar on the root screen (matches the width breakpoint in RootView).
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final isPhone = MediaQuery.sizeOf(context).width < 768;
        if (!isPhone) return child;
        // The iPhone tab bar renders at kBottomNavigationBarHeight PLUS the
        // bottom safe-area inset (Android gesture nav bar / iPhone home
        // indicator), because BottomNavigationBar pads itself up by that inset.
        // Lifting the mini-player by the height alone left it overlapping the
        // tab-bar labels on devices with a bottom inset, so the menu bar looked
        // gone in portrait (Fabien, Android v0.8.336). Include the safe area.
        final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
        return PlayerSheetScaffold(
          sheetBottomInset: kBottomNavigationBarHeight + safeBottom,
          child: child,
        );
      },
      home: const ModeSelectorView(),
    );
  }
}
