// ---------------------------------------------------------------------------
// ErrorMapper — Maps technical errors to user-friendly French messages.
// Mirrors ErrorMapper.swift (iOS).
// ---------------------------------------------------------------------------

class ErrorMapperResult {
  final String message;
  final String? suggestion;

  const ErrorMapperResult(this.message, this.suggestion);
}

abstract final class ErrorMapper {
  static ErrorMapperResult userFriendly(String error) {
    final lower = error.toLowerCase();

    // ---- Network / Connection ----

    if (lower.contains('connection') ||
        lower.contains('timed out') ||
        lower.contains('no route') ||
        lower.contains('network')) {
      return const ErrorMapperResult(
        'Impossible de joindre le serveur',
        'Verifiez que Tune est en cours d\'execution et que vous etes sur le meme reseau Wi-Fi.',
      );
    }

    if (lower.contains('refused') || lower.contains('port')) {
      return const ErrorMapperResult(
        'Connexion refusee par le serveur',
        'Le serveur est peut-etre arrete ou le port est incorrect. Verifiez dans Reglages > Serveur.',
      );
    }

    // ---- Playback ----

    if (lower.contains('no zone') ||
        lower.contains('zone not found') ||
        lower.contains('aucune zone')) {
      return const ErrorMapperResult(
        'Aucune zone de lecture selectionnee',
        'Creez une zone dans Reglages > Zones, ou selectionnez un appareil de lecture.',
      );
    }

    if (lower.contains('playback') ||
        lower.contains('play failed') ||
        lower.contains('decode')) {
      return const ErrorMapperResult(
        'Impossible de lire cette piste',
        'Le fichier est peut-etre corrompu ou dans un format non supporte.',
      );
    }

    if (lower.contains('output') ||
        lower.contains('dlna') ||
        lower.contains('renderer')) {
      return const ErrorMapperResult(
        'L\'appareil de lecture ne repond pas',
        'Verifiez que l\'enceinte/DAC est allume et sur le meme reseau.',
      );
    }

    // ---- Library ----

    if (lower.contains('scan') ||
        lower.contains('music_dirs') ||
        lower.contains('directory')) {
      return const ErrorMapperResult(
        'Probleme lors du scan de la bibliotheque',
        'Verifiez que le dossier musical est accessible et que les permissions sont correctes.',
      );
    }

    // ---- Streaming auth ----

    if (lower.contains('auth') ||
        lower.contains('token') ||
        lower.contains('401') ||
        lower.contains('unauthorized')) {
      return const ErrorMapperResult(
        'Session de streaming expiree',
        'Reconnectez-vous au service dans Reglages > Streaming.',
      );
    }

    if (lower.contains('tidal') ||
        lower.contains('qobuz') ||
        lower.contains('deezer') ||
        lower.contains('spotify')) {
      return const ErrorMapperResult(
        'Erreur du service de streaming',
        'Le service peut etre temporairement indisponible. Reessayez dans quelques minutes.',
      );
    }

    // ---- Database ----

    if (lower.contains('database') ||
        lower.contains('sqlite') ||
        lower.contains('migration')) {
      return const ErrorMapperResult(
        'Erreur de base de donnees',
        'Essayez de redemarrer l\'application. Si le probleme persiste, utilisez Aide > Envoyer un rapport de bug.',
      );
    }

    // ---- Fallback ----

    return ErrorMapperResult(
      error,
      'Si le probleme persiste, consultez Aide > Depannage ou envoyez un rapport de bug.',
    );
  }
}
