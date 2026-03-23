# Tune Server Flutter — Roadmap

> **Process :** 1 tâche = 1 commit · 1 phase = 1 branche git · Clear contexte entre phases
> **Référence :** portage de `tune-server-ipados` (Swift 6 / GRDB / SwiftUI)
> **Cible :** iOS + Android (features iOS-only masquées sur Android via `Platform.isIOS`)
> **Hi-Res audio (24-bit/192kHz)** : non traité en phases initiales — marqué `[HI-RES-TODO]`

---

## Phase 0 — Fondation projet
**Branche :** `phase/0-foundation`

- [ ] **T0.1** Créer le projet Flutter (`flutter create --org com.mozaiklabs tune_server`) et configurer `pubspec.yaml` (drift, just_audio, shelf, crypto, xml, http, riverpod ou provider)
- [ ] **T0.2** Configurer les targets iOS (entitlements, Info.plist : réseau local, background audio, Bonjour services) et Android (permissions réseau, foreground service, Manifest)
- [ ] **T0.3** Définir la structure de dossiers miroir de l'app iOS (`lib/server/`, `lib/models/`, `lib/state/`, `lib/views/`, `lib/services/`)
- [ ] **T0.4** Créer les enums de base (`Source`, `AudioFormat`, `PlaybackState`, `RepeatMode`, `OutputType`, `ConnectionState`) dans `lib/models/enums.dart`
- [ ] **T0.5** Créer les domain models (`Track`, `Album`, `Artist`, `Playlist`, `Zone`, `RadioStation`, `DiscoveredDevice`, etc.) dans `lib/models/domain_models.dart`

---

## Phase 1 — Base de données (drift)
**Branche :** `phase/1-database`

- [ ] **T1.1** Définir le schéma drift (`lib/server/database/schema.dart`) : tables tracks, albums, artists, playlists, playlist_tracks, zones, queue_items, radios, radio_favorites, music_folders, saved_devices, streaming_config, history
- [ ] **T1.2** Implémenter `TuneDatabase` avec migrations et mode WAL
- [ ] **T1.3** Implémenter `TrackRepository` (CRUD + `forAlbum`, `forArtist`, `search` FTS5, `count`)
- [ ] **T1.4** Implémenter `AlbumRepository` (CRUD + `forArtist`, `search`, `count`, `all`)
- [ ] **T1.5** Implémenter `ArtistRepository` (CRUD + `search`, `count`, `all`)
- [ ] **T1.6** Implémenter `PlaylistRepository` (CRUD + `tracks(playlistId:)`)
- [ ] **T1.7** Implémenter `ZoneRepository` (CRUD)
- [ ] **T1.8** Implémenter `RadioRepository` (CRUD + `all`)

---

## Phase 2 — Noyau serveur
**Branche :** `phase/2-server-core`

- [ ] **T2.1** Implémenter `EventBus` (`StreamController<Event>` broadcast, `subscribe`, `unsubscribe`, `emit`) dans `lib/server/event_bus.dart`
- [ ] **T2.2** Implémenter `ServerConfiguration` (préférences persistées, port HTTP, setup completed) dans `lib/server/configuration.dart`
- [ ] **T2.3** Implémenter `NetworkUtils` (IP locale WiFi, scan subnet) dans `lib/server/utils/network_utils.dart`
- [ ] **T2.4** Implémenter `HttpAudioStreamer` (serveur HTTP `shelf` embarqué pour servir iPod Library → DLNA) dans `lib/server/outputs/http_audio_streamer.dart`

---

## Phase 3 — Discovery UPnP/DLNA
**Branche :** `phase/3-discovery`

- [ ] **T3.1** Implémenter `SSDPDiscovery` (UDP multicast, M-SEARCH, parse réponses) dans `lib/server/discovery/ssdp_discovery.dart`
- [ ] **T3.2** Implémenter `UPnPDeviceParser` (parse XML description device, extrait capabilities, content directory URL) dans `lib/server/discovery/upnp_device_parser.dart`
- [ ] **T3.3** Implémenter `ContentDirectoryClient` (SOAP Browse, DIDL-Lite parser) dans `lib/server/discovery/content_directory_client.dart`
- [ ] **T3.4** Implémenter `DiscoveryManager` (orchestre SSDP + parsing + cache devices, `allDevices()`, `probeHost()`, `refresh()`) dans `lib/server/discovery/discovery_manager.dart`
- [ ] **T3.5** Implémenter `UPnPIndexer` (parcours récursif Content Directory → insert tracks/albums/artists en DB) dans `lib/server/discovery/upnp_indexer.dart` — **`Isolate.run()` obligatoire** : parsing DIDL-Lite de milliers de nœuds XML est CPU-intensif et bloquerait l'event loop

---

## Phase 4 — Outputs audio
**Branche :** `phase/4-audio-outputs`

- [ ] **T4.1** Définir l'interface `OutputTarget` (contrat : `prepare`, `play`, `pause`, `resume`, `stop`, `seek`, `setVolume`, `currentPositionMs`) dans `lib/server/outputs/output_target.dart`
- [ ] **T4.2** Implémenter `LocalAudioOutput` via `just_audio` (lecture locale HTTP + fichier) dans `lib/server/audio/local_audio_output.dart` — `[HI-RES-TODO]` : vérifier support 24-bit/192kHz natif just_audio
- [ ] **T4.3** Implémenter `DLNAOutput` (SOAP SetAVTransportURI, Play, Pause, Stop, Seek, GetPositionInfo, SetVolume) dans `lib/server/outputs/dlna_output.dart`
- [ ] **T4.4** Implémenter le platform channel iOS `AirPlayOutput` (MethodChannel vers AVRoutePickerView) dans `lib/server/outputs/airplay_output.dart` + `ios/Runner/AirPlayPlugin.swift` — **masqué sur Android**
- [ ] **T4.5** Implémenter `OutputFactory` (instancie le bon `OutputTarget` selon `OutputType` et `Platform.isIOS`)

---

## Phase 5 — Playback engine
**Branche :** `phase/5-playback`

- [ ] **T5.1** Implémenter `PlayQueue` (load, currentTrack, next, previous, addToEnd, addNext, remove, move, jumpTo, shuffle, repeat, snapshot) dans `lib/server/playback/play_queue.dart`
- [ ] **T5.2** Implémenter `Player` (state machine : stopped/buffering/playing/paused, position timer, track end monitor, contrôles) dans `lib/server/playback/player.dart`
- [ ] **T5.3** Implémenter `ZoneInstance` (Player + PlayQueue liés à une zone, `snapshot()`) dans `lib/server/zones/zone_instance.dart`
- [ ] **T5.4** Implémenter `ZoneManager` (bootstrap depuis DB, `createZone`, `deleteZone`, `zone(id)`, `allZones()`, `setVolume`) dans `lib/server/zones/zone_manager.dart`

---

## Phase 6 — Services streaming
**Branche :** `phase/6-streaming`

- [ ] **T6.1** Définir l'interface `StreamingService` + types (`StreamingSearchResult`, `StreamingAuthResult`, `StreamingServiceStatus`, `StreamingError`) dans `lib/server/streaming/streaming_service.dart`
- [ ] **T6.2** Implémenter `QobuzService` (auth email/password, MD5 via `crypto`, search, getTrack, getStreamUrl, getAlbumTracks, getPlaylistTracks, saveAuth/restoreAuth) dans `lib/server/streaming/qobuz_service.dart`
- [ ] **T6.3** Implémenter `TidalService` (OAuth Device Code, quality fallback, search, getTrack, getStreamUrl, saveAuth/restoreAuth) dans `lib/server/streaming/tidal_service.dart`
- [ ] **T6.4** Implémenter `YouTubeService` (Piped API + Google OAuth Device Code, search, getStreamUrl, saveAuth/restoreAuth) dans `lib/server/streaming/youtube_service.dart`
- [ ] **T6.5** Implémenter `StreamingManager` (bootstrap depuis DB, `enableService`, `disableService`, `authenticateService`, `resolveStreamUrl`, `searchAll` en parallèle, `status`) dans `lib/server/streaming/streaming_manager.dart`

---

## Phase 7 — Bibliothèque locale
**Branche :** `phase/7-library`

- [ ] **T7.1** Implémenter `MetadataReader` (lecture tags audio : FLAC/MP3/AAC — via `just_audio_media_kit` ou plugin dédié) dans `lib/server/library/metadata_reader.dart` — **`Isolate.run()` obligatoire** : lecture des tags sur des centaines de fichiers est CPU-intensif et bloquerait l'event loop
- [ ] **T7.2** Implémenter `ArtworkManager` (dossier cache pochettes, URL locale) dans `lib/server/library/artwork_manager.dart`
- [ ] **T7.3** Implémenter `CoverArtFetcher` (requête iTunes Search API → URL cover) dans `lib/server/library/cover_art_fetcher.dart`
- [ ] **T7.4** Implémenter `LibraryScanner` (parcours dossiers, orchestre `MetadataReader`, insert/update DB, émet events scan) dans `lib/server/library/library_scanner.dart` — délègue le travail CPU à `MetadataReader` via `Isolate.run()` ; lui-même reste sur l'event loop principal pour la coordination et les écritures DB
- [ ] **T7.5** Implémenter le platform channel iOS `AppleMusicLibrary` (MethodChannel → MPMediaLibrary) dans `lib/server/library/apple_music_library.dart` + `ios/Runner/AppleMusicPlugin.swift` — **masqué sur Android**

---

## Phase 8 — Radio & métadonnées
**Branche :** `phase/8-radio`

- [ ] **T8.1** Implémenter `RadioMetadataService` (polling ICY metadata / RadioFrance API, émet `.radioMetadata` sur EventBus) dans `lib/server/streaming/radio_metadata_service.dart`
- [ ] **T8.2** Implémenter import/export M3U des radios dans `RadioRepository`

---

## Phase 9 — ServerEngine & AppState
**Branche :** `phase/9-engine-state`

- [ ] **T9.1** Implémenter `ServerEngine` (orchestre tous les services : bootstrap, start, scanLibrary, addMusicFolder, search, stats, saveDevice, clearLibrary, cleanupOrphans) dans `lib/server/server_engine.dart`
- [ ] **T9.2** Implémenter `ZoneState` (zones, currentZoneId, queue, playback position, shuffle/repeat, devices) dans `lib/state/zone_state.dart`
- [ ] **T9.3** Implémenter `LibraryState` (albums, artists, tracks, playlists, radios, history, streamingServices) dans `lib/state/library_state.dart`
- [ ] **T9.4** Implémenter `SettingsState` (thème, langue, defaultZoneId, persistance via shared_preferences) dans `lib/state/settings_state.dart`
- [ ] **T9.5** Implémenter `AppState` (startServer, stopServer, event loop, playback controls, playback streaming, radio sync, device discovery) dans `lib/state/app_state.dart`

---

## Phase 10 — UI Fondation
**Branche :** `phase/10-ui-foundation`

- [ ] **T10.1** Implémenter le système de thème (`TuneColors`, `TuneFonts`, `AppTheme`) dans `lib/views/helpers/`
- [ ] **T10.2** Implémenter `ArtworkView` (widget cover art avec fallback) dans `lib/views/helpers/artwork_view.dart`
- [ ] **T10.3** Implémenter `RootView` (splash/loading, connexion, routing iPhone vs iPad) dans `lib/views/root_view.dart`
- [ ] **T10.4** Implémenter `iPhoneContentView` (BottomNavigationBar : Library, Search, Streaming, Radios, Settings) dans `lib/views/iphone/`
- [ ] **T10.5** Implémenter `iPadContentView` (NavigationSplitView : Sidebar + Detail) dans `lib/views/ipad/`
- [ ] **T10.6** Implémenter `MiniPlayerView` (barre transport bas d'écran : cover, titre, play/pause, next) dans `lib/views/components/mini_player_view.dart`

---

## Phase 11 — UI Lecture en cours
**Branche :** `phase/11-ui-now-playing`

- [ ] **T11.1** Implémenter `NowPlayingView` (pochette blur, titre, artiste, contrôles complets)
- [ ] **T11.2** Implémenter `SeekBarView` (slider position, durée)
- [ ] **T11.3** Implémenter `VolumeControlView` (slider volume, mute)
- [ ] **T11.4** Implémenter `QueueView` (liste queue draggable, suppression)
- [ ] **T11.5** Implémenter `ZoneManagementView` (sélection zone, création zone depuis device)
- [ ] **T11.6** Implémenter `iPadNowPlayingBar` (barre persistante iPad avec contrôles étendus)

---

## Phase 12 — UI Bibliothèque
**Branche :** `phase/12-ui-library`

- [ ] **T12.1** Implémenter `LibraryView` + `LibraryNavigationView` (onglets Albums/Artistes/Pistes/Genres)
- [ ] **T12.2** Implémenter `AlbumsGridView` (grille covers) + `AlbumDetailView` (tracklist, play album)
- [ ] **T12.3** Implémenter `ArtistsListView` + `ArtistDetailView` (albums de l'artiste)
- [ ] **T12.4** Implémenter `TracksListView` (liste pistes avec badge audio format)
- [ ] **T12.5** Implémenter `GenresView` (filtrage par genre)
- [ ] **T12.6** Implémenter `AppleMusicView` (iPod Library locale) — **masqué sur Android**
- [ ] **T12.7** Implémenter `EditAlbumSheet` + `EditTrackSheet` (édition métadonnées)
- [ ] **T12.8** Implémenter `PlaylistsView` + `PlaylistDetailView` + `AddToPlaylistSheet`

---

## Phase 13 — UI Streaming
**Branche :** `phase/13-ui-streaming`

- [ ] **T13.1** Implémenter `StreamingView` (liste services configurés + boutons auth)
- [ ] **T13.2** Implémenter `StreamingServiceDetailView` (albums récents, playlists du service)
- [ ] **T13.3** Implémenter `StreamingAlbumDetailView` (tracklist streaming + play)
- [ ] **T13.4** Implémenter les flows d'auth : Qobuz (email/password form), Tidal/YouTube (Device Code — affiche code + lien)

---

## Phase 14 — UI Radios
**Branche :** `phase/14-ui-radios`

- [ ] **T14.1** Implémenter `RadiosView` (liste radios, lecture, import M3U)
- [ ] **T14.2** Implémenter `RadioFavoritesView` (favoris radio, export CSV)

---

## Phase 15 — UI Recherche & Divers
**Branche :** `phase/15-ui-search-misc`

- [ ] **T15.1** Implémenter `SearchView` (recherche fédérée : bibliothèque locale + tous services streaming en parallèle)
- [ ] **T15.2** Implémenter `HomeView` (récents, statistiques, accès rapide)
- [ ] **T15.3** Implémenter `HistoryView` (historique de lecture)
- [ ] **T15.4** Implémenter `BrowseView` (navigation UPnP/DLNA serveur)

---

## Phase 16 — UI Paramètres
**Branche :** `phase/16-ui-settings`

- [ ] **T16.1** Implémenter `SettingsView` + `SettingsNavigationView` (thème, langue, zone par défaut, about)
- [ ] **T16.2** Implémenter `MetadataView` (stats bibliothèque, scan, clear, cleanup orphelins)
- [ ] **T16.3** Implémenter `LibrarySetupView` (onboarding premier lancement : choisir dossiers musique / UPnP server)

---

## Phase 17 — Localisation
**Branche :** `phase/17-i18n`

- [ ] **T17.1** Configurer `flutter_localizations` + `intl`, générer `AppLocalizations`
- [ ] **T17.2** Extraire toutes les chaînes UI vers les fichiers ARB (FR, EN, DE, ES, IT, ZH, JA, KO)

---

## Phase 18 — Qualité & CI
**Branche :** `phase/18-ci-quality`

- [ ] **T18.1** Écrire les tests unitaires : modèles, repositories, EventBus
- [ ] **T18.2** Écrire les tests unitaires : Player, PlayQueue, ZoneManager
- [ ] **T18.3** Écrire les tests unitaires : StreamingManager (mocks services)
- [ ] **T18.4** Configurer GitHub Actions (flutter test + flutter build iOS/Android)
- [ ] **T18.5** Configurer `flutter_lints` + règles custom dans `analysis_options.yaml`

---

## Backlog — Hi-Res Audio `[HI-RES-TODO]`
> À traiter dans une phase dédiée ultérieure

- Vérifier support 24-bit/192kHz dans `just_audio` sur iOS et Android
- Implémenter platform channel audio si just_audio insuffisant (AVAudioEngine iOS, ExoPlayer Android avec format natif)
- DLNA : tester SetAVTransportURI avec FLAC 24-bit/192kHz (MIME type `audio/flac`, resolution dans DIDL-Lite)
- Qobuz : vérifier que les URLs stream résolues sont bien en FLAC 24-bit (format `27` dans l'API)

---

## Résumé des phases

| Phase | Contenu | Tâches |
|---|---|---|
| 0 | Fondation projet | 5 |
| 1 | Base de données | 8 |
| 2 | Noyau serveur | 4 |
| 3 | Discovery UPnP | 5 |
| 4 | Outputs audio | 5 |
| 5 | Playback engine | 4 |
| 6 | Streaming services | 5 |
| 7 | Bibliothèque locale | 5 |
| 8 | Radio & métadonnées | 2 |
| 9 | ServerEngine & AppState | 5 |
| 10 | UI Fondation | 6 |
| 11 | UI Lecture en cours | 6 |
| 12 | UI Bibliothèque | 8 |
| 13 | UI Streaming | 4 |
| 14 | UI Radios | 2 |
| 15 | UI Recherche & Divers | 4 |
| 16 | UI Paramètres | 3 |
| 17 | Localisation | 2 |
| 18 | Qualité & CI | 5 |
| **Total** | | **98 tâches** |
