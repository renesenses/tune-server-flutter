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

  final appState = await AppState.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: appState),
        ChangeNotifierProvider<ZoneState>.value(value: appState.zoneState),
        ChangeNotifierProvider<LibraryState>.value(
            value: appState.libraryState),
        ChangeNotifierProvider<SettingsState>.value(
            value: appState.settingsState),
      ],
      child: const TuneServerApp(),
    ),
  );
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
