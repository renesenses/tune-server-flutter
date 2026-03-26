// ---------------------------------------------------------------------------
// T6.1 — StreamingService
// Interface + types partagés pour tous les services de streaming.
// Miroir de StreamingService.swift (iOS)
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Types résultats
// ---------------------------------------------------------------------------

/// Un résultat de recherche cross-service.
class StreamingSearchResult {
  final String id;
  final String title;
  final String? artist;
  final String? album;
  final int? durationMs;
  final String? coverUrl;
  final String? previewUrl;
  final String serviceId; // 'qobuz' | 'tidal' | 'youtube'
  final String type; // 'track' | 'album' | 'artist'
  final Map<String, dynamic> raw; // données brutes pour getStreamUrl

  const StreamingSearchResult({
    required this.id,
    required this.title,
    this.artist,
    this.album,
    this.durationMs,
    this.coverUrl,
    this.previewUrl,
    required this.serviceId,
    this.type = 'track',
    this.raw = const {},
  });
}

/// Résultat d'une authentification.
sealed class StreamingAuthResult {
  const StreamingAuthResult();
}

class StreamingAuthSuccess extends StreamingAuthResult {
  final String displayName; // ex: "jean@example.com" ou "Premium"
  const StreamingAuthSuccess(this.displayName);
}

class StreamingAuthFailure extends StreamingAuthResult {
  final String message;
  const StreamingAuthFailure(this.message);
}

/// Pour les flows OAuth Device Code (Tidal, YouTube).
class StreamingDeviceCodeResult extends StreamingAuthResult {
  final String deviceCode;
  final String userCode;    // code à saisir sur le site
  final String verificationUrl;
  final int expiresInSeconds;
  final int intervalSeconds;
  const StreamingDeviceCodeResult({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUrl,
    required this.expiresInSeconds,
    required this.intervalSeconds,
  });
}

/// État d'un service streaming.
class StreamingServiceStatus {
  final String serviceId;
  final bool enabled;
  final bool authenticated;
  final String? accountName;
  final String? quality; // 'lossless' | 'hi_res' | 'high' | 'normal'
  final String? errorMessage;

  const StreamingServiceStatus({
    required this.serviceId,
    required this.enabled,
    required this.authenticated,
    this.accountName,
    this.quality,
    this.errorMessage,
  });
}

/// Erreurs spécifiques streaming.
enum StreamingError {
  notAuthenticated,
  networkError,
  quotaExceeded,
  trackUnavailable,
  regionRestricted,
  unknown;

  String get message {
    switch (this) {
      case StreamingError.notAuthenticated:
        return 'Non authentifié';
      case StreamingError.networkError:
        return 'Erreur réseau';
      case StreamingError.quotaExceeded:
        return 'Quota dépassé';
      case StreamingError.trackUnavailable:
        return 'Piste indisponible';
      case StreamingError.regionRestricted:
        return 'Indisponible dans votre région';
      case StreamingError.unknown:
        return 'Erreur inconnue';
    }
  }
}

// ---------------------------------------------------------------------------
// Interface
// ---------------------------------------------------------------------------

/// Interface commune à tous les services de streaming.
abstract interface class StreamingService {
  /// Identifiant du service ('qobuz', 'tidal', 'youtube').
  String get serviceId;

  /// Nom affiché ('Qobuz', 'Tidal', 'YouTube').
  String get displayName;

  /// true si les credentials sont présents et valides.
  bool get isAuthenticated;

  // ---------------------------------------------------------------------------
  // Auth — email/password (Qobuz)
  // ---------------------------------------------------------------------------

  /// Authentifie avec email + mot de passe.
  /// Implémenté uniquement par Qobuz.
  Future<StreamingAuthResult> authenticateWithCredentials(
    String email,
    String password,
  ) => Future.value(const StreamingAuthFailure('Non supporté'));

  // ---------------------------------------------------------------------------
  // Auth — OAuth Device Code (Tidal, YouTube)
  // ---------------------------------------------------------------------------

  /// Démarre le flow Device Code. Retourne [StreamingDeviceCodeResult].
  Future<StreamingAuthResult> startDeviceCodeFlow() =>
      Future.value(const StreamingAuthFailure('Non supporté'));

  /// Attend la validation du Device Code (polling). Retourne [StreamingAuthSuccess]
  /// quand l'utilisateur a autorisé sur le site.
  Future<StreamingAuthResult> pollDeviceCodeFlow(
    StreamingDeviceCodeResult deviceCode,
  ) => Future.value(const StreamingAuthFailure('Non supporté'));

  // ---------------------------------------------------------------------------
  // Auth — persistance
  // ---------------------------------------------------------------------------

  /// Sauvegarde les tokens en DB (streaming_auth).
  Future<void> saveAuth(String tokenJson);

  /// Restaure les tokens depuis la DB.
  Future<bool> restoreAuth(String tokenJson);

  /// Déconnecte et supprime les tokens.
  Future<void> logout();

  // ---------------------------------------------------------------------------
  // Recherche
  // ---------------------------------------------------------------------------

  Future<List<StreamingSearchResult>> search(
    String query, {
    int limit = 20,
  });

  // ---------------------------------------------------------------------------
  // Pistes / albums / playlists
  // ---------------------------------------------------------------------------

  Future<StreamingSearchResult?> getTrack(String trackId);

  Future<String?> getStreamUrl(String trackId);

  Future<List<StreamingSearchResult>> getAlbumTracks(String albumId);

  Future<List<StreamingSearchResult>> getPlaylistTracks(String playlistId);

  // ---------------------------------------------------------------------------
  // État
  // ---------------------------------------------------------------------------

  StreamingServiceStatus get status;
}
