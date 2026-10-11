# CLAUDE.md — Tune serveur (Flutter, Android)

## Projet

Application Android « Tune serveur » : **le serveur Tune dans le téléphone**.

- **Moteur** : le serveur Rust (`libtuneserver.so`, caisse `tune-ffi` de
  `tune-server-rust`), chargé par Dart FFI et lancé derrière un service au
  premier plan de type `mediaPlayback` (`flutter_foreground_task`).
- **Interface** : celle de la télécommande **`tune-remote-flutter`**, prise en
  dépendance et **jamais recopiée**. Elle parle au moteur sur
  `http://127.0.0.1:8888`, exactement comme à un serveur du réseau ; les autres
  appareils joignent le téléphone sur son port 8888.

Le moteur Dart historique (`lib/server`, Drift, shelf…) a été retiré le
09/10/2026 (go de Bertrand) : le mode serveur est désormais le moteur Rust.

## L'interface : `tune_remote` en dépendance git épinglée

`pubspec.yaml` prend `tune_remote` par git, **épinglé sur un commit** (`ref:`).
Pourquoi cette méthode plutôt qu'un sous-module ou un paquet extrait :
- un seul code d'interface, aucune synchronisation à la main ;
- la version prise est explicite et rejouable (`ref` + `pubspec.lock`), et la
  monter est un changement d'une ligne, relu en PR et rejoué par la CI ;
- pas d'état de sous-module à oublier (`git submodule update`), pas de nouveau
  dépôt (interdit) ;
- pub résout les dépendances de l'interface (Riverpod, http…) avec les nôtres.

Côté télécommande, `lancerTune(paquet: 'tune_remote')` lance l'interface ;
`Jetons.paquet` fait résoudre polices et logos sous `packages/tune_remote/`.

**Monter l'interface** : changer `ref:` (et la ligne `tune_remote` de
`pubspec.lock`), puis tests.

**Machines sans accès git au dépôt privé** (Shrek) : extraire le commit épinglé
et pointer dessus par `scripts/interface-locale.sh <copie>`, qui écrit
`pubspec_overrides.yaml` (ignoré par git) et refuse une copie à un autre commit.
La CI lit le dépôt privé avec le secret `TUNE_REMOTE_READ_TOKEN`.

## Build

```bash
flutter pub get
flutter test
flutter build apk --release --target-platform android-arm64
```

Tout se compile et se teste sur Shrek (`~/sdk/flutter-3.44.9`, SDK Android
dans `~/android/sdk`, JDK dans `~/android/jdk21`).

## Architecture

```
lib/
├── main.dart                 # démarre le moteur, puis lancerTune()
└── embarque/
    ├── moteur_natif.dart     # liaisons FFI (5 fonctions C)
    ├── serveur_embarque.dart # service + moteur + attente de /system/health
    ├── android.dart          # flutter_foreground_task, dossiers par défaut
    ├── demarrage.dart        # écran d'attente / d'échec
    ├── preferences.dart      # adresse 127.0.0.1 + bienvenue passée
    └── tache_serveur.dart    # isolat du service : verrou multicast, arrêt
packages/verrou_multicast/    # greffon local : WifiManager.MulticastLock
```

Le **verrou multicast** est pris par le service au premier plan à son
démarrage et rendu à son arrêt (greffon, donc présent dans le moteur Flutter
du service même sans activité). Sans lui, un téléphone filtre le multicast
Wi-Fi : SSDP et mDNS deviennent aveugles. L'émulateur ne filtre pas.

## Bibliothèques natives Android (`libtuneserver.so`)

Le moteur est le serveur Rust (caisse `tune-ffi` de `tune-server-rust`),
chargé par Dart FFI. **Une seule ABI est livrée : arm64-v8a**
(`android/app/src/main/jniLibs/arm64-v8a/libtuneserver.so`) ; Gradle filtre
les ABI (`abiFilters`) pour que l'APK ne s'installe pas là où elle manque.

La version attendue du moteur est le tag Rust écrit dans
**`tune-engine.version`** (racine du dépôt), et non plus la version de
`pubspec.yaml` : l'interface vient de `tune-remote-flutter` et suit son propre
numéro. L'empreinte est figée dans `android/app/src/main/jniLibs/tune-native.manifest`.

`scripts/check-native-libs.sh` **fait échouer** tout build Android dont la
`.so` ne porte pas cette version, ou dont l'empreinte a changé — branché sur
`preBuild` (Gradle) et sur la CI. Ce n'est pas un avertissement (#1751).

Reconstruire (sur Shrek, NDK r28c, cf. `tune-ffi/build-android.sh` pour
l'environnement CMake/opus) :

```bash
# dans tune-server-rust, au tag de tune-engine.version
TUNE_VERSION=<tag sans v> cargo build -p tune-ffi --target aarch64-linux-android --release
# ici
cp …/libtuneserver.so android/app/src/main/jniLibs/arm64-v8a/
scripts/check-native-libs.sh --update   # régénère l'empreinte
```

puis committer **la `.so`, le manifeste et `tune-engine.version`**. `--update`
refuse de tamponner une bibliothèque qui ne contient pas la version attendue.

## CRITICAL RULES

- **NEVER mention or reference recorder, recording, or special-edition features.** This is a public repo.
