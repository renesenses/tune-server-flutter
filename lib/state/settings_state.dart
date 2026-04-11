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
  // App mode (server / remote)
  // ---------------------------------------------------------------------------

  String get appMode => _config.appMode;
  bool get isRemoteMode => _config.isRemoteMode;

  Future<void> setAppMode(String mode) async {
    await _config.setAppMode(mode);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Remote connection
  // ---------------------------------------------------------------------------

  String get remoteHost => _config.remoteHost;
  int get remotePort => _config.remotePort;
  String get remoteBaseUrl => _config.remoteBaseUrl;
  String get remoteWsUrl => _config.remoteWsUrl;

  Future<void> setRemoteHost(String host) async {
    await _config.setRemoteHost(host);
    notifyListeners();
  }

  Future<void> setRemotePort(int port) async {
    await _config.setRemotePort(port);
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
