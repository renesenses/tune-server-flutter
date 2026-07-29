import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../event_bus.dart';
import 'license_manager.dart';

/// Periodic cloud licence validation for the embedded Flutter server.
///
/// Port of the Rust `spawn_heartbeat` (tune-server/src/background.rs): every
/// [_interval] it POSTs to mozaiklabs.fr and reconciles the licence state from
/// the response — including the floating-licence single-session
/// `session_conflict`, so a second server ("second house") is correctly
/// suppressed here while the licence is active elsewhere.
///
/// Degrades gracefully: any network/parse failure keeps the cached state (the
/// 30-day offline grace in [LicenseManager] covers it). No-op without a key.
class LicenseHeartbeat {
  static const _endpoint = 'https://mozaiklabs.fr/api/v1/heartbeat';
  static const _interval = Duration(minutes: 5);

  final LicenseManager _license;
  Timer? _timer;
  String? _version;

  LicenseHeartbeat(this._license);

  /// Start the periodic heartbeat (idempotent). Fires once immediately, then
  /// every [_interval].
  Future<void> start() async {
    if (_timer != null) return;
    try {
      _version = (await PackageInfo.fromPlatform()).version;
    } catch (_) {
      _version = null;
    }
    await _beat();
    _timer = Timer.periodic(_interval, (_) => _beat());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _beat() async {
    final ls = _license.licenseState;
    final hasKey = ls.licenseKey != null && ls.licenseKey!.isNotEmpty;
    // Without a key there is nothing for the cloud to validate.
    if (!hasKey) return;

    final payload = <String, dynamic>{
      'instance_id': await _license.instanceId(),
      'hardware_fingerprint': await _license.hardwareFingerprint(),
      'license_key': ls.licenseKey,
      'hostname': Platform.localHostname,
      if (_version != null) 'version': _version,
    };

    http.Response resp;
    try {
      resp = await http
          .post(
            Uri.parse(_endpoint),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('[license] heartbeat failed: $e');
      return;
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      debugPrint('[license] heartbeat rejected: ${resp.statusCode}');
      return;
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (_) {
      return; // no/invalid body → keep cached state
    }

    await _apply(body, hasKey: hasKey);
  }

  /// Reconcile the licence state from the heartbeat response. Mirrors the Rust
  /// heartbeat branch in `background.rs`.
  Future<void> _apply(Map<String, dynamic> body,
      {required bool hasKey}) async {
    // 1. Floating-licence single-session model: the cloud tells us when this
    // key is currently held by ANOTHER server. Unlike a bare
    // `license_valid:false` (transient, softened by the offline grace), a
    // conflict is authoritative "not now": suppress premium here, but keep the
    // key intact so it snaps back once the other server stops pinging.
    final wasInConflict = _license.sessionConflict != null;
    if (body['session_conflict'] == true) {
      final activeServer = body['active_server'] as String?;
      _license.setSessionConflict(activeServer, body['active_since'] as String?);
      if (!wasInConflict) {
        EventBus.instance.emit(LicenseSessionConflictChangedEvent(true,
            activeServer: activeServer));
      }
      return;
    }
    _license.clearSessionConflict();
    if (wasInConflict) {
      EventBus.instance.emit(const LicenseSessionConflictChangedEvent(false));
    }

    // 2. Normal verdict — only when the server actually evaluated a licence.
    final tierStr = body['license_tier'];
    if (tierStr is! String) return; // no licence fields → keep cached state

    final valid = body['license_valid'] != false; // absent/true → valid
    final expiresAt = body['license_expires_at'] as String?;
    final expiredAuthoritatively = expiresAt != null && _isPast(expiresAt);

    if (!valid && hasKey && !expiredAuthoritatively) {
      // Transient rejection (fingerprint re-binding, server hiccup): keep the
      // cached tier and do NOT refresh lastValidated — the 30-day offline grace
      // then lapses on its own if the rejection persists, so a valid key
      // survives a bad verdict while a genuinely revoked one still degrades.
      debugPrint('[license] key rejected by server (keeping cached tier within grace)');
      return;
    }
    if (!valid) {
      await _license.updateFromServer(Tier.free, null);
      return;
    }

    final tier = tierStr == 'premium' ? Tier.premium : Tier.free;
    await _license.updateFromServer(tier, expiresAt);
  }

  /// Whether an ISO-8601 timestamp lies in the past. Fails OPEN (unparseable →
  /// false) so malformed server data never triggers a licence revocation —
  /// mirrors the Rust `is_timestamp_past`.
  static bool _isPast(String ts) {
    final d = DateTime.tryParse(ts);
    return d != null && d.toUtc().isBefore(DateTime.now().toUtc());
  }
}
