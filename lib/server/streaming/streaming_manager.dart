import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/database.dart';
import 'qobuz_service.dart';
import 'streaming_service.dart';
import 'tidal_service.dart';
import 'youtube_service.dart';

// ---------------------------------------------------------------------------
// T6.5 — StreamingManager
// Bootstrap depuis DB, enable/disable, auth, resolveStreamUrl, searchAll.
// Miroir de StreamingManager.swift (iOS)
// ---------------------------------------------------------------------------

class StreamingManager {
  final TuneDatabase _db;

  final Map<String, StreamingService> _services = {};

  StreamingManager(this._db, {
    String qobuzAppId = '798273057',
    String qobuzAppSecret = 'abb21364945c0583309667d13ca3d93a',
  }) {
    // Enregistre tous les services (auth configurée plus tard via UI)
    _services['qobuz'] = QobuzService(
      appId: qobuzAppId,
      appSecret: qobuzAppSecret,
    );
    _services['tidal'] = TidalService();
    _services['youtube'] = YouTubeService();
  }

  // ---------------------------------------------------------------------------
  // Bootstrap — restaure l'état depuis la DB
  // ---------------------------------------------------------------------------

  Future<void> bootstrap() async {
    final configs = await _db.select(_db.streamingConfig).get();
    final auths = await _db.select(_db.streamingAuth).get();

    final authByService = {
      for (final a in auths) a.service: a.tokenData,
    };

    for (final config in configs) {
      if (!config.enabled) continue;
      final service = _services[config.service];
      if (service == null) continue;

      final tokenData = authByService[config.service];
      if (tokenData != null) {
        await service.restoreAuth(tokenData);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Accès
  // ---------------------------------------------------------------------------

  StreamingService? service(String serviceId) => _services[serviceId];

  List<StreamingService> get allServices =>
      List.unmodifiable(_services.values);

  List<StreamingServiceStatus> get status =>
      _services.values.map((s) => s.status).toList();

  // ---------------------------------------------------------------------------
  // Enable / Disable
  // ---------------------------------------------------------------------------

  Future<void> enableService(String serviceId) async {
    await _upsertConfig(serviceId, enabled: true);
  }

  Future<void> disableService(String serviceId) async {
    await _upsertConfig(serviceId, enabled: false);
    await _services[serviceId]?.logout();
  }

  // ---------------------------------------------------------------------------
  // Authentification
  // ---------------------------------------------------------------------------

  /// Auth email/password (Qobuz).
  Future<StreamingAuthResult> authenticateWithCredentials(
    String serviceId,
    String email,
    String password,
  ) async {
    final service = _services[serviceId];
    if (service == null) {
      return StreamingAuthFailure('Service "$serviceId" inconnu');
    }

    final result =
        await service.authenticateWithCredentials(email, password);

    if (result is StreamingAuthSuccess) {
      await _persistAuth(service);
    }
    return result;
  }

  /// Démarre le Device Code flow (Tidal / YouTube).
  Future<StreamingAuthResult> startDeviceCodeFlow(String serviceId) async {
    final service = _services[serviceId];
    if (service == null) {
      return StreamingAuthFailure('Service "$serviceId" inconnu');
    }
    return service.startDeviceCodeFlow();
  }

  /// Attend la validation du Device Code et persiste le token.
  Future<StreamingAuthResult> pollDeviceCodeFlow(
    String serviceId,
    StreamingDeviceCodeResult deviceCode,
  ) async {
    final service = _services[serviceId];
    if (service == null) {
      return StreamingAuthFailure('Service "$serviceId" inconnu');
    }

    final result = await service.pollDeviceCodeFlow(deviceCode);
    if (result is StreamingAuthSuccess) {
      await _persistAuth(service);
    }
    return result;
  }

  Future<void> logout(String serviceId) async {
    await _services[serviceId]?.logout();
    await (_db.delete(_db.streamingAuth)
          ..where((a) => a.service.equals(serviceId)))
        .go();
  }

  // ---------------------------------------------------------------------------
  // Stream URL
  // ---------------------------------------------------------------------------

  /// Résout l'URL de stream pour un track d'un service donné.
  Future<String?> resolveStreamUrl(
      String serviceId, String trackId) async {
    return _services[serviceId]?.getStreamUrl(trackId);
  }

  // ---------------------------------------------------------------------------
  // Recherche fédérée
  // ---------------------------------------------------------------------------

  /// Recherche en parallèle sur tous les services authentifiés.
  Future<Map<String, List<StreamingSearchResult>>> searchAll(
    String query, {
    int limitPerService = 20,
  }) async {
    final futures = <String, Future<List<StreamingSearchResult>>>{};

    for (final entry in _services.entries) {
      if (entry.value.isAuthenticated) {
        futures[entry.key] =
            entry.value.search(query, limit: limitPerService);
      }
    }

    final results = await Future.wait(
      futures.values,
      eagerError: false,
    );

    final keys = futures.keys.toList();
    return {
      for (var i = 0; i < keys.length; i++) keys[i]: results[i],
    };
  }

  // ---------------------------------------------------------------------------
  // Persistance DB
  // ---------------------------------------------------------------------------

  Future<void> _persistAuth(StreamingService service) async {
    // Récupère le tokenJson depuis le service concret
    String tokenData = '';
    if (service is QobuzService) tokenData = service.tokenJson;
    if (service is TidalService) tokenData = service.tokenJson;
    if (service is YouTubeService) tokenData = service.tokenJson;

    await _db.into(_db.streamingAuth).insertOnConflictUpdate(
          StreamingAuthCompanion.insert(
            service: service.serviceId,
            tokenData: tokenData,
            updatedAt: DateTime.now().toIso8601String(),
          ),
        );
  }

  Future<void> _upsertConfig(
    String serviceId, {
    required bool enabled,
  }) async {
    await _db.into(_db.streamingConfig).insertOnConflictUpdate(
          StreamingConfigCompanion.insert(
            service: serviceId,
            enabled: Value(enabled),
          ),
        );
  }
}
