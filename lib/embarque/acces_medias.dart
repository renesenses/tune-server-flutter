/// L'accès aux fichiers de musique du téléphone, sans MANAGE_EXTERNAL_STORAGE.
///
/// La politique Play range « l'accès aux fichiers multimédias » parmi les
/// usages NON valides de MANAGE_EXTERNAL_STORAGE. On prend donc les
/// permissions médias :
/// - READ_MEDIA_AUDIO : les fichiers audio (Android 13+) ;
/// - READ_MEDIA_IMAGES : les pochettes posées à côté (`folder.jpg`,
///   `cover.jpg`) ;
/// - READ_EXTERNAL_STORAGE jusqu'à Android 12 (maxSdkVersion 32).
///
/// Avec elles, Android 11+ permet l'accès DIRECT PAR CHEMIN aux médias
/// (`/storage/emulated/0/Music/…`) : le moteur Rust lit les fichiers en
/// POSIX, sans URI `content://`. Limites connues, mesurées sur l'émulateur
/// (Android 14) le 09/10/2026 :
/// - les fichiers qui ne sont pas des médias (`.cue`, `.log`) restent
///   invisibles par cette voie ;
/// - **`folder.jpg` aussi** : MediaStore le classe `media_type=0` (non-média),
///   donc READ_MEDIA_IMAGES ne l'ouvre pas, alors que `cover.jpg` (classé
///   image) est lu et sert de pochette.
library;

import 'package:permission_handler/permission_handler.dart';

/// Ce que l'application peut lire.
class EtatMedias {
  const EtatMedias({required this.musique, required this.pochettes});

  /// Les fichiers audio.
  final bool musique;

  /// Les images posées à côté des albums.
  final bool pochettes;

  @override
  String toString() => 'EtatMedias(musique: $musique, pochettes: $pochettes)';
}

/// Les permissions demandées, dans l'ordre des boîtes de dialogue.
///
/// `storage` ne produit de dialogue que jusqu'à Android 12 (la permission
/// n'est déclarée que jusqu'au SDK 32) ; `audio` et `photos` qu'à partir
/// d'Android 13. Les demander toutes laisse le système ignorer celles qui ne
/// concernent pas sa version.
const permissionsMedias = [
  Permission.audio,
  Permission.photos,
  Permission.storage,
];

bool _accorde(PermissionStatus? s) =>
    s == PermissionStatus.granted || s == PermissionStatus.limited;

/// Lit les réponses du système. Le stockage « ancien » vaut pour la musique
/// comme pour les images (Android 12 et avant).
EtatMedias interpreter(Map<Permission, PermissionStatus> reponses) {
  final ancien = _accorde(reponses[Permission.storage]);
  return EtatMedias(
    musique: ancien || _accorde(reponses[Permission.audio]),
    pochettes: ancien || _accorde(reponses[Permission.photos]),
  );
}

class AccesMedias {
  AccesMedias({
    Future<Map<Permission, PermissionStatus>> Function(List<Permission>)?
    demander,
  }) : _demander = demander ?? ((p) => p.request());

  final Future<Map<Permission, PermissionStatus>> Function(List<Permission>)
  _demander;

  /// Demande ce qui manque et rend ce qui est accordé. Ne lève jamais :
  /// un refus n'empêche pas le serveur de démarrer (streaming, radios,
  /// serveurs UPnP restent possibles).
  Future<EtatMedias> obtenir() async {
    try {
      return interpreter(await _demander(permissionsMedias));
    } catch (_) {
      return const EtatMedias(musique: false, pochettes: false);
    }
  }
}
