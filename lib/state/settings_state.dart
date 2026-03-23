import 'package:flutter/foundation.dart';

import '../server/configuration.dart';

// ---------------------------------------------------------------------------
// T9.4 — SettingsState
// ChangeNotifier pour les préférences utilisateur.
// Délègue la persistance à ServerConfiguration (shared_preferences).
// Miroir de SettingsState.swift (iOS / @Observable + AppStorage)
// ---------------------------------------------------------------------------

class SettingsState extends ChangeNotifier {
  final ServerConfiguration _config;

  SettingsState(this._config);

  // ---------------------------------------------------------------------------
  // Thème
  // ---------------------------------------------------------------------------

  String get theme => _config.theme;

  Future<void> setTheme(String value) async {
    await _config.setTheme(value);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Langue
  // ---------------------------------------------------------------------------

  String? get language => _config.language;

  Future<void> setLanguage(String? code) async {
    await _config.setLanguage(code);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Zone par défaut
  // ---------------------------------------------------------------------------

  int? get defaultZoneId => _config.defaultZoneId;

  Future<void> setDefaultZoneId(int? id) async {
    await _config.setDefaultZoneId(id);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Port serveur
  // ---------------------------------------------------------------------------

  int get serverPort => _config.port;

  Future<void> setServerPort(int port) async {
    await _config.setPort(port);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------

  bool get setupCompleted => _config.setupCompleted;

  Future<void> completeSetup() async {
    await _config.setSetupCompleted(value: true);
    notifyListeners();
  }

  Future<void> resetSetup() async {
    await _config.setSetupCompleted(value: false);
    notifyListeners();
  }
}
