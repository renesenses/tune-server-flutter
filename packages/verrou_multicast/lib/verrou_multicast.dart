/// Le `WifiManager.MulticastLock` d'Android, vu de Dart.
library;

import 'package:flutter/services.dart';

/// Prend et rend le verrou multicast Wi-Fi. Sans lui, un téléphone peut
/// filtrer le multicast et le serveur ne découvre plus rien (SSDP, mDNS).
///
/// Hors Android (essais, autres plateformes), aucun hôte ne répond : chaque
/// appel rend `false` au lieu de lever.
class VerrouMulticast {
  const VerrouMulticast({MethodChannel? canal})
    : _canal = canal ?? const MethodChannel(nomCanal);

  static const nomCanal = 'com.mozaiklabs.tune/verrou_multicast';

  final MethodChannel _canal;

  /// `true` si le verrou est tenu au retour.
  Future<bool> prendre() => _appeler('prendre');

  /// `true` si le verrou n'est plus tenu au retour.
  Future<bool> rendre() => _appeler('rendre');

  Future<bool> estTenu() => _appeler('estTenu');

  Future<bool> _appeler(String methode) async {
    try {
      return await _canal.invokeMethod<bool>(methode) ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
