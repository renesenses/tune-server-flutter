# Roadmap des corrections — erreurs `flutter run`

Erreurs relevées après la Phase 17. Organisées par catégorie et priorité.
Format : `[ ]` = à faire · `[x]` = corrigé.

---

## FX-01 — l10n.yaml : avertissement `synthetic-package` déprecié
**Fichier :** `l10n.yaml`
**Erreur :**
```
The argument "synthetic-package" no longer has any effect and should be removed.
```
**Correction :** Supprimer la ligne `synthetic-package: false` dans `l10n.yaml`.

- [x] Supprimer `synthetic-package: false` de `l10n.yaml`

---

## FX-02 — i18n : erreurs `const` context et paramètres nommés résiduels
**Fichiers :**
- `lib/views/radios/radio_favorites_view.dart:79` — `AppLocalizations.of(context)` dans un bloc `const`
- `lib/views/radios/radio_favorites_view.dart:121` — `radioFavExportDone(path: file.path)` paramètre nommé au lieu de positionnel
- `lib/views/streaming/streaming_album_detail_view.dart:146` — `AppLocalizations.of(context)` dans un bloc `const`
- `lib/views/streaming/streaming_view.dart:238` — `streamingLogoutBody(service: info.name)` paramètre nommé au lieu de positionnel
- `lib/views/settings/metadata_view.dart:130` — `metadataScanInProgress(current:, total:)` paramètres nommés
- `lib/views/settings/metadata_view.dart:152` — `metadataScanResult(added:, updated:)` paramètres nommés
- `lib/views/settings/metadata_view.dart:240` — `metadataFolderAddedOn(date:)` paramètre nommé

**Cause :** `flutter gen-l10n` génère des méthodes avec arguments positionnels, pas nommés. Certains widgets `const` englobants n'ont pas été retirés.

**Correction :**
- Remplacer les appels nommés par positionnels : `l.metadataScanInProgress(current, total)` → `l.metadataScanInProgress(current, total)`
- Retirer les `const` sur les `Center`/`Column` qui contiennent des appels `AppLocalizations.of(context)`

- [x] `radio_favorites_view.dart` : retirer `const` du `Center` + corriger `radioFavExportDone(file.path)`
- [x] `streaming_album_detail_view.dart` : retirer `const` du `SliverFillRemaining`/`Center` englobant
- [x] `streaming_view.dart` : vérifier l'appel `streamingLogoutBody(info.name)` (positionnel)
- [x] `metadata_view.dart` : vérifier tous les appels ARB paramétrés (positionnels)

---

## FX-03 — Conflit d'import `RepeatMode`
**Fichiers :**
- `lib/views/ipad/ipad_now_playing_bar.dart:4,190,194`
- `lib/views/nowplaying/now_playing_view.dart:140,143`

**Erreur :**
```
'RepeatMode' is imported from both
  'package:flutter/src/widgets/repeating_animation_builder.dart'
  'package:tune_server/models/enums.dart'
```
**Cause :** Flutter a ajouté un `RepeatMode` dans son propre package, qui entre en conflit avec celui du projet.

**Correction :** Masquer le `RepeatMode` de Flutter dans les imports concernés :
```dart
import 'package:flutter/material.dart' hide RepeatMode;
```
ou qualifier explicitement : `models.RepeatMode`.

- [x] `ipad_now_playing_bar.dart` : ajouter `hide RepeatMode` sur l'import Flutter
- [x] `now_playing_view.dart` : ajouter `hide RepeatMode` sur l'import Flutter

---

## FX-04 — Conflit d'import `DiscoveredDevice`
**Fichier :** `lib/state/zone_state.dart:6,105,108,116,126`

**Erreur :**
```
'DiscoveredDevice' is imported from both
  'package:tune_server/models/domain_models.dart'
  'package:tune_server/server/discovery/discovery_manager.dart'
```
**Cause :** `DiscoveredDevice` est défini dans `domain_models.dart` mais réexporté (ou redéfini) dans `discovery_manager.dart`.

**Correction :** Supprimer l'import redondant de `discovery_manager.dart` dans `zone_state.dart`, ou masquer `DiscoveredDevice` de l'un des deux.

- [x] `zone_state.dart` : supprimer l'import `discovery_manager.dart` ou ajouter `hide DiscoveredDevice`

---

## FX-05 — `app_state.dart` : `ZoneWithState` non trouvé + `setOutput` trop d'arguments
**Fichier :** `lib/state/app_state.dart:330,665`

**Erreurs :**
```
665: Type 'ZoneWithState' not found.
330: Too many positional arguments: 1 allowed, but 2 found.
     await engine.zoneManager.setOutput(zoneId, outputType, ...)
```
**Cause :**
- `ZoneWithState` n'est peut-être plus importé ou a été renommé.
- La signature de `ZoneManager.setOutput` a changé (n'accepte plus `zoneId` + `outputType`).

**Correction :**
- Vérifier l'import de `ZoneWithState` (devrait venir de `domain_models.dart`).
- Adapter l'appel `setOutput` à la signature actuelle de `ZoneManager`.

- [x] `app_state.dart:665` : ajouter/corriger l'import `ZoneWithState`
- [x] `app_state.dart:330` : adapter l'appel `setOutput` à la bonne signature

---

## FX-06 — `OutputType.airPlay` vs `OutputType.airplay` (casse enum)
**Fichier :** `lib/server/outputs/output_factory.dart:28,48,66`

**Erreurs :**
```
48: Member not found: 'airPlay'
66: Member not found: 'airPlay'
28: 'OutputType' is not exhaustively matched (doesn't match 'OutputType.airplay')
```
**Cause :** L'enum `OutputType` utilise `airplay` (minuscules) mais `output_factory.dart` utilise `airPlay` (camelCase).

**Correction :** Remplacer `OutputType.airPlay` par `OutputType.airplay` dans `output_factory.dart`.

- [x] `output_factory.dart` : corriger la casse `airPlay` → `airplay` (2 occurrences)

---

## FX-07 — `EventBus` : `whereType` non défini sur `Stream<AppEvent>`
**Fichier :** `lib/server/event_bus.dart:128,133`

**Erreur :**
```
The method 'whereType' isn't defined for the type 'Stream<AppEvent>'.
```
**Cause :** `whereType` est une méthode d'extension de `dart:async` sur `Stream` mais ne fonctionne pas directement sur un stream typé `Stream<AppEvent>`. Il faut caster ou utiliser `.where((e) => e is T).cast<T>()`.

**Correction :**
```dart
// Remplacer :
_controller.stream.whereType<T>()
// Par :
_controller.stream.where((e) => e is T).cast<T>()
```

- [x] `event_bus.dart:128` : remplacer `whereType<T>()` par `.where((e) => e is T).cast<T>()`
- [x] `event_bus.dart:133` : idem

---

## FX-08 — Repositories drift : `Future<List<Future<T>>>` type mismatch
**Fichiers :**
- `lib/server/database/repositories/track_repository.dart:88`
- `lib/server/database/repositories/playlist_repository.dart:56`
- `lib/server/database/repositories/artist_repository.dart:67`
- `lib/server/database/repositories/album_repository.dart:68`

**Erreur :**
```
A value of type 'Future<List<Future<Track>>>' can't be returned from an async function
with return type 'Future<List<Track>>'.
```
**Cause :** Dans la version actuelle de drift, `.get()` sur une requête avec `.map()` asynchrone retourne un `Future<List<Future<T>>>`. Il faut `await` chaque élément ou restructurer la requête.

**Correction :** Utiliser `await Future.wait(...)` pour aplatir :
```dart
final rows = await query.get();
return await Future.wait(rows.map((r) => _toModel(r)));
```
Ou restructurer la requête pour éviter le mapping async.

- [x] `track_repository.dart` : aplatir le type avec `Future.wait`
- [x] `playlist_repository.dart` : idem
- [x] `artist_repository.dart` : idem + corriger `coalesce` (voir FX-09)
- [x] `album_repository.dart` : idem

---

## FX-09 — `artist_repository.dart` : `coalesce` non défini sur `GeneratedColumn<String>`
**Fichier :** `lib/server/database/repositories/artist_repository.dart:45`

**Erreur :**
```
The method 'coalesce' isn't defined for the type 'GeneratedColumn<String>'.
```
**Cause :** L'API drift a changé. La méthode `coalesce` n'existe plus directement sur une colonne — elle a été déplacée ou renommée dans drift 2.x.

**Correction :** Utiliser `coalesce([a.sortName, a.name])` comme fonction top-level drift, ou `a.sortName.coalesceWith(a.name)` selon la version. Vérifier la version drift installée (`pubspec.lock`) et adapter.

- [x] `artist_repository.dart:45` : corriger l'appel `coalesce` pour drift 2.x

---

## FX-10 — `local_audio_output.dart` : `MediaItem` non trouvé
**Fichier :** `lib/server/audio/local_audio_output.dart:90,100`

**Erreur :**
```
The method 'MediaItem' isn't defined for the type 'LocalAudioOutput'.
```
**Cause :** `MediaItem` vient du package `audio_service`. L'import est probablement manquant ou le package a changé.

**Correction :** Ajouter l'import manquant :
```dart
import 'package:audio_service/audio_service.dart';
```

- [x] `local_audio_output.dart` : remplacer `MediaItem` par `Map` (audio_service absent de pubspec)

---

## FX-11 — Streaming services : interface `StreamingService` incomplète
**Fichiers :**
- `lib/server/streaming/youtube_service.dart:18`
- `lib/server/streaming/tidal_service.dart:16`
- `lib/server/streaming/qobuz_service.dart:17`

**Erreurs :**
```
YouTubeService : missing 'authenticateWithCredentials'
TidalService   : missing 'authenticateWithCredentials'
QobuzService   : missing 'pollDeviceCodeFlow', 'startDeviceCodeFlow'
```
**Cause :** L'interface `StreamingService` a été mise à jour avec de nouvelles méthodes abstraites, mais les implémentations concrètes n'ont pas suivi.

**Correction :**
- `YouTubeService` et `TidalService` : ajouter une implémentation stub de `authenticateWithCredentials` (retourne une erreur "not supported").
- `QobuzService` : ajouter des stubs pour `pollDeviceCodeFlow` et `startDeviceCodeFlow`.

- [x] `youtube_service.dart` : ajouter stub `authenticateWithCredentials`
- [x] `tidal_service.dart` : ajouter stub `authenticateWithCredentials`
- [x] `qobuz_service.dart` : ajouter stubs `startDeviceCodeFlow` + `pollDeviceCodeFlow`

---

## Récapitulatif

| ID    | Fichier(s)                         | Priorité | Complexité |
|-------|------------------------------------|----------|------------|
| FX-01 | `l10n.yaml`                        | Basse    | Triviale   |
| FX-02 | 4 vues (i18n const/params)         | Haute    | Faible     |
| FX-03 | 2 vues (RepeatMode)                | Haute    | Faible     |
| FX-04 | `zone_state.dart`                  | Haute    | Faible     |
| FX-05 | `app_state.dart`                   | Haute    | Moyenne    |
| FX-06 | `output_factory.dart`              | Haute    | Triviale   |
| FX-07 | `event_bus.dart`                   | Haute    | Faible     |
| FX-08 | 4 repositories drift               | Haute    | Moyenne    |
| FX-09 | `artist_repository.dart`           | Haute    | Faible     |
| FX-10 | `local_audio_output.dart`          | Haute    | Triviale   |
| FX-11 | 3 services streaming               | Haute    | Faible     |

**Total : 11 groupes d'erreurs, ~25 corrections unitaires.**
