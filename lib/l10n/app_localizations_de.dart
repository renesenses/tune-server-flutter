// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => 'OK';

  @override
  String get btnCancel => 'Abbrechen';

  @override
  String get btnAdd => 'Hinzufügen';

  @override
  String get btnSave => 'Speichern';

  @override
  String get btnDelete => 'Löschen';

  @override
  String get btnEdit => 'Bearbeiten';

  @override
  String get btnClose => 'Schließen';

  @override
  String get btnRetry => 'Erneut versuchen';

  @override
  String get btnCreate => 'Erstellen';

  @override
  String get btnClear => 'Löschen';

  @override
  String get btnNext => 'Weiter';

  @override
  String get btnSkip => 'Diesen Schritt überspringen';

  @override
  String get btnFinish => 'Konfiguration abschließen';

  @override
  String get btnStart => 'Starten';

  @override
  String get btnConnect => 'Verbinden';

  @override
  String get btnDisconnect => 'Trennen';

  @override
  String get btnDownload => 'Herunterladen';

  @override
  String get btnImport => 'Importieren';

  @override
  String get btnExport => 'Exportieren';

  @override
  String get btnReset => 'Zurücksetzen';

  @override
  String get btnUse => 'Verwenden';

  @override
  String get btnShuffle => 'Zufällig';

  @override
  String get btnSeeAll => 'Alle anzeigen';

  @override
  String get btnRefresh => 'Aktualisieren';

  @override
  String get btnScan => 'Bibliothek scannen';

  @override
  String get btnAddFolder => 'Ordner hinzufügen';

  @override
  String get actionIrreversible =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get rootStartError => 'Startfehler';

  @override
  String get playbackErrorNoZone =>
      'Keine Zone ausgewählt — bitte eine Zone erstellen oder auswählen';

  @override
  String get playbackErrorZoneNotFound => 'Zone nicht gefunden';

  @override
  String get playbackErrorFailed => 'Wiedergabe fehlgeschlagen';

  @override
  String zoneLimitReached(int limit) {
    return 'Kostenlose Version auf $limit Zonen begrenzt — auf Premium upgraden für unbegrenzte Zonen';
  }

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get navSearch => 'Suche';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navRadios => 'Radios';

  @override
  String get navZones => 'Zonen';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get libraryTitle => 'Bibliothek';

  @override
  String get tabAlbums => 'Alben';

  @override
  String get tabArtists => 'Künstler';

  @override
  String get tabTracks => 'Titel';

  @override
  String albumTracksDuration(int count, String duration) {
    return '$count Titel · $duration';
  }

  @override
  String get tabGenres => 'Genres';

  @override
  String get tabPlaylists => 'Playlists';

  @override
  String get tabFavorites => 'Favoriten';

  @override
  String get favoriteAdded => 'Zu Favoriten hinzugefügt';

  @override
  String get favoriteRemoved => 'Aus Favoriten entfernt';

  @override
  String get libraryEmptyFavorites => 'Keine Favoriten';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => 'Keine Alben in der Bibliothek';

  @override
  String get libraryEmptyArtists => 'Keine Künstler in der Bibliothek';

  @override
  String get libraryEmptyTracks => 'Keine Titel in der Bibliothek';

  @override
  String get libraryEmptyGenres => 'Keine Genres';

  @override
  String get libraryEmptyPlaylists => 'Keine Playlists';

  @override
  String get libraryNoFilterResults => 'Keine Alben entsprechen den Filtern';

  @override
  String get libraryPlayAll => 'Alle abspielen';

  @override
  String get libraryAddTo => 'Hinzufügen zu…';

  @override
  String get libraryEditAlbum => 'Album bearbeiten';

  @override
  String get libraryEditTrack => 'Titel bearbeiten';

  @override
  String get libraryPlay => 'Abspielen';

  @override
  String get genresAllTracks => 'Alle Titel';

  @override
  String get playlistCreate => 'Playlist erstellen';

  @override
  String get playlistName => 'Playlist-Name';

  @override
  String get playlistEmpty => 'Keine Titel';

  @override
  String get playlistAddTo => 'Zur Playlist hinzufügen';

  @override
  String get playlistNewPlaylist => 'Neue Playlist';

  @override
  String playlistTrackAdded(String name) {
    return 'Zu „$name\" hinzugefügt';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return 'Bereits in „$name\"';
  }

  @override
  String playlistTracksAdded(int count, String name) {
    return '$count Titel zu \"$name\" hinzugefügt';
  }

  @override
  String get playlistAddAllTracks => 'Alle zur Playlist hinzufügen';

  @override
  String get playlistDeleteTitle => 'Playlist löschen?';

  @override
  String get playlistDeleteBody => 'Diese Playlist wird dauerhaft gelöscht.';

  @override
  String get searchHint => 'Suchen…';

  @override
  String get searchNoResults => 'Keine Ergebnisse';

  @override
  String get searchTopResult => 'Bestes Ergebnis';

  @override
  String get searchSectionTracks => 'Titel';

  @override
  String get searchSectionAlbums => 'Alben';

  @override
  String get searchSectionArtists => 'Künstler';

  @override
  String get searchSectionStreaming => 'Streaming';

  @override
  String get homeRecentlyPlayed => 'Zuletzt gespielt';

  @override
  String get homeLibrary => 'Bibliothek';

  @override
  String get homeQuickAccess => 'Schnellzugriff';

  @override
  String get homeHistory => 'Verlauf';

  @override
  String get homeBrowseDlna => 'DLNA durchsuchen';

  @override
  String get homeStatTracks => 'Titel';

  @override
  String get homeStatAlbums => 'Alben';

  @override
  String get homeStatArtists => 'Künstler';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historyEmpty => 'Kein Verlauf';

  @override
  String get historyClear => 'Löschen';

  @override
  String get historyClearTitle => 'Verlauf löschen';

  @override
  String get nowPlayingNoTrack => 'Kein Titel';

  @override
  String get queueTitle => 'Wiedergabeliste';

  @override
  String queueUpNextSummary(int count, String time) {
    return '$count als Nächstes · $time';
  }

  @override
  String get queueEmpty => 'Liste leer';

  @override
  String get queueClearTitle => 'Liste leeren?';

  @override
  String get queueClearBody =>
      'Alle Titel werden aus der Wiedergabeliste entfernt.';

  @override
  String get zonesTitle => 'Zonen';

  @override
  String get zonesNew => 'Neue Zone';

  @override
  String get zonesNewName => 'Zonenname';

  @override
  String get zonesNone => 'Keine Zonen';

  @override
  String get zonesRename => 'Zone umbenennen';

  @override
  String get zonesDelete => 'Zone löschen';

  @override
  String get zonesDevices => 'Verfügbare Geräte';

  @override
  String get zonesOutputLocal => 'Lokal';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesAirplayPair => 'Koppeln (PIN-Code)';

  @override
  String get zonesAirplayPairTitle => 'AirPlay-Kopplung';

  @override
  String get zonesAirplayPairIntro =>
      'Manche Fernseher (Samsung, LG) und das Apple TV zeigen einen vierstelligen Code auf dem Bildschirm an. Starten Sie die Kopplung und geben Sie dann den Code ein.';

  @override
  String get zonesAirplayPairWaiting =>
      'Warten auf den auf dem Gerät angezeigten Code…';

  @override
  String get zonesAirplayPairEnterCode =>
      'Geben Sie den auf dem Gerät angezeigten Code ein:';

  @override
  String get zonesAirplayPairStart => 'Kopplung starten';

  @override
  String get zonesAirplayPairSubmit => 'Code bestätigen';

  @override
  String get zonesAirplayPairRetry => 'Erneut versuchen';

  @override
  String get zonesOutputBluetooth => 'Bluetooth';

  @override
  String get zonesChangeOutput => 'Ausgabe ändern';

  @override
  String get zonesOutputTitle => 'Audioausgabe';

  @override
  String get zonesAssignDevice => 'Zuweisen';

  @override
  String get zonesTransferTitle => 'Wiedergabe auf...';

  @override
  String get zonesNowPlaying => 'Läuft hier';

  @override
  String zonesActivated(String name) {
    return 'Aktive Zone: $name';
  }

  @override
  String get radiosTitle => 'Radios';

  @override
  String get radiosTabAll => 'Alle';

  @override
  String get radiosTabFavorites => 'Favoriten';

  @override
  String get radiosNone => 'Keine Radios';

  @override
  String get radiosFavNone => 'Keine Lieblingsradios';

  @override
  String get radiosSavedFavorites => 'Gespeicherte Favoriten';

  @override
  String get radiosAdd => 'Radio hinzufügen';

  @override
  String get radiosName => 'Name';

  @override
  String get radiosStreamUrl => 'Stream-URL';

  @override
  String get radiosGenre => 'Genre (optional)';

  @override
  String get radiosPasteM3u => 'M3U einfügen';

  @override
  String get radiosImportUrl => 'Von URL importieren';

  @override
  String get radiosImportUrlLabel => 'URL der M3U-Datei';

  @override
  String radiosImportResult(int count) {
    return '$count Station(en) importiert';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'HTTP-Fehler $code';
  }

  @override
  String get radiosImportFailed => 'Datei konnte nicht heruntergeladen werden';

  @override
  String get radiosFavSaved => 'Titel gespeichert';

  @override
  String get radioSaveFavorite => 'Titel speichern';

  @override
  String get radioFavTitle => 'Radio-Favoriten';

  @override
  String get radioFavEmpty => 'Keine gespeicherten Favoriten';

  @override
  String get radioFavExportCsv => 'CSV exportieren';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get streamingConnected => 'Verbunden';

  @override
  String get streamingNotConnected => 'Nicht verbunden';

  @override
  String get streamingEmail => 'E-Mail';

  @override
  String get streamingPassword => 'Passwort';

  @override
  String get streamingSignIn => 'Anmelden';

  @override
  String get streamingSigningIn => 'Anmeldung…';

  @override
  String get streamingDeviceCode => 'Bestätigungscode';

  @override
  String get streamingOpenLink => 'Öffnen…';

  @override
  String get streamingLogoutTitle => 'Abmelden?';

  @override
  String streamingLogoutBody(String service) {
    return 'Von $service abmelden?';
  }

  @override
  String get streamingAuthError => 'Authentifizierung fehlgeschlagen';

  @override
  String get streamingAlbumsSection => 'Alben';

  @override
  String get streamingPlaylistsSection => 'Playlists';

  @override
  String get browseTitle => 'Durchsuchen';

  @override
  String get browseRefreshTooltip => 'Aktualisieren';

  @override
  String get browseNoServers => 'Keine UPnP/DLNA-Server erkannt';

  @override
  String get browseNoServersHint =>
      'Stellen Sie sicher, dass Ihr Server im selben WLAN ist.';

  @override
  String get browseNoContent => 'Leerer Ordner';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionAppearance => 'Erscheinungsbild';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLangSystem => 'System';

  @override
  String get settingsSectionZones => 'Zonen';

  @override
  String get settingsDefaultZone => 'Standardzone';

  @override
  String get settingsDefaultZoneAuto => 'Automatisch';

  @override
  String get settingsNoZones => 'Keine Zonen';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsHttpPort => 'HTTP-Port';

  @override
  String get settingsHttpPortDesc => 'Hauptserver-Port';

  @override
  String get settingsLocalIp => 'Lokale IP-Adresse';

  @override
  String get settingsSectionLibrary => 'Bibliothek';

  @override
  String get settingsMetadata => 'Musik & Metadaten';

  @override
  String get settingsMetadataDesc => 'Ordner, Scan, Statistiken';

  @override
  String get settingsSetupWizard => 'Einrichtungsassistent';

  @override
  String get settingsSetupWizardDesc => 'Musikquellen neu konfigurieren';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsVersion => 'Version 0.1.0';

  @override
  String get settingsResetConfig => 'Konfiguration zurücksetzen';

  @override
  String get settingsResetTitle => 'Zurücksetzen?';

  @override
  String get settingsResetBody =>
      'Alle Einstellungen werden zurückgesetzt. Der Startassistent wird beim nächsten Start angezeigt.';

  @override
  String get settingsPortTitle => 'HTTP-Port';

  @override
  String get settingsPortHint => 'Port (1024–65535)';

  @override
  String get metadataTitle => 'Musik & Metadaten';

  @override
  String get metadataRefreshStats => 'Statistiken aktualisieren';

  @override
  String get metadataSectionStats => 'Statistiken';

  @override
  String get metadataStatTracks => 'Titel';

  @override
  String get metadataStatAlbums => 'Alben';

  @override
  String get metadataStatArtists => 'Künstler';

  @override
  String get metadataStatPlaylists => 'Playlists';

  @override
  String get metadataStatRadios => 'Radios';

  @override
  String get metadataStatArtwork => 'Cover-Cache';

  @override
  String get metadataSectionScan => 'Bibliothek-Scan';

  @override
  String metadataScanInProgress(int current, int total) {
    return 'Scan läuft… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return 'Letzter Scan: +$added hinzugefügt, $updated aktualisiert';
  }

  @override
  String get metadataScanBtn => 'Bibliothek scannen';

  @override
  String get metadataScanDesc => 'Alle konfigurierten Ordner indexieren';

  @override
  String get metadataSectionFolders => 'Musikordner';

  @override
  String get metadataFoldersNone => 'Keine Ordner konfiguriert';

  @override
  String metadataFolderAddedOn(String date) {
    return 'Hinzugefügt am $date';
  }

  @override
  String get metadataAddFolder => 'Ordner hinzufügen';

  @override
  String get metadataFolderPath => 'Ordnerpfad';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => 'Bereinigung';

  @override
  String get metadataCleanupOrphans => 'Verwaiste löschen';

  @override
  String get metadataCleanupOrphansDesc => 'Alben und Künstler ohne Titel';

  @override
  String get metadataClearLibrary => 'Bibliothek leeren';

  @override
  String get metadataClearLibraryDesc => 'Löscht alle lokalen Titel';

  @override
  String get metadataCleanupOrphansTitle => 'Verwaiste löschen?';

  @override
  String get metadataCleanupOrphansBody =>
      'Alben und Künstler ohne zugehörige Titel werden aus der Datenbank gelöscht.';

  @override
  String get metadataClearLibraryTitle => 'Bibliothek leeren?';

  @override
  String get metadataClearLibraryBody =>
      'Alle lokalen Titel, Alben und Künstler werden aus der Datenbank gelöscht. Diese Aktion ist irreversibel.';

  @override
  String get metadataOrphansDeleted => 'Verwaiste gelöscht';

  @override
  String get metadataLibraryCleared => 'Bibliothek geleert';

  @override
  String get metadataDeleteBtn => 'Löschen';

  @override
  String get metadataClearBtn => 'Leeren';

  @override
  String get setupWelcomeTitle => 'Willkommen bei\nTune Server';

  @override
  String get setupWelcomeBody =>
      'Ihr eingebetteter Multiroom-Musikserver. Streamen Sie Ihre lokale Bibliothek, Ihre Lieblings-Streaming-Dienste und Radios zu jedem DLNA- oder AirPlay-Lautsprecher.';

  @override
  String get setupStart => 'Starten';

  @override
  String get setupLocalTitle => 'Lokale Bibliothek';

  @override
  String get setupLocalBody =>
      'Geben Sie den Pfad eines Ordners mit Ihren Audiodateien an (FLAC, MP3, AAC…). Sie können später in den Einstellungen weitere hinzufügen.';

  @override
  String get setupFolderPath => 'Ordnerpfad';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => 'Diesen Ordner hinzufügen';

  @override
  String get setupFolderAdded => 'Ordner hinzugefügt — Scan läuft…';

  @override
  String get setupFolderEmpty => 'Bitte geben Sie einen Ordnerpfad ein';

  @override
  String get setupUPnPTitle => 'UPnP/DLNA-Server';

  @override
  String get setupUPnPBody =>
      'Tune Server erkennt automatisch UPnP/DLNA-Server in Ihrem lokalen Netzwerk. Durchsuchen Sie deren Bibliotheken über Suche → Durchsuchen.';

  @override
  String get setupFeatureSsdp => 'Automatische SSDP-Erkennung';

  @override
  String get setupFeatureContentDir => 'ContentDirectory-Navigation';

  @override
  String get setupFeaturePlayback => 'Direkte DLNA-Dateiwiedergabe';

  @override
  String get setupFinish => 'Konfiguration abschließen';

  @override
  String get libraryPlayAlbum => 'Album abspielen';

  @override
  String get libraryPlayNext => 'Als Nächstes spielen';

  @override
  String radioFavExportDone(String path) {
    return 'CSV exportiert: $path';
  }

  @override
  String get radioFavExportError => 'Exportfehler';

  @override
  String get streamingViewAlbum => 'Album anzeigen';

  @override
  String get streamingLogoutContent => 'Ihr Konto wird getrennt.';

  @override
  String get streamingUrlCopied => 'URL in die Zwischenablage kopiert';

  @override
  String get streamingDeviceCodeHint =>
      'Rufen Sie diese URL auf und geben Sie den obigen Code ein:';

  @override
  String get searchHintFull => 'Künstler, Alben, Titel suchen…';

  @override
  String get browseNavError => 'Navigationsfehler';

  @override
  String get streamingCodeEntered => 'Code eingegeben';

  @override
  String get appleMusicAuthorize => 'Zugriff erlauben';

  @override
  String get smbNavTitle => 'SMB-Quelle';

  @override
  String get smbTitle => 'SMB-Verbindung';

  @override
  String get smbHostHint => 'IP-Adresse des SMB-Servers eingeben';

  @override
  String get smbHostLabel => 'IP-Adresse (z.B. 192.168.1.23)';

  @override
  String get smbUser => 'Benutzername';

  @override
  String get smbPassword => 'Passwort';

  @override
  String get smbConnect => 'Verbinden';

  @override
  String get smbSelectShare => 'Freigabe auswählen';

  @override
  String get smbBack => 'Zurück';

  @override
  String get smbManualHint =>
      'Freigaben konnten nicht automatisch aufgelistet werden.\nFreigabenamen manuell eingeben:';

  @override
  String get smbShareName => 'Freigabename (z.B. Share, Music)';

  @override
  String get smbScan => 'Scannen';

  @override
  String get smbScanning => 'Scan läuft…';

  @override
  String smbScanCount(int count) {
    return '$count Audiodateien gefunden';
  }

  @override
  String get smbDoneTitle => 'Indizierung abgeschlossen';

  @override
  String smbDoneBody(int count, String share) {
    return '$count Tracks importiert von $share';
  }

  @override
  String get smbAddAnother => 'Weitere Freigabe hinzufügen';

  @override
  String get settingsSmb => 'SMB / Samba-Quellen';

  @override
  String get settingsSmbDesc => 'Bibliotheken von Netzwerkfreigaben indizieren';

  @override
  String get podcastsTitle => 'Podcasts';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => 'Suchen';

  @override
  String get podcastsEmpty => 'Keine Podcasts';

  @override
  String get podcastsSearchHint => 'Podcast suchen…';

  @override
  String get podcastsNoEpisodes => 'Keine Episoden';

  @override
  String get navPodcasts => 'Podcasts';

  @override
  String get streamingConnectedSuccess => 'Verbunden!';

  @override
  String browseItemCount(int count) {
    return '$count Elemente';
  }

  @override
  String get settingsSources => 'Quellen & Geräte';

  @override
  String get settingsSourcesDesc => 'UPnP-Server, DLNA-Renderer';

  @override
  String get sourcesTitle => 'Quellen & Geräte';

  @override
  String get sourcesServersSection => 'UPnP-Inhaltsserver';

  @override
  String get sourcesRenderersSection => 'DLNA-Renderer';

  @override
  String get sourcesNoDevices => 'Kein Gerät gefunden';

  @override
  String get sourcesTypeServer => 'Server';

  @override
  String get sourcesTypeRenderer => 'Renderer';

  @override
  String get sourcesAvailable => 'Verfügbar';

  @override
  String get sourcesUnavailable => 'Offline';

  @override
  String get sourcesIndexBtn => 'Bibliothek indizieren';

  @override
  String get sourcesRescanBtn => 'Erneut scannen';

  @override
  String get sourcesForget => 'Vergessen';

  @override
  String get sourcesAddManually => 'Manuell hinzufügen';

  @override
  String get sourcesAddTitle => 'Manueller Scan';

  @override
  String get sourcesIpLabel => 'IP-Adresse';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => 'Port';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => 'Suche läuft…';

  @override
  String get sourcesNotFound => 'Kein UPnP-Gerät unter dieser Adresse gefunden';

  @override
  String get zonesMultiRoom => 'Multi-Room';

  @override
  String get zonesCreateGroup => 'Gruppe erstellen';

  @override
  String get zonesGroupLeader => 'Leader';

  @override
  String get zonesGroupFollower => 'Follower';

  @override
  String get zonesGroupDissolve => 'Gruppe auflösen';

  @override
  String get zonesGroupSyncDelay => 'Sync-Verzögerung';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => 'Zonen auswählen';

  @override
  String get zonesGroupSelectLeader => 'Leader auswählen';

  @override
  String get zonesGroupNoZones => 'Keine aktiven Gruppen';

  @override
  String get zonesGroupNeedTwo => 'Mindestens 2 Zonen auswählen';

  @override
  String get zonesGroupCreated => 'Gruppe erstellt';

  @override
  String get zonesGroupDissolved => 'Gruppe aufgelöst';

  @override
  String get metadataSectionEnrich => 'Anreichern';

  @override
  String get metadataSectionDuplicates => 'Duplikate';

  @override
  String get metadataSectionCorrect => 'Korrigieren';

  @override
  String get metadataFilterAll => 'Alle';

  @override
  String get metadataFilterMissingCover => 'Fehlende Cover';

  @override
  String get metadataFilterMissingGenre => 'Fehlendes Genre';

  @override
  String get metadataFilterMissingYear => 'Fehlendes Jahr';

  @override
  String get metadataFilterMissingArtist => 'Fehlender Künstler';

  @override
  String get metadataFilterDoubtful => 'Zweifelhaft';

  @override
  String get metadataSearchHint => 'Alben suchen…';

  @override
  String get metadataArtistFilter => 'Künstler';

  @override
  String get metadataGenreFilter => 'Genre';

  @override
  String get metadataAllArtists => 'Alle Künstler';

  @override
  String get metadataAllGenres => 'Alle Genres';

  @override
  String get metadataNoAlbums => 'Keine passenden Alben';

  @override
  String get metadataEditAlbum => 'Album bearbeiten';

  @override
  String get metadataSaveChanges => 'Speichern';

  @override
  String get metadataWriteTags => 'Tags schreiben';

  @override
  String metadataWriteTagsSuccess(int count) {
    return 'Tags geschrieben: $count Dateien';
  }

  @override
  String get metadataMergeGroup => 'Zusammenführen';

  @override
  String metadataMergeConfirm(int count) {
    return 'Diese $count Alben zusammenführen? Das Album mit den meisten Tracks wird beibehalten.';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return 'Zusammengeführt: $moved Tracks verschoben, $total gesamt';
  }

  @override
  String get metadataUploadCover => 'Cover hochladen';

  @override
  String get metadataCoverUploaded => 'Cover hochgeladen';

  @override
  String get metadataAlbumSaved => 'Album gespeichert';

  @override
  String metadataDupAlbums(int count) {
    return '$count doppelte Alben';
  }

  @override
  String get metadataDoubtfulReasons => 'Probleme';

  @override
  String get metadataArtistField => 'Künstler';

  @override
  String get metadataAlbumField => 'Album';

  @override
  String get metadataGenreField => 'Genre';

  @override
  String get metadataYearField => 'Jahr';

  @override
  String metadataTracksCount(int count) {
    return '$count Tracks';
  }

  @override
  String get stereoPairsTitle => 'Stereopaare';

  @override
  String get stereoPairCreate => 'Stereopaar erstellen';

  @override
  String get stereoPairName => 'Paarname';

  @override
  String get stereoPairNameHint => 'z.B. Wohnzimmer Stereo';

  @override
  String get stereoPairLeft => 'Links (L)';

  @override
  String get stereoPairRight => 'Rechts (R)';

  @override
  String get stereoPairSelectDevice => 'Gerät auswählen';

  @override
  String get stereoPairNone => 'Keine Stereopaare';

  @override
  String get stereoPairCreated => 'Stereopaar erstellt';

  @override
  String get stereoPairDissolved => 'Stereopaar aufgelöst';

  @override
  String get stereoPairDissolve => 'Auflösen';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => 'Aktivieren';

  @override
  String get streamingDisable => 'Deaktivieren';

  @override
  String get streamingEnabled => 'Dienst aktiviert';

  @override
  String get streamingDisabled => 'Dienst deaktiviert';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Tune!';

  @override
  String get onboardingWelcomeBody =>
      'Ihr eingebetteter Multiroom-Musikserver. Lassen Sie uns Ihre Installation in wenigen Schritten einrichten.';

  @override
  String get onboardingWelcomeStart => 'Starten';

  @override
  String get onboardingConfigTitle => 'Konfiguration';

  @override
  String get onboardingConfigBody =>
      'Geben Sie einen Ordner mit Ihren Audiodateien an oder verbinden Sie sich mit einem entfernten Tune-Server.';

  @override
  String get onboardingConfigModeLocal => 'Eingebetteter Server';

  @override
  String get onboardingConfigModeRemote => 'Remote-Server';

  @override
  String get onboardingZoneTitle => 'Zone erstellen';

  @override
  String get onboardingZoneBody =>
      'Die folgenden Geräte wurden in Ihrem Netzwerk entdeckt. Tippen Sie auf eines, um Ihre erste Audiozone zu erstellen.';

  @override
  String get onboardingZoneEmpty =>
      'Noch keine Geräte entdeckt. Sie können später weitere hinzufügen.';

  @override
  String onboardingZoneCreated(String name) {
    return 'Zone erstellt: $name';
  }

  @override
  String get onboardingDoneTitle => 'Fertig!';

  @override
  String get onboardingDoneBody =>
      'Ihre Einrichtung ist bereit. Genießen Sie Ihre Musik!';

  @override
  String get onboardingDoneButton => 'Zum Dashboard';

  @override
  String get artistBio => 'Biografie';

  @override
  String get artistAnecdotes => 'Anekdoten';

  @override
  String get artistSimilarArtists => 'Ähnliche Künstler';

  @override
  String get artistMembers => 'Mitglieder';

  @override
  String get artistDiscography => 'Diskografie';

  @override
  String get artistEnriching => 'Anreicherung läuft…';

  @override
  String get artistGenres => 'Genres';

  @override
  String get libraryShuffleAll => 'Alle zufällig wiedergeben';

  @override
  String get librarySortBy => 'Sortieren nach';

  @override
  String get librarySortTitle => 'Titel';

  @override
  String get librarySortArtist => 'Künstler';

  @override
  String get librarySortYear => 'Jahr';

  @override
  String get librarySortOriginalYear => 'Originaljahr';

  @override
  String get librarySortAddedDate => 'Hinzugefügt am';

  @override
  String get librarySortAscending => 'Aufsteigend';

  @override
  String get librarySortDescending => 'Absteigend';

  @override
  String get addFavorite => 'Zu Favoriten hinzufügen';

  @override
  String get addFolder => 'Ordner hinzufügen';

  @override
  String get addThisFolder => 'Diesen Ordner hinzufügen';

  @override
  String get addToPlaylist => 'Zu einer Playlist hinzufügen';

  @override
  String get addedToPlaylist => 'Zur Playlist hinzugefügt';

  @override
  String get audioOutput => 'Audioausgang';

  @override
  String get audioOutputDesc =>
      'Jede Serverzone ist ein Ausgang (lokales ALSA, Diretta-Renderer…). Wähle die Zone zum Abspielen.';

  @override
  String get authorizeInBrowser => 'Autorisiere den Zugriff im Browser:';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get connect => 'Verbinden';

  @override
  String get connected => 'Verbunden';

  @override
  String get cover => 'Cover';

  @override
  String get create => 'Erstellen';

  @override
  String get createPlaylist => 'Playlist erstellen';

  @override
  String get delete => 'Löschen';

  @override
  String get deletePlaylist => 'Playlist löschen';

  @override
  String get deletePlaylistConfirm => 'Diese Playlist löschen?';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get disconnected => 'Nicht verbunden';

  @override
  String get done => 'Fertig';

  @override
  String get dynamicPlaylists => 'Dynamische Playlists';

  @override
  String get dynamicTag => 'Dynamisch';

  @override
  String errorWith(String msg) {
    return 'Fehler: $msg';
  }

  @override
  String favError(String msg) {
    return 'Favorit fehlgeschlagen: $msg';
  }

  @override
  String get favoritesTitle => 'Favoriten';

  @override
  String get filterAll => 'Alle';

  @override
  String get freqLimit => 'Frequenzgrenze';

  @override
  String get gapless => 'Lückenlose Wiedergabe';

  @override
  String get gaplessDesc =>
      'Deaktivieren bei Rauschen / Aussetzern zwischen Titeln auf diesem Renderer.';

  @override
  String get host => 'Host';

  @override
  String get language => 'Sprache';

  @override
  String get loading => 'Lädt…';

  @override
  String get localLibrary => 'Lokale Bibliothek';

  @override
  String get localLibraryDesc => 'Ordner, die der Server nach Musik durchsucht';

  @override
  String get logIn => 'Anmelden';

  @override
  String get logOut => 'Abmelden';

  @override
  String loginTo(String service) {
    return 'Bei $service anmelden';
  }

  @override
  String get maxBitDepth => 'Max. Bit-Tiefe';

  @override
  String get maxFrequency => 'Max. Frequenz';

  @override
  String maxTracks(int n) {
    return 'max. $n';
  }

  @override
  String get metadataFields => 'Metadatenfelder';

  @override
  String get metadataFieldsDesc => 'Für die lokale Bibliothek angezeigte Infos';

  @override
  String get metadataSaved => 'Metadaten gespeichert';

  @override
  String get musicFolders => 'Gescannte Ordner';

  @override
  String get navFavorites => 'Favoriten';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get newPlaylist => 'Neue Playlist';

  @override
  String get noFavAlbums => 'Keine Lieblingsalben';

  @override
  String get noFavArtists => 'Keine Lieblingskünstler';

  @override
  String get noFavTracks => 'Keine Lieblingstitel';

  @override
  String get noFolders => 'Kein Ordner konfiguriert';

  @override
  String get noLimit => 'Ohne Limit';

  @override
  String get noPlaylists => 'Keine Playlist';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get noService => 'Kein Dienst';

  @override
  String get noTracks => 'Keine Titel';

  @override
  String get noZones => 'Keine Zone verfügbar';

  @override
  String get notConnected => 'Server in den Einstellungen einrichten';

  @override
  String get nothingPlaying => 'Nichts wird abgespielt';

  @override
  String get openAuthPage => 'Autorisierungsseite öffnen';

  @override
  String get password => 'Passwort';

  @override
  String get pickFolder => 'Ordner auswählen';

  @override
  String get playAll => 'Alle abspielen';

  @override
  String get playlistCreated => 'Playlist erstellt';

  @override
  String get playlistDeleted => 'Playlist gelöscht';

  @override
  String get playlistsTitle => 'Playlists';

  @override
  String get port => 'Port';

  @override
  String get qualityCd => 'CD (44.1 kHz / 16 Bit)';

  @override
  String get qualityHires => 'Hi-Res (bis 192 kHz)';

  @override
  String get qualityMax => 'Maximum';

  @override
  String get removeFavorite => 'Aus Favoriten entfernen';

  @override
  String get removeFromPlaylist => 'Aus Playlist entfernen';

  @override
  String get runScan => 'Bibliothek scannen';

  @override
  String get scanning => 'Scannt…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · deine Bibliothek';

  @override
  String get searchEmptyTitle =>
      'Suche einen Titel, ein Album oder einen Künstler';

  @override
  String get searchTitle => 'Suche';

  @override
  String get sectionAlbums => 'Alben';

  @override
  String get sectionArtists => 'Künstler';

  @override
  String get sectionPlaylists => 'Playlists';

  @override
  String get sectionTracks => 'Titel';

  @override
  String get server => 'Server';

  @override
  String get sourceLibrary => 'Bibliothek';

  @override
  String get streamingQuality => 'Streaming-Qualität';

  @override
  String get streamingQualityDesc =>
      'Begrenzt die von den Diensten angeforderte Frequenz / Auflösung (Qobuz, Tidal…).';

  @override
  String get streamingServices => 'Streaming-Dienste';

  @override
  String get systemLanguage => 'System';

  @override
  String get trackRemoved => 'Aus Playlist entfernt';

  @override
  String tracksCount(int n) {
    return '$n Titel';
  }

  @override
  String get username => 'Benutzername';

  @override
  String get visualizer => 'Visualisierung';

  @override
  String get licenseSessionConflictTitle =>
      'Lizenz auf einem anderen Server aktiv';

  @override
  String get licenseSessionConflictBody =>
      'Ihre Tune-Lizenz wird bereits auf einem anderen Ihrer Server verwendet. Dieser Server wechselt automatisch zurück zu Premium, einige Minuten nachdem der andere gestoppt wurde.';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'Ihre Tune-Lizenz ist auf „$server“ aktiv. Dieser Server wechselt automatisch zurück zu Premium, einige Minuten nachdem der andere gestoppt wurde.';
  }

  @override
  String cfgSaveError(String detail) {
    return 'Speichern fehlgeschlagen: $detail';
  }

  @override
  String get cfgReload => 'Neu laden';

  @override
  String get cfgFieldsLoadError => 'Felder konnten nicht geladen werden';

  @override
  String get cfgFieldsNone => 'Keine Felder verfügbar';

  @override
  String get cfgFieldsHint =>
      'Wähle, welche Metadatenfelder im Titel-Editor angezeigt werden.';

  @override
  String get cfgMetaCompleteness => 'Vollständigkeit der Metadaten';

  @override
  String get cfgMetaEnrichMusicBrainz => 'Mit MusicBrainz anreichern';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'MusicBrainz-Anreicherung';

  @override
  String get cfgMetaFixYearsTidal => 'Jahre korrigieren (TIDAL)';

  @override
  String get cfgMetaFixYearsDiscogs => 'Jahre korrigieren (Discogs)';

  @override
  String get cfgMetaFixGenres => 'Genres korrigieren';

  @override
  String get cfgMetaAutoFixAlbums => 'Alben automatisch korrigieren';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ausstehende Vorschläge',
      one: '1 ausstehender Vorschlag',
      zero: 'Keine ausstehenden Vorschläge',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => 'Alle annehmen';

  @override
  String get cfgMetaSuggestions => 'Vorschläge';

  @override
  String get cfgMetaScanDuplicates => 'Nach Duplikaten suchen';

  @override
  String get cfgMetaAutoMerge => 'Automatisch zusammenführen';

  @override
  String get cfgMetaMergeDuplicatesTask => 'Duplikate zusammenführen';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$count doppelte Alben ($groups Gruppen)',
      one: '$count doppelte Alben (1 Gruppe)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… und $count weitere Gruppen',
      one: '… und 1 weitere Gruppe',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => 'Letztes Ergebnis';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct % vollständig';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label: Fehler — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label: $count angenommen';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label: $fixed/$total korrigiert';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label: $fixed korrigiert';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label: $total verarbeitet';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label: abgeschlossen';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return 'Fehler beim Schreiben der Tags: $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return 'Hochladen fehlgeschlagen: $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alben zusammenführen?',
      one: '1 Album zusammenführen?',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody =>
      'Das Album mit den meisten Titeln bleibt erhalten, die anderen werden gelöscht.';

  @override
  String cfgMetaMergeError(String detail) {
    return 'Zusammenführen fehlgeschlagen: $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => 'Statistiken nicht verfügbar';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alben',
      one: '1 Album',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… und $count weitere Alben (zum Eingrenzen filtern)',
      one: '… und 1 weiteres Album (zum Eingrenzen filtern)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count Titel';
  }

  @override
  String get cfgMetaReasonArtistUppercase => 'Künstler in Großbuchstaben';

  @override
  String get cfgMetaReasonArtistPlaceholder => 'Platzhalter-Künstler';

  @override
  String get cfgMetaReasonArtistHasYear => 'Künstler = Ordner';

  @override
  String get cfgMetaReasonGenrePlaceholder => 'Platzhalter-Genre';

  @override
  String get cfgMetaReasonYearSuspicious => 'Verdächtiges Jahr';

  @override
  String get cfgMetaReasonTitleUppercase => 'Titel in Großbuchstaben';

  @override
  String get cfgMetaReasonArtistMismatch => 'Abweichender Künstler';

  @override
  String get cfgSmbNotConnected =>
      'Nicht mit einem entfernten Server verbunden';

  @override
  String cfgSmbMountTitle(String name) {
    return '$name einbinden';
  }

  @override
  String get cfgSmbMount => 'Einbinden';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name eingebunden';
  }

  @override
  String get cfgSmbTitle => 'Netzwerkfreigaben (SMB)';

  @override
  String get cfgSmbSearching => 'Suche nach SMB-Freigaben…';

  @override
  String get cfgSmbNone => 'Keine SMB-Freigaben gefunden';

  @override
  String get cfgSmbSaveCredentials => 'Zugangsdaten speichern';

  @override
  String get cfgUnknown => 'Unbekannt';

  @override
  String get cfgEqTitle => 'Equalizer';

  @override
  String get cfgEqTabAssistant => 'Assistent';

  @override
  String get cfgEqTabExpert => 'Experte';

  @override
  String cfgEqError(String detail) {
    return 'EQ-Fehler: $detail';
  }

  @override
  String get cfgEqPresetFlat => 'Linear';

  @override
  String get cfgEqPresetBassBoost => 'Bass-Boost';

  @override
  String get cfgEqPresetClassical => 'Klassik';

  @override
  String get cfgEqPresetVocal => 'Gesang';

  @override
  String get cfgNotConnectedToServer => 'Nicht mit dem Server verbunden';

  @override
  String get cfgCredentialsRequired =>
      'Benutzername und Passwort sind erforderlich';

  @override
  String cfgServiceConnected(String service) {
    return '$service verbunden.';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service getrennt.';
  }

  @override
  String get cfgLastfmTitle => 'Last.fm-Scrobbling';

  @override
  String get cfgLastfmDesc =>
      'Übertrage deinen Hörverlauf an Last.fm. Titel werden automatisch gescrobbelt, wenn sie in einer beliebigen Zone gespielt werden.';

  @override
  String get cfgDisconnecting => 'Trennen…';

  @override
  String get cfgConnectHeader => 'VERBINDEN';

  @override
  String get cfgConnecting => 'Verbinden…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Scrobbles',
      one: '1 Scrobble',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return 'Zuletzt: $date';
  }

  @override
  String get cfgTokenRequired => 'Bitte gib dein Benutzer-Token ein';

  @override
  String get cfgScrobblerUnavailable => 'Scrobbler nicht verfügbar';

  @override
  String cfgConnectedAs(String name) {
    return 'Verbunden als $name';
  }

  @override
  String get cfgListenbrainzDesc =>
      'Übertrage deinen Hörverlauf an ListenBrainz. Dein Benutzer-Token findest du unter listenbrainz.org/settings.';

  @override
  String get cfgUserToken => 'Benutzer-Token';

  @override
  String get cfgValidating => 'Wird geprüft…';

  @override
  String get cfgSaveAndConnect => 'Speichern & verbinden';

  @override
  String get cfgScrobbleAuto => 'Titel werden automatisch gescrobbelt';

  @override
  String cfgConfigExported(String path) {
    return 'Konfiguration exportiert: $path';
  }

  @override
  String get cfgConfigImported => 'Konfiguration erfolgreich importiert';

  @override
  String cfgImportError(String detail) {
    return 'Import fehlgeschlagen: $detail';
  }

  @override
  String get cfgConfigExportDesc =>
      'Speichert die Serverkonfiguration als JSON-Datei.';

  @override
  String get cfgConfigExportJson => 'JSON exportieren';

  @override
  String get cfgConfigImportDesc =>
      'Stellt eine Konfiguration aus einer JSON-Datei wieder her.';

  @override
  String get cfgChooseFile => 'Datei auswählen';

  @override
  String get cfgDbNoServer => 'Kein Server verbunden.';

  @override
  String cfgDbExportOk(String size, String path) {
    return 'Export erfolgreich: $size MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => 'Dateipfad nicht zugänglich.';

  @override
  String get cfgDbImportConfirmTitle => 'Import bestätigen';

  @override
  String cfgDbImportConfirmBody(String name) {
    return 'Die Serverdatenbank durch „$name“ ersetzen?\n\nEine Sicherungskopie wird automatisch erstellt. Der Server muss nach dem Import neu gestartet werden.';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return 'Import erfolgreich: $size MB ($engine).\nStarte den Server neu, um die Änderungen zu übernehmen.';
  }

  @override
  String get cfgDbTitle => 'Datenbank';

  @override
  String get cfgDbIntro =>
      'Exportiere oder importiere die Datenbank des verbundenen Servers.\nSQLite: .db-Datei. PostgreSQL: SQL-Dump.';

  @override
  String get cfgDbExporting => 'Export läuft…';

  @override
  String get cfgDbExportBtn => 'Datenbank exportieren';

  @override
  String get cfgDbImporting => 'Import läuft…';

  @override
  String get cfgDbImportBtn => 'Datei importieren';

  @override
  String get cfgDbFooter =>
      'Starte den Server nach einem Import neu, um die Änderungen zu übernehmen. Vor dem Ersetzen wird automatisch eine Sicherungskopie erstellt.';

  @override
  String cfgStatusUnavailable(String detail) {
    return 'Status nicht verfügbar: $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune erscheint im lokalen Netzwerk als Spotify Connect-Empfänger. Wähle in der Spotify-App „Tune (…)“ in der Geräteliste. Auf Client-Seite ist ein Spotify Premium-Konto erforderlich.';

  @override
  String get cfgSpotifyNoLibrespot => 'librespot auf dem Server nicht gefunden';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      'Installiere Tune Server aus dem offiziellen Tarball/ZIP neu, damit die Binärdatei enthalten ist, oder installiere sie separat (apt install librespot / brew install librespot).';

  @override
  String get cfgTargetZone => 'Zielzone';

  @override
  String get cfgDeviceName => 'Gerätename';

  @override
  String get cfgPlaying => 'Wiedergabe läuft';

  @override
  String get cfgNetDiagTitle => 'Netzwerkdiagnose';

  @override
  String get cfgNetSsdpActive => 'SSDP aktiv';

  @override
  String get cfgNetMulticastReachable => 'Multicast erreichbar';

  @override
  String get cfgError => 'Fehler';

  @override
  String get cfgNetResolution => 'Auflösung';

  @override
  String get cfgNetLatency => 'Latenz';

  @override
  String get cfgNetPublicIp => 'Öffentliche IP';

  @override
  String get cfgNetInterfaces => 'NETZWERKSCHNITTSTELLEN';

  @override
  String get cfgStatusWarning => 'Warnung';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total Alben';
  }

  @override
  String get libNoCollectionsYet => 'Noch keine Sammlungen';

  @override
  String libRatingError(String error) {
    return 'Fehler bei der Bewertung: $error';
  }

  @override
  String libDisc(int disc) {
    return 'CD $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return 'CD $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => 'Schnell-Favorit';

  @override
  String get libAddToCollection => 'Zu Sammlung hinzufügen';

  @override
  String get libAlbumNotes => 'Albuminfos';

  @override
  String get libCredits => 'Mitwirkende';

  @override
  String get libNoCredits => 'Keine Mitwirkenden';

  @override
  String get libNoAlbumNotes => 'Keine Albuminfos verfügbar';

  @override
  String get libNoNotes => 'Keine Infos verfügbar';

  @override
  String get libSourceCommunity => 'Tune-Community';

  @override
  String libBioSource(String source) {
    return 'Quelle: $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return 'Quelle: $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied =>
      'Zugriff auf die Apple Music-Mediathek verweigert.';

  @override
  String get libAppleMusicPermissionRefused =>
      'Berechtigung verweigert. Aktivieren Sie den Zugriff unter Einstellungen > Datenschutz > Medien & Apple Music.';

  @override
  String get libUnknownError => 'Unbekannter Fehler';

  @override
  String get libAppleMusicAccessTitle => 'Zugriff auf Apple Music';

  @override
  String get libAppleMusicAccessBody =>
      'Erlauben Sie den Zugriff auf Ihre Mediathek, um Ihre Apple Music-Titel abzuspielen.';

  @override
  String get libAppleMusicEmpty => 'Apple Music-Mediathek ist leer';

  @override
  String get libReportImageTitle => 'Bild melden';

  @override
  String get libReportImageBody =>
      'Dieses Künstlerbild als falsch melden? Der Server ersetzt es bei der nächsten Anreicherung.';

  @override
  String get libReportAction => 'Melden';

  @override
  String get libImageReported => 'Bild gemeldet';

  @override
  String libServiceAlbums(String service) {
    return '$service-Alben';
  }

  @override
  String libTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel',
      one: '1 Titel',
    );
    return '$_temp0';
  }

  @override
  String get libDuplicateScanner => 'Duplikatsuche';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$groups Duplikatgruppen gefunden',
      one: '1 Duplikatgruppe gefunden',
    );
    return '$_temp0 ($tracks Titel insgesamt)';
  }

  @override
  String get libFindDuplicatesTitle => 'Doppelte Titel finden';

  @override
  String get libFindDuplicatesBody =>
      'Vergleicht Prüfsummen der Audioinhalte, um identische Titel in Ihrer Bibliothek zu finden.';

  @override
  String get libStartScan => 'Suche starten';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total Titel ($percent %)';
  }

  @override
  String get libLoadingTracks => 'Titel werden geladen…';

  @override
  String get libNoDuplicatesFound => 'Keine Duplikate gefunden';

  @override
  String get libLibraryClean => 'Ihre Bibliothek ist sauber.';

  @override
  String get libScanAgain => 'Erneut suchen';

  @override
  String get libScanFailed => 'Suche fehlgeschlagen';

  @override
  String get libTrackNumberField => 'Titel-Nr.';

  @override
  String get libDiscNumberField => 'CD-Nr.';

  @override
  String get libExtendedMetadata => 'Erweiterte Metadaten';

  @override
  String get libGenreTreeSaved => 'Genre-Baum gespeichert';

  @override
  String libSaveError(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get libGenreTree => 'Genre-Baum';

  @override
  String get libAddRootGenre => 'Hauptgenre hinzufügen';

  @override
  String get libGenreTreeRequiresRemote =>
      'Der Genre-Baum erfordert eine Verbindung zu einem entfernten Server.';

  @override
  String get libNoGenreHierarchy => 'Keine Genre-Hierarchie definiert';

  @override
  String libAddSubGenreTo(String parent) {
    return 'Subgenre zu „$parent“ hinzufügen';
  }

  @override
  String get libGenreName => 'Genrename';

  @override
  String libSubGenreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Subgenres',
      one: '1 Subgenre',
    );
    return '$_temp0';
  }

  @override
  String get libAddSubGenre => 'Subgenre hinzufügen';

  @override
  String get libRemove => 'Entfernen';

  @override
  String libRemoveNamedConfirm(String name) {
    return '„$name“ entfernen?';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dadurch werden auch alle $count Subgenres entfernt.',
      one: 'Dadurch wird auch sein Subgenre entfernt.',
    );
    return '$_temp0';
  }

  @override
  String get libRemoveGenreBody => 'Dieses Genre wird aus dem Baum entfernt.';

  @override
  String libAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alben',
      one: '1 Album',
    );
    return '$_temp0';
  }

  @override
  String get libNoTracksForFilter => 'Keine Titel für diesen Filter';

  @override
  String get libQualityLossless => 'Verlustfrei';

  @override
  String get libQualityLossy => 'Verlustbehaftet';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total Titel';
  }

  @override
  String get libNewCollection => 'Neue Sammlung';

  @override
  String get libCollectionName => 'Name der Sammlung';

  @override
  String libCreateError(String error) {
    return 'Fehler beim Erstellen: $error';
  }

  @override
  String libDeleteError(String error) {
    return 'Fehler beim Löschen: $error';
  }

  @override
  String get libCollectionsTitle => 'Sammlungen';

  @override
  String get libCollectionsLoadFailed =>
      'Sammlungen konnten nicht geladen werden';

  @override
  String get libDeleteCollectionTitle => 'Sammlung löschen?';

  @override
  String libDeleteCollectionBody(String name) {
    return '„$name“ wird dauerhaft gelöscht.';
  }

  @override
  String get libNoAlbumsInCollection => 'Keine Alben in dieser Sammlung';

  @override
  String get libDeleteConfirmTitle => 'Löschen?';

  @override
  String get libDeleteSmartCollectionBody =>
      'Diese intelligente Sammlung wird dauerhaft gelöscht.';

  @override
  String get libNoRules => 'keine Regeln';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return 'Mitwirkung: $role=$artist';
  }

  @override
  String get libAnd => 'UND';

  @override
  String get libOr => 'ODER';

  @override
  String get libSmartCollections => 'Intelligente Sammlungen';

  @override
  String get libNewSmartCollection => 'Neue intelligente Sammlung';

  @override
  String get libNoSmartCollections => 'Keine intelligenten Sammlungen';

  @override
  String get libSmartCollectionsSeedHint =>
      'Der Server legt beim ersten Start normalerweise 7 Standardsammlungen an.';

  @override
  String get libCreateFirstSmartCollection =>
      'Meine erste intelligente Sammlung erstellen';

  @override
  String get libNoMatchingAlbums => 'Keine passenden Alben';

  @override
  String get libSmartCreditsHint =>
      'Für Regeln auf Basis von Mitwirkenden (engineer, performer, …) reichern Sie die Bibliothek zuerst in den Einstellungen an.';

  @override
  String get libFieldSampleRate => 'Abtastrate';

  @override
  String get libFieldBitDepth => 'Bittiefe';

  @override
  String get libFieldTrackCount => 'Anzahl Titel';

  @override
  String get libFieldFormat => 'Format';

  @override
  String get libFieldLabel => 'Label';

  @override
  String get libFieldAlbumTitle => 'Albumtitel';

  @override
  String get libFieldSource => 'Quelle';

  @override
  String get libFieldCredit => 'Mitwirkung';

  @override
  String get libFieldPlayCount => 'Wiedergaben';

  @override
  String get libFieldLastPlayed => 'Zuletzt gespielt';

  @override
  String get libOpBetween => 'zwischen';

  @override
  String get libOpContains => 'enthält';

  @override
  String get libOpStartsWith => 'beginnt mit';

  @override
  String get libOpEmpty => 'leer';

  @override
  String get libOpNotEmpty => 'nicht leer';

  @override
  String get libOpNever => 'nie';

  @override
  String get libOpAfter => 'nach';

  @override
  String get libOpBefore => 'vor';

  @override
  String get libNameLabel => 'Name';

  @override
  String get libMatchMode => 'Verknüpfung';

  @override
  String get libMatchAll => 'Alle Regeln (UND)';

  @override
  String get libMatchAny => 'Mindestens eine (ODER)';

  @override
  String get libAddRule => 'Regel hinzufügen';

  @override
  String get libMatchingAlbumsPending => '… passende Alben';

  @override
  String libMatchingAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passende Alben',
      one: '1 passendes Album',
    );
    return '$_temp0';
  }

  @override
  String get libTimestampHint => 'now-30d oder 2024-01-01';

  @override
  String get libValueHint => 'Wert';

  @override
  String get libMinHint => 'min';

  @override
  String get libMaxHint => 'max';

  @override
  String get libCommaSeparatedHint => 'durch Kommas getrennte Werte';

  @override
  String get libCreditRoleHint => 'Rolle (engineer, performer, …)';

  @override
  String get libCreditArtistHint => 'Künstler (Rudy Van Gelder, …)';

  @override
  String get libCreditInstrumentHint => 'Instrument (Piano, …) — optional';

  @override
  String get libDirectories => 'Verzeichnisse';

  @override
  String get libLoadError => 'Fehler beim Laden';

  @override
  String get libNoFolders => 'Keine Ordner';

  @override
  String get libAddFoldersInSettings =>
      'Fügen Sie Musikordner in den Einstellungen hinzu';

  @override
  String get libFoldersHeader => 'Ordner';

  @override
  String libTracksHeaderCount(int count) {
    return 'Titel ($count)';
  }

  @override
  String get libPlayFromHere => 'Ab hier abspielen';

  @override
  String get libTags => 'Tags';

  @override
  String get libNewTagHint => 'Neuer Tag…';

  @override
  String get libJustNow => 'Gerade eben';

  @override
  String libMinutesAgo(int count) {
    return 'Vor $count Min.';
  }

  @override
  String libHoursAgo(int count) {
    return 'Vor $count Std.';
  }

  @override
  String get libYesterday => 'Gestern';

  @override
  String libDaysAgo(int count) {
    return 'Vor $count T.';
  }

  @override
  String get libNowListening => 'Wird gerade gehört';

  @override
  String get libContinueListening => 'Weiterhören';

  @override
  String get libRecentlyAdded => 'Kürzlich hinzugefügt';

  @override
  String get libTopTracks => 'Meistgehörte Titel';

  @override
  String get libTopArtists => 'Meistgehörte Künstler';

  @override
  String get libRecommendations => 'Empfehlungen';

  @override
  String get libSourceLocal => 'Lokal';

  @override
  String get libFieldDuration => 'Dauer';

  @override
  String get libFilter => 'Filtern';

  @override
  String get libRefreshAll => 'Alle aktualisieren';

  @override
  String get libPodcastsSubscribed => 'Abonniert';

  @override
  String get libNoSubscriptions => 'Noch keine Abonnements';

  @override
  String get libSubscribeRssFeed => 'RSS-Feed abonnieren';

  @override
  String get libUnknown => 'Unbekannt';

  @override
  String get libUnsubscribeTitle => 'Abo beenden?';

  @override
  String libUnsubscribeBody(String name) {
    return 'Abo von „$name“ beenden?';
  }

  @override
  String get libUnsubscribe => 'Abo beenden';

  @override
  String libEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Folgen',
      one: '1 Folge',
    );
    return '$_temp0';
  }

  @override
  String get libSubscribeToPodcast => 'Podcast abonnieren';

  @override
  String get libRssFeedUrl => 'RSS-Feed-URL';

  @override
  String get libSubscribe => 'Abonnieren';

  @override
  String get libSubscribed => 'Abonniert.';

  @override
  String libSubscribeError(String error) {
    return 'Fehler beim Abonnieren: $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return 'Fehler beim Beenden des Abos: $error';
  }

  @override
  String get libPodcastRefreshed => 'Podcast aktualisiert.';

  @override
  String libRefreshError(String error) {
    return 'Fehler beim Aktualisieren: $error';
  }

  @override
  String get libAllPodcastsRefreshed => 'Alle Podcasts aktualisiert.';

  @override
  String get libToday => 'Heute';

  @override
  String get miscNavFolders => 'Ordner';

  @override
  String get miscNavCollections => 'Sammlungen';

  @override
  String get miscNavSmartCollections => 'Intelligente Sammlungen';

  @override
  String get miscNavDjMode => 'DJ-Modus';

  @override
  String get miscNavPartyMode => 'Party-Modus';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => 'Party';

  @override
  String get miscNavSmartPlaylists => 'Intelligente Playlists';

  @override
  String get miscNavAlarms => 'Wecker';

  @override
  String get miscNavGenreTree => 'Genre-Baum';

  @override
  String get miscNavDashboard => 'Dashboard';

  @override
  String get miscNavDiagnostics => 'Diagnose';

  @override
  String get miscNavAdmin => 'Verwaltung';

  @override
  String get miscNavMore => 'Mehr';

  @override
  String get miscNextTrack => 'Nächster Titel';

  @override
  String get miscPreviousTrack => 'Vorheriger Titel';

  @override
  String get miscUnknownError => 'Unbekannter Fehler';

  @override
  String get miscAuthorizationCode => 'Autorisierungscode';

  @override
  String get miscWaitingForValidation => 'Warte auf Bestätigung…';

  @override
  String miscCodeValue(String code) {
    return 'Code: $code';
  }

  @override
  String get miscQualityHigh => 'Hoch';

  @override
  String get miscExplore => 'Entdecken';

  @override
  String get miscFavoriteAlbums => 'Lieblingsalben';

  @override
  String get miscFavoriteTracks => 'Lieblingstitel';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Titel ansehen',
      one: '1 Titel ansehen',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => 'Meine Playlists';

  @override
  String get miscNoApiClient => 'Kein API-Client';

  @override
  String miscServiceFavorites(String service) {
    return '$service-Favoriten';
  }

  @override
  String miscPlayAllCount(int count) {
    return 'Alle abspielen ($count)';
  }

  @override
  String get miscServiceNotFound => 'Dienst nicht gefunden';

  @override
  String get miscYtHome => 'Start';

  @override
  String get miscYtCharts => 'Charts';

  @override
  String get miscYtMoods => 'Stimmungen';

  @override
  String get miscNoData => 'Keine Daten';

  @override
  String get miscNoContentAvailable => 'Keine Inhalte verfügbar';

  @override
  String get miscNoChartsAvailable => 'Keine Charts verfügbar';

  @override
  String get miscNoMoodsAvailable => 'Keine Stimmungen verfügbar';

  @override
  String get miscDashTotalPlays => 'Wiedergaben gesamt';

  @override
  String get miscDashListeningTime => 'Hördauer';

  @override
  String get miscDashUniqueTracks => 'Verschiedene Titel';

  @override
  String get miscDashUniqueArtists => 'Verschiedene Künstler';

  @override
  String get miscDashTopArtists => 'TOP-KÜNSTLER';

  @override
  String get miscDashTopAlbums => 'TOP-ALBEN';

  @override
  String get miscDashTopTracks => 'TOP-TITEL';

  @override
  String get miscDashListeningByHour => 'HÖREN NACH STUNDE';

  @override
  String get miscDashListeningByDay => 'HÖREN NACH TAG';

  @override
  String get miscDashAllTime => 'Gesamter Zeitraum';

  @override
  String miscDashLastDays(int days) {
    return '$days Tage';
  }

  @override
  String get miscUnknown => 'Unbekannt';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wiedergaben',
      one: '1 Wiedergabe',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => 'Noch keine Hördaten';

  @override
  String get miscDashNoDataHint =>
      'Spiele Musik ab, um hier deine Statistiken zu sehen.';

  @override
  String get miscDashLoadFailed => 'Dashboard konnte nicht geladen werden';

  @override
  String get miscDiagRequiresRemote =>
      'Die Diagnose erfordert eine Verbindung zu einem Remote-Server.';

  @override
  String get miscDiagSystem => 'System';

  @override
  String get miscDiagHealth => 'Zustand';

  @override
  String get miscVersion => 'Version';

  @override
  String get miscDiagUptime => 'Laufzeit';

  @override
  String get miscDiagMemory => 'Speicher';

  @override
  String get miscDiagDatabase => 'Datenbank';

  @override
  String miscZoneNumbered(String id) {
    return 'Zone $id';
  }

  @override
  String get miscDiagLogs => 'Protokolle';

  @override
  String get miscDiagNoLogs => 'Keine Protokolle verfügbar';

  @override
  String get miscAdminTitle => 'Admin-Dashboard';

  @override
  String get miscAdminNotConnected => 'Nicht mit einem Remote-Server verbunden';

  @override
  String get miscAdminSystemHealth => 'Systemzustand';

  @override
  String get miscAdminStatus => 'Status';

  @override
  String get miscAdminDisk => 'Festplatte';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return 'Gefundene Geräte ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return 'Letzte Fehler ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => 'Keine aktuellen Fehler';

  @override
  String get miscTroubleshootingTitle => 'Fehlerbehebung';

  @override
  String get miscFaqHeader => 'Häufige Fragen';

  @override
  String get miscFaq1Title => 'Ich sehe meinen Server nicht';

  @override
  String get miscFaq1Step1 =>
      'Prüfe, ob der Tune-Server läuft und erreichbar ist.';

  @override
  String get miscFaq1Step2 =>
      'Stelle sicher, dass dein Gerät im selben WLAN wie der Server ist.';

  @override
  String get miscFaq1Step3 =>
      'Wenn du ein VPN nutzt, deaktiviere es oder aktiviere die LAN-Erkennung (z. B. nordvpn set lan-discovery on).';

  @override
  String get miscFaq1Step4 =>
      'Versuche, das Netzwerk über Einstellungen > Modus > Netzwerk scannen zu durchsuchen.';

  @override
  String get miscFaq1Step5 =>
      'Prüfe, ob der Server-Port (standardmäßig 8888) nicht von einer Firewall blockiert wird.';

  @override
  String get miscFaq1Step6 => 'Starte Server und App neu.';

  @override
  String get miscFaq2Title => 'Musik wird nicht abgespielt';

  @override
  String get miscFaq2Step1 =>
      'Prüfe, ob eine Wiedergabezone ausgewählt ist (Leiste unten am Bildschirm).';

  @override
  String get miscFaq2Step2 =>
      'Wenn keine Zone existiert, erstelle eine unter Einstellungen > Audio > Zonen > Erstellen.';

  @override
  String get miscFaq2Step3 =>
      'Prüfe, ob das Ausgabegerät (Lautsprecher, DAC) eingeschaltet und im selben Netzwerk ist.';

  @override
  String get miscFaq2Step4 =>
      'Warte bei DLNA-Geräten nach der Erkennung einige Sekunden, bevor du die Wiedergabe startest.';

  @override
  String get miscFaq2Step5 =>
      'Versuche eine andere Datei — das Format der aktuellen Datei wird eventuell nicht unterstützt.';

  @override
  String get miscFaq2Step6 =>
      'Starte die App neu, wenn das Problem weiterhin besteht.';

  @override
  String get miscFaq3Title => 'Cover werden nicht angezeigt';

  @override
  String get miscFaq3Step1 =>
      'Starte einen Bibliotheksscan unter Einstellungen > Bibliothek > Quellen.';

  @override
  String get miscFaq3Step2 =>
      'Prüfe, ob die Dateien eingebettete Cover enthalten (ID3-/Vorbis-Tags).';

  @override
  String get miscFaq3Step3 =>
      'Lege eine Datei cover.jpg oder folder.jpg in den Albumordner.';

  @override
  String get miscFaq3Step4 =>
      'Aktiviere das automatische Laden von Covern unter Einstellungen > Bibliothek > Metadaten.';

  @override
  String get miscFaq3Step5 =>
      'Leere den Bildercache, indem du die App neu startest.';

  @override
  String get miscFaq4Title => 'Der Scan hängt';

  @override
  String get miscFaq4Step1 =>
      'Ein erster Scan kann je nach Größe der Bibliothek mehrere Minuten dauern.';

  @override
  String get miscFaq4Step2 =>
      'Prüfe, ob die Musikordner zugänglich sind (Berechtigungen, SMB-Freigaben).';

  @override
  String get miscFaq4Step3 =>
      'Schließe die App und starte sie neu, um einen hängenden Scan abzubrechen.';

  @override
  String get miscFaq4Step4 =>
      'Prüfe die Server-Protokolle, um eine problematische Datei zu finden.';

  @override
  String get miscFaq4Step5 =>
      'Versuche, die Anzahl der Quellordner zu verringern, um das Problem einzugrenzen.';

  @override
  String get miscFaq5Title => 'So verbindest du ein DLNA-/AirPlay-Gerät';

  @override
  String get miscFaq5Step1 =>
      'DLNA: Das Gerät muss eingeschaltet und im selben Netzwerk sein. Es erscheint automatisch in der Liste der Ausgänge.';

  @override
  String get miscFaq5Step2 =>
      'Wenn das Gerät nicht erscheint, prüfe, ob Multicast auf deinem Router funktioniert.';

  @override
  String get miscFaq5Step3 =>
      'Manche Router blockieren SSDP-Verkehr zwischen WLAN-Clients — aktiviere die Multicast-Weiterleitung.';

  @override
  String get miscFaq5Step4 =>
      'BluOS: Bluesound-Lautsprecher werden automatisch erkannt.';

  @override
  String get miscFaq5Step5 =>
      'Chromecast: Google-Cast-Geräte erscheinen unter den verfügbaren Ausgängen.';

  @override
  String get miscFaq5Step6 =>
      'Erstelle nach der Erkennung eine Zone und weise ihr das Gerät als Ausgang zu.';

  @override
  String get miscFaq6Title => 'Probleme beim Streaming';

  @override
  String get miscFaq6Step1 =>
      'Prüfe, ob deine Zugangsdaten (TIDAL, Qobuz, Deezer) unter Einstellungen > Streaming korrekt sind.';

  @override
  String get miscFaq6Step2 =>
      'Wenn die Sitzung abgelaufen ist, trenne den Dienst und verbinde ihn erneut.';

  @override
  String get miscFaq6Step3 => 'Prüfe deine Internetverbindung.';

  @override
  String get miscFaq6Step4 =>
      'Manche Titel sind in deiner Region möglicherweise nicht verfügbar.';

  @override
  String get miscFaq6Step5 =>
      'Prüfe bei Qualitätsproblemen die Streaming-Qualität unter Einstellungen > Erweitertes Audio.';

  @override
  String get miscFaq6Step6 =>
      'Wenn das Problem weiterhin besteht, sende einen Fehlerbericht über Einstellungen > Hilfe.';

  @override
  String get miscBugReportCopied => 'Bericht in die Zwischenablage kopiert';

  @override
  String get miscBugReportSent => 'Fehler gesendet, danke!';

  @override
  String get miscBugReportSendFailed =>
      'Senden fehlgeschlagen. Kopiere den Bericht ins Forum.';

  @override
  String get miscBugReportTitle => 'Fehlerbericht';

  @override
  String get miscRegenerate => 'Neu erstellen';

  @override
  String get miscBugReportGenerateFailed =>
      'Bericht konnte nicht erstellt werden';

  @override
  String get miscSent => 'Gesendet!';

  @override
  String get miscSending => 'Wird gesendet…';

  @override
  String get miscSubmit => 'Senden';

  @override
  String get miscCopied => 'Kopiert!';

  @override
  String get miscCopyReport => 'Bericht kopieren';

  @override
  String get miscAiServerNotConnected =>
      'Server nicht verbunden. Prüfe die Verbindung.';

  @override
  String miscAiQueryFailed(int code) {
    return 'KI-Anfrage fehlgeschlagen ($code)';
  }

  @override
  String get miscAiNoReply => 'Keine Antwort';

  @override
  String get miscAiAskHint => 'Stelle eine Frage…';

  @override
  String get miscAiSend => 'Senden';

  @override
  String get miscAiTitle => 'KI-Assistent';

  @override
  String get miscAiEmptyTitle => 'Tune KI-Assistent';

  @override
  String get miscAiEmptyBody =>
      'Stelle eine Frage zu deiner Musik,\nbitte um Empfehlungen…';

  @override
  String miscAiAction(String action) {
    return 'Aktion: $action';
  }

  @override
  String get miscCreateAccount => 'Konto erstellen';

  @override
  String get miscUsername => 'Benutzername';

  @override
  String get miscUsernameRequired => 'Benutzername erforderlich';

  @override
  String get miscEmailRequired => 'E-Mail erforderlich';

  @override
  String get miscEmailInvalid => 'Ungültige E-Mail';

  @override
  String get miscPasswordRequired => 'Passwort erforderlich';

  @override
  String miscPasswordMinLength(int min) {
    return 'Mindestens $min Zeichen';
  }

  @override
  String get miscHaveAccountSignIn => 'Schon ein Konto? Anmelden';

  @override
  String get miscNoAccountSignUp => 'Kein Konto? Registrieren';

  @override
  String get npRepeat => 'Wiederholen';

  @override
  String get npQueue => 'Warteschlange';

  @override
  String get npFavorite => 'Favorit';

  @override
  String get npRadioFavAdded => 'Zu den Radio-Favoriten hinzugefügt';

  @override
  String get npLyrics => 'Liedtext';

  @override
  String get npAlarm => 'Wecker';

  @override
  String get npSleepTimer => 'Sleep-Timer';

  @override
  String get npDspCrossfeed => 'DSP-Crossfeed';

  @override
  String get npEqualizer => 'Equalizer';

  @override
  String get npShare => 'Teilen';

  @override
  String get npTransfer => 'Übertragen';

  @override
  String get npCopiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get npNoLyricsFound => 'Kein Liedtext gefunden';

  @override
  String get npNoLyricsAvailable => 'Kein Liedtext verfügbar';

  @override
  String get npLyricsOpenFromNowPlaying =>
      'Für den vollständigen Liedtext über „Aktuelle Wiedergabe“ öffnen';

  @override
  String get npLyricsLoadFailed => 'Liedtext konnte nicht geladen werden';

  @override
  String get npLrcMetadataTooltip => 'Metadaten';

  @override
  String get npLrcMetadataTitle => 'LRC-Metadaten';

  @override
  String get npLrcTitle => 'Titel';

  @override
  String get npLrcCreatedBy => 'Erstellt von';

  @override
  String get npLrcOffset => 'Versatz (ms)';

  @override
  String get npLrcHint =>
      'Lege eine gleichnamige .lrc-Datei neben die Audiodatei.';

  @override
  String get npEqFlat => 'Neutral';

  @override
  String get npEqBassBoost => 'Bass-Boost';

  @override
  String get npEqTrebleBoost => 'Höhen-Boost';

  @override
  String get npEqVocal => 'Gesang';

  @override
  String get npEqRock => 'Rock';

  @override
  String get npEqJazz => 'Jazz';

  @override
  String get npEqClassical => 'Klassik';

  @override
  String get npEqElectronic => 'Elektronisch';

  @override
  String get npEqHipHop => 'Hip-Hop';

  @override
  String get npEqAcoustic => 'Akustisch';

  @override
  String npEqApplied(String preset) {
    return 'EQ: $preset';
  }

  @override
  String npEqError(String error) {
    return 'EQ-Fehler: $error';
  }

  @override
  String get npCrossfeedDesc =>
      'Mischt die Stereokanäle für einen natürlicheren Kopfhörerklang';

  @override
  String get npCrossfeedOff => 'Aus';

  @override
  String get npCrossfeedLight => 'Leicht';

  @override
  String get npCrossfeedMedium => 'Mittel';

  @override
  String get npCrossfeedStrong => 'Stark';

  @override
  String npCrossfeedApplied(String level) {
    return 'Crossfeed: $level';
  }

  @override
  String npDspError(String error) {
    return 'DSP-Fehler: $error';
  }

  @override
  String get npTransferTitle => 'Wiedergabe übertragen';

  @override
  String get npNoOtherZones => 'Keine weiteren Zonen verfügbar';

  @override
  String npTransferredTo(String zone) {
    return 'An $zone übertragen';
  }

  @override
  String npTransferError(String error) {
    return 'Übertragungsfehler: $error';
  }

  @override
  String get npAlarmClock => 'Wecker';

  @override
  String npAlarmSetFor(String time) {
    return 'Wecker gestellt auf $time';
  }

  @override
  String npAlarmError(String error) {
    return 'Weckerfehler: $error';
  }

  @override
  String get npAlarmCancelled => 'Wecker abgebrochen';

  @override
  String get npPause => 'Pause';

  @override
  String get npStop => 'Stopp';

  @override
  String get npRoleComposer => 'Komponist';

  @override
  String get npRoleLyricist => 'Texter';

  @override
  String get npRoleArranger => 'Arrangeur';

  @override
  String get npRoleConductor => 'Dirigent';

  @override
  String get npRolePerformer => 'Interpret';

  @override
  String get npRoleProducer => 'Produzent';

  @override
  String get npRoleMixer => 'Mischung';

  @override
  String get npRoleEngineer => 'Toningenieur';

  @override
  String get npCreditsEnriching => 'Wird angereichert…';

  @override
  String get npCreditsEnrich => 'Über MusicBrainz anreichern';

  @override
  String get npVolume => 'Lautstärke';

  @override
  String get npChangeZone => 'Zone wechseln';

  @override
  String get npZoneFallback => 'Zone';

  @override
  String get npFollowMe => 'Folge mir';

  @override
  String get npMovePlaybackTo => 'Wiedergabe verschieben nach…';

  @override
  String get npNowPlaying => 'Aktuelle Wiedergabe';

  @override
  String get npTabMore => 'Mehr';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return 'Sleep-Timer gestellt: $minutes Min. (Ausblenden: $fade s)';
  }

  @override
  String npSleepTimerError(String error) {
    return 'Sleep-Timer-Fehler: $error';
  }

  @override
  String get npSleepTimerCancelled => 'Sleep-Timer abgebrochen';

  @override
  String get npSleepDuration => 'DAUER';

  @override
  String get npSleepCustom => 'Eigene';

  @override
  String get npSleepFadeOut => 'AUSBLENDEN';

  @override
  String npSleepFadeDesc(int seconds) {
    return 'Die Lautstärke wird in den letzten $seconds Sekunden allmählich auf null ausgeblendet.';
  }

  @override
  String get npSleepStarting => 'Wird gestartet…';

  @override
  String npSleepStart(String duration) {
    return 'Starten ($duration)';
  }

  @override
  String get npSleepSelectDuration => 'Dauer wählen';

  @override
  String get npSleepTimerActive => 'Timer aktiv';

  @override
  String get npSleepCancelTimer => 'Timer abbrechen';

  @override
  String get npMoodChill => 'Chillen';

  @override
  String get npMoodParty => 'Party';

  @override
  String get npMoodFocus => 'Fokus';

  @override
  String get npMoodEnergetic => 'Energiegeladen';

  @override
  String get npNoZoneAvailable => 'Keine Zone verfügbar';

  @override
  String npMoodNoTracks(String mood) {
    return 'Keine Titel für $mood gefunden';
  }

  @override
  String get npMoodInvalidTrackIds => 'Fehler: ungültige Titel-IDs';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel werden abgespielt',
      one: '1 Titel wird abgespielt',
    );
    return '$mood-Mix: $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel zur Warteschlange hinzugefügt',
      one: '1 Titel zur Warteschlange hinzugefügt',
    );
    return '$mood-Mix: $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Smart-AutoPlay-Fehler: $error';
  }

  @override
  String get npSmartAutoplayDesc =>
      'Wähle eine Stimmung, um eine intelligente Playlist zu erstellen';

  @override
  String get npAlarmsNotConnected => 'Nicht mit einem Remote-Server verbunden';

  @override
  String get npAlarmSnoozed => 'Wecker um 5 Min. verschoben';

  @override
  String get npAlarmsTitle => 'Wecker';

  @override
  String get npAlarmsEmpty => 'Keine Wecker';

  @override
  String npZoneNumbered(String id) {
    return 'Zone $id';
  }

  @override
  String get npAlarmSkipsHolidays => 'Außer an Feiertagen';

  @override
  String get npAlarmSnooze => 'Schlummern';

  @override
  String get npAlarmDefaultName => 'Wecker';

  @override
  String get npAlarmEdit => 'Wecker bearbeiten';

  @override
  String get npAlarmNew => 'Neuer Wecker';

  @override
  String get npAlarmTime => 'Uhrzeit';

  @override
  String get npAlarmNameHint => 'Aufwachen';

  @override
  String get npAlarmDays => 'Tage';

  @override
  String get npAlarmSkipHolidays => 'Feiertage auslassen';

  @override
  String get npAlarmCountry => 'Land:';

  @override
  String get npCountryFR => 'Frankreich';

  @override
  String get npCountryBE => 'Belgien';

  @override
  String get npCountryCH => 'Schweiz';

  @override
  String get npCountryCA => 'Kanada';

  @override
  String get npCountryUS => 'USA';

  @override
  String get npCountryDE => 'Deutschland';

  @override
  String get npCountryGB => 'Vereinigtes Königreich';

  @override
  String get npAlarmSource => 'Quelle';

  @override
  String get npAlarmSourceType => 'Typ';

  @override
  String get npSourceRadio => 'Radio';

  @override
  String get npSourcePlaylist => 'Playlist';

  @override
  String get npSourceAlbum => 'Album';

  @override
  String get npAlarmSourceName => 'Name der Quelle';

  @override
  String get npAlarmPlaylistId => 'Playlist-ID';

  @override
  String get npAlarmAlbumId => 'Album-ID';

  @override
  String get npAlarmIdentifier => 'Kennung';

  @override
  String get npAlarmPlaybackZone => 'Wiedergabezone';

  @override
  String get npAlarmDefaultZone => 'Standard';

  @override
  String npAlarmVolume(int percent) {
    return 'Lautstärke: $percent %';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return 'Einblenden: $seconds s';
  }

  @override
  String get npAlarmEnabled => 'Aktiviert';

  @override
  String get npAlarmDeleteTitle => 'Wecker löschen?';

  @override
  String get npDayMon => 'Mo';

  @override
  String get npDayTue => 'Di';

  @override
  String get npDayWed => 'Mi';

  @override
  String get npDayThu => 'Do';

  @override
  String get npDayFri => 'Fr';

  @override
  String get npDaySat => 'Sa';

  @override
  String get npDaySun => 'So';

  @override
  String get plHubTitle => 'Playlist-Hub';

  @override
  String get plTabSmartAi => 'KI';

  @override
  String get plTabTransfers => 'Übertragungen';

  @override
  String get plSync => 'Sync';

  @override
  String get plTabBackup => 'Sicherung';

  @override
  String get plCompare => 'Vergleichen';

  @override
  String get plComparing => 'Vergleich läuft…';

  @override
  String plCompareError(String detail) {
    return 'Vergleich fehlgeschlagen: $detail';
  }

  @override
  String get plNoPlaylistsAvailable => 'Keine Playlists verfügbar';

  @override
  String get plSectionSource => 'QUELLE';

  @override
  String get plSectionTarget => 'ZIEL';

  @override
  String get plServiceLabel => 'Dienst';

  @override
  String get plPlaylistLabel => 'Playlist';

  @override
  String get plLocal => 'Lokal';

  @override
  String get plSourceLabel => 'Quelle';

  @override
  String get plRestoreSnapshotTitle => 'Snapshot wiederherstellen';

  @override
  String get plLocalPlaylistNameLabel => 'Name der lokalen Playlist:';

  @override
  String get plRestore => 'Wiederherstellen';

  @override
  String plRestoreDone(String name, String matched, String notFound) {
    return '„$name“ wiederhergestellt: $matched gefunden, $notFound nicht gefunden.';
  }

  @override
  String plRestoreReplaced(String name, String matched, String notFound) {
    return '„$name“ ersetzt: $matched gefunden, $notFound nicht gefunden.';
  }

  @override
  String get plExistingTitle => 'Playlist existiert bereits';

  @override
  String plExistingBody(String name) {
    return 'Eine Playlist „$name“ existiert bereits. Ersetzen?';
  }

  @override
  String get plReplace => 'Ersetzen';

  @override
  String plDeleteSnapshotBody(String name) {
    return 'Snapshot von „$name“ löschen?';
  }

  @override
  String get plSyncIntervalTitle => 'Intervall für Auto-Sync';

  @override
  String get plSyncIntervalLabel => 'Minuten (0 = nur manuell):';

  @override
  String get plSyncIntervalHint => 'z. B. 60';

  @override
  String get plNoTransfers => 'Keine Übertragungen';

  @override
  String get plNoSyncLinks => 'Keine Sync-Verknüpfungen';

  @override
  String get plNoSyncLinksHint =>
      'Verknüpfungen über eine Übertragung erstellen';

  @override
  String plPlaylistNumber(String id) {
    return 'Playlist #$id';
  }

  @override
  String plAutoEveryMinutes(String minutes) {
    return 'auto $minutes Min.';
  }

  @override
  String plSyncDone(
    String addedLocal,
    String removedLocal,
    String addedRemote,
    String removedRemote,
  ) {
    return 'Sync OK: +$addedLocal/-$removedLocal lokal, +$addedRemote/-$removedRemote entfernt';
  }

  @override
  String plSyncConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ', $count Konflikte',
      one: ', 1 Konflikt',
    );
    return '$_temp0';
  }

  @override
  String plSyncError(String detail) {
    return 'Sync fehlgeschlagen: $detail';
  }

  @override
  String get plSectionBackup => 'SICHERUNG';

  @override
  String get plBackingUp => 'Sicherung läuft…';

  @override
  String get plBackupAll => 'Alle Playlists sichern';

  @override
  String plBackupResult(String playlists, String tracks) {
    return '$playlists Playlists · $tracks Titel';
  }

  @override
  String get plSectionSnapshots => 'SNAPSHOTS';

  @override
  String get plNoSnapshots =>
      'Keine Snapshots. Starte eine Sicherung, um einen zu erstellen.';

  @override
  String get plSectionBatchTransfer => 'SAMMELÜBERTRAGUNG';

  @override
  String get plBatchTransferHint => 'Alle Playlists eines Dienstes übertragen';

  @override
  String get plTransferring => 'Übertragung…';

  @override
  String get plTransferAll => 'Alle übertragen';

  @override
  String plBatchResult(String count, String status) {
    return '$count Playlists — $status';
  }

  @override
  String get plMergeDone => 'Playlists zusammengeführt.';

  @override
  String plMergeError(String detail) {
    return 'Zusammenführen fehlgeschlagen: $detail';
  }

  @override
  String get plNameLabel => 'Name';

  @override
  String plDeleteNamed(String name) {
    return '„$name“ löschen?';
  }

  @override
  String plImportedLocal(String name) {
    return '„$name“ lokal importiert.';
  }

  @override
  String plImportError(String detail) {
    return 'Import fehlgeschlagen: $detail';
  }

  @override
  String get plFilterAll => 'Alle';

  @override
  String get plMerge => 'Zusammenführen';

  @override
  String get plCancelMerge => 'Zusammenführen abbrechen';

  @override
  String get plMerging => 'Wird zusammengeführt…';

  @override
  String get plImportToLocal => 'Lokal importieren';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => 'Duplikate entfernen';

  @override
  String get plMergedNameHint => 'Name der zusammengeführten Playlist';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel',
      one: '1 Titel',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => 'ERGEBNISSE';

  @override
  String get plCommon => 'Gemeinsam';

  @override
  String get plSourceOnly => 'Nur Quelle';

  @override
  String get plTargetOnly => 'Nur Ziel';

  @override
  String plMatchRate(String rate) {
    return '$rate % Übereinstimmung';
  }

  @override
  String plOnlyInSource(int count) {
    return 'Nur in der Quelle ($count)';
  }

  @override
  String plOnlyInTarget(int count) {
    return 'Nur im Ziel ($count)';
  }

  @override
  String plMoreCount(int count) {
    return '+ $count weitere';
  }

  @override
  String get plTransferPlaylistTitle => 'Playlist übertragen';

  @override
  String get plCreateOnRemote => 'Im entfernten Dienst erstellen';

  @override
  String get plTransfer => 'Übertragen';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return 'Übertragung: $matched gefunden, $approximate ungefähr, $notFound fehlen.';
  }

  @override
  String get plRecover => 'Wiederherstellen';

  @override
  String plRecoverDone(int available, int alternatives) {
    return 'Wiederherstellung: $available verfügbar, $alternatives Alternativen gefunden.';
  }

  @override
  String plCopyName(String name) {
    return '$name (Kopie)';
  }

  @override
  String get plDuplicate => 'Duplizieren';

  @override
  String plDuplicated(String name) {
    return 'Dupliziert: $name';
  }

  @override
  String plDeleted(String name) {
    return 'Gelöscht: $name';
  }

  @override
  String plTransferred(String name) {
    return 'Übertragen: $name';
  }

  @override
  String get plTransferToLocal => 'Lokal übertragen';

  @override
  String get plExportJson => 'Als JSON exportieren';

  @override
  String get plExportCsv => 'Als CSV exportieren';

  @override
  String get plExportM3u => 'Als M3U exportieren';

  @override
  String get plExportJsonDone => 'JSON-Export abgeschlossen';

  @override
  String get plExportCsvDone => 'CSV-Export abgeschlossen';

  @override
  String plExportM3uDone(String path) {
    return 'M3U exportiert: $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'M3U-Export fehlgeschlagen: $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importiert: $name ($count Titel)',
      one: 'Importiert: $name (1 Titel)',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'M3U-Import fehlgeschlagen: $detail';
  }

  @override
  String get plSmartTitle => 'Intelligente Playlists';

  @override
  String plSmartLoadError(String detail) {
    return 'Intelligente Playlists konnten nicht geladen werden: $detail';
  }

  @override
  String plDeleteError(String detail) {
    return 'Löschen fehlgeschlagen: $detail';
  }

  @override
  String get plSmartEmpty => 'Keine intelligenten Playlists';

  @override
  String get plUntitled => 'Ohne Titel';

  @override
  String get plSmartDeleteTitle => 'Intelligente Playlist löschen?';

  @override
  String plPreviewError(String detail) {
    return 'Vorschau fehlgeschlagen: $detail';
  }

  @override
  String get plEnterName => 'Bitte einen Namen eingeben';

  @override
  String plSaveError(String detail) {
    return 'Speichern fehlgeschlagen: $detail';
  }

  @override
  String get plSmartEditTitle => 'Intelligente Playlist bearbeiten';

  @override
  String get plSmartNewTitle => 'Neue intelligente Playlist';

  @override
  String get plMatchLabel => 'Treffer';

  @override
  String get plMatchAll => 'Alle Regeln';

  @override
  String get plMatchAny => 'Beliebige Regel';

  @override
  String get plSectionRules => 'REGELN';

  @override
  String get plAddRule => 'Regel hinzufügen';

  @override
  String get plMaxTracksLabel => 'Max. Titel (optional)';

  @override
  String get plNoLimit => 'Keine Begrenzung';

  @override
  String get plPreviewMatching => 'Passende Titel anzeigen';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passende Titel',
      one: '1 passender Titel',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => 'Wert';

  @override
  String get plUnknownTitle => 'Unbekannt';

  @override
  String plTracksLoadError(String detail) {
    return 'Titel konnten nicht geladen werden: $detail';
  }

  @override
  String get plSmartNoTracks => 'Keine Titel passen zu dieser Playlist';

  @override
  String get plFieldGenre => 'Genre';

  @override
  String get plFieldArtist => 'Künstler';

  @override
  String get plFieldAlbum => 'Album';

  @override
  String get plFieldTitle => 'Titel';

  @override
  String get plFieldYear => 'Jahr';

  @override
  String get plFieldRating => 'Bewertung';

  @override
  String get plFieldPlayCount => 'Wiedergaben';

  @override
  String get plFieldDuration => 'Dauer (ms)';

  @override
  String get plFieldDateAdded => 'Hinzugefügt am';

  @override
  String get plFieldFavorite => 'Favorit';

  @override
  String get plOpContains => 'enthält';

  @override
  String get plOpEquals => 'ist gleich';

  @override
  String get plOpStartsWith => 'beginnt mit';

  @override
  String get plOpEndsWith => 'endet mit';

  @override
  String get plOpGreaterThan => 'größer als';

  @override
  String get plOpLessThan => 'kleiner als';

  @override
  String get plOpIs => 'ist';

  @override
  String get plOpIsNot => 'ist nicht';

  @override
  String get srvConfigTitle => 'Serverkonfiguration';

  @override
  String srvFolderAdded(String path) {
    return 'Ordner hinzugefügt: $path';
  }

  @override
  String get srvRemoveFolderTitle => 'Diesen Ordner entfernen?';

  @override
  String srvScanStarted(String path) {
    return 'Scan gestartet: $path';
  }

  @override
  String get srvFullScanStarted => 'Vollständiger Scan gestartet';

  @override
  String get srvRestartTitle => 'Server neu starten?';

  @override
  String get srvRestartBody =>
      'Der Server wird gestoppt und neu gestartet. Die laufende Wiedergabe wird unterbrochen.';

  @override
  String get srvRestartBtn => 'Neu starten';

  @override
  String get srvRestarting => 'Server wird neu gestartet…';

  @override
  String get srvRestartInProgress => 'Neustart läuft…';

  @override
  String get srvLoadError => 'Laden fehlgeschlagen';

  @override
  String get srvScanFolderTooltip => 'Diesen Ordner scannen';

  @override
  String get srvSectionServerInfo => 'Serverinformationen';

  @override
  String get srvInfoVersion => 'Version';

  @override
  String get srvInfoEngine => 'Engine';

  @override
  String get srvInfoDatabase => 'Datenbank';

  @override
  String get srvSectionActions => 'Aktionen';

  @override
  String get srvRestartServer => 'Server neu starten';

  @override
  String get srvRestartServerDesc =>
      'Stoppt den Serverprozess und startet ihn neu';

  @override
  String get srvManualEntry => 'Manuell eingeben';

  @override
  String srvSelectPath(String path) {
    return '„$path“ auswählen';
  }

  @override
  String get srvBrowse => 'Durchsuchen…';

  @override
  String get srvFolderPathHint => '/pfad/zur/musik';

  @override
  String get srvFolderPathHelp =>
      'Gib den absoluten Pfad des Ordners auf dem Server ein.';

  @override
  String get srvNoSubfolders => 'Keine Unterordner';

  @override
  String get srvPluginsTitle => 'Plugins';

  @override
  String get srvNotConnectedToServer => 'Nicht mit dem Server verbunden';

  @override
  String srvPluginInstalled(String name) {
    return '$name installiert';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name deinstalliert';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name aktualisiert';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name aktiviert';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name deaktiviert';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return 'Installation fehlgeschlagen: $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return 'Deinstallation fehlgeschlagen: $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return 'Aktualisierung fehlgeschlagen: $error';
  }

  @override
  String get srvPluginsTabStore => 'Store';

  @override
  String get srvPluginsTabInstalled => 'Installiert';

  @override
  String get srvRestartRequired =>
      'Neustart erforderlich, um die Änderungen zu übernehmen';

  @override
  String get srvPluginsSearchHint => 'Plugins durchsuchen…';

  @override
  String get srvPluginsNoneFound => 'Keine Plugins gefunden';

  @override
  String get srvPluginsNoneInstalled => 'Keine Plugins installiert';

  @override
  String get srvPluginsBrowseStore => 'Store durchsuchen';

  @override
  String get srvPluginBadgeFeatured => 'Empfohlen';

  @override
  String get srvPluginBadgeUpdate => 'Update';

  @override
  String get srvPluginBadgeIncompatible => 'Inkompatibel';

  @override
  String srvPluginByAuthor(String author) {
    return 'von $author';
  }

  @override
  String get srvPluginActionUpdate => 'Aktualisieren';

  @override
  String get srvPluginActionInstall => 'Installieren';

  @override
  String get srvPluginActionUninstall => 'Deinstallieren';

  @override
  String get srvPluginStatusActive => 'Aktiv';

  @override
  String get srvPluginStatusError => 'Fehler';

  @override
  String get srvAutoFixTitle => 'Metadaten automatisch korrigieren';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Korrekturen angewendet',
      one: '1 Korrektur angewendet',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence =>
      'Keine Korrekturen mit hoher Konfidenz mehr';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Vorschläge übrig',
      one: '1 Vorschlag übrig',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => 'Hohe Konfidenz anwenden';

  @override
  String srvAutoFixTrackNumber(int id) {
    return 'Titel #$id';
  }

  @override
  String get srvAutoFixCurrent => 'Aktuell';

  @override
  String get srvAutoFixEmpty => '(leer)';

  @override
  String get srvAutoFixSuggested => 'Vorgeschlagen';

  @override
  String get srvAutoFixSkip => 'Überspringen';

  @override
  String get srvAutoFixApply => 'Anwenden';

  @override
  String get srvAutoFixIntroTitle => 'Fehlende Metadaten korrigieren';

  @override
  String get srvAutoFixIntroBody =>
      'Durchsucht Titel ohne Genre, Jahr oder MusicBrainz-ID und schlägt Korrekturen aus MusicBrainz vor.';

  @override
  String get srvAutoFixStartScan => 'Scan starten';

  @override
  String get srvAutoFixScanning => 'MusicBrainz wird durchsucht…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total Titel ($pct %)';
  }

  @override
  String get srvAutoFixLoadingTracks => 'Titel werden geladen…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bisher $count Korrekturen gefunden',
      one: 'Bisher 1 Korrektur gefunden',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit =>
      'Auf 1 Anfrage/s begrenzt (MusicBrainz-Richtlinie)';

  @override
  String get srvAutoFixNoneNeeded => 'Keine Korrekturen nötig';

  @override
  String get srvAutoFixAllComplete =>
      'Alle Titel haben vollständige Metadaten.';

  @override
  String get srvAutoFixScanAgain => 'Erneut scannen';

  @override
  String get srvAutoFixScanFailed => 'Scan fehlgeschlagen';

  @override
  String get srvMpStepSetup => 'Einrichtung';

  @override
  String get srvMpStepFineTune => 'Feinabstimmung';

  @override
  String get srvMpListenTitle => 'Wie hörst du?';

  @override
  String get srvMpListenSubtitle =>
      'Das Profil wird an deine Hörumgebung angepasst';

  @override
  String get srvMpSpeakers => 'Lautsprecher';

  @override
  String get srvMpSpeakersSub => 'Hörraum';

  @override
  String get srvMpHeadphones => 'Kopfhörer';

  @override
  String get srvMpHeadphonesSub => 'Persönliches Hören';

  @override
  String get srvMpRoomTitle => 'Wie groß ist der Raum?';

  @override
  String get srvMpRoomSubtitle => 'Beeinflusst tiefe Frequenzen und Nachhall';

  @override
  String get srvMpRoomSmall => 'Klein';

  @override
  String get srvMpRoomMedium => 'Mittel';

  @override
  String get srvMpRoomLarge => 'Groß';

  @override
  String get srvMpPlacementTitle => 'Lautsprecheraufstellung';

  @override
  String get srvMpPlacementSubtitle =>
      'Die Aufstellung beeinflusst Bassreflexionen';

  @override
  String get srvMpNearWall => 'Nah an der Wand';

  @override
  String get srvMpFreeStanding => 'Frei stehend';

  @override
  String get srvMpTuneSound => 'Klang anpassen';

  @override
  String get srvMpCorrectionActive => 'Korrektur aktiv';

  @override
  String get srvMpCorrectionDesc =>
      'Wendet das Profil auf die aktuelle Zone an';

  @override
  String get srvMpBass => 'Bass';

  @override
  String get srvMpBassDesc => 'Gewicht, Wärme, Körper des Klangs';

  @override
  String get srvMpBassLow => 'Schlank';

  @override
  String get srvMpBassHigh => 'Wuchtig';

  @override
  String get srvMpMid => 'Stimme / Mitten';

  @override
  String get srvMpMidDesc => 'Präsenz, Klarheit, Verständlichkeit';

  @override
  String get srvMpMidLow => 'Zurückhaltend';

  @override
  String get srvMpMidHigh => 'Präsent';

  @override
  String get srvMpTreble => 'Höhen';

  @override
  String get srvMpTrebleDesc => 'Brillanz, Detail, Luftigkeit des Klangs';

  @override
  String get srvMpTrebleLow => 'Dunkel';

  @override
  String get srvMpTrebleHigh => 'Hell';

  @override
  String get srvMpProfileApplied => 'Profil angewendet';

  @override
  String get srvMpApplying => 'Wird angewendet…';

  @override
  String get srvMpApply => 'Profil anwenden';

  @override
  String get srvMpBackToQuestions => 'Zurück zu den Fragen';

  @override
  String get srvRemoteConfigBody =>
      'Verbinde dich mit einem Tune-Server in deinem Netzwerk, um alle Funktionen zu nutzen.';

  @override
  String get srvModeStandalone => 'Eigenständig';

  @override
  String get srvStandaloneWarning =>
      'Eigenständiger Modus: Party, DJ, synchronisierte Songtexte, EQ und Empfehlungen sind nicht verfügbar. Empfohlen: einen Remote-Tune-Server verwenden.';

  @override
  String get srvServerAddress => 'Serveradresse';

  @override
  String get srvNoServerYet => 'Noch kein Server?';

  @override
  String get srvDownloadServer =>
      'Tune Server herunterladen: mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).';

  @override
  String get srvStreamingBody =>
      'Aktiviere die Streaming-Dienste, die du mit Tune nutzen möchtest.';

  @override
  String get srvStreamingStandaloneWarning =>
      'Im eigenständigen Modus sind Streaming-Dienste nicht verfügbar. Wechsle in den Remote-Server-Modus, um sie zu aktivieren.';

  @override
  String get srvNoServiceAvailable =>
      'Keine Dienste verfügbar. Prüfe die Verbindung zum Server.';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dienste aktiviert',
      one: '1 Dienst aktiviert',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verbunden',
      one: '1 verbunden',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => 'Aktiviert, nicht verbunden';

  @override
  String get srvAudioCheckTitle => 'Audio-Diagnose';

  @override
  String get srvAudioCheckBody =>
      'Die Audiokonfiguration deines Systems wird überprüft.';

  @override
  String get srvDiagZones => 'Konfigurierte Zonen';

  @override
  String get srvDiagOutputs => 'Audioausgänge';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erkannt',
      one: '1 erkannt',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => 'Netzwerkgeräte';

  @override
  String get srvDiagNone => 'Keine';

  @override
  String get srvDiagNoZoneWarning =>
      'Keine Zone konfiguriert. Du kannst in den Zonen-Einstellungen eine erstellen.';

  @override
  String srvAudioCheckUnavailable(String error) {
    return 'Audio-Diagnose nicht verfügbar: $error';
  }

  @override
  String get srvRecheck => 'Erneut prüfen';

  @override
  String get srvScanBody =>
      'Starte einen Scan, um deine Musikdateien zu indexieren und ihre Metadaten abzurufen.';

  @override
  String get srvScanStart => 'Scan starten';

  @override
  String get srvScanStatScanned => 'Gescannt';

  @override
  String get srvScanStatAdded => 'Hinzugefügt';

  @override
  String get srvScanStatUpdated => 'Aktualisiert';

  @override
  String get srvScanMayTakeMinutes => 'Das kann einige Minuten dauern…';

  @override
  String get srvScanComplete => 'Scan abgeschlossen!';

  @override
  String stgUpdateAvailable(String version) {
    return 'Update verfügbar: v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return 'Aktuelle Version: v$version';
  }

  @override
  String get stgOpen => 'Öffnen';

  @override
  String get stgMode => 'Modus';

  @override
  String stgConnectedTo(String address) {
    return 'Verbunden mit $address';
  }

  @override
  String get stgModeRemote => 'Remote';

  @override
  String get stgStandaloneTitle =>
      'Standalone-Modus — eingeschränkte Funktionen';

  @override
  String get stgStandaloneBody =>
      'Party, DJ, synchronisierte Songtexte, EQ, Album-Biografien, Empfehlungen… erfordern einen entfernten Tune-Server.';

  @override
  String get stgServerAddress => 'Serveradresse';

  @override
  String get stgNotConfigured => 'Nicht konfiguriert';

  @override
  String get stgScanNetwork => 'Netzwerk durchsuchen';

  @override
  String get stgSectionPlayback => 'WIEDERGABE';

  @override
  String get stgCrossfade => 'Überblendung';

  @override
  String get stgRepeatOneByDefault => 'Standardmäßig wiederholen';

  @override
  String get stgExclusiveMode => 'Exklusivmodus (bit-perfect)';

  @override
  String get stgExclusiveModeDesc =>
      'WASAPI Exclusive — direkter Zugriff auf den USB-DAC';

  @override
  String get stgSectionMetadataFields => 'METADATENFELDER';

  @override
  String get stgSectionAdvancedAudio => 'ERWEITERTES AUDIO';

  @override
  String get stgEqualizer => 'Equalizer';

  @override
  String get stgEqualizerDesc => 'Kalibrierungsassistent + 10-Band-Experten-EQ';

  @override
  String get stgMetadataFieldsDesc =>
      'Erweiterte Felder konfigurieren (Komponist, Dirigent…)';

  @override
  String get stgSpotifyConnectDesc =>
      'Tune als Empfänger (Premium auf dem Client erforderlich)';

  @override
  String get stgLastfmDesc => 'Hörverlauf scrobbeln';

  @override
  String get stgListenBrainzDesc => 'Zu ListenBrainz scrobbeln';

  @override
  String get stgAutoFixMetadata => 'Metadaten automatisch korrigieren';

  @override
  String get stgAutoFixMetadataDesc =>
      'Fehlendes Genre, Jahr, MBID über MusicBrainz ergänzen';

  @override
  String get stgDatabase => 'Datenbank';

  @override
  String get stgImportExport => 'Import / Export';

  @override
  String get stgSectionProfiles => 'PROFILE';

  @override
  String get stgSectionSystem => 'SYSTEM';

  @override
  String get stgServerConfig => 'Serverkonfiguration';

  @override
  String get stgServerConfigDesc => 'Musikordner, Scan, Neustart';

  @override
  String get stgNetworkDiagnostics => 'Netzwerkdiagnose';

  @override
  String get stgNetworkDiagnosticsDesc => 'Multicast, DNS, Konnektivität';

  @override
  String get stgConfiguration => 'Konfiguration';

  @override
  String get stgExportImport => 'Exportieren / Importieren';

  @override
  String get stgPlugins => 'Plugins';

  @override
  String get stgPluginsDesc => 'Installierte Erweiterungen';

  @override
  String get stgNetworkShares => 'Netzwerkfreigaben (SMB)';

  @override
  String get stgNetworkSharesDesc => 'Freigaben finden und einbinden';

  @override
  String get stgSectionCloud => 'CLOUD';

  @override
  String get stgSectionHelp => 'HILFE';

  @override
  String get stgTroubleshooting => 'Fehlerbehebung';

  @override
  String get stgTroubleshootingDesc => 'Häufige Fragen und Lösungen';

  @override
  String get stgSendBugReport => 'Fehlerbericht senden';

  @override
  String get stgSendBugReportDesc =>
      'Technischen Bericht erstellen und kopieren';

  @override
  String get stgServerAddressHint => 'IP oder Hostname (z. B. 192.168.1.18)';

  @override
  String get stgServerPort => 'Server-Port';

  @override
  String get stgPortDefaultHint => 'Port (Standard: 8888)';

  @override
  String get stgWarnNoZones =>
      'Keine Zone konfiguriert. Erstelle eine, um die Wiedergabe zu starten.';

  @override
  String get stgWarnNoNetworkDevices =>
      'Kein Netzwerkgerät erkannt (DLNA/BluOS/Chromecast).';

  @override
  String get stgSectionAudio => 'AUDIO';

  @override
  String get stgAudioOutputs => 'Audioausgänge';

  @override
  String stgOutputsDetected(int count) {
    return '$count erkannt';
  }

  @override
  String get stgNetworkDevices => 'Netzwerkgeräte';

  @override
  String get stgZoneNameHint => 'z. B. Wohnzimmer, Büro';

  @override
  String get stgProfileActivated => 'Profil aktiviert';

  @override
  String get stgNewProfile => 'Neues Profil';

  @override
  String get stgProfileName => 'Profilname';

  @override
  String get stgProfileNameHint => 'z. B. Abend, Morgen';

  @override
  String get stgProfileUpdated => 'Profil aktualisiert';

  @override
  String get stgNoProfiles => 'Keine Profile';

  @override
  String get stgProfile => 'Profil';

  @override
  String get stgEditProfile => 'Profil bearbeiten';

  @override
  String get stgName => 'Name';

  @override
  String get stgColor => 'Farbe';

  @override
  String get stgScanInProgress => 'Netzwerk wird durchsucht…';

  @override
  String stgScanChecking(int scanned, int total) {
    return 'Prüfe $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'Kein Tune-Server gefunden';

  @override
  String stgServersFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Server gefunden',
      one: '1 Server gefunden',
    );
    return '$_temp0';
  }

  @override
  String get stgTuneServers => 'Tune-Server';

  @override
  String get stgFieldFormat => 'Format (FLAC, MP3…)';

  @override
  String get stgFieldSampleRate => 'Abtastrate (96 kHz)';

  @override
  String get stgFieldBitDepth => 'Bittiefe (24 Bit)';

  @override
  String get stgFieldLabel => 'Label';

  @override
  String get stgFieldComposer => 'Komponist';

  @override
  String get stgFieldDuration => 'Dauer';

  @override
  String get stgFieldSource => 'Quelle (Tidal, Qobuz…)';

  @override
  String get stgMetadataFieldsIntro =>
      'Unter jedem Titel angezeigte Felder (Suche, Bibliothek, Warteschlange, Verlauf)';

  @override
  String get stgAudiophileMode => 'Audiophiler Modus';

  @override
  String get stgAudiophileModeDesc =>
      'DSP umgangen, EQ deaktiviert, bit-perfect';

  @override
  String get stgCloudAccount => 'Cloud-Konto';

  @override
  String stgConnectedAs(String email) {
    return 'Verbunden ($email)';
  }

  @override
  String get stgTelemetry => 'Telemetrie';

  @override
  String get stgTelemetryDesc => 'Anonyme Nutzungsstatistiken senden';

  @override
  String get stgSyncingLibrary => 'Bibliothek wird synchronisiert…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total Titel';
  }

  @override
  String get stgConnectingStreaming => 'Verbindung mit Streaming-Diensten…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'Neu in v$version';
  }

  @override
  String get stgWhatsNewLibrarySync =>
      'Verbesserte Bibliothekssynchronisierung';

  @override
  String get stgWhatsNewMultiRoom =>
      'Optimierter Multiroom und Zonenverwaltung';

  @override
  String get stgWhatsNewBugFixes =>
      'Fehlerbehebungen und Stabilitätsverbesserungen';

  @override
  String get stgStartServerFailed => 'Server konnte nicht gestartet werden';

  @override
  String stgStartServerFailedWith(String detail) {
    return 'Server konnte nicht gestartet werden: $detail';
  }

  @override
  String get stgConnectionFailed => 'Verbindung fehlgeschlagen';

  @override
  String stgConnectionFailedWith(String detail) {
    return 'Verbindung fehlgeschlagen: $detail';
  }

  @override
  String get stgStartingServer => 'Tune Server wird gestartet…';

  @override
  String get stgTagline => 'Multiroom-Musikserver';

  @override
  String get stgLocalServer => 'Lokaler Server';

  @override
  String get stgLocalServerDesc =>
      'Tune auf diesem Gerät ausführen.\nDeine Musik, deine Regeln.';

  @override
  String get stgRemoteControl => 'Fernbedienung';

  @override
  String get stgRemoteControlDesc =>
      'Mit einem Tune-Server\nin deinem Netzwerk verbinden.';

  @override
  String get stgRemoteConnection => 'Fernverbindung';

  @override
  String get znZoneManagerTitle => 'Zonenverwaltung';

  @override
  String get znCannotDeleteLastZone =>
      'Die letzte Zone kann nicht gelöscht werden';

  @override
  String znZoneSwitchError(String error) {
    return 'Zonenwechsel fehlgeschlagen: $error';
  }

  @override
  String get znZoneSettings => 'Zoneneinstellungen';

  @override
  String get znPhoneSpeakers => 'Telefonlautsprecher';

  @override
  String get znBtConnectedOutputs => 'Verbundene Bluetooth-Ausgänge';

  @override
  String get znBtSystemOutput => 'Nutzt die Systemausgabe (Kontrollzentrum)';

  @override
  String get znBtOutputsTitle => 'Bluetooth-Ausgänge';

  @override
  String get znBtNoDevice =>
      'Kein Bluetooth-Gerät verbunden. Koppeln Sie ein Gerät in den Systemeinstellungen.';

  @override
  String get znBtAndroidRouting =>
      'Das aktive Routing hängt von den Android-Systemeinstellungen ab.';

  @override
  String get znDsdMode => 'DSD-Modus';

  @override
  String get znDsdAuto => 'Auto';

  @override
  String get znDsdNative => 'Nativ';

  @override
  String get znGaplessDlnaDesc => 'Nahtlose Übergänge zwischen Titeln (DLNA)';

  @override
  String get znFixedVolume => 'Feste Lautstärke';

  @override
  String get znFixedVolumeDesc => 'Deaktiviert die Software-Lautstärkeregelung';

  @override
  String get znCap16Bit => 'Auf 16 Bit begrenzen';

  @override
  String get znCap16BitDesc =>
      'Aktivieren, wenn Hi-Res (24 Bit) stumm bleibt, 16 Bit aber funktioniert (Ruark R3). Wandelt in 16-Bit-FLAC um.';

  @override
  String get znZoneMuted => 'Zone stummgeschaltet';

  @override
  String get znZoneUnmuted => 'Stummschaltung aufgehoben';

  @override
  String znErrMute(String error) {
    return 'Fehler beim Stummschalten: $error';
  }

  @override
  String znErrVolume(String error) {
    return 'Lautstärkefehler: $error';
  }

  @override
  String znErrLatency(String error) {
    return 'Latenzfehler: $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return 'Fehler bei der Gruppenlautstärke: $error';
  }

  @override
  String get znCalibrationDone => 'Kalibrierung abgeschlossen';

  @override
  String znErrCalibration(String error) {
    return 'Kalibrierungsfehler: $error';
  }

  @override
  String znErrDissolve(String error) {
    return 'Gruppe konnte nicht aufgelöst werden: $error';
  }

  @override
  String get znRenameGroupTitle => 'Gruppe umbenennen';

  @override
  String get znNewNameHint => 'Neuer Name';

  @override
  String get znRename => 'Umbenennen';

  @override
  String get znGroupRenamed => 'Gruppe umbenannt';

  @override
  String znErrRename(String error) {
    return 'Fehler beim Umbenennen: $error';
  }

  @override
  String get znGroupNeedTwoZones =>
      'Für eine Gruppe sind mindestens 2 Zonen nötig';

  @override
  String get znGroupNameLabel => 'Gruppenname';

  @override
  String get znGroupNameHint => 'z. B. Wohnzimmer + Küche';

  @override
  String get znChooseLeader => 'Leader auswählen';

  @override
  String get znMembers => 'Mitglieder';

  @override
  String znErrCreateGroup(String error) {
    return 'Gruppe konnte nicht erstellt werden: $error';
  }

  @override
  String get znProfileActivated => 'Profil aktiviert';

  @override
  String znErrActivate(String error) {
    return 'Fehler beim Aktivieren: $error';
  }

  @override
  String get znProfileDeleted => 'Profil gelöscht';

  @override
  String znErrDelete(String error) {
    return 'Fehler beim Löschen: $error';
  }

  @override
  String get znNoOfflineZones => 'Keine Offline-Zonen zu entfernen';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Offline-Zonen entfernt',
      one: '1 Offline-Zone entfernt',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return 'Fehler beim Aufräumen: $error';
  }

  @override
  String get znSaveConfigTitle => 'Konfiguration speichern';

  @override
  String get znProfileNameLabel => 'Profilname';

  @override
  String get znProfileNameHint => 'z. B. Party, Ruhiger Morgen';

  @override
  String get znDescriptionOptional => 'Beschreibung (optional)';

  @override
  String get znNameRequired => 'Ein Name ist erforderlich';

  @override
  String get znProfileSaved => 'Profil gespeichert';

  @override
  String znErrSave(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get znCleanupOffline => 'Offline-Zonen aufräumen';

  @override
  String get znRemoteRequired =>
      'Die Zonenverwaltung erfordert eine Verbindung zu einem entfernten Server.';

  @override
  String get znDataUnavailable => 'Daten nicht verfügbar';

  @override
  String get znGroups => 'Gruppen';

  @override
  String get znNoGroups => 'Keine Gruppen';

  @override
  String get znGroupFallback => 'Gruppe';

  @override
  String znZoneFallback(String id) {
    return 'Zone $id';
  }

  @override
  String get znCalibrate => 'Kalibrieren';

  @override
  String get znDissolve => 'Auflösen';

  @override
  String get znProfiles => 'Profile';

  @override
  String get znNoProfiles => 'Keine gespeicherten Profile';

  @override
  String get znSaveConfigButton => 'Konfiguration speichern';

  @override
  String get znProfileFallback => 'Profil';

  @override
  String get znPins => 'Pins';

  @override
  String znPinFallback(int n) {
    return 'Pin $n';
  }

  @override
  String znPinInvoked(int n) {
    return 'Pin $n gestartet';
  }

  @override
  String znPinInvokeError(String error) {
    return 'Pin konnte nicht gestartet werden: $error';
  }

  @override
  String get znNoPins => 'Keine Pins eingerichtet';

  @override
  String get znMute => 'Stummschalten';

  @override
  String get znUnmute => 'Ton einschalten';

  @override
  String get znLatency => 'Latenz';

  @override
  String get znLatencyError => 'Fehler';

  @override
  String znPartyAddError(String error) {
    return 'Titel konnte nicht hinzugefügt werden: $error';
  }

  @override
  String znPartyVoteError(String error) {
    return 'Fehler bei der Abstimmung: $error';
  }

  @override
  String get znPartyLinkCopied => 'Party-Link in die Zwischenablage kopiert';

  @override
  String get znPartyTitle => 'Party-Modus';

  @override
  String get znPartyShareLink => 'Party-Link teilen';

  @override
  String get znPartyAddHint => 'Titel hinzufügen…';

  @override
  String get znPartyQueue => 'Warteschlange';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Titel',
      one: '1 Titel',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => 'Unbekannte Zone';

  @override
  String get znUnknownTitle => 'Unbekannt';

  @override
  String get znNowPlaying => 'Läuft gerade';

  @override
  String get znUpvote => 'Hochvoten';

  @override
  String znDjLoadOnDeck(String deck) {
    return 'Titel auf Deck $deck laden';
  }

  @override
  String get znDjSearchHint => 'Titel suchen…';

  @override
  String get znDjSearchHelp =>
      'Titelnamen eingeben und auf „Suchen & laden“ tippen';

  @override
  String get znDjNoTracksFound => 'Keine Titel gefunden';

  @override
  String znDjSearchError(String error) {
    return 'Suchfehler: $error';
  }

  @override
  String get znDjSearchAndLoad => 'Suchen & laden';

  @override
  String znDjLoadError(String error) {
    return 'Ladefehler: $error';
  }

  @override
  String znDjPlayError(String error) {
    return 'Wiedergabefehler: $error';
  }

  @override
  String znDjPauseError(String error) {
    return 'Fehler beim Pausieren: $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return 'Überblendungsfehler: $error';
  }

  @override
  String get znDjTitle => 'DJ-Modus';

  @override
  String get znDjDisabled => 'Der DJ-Modus ist deaktiviert';

  @override
  String get znDjEnableHint =>
      'Aktivieren Sie ihn, um mit dem Mixen zu beginnen';

  @override
  String znDjDeck(String deck) {
    return 'Deck $deck';
  }

  @override
  String get znDjCrossfade => 'Überblendung';

  @override
  String znDjDuration(String seconds) {
    return 'Dauer: $seconds s';
  }

  @override
  String get znDjStartCrossfade => 'Überblendung starten';

  @override
  String get znDjAutoCrossfade => 'Automatische Überblendung';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return 'Sync $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => 'Synchronisierung fehlgeschlagen';

  @override
  String get znDjNoTrackLoaded => 'Kein Titel geladen';

  @override
  String get znDjLoadTrack => 'Titel laden';

  @override
  String get znDjGain => 'Pegel';

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
