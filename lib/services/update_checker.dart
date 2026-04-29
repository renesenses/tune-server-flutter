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
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

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
      final tag = (body['tag_name'] as String? ?? '').replaceAll('v', '');
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

  bool _isNewer(String newVersion, String current) {
    try {
      final newParts = newVersion.split('.').map(int.parse).toList();
      final curParts = current.split('.').map(int.parse).toList();
      while (newParts.length < curParts.length) newParts.add(0);
      while (curParts.length < newParts.length) curParts.add(0);
      for (var i = 0; i < newParts.length; i++) {
        if (newParts[i] > curParts[i]) return true;
        if (newParts[i] < curParts[i]) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
