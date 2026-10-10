// Garde-fou du garde-fou : la protection « bump ≠ reconstruction » ne doit pas
// disparaître au premier remaniement.
//
// Les `libtuneserver.so` du serveur Rust sont versionnés dans ce dépôt et le
// bump de version ne les reconstruit pas. Sur 0.9.81, 0.9.85, 0.9.89, 0.9.90 et
// 0.9.91, le commit de bump a laissé la CI rouge sur le job « Bibliothèques
// natives à jour » et il a fallu un commit séparé de reconstruction pour la
// repasser au vert. Une fois, personne n'a vu la dérive : les testeurs Android
// ont tourné trois semaines et demie sur un moteur du 21 juillet dans une
// interface récente.
//
// Trois verrous ferment la porte, du plus tôt au plus tard :
//   1. `scripts/bump-all.sh` (dépôt tune-server-rust) reconstruit lui-même ;
//   2. le hook `pre-commit` refuse le commit de bump sans les `.so` ;
//   3. la CI refuse la PR.
//
// Ce fichier tient les verrous 2 et 3, et vérifie surtout que le garde-fou
// FAIT ÉCHOUER un bump nu — un test qui ne relirait que du texte ne dirait
// rien du jour où le script cesse de refuser.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Trois octets d'ELF suffisent : le garde-fou cherche la version en clair
/// dans le binaire, il ne le charge jamais. Inutile de compiler quoi que ce
/// soit pour prouver qu'il refuse.
File _faussLibrairie(Directory racine, String abi, String version) {
  final f = File('${racine.path}/android/app/src/main/jniLibs/$abi/libtuneserver.so');
  f.parent.createSync(recursive: true);
  f.writeAsStringSync('\x7fELF fake libtuneserver $version build\n');
  return f;
}

/// Un dépôt jetable qui a la forme attendue par `check-native-libs.sh` :
/// le vrai script, un `pubspec.yaml` minimal, trois `.so` factices.
Directory _depotFactice(String version) {
  final racine = Directory.systemTemp.createTempSync('tune-native-guard');
  addTearDown(() => racine.deleteSync(recursive: true));

  File('${racine.path}/pubspec.yaml').writeAsStringSync(
    'name: tune_server\nversion: $version+1\n',
  );

  final scripts = Directory('${racine.path}/scripts')..createSync(recursive: true);
  final copie = File('${scripts.path}/check-native-libs.sh');
  copie.writeAsBytesSync(File('scripts/check-native-libs.sh').readAsBytesSync());
  Process.runSync('chmod', ['+x', copie.path]);

  for (final abi in const ['arm64-v8a', 'armeabi-v7a', 'x86_64']) {
    _faussLibrairie(racine, abi, version);
  }
  return racine;
}

ProcessResult _garde(Directory racine, List<String> args) => Process.runSync(
      'bash',
      ['${racine.path}/scripts/check-native-libs.sh', ...args],
      workingDirectory: racine.path,
    );

void _ecrireVersion(Directory racine, String version) =>
    File('${racine.path}/pubspec.yaml').writeAsStringSync(
      'name: tune_server\nversion: $version+2\n',
    );

void main() {
  group('check-native-libs.sh refuse un bump non reconstruit', () {
    test('un état cohérent passe', () {
      final racine = _depotFactice('0.9.90');
      expect(_garde(racine, ['--update']).exitCode, 0,
          reason: 'l\'empreinte doit pouvoir être générée sur un état sain');
      expect(_garde(racine, []).exitCode, 0);
    });

    test('bumper pubspec.yaml sans reconstruire les .so fait ÉCHOUER', () {
      final racine = _depotFactice('0.9.90');
      expect(_garde(racine, ['--update']).exitCode, 0);

      // Exactement ce que fait un commit de bump : la version bouge, les
      // bibliothèques restent celles de la version précédente.
      _ecrireVersion(racine, '0.9.91');

      final r = _garde(racine, []);
      expect(r.exitCode, 1,
          reason: 'un bump sans reconstruction DOIT être refusé — '
              'c\'est toute la raison d\'être de ce script');
      expect('${r.stderr}', contains('0.9.91'));
      expect('${r.stderr}', contains('0.9.90'));
    });

    test('remplacer un .so sans régénérer l\'empreinte fait ÉCHOUER', () {
      final racine = _depotFactice('0.9.90');
      expect(_garde(racine, ['--update']).exitCode, 0);

      _faussLibrairie(racine, 'arm64-v8a', '0.9.90')
          .writeAsStringSync('\x7fELF fake libtuneserver 0.9.90 autre build\n');

      expect(_garde(racine, []).exitCode, 1,
          reason: 'l\'empreinte sha256 doit détecter la substitution');
    });

    test('--update refuse de tamponner un binaire périmé', () {
      final racine = _depotFactice('0.9.90');
      _ecrireVersion(racine, '0.9.91'); // .so encore en 0.9.90

      expect(_garde(racine, ['--update']).exitCode, 1,
          reason: 'sinon il suffirait de relancer --update pour blanchir '
              'une dérive au lieu de la corriger');
      expect(
        File('${racine.path}/android/app/src/main/jniLibs/tune-native.manifest')
            .existsSync(),
        isFalse,
        reason: 'aucune empreinte ne doit rester derrière un --update refusé',
      );
    });

    test('un argument inconnu ne passe pas pour un succès', () {
      final racine = _depotFactice('0.9.90');
      expect(_garde(racine, ['--wat']).exitCode, 2);
    });
  });

  group('les trois verrous sont en place', () {
    test('le hook pre-commit interroge le garde-fou sur l\'index', () {
      final hook = File('.githooks/pre-commit');
      expect(hook.existsSync(), isTrue);
      final source = hook.readAsStringSync();

      expect(source, contains('check-native-libs.sh'),
          reason: 'sans cet appel, un commit de bump nu redevient possible');
      expect(source, contains('--staged'),
          reason: 'juger la copie de travail laisserait passer un .so '
              'reconstruit mais non ajouté à l\'index');
      expect(source, contains('pubspec.yaml'),
          reason: 'le déclencheur est le déplacement de la version');
      expect(RegExp(r'jniLibs').hasMatch(source), isTrue,
          reason: 'un .so remplacé seul doit aussi déclencher le contrôle');
    });

    test('le mode --staged existe toujours dans le garde-fou', () {
      final source = File('scripts/check-native-libs.sh').readAsStringSync();
      expect(source, contains('--staged'));
      expect(source, contains('ls-files --stage'),
          reason: 'le mode --staged doit lire l\'index, pas la copie de travail');
    });

    test('la CI conserve le job « Bibliothèques natives à jour »', () {
      final ci = File('.github/workflows/ci.yml').readAsStringSync();
      expect(ci, contains('check-native-libs.sh'),
          reason: 'dernier filet avant qu\'un APK périmé ne parte aux testeurs');
    });
  });
}
