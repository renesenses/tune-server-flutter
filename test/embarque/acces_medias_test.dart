import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tune_server/embarque/acces_medias.dart';

void main() {
  test('Android 13+ : audio et images, séparément', () {
    final e = interpreter({
      Permission.audio: PermissionStatus.granted,
      Permission.photos: PermissionStatus.denied,
      Permission.storage: PermissionStatus.permanentlyDenied,
    });
    expect(e.musique, isTrue);
    expect(e.pochettes, isFalse);
  });

  test("Android 12 et avant : le stockage vaut pour tout", () {
    final e = interpreter({
      Permission.audio: PermissionStatus.denied,
      Permission.photos: PermissionStatus.denied,
      Permission.storage: PermissionStatus.granted,
    });
    expect(e.musique, isTrue);
    expect(e.pochettes, isTrue);
  });

  test('accès partiel aux images : compté comme accordé', () {
    final e = interpreter({Permission.photos: PermissionStatus.limited});
    expect(e.pochettes, isTrue);
    expect(e.musique, isFalse);
  });

  test(
    "on demande audio, images et stockage — jamais la gestion de tous les fichiers",
    () async {
      List<Permission>? demandees;
      final e = await AccesMedias(
        demander: (p) async {
          demandees = p;
          return {for (final x in p) x: PermissionStatus.granted};
        },
      ).obtenir();
      expect(demandees, [
        Permission.audio,
        Permission.photos,
        Permission.storage,
      ]);
      expect(demandees, isNot(contains(Permission.manageExternalStorage)));
      expect(e.musique && e.pochettes, isTrue);
    },
  );

  test('une erreur du système ne bloque pas le démarrage', () async {
    final e = await AccesMedias(
      demander: (_) async => throw StateError('x'),
    ).obtenir();
    expect(e.musique, isFalse);
  });
}
