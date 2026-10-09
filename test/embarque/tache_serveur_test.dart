import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/embarque/tache_serveur.dart';
import 'package:verrou_multicast/verrou_multicast.dart';

class _Verrou implements VerrouMulticast {
  bool tenu = false;
  final journal = <String>[];
  @override
  Future<bool> prendre() async {
    journal.add('prendre');
    return tenu = true;
  }

  @override
  Future<bool> rendre() async {
    journal.add('rendre');
    tenu = false;
    return true;
  }

  @override
  Future<bool> estTenu() async => tenu;
}

void main() {
  late _Verrou verrou;
  late List<String> journal;
  late TacheServeur tache;

  setUp(() {
    verrou = _Verrou();
    journal = [];
    tache = TacheServeur(
      verrou: verrou,
      arreterMoteur: () => journal.add('moteur arrêté'),
      arreterService: () async {
        journal.add('service arrêté');
        return null;
      },
    );
  });

  test('le verrou multicast est tenu tant que le service tourne', () async {
    await tache.onStart(DateTime.now(), TaskStarter.developer);
    expect(verrou.tenu, isTrue);

    await tache.onDestroy(DateTime.now());
    expect(verrou.tenu, isFalse);
    // Le moteur s'arrête AVANT que le verrou soit rendu : il ne doit pas
    // rester un serveur qui tourne sans entendre le réseau.
    expect(journal, ['moteur arrêté']);
    expect(verrou.journal, ['prendre', 'rendre']);
  });

  test('le verrou est rendu même si l\'arrêt du moteur lève', () async {
    final t = TacheServeur(
      verrou: verrou,
      arreterMoteur: () => throw StateError('bibliothèque absente'),
      arreterService: () async => null,
    );
    await t.onStart(DateTime.now(), TaskStarter.developer);
    await t.onDestroy(DateTime.now());
    expect(verrou.tenu, isFalse);
  });

  test('le bouton « Arrêter » de la notification arrête le service', () {
    tache.onNotificationButtonPressed('arreter');
    tache.onNotificationButtonPressed('autre');
    expect(journal, ['service arrêté']);
  });
}
