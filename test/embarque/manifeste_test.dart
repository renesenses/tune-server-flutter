import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Ce que le manifeste Android déclare — et ce qu'il ne doit jamais déclarer.
void main() {
  final manifeste = File(
    'android/app/src/main/AndroidManifest.xml',
  ).readAsStringSync();

  test('permissions médias déclarées', () {
    expect(manifeste, contains('android.permission.READ_MEDIA_AUDIO'));
    expect(manifeste, contains('android.permission.READ_MEDIA_IMAGES'));
  });

  test('ni gestion de tous les fichiers, ni stockage « ancien »', () {
    // La politique Play refuse MANAGE_EXTERNAL_STORAGE pour l'accès aux
    // médias ; requestLegacyExternalStorage est sans effet en targetSdk 35.
    expect(
      manifeste,
      isNot(
        contains('android:name="android.permission.MANAGE_EXTERNAL_STORAGE"'),
      ),
    );
    expect(manifeste, isNot(contains('android:requestLegacyExternalStorage')));
  });

  test('READ_EXTERNAL_STORAGE reste bornée à Android 12', () {
    expect(
      RegExp(
        r'READ_EXTERNAL_STORAGE"\s+android:maxSdkVersion="32"',
      ).hasMatch(manifeste),
      isTrue,
    );
  });

  test(
    'service au premier plan de type mediaPlayback, sans démarrage au boot',
    () {
      expect(
        manifeste,
        contains('android:foregroundServiceType="mediaPlayback"'),
      );
      expect(manifeste, isNot(contains('RECEIVE_BOOT_COMPLETED')));
    },
  );
}
