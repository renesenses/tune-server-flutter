import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../database/database.dart';
import '../database/repositories/settings_repository.dart';

/// Licence tiers. Mirror of the Rust `tune-core/src/license.rs` `Tier` enum
/// (serialised lowercase: "free" / "premium").
enum Tier {
  free,
  premium;

  String get asString => this == Tier.premium ? 'premium' : 'free';

  static Tier fromString(String? s) =>
      s == 'premium' ? Tier.premium : Tier.free;
}

/// Live signal that the premium licence is currently held by ANOTHER server
/// (floating-licence single-session model, à la Roon). Port of the Rust
/// `SessionConflict`. Set by the heartbeat when the cloud answers
/// `session_conflict:true`; runtime-only (never persisted) — the next heartbeat
/// re-establishes the truth. While present it suppresses premium *here* even
/// with an otherwise-valid key, and carries just enough context for the UI.
class SessionConflict {
  /// Label (or server_id) of the server currently holding the session.
  final String? activeServer;

  /// ISO-8601 timestamp of that server's last heartbeat.
  final String? activeSince;

  const SessionConflict({this.activeServer, this.activeSince});
}

/// Snapshot of the licence state. Port of the Rust `LicenseState`.
///
/// Premium can come from two OR-ed sources (see [_effectiveTier]):
///  - a premium license key (`tier`), or
///  - the linked mozaiklabs.fr **account** premium (SSO), which is time-boxed
///    by [accountPremiumExpires] and an offline grace window on
///    [accountPremiumChecked].
class LicenseState {
  Tier tier;
  String? licenseKey;
  String? expiresAt;
  String? lastValidated;
  bool accountPremium;
  String? accountPremiumExpires;
  String? accountPremiumChecked;

  /// Live single-session conflict: non-null while another server holds the
  /// floating licence. Runtime-only — never persisted; the next heartbeat
  /// restores it if still in conflict.
  SessionConflict? sessionConflict;

  LicenseState({
    required this.tier,
    this.licenseKey,
    this.expiresAt,
    this.lastValidated,
    this.accountPremium = false,
    this.accountPremiumExpires,
    this.accountPremiumChecked,
    this.sessionConflict,
  });

  LicenseState copyWith() => LicenseState(
        tier: tier,
        licenseKey: licenseKey,
        expiresAt: expiresAt,
        lastValidated: lastValidated,
        accountPremium: accountPremium,
        accountPremiumExpires: accountPremiumExpires,
        accountPremiumChecked: accountPremiumChecked,
        sessionConflict: sessionConflict,
      );

  Map<String, dynamic> toJson() => {
        'tier': tier.asString,
        'license_key': licenseKey,
        'expires_at': expiresAt,
        'last_validated': lastValidated,
        'account_premium': accountPremium,
        'account_premium_expires': accountPremiumExpires,
        'account_premium_checked': accountPremiumChecked,
        'session_conflict': sessionConflict == null
            ? null
            : {
                'active_server': sessionConflict!.activeServer,
                'active_since': sessionConflict!.activeSince,
              },
      };
}

/// Dart port of the Rust `LicenseManager` (`tune-core/src/license.rs`), for the
/// **embedded** Flutter server. Free tier is capped at [freeMaxZones] zones;
/// Premium (license key OR active account premium) is unlimited.
///
/// State is loaded once from the settings table via [load]; query accessors
/// then read the in-memory snapshot synchronously. Mutators persist to settings.
class LicenseManager {
  /// Max zones on the Free tier. Kept at 10 to match the Rust server for now
  /// (single source of truth for the freemium cap across platforms).
  static const int freeMaxZones = 10;

  /// Offline grace: premium is honoured this many days past the last successful
  /// server confirmation before degrading to Free.
  static const int gracePeriodDays = 30;

  final TuneDatabase _db;
  LicenseState _state =
      LicenseState(tier: Tier.free); // safe default before load()

  LicenseManager(this._db);

  SettingsRepository get _settings => _db.settingsRepo;

  /// Load cached state from settings. If the tier is premium but the last
  /// validation is older than [gracePeriodDays] (or missing), degrade to Free —
  /// same rule as the Rust manager's constructor.
  Future<void> load() async {
    final s = await _settings.getMultiple([
      'license_key',
      'license_tier',
      'license_expires_at',
      'license_last_validated',
      'mozaik_premium',
      'mozaik_premium_expires',
      'mozaik_premium_checked',
    ]);

    var tier = Tier.fromString(s['license_tier']);
    final lastValidated = s['license_last_validated'];
    if (tier == Tier.premium &&
        (lastValidated == null || _isExpired(lastValidated, gracePeriodDays))) {
      debugPrint('[license] grace period expired or unvalidated, degrading to free');
      tier = Tier.free;
    }

    _state = LicenseState(
      tier: tier,
      licenseKey: s['license_key'],
      expiresAt: s['license_expires_at'],
      lastValidated: lastValidated,
      accountPremium: s['mozaik_premium'] == 'true',
      accountPremiumExpires: s['mozaik_premium_expires'],
      accountPremiumChecked: s['mozaik_premium_checked'],
    );
    debugPrint('[license] initialised: tier=${effectiveTier.asString}');
  }

  /// Effective tier: Premium if a premium license key OR an active account
  /// premium (SSO) is present. All gating uses this.
  Tier get effectiveTier => _effectiveTier(_state);

  bool get isPremium => effectiveTier == Tier.premium;

  /// All premium features require the effective Premium tier.
  bool checkFeature() => isPremium;

  /// Whether adding a new zone is allowed given the current zone count.
  /// Free: max [freeMaxZones]. Premium: unlimited.
  bool checkZoneLimit(int currentCount) => _checkZoneLimit(_state, currentCount);

  /// Snapshot for API/UI. `tier` reflects the *effective* tier.
  LicenseState get licenseState {
    final snapshot = _state.copyWith();
    snapshot.tier = effectiveTier;
    return snapshot;
  }

  /// Store a license key and set tier to Premium (server-side validation happens
  /// later via heartbeat).
  Future<void> setLicenseKey(String key) async {
    final now = _nowIso();
    await _settings.set('license_key', key);
    await _settings.set('license_tier', 'premium');
    await _settings.set('license_last_validated', now);
    _state.licenseKey = key;
    _state.tier = Tier.premium;
    _state.lastValidated = now;
  }

  /// Remove the license key and revert to Free.
  Future<void> clearLicense() async {
    await _settings.delete('license_key');
    await _settings.set('license_tier', 'free');
    await _settings.delete('license_expires_at');
    await _settings.delete('license_last_validated');
    _state.licenseKey = null;
    _state.tier = Tier.free;
    _state.expiresAt = null;
    _state.lastValidated = null;
  }

  /// Called by heartbeat when the licensing server responds.
  Future<void> updateFromServer(Tier tier, String? expiresAt) async {
    final now = _nowIso();
    await _settings.set('license_tier', tier.asString);
    await _settings.set('license_last_validated', now);
    if (expiresAt != null) {
      await _settings.set('license_expires_at', expiresAt);
    } else {
      await _settings.delete('license_expires_at');
    }
    _state.tier = tier;
    _state.expiresAt = expiresAt;
    _state.lastValidated = now;
  }

  /// Set the account premium (SSO) state, stamping the check time for the
  /// offline grace window. Called after SSO login / periodic refresh.
  Future<void> setAccountPremium(bool premium, String? expires) async {
    final now = _nowIso();
    await _settings.set('mozaik_premium', premium ? 'true' : 'false');
    await _settings.set('mozaik_premium_checked', now);
    if (expires != null) {
      await _settings.set('mozaik_premium_expires', expires);
    } else {
      await _settings.delete('mozaik_premium_expires');
    }
    _state.accountPremium = premium;
    _state.accountPremiumExpires = expires;
    _state.accountPremiumChecked = now;
  }

  /// Clear the account premium (SSO logout). The license-key path is untouched.
  Future<void> clearAccountPremium() async {
    await _settings.delete('mozaik_premium');
    await _settings.delete('mozaik_premium_expires');
    await _settings.delete('mozaik_premium_checked');
    _state.accountPremium = false;
    _state.accountPremiumExpires = null;
    _state.accountPremiumChecked = null;
  }

  // --- Single-session conflict (floating licence) ---

  /// Record that the floating licence is currently held by ANOTHER server
  /// (cloud answered `session_conflict:true`). Gates the effective tier to Free
  /// here — authoritative "not now" — WITHOUT touching the key or lastValidated,
  /// so premium snaps back the moment the other server stops pinging.
  void setSessionConflict(String? activeServer, String? activeSince) {
    final wasClear = _state.sessionConflict == null;
    _state.sessionConflict =
        SessionConflict(activeServer: activeServer, activeSince: activeSince);
    if (wasClear) {
      debugPrint('[license] session conflict set — held by another server');
    }
  }

  /// Clear a previously recorded session conflict (reclaimed here / no conflict).
  void clearSessionConflict() {
    if (_state.sessionConflict != null) {
      _state.sessionConflict = null;
      debugPrint('[license] session conflict cleared — reclaimed here');
    }
  }

  /// Current session conflict, if the licence is held elsewhere right now.
  SessionConflict? get sessionConflict => _state.sessionConflict;

  // --- Device identity (for the cloud heartbeat) ---

  /// Stable per-install hardware fingerprint (64-hex), persisted. Generated once
  /// from the hostname + a random salt; mirrors the *role* of the Rust SHA-256
  /// fingerprint (mobile has no stable hardware serial without extra plugins, so
  /// a persisted per-install id is the pragmatic equivalent — one device, one
  /// activation).
  Future<String> hardwareFingerprint() async {
    final cached = await _settings.get('hardware_fingerprint');
    if (cached != null && cached.isNotEmpty) return cached;
    final salt = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    final digest =
        sha256.convert([...utf8.encode('${Platform.localHostname}:'), ...salt]);
    final fp = digest.toString();
    await _settings.set('hardware_fingerprint', fp);
    return fp;
  }

  /// Stable per-install instance id (UUID-v4-shaped), persisted. Sent with the
  /// heartbeat so the cloud can dedupe this server instance.
  Future<String> instanceId() async {
    final cached = await _settings.get('instance_id');
    if (cached != null && cached.isNotEmpty) return cached;
    final b = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40; // version 4
    b[8] = (b[8] & 0x3f) | 0x80; // variant
    String h(int i) => b[i].toRadixString(16).padLeft(2, '0');
    final id = '${h(0)}${h(1)}${h(2)}${h(3)}-${h(4)}${h(5)}-${h(6)}${h(7)}'
        '-${h(8)}${h(9)}-${h(10)}${h(11)}${h(12)}${h(13)}${h(14)}${h(15)}';
    await _settings.set('instance_id', id);
    return id;
  }

  /// Zone limit for the Free tier (for UI display).
  static int get freeZoneLimit => freeMaxZones;
}

// ---------------------------------------------------------------------------
// Pure helpers (mirror the Rust free functions, unit-tested directly)
// ---------------------------------------------------------------------------

/// Effective tier = Premium if the license key is premium OR the account
/// premium (SSO) is active. Otherwise Free.
///
/// A live single-session conflict overrides everything: while another server
/// holds the floating licence, premium is suppressed here even though the key /
/// account are otherwise valid. This enforces "one active session at a time"
/// and, unlike a transient rejection, is authoritative (not softened by grace).
Tier _effectiveTier(LicenseState s) {
  if (s.sessionConflict != null) return Tier.free;
  return (s.tier == Tier.premium || _accountPremiumActive(s))
      ? Tier.premium
      : Tier.free;
}

/// Pure zone-limit rule: Premium unlimited, Free capped at [LicenseManager.freeMaxZones].
bool _checkZoneLimit(LicenseState s, int currentCount) =>
    _effectiveTier(s) == Tier.premium
        ? true
        : currentCount < LicenseManager.freeMaxZones;

/// Whether the account premium (SSO) currently counts as active: flag set, its
/// subscription not past, and last confirmed within the offline grace window.
bool _accountPremiumActive(LicenseState s) {
  if (!s.accountPremium) return false;
  final exp = s.accountPremiumExpires;
  if (exp != null && _isExpired(exp, 0)) return false;
  final checked = s.accountPremiumChecked;
  return checked != null &&
      !_isExpired(checked, LicenseManager.gracePeriodDays);
}

/// Whether an ISO-8601 timestamp is older than [days] from now. Unparseable →
/// treated as expired (same as the Rust helper).
bool _isExpired(String timestamp, int days) {
  final parsed = DateTime.tryParse(timestamp);
  if (parsed == null) return true;
  final cutoff = DateTime.now().toUtc().subtract(Duration(days: days));
  return parsed.toUtc().isBefore(cutoff);
}

String _nowIso() => DateTime.now().toUtc().toIso8601String();

/// Thrown by the zone manager when a Free-tier user tries to exceed
/// [LicenseManager.freeMaxZones] zones.
class ZoneLimitException implements Exception {
  final int limit;
  const ZoneLimitException(this.limit);

  @override
  String toString() =>
      'ZoneLimitException: free tier limited to $limit zones';
}

/// Expose the pure helpers to tests without leaking them into the public API.
@visibleForTesting
Tier effectiveTierForTest(LicenseState s) => _effectiveTier(s);
@visibleForTesting
bool isExpiredForTest(String timestamp, int days) => _isExpired(timestamp, days);
@visibleForTesting
bool checkZoneLimitForTest(LicenseState s, int currentCount) =>
    _checkZoneLimit(s, currentCount);
