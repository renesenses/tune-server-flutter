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

  LicenseState({
    required this.tier,
    this.licenseKey,
    this.expiresAt,
    this.lastValidated,
    this.accountPremium = false,
    this.accountPremiumExpires,
    this.accountPremiumChecked,
  });

  LicenseState copyWith() => LicenseState(
        tier: tier,
        licenseKey: licenseKey,
        expiresAt: expiresAt,
        lastValidated: lastValidated,
        accountPremium: accountPremium,
        accountPremiumExpires: accountPremiumExpires,
        accountPremiumChecked: accountPremiumChecked,
      );

  Map<String, dynamic> toJson() => {
        'tier': tier.asString,
        'license_key': licenseKey,
        'expires_at': expiresAt,
        'last_validated': lastValidated,
        'account_premium': accountPremium,
        'account_premium_expires': accountPremiumExpires,
        'account_premium_checked': accountPremiumChecked,
      };
}

/// Dart port of the Rust `LicenseManager` (`tune-core/src/license.rs`), for the
/// **embedded** Flutter server. Free tier is capped at [freeMaxZones] zones;
/// Premium (license key OR active account premium) is unlimited.
///
/// State is loaded once from the settings table via [load]; query accessors
/// then read the in-memory snapshot synchronously. Mutators persist to settings.
class LicenseManager {
  /// Max zones on the Free tier. **Deliberately 3 on mobile** (the Rust server
  /// uses its own constant); a decision, not a copy — keep it explicit.
  static const int freeMaxZones = 3;

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

  /// Zone limit for the Free tier (for UI display).
  static int get freeZoneLimit => freeMaxZones;
}

// ---------------------------------------------------------------------------
// Pure helpers (mirror the Rust free functions, unit-tested directly)
// ---------------------------------------------------------------------------

/// Effective tier = Premium if the license key is premium OR the account
/// premium (SSO) is active. Otherwise Free.
Tier _effectiveTier(LicenseState s) =>
    (s.tier == Tier.premium || _accountPremiumActive(s)) ? Tier.premium : Tier.free;

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
