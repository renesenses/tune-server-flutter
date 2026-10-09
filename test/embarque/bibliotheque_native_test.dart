import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// La garde des bibliothèques natives (#1751), telle que l'application
/// « Tune serveur » l'emploie : une seule ABI (arm64-v8a), et la version
/// attendue lue dans `tune-engine.version`, plus dans `pubspec.yaml`.
void main() {
  final racine = Directory.current.path;
  final script = '$racine/scripts/check-native-libs.sh';

  Future<ProcessResult> garde(String depot, [List<String> args = const []]) =>
      Process.run('bash', ['$depot/scripts/check-native-libs.sh', ...args]);

  test('le dépôt embarque un moteur conforme à tune-engine.version', () async {
    final r = await garde(racine);
    expect(r.exitCode, 0, reason: '${r.stdout}\n${r.stderr}');
    final version = File('$racine/tune-engine.version')
        .readAsLinesSync()
        .firstWhere((l) => l.trim().isNotEmpty && !l.startsWith('#'))
        .trim();
    expect(r.stdout, contains('v$version'));
  });

  test("seule l'ABI arm64-v8a est livrée, et Gradle la filtre", () {
    final jni = Directory('$racine/android/app/src/main/jniLibs');
    final abis = jni
        .listSync()
        .whereType<Directory>()
        .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
        .toList();
    expect(abis, ['arm64-v8a']);
    final gradle = File(
      '$racine/android/app/build.gradle.kts',
    ).readAsStringSync();
    expect(gradle, contains('abiFilters += listOf("arm64-v8a")'));
  });

  test('la libc++ partagée dont dépend le moteur est livrée avec lui', () {
    final dossier = '$racine/android/app/src/main/jniLibs/arm64-v8a';
    // Le nom figure dans la table dynamique (NEEDED) de la bibliothèque :
    // sans ce fichier, Android refuse de la charger (« library
    // "libc++_shared.so" not found », vu sur l'émulateur le 09/10).
    final moteur = File('$dossier/libtuneserver.so').readAsBytesSync();
    final besoin = 'libc++_shared.so'.codeUnits;
    bool contient(List<int> octets, List<int> motif) {
      for (var i = 0; i + motif.length <= octets.length; i++) {
        var ok = true;
        for (var j = 0; j < motif.length && ok; j++) {
          ok = octets[i + j] == motif[j];
        }
        if (ok) return true;
      }
      return false;
    }

    expect(contient(moteur, besoin), isTrue);
    expect(File('$dossier/libc++_shared.so').existsSync(), isTrue);
  });

  group('sur un dépôt factice', () {
    late Directory depot;
    late File so;

    setUp(() {
      depot = Directory.systemTemp.createTempSync('garde_native_');
      Directory('${depot.path}/scripts').createSync();
      File(script).copySync('${depot.path}/scripts/check-native-libs.sh');
      File(
        '${depot.path}/tune-engine.version',
      ).writeAsStringSync('# commentaire\n1.0.0-rc3\n');
      final dossier = Directory(
        '${depot.path}/android/app/src/main/jniLibs/arm64-v8a',
      )..createSync(recursive: true);
      so = File('${dossier.path}/libtuneserver.so');
    });

    tearDown(() => depot.deleteSync(recursive: true));

    test('--update refuse une bibliothèque d\'une autre version', () async {
      so.writeAsStringSync('ELF… tune 1.0.0-rc2 …');
      final r = await garde(depot.path, ['--update']);
      expect(r.exitCode, 1);
      expect(r.stderr, contains('ne contient pas la version 1.0.0-rc3'));
    });

    test('--update tamponne, puis un .so remplacé est refusé', () async {
      so.writeAsStringSync('ELF… tune 1.0.0-rc3 …');
      expect((await garde(depot.path, ['--update'])).exitCode, 0);
      expect((await garde(depot.path)).exitCode, 0);

      // Même version dans le binaire, mais ce n'est plus le même fichier.
      so.writeAsStringSync('ELF… tune 1.0.0-rc3 … reconstruit');
      final r = await garde(depot.path);
      expect(r.exitCode, 1);
      expect(r.stderr, contains("ne correspond pas à l'empreinte"));
    });

    test('changer tune-engine.version sans reconstruire est refusé', () async {
      so.writeAsStringSync('ELF… tune 1.0.0-rc3 …');
      expect((await garde(depot.path, ['--update'])).exitCode, 0);
      File('${depot.path}/tune-engine.version').writeAsStringSync('1.0.0\n');
      final r = await garde(depot.path);
      expect(r.exitCode, 1);
      expect(r.stderr, contains('attend le moteur 1.0.0'));
    });
  }, skip: Platform.isWindows ? 'bash requis' : null);
}
