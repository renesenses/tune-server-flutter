// ---------------------------------------------------------------------------
// T4.1 — OutputTarget
// Interface commune à tous les outputs audio.
// Miroir du protocole OutputTarget.swift (iOS)
//
// Implémentations :
//   - LocalAudioOutput  (just_audio, Phase 4)
//   - DLNAOutput        (SOAP UPnP AVTransport, Phase 4)
//   - AirPlayOutput     (MethodChannel iOS, Phase 4)
// ---------------------------------------------------------------------------

/// État de préparation de l'output.
enum OutputReadyState { idle, preparing, ready, error }

/// Résultat d'une action sur l'output.
sealed class OutputResult {
  const OutputResult();
}

class OutputSuccess extends OutputResult {
  const OutputSuccess();
}

class OutputFailure extends OutputResult {
  final String message;
  const OutputFailure(this.message);
}

/// Interface contractuelle de tout output audio.
abstract interface class OutputTarget {
  // ---------------------------------------------------------------------------
  // Identité
  // ---------------------------------------------------------------------------

  /// Identifiant unique de l'output (ex: UDN du renderer, 'local', 'airplay').
  String get id;

  /// Nom affiché (ex: "Salon — DLNA", "Haut-parleurs", "AirPlay").
  String get displayName;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Prépare l'output pour la lecture (initialise la session, établit la connexion…).
  Future<OutputResult> prepare();

  /// Libère toutes les ressources de l'output.
  Future<void> dispose();

  // ---------------------------------------------------------------------------
  // Transport
  // ---------------------------------------------------------------------------

  /// Charge une URL audio et démarre la lecture.
  /// [url]   : URL HTTP (streamer local) ou chemin fichier.
  /// [title] / [artist] / [albumArtUrl] : métadonnées pour l'affichage.
  Future<OutputResult> play(
    String url, {
    String? title,
    String? artist,
    String? albumArtUrl,
  });

  /// Met en pause la lecture.
  Future<OutputResult> pause();

  /// Reprend la lecture après une pause.
  Future<OutputResult> resume();

  /// Arrête la lecture et libère le média en cours.
  Future<OutputResult> stop();

  /// Déplace la position de lecture.
  Future<OutputResult> seek(Duration position);

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  /// Règle le volume [0.0 – 1.0].
  Future<OutputResult> setVolume(double volume);

  /// Volume actuel [0.0 – 1.0]. Null si non disponible.
  double? get currentVolume;

  // ---------------------------------------------------------------------------
  // Position
  // ---------------------------------------------------------------------------

  /// Position de lecture courante. Null si rien n'est en cours.
  Future<Duration?> currentPosition();

  /// Durée totale du média en cours. Null si inconnue.
  Future<Duration?> duration();

  // ---------------------------------------------------------------------------
  // État
  // ---------------------------------------------------------------------------

  /// État de disponibilité de l'output.
  OutputReadyState get readyState;

  /// Indique si l'output est actuellement en train de lire.
  bool get isPlaying;
}
