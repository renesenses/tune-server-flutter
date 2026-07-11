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
  static const _kAppMode = 'app_mode'; // 'server' | 'remote'
  static const _kRemoteHost = 'remote_host';
  static const _kRemotePort = 'remote_port';

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
  // App mode (server / remote)
  // ---------------------------------------------------------------------------

  // v0.7.20 "A pragmatique": default remote so every user gets full
  // feature parity through the Python server. Standalone stays available
  // in Settings → Advanced with a clear "features limitées" badge.
  String get appMode => _p.getString(_kAppMode) ?? 'remote';
  bool get isRemoteMode => appMode == 'remote';

  Future<void> setAppMode(String value) => _p.setString(_kAppMode, value);

  // ---------------------------------------------------------------------------
  // Remote server connection
  // ---------------------------------------------------------------------------

  String get remoteHost => _p.getString(_kRemoteHost) ?? '';

  Future<void> setRemoteHost(String value) => _p.setString(_kRemoteHost, value);

  int get remotePort => _p.getInt(_kRemotePort) ?? 8888;

  Future<void> setRemotePort(int value) => _p.setInt(_kRemotePort, value);

  String get remoteBaseUrl => 'http://$remoteHost:$remotePort/api/v1';
  String get remoteWsUrl => 'ws://$remoteHost:$remotePort/ws';

  // ---------------------------------------------------------------------------
  // Crossfade
  // ---------------------------------------------------------------------------

  static const _kCrossfadeEnabled = 'crossfade_enabled';
  static const _kCrossfadeDuration = 'crossfade_duration';

  bool get crossfadeEnabled => _p.getBool(_kCrossfadeEnabled) ?? false;
  Future<void> setCrossfadeEnabled(bool value) => _p.setBool(_kCrossfadeEnabled, value);

  double get crossfadeDuration => (_p.getDouble(_kCrossfadeDuration) ?? 3.0);
  Future<void> setCrossfadeDuration(double value) => _p.setDouble(_kCrossfadeDuration, value);

  // Repeat the current track by default: when on, playback starts with
  // RepeatMode.one so a finished track restarts from the beginning (Elie).
  static const _kRepeatOneByDefault = 'repeat_one_by_default';
  bool get repeatOneByDefault => _p.getBool(_kRepeatOneByDefault) ?? false;
  Future<void> setRepeatOneByDefault(bool value) =>
      _p.setBool(_kRepeatOneByDefault, value);

  // ---------------------------------------------------------------------------
  // Exclusive Mode (WASAPI / bit-perfect)
  // ---------------------------------------------------------------------------

  static const _kExclusiveMode = 'exclusive_mode_enabled';

  bool get exclusiveModeEnabled => _p.getBool(_kExclusiveMode) ?? false;
  Future<void> setExclusiveModeEnabled(bool value) => _p.setBool(_kExclusiveMode, value);

  // ---------------------------------------------------------------------------
  // Metadata display fields
  // ---------------------------------------------------------------------------

  static const _kMetadataDisplayFields = 'metadata_display_fields';
  static const List<String> defaultMetadataDisplayFields = [
    'format',
    'genre',
    'year',
  ];

  List<String> get metadataDisplayFields {
    final stored = _p.getString(_kMetadataDisplayFields);
    if (stored == null) return defaultMetadataDisplayFields;
    try {
      final decoded = (stored.split(','))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      return decoded.isEmpty ? defaultMetadataDisplayFields : decoded;
    } catch (_) {
      return defaultMetadataDisplayFields;
    }
  }

  Future<void> setMetadataDisplayFields(List<String> fields) =>
      _p.setString(_kMetadataDisplayFields, fields.join(','));

  // ---------------------------------------------------------------------------
  // Last seen version (What's New dialog)
  // ---------------------------------------------------------------------------

  static const _kLastSeenVersion = 'last_seen_version';

  String? get lastSeenVersion => _p.getString(_kLastSeenVersion);

  Future<void> setLastSeenVersion(String version) =>
      _p.setString(_kLastSeenVersion, version);

  // ---------------------------------------------------------------------------
  // Reset (tests / onboarding)
  // ---------------------------------------------------------------------------

  Future<void> reset() => _p.clear();
}
