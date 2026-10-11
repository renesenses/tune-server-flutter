import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verrou_multicast/verrou_multicast.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const canal = MethodChannel(VerrouMulticast.nomCanal);
  final messager =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messager.setMockMethodCallHandler(canal, null));

  test('prendre puis rendre parlent au côté Android', () async {
    var tenu = false;
    final appels = <String>[];
    messager.setMockMethodCallHandler(canal, (appel) async {
      appels.add(appel.method);
      switch (appel.method) {
        case 'prendre':
          tenu = true;
          return true;
        case 'rendre':
          tenu = false;
          return true;
        case 'estTenu':
          return tenu;
      }
      return null;
    });

    const v = VerrouMulticast();
    expect(await v.prendre(), isTrue);
    expect(await v.estTenu(), isTrue);
    expect(await v.rendre(), isTrue);
    expect(await v.estTenu(), isFalse);
    expect(appels, ['prendre', 'estTenu', 'rendre', 'estTenu']);
  });

  test('sans hôte Android, rien ne lève', () async {
    const v = VerrouMulticast();
    expect(await v.prendre(), isFalse);
    expect(await v.rendre(), isFalse);
  });

  test('une erreur de la plateforme devient false', () async {
    messager.setMockMethodCallHandler(
      canal,
      (_) async => throw PlatformException(code: 'wifi'),
    );
    expect(await const VerrouMulticast().prendre(), isFalse);
  });
}
