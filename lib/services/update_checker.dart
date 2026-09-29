// Flutter app update check.
//
// The Flutter build is an embedded-server app (it doesn't connect to a
// remote tune-server), so the FastAPI /system/update/check endpoint
// doesn't apply — we'd be polling ourselves. Instead we hit GitHub
// Releases for tune-server-flutter directly and compare the latest tag
// against the bundled pubspec version. SettingsView surfaces a banner
// when a newer build is on GitHub. Same UX rhythm as the web client's
// MAJ badge and the macOS menubar's update notice.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class UpdateInfo {
  final String currentVersion;
  final String? latestVersion;
  final bool updateAvailable;
  final String? releaseUrl;

  const UpdateInfo({
    required this.currentVersion,
    this.latestVersion,
    required this.updateAvailable,
    this.releaseUrl,
  });
}

class UpdateChecker {
  static const _githubLatest =
      'https://api.github.com/repos/renesenses/tune-server-flutter/releases/latest';

  Future<UpdateInfo> check() async {
    final info = await PackageInfo.fromPlatform();
    final current = info.version; // "0.7.24"
    try {
      final resp = await http.get(Uri.parse(_githubLatest)).timeout(
            const Duration(seconds: 8),
          );
      if (resp.statusCode != 200) {
        return UpdateInfo(currentVersion: current, updateAvailable: false);
      }
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      // `replaceFirst(RegExp('^v'))` et non `replaceAll('v')` : on retire le
      // préfixe, pas une lettre au hasard du suffixe.
      final tag = (body['tag_name'] as String? ?? '').replaceFirst(RegExp('^v'), '');
      final url = body['html_url'] as String?;
      if (tag.isEmpty) {
        return UpdateInfo(currentVersion: current, updateAvailable: false);
      }
      return UpdateInfo(
        currentVersion: current,
        latestVersion: tag,
        updateAvailable: _isNewer(tag, current),
        releaseUrl: url,
      );
    } catch (_) {
      // Network failure / GitHub down — degrade silently rather than
      // spamming Sentry. Worst case the user misses one polling window.
      return UpdateInfo(currentVersion: current, updateAvailable: false);
    }
  }

  /// `newVersion` est-elle STRICTEMENT plus récente que `current` ?
  ///
  /// L'ancienne comparaison passait chaque morceau à `int.parse` : sur
  /// `1.0.0-rc1`, `int.parse('0-rc1')` levait, le `catch` rendait `false`, et
  /// aucune mise à jour n'était jamais signalée, ni vers une RC ni depuis une
  /// RC. `pub_semver` suit semver : `1.0.0-rc1 < 1.0.0`. Une version
  /// illisible ne passe jamais pour plus récente.
  @visibleForTesting
  static bool isNewer(String newVersion, String current) {
    try {
      return Version.parse(_sansV(newVersion)) > Version.parse(_sansV(current));
    } on FormatException {
      return false;
    }
  }

  static String _sansV(String v) => v.trim().replaceFirst(RegExp('^v'), '');

  bool _isNewer(String newVersion, String current) => isNewer(newVersion, current);
}
