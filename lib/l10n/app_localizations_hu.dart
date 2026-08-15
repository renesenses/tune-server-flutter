// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => 'OK';

  @override
  String get btnCancel => 'Mégse';

  @override
  String get btnAdd => 'Hozzáadás';

  @override
  String get btnSave => 'Mentés';

  @override
  String get btnDelete => 'Törlés';

  @override
  String get btnEdit => 'Szerkesztés';

  @override
  String get btnClose => 'Bezárás';

  @override
  String get btnRetry => 'Újra';

  @override
  String get btnCreate => 'Létrehozás';

  @override
  String get btnClear => 'Törlés';

  @override
  String get btnNext => 'Tovább';

  @override
  String get btnSkip => 'Lépés kihagyása';

  @override
  String get btnFinish => 'Beállítás befejezése';

  @override
  String get btnStart => 'Kezdés';

  @override
  String get btnConnect => 'Bejelentkezés';

  @override
  String get btnDisconnect => 'Kijelentkezés';

  @override
  String get btnDownload => 'Letöltés';

  @override
  String get btnImport => 'Importálás';

  @override
  String get btnExport => 'Exportálás';

  @override
  String get btnReset => 'Alaphelyzet';

  @override
  String get btnUse => 'Használat';

  @override
  String get btnShuffle => 'Keverés';

  @override
  String get btnSeeAll => 'Összes megtekintése';

  @override
  String get btnRefresh => 'Frissítés';

  @override
  String get btnScan => 'Gyűjtemény beolvasása';

  @override
  String get btnAddFolder => 'Mappa hozzáadása';

  @override
  String get actionIrreversible => 'Ez a művelet visszavonhatatlan.';

  @override
  String get rootStartError => 'Indítási hiba';

  @override
  String get playbackErrorNoZone =>
      'Nincs kiválasztott zóna — hozz létre vagy válassz egyet';

  @override
  String get playbackErrorZoneNotFound => 'A zóna nem található';

  @override
  String get playbackErrorFailed => 'A lejátszás nem sikerült';

  @override
  String zoneLimitReached(int limit) {
    return 'Az ingyenes csomag $limit zónára korlátozott — válts Premiumra a korlátlan használathoz';
  }

  @override
  String get navLibrary => 'Gyűjtemény';

  @override
  String get navSearch => 'Keresés';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navRadios => 'Rádiók';

  @override
  String get navZones => 'Zónák';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get libraryTitle => 'Gyűjtemény';

  @override
  String get tabAlbums => 'Albumok';

  @override
  String get tabArtists => 'Előadók';

  @override
  String get tabTracks => 'Számok';

  @override
  String albumTracksDuration(int count, String duration) {
    return '$count szám · $duration';
  }

  @override
  String get tabGenres => 'Műfajok';

  @override
  String get tabPlaylists => 'Lejátszási listák';

  @override
  String get tabFavorites => 'Kedvencek';

  @override
  String get favoriteAdded => 'Hozzáadva a kedvencekhez';

  @override
  String get favoriteRemoved => 'Eltávolítva a kedvencekből';

  @override
  String get libraryEmptyFavorites => 'Nincs kedvenc';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => 'Nincs album a gyűjteményben';

  @override
  String get libraryEmptyArtists => 'Nincs előadó a gyűjteményben';

  @override
  String get libraryEmptyTracks => 'Nincs szám a gyűjteményben';

  @override
  String get libraryEmptyGenres => 'Nincs műfaj';

  @override
  String get libraryEmptyPlaylists => 'Nincs lejátszási lista';

  @override
  String get libraryNoFilterResults =>
      'Egyetlen album sem felel meg a szűrőknek';

  @override
  String get libraryPlayAll => 'Összes lejátszása';

  @override
  String get libraryAddTo => 'Hozzáadás ide…';

  @override
  String get libraryEditAlbum => 'Album szerkesztése';

  @override
  String get libraryEditTrack => 'Szám szerkesztése';

  @override
  String get libraryPlay => 'Lejátszás';

  @override
  String get genresAllTracks => 'Összes szám';

  @override
  String get playlistCreate => 'Lejátszási lista létrehozása';

  @override
  String get playlistName => 'A lejátszási lista neve';

  @override
  String get playlistEmpty => 'Nincs szám';

  @override
  String get playlistAddTo => 'Hozzáadás lejátszási listához';

  @override
  String get playlistNewPlaylist => 'Új lejátszási lista';

  @override
  String playlistTrackAdded(String name) {
    return 'Hozzáadva ehhez: „$name”';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return 'Már szerepel itt: „$name”';
  }

  @override
  String playlistTracksAdded(int count, String name) {
    return '$count szám hozzáadva ehhez: \"$name\"';
  }

  @override
  String get playlistAddAllTracks => 'Összes hozzáadása lejátszási listához';

  @override
  String get playlistDeleteTitle => 'Törlöd a lejátszási listát?';

  @override
  String get playlistDeleteBody => 'Ez a lejátszási lista véglegesen törlődik.';

  @override
  String get searchHint => 'Keresés…';

  @override
  String get searchNoResults => 'Nincs találat';

  @override
  String get searchTopResult => 'Legjobb találat';

  @override
  String get searchSectionTracks => 'Számok';

  @override
  String get searchSectionAlbums => 'Albumok';

  @override
  String get searchSectionArtists => 'Előadók';

  @override
  String get searchSectionStreaming => 'Streaming';

  @override
  String get homeRecentlyPlayed => 'Nemrég hallgatott';

  @override
  String get homeLibrary => 'Gyűjtemény';

  @override
  String get homeQuickAccess => 'Gyors elérés';

  @override
  String get homeHistory => 'Előzmények';

  @override
  String get homeBrowseDlna => 'DLNA böngészése';

  @override
  String get homeStatTracks => 'szám';

  @override
  String get homeStatAlbums => 'album';

  @override
  String get homeStatArtists => 'előadó';

  @override
  String get historyTitle => 'Előzmények';

  @override
  String get historyEmpty => 'Nincs előzmény';

  @override
  String get historyClear => 'Törlés';

  @override
  String get historyClearTitle => 'Előzmények törlése';

  @override
  String get nowPlayingNoTrack => 'Nincs szám';

  @override
  String get queueTitle => 'Várólista';

  @override
  String queueUpNextSummary(int count, String time) {
    return '$count következik · $time';
  }

  @override
  String get queueEmpty => 'A várólista üres';

  @override
  String get queueClearTitle => 'Kiüríted a várólistát?';

  @override
  String get queueClearBody => 'Minden szám lekerül a várólistáról.';

  @override
  String get zonesTitle => 'Zónák';

  @override
  String get zonesNew => 'Új zóna';

  @override
  String get zonesNewName => 'A zóna neve';

  @override
  String get zonesNone => 'Nincs zóna';

  @override
  String get zonesRename => 'Zóna átnevezése';

  @override
  String get zonesDelete => 'Zóna törlése';

  @override
  String get zonesDevices => 'Elérhető eszközök';

  @override
  String get zonesOutputLocal => 'Helyi';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesAirplayPair => 'Párosítás (PIN-kód)';

  @override
  String get zonesAirplayPairTitle => 'AirPlay-párosítás';

  @override
  String get zonesAirplayPairIntro =>
      'Egyes tévék (Samsung, LG) és az Apple TV négyjegyű kódot jelenít meg a képernyőn. Indítsd el a párosítást, majd add meg a kódot.';

  @override
  String get zonesAirplayPairWaiting =>
      'Várakozás az eszközön megjelenő kódra…';

  @override
  String get zonesAirplayPairEnterCode =>
      'Add meg az eszközön megjelenő kódot:';

  @override
  String get zonesAirplayPairStart => 'Párosítás indítása';

  @override
  String get zonesAirplayPairSubmit => 'Kód megerősítése';

  @override
  String get zonesAirplayPairRetry => 'Újra';

  @override
  String get zonesOutputBluetooth => 'Bluetooth';

  @override
  String get zonesChangeOutput => 'Kimenet módosítása';

  @override
  String get zonesOutputTitle => 'Hangkimenet';

  @override
  String get zonesAssignDevice => 'Hozzárendelés';

  @override
  String get zonesTransferTitle => 'Lejátszás ide...';

  @override
  String get zonesNowPlaying => 'Itt szól';

  @override
  String zonesActivated(String name) {
    return 'Aktív zóna: $name';
  }

  @override
  String get radiosTitle => 'Rádiók';

  @override
  String get radiosTabAll => 'Összes';

  @override
  String get radiosTabFavorites => 'Kedvencek';

  @override
  String get radiosNone => 'Nincs rádió';

  @override
  String get radiosFavNone => 'Nincs kedvenc rádió';

  @override
  String get radiosSavedFavorites => 'Elmentett kedvencek';

  @override
  String get radiosAdd => 'Rádió hozzáadása';

  @override
  String get radiosName => 'Név';

  @override
  String get radiosStreamUrl => 'Az adatfolyam URL-je';

  @override
  String get radiosGenre => 'Műfaj (nem kötelező)';

  @override
  String get radiosPasteM3u => 'M3U beillesztése';

  @override
  String get radiosImportUrl => 'Importálás URL-ről';

  @override
  String get radiosImportUrlLabel => 'Az M3U-fájl URL-je';

  @override
  String radiosImportResult(int count) {
    return '$count állomás importálva';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'HTTP-hiba: $code';
  }

  @override
  String get radiosImportFailed => 'A fájlt nem sikerült letölteni';

  @override
  String get radiosFavSaved => 'A szám elmentve';

  @override
  String get radioSaveFavorite => 'Szám mentése';

  @override
  String get radioFavTitle => 'Kedvenc rádiós számok';

  @override
  String get radioFavEmpty => 'Nincs elmentett kedvenc';

  @override
  String get radioFavExportCsv => 'CSV exportálása';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get streamingConnected => 'Csatlakoztatva';

  @override
  String get streamingNotConnected => 'Nincs csatlakoztatva';

  @override
  String get streamingEmail => 'E-mail';

  @override
  String get streamingPassword => 'Jelszó';

  @override
  String get streamingSignIn => 'Bejelentkezés';

  @override
  String get streamingSigningIn => 'Bejelentkezés…';

  @override
  String get streamingDeviceCode => 'Ellenőrző kód';

  @override
  String get streamingOpenLink => 'Megnyitás…';

  @override
  String get streamingLogoutTitle => 'Kijelentkezel?';

  @override
  String streamingLogoutBody(String service) {
    return 'Kijelentkezel innen: $service?';
  }

  @override
  String get streamingAuthError => 'A hitelesítés nem sikerült';

  @override
  String get streamingAlbumsSection => 'Albumok';

  @override
  String get streamingPlaylistsSection => 'Lejátszási listák';

  @override
  String get browseTitle => 'Böngészés';

  @override
  String get browseRefreshTooltip => 'Frissítés';

  @override
  String get browseNoServers => 'Nem található UPnP/DLNA-szerver';

  @override
  String get browseNoServersHint =>
      'Ellenőrizd, hogy a szervered ugyanazon a Wi-Fi-hálózaton van-e.';

  @override
  String get browseNoContent => 'Üres mappa';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get settingsSectionAppearance => 'Megjelenés';

  @override
  String get settingsTheme => 'Téma';

  @override
  String get settingsThemeSystem => 'Rendszer';

  @override
  String get settingsThemeLight => 'Világos';

  @override
  String get settingsThemeDark => 'Sötét';

  @override
  String get settingsLanguage => 'Nyelv';

  @override
  String get settingsLangSystem => 'Rendszer';

  @override
  String get settingsSectionZones => 'Zónák';

  @override
  String get settingsDefaultZone => 'Alapértelmezett zóna';

  @override
  String get settingsDefaultZoneAuto => 'Automatikus';

  @override
  String get settingsNoZones => 'Nincs zóna';

  @override
  String get settingsSectionServer => 'Szerver';

  @override
  String get settingsHttpPort => 'HTTP-port';

  @override
  String get settingsHttpPortDesc => 'A fő szerver portja';

  @override
  String get settingsLocalIp => 'Helyi IP-cím';

  @override
  String get settingsSectionLibrary => 'Gyűjtemény';

  @override
  String get settingsMetadata => 'Zene és metaadatok';

  @override
  String get settingsMetadataDesc => 'Mappák, beolvasás, statisztikák';

  @override
  String get settingsSetupWizard => 'Beállítási varázsló';

  @override
  String get settingsSetupWizardDesc => 'A zenei források újrabeállítása';

  @override
  String get settingsSectionAbout => 'Névjegy';

  @override
  String get settingsVersion => '0.1.0 verzió';

  @override
  String get settingsResetConfig => 'A beállítások visszaállítása';

  @override
  String get settingsResetTitle => 'Visszaállítod?';

  @override
  String get settingsResetBody =>
      'Minden beállítás alaphelyzetbe áll. A következő indításkor megjelenik az indulási varázsló.';

  @override
  String get settingsPortTitle => 'HTTP-port';

  @override
  String get settingsPortHint => 'Port (1024–65535)';

  @override
  String get metadataTitle => 'Zene és metaadatok';

  @override
  String get metadataRefreshStats => 'Statisztikák frissítése';

  @override
  String get metadataSectionStats => 'Statisztikák';

  @override
  String get metadataStatTracks => 'Számok';

  @override
  String get metadataStatAlbums => 'Albumok';

  @override
  String get metadataStatArtists => 'Előadók';

  @override
  String get metadataStatPlaylists => 'Lejátszási listák';

  @override
  String get metadataStatRadios => 'Rádiók';

  @override
  String get metadataStatArtwork => 'Borító-gyorsítótár';

  @override
  String get metadataSectionScan => 'Gyűjtemény beolvasása';

  @override
  String metadataScanInProgress(int current, int total) {
    return 'Beolvasás folyamatban… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return 'Utolsó beolvasás: +$added hozzáadva, $updated frissítve';
  }

  @override
  String get metadataScanBtn => 'Gyűjtemény beolvasása';

  @override
  String get metadataScanDesc => 'Indexeli az összes beállított mappát';

  @override
  String get metadataSectionFolders => 'Zenemappák';

  @override
  String get metadataFoldersNone => 'Nincs beállított mappa';

  @override
  String metadataFolderAddedOn(String date) {
    return 'Hozzáadva: $date';
  }

  @override
  String get metadataAddFolder => 'Mappa hozzáadása';

  @override
  String get metadataFolderPath => 'A mappa elérési útja';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => 'Takarítás';

  @override
  String get metadataCleanupOrphans => 'Árva elemek törlése';

  @override
  String get metadataCleanupOrphansDesc => 'Albumok és előadók számok nélkül';

  @override
  String get metadataClearLibrary => 'Gyűjtemény ürítése';

  @override
  String get metadataClearLibraryDesc => 'Törli az összes helyi számot';

  @override
  String get metadataCleanupOrphansTitle => 'Törlöd az árva elemeket?';

  @override
  String get metadataCleanupOrphansBody =>
      'Azok az albumok és előadók, amelyekhez egyetlen szám sem tartozik, törlődnek az adatbázisból.';

  @override
  String get metadataClearLibraryTitle => 'Kiüríted a gyűjteményt?';

  @override
  String get metadataClearLibraryBody =>
      'Az összes helyi szám, album és előadó törlődik az adatbázisból. Ez a művelet visszavonhatatlan.';

  @override
  String get metadataOrphansDeleted => 'Az árva elemek törölve';

  @override
  String get metadataLibraryCleared => 'A gyűjtemény kiürítve';

  @override
  String get metadataDeleteBtn => 'Törlés';

  @override
  String get metadataClearBtn => 'Ürítés';

  @override
  String get setupWelcomeTitle => 'Üdvözöl a\nTune Server';

  @override
  String get setupWelcomeBody =>
      'A beépített, többszobás zeneszervered. Sugározd a helyi gyűjteményedet, a streamingszolgáltatásaidat és a rádióidat bármelyik DLNA- vagy AirPlay-hangszóróra.';

  @override
  String get setupStart => 'Kezdés';

  @override
  String get setupLocalTitle => 'Helyi gyűjtemény';

  @override
  String get setupLocalBody =>
      'Add meg egy olyan mappa elérési útját, amely hangfájlokat tartalmaz (FLAC, MP3, AAC…). Továbbiakat később a Beállításokban vehetsz fel.';

  @override
  String get setupFolderPath => 'A mappa elérési útja';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => 'Ezt a mappát hozzáadom';

  @override
  String get setupFolderAdded => 'A mappa hozzáadva — beolvasás folyamatban…';

  @override
  String get setupFolderEmpty => 'Adj meg egy mappa-elérési utat';

  @override
  String get setupUPnPTitle => 'UPnP/DLNA-szerverek';

  @override
  String get setupUPnPBody =>
      'A Tune Server automatikusan felderíti a helyi hálózatod UPnP/DLNA-szervereit. A gyűjteményeikben a Keresés → Böngészés útvonalon barangolhatsz.';

  @override
  String get setupFeatureSsdp => 'Automatikus SSDP-felderítés';

  @override
  String get setupFeatureContentDir => 'ContentDirectory-böngészés';

  @override
  String get setupFeaturePlayback => 'DLNA-fájlok közvetlen lejátszása';

  @override
  String get setupFinish => 'Beállítás befejezése';

  @override
  String get libraryPlayAlbum => 'Album lejátszása';

  @override
  String get libraryPlayNext => 'Lejátszás következőként';

  @override
  String radioFavExportDone(String path) {
    return 'CSV exportálva: $path';
  }

  @override
  String get radioFavExportError => 'Hiba az exportálás közben';

  @override
  String get streamingViewAlbum => 'Album megtekintése';

  @override
  String get streamingLogoutContent => 'A fiókodból kijelentkezünk.';

  @override
  String get streamingUrlCopied => 'Az URL a vágólapra másolva';

  @override
  String get streamingDeviceCodeHint =>
      'Nyisd meg ezt az URL-t, és add meg a fenti kódot:';

  @override
  String get searchHintFull => 'Keress előadókat, albumokat, számokat…';

  @override
  String get browseNavError => 'Navigációs hiba';

  @override
  String get streamingCodeEntered => 'Megadtam a kódot';

  @override
  String get appleMusicAuthorize => 'Hozzáférés engedélyezése';

  @override
  String get smbNavTitle => 'SMB-forrás';

  @override
  String get smbTitle => 'SMB-kapcsolat';

  @override
  String get smbHostHint => 'Add meg az SMB-szerver címét';

  @override
  String get smbHostLabel => 'IP-cím (pl.: 192.168.1.23)';

  @override
  String get smbUser => 'Felhasználó';

  @override
  String get smbPassword => 'Jelszó';

  @override
  String get smbConnect => 'Csatlakozás';

  @override
  String get smbSelectShare => 'Válassz megosztást';

  @override
  String get smbBack => 'Vissza';

  @override
  String get smbManualHint =>
      'A megosztásokat nem sikerült automatikusan listázni.\nAdd meg a megosztás nevét kézzel:';

  @override
  String get smbShareName => 'A megosztás neve (pl.: Share, Music)';

  @override
  String get smbScan => 'Beolvasás';

  @override
  String get smbScanning => 'Beolvasás folyamatban…';

  @override
  String smbScanCount(int count) {
    return '$count hangfájl található';
  }

  @override
  String get smbDoneTitle => 'Az indexelés kész';

  @override
  String smbDoneBody(int count, String share) {
    return '$count szám importálva innen: $share';
  }

  @override
  String get smbAddAnother => 'Másik megosztás hozzáadása';

  @override
  String get settingsSmb => 'SMB-/Samba-források';

  @override
  String get settingsSmbDesc =>
      'Gyűjtemények indexelése hálózati megosztásokon';

  @override
  String get podcastsTitle => 'Podcastok';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => 'Keresés';

  @override
  String get podcastsEmpty => 'Nincs podcast';

  @override
  String get podcastsSearchHint => 'Podcast keresése…';

  @override
  String get podcastsNoEpisodes => 'Nincs epizód';

  @override
  String get navPodcasts => 'Podcastok';

  @override
  String get streamingConnectedSuccess => 'Csatlakozva!';

  @override
  String browseItemCount(int count) {
    return '$count elem';
  }

  @override
  String get settingsSources => 'Források és eszközök';

  @override
  String get settingsSourcesDesc => 'UPnP-szerverek, DLNA-renderelők';

  @override
  String get sourcesTitle => 'Források és eszközök';

  @override
  String get sourcesServersSection => 'UPnP-tartalomszerverek';

  @override
  String get sourcesRenderersSection => 'DLNA-renderelők';

  @override
  String get sourcesNoDevices => 'Nem található eszköz';

  @override
  String get sourcesTypeServer => 'Szerver';

  @override
  String get sourcesTypeRenderer => 'Renderelő';

  @override
  String get sourcesAvailable => 'Elérhető';

  @override
  String get sourcesUnavailable => 'Offline';

  @override
  String get sourcesIndexBtn => 'Gyűjtemény indexelése';

  @override
  String get sourcesRescanBtn => 'Újraolvasás';

  @override
  String get sourcesForget => 'Elfelejtés';

  @override
  String get sourcesAddManually => 'Hozzáadás kézzel';

  @override
  String get sourcesAddTitle => 'Kézi lekérdezés';

  @override
  String get sourcesIpLabel => 'IP-cím';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => 'Port';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => 'Lekérdezés folyamatban…';

  @override
  String get sourcesNotFound => 'Ezen a címen nem található UPnP-eszköz';

  @override
  String get zonesMultiRoom => 'Többszobás';

  @override
  String get zonesCreateGroup => 'Csoport létrehozása';

  @override
  String get zonesGroupLeader => 'Vezető';

  @override
  String get zonesGroupFollower => 'Követő';

  @override
  String get zonesGroupDissolve => 'Csoport feloszlatása';

  @override
  String get zonesGroupSyncDelay => 'Szinkronkésleltetés';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => 'Válaszd ki a zónákat';

  @override
  String get zonesGroupSelectLeader => 'Válaszd ki a vezetőt';

  @override
  String get zonesGroupNoZones => 'Nincs aktív csoport';

  @override
  String get zonesGroupNeedTwo => 'Válassz legalább 2 zónát';

  @override
  String get zonesGroupCreated => 'A csoport létrejött';

  @override
  String get zonesGroupDissolved => 'A csoport feloszlatva';

  @override
  String get metadataSectionEnrich => 'Gazdagítás';

  @override
  String get metadataSectionDuplicates => 'Duplikátumok';

  @override
  String get metadataSectionCorrect => 'Javítás';

  @override
  String get metadataFilterAll => 'Összes';

  @override
  String get metadataFilterMissingCover => 'Hiányzó borítók';

  @override
  String get metadataFilterMissingGenre => 'Hiányzó műfaj';

  @override
  String get metadataFilterMissingYear => 'Hiányzó év';

  @override
  String get metadataFilterMissingArtist => 'Hiányzó előadó';

  @override
  String get metadataFilterDoubtful => 'Kétes';

  @override
  String get metadataSearchHint => 'Albumok keresése…';

  @override
  String get metadataArtistFilter => 'Előadó';

  @override
  String get metadataGenreFilter => 'Műfaj';

  @override
  String get metadataAllArtists => 'Összes előadó';

  @override
  String get metadataAllGenres => 'Összes műfaj';

  @override
  String get metadataNoAlbums => 'Nincs megfelelő album';

  @override
  String get metadataEditAlbum => 'Album szerkesztése';

  @override
  String get metadataSaveChanges => 'Mentés';

  @override
  String get metadataWriteTags => 'Címkék beírása';

  @override
  String metadataWriteTagsSuccess(int count) {
    return 'Címkék beírva: $count fájl';
  }

  @override
  String get metadataMergeGroup => 'Összevonás';

  @override
  String metadataMergeConfirm(int count) {
    return 'Összevonod ezt a(z) $count albumot egyetlenné? A legtöbb számot tartalmazó album marad meg.';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return 'Összevonva: $moved szám áthelyezve, összesen $total';
  }

  @override
  String get metadataUploadCover => 'Borító feltöltése';

  @override
  String get metadataCoverUploaded => 'A borító feltöltve';

  @override
  String get metadataAlbumSaved => 'Az album mentve';

  @override
  String metadataDupAlbums(int count) {
    return '$count duplikált album';
  }

  @override
  String get metadataDoubtfulReasons => 'Problémák';

  @override
  String get metadataArtistField => 'Előadó';

  @override
  String get metadataAlbumField => 'Album';

  @override
  String get metadataGenreField => 'Műfaj';

  @override
  String get metadataYearField => 'Év';

  @override
  String metadataTracksCount(int count) {
    return '$count szám';
  }

  @override
  String get stereoPairsTitle => 'Sztereó párok';

  @override
  String get stereoPairCreate => 'Sztereó pár létrehozása';

  @override
  String get stereoPairName => 'A pár neve';

  @override
  String get stereoPairNameHint => 'Pl.: Nappali sztereó';

  @override
  String get stereoPairLeft => 'Bal (L)';

  @override
  String get stereoPairRight => 'Jobb (R)';

  @override
  String get stereoPairSelectDevice => 'Válassz eszközt';

  @override
  String get stereoPairNone => 'Nincs sztereó pár';

  @override
  String get stereoPairCreated => 'A sztereó pár létrejött';

  @override
  String get stereoPairDissolved => 'A sztereó pár feloldva';

  @override
  String get stereoPairDissolve => 'Feloldás';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => 'Bekapcsolás';

  @override
  String get streamingDisable => 'Kikapcsolás';

  @override
  String get streamingEnabled => 'A szolgáltatás bekapcsolva';

  @override
  String get streamingDisabled => 'A szolgáltatás kikapcsolva';

  @override
  String get onboardingWelcomeTitle => 'Üdvözöl a Tune!';

  @override
  String get onboardingWelcomeBody =>
      'A beépített, többszobás zeneszervered. Állítsuk be együtt a rendszeredet néhány lépésben.';

  @override
  String get onboardingWelcomeStart => 'Kezdés';

  @override
  String get onboardingConfigTitle => 'Beállítás';

  @override
  String get onboardingConfigBody =>
      'Add meg egy hangfájlokat tartalmazó mappa elérési útját, vagy csatlakozz egy távoli Tune-szerverhez.';

  @override
  String get onboardingConfigModeLocal => 'Beépített szerver';

  @override
  String get onboardingConfigModeRemote => 'Távoli szerver';

  @override
  String get onboardingZoneTitle => 'Zóna létrehozása';

  @override
  String get onboardingZoneBody =>
      'Az alábbi eszközöket találtuk a hálózatodon. Koppints az egyikre az első hangzónád létrehozásához.';

  @override
  String get onboardingZoneEmpty =>
      'Egyelőre nem találtunk eszközt. Később is hozzáadhatsz.';

  @override
  String onboardingZoneCreated(String name) {
    return 'Zóna létrehozva: $name';
  }

  @override
  String get onboardingDoneTitle => 'Kész!';

  @override
  String get onboardingDoneBody =>
      'A rendszered készen áll. Jó zenehallgatást!';

  @override
  String get onboardingDoneButton => 'Irány az irányítópult';

  @override
  String get artistBio => 'Életrajz';

  @override
  String get artistAnecdotes => 'Érdekességek';

  @override
  String get artistSimilarArtists => 'Hasonló előadók';

  @override
  String get artistMembers => 'Tagok';

  @override
  String get artistDiscography => 'Diszkográfia';

  @override
  String get artistEnriching => 'Gazdagítás folyamatban…';

  @override
  String get artistGenres => 'Műfajok';

  @override
  String get libraryShuffleAll => 'Minden lejátszása véletlenszerűen';

  @override
  String get librarySortBy => 'Rendezés';

  @override
  String get librarySortTitle => 'Cím';

  @override
  String get librarySortArtist => 'Előadó';

  @override
  String get librarySortYear => 'Év';

  @override
  String get librarySortOriginalYear => 'Eredeti év';

  @override
  String get librarySortAddedDate => 'Hozzáadás dátuma';

  @override
  String get librarySortAscending => 'Növekvő';

  @override
  String get librarySortDescending => 'Csökkenő';

  @override
  String get addFavorite => 'Hozzáadás a kedvencekhez';

  @override
  String get addFolder => 'Mappa hozzáadása';

  @override
  String get addThisFolder => 'Ezt a mappát hozzáadom';

  @override
  String get addToPlaylist => 'Hozzáadás lejátszási listához';

  @override
  String get addedToPlaylist => 'Hozzáadva a lejátszási listához';

  @override
  String get audioOutput => 'Hangkimenet';

  @override
  String get audioOutputDesc =>
      'A szerver minden zónája egy-egy kimenetnek felel meg (helyi ALSA, Diretta-renderelő…). Válaszd ki, melyiken szóljon.';

  @override
  String get authorizeInBrowser => 'Engedélyezd a hozzáférést a böngésződben:';

  @override
  String get cancel => 'Mégse';

  @override
  String get connect => 'Csatlakozás';

  @override
  String get connected => 'Csatlakoztatva';

  @override
  String get cover => 'Borító';

  @override
  String get create => 'Létrehozás';

  @override
  String get createPlaylist => 'Lejátszási lista létrehozása';

  @override
  String get delete => 'Törlés';

  @override
  String get deletePlaylist => 'Lejátszási lista törlése';

  @override
  String get deletePlaylistConfirm => 'Törlöd ezt a lejátszási listát?';

  @override
  String get disabled => 'Kikapcsolva';

  @override
  String get disconnected => 'Nincs csatlakoztatva';

  @override
  String get done => 'Végeztem';

  @override
  String get dynamicPlaylists => 'Dinamikus lejátszási listák';

  @override
  String get dynamicTag => 'Dinamikus';

  @override
  String errorWith(String msg) {
    return 'Hiba: $msg';
  }

  @override
  String favError(String msg) {
    return 'A kedvencekhez adás nem sikerült: $msg';
  }

  @override
  String get favoritesTitle => 'Kedvencek';

  @override
  String get filterAll => 'Összes';

  @override
  String get freqLimit => 'Frekvenciakorlát';

  @override
  String get gapless => 'Folyamatos lejátszás (gapless)';

  @override
  String get gaplessDesc =>
      'Kapcsold ki, ha fehér zaj vagy zavar hallatszik a számok között ezen a renderelőn.';

  @override
  String get host => 'Gazdagép';

  @override
  String get language => 'Nyelv';

  @override
  String get loading => 'Betöltés…';

  @override
  String get localLibrary => 'Helyi gyűjtemény';

  @override
  String get localLibraryDesc => 'Mappák, ahol a szerver a zenét keresi';

  @override
  String get logIn => 'Bejelentkezés';

  @override
  String get logOut => 'Kijelentkezés';

  @override
  String loginTo(String service) {
    return 'Bejelentkezés: $service';
  }

  @override
  String get maxBitDepth => 'Max. bitmélység';

  @override
  String get maxFrequency => 'Max. frekvencia';

  @override
  String maxTracks(int n) {
    return 'max. $n';
  }

  @override
  String get metadataFields => 'Metaadatmezők';

  @override
  String get metadataFieldsDesc => 'A helyi gyűjteményhez megjelenített adatok';

  @override
  String get metadataSaved => 'A metaadatok mentve';

  @override
  String get musicFolders => 'Beolvasott mappák';

  @override
  String get navFavorites => 'Kedvencek';

  @override
  String get navPlaylists => 'Lejátszási listák';

  @override
  String get newPlaylist => 'Új lejátszási lista';

  @override
  String get noFavAlbums => 'Nincs kedvenc album';

  @override
  String get noFavArtists => 'Nincs kedvenc előadó';

  @override
  String get noFavTracks => 'Nincs kedvenc szám';

  @override
  String get noFolders => 'Nincs beállított mappa';

  @override
  String get noLimit => 'Nincs korlát';

  @override
  String get noPlaylists => 'Nincs lejátszási lista';

  @override
  String get noResults => 'Nincs találat';

  @override
  String get noService => 'Nincs szolgáltatás';

  @override
  String get noTracks => 'Nincs szám';

  @override
  String get noZones => 'Nincs elérhető zóna';

  @override
  String get notConnected => 'Állítsd be a szervert a Beállításokban';

  @override
  String get nothingPlaying => 'Nem szól semmi';

  @override
  String get openAuthPage => 'Az engedélyezési oldal megnyitása';

  @override
  String get password => 'Jelszó';

  @override
  String get pickFolder => 'Válassz mappát';

  @override
  String get playAll => 'Összes lejátszása';

  @override
  String get playlistCreated => 'A lejátszási lista létrejött';

  @override
  String get playlistDeleted => 'A lejátszási lista törölve';

  @override
  String get playlistsTitle => 'Lejátszási listák';

  @override
  String get port => 'Port';

  @override
  String get qualityCd => 'CD (44,1 kHz / 16 bit)';

  @override
  String get qualityHires => 'Hi-Res (akár 192 kHz)';

  @override
  String get qualityMax => 'Maximum';

  @override
  String get removeFavorite => 'Eltávolítás a kedvencekből';

  @override
  String get removeFromPlaylist => 'Eltávolítás a lejátszási listáról';

  @override
  String get runScan => 'Gyűjtemény beolvasása';

  @override
  String get scanning => 'Beolvasás folyamatban…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · a gyűjteményed';

  @override
  String get searchEmptyTitle => 'Keress számot, albumot vagy előadót';

  @override
  String get searchTitle => 'Keresés';

  @override
  String get sectionAlbums => 'Albumok';

  @override
  String get sectionArtists => 'Előadók';

  @override
  String get sectionPlaylists => 'Lejátszási listák';

  @override
  String get sectionTracks => 'Számok';

  @override
  String get server => 'Szerver';

  @override
  String get sourceLibrary => 'Gyűjtemény';

  @override
  String get streamingQuality => 'Streaming minősége';

  @override
  String get streamingQualityDesc =>
      'Korlátozza a szolgáltatásoktól (Qobuz, Tidal…) kért frekvenciát és felbontást.';

  @override
  String get streamingServices => 'Streamingszolgáltatások';

  @override
  String get systemLanguage => 'Rendszer';

  @override
  String get trackRemoved => 'Eltávolítva a lejátszási listáról';

  @override
  String tracksCount(int n) {
    return '$n szám';
  }

  @override
  String get username => 'Azonosító / e-mail';

  @override
  String get visualizer => 'Vizualizáció';

  @override
  String get licenseSessionConflictTitle =>
      'A licenc egy másik szerveren aktív';

  @override
  String get licenseSessionConflictBody =>
      'A Tune-licenced már használatban van egy másik szervereden. Ez a szerver néhány perccel a másik leállása után automatikusan visszavált Premiumra.';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'A Tune-licenced a(z) „$server” szerveren aktív. Ez a szerver néhány perccel a másik leállása után automatikusan visszavált Premiumra.';
  }
}
