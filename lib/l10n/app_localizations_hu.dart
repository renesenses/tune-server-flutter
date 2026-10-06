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

  @override
  String cfgSaveError(String detail) {
    return 'Mentési hiba: $detail';
  }

  @override
  String get cfgReload => 'Újratöltés';

  @override
  String get cfgFieldsLoadError => 'A mezők nem tölthetők be';

  @override
  String get cfgFieldsNone => 'Nincs elérhető mező';

  @override
  String get cfgFieldsHint =>
      'Válaszd ki, mely metaadatmezők jelenjenek meg a számszerkesztőben.';

  @override
  String get cfgMetaCompleteness => 'Metaadatok teljessége';

  @override
  String get cfgMetaEnrichMusicBrainz => 'Gazdagítás MusicBrainz-zel';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'MusicBrainz-gazdagítás';

  @override
  String get cfgMetaFixYearsTidal => 'Évszámok javítása (TIDAL)';

  @override
  String get cfgMetaFixYearsDiscogs => 'Évszámok javítása (Discogs)';

  @override
  String get cfgMetaFixGenres => 'Műfajok javítása';

  @override
  String get cfgMetaAutoFixAlbums => 'Albumok automatikus javítása';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count függő javaslat',
      zero: 'Nincs függő javaslat',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => 'Összes elfogadása';

  @override
  String get cfgMetaSuggestions => 'Javaslatok';

  @override
  String get cfgMetaScanDuplicates => 'Duplikátumok keresése';

  @override
  String get cfgMetaAutoMerge => 'Automatikus összevonás';

  @override
  String get cfgMetaMergeDuplicatesTask => 'Duplikátumok összevonása';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$count duplikált album ($groups csoport)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… és még $count csoport',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => 'Utolsó eredmény';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct% kész';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label: hiba — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label: $count elfogadva';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label: $fixed/$total javítva';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label: $fixed javítva';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label: $total feldolgozva';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label: kész';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return 'Címkeírási hiba: $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return 'Feltöltési hiba: $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Összevonsz $count albumot?',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody =>
      'A legtöbb számot tartalmazó album megmarad, a többi törlődik.';

  @override
  String cfgMetaMergeError(String detail) {
    return 'Összevonási hiba: $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => 'A statisztikák nem érhetők el';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count album',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… és még $count album (szűkíts szűrővel)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count szám';
  }

  @override
  String get cfgMetaReasonArtistUppercase => 'Előadó nagybetűvel';

  @override
  String get cfgMetaReasonArtistPlaceholder => 'Ideiglenes előadó';

  @override
  String get cfgMetaReasonArtistHasYear => 'Előadó = mappa';

  @override
  String get cfgMetaReasonGenrePlaceholder => 'Ideiglenes műfaj';

  @override
  String get cfgMetaReasonYearSuspicious => 'Gyanús évszám';

  @override
  String get cfgMetaReasonTitleUppercase => 'Cím nagybetűvel';

  @override
  String get cfgMetaReasonArtistMismatch => 'Eltérő előadó';

  @override
  String get cfgSmbNotConnected => 'Nincs kapcsolat távoli szerverrel';

  @override
  String cfgSmbMountTitle(String name) {
    return '$name csatolása';
  }

  @override
  String get cfgSmbMount => 'Csatolás';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name csatolva';
  }

  @override
  String get cfgSmbTitle => 'Hálózati megosztások (SMB)';

  @override
  String get cfgSmbSearching => 'SMB-megosztások keresése…';

  @override
  String get cfgSmbNone => 'Nem található SMB-megosztás';

  @override
  String get cfgSmbSaveCredentials => 'Hitelesítő adatok mentése';

  @override
  String get cfgUnknown => 'Ismeretlen';

  @override
  String get cfgEqTitle => 'Hangszínszabályzó';

  @override
  String get cfgEqTabAssistant => 'Varázsló';

  @override
  String get cfgEqTabExpert => 'Szakértő';

  @override
  String cfgEqError(String detail) {
    return 'EQ-hiba: $detail';
  }

  @override
  String get cfgEqPresetFlat => 'Lineáris';

  @override
  String get cfgEqPresetBassBoost => 'Basszuskiemelés';

  @override
  String get cfgEqPresetClassical => 'Klasszikus';

  @override
  String get cfgEqPresetVocal => 'Ének';

  @override
  String get cfgNotConnectedToServer => 'Nincs kapcsolat a szerverrel';

  @override
  String get cfgCredentialsRequired =>
      'Felhasználónév és jelszó megadása kötelező';

  @override
  String cfgServiceConnected(String service) {
    return '$service csatlakoztatva.';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service leválasztva.';
  }

  @override
  String get cfgLastfmTitle => 'Last.fm scrobble';

  @override
  String get cfgLastfmDesc =>
      'Küldd el hallgatási előzményeidet a Last.fm-nek. A számok automatikusan rögzítésre kerülnek, bármelyik zónán szólnak.';

  @override
  String get cfgDisconnecting => 'Leválasztás…';

  @override
  String get cfgConnectHeader => 'CSATLAKOZÁS';

  @override
  String get cfgConnecting => 'Csatlakozás…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scrobble',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return 'Utolsó: $date';
  }

  @override
  String get cfgTokenRequired => 'Add meg a felhasználói tokenedet';

  @override
  String get cfgScrobblerUnavailable => 'A scrobbler nem érhető el';

  @override
  String cfgConnectedAs(String name) {
    return 'Csatlakozva mint $name';
  }

  @override
  String get cfgListenbrainzDesc =>
      'Küldd el hallgatási előzményeidet a ListenBrainznek. A felhasználói tokent a listenbrainz.org/settings oldalon találod.';

  @override
  String get cfgUserToken => 'Felhasználói token';

  @override
  String get cfgValidating => 'Ellenőrzés…';

  @override
  String get cfgSaveAndConnect => 'Mentés és csatlakozás';

  @override
  String get cfgScrobbleAuto => 'A számok automatikusan rögzítésre kerülnek';

  @override
  String cfgConfigExported(String path) {
    return 'Konfiguráció exportálva: $path';
  }

  @override
  String get cfgConfigImported => 'Konfiguráció sikeresen importálva';

  @override
  String cfgImportError(String detail) {
    return 'Importálási hiba: $detail';
  }

  @override
  String get cfgConfigExportDesc =>
      'A szerver konfigurációját JSON-fájlba menti.';

  @override
  String get cfgConfigExportJson => 'JSON exportálása';

  @override
  String get cfgConfigImportDesc => 'Konfiguráció visszaállítása JSON-fájlból.';

  @override
  String get cfgChooseFile => 'Fájl kiválasztása';

  @override
  String get cfgDbNoServer => 'Nincs csatlakoztatott szerver.';

  @override
  String cfgDbExportOk(String size, String path) {
    return 'Exportálás kész: $size MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => 'A fájl elérési útja nem érhető el.';

  @override
  String get cfgDbImportConfirmTitle => 'Importálás megerősítése';

  @override
  String cfgDbImportConfirmBody(String name) {
    return 'Lecseréled a szerver adatbázisát erre: „$name”?\n\nA rendszer automatikusan biztonsági mentést készít. Az importálás után a szervert újra kell indítani.';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return 'Importálás kész: $size MB ($engine).\nIndítsd újra a szervert a módosítások alkalmazásához.';
  }

  @override
  String get cfgDbTitle => 'Adatbázis';

  @override
  String get cfgDbIntro =>
      'A csatlakoztatott szerver adatbázisának exportálása vagy importálása.\nSQLite: .db fájl. PostgreSQL: SQL-dump.';

  @override
  String get cfgDbExporting => 'Exportálás…';

  @override
  String get cfgDbExportBtn => 'Adatbázis exportálása';

  @override
  String get cfgDbImporting => 'Importálás…';

  @override
  String get cfgDbImportBtn => 'Fájl importálása';

  @override
  String get cfgDbFooter =>
      'Importálás után indítsd újra a szervert a módosítások alkalmazásához. A csere előtt automatikusan biztonsági mentés készül.';

  @override
  String cfgStatusUnavailable(String detail) {
    return 'Az állapot nem érhető el: $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'A Tune Spotify Connect-vevőként jelenik meg a helyi hálózaton. A Spotify alkalmazásban válaszd a „Tune (…)” eszközt a listából. Az ügyfél oldalán Spotify Premium-fiók szükséges.';

  @override
  String get cfgSpotifyNoLibrespot => 'A librespot nem található a szerveren';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      'Telepítsd újra a Tune Servert a hivatalos tarball/zip csomagból, hogy a bináris is bekerüljön, vagy telepítsd külön (apt install librespot / brew install librespot).';

  @override
  String get cfgTargetZone => 'Célzóna';

  @override
  String get cfgDeviceName => 'Eszköz neve';

  @override
  String get cfgPlaying => 'Lejátszás';

  @override
  String get cfgNetDiagTitle => 'Hálózati diagnosztika';

  @override
  String get cfgNetSsdpActive => 'SSDP aktív';

  @override
  String get cfgNetMulticastReachable => 'Multicast elérhető';

  @override
  String get cfgError => 'Hiba';

  @override
  String get cfgNetResolution => 'Feloldás';

  @override
  String get cfgNetLatency => 'Késleltetés';

  @override
  String get cfgNetPublicIp => 'Nyilvános IP';

  @override
  String get cfgNetInterfaces => 'HÁLÓZATI INTERFÉSZEK';

  @override
  String get cfgStatusWarning => 'Figyelem';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total album';
  }

  @override
  String get libNoCollectionsYet => 'Még nincs kollekció';

  @override
  String libRatingError(String error) {
    return 'Értékelési hiba: $error';
  }

  @override
  String libDisc(int disc) {
    return '$disc. lemez';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return '$disc. lemez — $subtitle';
  }

  @override
  String get libQuickFavorite => 'Gyors kedvenc';

  @override
  String get libAddToCollection => 'Hozzáadás kollekcióhoz';

  @override
  String get libAlbumNotes => 'Album jegyzetei';

  @override
  String get libCredits => 'Közreműködők';

  @override
  String get libNoCredits => 'Nincsenek közreműködők';

  @override
  String get libNoAlbumNotes => 'Nincs elérhető albumjegyzet';

  @override
  String get libNoNotes => 'Nincs elérhető jegyzet';

  @override
  String get libSourceCommunity => 'Tune közösség';

  @override
  String libBioSource(String source) {
    return 'Forrás: $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return 'Forrás: $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied =>
      'Az Apple Music könyvtár elérése megtagadva.';

  @override
  String get libAppleMusicPermissionRefused =>
      'Engedély megtagadva. Engedélyezd a hozzáférést: Beállítások > Adatvédelem > Média és Apple Music.';

  @override
  String get libUnknownError => 'Ismeretlen hiba';

  @override
  String get libAppleMusicAccessTitle => 'Hozzáférés az Apple Musichoz';

  @override
  String get libAppleMusicAccessBody =>
      'Engedélyezd a zenei könyvtárad elérését az Apple Music számaid lejátszásához.';

  @override
  String get libAppleMusicEmpty => 'Az Apple Music könyvtár üres';

  @override
  String get libReportImageTitle => 'Kép jelentése';

  @override
  String get libReportImageBody =>
      'Hibásnak jelölöd ezt az előadói képet? A szerver a következő gazdagításkor lecseréli.';

  @override
  String get libReportAction => 'Jelentés';

  @override
  String get libImageReported => 'Kép jelentve';

  @override
  String libServiceAlbums(String service) {
    return '$service-albumok';
  }

  @override
  String libTrackCount(int count) {
    return '$count szám';
  }

  @override
  String get libDuplicateScanner => 'Duplikátumkereső';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    return '$groups duplikátumcsoport található (összesen $tracks szám)';
  }

  @override
  String get libFindDuplicatesTitle => 'Duplikált számok keresése';

  @override
  String get libFindDuplicatesBody =>
      'A hangtartalom hash-értékei alapján megkeresi az azonos számokat a gyűjteményedben.';

  @override
  String get libStartScan => 'Keresés indítása';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total szám ($percent%)';
  }

  @override
  String get libLoadingTracks => 'Számok betöltése…';

  @override
  String get libNoDuplicatesFound => 'Nem található duplikátum';

  @override
  String get libLibraryClean => 'A gyűjteményed rendben van.';

  @override
  String get libScanAgain => 'Újrakeresés';

  @override
  String get libScanFailed => 'A keresés sikertelen';

  @override
  String get libTrackNumberField => 'Szám sorszáma';

  @override
  String get libDiscNumberField => 'Lemez sorszáma';

  @override
  String get libExtendedMetadata => 'Bővített metaadatok';

  @override
  String get libGenreTreeSaved => 'Műfajfa mentve';

  @override
  String libSaveError(String error) {
    return 'Mentési hiba: $error';
  }

  @override
  String get libGenreTree => 'Műfajfa';

  @override
  String get libAddRootGenre => 'Fő műfaj hozzáadása';

  @override
  String get libGenreTreeRequiresRemote =>
      'A műfajfához távoli szerverkapcsolat szükséges.';

  @override
  String get libNoGenreHierarchy => 'Nincs megadott műfaj-hierarchia';

  @override
  String libAddSubGenreTo(String parent) {
    return 'Alműfaj hozzáadása ehhez: „$parent”';
  }

  @override
  String get libGenreName => 'Műfaj neve';

  @override
  String libSubGenreCount(int count) {
    return '$count alműfaj';
  }

  @override
  String get libAddSubGenre => 'Alműfaj hozzáadása';

  @override
  String get libRemove => 'Eltávolítás';

  @override
  String libRemoveNamedConfirm(String name) {
    return 'Eltávolítod: „$name”?';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    return 'Ezzel mind a(z) $count alműfaj is törlődik.';
  }

  @override
  String get libRemoveGenreBody => 'Ez a műfaj kikerül a fából.';

  @override
  String libAlbumCount(int count) {
    return '$count album';
  }

  @override
  String get libNoTracksForFilter => 'Nincs a szűrőnek megfelelő szám';

  @override
  String get libQualityLossless => 'Veszteségmentes';

  @override
  String get libQualityLossy => 'Veszteséges';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total szám';
  }

  @override
  String get libNewCollection => 'Új kollekció';

  @override
  String get libCollectionName => 'Kollekció neve';

  @override
  String libCreateError(String error) {
    return 'Létrehozási hiba: $error';
  }

  @override
  String libDeleteError(String error) {
    return 'Törlési hiba: $error';
  }

  @override
  String get libCollectionsTitle => 'Kollekciók';

  @override
  String get libCollectionsLoadFailed =>
      'Nem sikerült betölteni a kollekciókat';

  @override
  String get libDeleteCollectionTitle => 'Törlöd a kollekciót?';

  @override
  String libDeleteCollectionBody(String name) {
    return 'A(z) „$name” véglegesen törlődik.';
  }

  @override
  String get libNoAlbumsInCollection => 'Nincs album ebben a kollekcióban';

  @override
  String get libDeleteConfirmTitle => 'Törlöd?';

  @override
  String get libDeleteSmartCollectionBody =>
      'Ez az okos kollekció véglegesen törlődik.';

  @override
  String get libNoRules => 'nincs szabály';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return 'közreműködés: $role=$artist';
  }

  @override
  String get libAnd => 'ÉS';

  @override
  String get libOr => 'VAGY';

  @override
  String get libSmartCollections => 'Okos kollekciók';

  @override
  String get libNewSmartCollection => 'Új okos kollekció';

  @override
  String get libNoSmartCollections => 'Nincs okos kollekció';

  @override
  String get libSmartCollectionsSeedHint =>
      'A szerver első indításkor általában 7 alapértelmezett kollekciót hoz létre.';

  @override
  String get libCreateFirstSmartCollection =>
      'Első okos kollekcióm létrehozása';

  @override
  String get libNoMatchingAlbums => 'Nincs megfelelő album';

  @override
  String get libSmartCreditsHint =>
      'A közreműködőkön alapuló szabályokhoz (engineer, performer, …) előbb gazdagítsd a gyűjteményt a Beállításokban.';

  @override
  String get libFieldSampleRate => 'Mintavételi frekvencia';

  @override
  String get libFieldBitDepth => 'Bitmélység';

  @override
  String get libFieldTrackCount => 'Számok száma';

  @override
  String get libFieldFormat => 'Formátum';

  @override
  String get libFieldLabel => 'Kiadó';

  @override
  String get libFieldAlbumTitle => 'Album címe';

  @override
  String get libFieldSource => 'Forrás';

  @override
  String get libFieldCredit => 'Közreműködés';

  @override
  String get libFieldPlayCount => 'Lejátszások száma';

  @override
  String get libFieldLastPlayed => 'Utoljára játszva';

  @override
  String get libOpBetween => 'között';

  @override
  String get libOpContains => 'tartalmazza';

  @override
  String get libOpStartsWith => 'ezzel kezdődik';

  @override
  String get libOpEmpty => 'üres';

  @override
  String get libOpNotEmpty => 'nem üres';

  @override
  String get libOpNever => 'soha';

  @override
  String get libOpAfter => 'után';

  @override
  String get libOpBefore => 'előtt';

  @override
  String get libNameLabel => 'Név';

  @override
  String get libMatchMode => 'Egyezés';

  @override
  String get libMatchAll => 'Minden szabály (ÉS)';

  @override
  String get libMatchAny => 'Legalább egy (VAGY)';

  @override
  String get libAddRule => 'Szabály hozzáadása';

  @override
  String get libMatchingAlbumsPending => '… megfelelő album';

  @override
  String libMatchingAlbums(int count) {
    return '$count megfelelő album';
  }

  @override
  String get libTimestampHint => 'now-30d vagy 2024-01-01';

  @override
  String get libValueHint => 'érték';

  @override
  String get libMinHint => 'min';

  @override
  String get libMaxHint => 'max';

  @override
  String get libCommaSeparatedHint => 'vesszővel elválasztott értékek';

  @override
  String get libCreditRoleHint => 'szerep (engineer, performer, …)';

  @override
  String get libCreditArtistHint => 'előadó (Rudy Van Gelder, …)';

  @override
  String get libCreditInstrumentHint => 'hangszer (Piano, …) — nem kötelező';

  @override
  String get libDirectories => 'Mappák';

  @override
  String get libLoadError => 'Betöltési hiba';

  @override
  String get libNoFolders => 'Nincs mappa';

  @override
  String get libAddFoldersInSettings =>
      'Adj hozzá zenei mappákat a Beállításokban';

  @override
  String get libFoldersHeader => 'Mappák';

  @override
  String libTracksHeaderCount(int count) {
    return 'Számok ($count)';
  }

  @override
  String get libPlayFromHere => 'Lejátszás innen';

  @override
  String get libTags => 'Címkék';

  @override
  String get libNewTagHint => 'Új címke…';

  @override
  String get libJustNow => 'Az imént';

  @override
  String libMinutesAgo(int count) {
    return '$count perce';
  }

  @override
  String libHoursAgo(int count) {
    return '$count órája';
  }

  @override
  String get libYesterday => 'Tegnap';

  @override
  String libDaysAgo(int count) {
    return '$count napja';
  }

  @override
  String get libNowListening => 'Most szól';

  @override
  String get libContinueListening => 'Folytatás';

  @override
  String get libRecentlyAdded => 'Nemrég hozzáadva';

  @override
  String get libTopTracks => 'Legtöbbet hallgatott számok';

  @override
  String get libTopArtists => 'Legtöbbet hallgatott előadók';

  @override
  String get libRecommendations => 'Ajánlások';

  @override
  String get libSourceLocal => 'Helyi';

  @override
  String get libFieldDuration => 'Hossz';

  @override
  String get libFilter => 'Szűrés';

  @override
  String get libRefreshAll => 'Összes frissítése';

  @override
  String get libPodcastsSubscribed => 'Feliratkozások';

  @override
  String get libNoSubscriptions => 'Még nincs feliratkozás';

  @override
  String get libSubscribeRssFeed => 'Feliratkozás RSS-hírcsatornára';

  @override
  String get libUnknown => 'Ismeretlen';

  @override
  String get libUnsubscribeTitle => 'Leiratkozol?';

  @override
  String libUnsubscribeBody(String name) {
    return 'Leiratkozol erről: „$name”?';
  }

  @override
  String get libUnsubscribe => 'Leiratkozás';

  @override
  String libEpisodeCount(int count) {
    return '$count epizód';
  }

  @override
  String get libSubscribeToPodcast => 'Feliratkozás podcastra';

  @override
  String get libRssFeedUrl => 'RSS-hírcsatorna URL-je';

  @override
  String get libSubscribe => 'Feliratkozás';

  @override
  String get libSubscribed => 'Feliratkoztál.';

  @override
  String libSubscribeError(String error) {
    return 'Feliratkozási hiba: $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return 'Leiratkozási hiba: $error';
  }

  @override
  String get libPodcastRefreshed => 'Podcast frissítve.';

  @override
  String libRefreshError(String error) {
    return 'Frissítési hiba: $error';
  }

  @override
  String get libAllPodcastsRefreshed => 'Minden podcast frissítve.';

  @override
  String get libToday => 'Ma';

  @override
  String get miscNavFolders => 'Mappák';

  @override
  String get miscNavCollections => 'Kollekciók';

  @override
  String get miscNavSmartCollections => 'Okos kollekciók';

  @override
  String get miscNavDjMode => 'DJ mód';

  @override
  String get miscNavPartyMode => 'Party mód';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => 'Party';

  @override
  String get miscNavSmartPlaylists => 'Okos lejátszási listák';

  @override
  String get miscNavAlarms => 'Ébresztők';

  @override
  String get miscNavGenreTree => 'Műfajfa';

  @override
  String get miscNavDashboard => 'Irányítópult';

  @override
  String get miscNavDiagnostics => 'Diagnosztika';

  @override
  String get miscNavAdmin => 'Adminisztráció';

  @override
  String get miscNavMore => 'Továbbiak';

  @override
  String get miscNextTrack => 'Következő szám';

  @override
  String get miscPreviousTrack => 'Előző szám';

  @override
  String get miscUnknownError => 'Ismeretlen hiba';

  @override
  String get miscAuthorizationCode => 'Engedélyezési kód';

  @override
  String get miscWaitingForValidation => 'Jóváhagyásra vár…';

  @override
  String miscCodeValue(String code) {
    return 'Kód: $code';
  }

  @override
  String get miscQualityHigh => 'Magas';

  @override
  String get miscExplore => 'Felfedezés';

  @override
  String get miscFavoriteAlbums => 'Kedvenc albumok';

  @override
  String get miscFavoriteTracks => 'Kedvenc számok';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mind a(z) $count szám megtekintése',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => 'Saját lejátszási listák';

  @override
  String get miscNoApiClient => 'Nincs API-kliens';

  @override
  String miscServiceFavorites(String service) {
    return '$service kedvencek';
  }

  @override
  String miscPlayAllCount(int count) {
    return 'Összes lejátszása ($count)';
  }

  @override
  String get miscServiceNotFound => 'A szolgáltatás nem található';

  @override
  String get miscYtHome => 'Kezdőlap';

  @override
  String get miscYtCharts => 'Slágerlisták';

  @override
  String get miscYtMoods => 'Hangulatok';

  @override
  String get miscNoData => 'Nincs adat';

  @override
  String get miscNoContentAvailable => 'Nincs elérhető tartalom';

  @override
  String get miscNoChartsAvailable => 'Nincs elérhető slágerlista';

  @override
  String get miscNoMoodsAvailable => 'Nincs elérhető hangulat';

  @override
  String get miscDashTotalPlays => 'Összes lejátszás';

  @override
  String get miscDashListeningTime => 'Hallgatási idő';

  @override
  String get miscDashUniqueTracks => 'Egyedi számok';

  @override
  String get miscDashUniqueArtists => 'Egyedi előadók';

  @override
  String get miscDashTopArtists => 'TOP ELŐADÓK';

  @override
  String get miscDashTopAlbums => 'TOP ALBUMOK';

  @override
  String get miscDashTopTracks => 'TOP SZÁMOK';

  @override
  String get miscDashListeningByHour => 'HALLGATÁS ÓRÁNKÉNT';

  @override
  String get miscDashListeningByDay => 'HALLGATÁS NAPONKÉNT';

  @override
  String get miscDashAllTime => 'Teljes időszak';

  @override
  String miscDashLastDays(int days) {
    return '$days nap';
  }

  @override
  String get miscUnknown => 'Ismeretlen';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lejátszás',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => 'Még nincsenek hallgatási adatok';

  @override
  String get miscDashNoDataHint =>
      'Játssz le zenét, hogy itt lásd a statisztikáidat.';

  @override
  String get miscDashLoadFailed => 'Az irányítópult betöltése sikertelen';

  @override
  String get miscDiagRequiresRemote =>
      'A diagnosztikához távoli szerverkapcsolat szükséges.';

  @override
  String get miscDiagSystem => 'Rendszer';

  @override
  String get miscDiagHealth => 'Állapot';

  @override
  String get miscVersion => 'Verzió';

  @override
  String get miscDiagUptime => 'Üzemidő';

  @override
  String get miscDiagMemory => 'Memória';

  @override
  String get miscDiagDatabase => 'Adatbázis';

  @override
  String miscZoneNumbered(String id) {
    return 'Zóna $id';
  }

  @override
  String get miscDiagLogs => 'Naplók';

  @override
  String get miscDiagNoLogs => 'Nincs elérhető napló';

  @override
  String get miscAdminTitle => 'Adminisztrációs irányítópult';

  @override
  String get miscAdminNotConnected => 'Nincs csatlakozva távoli szerverhez';

  @override
  String get miscAdminSystemHealth => 'Rendszerállapot';

  @override
  String get miscAdminStatus => 'Állapot';

  @override
  String get miscAdminDisk => 'Lemez';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return 'Felfedezett eszközök ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return 'Legutóbbi hibák ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => 'Nincsenek friss hibák';

  @override
  String get miscTroubleshootingTitle => 'Hibaelhárítás';

  @override
  String get miscFaqHeader => 'Gyakori kérdések';

  @override
  String get miscFaq1Title => 'Nem látom a szerveremet';

  @override
  String get miscFaq1Step1 =>
      'Ellenőrizd, hogy a Tune szerver fut és elérhető.';

  @override
  String get miscFaq1Step2 =>
      'Győződj meg róla, hogy az eszközöd ugyanazon a Wi-Fi-hálózaton van, mint a szerver.';

  @override
  String get miscFaq1Step3 =>
      'Ha VPN-t használsz, kapcsold ki, vagy engedélyezd a LAN-felderítést (pl. nordvpn set lan-discovery on).';

  @override
  String get miscFaq1Step4 =>
      'Próbáld meg átvizsgálni a hálózatot: Beállítások > Mód > Hálózat keresése.';

  @override
  String get miscFaq1Step5 =>
      'Ellenőrizd, hogy a szerver portját (alapértelmezés szerint 8888) nem blokkolja-e tűzfal.';

  @override
  String get miscFaq1Step6 => 'Indítsd újra a szervert és az alkalmazást.';

  @override
  String get miscFaq2Title => 'Nem szól a zene';

  @override
  String get miscFaq2Step1 =>
      'Ellenőrizd, hogy ki van-e választva lejátszási zóna (a képernyő alján lévő sáv).';

  @override
  String get miscFaq2Step2 =>
      'Ha nincs zóna, hozz létre egyet: Beállítások > Hang > Zónák > Létrehozás.';

  @override
  String get miscFaq2Step3 =>
      'Ellenőrizd, hogy a kimeneti eszköz (hangszóró, DAC) be van-e kapcsolva és ugyanazon a hálózaton van-e.';

  @override
  String get miscFaq2Step4 =>
      'DLNA-eszközöknél várj néhány másodpercet a felderítés után, mielőtt elindítod a lejátszást.';

  @override
  String get miscFaq2Step5 =>
      'Próbálj ki egy másik fájlt — lehet, hogy a jelenlegi fájl formátuma nem támogatott.';

  @override
  String get miscFaq2Step6 =>
      'Ha a probléma továbbra is fennáll, indítsd újra az alkalmazást.';

  @override
  String get miscFaq3Title => 'Nem jelennek meg a borítók';

  @override
  String get miscFaq3Step1 =>
      'Indítsd el a gyűjtemény vizsgálatát: Beállítások > Gyűjtemény > Források.';

  @override
  String get miscFaq3Step2 =>
      'Ellenőrizd, hogy a fájlok tartalmaznak-e beágyazott borítót (ID3/Vorbis címkék).';

  @override
  String get miscFaq3Step3 =>
      'Tegyél egy cover.jpg vagy folder.jpg fájlt az album mappájába.';

  @override
  String get miscFaq3Step4 =>
      'Kapcsold be a borítók automatikus letöltését: Beállítások > Gyűjtemény > Metaadatok.';

  @override
  String get miscFaq3Step5 =>
      'Ürítsd a képgyorsítótárat az alkalmazás újraindításával.';

  @override
  String get miscFaq4Title => 'Elakadt a vizsgálat';

  @override
  String get miscFaq4Step1 =>
      'Az első vizsgálat a gyűjtemény méretétől függően több percig is tarthat.';

  @override
  String get miscFaq4Step2 =>
      'Ellenőrizd, hogy a zenei mappák elérhetők-e (jogosultságok, SMB-csatolások).';

  @override
  String get miscFaq4Step3 =>
      'Zárd be és indítsd újra az alkalmazást az elakadt vizsgálat megszakításához.';

  @override
  String get miscFaq4Step4 =>
      'Nézd át a szerver naplóit a problémás fájl azonosításához.';

  @override
  String get miscFaq4Step5 =>
      'A probléma behatárolásához próbáld csökkenteni a forrásmappák számát.';

  @override
  String get miscFaq5Title => 'DLNA/AirPlay eszköz csatlakoztatása';

  @override
  String get miscFaq5Step1 =>
      'DLNA: az eszköznek bekapcsolva és ugyanazon a hálózaton kell lennie. Automatikusan megjelenik a kimenetek listájában.';

  @override
  String get miscFaq5Step2 =>
      'Ha az eszköz nem jelenik meg, ellenőrizd, hogy működik-e a multicast a routereden.';

  @override
  String get miscFaq5Step3 =>
      'Egyes routerek blokkolják az SSDP-forgalmat a Wi-Fi-kliensek között — kapcsold be a multicast-továbbítást.';

  @override
  String get miscFaq5Step4 =>
      'BluOS: a Bluesound hangszórókat a rendszer automatikusan felismeri.';

  @override
  String get miscFaq5Step5 =>
      'Chromecast: a Google Cast eszközök megjelennek az elérhető kimenetek között.';

  @override
  String get miscFaq5Step6 =>
      'Az észlelés után hozz létre egy zónát, és rendeld hozzá az eszközt kimenetként.';

  @override
  String get miscFaq6Title => 'Streamingproblémák';

  @override
  String get miscFaq6Step1 =>
      'Ellenőrizd, hogy a szolgáltatások (TIDAL, Qobuz, Deezer) belépési adatai helyesek-e: Beállítások > Streaming.';

  @override
  String get miscFaq6Step2 =>
      'Ha a munkamenet lejárt, bontsd a kapcsolatot, majd csatlakoztasd újra a szolgáltatást.';

  @override
  String get miscFaq6Step3 => 'Ellenőrizd az internetkapcsolatot.';

  @override
  String get miscFaq6Step4 => 'Egyes számok nem érhetők el a régiódban.';

  @override
  String get miscFaq6Step5 =>
      'Minőségi problémák esetén nézd meg a streamingminőség beállításait: Beállítások > Speciális hang.';

  @override
  String get miscFaq6Step6 =>
      'Ha a probléma továbbra is fennáll, küldj hibajelentést: Beállítások > Súgó.';

  @override
  String get miscBugReportCopied => 'Jelentés a vágólapra másolva';

  @override
  String get miscBugReportSent => 'Hibajelentés elküldve, köszönjük!';

  @override
  String get miscBugReportSendFailed =>
      'A küldés sikertelen. Másold be a jelentést a fórumba.';

  @override
  String get miscBugReportTitle => 'Hibajelentés';

  @override
  String get miscRegenerate => 'Újragenerálás';

  @override
  String get miscBugReportGenerateFailed =>
      'Nem sikerült létrehozni a jelentést';

  @override
  String get miscSent => 'Elküldve!';

  @override
  String get miscSending => 'Küldés…';

  @override
  String get miscSubmit => 'Beküldés';

  @override
  String get miscCopied => 'Másolva!';

  @override
  String get miscCopyReport => 'Jelentés másolása';

  @override
  String get miscAiServerNotConnected =>
      'A szerver nincs csatlakoztatva. Ellenőrizd a kapcsolatot.';

  @override
  String miscAiQueryFailed(int code) {
    return 'Az MI-lekérdezés sikertelen ($code)';
  }

  @override
  String get miscAiNoReply => 'Nincs válasz';

  @override
  String get miscAiAskHint => 'Tegyél fel egy kérdést…';

  @override
  String get miscAiSend => 'Küldés';

  @override
  String get miscAiTitle => 'MI-asszisztens';

  @override
  String get miscAiEmptyTitle => 'Tune MI-asszisztens';

  @override
  String get miscAiEmptyBody => 'Kérdezz a zenédről,\nkérj ajánlásokat…';

  @override
  String miscAiAction(String action) {
    return 'Művelet: $action';
  }

  @override
  String get miscCreateAccount => 'Fiók létrehozása';

  @override
  String get miscUsername => 'Felhasználónév';

  @override
  String get miscUsernameRequired => 'A felhasználónév kötelező';

  @override
  String get miscEmailRequired => 'Az e-mail-cím kötelező';

  @override
  String get miscEmailInvalid => 'Érvénytelen e-mail-cím';

  @override
  String get miscPasswordRequired => 'A jelszó kötelező';

  @override
  String miscPasswordMinLength(int min) {
    return 'Legalább $min karakter';
  }

  @override
  String get miscHaveAccountSignIn => 'Már van fiókod? Bejelentkezés';

  @override
  String get miscNoAccountSignUp => 'Nincs fiókod? Regisztráció';

  @override
  String get npRepeat => 'Ismétlés';

  @override
  String get npQueue => 'Várólista';

  @override
  String get npFavorite => 'Kedvenc';

  @override
  String get npRadioFavAdded => 'Hozzáadva a rádiós kedvencekhez';

  @override
  String get npLyrics => 'Dalszöveg';

  @override
  String get npAlarm => 'Ébresztő';

  @override
  String get npSleepTimer => 'Elalváskapcsoló';

  @override
  String get npDspCrossfeed => 'DSP crossfeed';

  @override
  String get npEqualizer => 'Hangszínszabályzó';

  @override
  String get npShare => 'Megosztás';

  @override
  String get npTransfer => 'Átvitel';

  @override
  String get npCopiedToClipboard => 'Vágólapra másolva';

  @override
  String get npNoLyricsFound => 'Nem található dalszöveg';

  @override
  String get npNoLyricsAvailable => 'Nincs elérhető dalszöveg';

  @override
  String get npLyricsOpenFromNowPlaying =>
      'A teljes dalszöveghez nyisd meg a „Most szól” nézetből';

  @override
  String get npLyricsLoadFailed => 'Nem sikerült betölteni a dalszöveget';

  @override
  String get npLrcMetadataTooltip => 'Metaadatok';

  @override
  String get npLrcMetadataTitle => 'LRC-metaadatok';

  @override
  String get npLrcTitle => 'Cím';

  @override
  String get npLrcCreatedBy => 'Készítette';

  @override
  String get npLrcOffset => 'Eltolás (ms)';

  @override
  String get npLrcHint => 'Tegyél egy azonos nevű .lrc fájlt a hangfájl mellé.';

  @override
  String get npEqFlat => 'Lineáris';

  @override
  String get npEqBassBoost => 'Mélykiemelés';

  @override
  String get npEqTrebleBoost => 'Magaskiemelés';

  @override
  String get npEqVocal => 'Ének';

  @override
  String get npEqRock => 'Rock';

  @override
  String get npEqJazz => 'Jazz';

  @override
  String get npEqClassical => 'Klasszikus';

  @override
  String get npEqElectronic => 'Elektronikus';

  @override
  String get npEqHipHop => 'Hiphop';

  @override
  String get npEqAcoustic => 'Akusztikus';

  @override
  String npEqApplied(String preset) {
    return 'EQ: $preset';
  }

  @override
  String npEqError(String error) {
    return 'EQ-hiba: $error';
  }

  @override
  String get npCrossfeedDesc =>
      'Összekeveri a sztereó csatornákat a természetesebb fejhallgatós hangzásért';

  @override
  String get npCrossfeedOff => 'Ki';

  @override
  String get npCrossfeedLight => 'Enyhe';

  @override
  String get npCrossfeedMedium => 'Közepes';

  @override
  String get npCrossfeedStrong => 'Erős';

  @override
  String npCrossfeedApplied(String level) {
    return 'Crossfeed: $level';
  }

  @override
  String npDspError(String error) {
    return 'DSP-hiba: $error';
  }

  @override
  String get npTransferTitle => 'Lejátszás átvitele';

  @override
  String get npNoOtherZones => 'Nincs más elérhető zóna';

  @override
  String npTransferredTo(String zone) {
    return 'Átvive ide: $zone';
  }

  @override
  String npTransferError(String error) {
    return 'Átviteli hiba: $error';
  }

  @override
  String get npAlarmClock => 'Ébresztőóra';

  @override
  String npAlarmSetFor(String time) {
    return 'Ébresztő beállítva: $time';
  }

  @override
  String npAlarmError(String error) {
    return 'Ébresztőhiba: $error';
  }

  @override
  String get npAlarmCancelled => 'Ébresztő törölve';

  @override
  String get npPause => 'Szünet';

  @override
  String get npStop => 'Leállítás';

  @override
  String get npRoleComposer => 'Zeneszerző';

  @override
  String get npRoleLyricist => 'Szövegíró';

  @override
  String get npRoleArranger => 'Hangszerelő';

  @override
  String get npRoleConductor => 'Karmester';

  @override
  String get npRolePerformer => 'Előadó';

  @override
  String get npRoleProducer => 'Producer';

  @override
  String get npRoleMixer => 'Keverés';

  @override
  String get npRoleEngineer => 'Hangmérnök';

  @override
  String get npCreditsEnriching => 'Bővítés…';

  @override
  String get npCreditsEnrich => 'Bővítés a MusicBrainzből';

  @override
  String get npVolume => 'Hangerő';

  @override
  String get npChangeZone => 'Zóna váltása';

  @override
  String get npZoneFallback => 'Zóna';

  @override
  String get npFollowMe => 'Kövess';

  @override
  String get npMovePlaybackTo => 'Lejátszás áthelyezése ide…';

  @override
  String get npNowPlaying => 'Most szól';

  @override
  String get npTabMore => 'Továbbiak';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return 'Elalváskapcsoló beállítva: $minutes perc (halkítás: $fade mp)';
  }

  @override
  String npSleepTimerError(String error) {
    return 'Elalváskapcsoló-hiba: $error';
  }

  @override
  String get npSleepTimerCancelled => 'Elalváskapcsoló törölve';

  @override
  String get npSleepDuration => 'IDŐTARTAM';

  @override
  String get npSleepCustom => 'Egyéni';

  @override
  String get npSleepFadeOut => 'HALKÍTÁS';

  @override
  String npSleepFadeDesc(int seconds) {
    return 'A hangerő az utolsó $seconds másodpercben fokozatosan nullára halkul.';
  }

  @override
  String get npSleepStarting => 'Indítás…';

  @override
  String npSleepStart(String duration) {
    return 'Indítás ($duration)';
  }

  @override
  String get npSleepSelectDuration => 'Válassz időtartamot';

  @override
  String get npSleepTimerActive => 'Időzítő aktív';

  @override
  String get npSleepCancelTimer => 'Időzítő törlése';

  @override
  String get npMoodChill => 'Chill';

  @override
  String get npMoodParty => 'Buli';

  @override
  String get npMoodFocus => 'Fókusz';

  @override
  String get npMoodEnergetic => 'Energikus';

  @override
  String get npNoZoneAvailable => 'Nincs elérhető zóna';

  @override
  String npMoodNoTracks(String mood) {
    return 'Nem található szám ehhez: $mood';
  }

  @override
  String get npMoodInvalidTrackIds => 'Hiba: érvénytelen számazonosítók';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szám szól',
      one: '1 szám szól',
    );
    return '$mood mix: $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szám a várólistához adva',
      one: '1 szám a várólistához adva',
    );
    return '$mood mix: $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Smart AutoPlay hiba: $error';
  }

  @override
  String get npSmartAutoplayDesc =>
      'Válassz hangulatot egy intelligens lejátszási lista készítéséhez';

  @override
  String get npAlarmsNotConnected => 'Nincs kapcsolat távoli szerverrel';

  @override
  String get npAlarmSnoozed => 'Ébresztő 5 perccel elhalasztva';

  @override
  String get npAlarmsTitle => 'Ébresztők';

  @override
  String get npAlarmsEmpty => 'Nincs ébresztő';

  @override
  String npZoneNumbered(String id) {
    return '$id. zóna';
  }

  @override
  String get npAlarmSkipsHolidays => 'Ünnepnapokon kihagyva';

  @override
  String get npAlarmSnooze => 'Szundi';

  @override
  String get npAlarmDefaultName => 'Ébresztő';

  @override
  String get npAlarmEdit => 'Ébresztő szerkesztése';

  @override
  String get npAlarmNew => 'Új ébresztő';

  @override
  String get npAlarmTime => 'Időpont';

  @override
  String get npAlarmNameHint => 'Ébredés';

  @override
  String get npAlarmDays => 'Napok';

  @override
  String get npAlarmSkipHolidays => 'Ünnepnapok kihagyása';

  @override
  String get npAlarmCountry => 'Ország:';

  @override
  String get npCountryFR => 'Franciaország';

  @override
  String get npCountryBE => 'Belgium';

  @override
  String get npCountryCH => 'Svájc';

  @override
  String get npCountryCA => 'Kanada';

  @override
  String get npCountryUS => 'USA';

  @override
  String get npCountryDE => 'Németország';

  @override
  String get npCountryGB => 'Egyesült Királyság';

  @override
  String get npAlarmSource => 'Forrás';

  @override
  String get npAlarmSourceType => 'Típus';

  @override
  String get npSourceRadio => 'Rádió';

  @override
  String get npSourcePlaylist => 'Lejátszási lista';

  @override
  String get npSourceAlbum => 'Album';

  @override
  String get npAlarmSourceName => 'Forrás neve';

  @override
  String get npAlarmPlaylistId => 'Lejátszási lista azonosítója';

  @override
  String get npAlarmAlbumId => 'Album azonosítója';

  @override
  String get npAlarmIdentifier => 'Azonosító';

  @override
  String get npAlarmPlaybackZone => 'Lejátszási zóna';

  @override
  String get npAlarmDefaultZone => 'Alapértelmezett';

  @override
  String npAlarmVolume(int percent) {
    return 'Hangerő: $percent%';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return 'Felhangosítás: $seconds mp';
  }

  @override
  String get npAlarmEnabled => 'Bekapcsolva';

  @override
  String get npAlarmDeleteTitle => 'Törlöd az ébresztőt?';

  @override
  String get npDayMon => 'H';

  @override
  String get npDayTue => 'K';

  @override
  String get npDayWed => 'Sze';

  @override
  String get npDayThu => 'Cs';

  @override
  String get npDayFri => 'P';

  @override
  String get npDaySat => 'Szo';

  @override
  String get npDaySun => 'V';

  @override
  String get plHubTitle => 'Lejátszásilista-központ';

  @override
  String get plTabSmartAi => 'MI';

  @override
  String get plTabTransfers => 'Átvitelek';

  @override
  String get plSync => 'Szinkron';

  @override
  String get plTabBackup => 'Mentés';

  @override
  String get plCompare => 'Összehasonlítás';

  @override
  String get plComparing => 'Összehasonlítás…';

  @override
  String plCompareError(String detail) {
    return 'Sikertelen összehasonlítás: $detail';
  }

  @override
  String get plNoPlaylistsAvailable => 'Nincs elérhető lejátszási lista';

  @override
  String get plSectionSource => 'FORRÁS';

  @override
  String get plSectionTarget => 'CÉL';

  @override
  String get plServiceLabel => 'Szolgáltatás';

  @override
  String get plPlaylistLabel => 'Lejátszási lista';

  @override
  String get plLocal => 'Helyi';

  @override
  String get plSourceLabel => 'Forrás';

  @override
  String get plRestoreSnapshotTitle => 'Pillanatkép visszaállítása';

  @override
  String get plLocalPlaylistNameLabel => 'Helyi lejátszási lista neve:';

  @override
  String get plRestore => 'Visszaállítás';

  @override
  String plRestoreDone(String name, String matched, String notFound) {
    return '„$name” visszaállítva: $matched megtalálva, $notFound nem található.';
  }

  @override
  String plRestoreReplaced(String name, String matched, String notFound) {
    return '„$name” lecserélve: $matched megtalálva, $notFound nem található.';
  }

  @override
  String get plExistingTitle => 'A lejátszási lista már létezik';

  @override
  String plExistingBody(String name) {
    return 'Már létezik „$name” nevű lejátszási lista. Lecseréli?';
  }

  @override
  String get plReplace => 'Csere';

  @override
  String plDeleteSnapshotBody(String name) {
    return 'Törli a(z) „$name” pillanatképét?';
  }

  @override
  String get plSyncIntervalTitle => 'Automatikus szinkron gyakorisága';

  @override
  String get plSyncIntervalLabel => 'Perc (0 = csak kézi):';

  @override
  String get plSyncIntervalHint => 'pl. 60';

  @override
  String get plNoTransfers => 'Nincs átvitel';

  @override
  String get plNoSyncLinks => 'Nincs szinkronkapcsolat';

  @override
  String get plNoSyncLinksHint => 'Kapcsolatokat egy átvitelből hozhat létre';

  @override
  String plPlaylistNumber(String id) {
    return '#$id lejátszási lista';
  }

  @override
  String plAutoEveryMinutes(String minutes) {
    return 'auto $minutes perc';
  }

  @override
  String plSyncDone(
    String addedLocal,
    String removedLocal,
    String addedRemote,
    String removedRemote,
  ) {
    return 'Szinkron kész: +$addedLocal/-$removedLocal helyi, +$addedRemote/-$removedRemote távoli';
  }

  @override
  String plSyncConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ', $count ütközés',
    );
    return '$_temp0';
  }

  @override
  String plSyncError(String detail) {
    return 'Sikertelen szinkronizálás: $detail';
  }

  @override
  String get plSectionBackup => 'MENTÉS';

  @override
  String get plBackingUp => 'Mentés folyamatban…';

  @override
  String get plBackupAll => 'Összes lejátszási lista mentése';

  @override
  String plBackupResult(String playlists, String tracks) {
    return '$playlists lejátszási lista · $tracks szám';
  }

  @override
  String get plSectionSnapshots => 'PILLANATKÉPEK';

  @override
  String get plNoSnapshots =>
      'Nincs pillanatkép. Indítson mentést a létrehozáshoz.';

  @override
  String get plSectionBatchTransfer => 'CSOPORTOS ÁTVITEL';

  @override
  String get plBatchTransferHint =>
      'Egy szolgáltatás összes lejátszási listájának átvitele';

  @override
  String get plTransferring => 'Átvitel…';

  @override
  String get plTransferAll => 'Összes átvitele';

  @override
  String plBatchResult(String count, String status) {
    return '$count lejátszási lista — $status';
  }

  @override
  String get plMergeDone => 'Lejátszási listák egyesítve.';

  @override
  String plMergeError(String detail) {
    return 'Sikertelen egyesítés: $detail';
  }

  @override
  String get plNameLabel => 'Név';

  @override
  String plDeleteNamed(String name) {
    return 'Törli: „$name”?';
  }

  @override
  String plImportedLocal(String name) {
    return '„$name” importálva helyileg.';
  }

  @override
  String plImportError(String detail) {
    return 'Sikertelen importálás: $detail';
  }

  @override
  String get plFilterAll => 'Összes';

  @override
  String get plMerge => 'Egyesítés';

  @override
  String get plCancelMerge => 'Egyesítés megszakítása';

  @override
  String get plMerging => 'Egyesítés…';

  @override
  String get plImportToLocal => 'Importálás helyileg';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kiválasztva',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => 'Duplikátumok nélkül';

  @override
  String get plMergedNameHint => 'Az egyesített lista neve';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szám',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => 'EREDMÉNYEK';

  @override
  String get plCommon => 'Közös';

  @override
  String get plSourceOnly => 'Csak forrás';

  @override
  String get plTargetOnly => 'Csak cél';

  @override
  String plMatchRate(String rate) {
    return '$rate% egyezés';
  }

  @override
  String plOnlyInSource(int count) {
    return 'Csak a forrásban ($count)';
  }

  @override
  String plOnlyInTarget(int count) {
    return 'Csak a célban ($count)';
  }

  @override
  String plMoreCount(int count) {
    return '+ további $count';
  }

  @override
  String get plTransferPlaylistTitle => 'Lejátszási lista átvitele';

  @override
  String get plCreateOnRemote => 'Létrehozás a távoli szolgáltatásban';

  @override
  String get plTransfer => 'Átvitel';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return 'Átvitel: $matched egyezik, $approximate közelítő, $notFound hiányzik.';
  }

  @override
  String get plRecover => 'Helyreállítás';

  @override
  String plRecoverDone(int available, int alternatives) {
    return 'Helyreállítás: $available elérhető, $alternatives alternatíva található.';
  }

  @override
  String plCopyName(String name) {
    return '$name (másolat)';
  }

  @override
  String get plDuplicate => 'Duplikálás';

  @override
  String plDuplicated(String name) {
    return 'Duplikálva: $name';
  }

  @override
  String plDeleted(String name) {
    return 'Törölve: $name';
  }

  @override
  String plTransferred(String name) {
    return 'Átvitt: $name';
  }

  @override
  String get plTransferToLocal => 'Átvitel helyileg';

  @override
  String get plExportJson => 'Exportálás JSON-ba';

  @override
  String get plExportCsv => 'Exportálás CSV-be';

  @override
  String get plExportM3u => 'Exportálás M3U-ba';

  @override
  String get plExportJsonDone => 'JSON-exportálás kész';

  @override
  String get plExportCsvDone => 'CSV-exportálás kész';

  @override
  String plExportM3uDone(String path) {
    return 'M3U exportálva: $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'Sikertelen M3U-exportálás: $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importálva: $name ($count szám)',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'Sikertelen M3U-importálás: $detail';
  }

  @override
  String get plSmartTitle => 'Intelligens lejátszási listák';

  @override
  String plSmartLoadError(String detail) {
    return 'Nem sikerült betölteni az intelligens listákat: $detail';
  }

  @override
  String plDeleteError(String detail) {
    return 'Sikertelen törlés: $detail';
  }

  @override
  String get plSmartEmpty => 'Nincs intelligens lejátszási lista';

  @override
  String get plUntitled => 'Névtelen';

  @override
  String get plSmartDeleteTitle => 'Törli az intelligens lejátszási listát?';

  @override
  String plPreviewError(String detail) {
    return 'Sikertelen előnézet: $detail';
  }

  @override
  String get plEnterName => 'Adjon meg egy nevet';

  @override
  String plSaveError(String detail) {
    return 'Sikertelen mentés: $detail';
  }

  @override
  String get plSmartEditTitle => 'Intelligens lista szerkesztése';

  @override
  String get plSmartNewTitle => 'Új intelligens lejátszási lista';

  @override
  String get plMatchLabel => 'Egyezés';

  @override
  String get plMatchAll => 'Minden szabály';

  @override
  String get plMatchAny => 'Bármely szabály';

  @override
  String get plSectionRules => 'SZABÁLYOK';

  @override
  String get plAddRule => 'Szabály hozzáadása';

  @override
  String get plMaxTracksLabel => 'Max. számok (nem kötelező)';

  @override
  String get plNoLimit => 'Nincs korlát';

  @override
  String get plPreviewMatching => 'Egyező számok előnézete';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egyező szám',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => 'Érték';

  @override
  String get plUnknownTitle => 'Ismeretlen';

  @override
  String plTracksLoadError(String detail) {
    return 'Nem sikerült betölteni a számokat: $detail';
  }

  @override
  String get plSmartNoTracks => 'Egy szám sem felel meg ennek a listának';

  @override
  String get plFieldGenre => 'Műfaj';

  @override
  String get plFieldArtist => 'Előadó';

  @override
  String get plFieldAlbum => 'Album';

  @override
  String get plFieldTitle => 'Cím';

  @override
  String get plFieldYear => 'Év';

  @override
  String get plFieldRating => 'Értékelés';

  @override
  String get plFieldPlayCount => 'Lejátszások száma';

  @override
  String get plFieldDuration => 'Időtartam (ms)';

  @override
  String get plFieldDateAdded => 'Hozzáadás dátuma';

  @override
  String get plFieldFavorite => 'Kedvenc';

  @override
  String get plOpContains => 'tartalmazza';

  @override
  String get plOpEquals => 'egyenlő';

  @override
  String get plOpStartsWith => 'ezzel kezdődik';

  @override
  String get plOpEndsWith => 'ezzel végződik';

  @override
  String get plOpGreaterThan => 'nagyobb mint';

  @override
  String get plOpLessThan => 'kisebb mint';

  @override
  String get plOpIs => 'pontosan';

  @override
  String get plOpIsNot => 'nem';

  @override
  String get srvConfigTitle => 'Szerverbeállítások';

  @override
  String srvFolderAdded(String path) {
    return 'Mappa hozzáadva: $path';
  }

  @override
  String get srvRemoveFolderTitle => 'Eltávolítod ezt a mappát?';

  @override
  String srvScanStarted(String path) {
    return 'Beolvasás elindítva: $path';
  }

  @override
  String get srvFullScanStarted => 'Teljes beolvasás elindítva';

  @override
  String get srvRestartTitle => 'Újraindítod a szervert?';

  @override
  String get srvRestartBody =>
      'A szerver leáll, majd újraindul. A folyamatban lévő lejátszás megszakad.';

  @override
  String get srvRestartBtn => 'Újraindítás';

  @override
  String get srvRestarting => 'A szerver újraindul…';

  @override
  String get srvRestartInProgress => 'Újraindítás folyamatban…';

  @override
  String get srvLoadError => 'Betöltési hiba';

  @override
  String get srvScanFolderTooltip => 'Mappa beolvasása';

  @override
  String get srvSectionServerInfo => 'Szerverinformációk';

  @override
  String get srvInfoVersion => 'Verzió';

  @override
  String get srvInfoEngine => 'Motor';

  @override
  String get srvInfoDatabase => 'Adatbázis';

  @override
  String get srvSectionActions => 'Műveletek';

  @override
  String get srvRestartServer => 'Szerver újraindítása';

  @override
  String get srvRestartServerDesc =>
      'Leállítja és újraindítja a szerverfolyamatot';

  @override
  String get srvManualEntry => 'Kézi megadás';

  @override
  String srvSelectPath(String path) {
    return '„$path” kiválasztása';
  }

  @override
  String get srvBrowse => 'Tallózás…';

  @override
  String get srvFolderPathHint => '/eleresi/ut/zene';

  @override
  String get srvFolderPathHelp =>
      'Add meg a mappa abszolút elérési útját a szerveren.';

  @override
  String get srvNoSubfolders => 'Nincsenek almappák';

  @override
  String get srvPluginsTitle => 'Bővítmények';

  @override
  String get srvNotConnectedToServer => 'Nincs kapcsolat a szerverrel';

  @override
  String srvPluginInstalled(String name) {
    return '$name telepítve';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name eltávolítva';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name frissítve';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name engedélyezve';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name letiltva';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return 'A telepítés sikertelen: $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return 'Az eltávolítás sikertelen: $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return 'A frissítés sikertelen: $error';
  }

  @override
  String get srvPluginsTabStore => 'Áruház';

  @override
  String get srvPluginsTabInstalled => 'Telepítve';

  @override
  String get srvRestartRequired =>
      'A módosítások érvénybe lépéséhez újraindítás szükséges';

  @override
  String get srvPluginsSearchHint => 'Bővítmény keresése…';

  @override
  String get srvPluginsNoneFound => 'Nincs találat';

  @override
  String get srvPluginsNoneInstalled => 'Nincs telepített bővítmény';

  @override
  String get srvPluginsBrowseStore => 'Áruház böngészése';

  @override
  String get srvPluginBadgeFeatured => 'Kiemelt';

  @override
  String get srvPluginBadgeUpdate => 'Frissítés';

  @override
  String get srvPluginBadgeIncompatible => 'Nem kompatibilis';

  @override
  String srvPluginByAuthor(String author) {
    return 'készítette: $author';
  }

  @override
  String get srvPluginActionUpdate => 'Frissítés';

  @override
  String get srvPluginActionInstall => 'Telepítés';

  @override
  String get srvPluginActionUninstall => 'Eltávolítás';

  @override
  String get srvPluginStatusActive => 'Aktív';

  @override
  String get srvPluginStatusError => 'Hiba';

  @override
  String get srvAutoFixTitle => 'Metaadatok automatikus javítása';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count javítás alkalmazva',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence =>
      'Nem maradt magas megbízhatóságú javítás';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count javaslat maradt',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => 'Magas megbízhatóságúak alkalmazása';

  @override
  String srvAutoFixTrackNumber(int id) {
    return '#$id. szám';
  }

  @override
  String get srvAutoFixCurrent => 'Jelenlegi';

  @override
  String get srvAutoFixEmpty => '(üres)';

  @override
  String get srvAutoFixSuggested => 'Javasolt';

  @override
  String get srvAutoFixSkip => 'Kihagyás';

  @override
  String get srvAutoFixApply => 'Alkalmazás';

  @override
  String get srvAutoFixIntroTitle => 'Hiányzó metaadatok javítása';

  @override
  String get srvAutoFixIntroBody =>
      'Megkeresi a műfaj, év vagy MusicBrainz-azonosító nélküli számokat, és javításokat javasol a MusicBrainzből.';

  @override
  String get srvAutoFixStartScan => 'Beolvasás indítása';

  @override
  String get srvAutoFixScanning => 'Keresés a MusicBrainzben…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total szám ($pct%)';
  }

  @override
  String get srvAutoFixLoadingTracks => 'Számok betöltése…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eddig $count javítás található',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit =>
      'Legfeljebb 1 kérés/s (MusicBrainz-szabály)';

  @override
  String get srvAutoFixNoneNeeded => 'Nincs szükség javításra';

  @override
  String get srvAutoFixAllComplete => 'Minden szám metaadatai teljesek.';

  @override
  String get srvAutoFixScanAgain => 'Újra beolvasás';

  @override
  String get srvAutoFixScanFailed => 'A beolvasás sikertelen';

  @override
  String get srvMpStepSetup => 'Beállítás';

  @override
  String get srvMpStepFineTune => 'Finomhangolás';

  @override
  String get srvMpListenTitle => 'Hogyan hallgatsz zenét?';

  @override
  String get srvMpListenSubtitle =>
      'A profil a hallgatási környezetedhez igazodik';

  @override
  String get srvMpSpeakers => 'Hangfalak';

  @override
  String get srvMpSpeakersSub => 'Hallgatószoba';

  @override
  String get srvMpHeadphones => 'Fejhallgató';

  @override
  String get srvMpHeadphonesSub => 'Egyéni hallgatás';

  @override
  String get srvMpRoomTitle => 'Mekkora a helyiség?';

  @override
  String get srvMpRoomSubtitle =>
      'Hatással van a mély frekvenciákra és az utózengésre';

  @override
  String get srvMpRoomSmall => 'Kicsi';

  @override
  String get srvMpRoomMedium => 'Közepes';

  @override
  String get srvMpRoomLarge => 'Nagy';

  @override
  String get srvMpPlacementTitle => 'Hangfalak elhelyezése';

  @override
  String get srvMpPlacementSubtitle =>
      'Az elhelyezés befolyásolja a basszus visszaverődését';

  @override
  String get srvMpNearWall => 'Fal közelében';

  @override
  String get srvMpFreeStanding => 'Szabadon álló';

  @override
  String get srvMpTuneSound => 'Hangzás beállítása';

  @override
  String get srvMpCorrectionActive => 'Korrekció bekapcsolva';

  @override
  String get srvMpCorrectionDesc => 'A profilt az aktuális zónára alkalmazza';

  @override
  String get srvMpBass => 'Mélyek';

  @override
  String get srvMpBassDesc => 'A hang súlya, melegsége, teste';

  @override
  String get srvMpBassLow => 'Vékony';

  @override
  String get srvMpBassHigh => 'Testes';

  @override
  String get srvMpMid => 'Ének / Közepek';

  @override
  String get srvMpMidDesc => 'Jelenlét, tisztaság, érthetőség';

  @override
  String get srvMpMidLow => 'Háttérben';

  @override
  String get srvMpMidHigh => 'Előtérben';

  @override
  String get srvMpTreble => 'Magasak';

  @override
  String get srvMpTrebleDesc => 'Csillogás, részletesség, levegősség';

  @override
  String get srvMpTrebleLow => 'Sötét';

  @override
  String get srvMpTrebleHigh => 'Fényes';

  @override
  String get srvMpProfileApplied => 'Profil alkalmazva';

  @override
  String get srvMpApplying => 'Alkalmazás…';

  @override
  String get srvMpApply => 'Profil alkalmazása';

  @override
  String get srvMpBackToQuestions => 'Vissza a kérdésekhez';

  @override
  String get srvRemoteConfigBody =>
      'Csatlakozz egy Tune szerverhez a hálózatodon, hogy minden funkciót használhass.';

  @override
  String get srvModeStandalone => 'Önálló';

  @override
  String get srvStandaloneWarning =>
      'Önálló mód: a Party, a DJ, a szinkronizált dalszöveg, az EQ és az ajánlások nem érhetők el. Ajánlott: távoli Tune szerver használata.';

  @override
  String get srvServerAddress => 'Szerver címe';

  @override
  String get srvNoServerYet => 'Még nincs szervered?';

  @override
  String get srvDownloadServer =>
      'Töltsd le a Tune Servert: mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).';

  @override
  String get srvStreamingBody =>
      'Kapcsold be a Tune-nal használni kívánt streamingszolgáltatásokat.';

  @override
  String get srvStreamingStandaloneWarning =>
      'Önálló módban a streamingszolgáltatások nem érhetők el. Válts távoli szerver módra a bekapcsolásukhoz.';

  @override
  String get srvNoServiceAvailable =>
      'Nincs elérhető szolgáltatás. Ellenőrizd a szerverkapcsolatot.';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szolgáltatás bekapcsolva',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count csatlakoztatva',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected =>
      'Bekapcsolva, nincs csatlakoztatva';

  @override
  String get srvAudioCheckTitle => 'Hangdiagnosztika';

  @override
  String get srvAudioCheckBody => 'A rendszer hangbeállításainak ellenőrzése.';

  @override
  String get srvDiagZones => 'Beállított zónák';

  @override
  String get srvDiagOutputs => 'Hangkimenetek';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count észlelve',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => 'Hálózati eszközök';

  @override
  String get srvDiagNone => 'Nincs';

  @override
  String get srvDiagNoZoneWarning =>
      'Nincs beállított zóna. A Zónák beállításaiban hozhatsz létre egyet.';

  @override
  String srvAudioCheckUnavailable(String error) {
    return 'A hangdiagnosztika nem érhető el: $error';
  }

  @override
  String get srvRecheck => 'Újraellenőrzés';

  @override
  String get srvScanBody =>
      'Indíts beolvasást a zenefájlok indexeléséhez és metaadataik lekéréséhez.';

  @override
  String get srvScanStart => 'Beolvasás indítása';

  @override
  String get srvScanStatScanned => 'Beolvasva';

  @override
  String get srvScanStatAdded => 'Hozzáadva';

  @override
  String get srvScanStatUpdated => 'Frissítve';

  @override
  String get srvScanMayTakeMinutes => 'Ez eltarthat néhány percig…';

  @override
  String get srvScanComplete => 'Beolvasás kész!';

  @override
  String stgUpdateAvailable(String version) {
    return 'Frissítés érhető el: v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return 'Jelenlegi verzió: v$version';
  }

  @override
  String get stgOpen => 'Megnyitás';

  @override
  String get stgMode => 'Mód';

  @override
  String stgConnectedTo(String address) {
    return 'Csatlakozva: $address';
  }

  @override
  String get stgModeRemote => 'Távoli';

  @override
  String get stgStandaloneTitle => 'Önálló mód — korlátozott funkciók';

  @override
  String get stgStandaloneBody =>
      'A Party, a DJ, a szinkronizált dalszöveg, az EQ, az albumismertetők és az ajánlások… távoli Tune szervert igényelnek.';

  @override
  String get stgServerAddress => 'Szervercím';

  @override
  String get stgNotConfigured => 'Nincs beállítva';

  @override
  String get stgScanNetwork => 'Hálózat keresése';

  @override
  String get stgSectionPlayback => 'LEJÁTSZÁS';

  @override
  String get stgCrossfade => 'Áttűnés';

  @override
  String get stgRepeatOneByDefault => 'Ismétlés alapértelmezésként';

  @override
  String get stgExclusiveMode => 'Exkluzív mód (bit-perfect)';

  @override
  String get stgExclusiveModeDesc =>
      'WASAPI Exclusive — közvetlen hozzáférés az USB DAC-hoz';

  @override
  String get stgSectionMetadataFields => 'METAADATMEZŐK';

  @override
  String get stgSectionAdvancedAudio => 'HALADÓ HANGBEÁLLÍTÁSOK';

  @override
  String get stgEqualizer => 'Hangszínszabályzó';

  @override
  String get stgEqualizerDesc => 'Kalibrációs varázsló + 10 sávos szakértői EQ';

  @override
  String get stgMetadataFieldsDesc =>
      'Bővített mezők beállítása (zeneszerző, karmester…)';

  @override
  String get stgSpotifyConnectDesc =>
      'Tune vevőként (a kliensen Premium szükséges)';

  @override
  String get stgLastfmDesc => 'Hallgatási előzmények scrobble-ölése';

  @override
  String get stgListenBrainzDesc => 'Scrobble a ListenBrainz-re';

  @override
  String get stgAutoFixMetadata => 'Metaadatok automatikus javítása';

  @override
  String get stgAutoFixMetadataDesc =>
      'Hiányzó műfaj, év, MBID pótlása a MusicBrainz segítségével';

  @override
  String get stgDatabase => 'Adatbázis';

  @override
  String get stgImportExport => 'Importálás / Exportálás';

  @override
  String get stgSectionProfiles => 'PROFILOK';

  @override
  String get stgSectionSystem => 'RENDSZER';

  @override
  String get stgServerConfig => 'Szerverbeállítások';

  @override
  String get stgServerConfigDesc => 'Zenei mappák, beolvasás, újraindítás';

  @override
  String get stgNetworkDiagnostics => 'Hálózati diagnosztika';

  @override
  String get stgNetworkDiagnosticsDesc => 'Multicast, DNS, kapcsolat';

  @override
  String get stgConfiguration => 'Konfiguráció';

  @override
  String get stgExportImport => 'Exportálás / Importálás';

  @override
  String get stgPlugins => 'Bővítmények';

  @override
  String get stgPluginsDesc => 'Telepített bővítmények';

  @override
  String get stgNetworkShares => 'Hálózati megosztások (SMB)';

  @override
  String get stgNetworkSharesDesc => 'Megosztások felderítése és csatolása';

  @override
  String get stgSectionCloud => 'FELHŐ';

  @override
  String get stgSectionHelp => 'SÚGÓ';

  @override
  String get stgTroubleshooting => 'Hibaelhárítás';

  @override
  String get stgTroubleshootingDesc => 'Gyakori kérdések és megoldások';

  @override
  String get stgSendBugReport => 'Hibajelentés küldése';

  @override
  String get stgSendBugReportDesc => 'Műszaki jelentés készítése és másolása';

  @override
  String get stgServerAddressHint => 'IP-cím vagy gépnév (pl. 192.168.1.18)';

  @override
  String get stgServerPort => 'Szerverport';

  @override
  String get stgPortDefaultHint => 'Port (alapértelmezett: 8888)';

  @override
  String get stgWarnNoZones =>
      'Nincs beállított zóna. Hozz létre egyet a lejátszáshoz.';

  @override
  String get stgWarnNoNetworkDevices =>
      'Nem található hálózati eszköz (DLNA/BluOS/Chromecast).';

  @override
  String get stgSectionAudio => 'HANG';

  @override
  String get stgAudioOutputs => 'Hangkimenetek';

  @override
  String stgOutputsDetected(int count) {
    return '$count észlelve';
  }

  @override
  String get stgNetworkDevices => 'Hálózati eszközök';

  @override
  String get stgZoneNameHint => 'pl. Nappali, Dolgozószoba';

  @override
  String get stgProfileActivated => 'Profil aktiválva';

  @override
  String get stgNewProfile => 'Új profil';

  @override
  String get stgProfileName => 'Profilnév';

  @override
  String get stgProfileNameHint => 'pl. Este, Reggel';

  @override
  String get stgProfileUpdated => 'Profil frissítve';

  @override
  String get stgNoProfiles => 'Nincs profil';

  @override
  String get stgProfile => 'Profil';

  @override
  String get stgEditProfile => 'Profil szerkesztése';

  @override
  String get stgName => 'Név';

  @override
  String get stgColor => 'Szín';

  @override
  String get stgScanInProgress => 'Hálózat keresése…';

  @override
  String stgScanChecking(int scanned, int total) {
    return 'Ellenőrzés: $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'Nem található Tune szerver';

  @override
  String stgServersFound(int count) {
    return '$count szerver található';
  }

  @override
  String get stgTuneServers => 'Tune szerverek';

  @override
  String get stgFieldFormat => 'Formátum (FLAC, MP3…)';

  @override
  String get stgFieldSampleRate => 'Mintavételi frekvencia (96 kHz)';

  @override
  String get stgFieldBitDepth => 'Bitmélység (24 bit)';

  @override
  String get stgFieldLabel => 'Kiadó';

  @override
  String get stgFieldComposer => 'Zeneszerző';

  @override
  String get stgFieldDuration => 'Időtartam';

  @override
  String get stgFieldSource => 'Forrás (Tidal, Qobuz…)';

  @override
  String get stgMetadataFieldsIntro =>
      'Az egyes számok alatt megjelenő mezők (keresés, könyvtár, lejátszási sor, előzmények)';

  @override
  String get stgAudiophileMode => 'Audiofil mód';

  @override
  String get stgAudiophileModeDesc =>
      'DSP megkerülve, EQ kikapcsolva, bit-perfect';

  @override
  String get stgCloudAccount => 'Felhőfiók';

  @override
  String stgConnectedAs(String email) {
    return 'Csatlakozva ($email)';
  }

  @override
  String get stgTelemetry => 'Telemetria';

  @override
  String get stgTelemetryDesc => 'Névtelen használati statisztikák küldése';

  @override
  String get stgSyncingLibrary => 'Könyvtár szinkronizálása…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total szám';
  }

  @override
  String get stgConnectingStreaming =>
      'Csatlakozás a streamingszolgáltatásokhoz…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'Újdonságok – v$version';
  }

  @override
  String get stgWhatsNewLibrarySync =>
      'Továbbfejlesztett könyvtár-szinkronizálás';

  @override
  String get stgWhatsNewMultiRoom => 'Optimalizált multiroom és zónakezelés';

  @override
  String get stgWhatsNewBugFixes => 'Hibajavítások és stabilitásjavítások';

  @override
  String get stgStartServerFailed => 'Nem sikerült elindítani a szervert';

  @override
  String stgStartServerFailedWith(String detail) {
    return 'Nem sikerült elindítani a szervert: $detail';
  }

  @override
  String get stgConnectionFailed => 'A csatlakozás sikertelen';

  @override
  String stgConnectionFailedWith(String detail) {
    return 'A csatlakozás sikertelen: $detail';
  }

  @override
  String get stgStartingServer => 'Tune Server indítása…';

  @override
  String get stgTagline => 'Multiroom zeneszerver';

  @override
  String get stgLocalServer => 'Helyi szerver';

  @override
  String get stgLocalServerDesc =>
      'Futtasd a Tune-t ezen az eszközön.\nA te zenéd, a te szabályaid.';

  @override
  String get stgRemoteControl => 'Távirányító';

  @override
  String get stgRemoteControlDesc =>
      'Csatlakozz egy Tune szerverhez\na hálózatodon.';

  @override
  String get stgRemoteConnection => 'Távoli kapcsolat';

  @override
  String get znZoneManagerTitle => 'Zónakezelő';

  @override
  String get znCannotDeleteLastZone => 'Az utolsó zóna nem törölhető';

  @override
  String znZoneSwitchError(String error) {
    return 'Nem sikerült zónát váltani: $error';
  }

  @override
  String get znZoneSettings => 'Zóna beállításai';

  @override
  String get znPhoneSpeakers => 'A telefon hangszórói';

  @override
  String get znBtConnectedOutputs => 'Csatlakoztatott Bluetooth-kimenetek';

  @override
  String get znBtSystemOutput =>
      'A rendszerkimenetet használja (Vezérlőközpont)';

  @override
  String get znBtOutputsTitle => 'Bluetooth-kimenetek';

  @override
  String get znBtNoDevice =>
      'Nincs csatlakoztatott Bluetooth-eszköz. Párosítson egy eszközt a rendszerbeállításokban.';

  @override
  String get znBtAndroidRouting =>
      'Az aktív útválasztás az Android rendszerbeállításaitól függ.';

  @override
  String get znDsdMode => 'DSD mód';

  @override
  String get znDsdAuto => 'Auto';

  @override
  String get znDsdNative => 'Natív';

  @override
  String get znGaplessDlnaDesc => 'Szünetmentes átmenet a számok között (DLNA)';

  @override
  String get znFixedVolume => 'Rögzített hangerő';

  @override
  String get znFixedVolumeDesc =>
      'Kikapcsolja a szoftveres hangerő-szabályzást';

  @override
  String get znCap16Bit => 'Korlátozás 16 bitre';

  @override
  String get znCap16BitDesc =>
      'Kapcsolja be, ha a hi-res (24 bites) hang néma, a 16 bites viszont szól (Ruark R3). 16 bites FLAC-ra alakít.';

  @override
  String get znZoneMuted => 'Zóna némítva';

  @override
  String get znZoneUnmuted => 'Némítás feloldva';

  @override
  String znErrMute(String error) {
    return 'Némítási hiba: $error';
  }

  @override
  String znErrVolume(String error) {
    return 'Hangerőhiba: $error';
  }

  @override
  String znErrLatency(String error) {
    return 'Késleltetési hiba: $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return 'Csoporthangerő-hiba: $error';
  }

  @override
  String get znCalibrationDone => 'A kalibrálás kész';

  @override
  String znErrCalibration(String error) {
    return 'Kalibrálási hiba: $error';
  }

  @override
  String znErrDissolve(String error) {
    return 'Nem sikerült feloszlatni a csoportot: $error';
  }

  @override
  String get znRenameGroupTitle => 'Csoport átnevezése';

  @override
  String get znNewNameHint => 'Új név';

  @override
  String get znRename => 'Átnevezés';

  @override
  String get znGroupRenamed => 'Csoport átnevezve';

  @override
  String znErrRename(String error) {
    return 'Átnevezési hiba: $error';
  }

  @override
  String get znGroupNeedTwoZones =>
      'Csoport létrehozásához legalább 2 zóna kell';

  @override
  String get znGroupNameLabel => 'Csoport neve';

  @override
  String get znGroupNameHint => 'pl. Nappali + Konyha';

  @override
  String get znChooseLeader => 'Vezető kiválasztása';

  @override
  String get znMembers => 'Tagok';

  @override
  String znErrCreateGroup(String error) {
    return 'Nem sikerült létrehozni a csoportot: $error';
  }

  @override
  String get znProfileActivated => 'Profil aktiválva';

  @override
  String znErrActivate(String error) {
    return 'Aktiválási hiba: $error';
  }

  @override
  String get znProfileDeleted => 'Profil törölve';

  @override
  String znErrDelete(String error) {
    return 'Törlési hiba: $error';
  }

  @override
  String get znNoOfflineZones => 'Nincs eltávolítandó offline zóna';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offline zóna eltávolítva',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return 'Tisztítási hiba: $error';
  }

  @override
  String get znSaveConfigTitle => 'Konfiguráció mentése';

  @override
  String get znProfileNameLabel => 'Profil neve';

  @override
  String get znProfileNameHint => 'pl. Buli, Csendes reggel';

  @override
  String get znDescriptionOptional => 'Leírás (nem kötelező)';

  @override
  String get znNameRequired => 'A név megadása kötelező';

  @override
  String get znProfileSaved => 'Profil mentve';

  @override
  String znErrSave(String error) {
    return 'Mentési hiba: $error';
  }

  @override
  String get znCleanupOffline => 'Offline zónák eltávolítása';

  @override
  String get znRemoteRequired =>
      'A zónakezelőhöz távoli szerverkapcsolat szükséges.';

  @override
  String get znDataUnavailable => 'Az adatok nem érhetők el';

  @override
  String get znGroups => 'Csoportok';

  @override
  String get znNoGroups => 'Nincs csoport';

  @override
  String get znGroupFallback => 'Csoport';

  @override
  String znZoneFallback(String id) {
    return '$id. zóna';
  }

  @override
  String get znCalibrate => 'Kalibrálás';

  @override
  String get znDissolve => 'Feloszlatás';

  @override
  String get znProfiles => 'Profilok';

  @override
  String get znNoProfiles => 'Nincs mentett profil';

  @override
  String get znSaveConfigButton => 'Konfiguráció mentése';

  @override
  String get znProfileFallback => 'Profil';

  @override
  String get znPins => 'Kitűzések';

  @override
  String znPinFallback(int n) {
    return '$n. kitűzés';
  }

  @override
  String znPinInvoked(int n) {
    return '$n. kitűzés elindítva';
  }

  @override
  String znPinInvokeError(String error) {
    return 'Nem sikerült elindítani a kitűzést: $error';
  }

  @override
  String get znNoPins => 'Nincs beállított kitűzés';

  @override
  String get znMute => 'Némítás';

  @override
  String get znUnmute => 'Némítás feloldása';

  @override
  String get znLatency => 'Késleltetés';

  @override
  String get znLatencyError => 'hiba';

  @override
  String znPartyAddError(String error) {
    return 'Nem sikerült hozzáadni a számot: $error';
  }

  @override
  String znPartyVoteError(String error) {
    return 'Szavazási hiba: $error';
  }

  @override
  String get znPartyLinkCopied => 'A bulilink a vágólapra másolva';

  @override
  String get znPartyTitle => 'Buli mód';

  @override
  String get znPartyShareLink => 'Bulilink megosztása';

  @override
  String get znPartyAddHint => 'Szám hozzáadása…';

  @override
  String get znPartyQueue => 'Várólista';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szám',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => 'Ismeretlen zóna';

  @override
  String get znUnknownTitle => 'Ismeretlen';

  @override
  String get znNowPlaying => 'Most szól';

  @override
  String get znUpvote => 'Szavazat';

  @override
  String znDjLoadOnDeck(String deck) {
    return 'Szám betöltése a(z) $deck deckre';
  }

  @override
  String get znDjSearchHint => 'Számok keresése…';

  @override
  String get znDjSearchHelp =>
      'Írja be a szám címét, majd koppintson a Keresés és betöltés gombra';

  @override
  String get znDjNoTracksFound => 'Nincs találat';

  @override
  String znDjSearchError(String error) {
    return 'Keresési hiba: $error';
  }

  @override
  String get znDjSearchAndLoad => 'Keresés és betöltés';

  @override
  String znDjLoadError(String error) {
    return 'Betöltési hiba: $error';
  }

  @override
  String znDjPlayError(String error) {
    return 'Lejátszási hiba: $error';
  }

  @override
  String znDjPauseError(String error) {
    return 'Szüneteltetési hiba: $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return 'Áttűnési hiba: $error';
  }

  @override
  String get znDjTitle => 'DJ mód';

  @override
  String get znDjDisabled => 'A DJ mód ki van kapcsolva';

  @override
  String get znDjEnableHint => 'Kapcsolja be a keveréshez';

  @override
  String znDjDeck(String deck) {
    return '$deck deck';
  }

  @override
  String get znDjCrossfade => 'Áttűnés';

  @override
  String znDjDuration(String seconds) {
    return 'Időtartam: $seconds mp';
  }

  @override
  String get znDjStartCrossfade => 'Áttűnés indítása';

  @override
  String get znDjAutoCrossfade => 'Automatikus áttűnés';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return 'Szinkron $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => 'A szinkronizálás nem sikerült';

  @override
  String get znDjNoTrackLoaded => 'Nincs betöltött szám';

  @override
  String get znDjLoadTrack => 'Szám betöltése';

  @override
  String get znDjGain => 'Erősítés';

  @override
  String cfgSizeBytes(String size) {
    return '$size B';
  }

  @override
  String cfgSizeKilobytes(String size) {
    return '$size KB';
  }

  @override
  String cfgSizeMegabytes(String size) {
    return '$size MB';
  }
}
