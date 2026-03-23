import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// T2.2 — ServerConfiguration
// Préférences persistées via shared_preferences.
// Miroir de ServerConfiguration.swift (iOS / UserDefaults)
// ---------------------------------------------------------------------------

class ServerConfiguration {
  ServerConfiguration._();
  static final ServerConfiguration instance = ServerConfiguration._();

  // Clés shared_preferences
  static const _kPort = 'server_port';
  static const _kSetupCompleted = 'setup_completed';
  static const _kDefaultZoneId = 'default_zone_id';
  static const _kTheme = 'app_theme'; // 'system' | 'light' | 'dark'
  static const _kLanguage = 'app_language'; // code BCP-47, null = système
  static const _kHttpStreamerPort = 'http_streamer_port';

  // Valeurs par défaut
  static const int defaultPort = 8080;
  static const int defaultHttpStreamerPort = 8081;

  SharedPreferences? _prefs;

  /// À appeler une fois au démarrage de l'app avant tout accès.
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    assert(_prefs != null, 'ServerConfiguration.load() non appelé');
    return _prefs!;
  }

  // ---------------------------------------------------------------------------
  // Port serveur principal
  // ---------------------------------------------------------------------------

  int get port => _p.getInt(_kPort) ?? defaultPort;

  Future<void> setPort(int value) => _p.setInt(_kPort, value);

  // ---------------------------------------------------------------------------
  // Port streamer HTTP embarqué
  // ---------------------------------------------------------------------------

  int get httpStreamerPort =>
      _p.getInt(_kHttpStreamerPort) ?? defaultHttpStreamerPort;

  Future<void> setHttpStreamerPort(int value) =>
      _p.setInt(_kHttpStreamerPort, value);

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------

  bool get setupCompleted => _p.getBool(_kSetupCompleted) ?? false;

  Future<void> setSetupCompleted({required bool value}) =>
      _p.setBool(_kSetupCompleted, value);

  // ---------------------------------------------------------------------------
  // Zone par défaut
  // ---------------------------------------------------------------------------

  int? get defaultZoneId {
    final v = _p.getInt(_kDefaultZoneId);
    return v == 0 ? null : v;
  }

  Future<void> setDefaultZoneId(int? id) async {
    if (id == null) {
      await _p.remove(_kDefaultZoneId);
    } else {
      await _p.setInt(_kDefaultZoneId, id);
    }
  }

  // ---------------------------------------------------------------------------
  // Thème
  // ---------------------------------------------------------------------------

  String get theme => _p.getString(_kTheme) ?? 'system';

  Future<void> setTheme(String value) => _p.setString(_kTheme, value);

  // ---------------------------------------------------------------------------
  // Langue
  // ---------------------------------------------------------------------------

  String? get language => _p.getString(_kLanguage);

  Future<void> setLanguage(String? code) async {
    if (code == null) {
      await _p.remove(_kLanguage);
    } else {
      await _p.setString(_kLanguage, code);
    }
  }

  // ---------------------------------------------------------------------------
  // Reset (tests / onboarding)
  // ---------------------------------------------------------------------------

  Future<void> reset() => _p.clear();
}
