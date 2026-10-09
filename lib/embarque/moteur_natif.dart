/// Le moteur Tune, en bibliothèque native : `libtuneserver.so`, la caisse
/// `tune-ffi` de `tune-server-rust`, chargée par Dart FFI.
///
/// Cinq fonctions C, rien d'autre : tout le reste passe par HTTP sur
/// `127.0.0.1`, comme pour n'importe quelle télécommande.
library;

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef _DemarrerC =
    Int32 Function(
      Uint16 port,
      Pointer<Utf8> base,
      Pointer<Utf8> repertoires,
      Pointer<Utf8> web,
    );
typedef _DemarrerDart =
    int Function(
      int port,
      Pointer<Utf8> base,
      Pointer<Utf8> repertoires,
      Pointer<Utf8> web,
    );
typedef _EntierC = Int32 Function();
typedef _EntierDart = int Function();
typedef _ChaineC = Pointer<Utf8> Function();
typedef _LibererC = Void Function(Pointer<Utf8>);
typedef _LibererDart = void Function(Pointer<Utf8>);

/// Ce que l'application attend du moteur. Abstrait pour les essais : le
/// banc n'a pas de `libtuneserver.so` sous la main.
abstract class Moteur {
  /// `0` : lancé ; `-1` : tournait déjà ; `-2` : refus (base absente, panique).
  int demarrer({
    required int port,
    required String base,
    List<String> repertoires = const [],
    String? web,
  });

  /// `0` : signal d'arrêt envoyé ; `-1` : ne tournait pas.
  int arreter();

  /// La version compilée dans la bibliothèque (`1.0.0-rc3`).
  String version();
}

/// Les répertoires de musique tels que `tune_server_start` les lit : un
/// tableau JSON. Encodé pour de bon — l'ancienne concaténation laissait
/// passer un guillemet ou une barre oblique inverse dans un nom de dossier.
String repertoiresEnJson(List<String> repertoires) => jsonEncode(repertoires);

/// Le vrai moteur, chargé depuis la bibliothèque de l'APK.
class MoteurNatif implements Moteur {
  MoteurNatif._(DynamicLibrary lib)
    : _demarrer = lib.lookupFunction<_DemarrerC, _DemarrerDart>(
        'tune_server_start',
      ),
      _arreter = lib.lookupFunction<_EntierC, _EntierDart>('tune_server_stop'),
      _version = lib.lookupFunction<_ChaineC, _ChaineC>('tune_server_version'),
      _liberer = lib.lookupFunction<_LibererC, _LibererDart>(
        'tune_free_string',
      );

  final _DemarrerDart _demarrer;
  final _EntierDart _arreter;
  final _ChaineC _version;
  final _LibererDart _liberer;

  static MoteurNatif? _charge;

  /// Charge la bibliothèque une fois par isolat. Le service au premier plan
  /// tourne dans un AUTRE isolat que l'interface : il recharge la même
  /// bibliothèque, déjà en mémoire dans le processus, et parle donc au même
  /// serveur.
  static MoteurNatif charger() => _charge ??= MoteurNatif._(
    Platform.isAndroid
        ? DynamicLibrary.open('libtuneserver.so')
        : DynamicLibrary.process(),
  );

  @override
  int demarrer({
    required int port,
    required String base,
    List<String> repertoires = const [],
    String? web,
  }) {
    final b = base.toNativeUtf8();
    final r = repertoiresEnJson(repertoires).toNativeUtf8();
    final w = web == null ? nullptr : web.toNativeUtf8();
    try {
      return _demarrer(port, b, r, w);
    } finally {
      calloc.free(b);
      calloc.free(r);
      if (w != nullptr) calloc.free(w);
    }
  }

  @override
  int arreter() => _arreter();

  @override
  String version() {
    final p = _version();
    if (p == nullptr) return 'inconnue';
    try {
      return p.toDartString();
    } finally {
      _liberer(p);
    }
  }
}
