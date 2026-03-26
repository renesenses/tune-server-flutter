# Tune Server — Flutter

Serveur musical multi-room embarqué pour Android (et iOS). Diffuse la bibliothèque locale, des services streaming et des radios vers des enceintes DLNA/UPnP.

---

## Prérequis

| Outil | Version minimale |
|---|---|
| Flutter | 3.27+ (stable) |
| Dart | 3.11+ |
| Android SDK | API 21+ (minSdk) |
| Java | 17+ (pour Gradle) |
| build_runner | inclus dans `dev_dependencies` |

Vérifier l'environnement :

```bash
flutter doctor -v
```

---

## Installation

```bash
git clone git@github.com:renesenses/tune-server-flutter.git
cd tune-server-flutter
flutter pub get
```

### Générer le code (obligatoire après un clone ou un changement de schéma DB)

L'ORM [drift](https://drift.simonbinder.eu/) et la localisation nécessitent une étape de génération :

```bash
# Génère database.g.dart (ORM drift) et les stubs Dart des DAOs
flutter pub run build_runner build --delete-conflicting-outputs

# Génère lib/l10n/app_localizations*.dart depuis les fichiers ARB
flutter gen-l10n
```

> **Quand relancer `build_runner` ?**
> À chaque modification de `lib/server/database/schema.dart` ou d'un fichier annoté `@DriftDatabase` / `@DataClassName`.
>
> **Quand relancer `flutter gen-l10n` ?**
> À chaque ajout ou modification de clé dans les fichiers `lib/l10n/app_*.arb`.

---

## Lancer l'application

### Sur un appareil Android connecté

```bash
# Lister les appareils disponibles
flutter devices

# Lancer en mode debug (hot reload activé)
flutter run -d <device-id>

# Lancer en mode release
flutter run --release -d <device-id>
```

### Build APK

```bash
# APK debug
flutter build apk --debug

# APK release (signé — voir section Signature ci-dessous)
flutter build apk --release
```

L'APK se trouve dans `build/app/outputs/flutter-apk/`.

### Signature APK (release)

Créer un keystore et configurer `android/key.properties` :

```properties
storePassword=<mot_de_passe>
keyPassword=<mot_de_passe>
keyAlias=<alias>
storeFile=<chemin_absolu_vers_le_keystore>
```

Puis décommenter le bloc `signingConfigs` dans `android/app/build.gradle.kts`.

---

## Analyse statique

```bash
flutter analyze
```

Doit retourner **0 erreur**. Les warnings `unused_import` présents dans `server_engine.dart` sont des artefacts du template Flutter de base — ils peuvent être ignorés.

---

## Tests

### Tests unitaires / widget

```bash
flutter test
```

> Le fichier `test/widget_test.dart` est un placeholder généré par Flutter. Les vrais tests métier sont à écrire (voir section [Travail en cours](#travail-en-cours)).

### Analyse + tests enchaînés

```bash
flutter analyze && flutter test
```

---

## Structure du projet

```
lib/
├── l10n/               # Fichiers ARB (8 langues) + classes générées
├── models/             # Types non-DB : ZoneWithState, enums, domain_models
├── server/
│   ├── database/       # Schéma Drift, migrations, repositories
│   ├── discovery/      # SSDP, DiscoveryManager, UPnPIndexer
│   ├── library/        # LibraryScanner, ArtworkManager
│   ├── outputs/        # OutputTarget, DlnaOutput, LocalAudioOutput
│   ├── playback/       # Player, PlayQueue
│   ├── streaming/      # StreamingManager, Qobuz, RadioMetadata
│   └── zones/          # ZoneManager, ZoneInstance
├── state/              # AppState, ZoneState, LibraryState, SettingsState
└── views/              # UI Flutter (Provider + ChangeNotifier)
    ├── ipad/
    ├── iphone/
    ├── library/
    ├── nowplaying/
    ├── settings/
    └── zones/
```

---

## Localisation

Les traductions sont dans `lib/l10n/app_<langue>.arb` (fr, en, de, es, it, zh, ja, ko).

Pour ajouter une clé :
1. Ajouter la clé dans `app_fr.arb` (référence) et tous les autres ARB
2. Relancer `flutter gen-l10n`
3. Utiliser `AppLocalizations.of(context).maCle` dans le code

---

## Base de données

Drift SQLite, schéma version **4** (`lib/server/database/schema.dart`).

| Table | Rôle |
|---|---|
| `artists`, `albums`, `tracks` | Bibliothèque locale (+ FTS5 pour la recherche) |
| `zones`, `queue_items` | Zones de lecture et files |
| `saved_devices` | Appareils UPnP/DLNA mémorisés |
| `radios`, `radio_favorites` | Radios et favoris |
| `playlists`, `playlist_tracks` | Playlists manuelles |
| `streaming_auth`, `streaming_config` | Auth et config services streaming |

Migrations dans `TuneDatabase.migration` (`database.dart`).

---

## Travail en cours

### Refonte architecture multi-output (priorité haute)

Le plan complet est documenté dans `.claude/plans/jaunty-shimmying-hellman.md`.

**Objectif** : passer d'un modèle "1 Player par zone" à "1 Player maître → N appareils simultanés".

Résumé des changements planifiés :

1. **DB schema v5** — nouvelle table `zone_devices` + colonne `is_active` sur `zones`
2. **`Player`** — refonte multi-output (`Map<String, OutputTarget>` au lieu d'un seul output)
3. **`ZoneInstance`** — devient un wrapper de config (plus de Player propre)
4. **`ZoneManager`** — possède l'unique Player maître
5. **`ZoneWithState`** — ajoute `isActive: bool` + `devices: List<ZoneDeviceEntry>`
6. **NowPlaying** — barre "Diffusion en cours" + panel zones/appareils avec toggles et curseurs volume
7. **ZonesView** — gestion des appareils dans chaque zone (ajout/retrait)

Les fichiers concernés et le détail des changements sont dans le plan ci-dessus.

### Sources & Appareils (terminé)

Page accessible via Paramètres → Sources & Appareils :
- Liste les serveurs UPnP et renderers DLNA découverts
- Bouton "Indexer la bibliothèque" sur les serveurs
- Ajout manuel par IP/port
- Swipe pour oublier un appareil

---

## Permissions Android requises

Déclarées dans `android/app/src/main/AndroidManifest.xml` :

| Permission | Usage |
|---|---|
| `INTERNET` | Streaming, UPnP |
| `ACCESS_WIFI_STATE` / `CHANGE_WIFI_MULTICAST_STATE` | Découverte SSDP |
| `READ_MEDIA_AUDIO` / `READ_EXTERNAL_STORAGE` | Scan bibliothèque locale |
| `FOREGROUND_SERVICE_MEDIA_PLAYBACK` | Service de lecture en arrière-plan |
| `POST_NOTIFICATIONS` | Notification de lecture |
