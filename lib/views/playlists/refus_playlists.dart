import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'package:tune_server/services/tune_api_client.dart';

/// Ce qu'un échec d'appel playlists veut dire pour l'utilisateur.
enum RefusPlaylist {
  /// 402 `premium_required`, code `playlist_transfer` : Importer, Transférer.
  transfertPremium,

  /// 402 `premium_required` sur une route du greffon « Playlists converter »
  /// (code `plugin_marketplace`) : copies datées, liens de synchronisation.
  greffonPremium,

  /// 404 `plugin not found` / `wasm plugins not loaded` : greffon absent.
  greffonAbsent,

  /// Toute autre erreur : on garde le message d'erreur générique.
  autre,
}

/// Classe une erreur. Un 402 dont le code n'est pas `playlist_transfer` est
/// traité comme un refus du greffon : c'est la seule autre garde que ces
/// écrans rencontrent.
RefusPlaylist classerRefus(Object erreur) {
  if (erreur is TunePremiumRequiredException) {
    return erreur.code == 'playlist_transfer'
        ? RefusPlaylist.transfertPremium
        : RefusPlaylist.greffonPremium;
  }
  if (erreur is TuneHttpException && erreur.greffonAbsent) {
    return RefusPlaylist.greffonAbsent;
  }
  return RefusPlaylist.autre;
}

/// Le texte à montrer pour une erreur d'appel playlists.
String expliquerRefus(Object erreur, AppLocalizations l) {
  switch (classerRefus(erreur)) {
    case RefusPlaylist.transfertPremium:
      return l.plPremiumTransfer;
    case RefusPlaylist.greffonPremium:
      return l.plPremiumConverter;
    case RefusPlaylist.greffonAbsent:
      return l.plConverterMissing;
    case RefusPlaylist.autre:
      return l.errorWith(erreur.toString());
  }
}

/// Montre l'erreur dans une barre en bas d'écran, avec un bouton vers
/// l'offre quand le serveur a donné une adresse web (`upgrade_url`).
void montrerRefus(BuildContext context, Object erreur) {
  final l = AppLocalizations.of(context);
  final url = erreur is TunePremiumRequiredException ? erreur.upgradeUrlSure : null;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(expliquerRefus(erreur, l)),
      duration: Duration(seconds: url != null ? 8 : 4),
      action: url == null
          ? null
          : SnackBarAction(
              label: l.plSeeOffer,
              onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
            ),
    ),
  );
}
