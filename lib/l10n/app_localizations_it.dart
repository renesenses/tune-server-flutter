// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => 'OK';

  @override
  String get btnCancel => 'Annulla';

  @override
  String get btnAdd => 'Aggiungi';

  @override
  String get btnSave => 'Salva';

  @override
  String get btnDelete => 'Elimina';

  @override
  String get btnEdit => 'Modifica';

  @override
  String get btnClose => 'Chiudi';

  @override
  String get btnRetry => 'Riprova';

  @override
  String get btnCreate => 'Crea';

  @override
  String get btnClear => 'Cancella';

  @override
  String get btnNext => 'Avanti';

  @override
  String get btnSkip => 'Salta questo passaggio';

  @override
  String get btnFinish => 'Termina configurazione';

  @override
  String get btnStart => 'Inizia';

  @override
  String get btnConnect => 'Connetti';

  @override
  String get btnDisconnect => 'Disconnetti';

  @override
  String get btnDownload => 'Scarica';

  @override
  String get btnImport => 'Importa';

  @override
  String get btnExport => 'Esporta';

  @override
  String get btnReset => 'Ripristina';

  @override
  String get btnUse => 'Usa';

  @override
  String get btnShuffle => 'Casuale';

  @override
  String get btnSeeAll => 'Vedi tutto';

  @override
  String get btnRefresh => 'Aggiorna';

  @override
  String get btnScan => 'Scansiona libreria';

  @override
  String get btnAddFolder => 'Aggiungi cartella';

  @override
  String get actionIrreversible => 'Questa azione è irreversibile.';

  @override
  String get rootStartError => 'Errore di avvio';

  @override
  String get playbackErrorNoZone =>
      'Nessuna zona selezionata — crea o seleziona una zona';

  @override
  String get playbackErrorZoneNotFound => 'Zona non trovata';

  @override
  String get playbackErrorFailed => 'Riproduzione fallita';

  @override
  String zoneLimitReached(int limit) {
    return 'Piano gratuito limitato a $limit zone — passa a Premium per zone illimitate';
  }

  @override
  String zoneLimitOverCap(int current, int limit) {
    return 'Le tue $current zone continuano a funzionare, ma il piano gratuito ne consente $limit — eliminane una o passa a Premium per aggiungerne una nuova';
  }

  @override
  String get navLibrary => 'Libreria';

  @override
  String get navSearch => 'Ricerca';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navRadios => 'Radio';

  @override
  String get navZones => 'Zone';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get libraryTitle => 'Libreria';

  @override
  String get tabAlbums => 'Album';

  @override
  String get tabArtists => 'Artisti';

  @override
  String get tabTracks => 'Brani';

  @override
  String albumTracksDuration(int count, String duration) {
    return '$count tracce · $duration';
  }

  @override
  String get tabGenres => 'Generi';

  @override
  String get tabPlaylists => 'Playlist';

  @override
  String get tabFavorites => 'Preferiti';

  @override
  String get favoriteAdded => 'Aggiunto ai preferiti';

  @override
  String get favoriteRemoved => 'Rimosso dai preferiti';

  @override
  String get libraryEmptyFavorites => 'Nessun preferito';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => 'Nessun album nella libreria';

  @override
  String get libraryEmptyArtists => 'Nessun artista nella libreria';

  @override
  String get libraryEmptyTracks => 'Nessun brano nella libreria';

  @override
  String get libraryEmptyGenres => 'Nessun genere';

  @override
  String get libraryEmptyPlaylists => 'Nessuna playlist';

  @override
  String get libraryNoFilterResults => 'Nessun album corrisponde ai filtri';

  @override
  String get libraryPlayAll => 'Riproduci tutto';

  @override
  String get libraryAddTo => 'Aggiungi a…';

  @override
  String get libraryEditAlbum => 'Modifica album';

  @override
  String get libraryEditTrack => 'Modifica brano';

  @override
  String get libraryPlay => 'Riproduci';

  @override
  String get genresAllTracks => 'Tutti i brani';

  @override
  String get playlistCreate => 'Crea playlist';

  @override
  String get playlistName => 'Nome playlist';

  @override
  String get playlistEmpty => 'Nessun brano';

  @override
  String get playlistAddTo => 'Aggiungi a playlist';

  @override
  String get playlistNewPlaylist => 'Nuova playlist';

  @override
  String playlistTrackAdded(String name) {
    return 'Aggiunta a «$name»';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return 'Già presente in «$name»';
  }

  @override
  String playlistTracksAdded(int count, String name) {
    return '$count brani aggiunti a \"$name\"';
  }

  @override
  String get playlistAddAllTracks => 'Aggiungi tutto alla playlist';

  @override
  String get playlistDeleteTitle => 'Eliminare playlist?';

  @override
  String get playlistDeleteBody =>
      'Questa playlist verrà eliminata definitivamente.';

  @override
  String get searchHint => 'Cerca…';

  @override
  String get searchNoResults => 'Nessun risultato';

  @override
  String get searchTopResult => 'Risultato principale';

  @override
  String get searchSectionTracks => 'Brani';

  @override
  String get searchSectionAlbums => 'Album';

  @override
  String get searchSectionArtists => 'Artisti';

  @override
  String get searchSectionStreaming => 'Streaming';

  @override
  String get homeRecentlyPlayed => 'Riprodotto di recente';

  @override
  String get homeLibrary => 'Libreria';

  @override
  String get homeQuickAccess => 'Accesso rapido';

  @override
  String get homeHistory => 'Cronologia';

  @override
  String get homeBrowseDlna => 'Sfoglia DLNA';

  @override
  String get homeStatTracks => 'brani';

  @override
  String get homeStatAlbums => 'album';

  @override
  String get homeStatArtists => 'artisti';

  @override
  String get historyTitle => 'Cronologia';

  @override
  String get historyEmpty => 'Nessuna cronologia';

  @override
  String get historyClear => 'Cancella';

  @override
  String get historyClearTitle => 'Cancella cronologia';

  @override
  String get nowPlayingNoTrack => 'Nessun brano';

  @override
  String get queueTitle => 'Coda di riproduzione';

  @override
  String queueUpNextSummary(int count, String time) {
    return '$count in coda · $time';
  }

  @override
  String get queueEmpty => 'Coda vuota';

  @override
  String get queueClearTitle => 'Svuotare la coda?';

  @override
  String get queueClearBody =>
      'Tutti i brani verranno rimossi dalla coda di riproduzione.';

  @override
  String get zonesTitle => 'Zone';

  @override
  String get zonesNew => 'Nuova zona';

  @override
  String get zonesNewName => 'Nome zona';

  @override
  String get zonesNone => 'Nessuna zona';

  @override
  String get zonesRename => 'Rinomina zona';

  @override
  String get zonesDelete => 'Elimina zona';

  @override
  String get zonesDevices => 'Dispositivi disponibili';

  @override
  String get zonesOutputLocal => 'Locale';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesAirplayPair => 'Associa (codice PIN)';

  @override
  String get zonesAirplayPairTitle => 'Associazione AirPlay';

  @override
  String get zonesAirplayPairIntro =>
      'Alcuni TV (Samsung, LG) e l\'Apple TV mostrano un codice a 4 cifre sullo schermo. Avvia l\'associazione, poi inserisci il codice.';

  @override
  String get zonesAirplayPairWaiting =>
      'In attesa del codice mostrato sul dispositivo…';

  @override
  String get zonesAirplayPairEnterCode =>
      'Inserisci il codice mostrato sul dispositivo:';

  @override
  String get zonesAirplayPairStart => 'Avvia l\'associazione';

  @override
  String get zonesAirplayPairSubmit => 'Conferma codice';

  @override
  String get zonesAirplayPairRetry => 'Riprova';

  @override
  String get zonesOutputBluetooth => 'Bluetooth';

  @override
  String get zonesChangeOutput => 'Cambia uscita';

  @override
  String get zonesOutputTitle => 'Uscita audio';

  @override
  String get zonesAssignDevice => 'Assegna';

  @override
  String get zonesTransferTitle => 'Riproduci su...';

  @override
  String get zonesNowPlaying => 'In riproduzione qui';

  @override
  String zonesActivated(String name) {
    return 'Zona attiva: $name';
  }

  @override
  String get radiosTitle => 'Radio';

  @override
  String get radiosTabAll => 'Tutte';

  @override
  String get radiosTabFavorites => 'Preferite';

  @override
  String get radiosNone => 'Nessuna radio';

  @override
  String get radiosFavNone => 'Nessuna radio preferita';

  @override
  String get radiosSavedFavorites => 'Preferiti salvati';

  @override
  String get radiosAdd => 'Aggiungi una radio';

  @override
  String get radiosName => 'Nome';

  @override
  String get radiosStreamUrl => 'URL stream';

  @override
  String get radiosGenre => 'Genere (opzionale)';

  @override
  String get radiosPasteM3u => 'Incolla M3U';

  @override
  String get radiosImportUrl => 'Importa da URL';

  @override
  String get radiosImportUrlLabel => 'URL file M3U';

  @override
  String radiosImportResult(int count) {
    return '$count stazione/i importata/e';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'Errore HTTP $code';
  }

  @override
  String get radiosImportFailed => 'Impossibile scaricare il file';

  @override
  String get radiosFavSaved => 'Brano salvato';

  @override
  String get radioSaveFavorite => 'Salva brano';

  @override
  String get radioFavTitle => 'Preferiti radio';

  @override
  String get radioFavEmpty => 'Nessun preferito salvato';

  @override
  String get radioFavExportCsv => 'Esporta CSV';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get streamingConnected => 'Connesso';

  @override
  String get streamingNotConnected => 'Non connesso';

  @override
  String get streamingEmail => 'Email';

  @override
  String get streamingPassword => 'Password';

  @override
  String get streamingSignIn => 'Accedi';

  @override
  String get streamingSigningIn => 'Accesso in corso…';

  @override
  String get streamingDeviceCode => 'Codice di verifica';

  @override
  String get streamingOpenLink => 'Apri…';

  @override
  String get streamingLogoutTitle => 'Disconnettersi?';

  @override
  String streamingLogoutBody(String service) {
    return 'Disconnettersi da $service?';
  }

  @override
  String get streamingAuthError => 'Autenticazione fallita';

  @override
  String get streamingAlbumsSection => 'Album';

  @override
  String get streamingPlaylistsSection => 'Playlist';

  @override
  String get browseTitle => 'Sfoglia';

  @override
  String get browseRefreshTooltip => 'Aggiorna';

  @override
  String get browseNoServers => 'Nessun server UPnP/DLNA rilevato';

  @override
  String get browseNoServersHint =>
      'Assicurarsi che il server sia sulla stessa rete Wi-Fi.';

  @override
  String get browseNoContent => 'Cartella vuota';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLangSystem => 'Sistema';

  @override
  String get settingsSectionZones => 'Zone';

  @override
  String get settingsDefaultZone => 'Zona predefinita';

  @override
  String get settingsDefaultZoneAuto => 'Automatica';

  @override
  String get settingsNoZones => 'Nessuna zona';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsHttpPort => 'Porta HTTP';

  @override
  String get settingsHttpPortDesc => 'Porta server principale';

  @override
  String get settingsLocalIp => 'Indirizzo IP locale';

  @override
  String get settingsSectionLibrary => 'Libreria';

  @override
  String get settingsMetadata => 'Musica e Metadati';

  @override
  String get settingsMetadataDesc => 'Cartelle, scansione, statistiche';

  @override
  String get settingsSetupWizard => 'Assistente configurazione';

  @override
  String get settingsSetupWizardDesc => 'Riconfigura le sorgenti musicali';

  @override
  String get settingsSectionAbout => 'Informazioni';

  @override
  String get settingsVersion => 'Versione 0.1.0';

  @override
  String get settingsResetConfig => 'Ripristina configurazione';

  @override
  String get settingsResetTitle => 'Ripristinare?';

  @override
  String get settingsResetBody =>
      'Tutte le preferenze saranno ripristinate. L\'assistente di avvio apparirà al prossimo avvio.';

  @override
  String get settingsPortTitle => 'Porta HTTP';

  @override
  String get settingsPortHint => 'Porta (1024–65535)';

  @override
  String get metadataTitle => 'Musica e Metadati';

  @override
  String get metadataRefreshStats => 'Aggiorna statistiche';

  @override
  String get metadataSectionStats => 'Statistiche';

  @override
  String get metadataStatTracks => 'Brani';

  @override
  String get metadataStatAlbums => 'Album';

  @override
  String get metadataStatArtists => 'Artisti';

  @override
  String get metadataStatPlaylists => 'Playlist';

  @override
  String get metadataStatRadios => 'Radio';

  @override
  String get metadataStatArtwork => 'Cache copertine';

  @override
  String get metadataSectionScan => 'Scansione libreria';

  @override
  String metadataScanInProgress(int current, int total) {
    return 'Scansione in corso… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return 'Ultima scansione: +$added aggiunti, $updated aggiornati';
  }

  @override
  String get metadataScanBtn => 'Scansiona libreria';

  @override
  String get metadataScanDesc => 'Indicizza tutte le cartelle configurate';

  @override
  String get metadataSectionFolders => 'Cartelle musicali';

  @override
  String get metadataFoldersNone => 'Nessuna cartella configurata';

  @override
  String metadataFolderAddedOn(String date) {
    return 'Aggiunto il $date';
  }

  @override
  String get metadataAddFolder => 'Aggiungi cartella';

  @override
  String get metadataFolderPath => 'Percorso cartella';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => 'Pulizia';

  @override
  String get metadataCleanupOrphans => 'Elimina orfani';

  @override
  String get metadataCleanupOrphansDesc => 'Album e artisti senza brani';

  @override
  String get metadataClearLibrary => 'Svuota libreria';

  @override
  String get metadataClearLibraryDesc => 'Elimina tutti i brani locali';

  @override
  String get metadataCleanupOrphansTitle => 'Eliminare orfani?';

  @override
  String get metadataCleanupOrphansBody =>
      'Album e artisti senza brani associati verranno eliminati dal database.';

  @override
  String get metadataClearLibraryTitle => 'Svuotare libreria?';

  @override
  String get metadataClearLibraryBody =>
      'Tutti i brani, album e artisti locali saranno eliminati. Questa azione è irreversibile.';

  @override
  String get metadataOrphansDeleted => 'Orfani eliminati';

  @override
  String get metadataLibraryCleared => 'Libreria svuotata';

  @override
  String get metadataDeleteBtn => 'Elimina';

  @override
  String get metadataClearBtn => 'Svuota';

  @override
  String get setupWelcomeTitle => 'Benvenuto in\nTune Server';

  @override
  String get setupWelcomeBody =>
      'Il tuo server musicale multiroom integrato. Trasmetti la tua libreria locale, i tuoi servizi di streaming e le tue radio a qualsiasi altoparlante DLNA o AirPlay.';

  @override
  String get setupStart => 'Inizia';

  @override
  String get setupLocalTitle => 'Libreria locale';

  @override
  String get setupLocalBody =>
      'Indica il percorso di una cartella con i tuoi file audio (FLAC, MP3, AAC…). Puoi aggiungerne altri in Impostazioni.';

  @override
  String get setupFolderPath => 'Percorso cartella';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => 'Aggiungi questa cartella';

  @override
  String get setupFolderAdded => 'Cartella aggiunta — scansione in corso…';

  @override
  String get setupFolderEmpty => 'Inserisci un percorso di cartella';

  @override
  String get setupUPnPTitle => 'Server UPnP/DLNA';

  @override
  String get setupUPnPBody =>
      'Tune Server scopre automaticamente i server UPnP/DLNA sulla tua rete locale. Sfoglia le loro librerie in Ricerca → Sfoglia.';

  @override
  String get setupFeatureSsdp => 'Scoperta SSDP automatica';

  @override
  String get setupFeatureContentDir => 'Navigazione ContentDirectory';

  @override
  String get setupFeaturePlayback => 'Riproduzione diretta file DLNA';

  @override
  String get setupFinish => 'Termina configurazione';

  @override
  String get libraryPlayAlbum => 'Riproduci album';

  @override
  String get libraryPlayNext => 'Riproduci dopo';

  @override
  String radioFavExportDone(String path) {
    return 'CSV esportato: $path';
  }

  @override
  String get radioFavExportError => 'Errore di esportazione';

  @override
  String get streamingViewAlbum => 'Vedi album';

  @override
  String get streamingLogoutContent => 'Il tuo account verrà disconnesso.';

  @override
  String get streamingUrlCopied => 'URL copiato negli appunti';

  @override
  String get streamingDeviceCodeHint =>
      'Vai a questo URL e inserisci il codice sopra:';

  @override
  String get searchHintFull => 'Cerca artisti, album, brani…';

  @override
  String get browseNavError => 'Errore di navigazione';

  @override
  String get streamingCodeEntered => 'Ho inserito il codice';

  @override
  String get appleMusicAuthorize => 'Consenti accesso';

  @override
  String get smbNavTitle => 'Sorgente SMB';

  @override
  String get smbTitle => 'Connessione SMB';

  @override
  String get smbHostHint => 'Inserire l\'indirizzo del server SMB';

  @override
  String get smbHostLabel => 'Indirizzo IP (es: 192.168.1.23)';

  @override
  String get smbUser => 'Utente';

  @override
  String get smbPassword => 'Password';

  @override
  String get smbConnect => 'Connetti';

  @override
  String get smbSelectShare => 'Seleziona condivisione';

  @override
  String get smbBack => 'Indietro';

  @override
  String get smbManualHint =>
      'Impossibile elencare le condivisioni automaticamente.\nInserire il nome manualmente:';

  @override
  String get smbShareName => 'Nome condivisione (es: Share, Music)';

  @override
  String get smbScan => 'Scansiona';

  @override
  String get smbScanning => 'Scansione in corso…';

  @override
  String smbScanCount(int count) {
    return '$count file audio trovati';
  }

  @override
  String get smbDoneTitle => 'Indicizzazione completata';

  @override
  String smbDoneBody(int count, String share) {
    return '$count tracce importate da $share';
  }

  @override
  String get smbAddAnother => 'Aggiungi un\'altra condivisione';

  @override
  String get settingsSmb => 'Sorgenti SMB / Samba';

  @override
  String get settingsSmbDesc => 'Indicizza librerie da condivisioni di rete';

  @override
  String get podcastsTitle => 'Podcast';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => 'Cerca';

  @override
  String get podcastsEmpty => 'Nessun podcast';

  @override
  String get podcastsSearchHint => 'Cerca un podcast…';

  @override
  String get podcastsNoEpisodes => 'Nessun episodio';

  @override
  String get navPodcasts => 'Podcast';

  @override
  String get streamingConnectedSuccess => 'Connesso!';

  @override
  String browseItemCount(int count) {
    return '$count elementi';
  }

  @override
  String get settingsSources => 'Sorgenti e dispositivi';

  @override
  String get settingsSourcesDesc => 'Server UPnP, renderer DLNA';

  @override
  String get sourcesTitle => 'Sorgenti e dispositivi';

  @override
  String get sourcesServersSection => 'Server di contenuti UPnP';

  @override
  String get sourcesRenderersSection => 'Renderer DLNA';

  @override
  String get sourcesNoDevices => 'Nessun dispositivo trovato';

  @override
  String get sourcesTypeServer => 'Server';

  @override
  String get sourcesTypeRenderer => 'Renderer';

  @override
  String get sourcesAvailable => 'Disponibile';

  @override
  String get sourcesUnavailable => 'Non in linea';

  @override
  String get sourcesIndexBtn => 'Indicizza libreria';

  @override
  String get sourcesRescanBtn => 'Riscansiona';

  @override
  String get sourcesForget => 'Dimentica';

  @override
  String get sourcesAddManually => 'Aggiungi manualmente';

  @override
  String get sourcesAddTitle => 'Scansione manuale';

  @override
  String get sourcesIpLabel => 'Indirizzo IP';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => 'Porta';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => 'Scansione in corso…';

  @override
  String get sourcesNotFound =>
      'Nessun dispositivo UPnP trovato a questo indirizzo';

  @override
  String get zonesMultiRoom => 'Multi-Room';

  @override
  String get zonesCreateGroup => 'Crea gruppo';

  @override
  String get zonesGroupLeader => 'Leader';

  @override
  String get zonesGroupFollower => 'Follower';

  @override
  String get zonesGroupDissolve => 'Dissolvi gruppo';

  @override
  String get zonesGroupSyncDelay => 'Ritardo di sincronizzazione';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => 'Seleziona zone';

  @override
  String get zonesGroupSelectLeader => 'Seleziona leader';

  @override
  String get zonesGroupNoZones => 'Nessun gruppo attivo';

  @override
  String get zonesGroupNeedTwo => 'Seleziona almeno 2 zone';

  @override
  String get zonesGroupCreated => 'Gruppo creato';

  @override
  String get zonesGroupDissolved => 'Gruppo dissolto';

  @override
  String get metadataSectionEnrich => 'Arricchire';

  @override
  String get metadataSectionDuplicates => 'Duplicati';

  @override
  String get metadataSectionCorrect => 'Correggere';

  @override
  String get metadataFilterAll => 'Tutti';

  @override
  String get metadataFilterMissingCover => 'Cover mancanti';

  @override
  String get metadataFilterMissingGenre => 'Genere mancante';

  @override
  String get metadataFilterMissingYear => 'Anno mancante';

  @override
  String get metadataFilterMissingArtist => 'Artista mancante';

  @override
  String get metadataFilterDoubtful => 'Dubbi';

  @override
  String get metadataSearchHint => 'Cerca album…';

  @override
  String get metadataArtistFilter => 'Artista';

  @override
  String get metadataGenreFilter => 'Genere';

  @override
  String get metadataAllArtists => 'Tutti gli artisti';

  @override
  String get metadataAllGenres => 'Tutti i generi';

  @override
  String get metadataNoAlbums => 'Nessun album corrispondente';

  @override
  String get metadataEditAlbum => 'Modifica album';

  @override
  String get metadataSaveChanges => 'Salva';

  @override
  String get metadataWriteTags => 'Scrivi tag';

  @override
  String metadataWriteTagsSuccess(int count) {
    return 'Tag scritti: $count file';
  }

  @override
  String get metadataMergeGroup => 'Unisci';

  @override
  String metadataMergeConfirm(int count) {
    return 'Unire questi $count album? Verrà mantenuto quello con più brani.';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return 'Unito: $moved brani spostati, $total totali';
  }

  @override
  String get metadataUploadCover => 'Carica cover';

  @override
  String get metadataCoverUploaded => 'Cover caricata';

  @override
  String get metadataAlbumSaved => 'Album salvato';

  @override
  String metadataDupAlbums(int count) {
    return '$count album duplicati';
  }

  @override
  String get metadataDoubtfulReasons => 'Problemi';

  @override
  String get metadataArtistField => 'Artista';

  @override
  String get metadataAlbumField => 'Album';

  @override
  String get metadataGenreField => 'Genere';

  @override
  String get metadataYearField => 'Anno';

  @override
  String metadataTracksCount(int count) {
    return '$count brani';
  }

  @override
  String get stereoPairsTitle => 'Coppie stereo';

  @override
  String get stereoPairCreate => 'Crea coppia stereo';

  @override
  String get stereoPairName => 'Nome della coppia';

  @override
  String get stereoPairNameHint => 'Es: Salotto Stereo';

  @override
  String get stereoPairLeft => 'Sinistra (L)';

  @override
  String get stereoPairRight => 'Destra (R)';

  @override
  String get stereoPairSelectDevice => 'Seleziona dispositivo';

  @override
  String get stereoPairNone => 'Nessuna coppia stereo';

  @override
  String get stereoPairCreated => 'Coppia stereo creata';

  @override
  String get stereoPairDissolved => 'Coppia stereo sciolta';

  @override
  String get stereoPairDissolve => 'Sciogliere';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => 'Attiva';

  @override
  String get streamingDisable => 'Disattiva';

  @override
  String get streamingEnabled => 'Servizio attivato';

  @override
  String get streamingDisabled => 'Servizio disattivato';

  @override
  String get onboardingWelcomeTitle => 'Benvenuto su Tune!';

  @override
  String get onboardingWelcomeBody =>
      'Il tuo server musicale multiroom integrato. Configuriamo la tua installazione in pochi passaggi.';

  @override
  String get onboardingWelcomeStart => 'Inizia';

  @override
  String get onboardingConfigTitle => 'Configurazione';

  @override
  String get onboardingConfigBody =>
      'Specifica una cartella con i tuoi file audio o connettiti a un server Tune remoto.';

  @override
  String get onboardingConfigModeLocal => 'Server integrato';

  @override
  String get onboardingConfigModeRemote => 'Server remoto';

  @override
  String get onboardingZoneTitle => 'Crea una zona';

  @override
  String get onboardingZoneBody =>
      'I dispositivi qui sotto sono stati scoperti nella tua rete. Toccane uno per creare la tua prima zona audio.';

  @override
  String get onboardingZoneEmpty =>
      'Nessun dispositivo scoperto finora. Puoi aggiungerne altri in seguito.';

  @override
  String onboardingZoneCreated(String name) {
    return 'Zona creata: $name';
  }

  @override
  String get onboardingDoneTitle => 'Fatto!';

  @override
  String get onboardingDoneBody =>
      'La tua configurazione è pronta. Goditi la tua musica!';

  @override
  String get onboardingDoneButton => 'Vai alla dashboard';

  @override
  String get artistBio => 'Biografia';

  @override
  String get artistAnecdotes => 'Aneddoti';

  @override
  String get artistSimilarArtists => 'Artisti simili';

  @override
  String get artistMembers => 'Membri';

  @override
  String get artistDiscography => 'Discografia';

  @override
  String get artistEnriching => 'Arricchimento in corso…';

  @override
  String get artistGenres => 'Generi';

  @override
  String get libraryShuffleAll => 'Riproduzione casuale';

  @override
  String get librarySortBy => 'Ordina per';

  @override
  String get librarySortTitle => 'Titolo';

  @override
  String get librarySortArtist => 'Artista';

  @override
  String get librarySortYear => 'Anno';

  @override
  String get librarySortOriginalYear => 'Anno originale';

  @override
  String get librarySortAddedDate => 'Data di aggiunta';

  @override
  String get librarySortAscending => 'Crescente';

  @override
  String get librarySortDescending => 'Decrescente';

  @override
  String get addFavorite => 'Aggiungi ai preferiti';

  @override
  String get addFolder => 'Aggiungi una cartella';

  @override
  String get addThisFolder => 'Aggiungi questa cartella';

  @override
  String get addToPlaylist => 'Aggiungi a una playlist';

  @override
  String get addedToPlaylist => 'Aggiunto alla playlist';

  @override
  String get audioOutput => 'Uscita audio';

  @override
  String get audioOutputDesc =>
      'Ogni zona del server è un\'uscita (ALSA locale, renderer Diretta…). Scegli la zona su cui riprodurre.';

  @override
  String get authorizeInBrowser => 'Autorizza l\'accesso nel browser:';

  @override
  String get cancel => 'Annulla';

  @override
  String get connect => 'Connetti';

  @override
  String get connected => 'Connesso';

  @override
  String get cover => 'Copertina';

  @override
  String get create => 'Crea';

  @override
  String get createPlaylist => 'Crea una playlist';

  @override
  String get delete => 'Elimina';

  @override
  String get deletePlaylist => 'Elimina playlist';

  @override
  String get deletePlaylistConfirm => 'Eliminare questa playlist?';

  @override
  String get disabled => 'Disattivato';

  @override
  String get disconnected => 'Non connesso';

  @override
  String get done => 'Ho finito';

  @override
  String get dynamicPlaylists => 'Playlist dinamiche';

  @override
  String get dynamicTag => 'Dinamica';

  @override
  String errorWith(String msg) {
    return 'Errore: $msg';
  }

  @override
  String favError(String msg) {
    return 'Preferito non riuscito: $msg';
  }

  @override
  String get favoritesTitle => 'Preferiti';

  @override
  String get filterAll => 'Tutto';

  @override
  String get freqLimit => 'Limite di frequenza';

  @override
  String get gapless => 'Riproduzione senza pause';

  @override
  String get gaplessDesc =>
      'Disattiva se senti rumore bianco / interruzioni tra i brani su questo renderer.';

  @override
  String get host => 'Host';

  @override
  String get language => 'Lingua';

  @override
  String get loading => 'Caricamento…';

  @override
  String get localLibrary => 'Libreria locale';

  @override
  String get localLibraryDesc => 'Cartelle in cui il server cerca la musica';

  @override
  String get logIn => 'Accedi';

  @override
  String get logOut => 'Disconnetti';

  @override
  String loginTo(String service) {
    return 'Accedi a $service';
  }

  @override
  String get maxBitDepth => 'Profondità max';

  @override
  String get maxFrequency => 'Frequenza max';

  @override
  String maxTracks(int n) {
    return 'max $n';
  }

  @override
  String get metadataFields => 'Campi metadati';

  @override
  String get metadataFieldsDesc => 'Info mostrate per la libreria locale';

  @override
  String get metadataSaved => 'Metadati salvati';

  @override
  String get musicFolders => 'Cartelle scansionate';

  @override
  String get navFavorites => 'Preferiti';

  @override
  String get navPlaylists => 'Playlist';

  @override
  String get newPlaylist => 'Nuova playlist';

  @override
  String get noFavAlbums => 'Nessun album preferito';

  @override
  String get noFavArtists => 'Nessun artista preferito';

  @override
  String get noFavTracks => 'Nessun brano preferito';

  @override
  String get noFolders => 'Nessuna cartella configurata';

  @override
  String get noLimit => 'Nessun limite';

  @override
  String get noPlaylists => 'Nessuna playlist';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get noService => 'Nessun servizio';

  @override
  String get noTracks => 'Nessun brano';

  @override
  String get noZones => 'Nessuna zona disponibile';

  @override
  String get notConnected => 'Configura il server nelle Impostazioni';

  @override
  String get nothingPlaying => 'Niente in riproduzione';

  @override
  String get openAuthPage => 'Apri la pagina di autorizzazione';

  @override
  String get password => 'Password';

  @override
  String get pickFolder => 'Scegli una cartella';

  @override
  String get playAll => 'Riproduci tutto';

  @override
  String get playlistCreated => 'Playlist creata';

  @override
  String get playlistDeleted => 'Playlist eliminata';

  @override
  String get playlistsTitle => 'Playlist';

  @override
  String get port => 'Porta';

  @override
  String get qualityCd => 'CD (44.1 kHz / 16 bit)';

  @override
  String get qualityHires => 'Hi-Res (fino a 192 kHz)';

  @override
  String get qualityMax => 'Massima';

  @override
  String get removeFavorite => 'Rimuovi dai preferiti';

  @override
  String get removeFromPlaylist => 'Rimuovi dalla playlist';

  @override
  String get runScan => 'Scansiona libreria';

  @override
  String get scanning => 'Scansione…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · la tua libreria';

  @override
  String get searchEmptyTitle => 'Cerca un titolo, un album o un artista';

  @override
  String get searchTitle => 'Cerca';

  @override
  String get sectionAlbums => 'Album';

  @override
  String get sectionArtists => 'Artisti';

  @override
  String get sectionPlaylists => 'Playlist';

  @override
  String get sectionTracks => 'Brani';

  @override
  String get server => 'Server';

  @override
  String get sourceLibrary => 'Libreria';

  @override
  String get streamingQuality => 'Qualità streaming';

  @override
  String get streamingQualityDesc =>
      'Limita la frequenza / risoluzione richiesta ai servizi (Qobuz, Tidal…).';

  @override
  String get streamingServices => 'Servizi di streaming';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get trackRemoved => 'Rimosso dalla playlist';

  @override
  String tracksCount(int n) {
    return '$n brani';
  }

  @override
  String get username => 'Nome utente';

  @override
  String get visualizer => 'Visualizzatore';

  @override
  String get licenseSessionConflictTitle => 'Licenza attiva su un altro server';

  @override
  String get licenseSessionConflictBody =>
      'La tua licenza Tune è già in uso su un altro dei tuoi server. Questo server tornerà a Premium automaticamente qualche minuto dopo l\'arresto dell\'altro.';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'La tua licenza Tune è attiva su «$server». Questo server tornerà a Premium automaticamente qualche minuto dopo l\'arresto dell\'altro.';
  }

  @override
  String cfgSaveError(String detail) {
    return 'Errore di salvataggio: $detail';
  }

  @override
  String get cfgReload => 'Ricarica';

  @override
  String get cfgFieldsLoadError => 'Impossibile caricare i campi';

  @override
  String get cfgFieldsNone => 'Nessun campo disponibile';

  @override
  String get cfgFieldsHint =>
      'Scegli quali campi di metadati mostrare nell\'editor dei brani.';

  @override
  String get cfgMetaCompleteness => 'Completezza dei metadati';

  @override
  String get cfgMetaEnrichMusicBrainz => 'Arricchisci con MusicBrainz';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'Arricchimento MusicBrainz';

  @override
  String get cfgMetaFixYearsTidal => 'Correggi anni (TIDAL)';

  @override
  String get cfgMetaFixYearsDiscogs => 'Correggi anni (Discogs)';

  @override
  String get cfgMetaFixGenres => 'Correggi generi';

  @override
  String get cfgMetaAutoFixAlbums => 'Correggi album automaticamente';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggerimenti in attesa',
      one: '1 suggerimento in attesa',
      zero: 'Nessun suggerimento in attesa',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => 'Accetta tutto';

  @override
  String get cfgMetaSuggestions => 'Suggerimenti';

  @override
  String get cfgMetaScanDuplicates => 'Cerca duplicati';

  @override
  String get cfgMetaAutoMerge => 'Unione automatica';

  @override
  String get cfgMetaMergeDuplicatesTask => 'Unione dei duplicati';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$count album duplicati ($groups gruppi)',
      one: '$count album duplicati (1 gruppo)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… e altri $count gruppi',
      one: '… e 1 altro gruppo',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => 'Ultimo risultato';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct% completo';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label: errore — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label: $count accettati';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label: $fixed/$total corretti';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label: $fixed corretti';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label: $total elaborati';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label: completato';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return 'Errore di scrittura dei tag: $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return 'Errore di caricamento: $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Unire $count album?',
      one: 'Unire 1 album?',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody =>
      'Verrà mantenuto l\'album con più brani; gli altri saranno eliminati.';

  @override
  String cfgMetaMergeError(String detail) {
    return 'Errore durante l\'unione: $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => 'Statistiche non disponibili';

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
      other: '… e altri $count album (filtra per restringere)',
      one: '… e 1 altro album (filtra per restringere)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count brani';
  }

  @override
  String get cfgMetaReasonArtistUppercase => 'Artista in maiuscolo';

  @override
  String get cfgMetaReasonArtistPlaceholder => 'Artista provvisorio';

  @override
  String get cfgMetaReasonArtistHasYear => 'Artista = cartella';

  @override
  String get cfgMetaReasonGenrePlaceholder => 'Genere provvisorio';

  @override
  String get cfgMetaReasonYearSuspicious => 'Anno sospetto';

  @override
  String get cfgMetaReasonTitleUppercase => 'Titolo in maiuscolo';

  @override
  String get cfgMetaReasonArtistMismatch => 'Artista non corrispondente';

  @override
  String get cfgSmbNotConnected => 'Non connesso a un server remoto';

  @override
  String cfgSmbMountTitle(String name) {
    return 'Monta $name';
  }

  @override
  String get cfgSmbMount => 'Monta';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name montato';
  }

  @override
  String get cfgSmbTitle => 'Condivisioni di rete (SMB)';

  @override
  String get cfgSmbSearching => 'Ricerca di condivisioni SMB…';

  @override
  String get cfgSmbNone => 'Nessuna condivisione SMB trovata';

  @override
  String get cfgSmbSaveCredentials => 'Salva credenziali';

  @override
  String get cfgUnknown => 'Sconosciuto';

  @override
  String get cfgEqTitle => 'Equalizzatore';

  @override
  String get cfgEqTabAssistant => 'Assistente';

  @override
  String get cfgEqTabExpert => 'Esperto';

  @override
  String cfgEqError(String detail) {
    return 'Errore dell\'equalizzatore: $detail';
  }

  @override
  String get cfgEqPresetFlat => 'Piatto';

  @override
  String get cfgEqPresetBassBoost => 'Bassi potenziati';

  @override
  String get cfgEqPresetClassical => 'Classica';

  @override
  String get cfgEqPresetVocal => 'Voce';

  @override
  String get cfgNotConnectedToServer => 'Non connesso al server';

  @override
  String get cfgCredentialsRequired =>
      'Nome utente e password sono obbligatori';

  @override
  String cfgServiceConnected(String service) {
    return '$service connesso.';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service disconnesso.';
  }

  @override
  String get cfgLastfmTitle => 'Scrobbling Last.fm';

  @override
  String get cfgLastfmDesc =>
      'Invia la cronologia di ascolto a Last.fm. I brani vengono registrati automaticamente quando sono riprodotti in qualsiasi zona.';

  @override
  String get cfgDisconnecting => 'Disconnessione…';

  @override
  String get cfgConnectHeader => 'CONNESSIONE';

  @override
  String get cfgConnecting => 'Connessione…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scrobble',
      one: '1 scrobble',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return 'Ultimo: $date';
  }

  @override
  String get cfgTokenRequired => 'Inserisci il tuo token utente';

  @override
  String get cfgScrobblerUnavailable => 'Scrobbler non disponibile';

  @override
  String cfgConnectedAs(String name) {
    return 'Connesso come $name';
  }

  @override
  String get cfgListenbrainzDesc =>
      'Invia la cronologia di ascolto a ListenBrainz. Ottieni il tuo token utente su listenbrainz.org/settings.';

  @override
  String get cfgUserToken => 'Token utente';

  @override
  String get cfgValidating => 'Verifica…';

  @override
  String get cfgSaveAndConnect => 'Salva e connetti';

  @override
  String get cfgScrobbleAuto => 'I brani verranno registrati automaticamente';

  @override
  String cfgConfigExported(String path) {
    return 'Configurazione esportata: $path';
  }

  @override
  String get cfgConfigImported => 'Configurazione importata correttamente';

  @override
  String cfgImportError(String detail) {
    return 'Errore d\'importazione: $detail';
  }

  @override
  String get cfgConfigExportDesc =>
      'Salva la configurazione del server in un file JSON.';

  @override
  String get cfgConfigExportJson => 'Esporta JSON';

  @override
  String get cfgConfigImportDesc =>
      'Ripristina una configurazione da un file JSON.';

  @override
  String get cfgChooseFile => 'Scegli un file';

  @override
  String get cfgDbNoServer => 'Nessun server connesso.';

  @override
  String cfgDbExportOk(String size, String path) {
    return 'Esportazione riuscita: $size MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => 'Percorso del file non accessibile.';

  @override
  String get cfgDbImportConfirmTitle => 'Conferma l\'importazione';

  @override
  String cfgDbImportConfirmBody(String name) {
    return 'Sostituire il database del server con «$name»?\n\nVerrà creato automaticamente un backup di sicurezza. Il server dovrà essere riavviato dopo l\'importazione.';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return 'Importazione riuscita: $size MB ($engine).\nRiavvia il server per applicare le modifiche.';
  }

  @override
  String get cfgDbTitle => 'Database';

  @override
  String get cfgDbIntro =>
      'Esporta o importa il database del server connesso.\nSQLite: file .db. PostgreSQL: dump SQL.';

  @override
  String get cfgDbExporting => 'Esportazione in corso…';

  @override
  String get cfgDbExportBtn => 'Esporta il database';

  @override
  String get cfgDbImporting => 'Importazione in corso…';

  @override
  String get cfgDbImportBtn => 'Importa un file';

  @override
  String get cfgDbFooter =>
      'Dopo un\'importazione, riavvia il server per applicare le modifiche. Prima della sostituzione viene creato automaticamente un backup di sicurezza.';

  @override
  String cfgStatusUnavailable(String detail) {
    return 'Stato non disponibile: $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune appare come ricevitore Spotify Connect sulla rete locale. Nell\'app Spotify, seleziona «Tune (…)» nell\'elenco dei dispositivi. È richiesto un account Spotify Premium sul client.';

  @override
  String get cfgSpotifyNoLibrespot => 'librespot non rilevato sul server';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      'Reinstalla Tune Server dal tarball/zip ufficiale per includere il binario, oppure installalo separatamente (apt install librespot / brew install librespot).';

  @override
  String get cfgTargetZone => 'Zona di destinazione';

  @override
  String get cfgDeviceName => 'Nome del dispositivo';

  @override
  String get cfgPlaying => 'In riproduzione';

  @override
  String get cfgNetDiagTitle => 'Diagnostica di rete';

  @override
  String get cfgNetSsdpActive => 'SSDP attivo';

  @override
  String get cfgNetMulticastReachable => 'Multicast raggiungibile';

  @override
  String get cfgError => 'Errore';

  @override
  String get cfgNetResolution => 'Risoluzione';

  @override
  String get cfgNetLatency => 'Latenza';

  @override
  String get cfgNetPublicIp => 'IP pubblico';

  @override
  String get cfgNetInterfaces => 'INTERFACCE DI RETE';

  @override
  String get cfgStatusWarning => 'Attenzione';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total album';
  }

  @override
  String get libNoCollectionsYet => 'Ancora nessuna collezione';

  @override
  String libRatingError(String error) {
    return 'Errore di valutazione: $error';
  }

  @override
  String libDisc(int disc) {
    return 'Disco $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return 'Disco $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => 'Preferito rapido';

  @override
  String get libAddToCollection => 'Aggiungi a una collezione';

  @override
  String get libAlbumNotes => 'Note dell’album';

  @override
  String get libCredits => 'Crediti';

  @override
  String get libNoCredits => 'Nessun credito';

  @override
  String get libNoAlbumNotes => 'Nessuna nota disponibile per questo album';

  @override
  String get libNoNotes => 'Nessuna nota disponibile';

  @override
  String get libSourceCommunity => 'Community Tune';

  @override
  String libBioSource(String source) {
    return 'Fonte: $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return 'Fonte: $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied =>
      'Accesso alla libreria di Apple Music negato.';

  @override
  String get libAppleMusicPermissionRefused =>
      'Autorizzazione negata. Attiva l’accesso in Impostazioni > Privacy > Media e Apple Music.';

  @override
  String get libUnknownError => 'Errore sconosciuto';

  @override
  String get libAppleMusicAccessTitle => 'Accesso ad Apple Music';

  @override
  String get libAppleMusicAccessBody =>
      'Consenti l’accesso alla tua libreria musicale per riprodurre i brani di Apple Music.';

  @override
  String get libAppleMusicEmpty => 'La libreria di Apple Music è vuota';

  @override
  String get libReportImageTitle => 'Segnala immagine';

  @override
  String get libReportImageBody =>
      'Segnalare questa immagine dell’artista come errata? Il server la sostituirà al prossimo arricchimento.';

  @override
  String get libReportAction => 'Segnala';

  @override
  String get libImageReported => 'Immagine segnalata';

  @override
  String libServiceAlbums(String service) {
    return 'Album $service';
  }

  @override
  String libTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return '$_temp0';
  }

  @override
  String get libDuplicateScanner => 'Ricerca duplicati';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$groups gruppi di duplicati trovati',
      one: '1 gruppo di duplicati trovato',
    );
    return '$_temp0 ($tracks brani in totale)';
  }

  @override
  String get libFindDuplicatesTitle => 'Trova brani duplicati';

  @override
  String get libFindDuplicatesBody =>
      'Analizza gli hash del contenuto audio per trovare brani identici nella tua libreria.';

  @override
  String get libStartScan => 'Avvia scansione';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total brani ($percent%)';
  }

  @override
  String get libLoadingTracks => 'Caricamento brani…';

  @override
  String get libNoDuplicatesFound => 'Nessun duplicato trovato';

  @override
  String get libLibraryClean => 'La tua libreria è pulita.';

  @override
  String get libScanAgain => 'Scansiona di nuovo';

  @override
  String get libScanFailed => 'Scansione non riuscita';

  @override
  String get libTrackNumberField => 'Traccia n.';

  @override
  String get libDiscNumberField => 'Disco n.';

  @override
  String get libExtendedMetadata => 'Metadati estesi';

  @override
  String get libGenreTreeSaved => 'Albero dei generi salvato';

  @override
  String libSaveError(String error) {
    return 'Errore durante il salvataggio: $error';
  }

  @override
  String get libGenreTree => 'Albero dei generi';

  @override
  String get libAddRootGenre => 'Aggiungi genere principale';

  @override
  String get libGenreTreeRequiresRemote =>
      'L’albero dei generi richiede la connessione a un server remoto.';

  @override
  String get libNoGenreHierarchy => 'Nessuna gerarchia di generi definita';

  @override
  String libAddSubGenreTo(String parent) {
    return 'Aggiungi sottogenere a “$parent”';
  }

  @override
  String get libGenreName => 'Nome del genere';

  @override
  String libSubGenreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sottogeneri',
      one: '1 sottogenere',
    );
    return '$_temp0';
  }

  @override
  String get libAddSubGenre => 'Aggiungi sottogenere';

  @override
  String get libRemove => 'Rimuovi';

  @override
  String libRemoveNamedConfirm(String name) {
    return 'Rimuovere “$name”?';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verranno rimossi anche tutti i suoi $count sottogeneri.',
      one: 'Verrà rimosso anche il suo sottogenere.',
    );
    return '$_temp0';
  }

  @override
  String get libRemoveGenreBody => 'Questo genere verrà rimosso dall’albero.';

  @override
  String libAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count album',
      one: '1 album',
    );
    return '$_temp0';
  }

  @override
  String get libNoTracksForFilter => 'Nessun brano corrisponde al filtro';

  @override
  String get libQualityLossless => 'Lossless';

  @override
  String get libQualityLossy => 'Lossy';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total brani';
  }

  @override
  String get libNewCollection => 'Nuova collezione';

  @override
  String get libCollectionName => 'Nome della collezione';

  @override
  String libCreateError(String error) {
    return 'Errore di creazione: $error';
  }

  @override
  String libDeleteError(String error) {
    return 'Errore di eliminazione: $error';
  }

  @override
  String get libCollectionsTitle => 'Collezioni';

  @override
  String get libCollectionsLoadFailed => 'Impossibile caricare le collezioni';

  @override
  String get libDeleteCollectionTitle => 'Eliminare la collezione?';

  @override
  String libDeleteCollectionBody(String name) {
    return '“$name” verrà eliminata definitivamente.';
  }

  @override
  String get libNoAlbumsInCollection => 'Nessun album in questa collezione';

  @override
  String get libDeleteConfirmTitle => 'Eliminare?';

  @override
  String get libDeleteSmartCollectionBody =>
      'Questa collezione smart verrà eliminata definitivamente.';

  @override
  String get libNoRules => 'nessuna regola';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return 'credito: $role=$artist';
  }

  @override
  String get libAnd => 'E';

  @override
  String get libOr => 'O';

  @override
  String get libSmartCollections => 'Collezioni smart';

  @override
  String get libNewSmartCollection => 'Nuova collezione smart';

  @override
  String get libNoSmartCollections => 'Nessuna collezione smart';

  @override
  String get libSmartCollectionsSeedHint =>
      'Di solito il server crea 7 collezioni predefinite al primo avvio.';

  @override
  String get libCreateFirstSmartCollection =>
      'Crea la mia prima collezione smart';

  @override
  String get libNoMatchingAlbums => 'Nessun album corrispondente';

  @override
  String get libSmartCreditsHint =>
      'Per le regole basate sui crediti (engineer, performer, …), arricchisci prima la libreria dalle Impostazioni.';

  @override
  String get libFieldSampleRate => 'Frequenza di campionamento';

  @override
  String get libFieldBitDepth => 'Profondità di bit';

  @override
  String get libFieldTrackCount => 'N. di brani';

  @override
  String get libFieldFormat => 'Formato';

  @override
  String get libFieldLabel => 'Etichetta';

  @override
  String get libFieldAlbumTitle => 'Titolo dell’album';

  @override
  String get libFieldSource => 'Fonte';

  @override
  String get libFieldCredit => 'Credito';

  @override
  String get libFieldPlayCount => 'N. di ascolti';

  @override
  String get libFieldLastPlayed => 'Ultimo ascolto';

  @override
  String get libOpBetween => 'tra';

  @override
  String get libOpContains => 'contiene';

  @override
  String get libOpStartsWith => 'inizia con';

  @override
  String get libOpEmpty => 'vuoto';

  @override
  String get libOpNotEmpty => 'non vuoto';

  @override
  String get libOpNever => 'mai';

  @override
  String get libOpAfter => 'dopo';

  @override
  String get libOpBefore => 'prima';

  @override
  String get libNameLabel => 'Nome';

  @override
  String get libMatchMode => 'Combinazione';

  @override
  String get libMatchAll => 'Tutte le regole (E)';

  @override
  String get libMatchAny => 'Almeno una (O)';

  @override
  String get libAddRule => 'Aggiungi una regola';

  @override
  String get libMatchingAlbumsPending => '… album corrispondenti';

  @override
  String libMatchingAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count album corrispondenti',
      one: '1 album corrispondente',
    );
    return '$_temp0';
  }

  @override
  String get libTimestampHint => 'now-30d o 2024-01-01';

  @override
  String get libValueHint => 'valore';

  @override
  String get libMinHint => 'min';

  @override
  String get libMaxHint => 'max';

  @override
  String get libCommaSeparatedHint => 'valori separati da virgole';

  @override
  String get libCreditRoleHint => 'ruolo (engineer, performer, …)';

  @override
  String get libCreditArtistHint => 'artista (Rudy Van Gelder, …)';

  @override
  String get libCreditInstrumentHint => 'strumento (Piano, …) — facoltativo';

  @override
  String get libDirectories => 'Cartelle';

  @override
  String get libLoadError => 'Errore di caricamento';

  @override
  String get libNoFolders => 'Nessuna cartella';

  @override
  String get libAddFoldersInSettings =>
      'Aggiungi cartelle musicali nelle Impostazioni';

  @override
  String get libFoldersHeader => 'Cartelle';

  @override
  String libTracksHeaderCount(int count) {
    return 'Brani ($count)';
  }

  @override
  String get libPlayFromHere => 'Riproduci da qui';

  @override
  String get libTags => 'Tag';

  @override
  String get libNewTagHint => 'Nuovo tag…';

  @override
  String get libJustNow => 'Proprio ora';

  @override
  String libMinutesAgo(int count) {
    return '$count min fa';
  }

  @override
  String libHoursAgo(int count) {
    return '$count h fa';
  }

  @override
  String get libYesterday => 'Ieri';

  @override
  String libDaysAgo(int count) {
    return '$count g fa';
  }

  @override
  String get libNowListening => 'In ascolto';

  @override
  String get libContinueListening => 'Continua ad ascoltare';

  @override
  String get libRecentlyAdded => 'Aggiunti di recente';

  @override
  String get libTopTracks => 'Brani più ascoltati';

  @override
  String get libTopArtists => 'Artisti più ascoltati';

  @override
  String get libRecommendations => 'Consigli';

  @override
  String get libSourceLocal => 'Locale';

  @override
  String get libFieldDuration => 'Durata';

  @override
  String get libFilter => 'Filtra';

  @override
  String get libRefreshAll => 'Aggiorna tutto';

  @override
  String get libPodcastsSubscribed => 'Iscrizioni';

  @override
  String get libNoSubscriptions => 'Ancora nessuna iscrizione';

  @override
  String get libSubscribeRssFeed => 'Iscriviti a un feed RSS';

  @override
  String get libUnknown => 'Sconosciuto';

  @override
  String get libUnsubscribeTitle => 'Annullare l’iscrizione?';

  @override
  String libUnsubscribeBody(String name) {
    return 'Annullare l’iscrizione a “$name”?';
  }

  @override
  String get libUnsubscribe => 'Annulla iscrizione';

  @override
  String libEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodi',
      one: '1 episodio',
    );
    return '$_temp0';
  }

  @override
  String get libSubscribeToPodcast => 'Iscriviti a un podcast';

  @override
  String get libRssFeedUrl => 'URL del feed RSS';

  @override
  String get libSubscribe => 'Iscriviti';

  @override
  String get libSubscribed => 'Iscrizione effettuata.';

  @override
  String libSubscribeError(String error) {
    return 'Errore di iscrizione: $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return 'Errore di annullamento iscrizione: $error';
  }

  @override
  String get libPodcastRefreshed => 'Podcast aggiornato.';

  @override
  String libRefreshError(String error) {
    return 'Errore di aggiornamento: $error';
  }

  @override
  String get libAllPodcastsRefreshed => 'Tutti i podcast aggiornati.';

  @override
  String get libToday => 'Oggi';

  @override
  String get miscNavFolders => 'Cartelle';

  @override
  String get miscNavCollections => 'Raccolte';

  @override
  String get miscNavSmartCollections => 'Raccolte intelligenti';

  @override
  String get miscNavDjMode => 'Modalità DJ';

  @override
  String get miscNavPartyMode => 'Modalità festa';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => 'Festa';

  @override
  String get miscNavSmartPlaylists => 'Playlist intelligenti';

  @override
  String get miscNavAlarms => 'Sveglie';

  @override
  String get miscNavGenreTree => 'Albero dei generi';

  @override
  String get miscNavDashboard => 'Dashboard';

  @override
  String get miscNavDiagnostics => 'Diagnostica';

  @override
  String get miscNavAdmin => 'Amministrazione';

  @override
  String get miscNavMore => 'Altro';

  @override
  String get miscNextTrack => 'Brano successivo';

  @override
  String get miscPreviousTrack => 'Brano precedente';

  @override
  String get miscUnknownError => 'Errore sconosciuto';

  @override
  String get miscAuthorizationCode => 'Codice di autorizzazione';

  @override
  String get miscWaitingForValidation => 'In attesa di conferma…';

  @override
  String miscCodeValue(String code) {
    return 'Codice: $code';
  }

  @override
  String get miscQualityHigh => 'Alta';

  @override
  String get miscExplore => 'Esplora';

  @override
  String get miscFavoriteAlbums => 'Album preferiti';

  @override
  String get miscFavoriteTracks => 'Brani preferiti';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vedi tutti i $count brani',
      one: 'Vedi 1 brano',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => 'Le mie playlist';

  @override
  String get miscNoApiClient => 'Nessun client API';

  @override
  String miscServiceFavorites(String service) {
    return 'Preferiti $service';
  }

  @override
  String miscPlayAllCount(int count) {
    return 'Riproduci tutto ($count)';
  }

  @override
  String get miscServiceNotFound => 'Servizio non trovato';

  @override
  String get miscYtHome => 'Home';

  @override
  String get miscYtCharts => 'Classifiche';

  @override
  String get miscYtMoods => 'Atmosfere';

  @override
  String get miscNoData => 'Nessun dato';

  @override
  String get miscNoContentAvailable => 'Nessun contenuto disponibile';

  @override
  String get miscNoChartsAvailable => 'Nessuna classifica disponibile';

  @override
  String get miscNoMoodsAvailable => 'Nessuna atmosfera disponibile';

  @override
  String get miscDashTotalPlays => 'Ascolti totali';

  @override
  String get miscDashListeningTime => 'Tempo di ascolto';

  @override
  String get miscDashUniqueTracks => 'Brani distinti';

  @override
  String get miscDashUniqueArtists => 'Artisti distinti';

  @override
  String get miscDashTopArtists => 'ARTISTI PIÙ ASCOLTATI';

  @override
  String get miscDashTopAlbums => 'ALBUM PIÙ ASCOLTATI';

  @override
  String get miscDashTopTracks => 'BRANI PIÙ ASCOLTATI';

  @override
  String get miscDashListeningByHour => 'ASCOLTO PER ORA';

  @override
  String get miscDashListeningByDay => 'ASCOLTO PER GIORNO';

  @override
  String get miscDashAllTime => 'Da sempre';

  @override
  String miscDashLastDays(int days) {
    return '$days giorni';
  }

  @override
  String get miscUnknown => 'Sconosciuto';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ascolti',
      one: '1 ascolto',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => 'Ancora nessun dato di ascolto';

  @override
  String get miscDashNoDataHint =>
      'Ascolta un po\' di musica per vedere qui le tue statistiche.';

  @override
  String get miscDashLoadFailed => 'Impossibile caricare la dashboard';

  @override
  String get miscDiagRequiresRemote =>
      'La diagnostica richiede la connessione a un server remoto.';

  @override
  String get miscDiagSystem => 'Sistema';

  @override
  String get miscDiagHealth => 'Stato';

  @override
  String get miscVersion => 'Versione';

  @override
  String get miscDiagUptime => 'Tempo di attività';

  @override
  String get miscDiagMemory => 'Memoria';

  @override
  String get miscDiagDatabase => 'Database';

  @override
  String miscZoneNumbered(String id) {
    return 'Zona $id';
  }

  @override
  String get miscDiagLogs => 'Log';

  @override
  String get miscDiagNoLogs => 'Nessun log disponibile';

  @override
  String get miscAdminTitle => 'Dashboard di amministrazione';

  @override
  String get miscAdminNotConnected => 'Non connesso a un server remoto';

  @override
  String get miscAdminSystemHealth => 'Stato del sistema';

  @override
  String get miscAdminStatus => 'Stato';

  @override
  String get miscAdminDisk => 'Disco';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return 'Dispositivi rilevati ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return 'Errori recenti ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => 'Nessun errore recente';

  @override
  String get miscTroubleshootingTitle => 'Risoluzione dei problemi';

  @override
  String get miscFaqHeader => 'Domande frequenti';

  @override
  String get miscFaq1Title => 'Non vedo il mio server';

  @override
  String get miscFaq1Step1 =>
      'Verifica che il server Tune sia avviato e raggiungibile.';

  @override
  String get miscFaq1Step2 =>
      'Assicurati che il dispositivo sia connesso alla stessa rete Wi-Fi del server.';

  @override
  String get miscFaq1Step3 =>
      'Se usi una VPN, disattivala o abilita il rilevamento LAN (es. nordvpn set lan-discovery on).';

  @override
  String get miscFaq1Step4 =>
      'Prova a scansionare la rete da Impostazioni > Modalità > Scansiona la rete.';

  @override
  String get miscFaq1Step5 =>
      'Verifica che la porta del server (8888 di default) non sia bloccata da un firewall.';

  @override
  String get miscFaq1Step6 => 'Riavvia il server e l\'app.';

  @override
  String get miscFaq2Title => 'La musica non parte';

  @override
  String get miscFaq2Step1 =>
      'Verifica che sia selezionata una zona di riproduzione (barra in fondo allo schermo).';

  @override
  String get miscFaq2Step2 =>
      'Se non esiste alcuna zona, creane una in Impostazioni > Audio > Zone > Crea.';

  @override
  String get miscFaq2Step3 =>
      'Verifica che il dispositivo di uscita (diffusore, DAC) sia acceso e sulla stessa rete.';

  @override
  String get miscFaq2Step4 =>
      'Per i dispositivi DLNA, attendi qualche secondo dopo il rilevamento prima di avviare la riproduzione.';

  @override
  String get miscFaq2Step5 =>
      'Prova un altro file: il formato del file attuale potrebbe non essere supportato.';

  @override
  String get miscFaq2Step6 => 'Riavvia l\'app se il problema persiste.';

  @override
  String get miscFaq3Title => 'Le copertine non vengono mostrate';

  @override
  String get miscFaq3Step1 =>
      'Avvia una scansione della libreria da Impostazioni > Libreria > Sorgenti.';

  @override
  String get miscFaq3Step2 =>
      'Verifica che i file contengano copertine incorporate (tag ID3/Vorbis).';

  @override
  String get miscFaq3Step3 =>
      'Inserisci un file cover.jpg o folder.jpg nella cartella dell\'album.';

  @override
  String get miscFaq3Step4 =>
      'Abilita il recupero automatico delle copertine in Impostazioni > Libreria > Metadati.';

  @override
  String get miscFaq3Step5 =>
      'Svuota la cache delle immagini riavviando l\'app.';

  @override
  String get miscFaq4Title => 'La scansione è bloccata';

  @override
  String get miscFaq4Step1 =>
      'Una prima scansione può richiedere diversi minuti a seconda delle dimensioni della libreria.';

  @override
  String get miscFaq4Step2 =>
      'Verifica che le cartelle musicali siano accessibili (permessi, montaggi SMB).';

  @override
  String get miscFaq4Step3 =>
      'Chiudi e riapri l\'app per interrompere una scansione bloccata.';

  @override
  String get miscFaq4Step4 =>
      'Controlla i log del server per individuare un file problematico.';

  @override
  String get miscFaq4Step5 =>
      'Prova a ridurre il numero di cartelle sorgente per isolare il problema.';

  @override
  String get miscFaq5Title => 'Come collegare un dispositivo DLNA/AirPlay';

  @override
  String get miscFaq5Step1 =>
      'DLNA: il dispositivo deve essere acceso e sulla stessa rete. Compare automaticamente nell\'elenco delle uscite.';

  @override
  String get miscFaq5Step2 =>
      'Se il dispositivo non compare, verifica che il multicast funzioni sul router.';

  @override
  String get miscFaq5Step3 =>
      'Alcuni router bloccano il traffico SSDP tra i client Wi-Fi: abilita l\'inoltro multicast.';

  @override
  String get miscFaq5Step4 =>
      'BluOS: i diffusori Bluesound vengono rilevati automaticamente.';

  @override
  String get miscFaq5Step5 =>
      'Chromecast: i dispositivi Google Cast compaiono tra le uscite disponibili.';

  @override
  String get miscFaq5Step6 =>
      'Dopo il rilevamento, crea una zona e assegnale il dispositivo come uscita.';

  @override
  String get miscFaq6Title => 'Problemi di streaming';

  @override
  String get miscFaq6Step1 =>
      'Verifica che le credenziali del servizio (TIDAL, Qobuz, Deezer) siano corrette in Impostazioni > Streaming.';

  @override
  String get miscFaq6Step2 =>
      'Se la sessione è scaduta, disconnetti e ricollega il servizio.';

  @override
  String get miscFaq6Step3 => 'Verifica la connessione a Internet.';

  @override
  String get miscFaq6Step4 =>
      'Alcuni brani potrebbero non essere disponibili nella tua regione.';

  @override
  String get miscFaq6Step5 =>
      'Per problemi di qualità, controlla le impostazioni di qualità dello streaming in Impostazioni > Audio avanzato.';

  @override
  String get miscFaq6Step6 =>
      'Se il problema persiste, invia una segnalazione di bug da Impostazioni > Aiuto.';

  @override
  String get miscBugReportCopied => 'Segnalazione copiata negli appunti';

  @override
  String get miscBugReportSent => 'Bug inviato, grazie!';

  @override
  String get miscBugReportSendFailed =>
      'Invio non riuscito. Copia la segnalazione nel forum.';

  @override
  String get miscBugReportTitle => 'Segnalazione di bug';

  @override
  String get miscRegenerate => 'Rigenera';

  @override
  String get miscBugReportGenerateFailed =>
      'Impossibile generare la segnalazione';

  @override
  String get miscSent => 'Inviato!';

  @override
  String get miscSending => 'Invio…';

  @override
  String get miscSubmit => 'Invia';

  @override
  String get miscCopied => 'Copiato!';

  @override
  String get miscCopyReport => 'Copia segnalazione';

  @override
  String get miscAiServerNotConnected =>
      'Server non connesso. Verifica la connessione.';

  @override
  String miscAiQueryFailed(int code) {
    return 'Richiesta IA non riuscita ($code)';
  }

  @override
  String get miscAiNoReply => 'Nessuna risposta';

  @override
  String get miscAiAskHint => 'Fai una domanda…';

  @override
  String get miscAiSend => 'Invia';

  @override
  String get miscAiTitle => 'Assistente IA';

  @override
  String get miscAiEmptyTitle => 'Assistente IA di Tune';

  @override
  String get miscAiEmptyBody =>
      'Fai una domanda sulla tua musica,\nchiedi consigli…';

  @override
  String miscAiAction(String action) {
    return 'Azione: $action';
  }

  @override
  String get miscCreateAccount => 'Crea un account';

  @override
  String get miscUsername => 'Nome utente';

  @override
  String get miscUsernameRequired => 'Nome utente obbligatorio';

  @override
  String get miscEmailRequired => 'Email obbligatoria';

  @override
  String get miscEmailInvalid => 'Email non valida';

  @override
  String get miscPasswordRequired => 'Password obbligatoria';

  @override
  String miscPasswordMinLength(int min) {
    return 'Almeno $min caratteri';
  }

  @override
  String get miscHaveAccountSignIn => 'Hai già un account? Accedi';

  @override
  String get miscNoAccountSignUp => 'Non hai un account? Registrati';

  @override
  String get npRepeat => 'Ripeti';

  @override
  String get npQueue => 'Coda';

  @override
  String get npFavorite => 'Preferito';

  @override
  String get npRadioFavAdded => 'Aggiunto ai preferiti radio';

  @override
  String get npLyrics => 'Testo';

  @override
  String get npAlarm => 'Sveglia';

  @override
  String get npSleepTimer => 'Timer di spegnimento';

  @override
  String get npDspCrossfeed => 'Crossfeed DSP';

  @override
  String get npEqualizer => 'Equalizzatore';

  @override
  String get npShare => 'Condividi';

  @override
  String get npTransfer => 'Trasferisci';

  @override
  String get npCopiedToClipboard => 'Copiato negli appunti';

  @override
  String get npNoLyricsFound => 'Nessun testo trovato';

  @override
  String get npNoLyricsAvailable => 'Testo non disponibile';

  @override
  String get npLyricsOpenFromNowPlaying =>
      'Apri da «In riproduzione» per il testo completo';

  @override
  String get npLyricsLoadFailed => 'Impossibile caricare il testo';

  @override
  String get npLrcMetadataTooltip => 'Metadati';

  @override
  String get npLrcMetadataTitle => 'Metadati LRC';

  @override
  String get npLrcTitle => 'Titolo';

  @override
  String get npLrcCreatedBy => 'Creato da';

  @override
  String get npLrcOffset => 'Offset (ms)';

  @override
  String get npLrcHint =>
      'Metti un file .lrc con lo stesso nome accanto al file audio.';

  @override
  String get npEqFlat => 'Piatto';

  @override
  String get npEqBassBoost => 'Bassi potenziati';

  @override
  String get npEqTrebleBoost => 'Alti potenziati';

  @override
  String get npEqVocal => 'Voce';

  @override
  String get npEqRock => 'Rock';

  @override
  String get npEqJazz => 'Jazz';

  @override
  String get npEqClassical => 'Classica';

  @override
  String get npEqElectronic => 'Elettronica';

  @override
  String get npEqHipHop => 'Hip hop';

  @override
  String get npEqAcoustic => 'Acustica';

  @override
  String npEqApplied(String preset) {
    return 'EQ: $preset';
  }

  @override
  String npEqError(String error) {
    return 'Errore EQ: $error';
  }

  @override
  String get npCrossfeedDesc =>
      'Miscela i canali stereo per un ascolto in cuffia più naturale';

  @override
  String get npCrossfeedOff => 'Disattivato';

  @override
  String get npCrossfeedLight => 'Leggero';

  @override
  String get npCrossfeedMedium => 'Medio';

  @override
  String get npCrossfeedStrong => 'Forte';

  @override
  String npCrossfeedApplied(String level) {
    return 'Crossfeed: $level';
  }

  @override
  String npDspError(String error) {
    return 'Errore DSP: $error';
  }

  @override
  String get npTransferTitle => 'Trasferisci la riproduzione';

  @override
  String get npNoOtherZones => 'Nessun’altra zona disponibile';

  @override
  String npTransferredTo(String zone) {
    return 'Trasferito su $zone';
  }

  @override
  String npTransferError(String error) {
    return 'Errore di trasferimento: $error';
  }

  @override
  String get npAlarmClock => 'Sveglia';

  @override
  String npAlarmSetFor(String time) {
    return 'Sveglia impostata alle $time';
  }

  @override
  String npAlarmError(String error) {
    return 'Errore sveglia: $error';
  }

  @override
  String get npAlarmCancelled => 'Sveglia annullata';

  @override
  String get npPause => 'Pausa';

  @override
  String get npStop => 'Stop';

  @override
  String get npRoleComposer => 'Compositore';

  @override
  String get npRoleLyricist => 'Paroliere';

  @override
  String get npRoleArranger => 'Arrangiatore';

  @override
  String get npRoleConductor => 'Direttore';

  @override
  String get npRolePerformer => 'Interprete';

  @override
  String get npRoleProducer => 'Produttore';

  @override
  String get npRoleMixer => 'Mixaggio';

  @override
  String get npRoleEngineer => 'Tecnico del suono';

  @override
  String get npCreditsEnriching => 'Arricchimento…';

  @override
  String get npCreditsEnrich => 'Arricchisci con MusicBrainz';

  @override
  String get npVolume => 'Volume';

  @override
  String get npChangeZone => 'Cambia zona';

  @override
  String get npZoneFallback => 'Zona';

  @override
  String get npFollowMe => 'Seguimi';

  @override
  String get npMovePlaybackTo => 'Sposta la riproduzione su…';

  @override
  String get npNowPlaying => 'In riproduzione';

  @override
  String get npTabMore => 'Altro';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return 'Timer impostato: $minutes min (dissolvenza: $fade s)';
  }

  @override
  String npSleepTimerError(String error) {
    return 'Errore del timer: $error';
  }

  @override
  String get npSleepTimerCancelled => 'Timer annullato';

  @override
  String get npSleepDuration => 'DURATA';

  @override
  String get npSleepCustom => 'Personalizzata';

  @override
  String get npSleepFadeOut => 'DISSOLVENZA';

  @override
  String npSleepFadeDesc(int seconds) {
    return 'Il volume scenderà gradualmente a zero negli ultimi $seconds secondi.';
  }

  @override
  String get npSleepStarting => 'Avvio…';

  @override
  String npSleepStart(String duration) {
    return 'Avvia ($duration)';
  }

  @override
  String get npSleepSelectDuration => 'Scegli una durata';

  @override
  String get npSleepTimerActive => 'Timer attivo';

  @override
  String get npSleepCancelTimer => 'Annulla timer';

  @override
  String get npMoodChill => 'Relax';

  @override
  String get npMoodParty => 'Festa';

  @override
  String get npMoodFocus => 'Concentrazione';

  @override
  String get npMoodEnergetic => 'Energico';

  @override
  String get npNoZoneAvailable => 'Nessuna zona disponibile';

  @override
  String npMoodNoTracks(String mood) {
    return 'Nessun brano trovato per $mood';
  }

  @override
  String get npMoodInvalidTrackIds => 'Errore: ID dei brani non validi';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani in riproduzione',
      one: '1 brano in riproduzione',
    );
    return 'Mix $mood: $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani aggiunti alla coda',
      one: '1 brano aggiunto alla coda',
    );
    return 'Mix $mood: $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Errore Smart AutoPlay: $error';
  }

  @override
  String get npSmartAutoplayDesc =>
      'Scegli un’atmosfera per generare una playlist intelligente';

  @override
  String get npAlarmsNotConnected => 'Non connesso a un server remoto';

  @override
  String get npAlarmSnoozed => 'Sveglia posticipata di 5 min';

  @override
  String get npAlarmsTitle => 'Sveglie';

  @override
  String get npAlarmsEmpty => 'Nessuna sveglia';

  @override
  String npZoneNumbered(String id) {
    return 'Zona $id';
  }

  @override
  String get npAlarmSkipsHolidays => 'Esclusi i festivi';

  @override
  String get npAlarmSnooze => 'Posticipa';

  @override
  String get npAlarmDefaultName => 'Sveglia';

  @override
  String get npAlarmEdit => 'Modifica sveglia';

  @override
  String get npAlarmNew => 'Nuova sveglia';

  @override
  String get npAlarmTime => 'Ora';

  @override
  String get npAlarmNameHint => 'Risveglio';

  @override
  String get npAlarmDays => 'Giorni';

  @override
  String get npAlarmSkipHolidays => 'Salta i giorni festivi';

  @override
  String get npAlarmCountry => 'Paese:';

  @override
  String get npCountryFR => 'Francia';

  @override
  String get npCountryBE => 'Belgio';

  @override
  String get npCountryCH => 'Svizzera';

  @override
  String get npCountryCA => 'Canada';

  @override
  String get npCountryUS => 'USA';

  @override
  String get npCountryDE => 'Germania';

  @override
  String get npCountryGB => 'Regno Unito';

  @override
  String get npAlarmSource => 'Sorgente';

  @override
  String get npAlarmSourceType => 'Tipo';

  @override
  String get npSourceRadio => 'Radio';

  @override
  String get npSourcePlaylist => 'Playlist';

  @override
  String get npSourceAlbum => 'Album';

  @override
  String get npAlarmSourceName => 'Nome della sorgente';

  @override
  String get npAlarmPlaylistId => 'ID della playlist';

  @override
  String get npAlarmAlbumId => 'ID dell’album';

  @override
  String get npAlarmIdentifier => 'Identificativo';

  @override
  String get npAlarmPlaybackZone => 'Zona di riproduzione';

  @override
  String get npAlarmDefaultZone => 'Predefinita';

  @override
  String npAlarmVolume(int percent) {
    return 'Volume: $percent%';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return 'Dissolvenza in entrata: $seconds s';
  }

  @override
  String get npAlarmEnabled => 'Attiva';

  @override
  String get npAlarmDeleteTitle => 'Eliminare la sveglia?';

  @override
  String get npDayMon => 'Lun';

  @override
  String get npDayTue => 'Mar';

  @override
  String get npDayWed => 'Mer';

  @override
  String get npDayThu => 'Gio';

  @override
  String get npDayFri => 'Ven';

  @override
  String get npDaySat => 'Sab';

  @override
  String get npDaySun => 'Dom';

  @override
  String get plHubTitle => 'Hub playlist';

  @override
  String get plTabSmartAi => 'IA';

  @override
  String get plTabTransfers => 'Trasferimenti';

  @override
  String get plSync => 'Sincronizza';

  @override
  String get plTabBackup => 'Backup';

  @override
  String get plCompare => 'Confronta';

  @override
  String get plComparing => 'Confronto…';

  @override
  String plCompareError(String detail) {
    return 'Confronto non riuscito: $detail';
  }

  @override
  String get plNoPlaylistsAvailable => 'Nessuna playlist disponibile';

  @override
  String get plSectionSource => 'ORIGINE';

  @override
  String get plSectionTarget => 'DESTINAZIONE';

  @override
  String get plServiceLabel => 'Servizio';

  @override
  String get plPlaylistLabel => 'Playlist';

  @override
  String get plLocal => 'Locale';

  @override
  String get plSourceLabel => 'Origine';

  @override
  String get plRestoreSnapshotTitle => 'Ripristina snapshot';

  @override
  String get plLocalPlaylistNameLabel => 'Nome della playlist locale:';

  @override
  String get plRestore => 'Ripristina';

  @override
  String plRestoreDone(String name, String matched, String notFound) {
    return '«$name» ripristinata: $matched trovati, $notFound non trovati.';
  }

  @override
  String plRestoreReplaced(String name, String matched, String notFound) {
    return '«$name» sostituita: $matched trovati, $notFound non trovati.';
  }

  @override
  String get plExistingTitle => 'Playlist già esistente';

  @override
  String plExistingBody(String name) {
    return 'Esiste già una playlist «$name». Sostituirla?';
  }

  @override
  String get plReplace => 'Sostituisci';

  @override
  String plDeleteSnapshotBody(String name) {
    return 'Eliminare lo snapshot di «$name»?';
  }

  @override
  String get plSyncIntervalTitle => 'Intervallo di sincronizzazione automatica';

  @override
  String get plSyncIntervalLabel => 'Minuti (0 = solo manuale):';

  @override
  String get plSyncIntervalHint => 'es. 60';

  @override
  String get plNoTransfers => 'Nessun trasferimento';

  @override
  String get plNoSyncLinks => 'Nessun collegamento di sincronizzazione';

  @override
  String get plNoSyncLinksHint => 'Crea collegamenti da un trasferimento';

  @override
  String plPlaylistNumber(String id) {
    return 'Playlist n. $id';
  }

  @override
  String plAutoEveryMinutes(String minutes) {
    return 'auto $minutes min';
  }

  @override
  String plSyncDone(
    String addedLocal,
    String removedLocal,
    String addedRemote,
    String removedRemote,
  ) {
    return 'Sincronizzazione OK: +$addedLocal/-$removedLocal locale, +$addedRemote/-$removedRemote remoto';
  }

  @override
  String plSyncConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ', $count conflitti',
      one: ', 1 conflitto',
    );
    return '$_temp0';
  }

  @override
  String plSyncError(String detail) {
    return 'Sincronizzazione non riuscita: $detail';
  }

  @override
  String get plSectionBackup => 'BACKUP';

  @override
  String get plBackingUp => 'Backup in corso…';

  @override
  String get plBackupAll => 'Esegui backup di tutte le playlist';

  @override
  String plBackupResult(String playlists, String tracks) {
    return '$playlists playlist · $tracks brani';
  }

  @override
  String get plSectionSnapshots => 'SNAPSHOT';

  @override
  String get plNoSnapshots =>
      'Nessuno snapshot. Esegui un backup per crearne uno.';

  @override
  String get plSectionBatchTransfer => 'TRASFERIMENTO IN BLOCCO';

  @override
  String get plBatchTransferHint =>
      'Trasferisci tutte le playlist di un servizio';

  @override
  String get plTransferring => 'Trasferimento…';

  @override
  String get plTransferAll => 'Trasferisci tutto';

  @override
  String plBatchResult(String count, String status) {
    return '$count playlist — $status';
  }

  @override
  String get plMergeDone => 'Playlist unite.';

  @override
  String plMergeError(String detail) {
    return 'Unione non riuscita: $detail';
  }

  @override
  String get plNameLabel => 'Nome';

  @override
  String plDeleteNamed(String name) {
    return 'Eliminare «$name»?';
  }

  @override
  String plImportedLocal(String name) {
    return '«$name» importata in locale.';
  }

  @override
  String plImportError(String detail) {
    return 'Importazione non riuscita: $detail';
  }

  @override
  String get plFilterAll => 'Tutte';

  @override
  String get plMerge => 'Unisci';

  @override
  String get plCancelMerge => 'Annulla unione';

  @override
  String get plMerging => 'Unione…';

  @override
  String get plImportToLocal => 'Importa in locale';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selezionate',
      one: '1 selezionata',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => 'Rimuovi duplicati';

  @override
  String get plMergedNameHint => 'Nome della playlist unita';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => 'RISULTATI';

  @override
  String get plCommon => 'In comune';

  @override
  String get plSourceOnly => 'Solo origine';

  @override
  String get plTargetOnly => 'Solo destinazione';

  @override
  String plMatchRate(String rate) {
    return '$rate% di corrispondenza';
  }

  @override
  String plOnlyInSource(int count) {
    return 'Solo nell’origine ($count)';
  }

  @override
  String plOnlyInTarget(int count) {
    return 'Solo nella destinazione ($count)';
  }

  @override
  String plMoreCount(int count) {
    return '+ altri $count';
  }

  @override
  String get plTransferPlaylistTitle => 'Trasferisci playlist';

  @override
  String get plCreateOnRemote => 'Crea sul servizio remoto';

  @override
  String get plTransfer => 'Trasferisci';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return 'Trasferimento: $matched trovati, $approximate approssimativi, $notFound mancanti.';
  }

  @override
  String get plRecover => 'Recupera';

  @override
  String plRecoverDone(int available, int alternatives) {
    return 'Recupero: $available disponibili, $alternatives alternative trovate.';
  }

  @override
  String plCopyName(String name) {
    return '$name (copia)';
  }

  @override
  String get plDuplicate => 'Duplica';

  @override
  String plDuplicated(String name) {
    return 'Duplicata: $name';
  }

  @override
  String plDeleted(String name) {
    return 'Eliminata: $name';
  }

  @override
  String plTransferred(String name) {
    return 'Trasferita: $name';
  }

  @override
  String get plTransferToLocal => 'Trasferisci in locale';

  @override
  String get plExportJson => 'Esporta JSON';

  @override
  String get plExportCsv => 'Esporta CSV';

  @override
  String get plExportM3u => 'Esporta M3U';

  @override
  String get plExportJsonDone => 'Esportazione JSON completata';

  @override
  String get plExportCsvDone => 'Esportazione CSV completata';

  @override
  String plExportM3uDone(String path) {
    return 'M3U esportato: $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'Esportazione M3U non riuscita: $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importata: $name ($count brani)',
      one: 'Importata: $name (1 brano)',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'Importazione M3U non riuscita: $detail';
  }

  @override
  String get plSmartTitle => 'Playlist intelligenti';

  @override
  String plSmartLoadError(String detail) {
    return 'Impossibile caricare le playlist intelligenti: $detail';
  }

  @override
  String plDeleteError(String detail) {
    return 'Eliminazione non riuscita: $detail';
  }

  @override
  String get plSmartEmpty => 'Nessuna playlist intelligente';

  @override
  String get plUntitled => 'Senza titolo';

  @override
  String get plSmartDeleteTitle => 'Eliminare la playlist intelligente?';

  @override
  String plPreviewError(String detail) {
    return 'Anteprima non riuscita: $detail';
  }

  @override
  String get plEnterName => 'Inserisci un nome';

  @override
  String plSaveError(String detail) {
    return 'Salvataggio non riuscito: $detail';
  }

  @override
  String get plSmartEditTitle => 'Modifica playlist intelligente';

  @override
  String get plSmartNewTitle => 'Nuova playlist intelligente';

  @override
  String get plMatchLabel => 'Corrispondenza';

  @override
  String get plMatchAll => 'Tutte le regole';

  @override
  String get plMatchAny => 'Almeno una regola';

  @override
  String get plSectionRules => 'REGOLE';

  @override
  String get plAddRule => 'Aggiungi regola';

  @override
  String get plMaxTracksLabel => 'Brani max (facoltativo)';

  @override
  String get plNoLimit => 'Nessun limite';

  @override
  String get plPreviewMatching => 'Anteprima dei brani corrispondenti';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani corrispondenti',
      one: '1 brano corrispondente',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => 'Valore';

  @override
  String get plUnknownTitle => 'Sconosciuto';

  @override
  String plTracksLoadError(String detail) {
    return 'Impossibile caricare i brani: $detail';
  }

  @override
  String get plSmartNoTracks => 'Nessun brano corrisponde a questa playlist';

  @override
  String get plFieldGenre => 'Genere';

  @override
  String get plFieldArtist => 'Artista';

  @override
  String get plFieldAlbum => 'Album';

  @override
  String get plFieldTitle => 'Titolo';

  @override
  String get plFieldYear => 'Anno';

  @override
  String get plFieldRating => 'Valutazione';

  @override
  String get plFieldPlayCount => 'Ascolti';

  @override
  String get plFieldDuration => 'Durata (ms)';

  @override
  String get plFieldDateAdded => 'Data di aggiunta';

  @override
  String get plFieldFavorite => 'Preferito';

  @override
  String get plOpContains => 'contiene';

  @override
  String get plOpEquals => 'è uguale a';

  @override
  String get plOpStartsWith => 'inizia con';

  @override
  String get plOpEndsWith => 'finisce con';

  @override
  String get plOpGreaterThan => 'maggiore di';

  @override
  String get plOpLessThan => 'minore di';

  @override
  String get plOpIs => 'è';

  @override
  String get plOpIsNot => 'non è';

  @override
  String get srvConfigTitle => 'Configurazione server';

  @override
  String srvFolderAdded(String path) {
    return 'Cartella aggiunta: $path';
  }

  @override
  String get srvRemoveFolderTitle => 'Rimuovere questa cartella?';

  @override
  String srvScanStarted(String path) {
    return 'Scansione avviata: $path';
  }

  @override
  String get srvFullScanStarted => 'Scansione completa avviata';

  @override
  String get srvRestartTitle => 'Riavviare il server?';

  @override
  String get srvRestartBody =>
      'Il server verrà arrestato e riavviato. La riproduzione in corso verrà interrotta.';

  @override
  String get srvRestartBtn => 'Riavvia';

  @override
  String get srvRestarting => 'Riavvio del server…';

  @override
  String get srvRestartInProgress => 'Riavvio in corso…';

  @override
  String get srvLoadError => 'Errore di caricamento';

  @override
  String get srvScanFolderTooltip => 'Scansiona questa cartella';

  @override
  String get srvSectionServerInfo => 'Informazioni server';

  @override
  String get srvInfoVersion => 'Versione';

  @override
  String get srvInfoEngine => 'Motore';

  @override
  String get srvInfoDatabase => 'Database';

  @override
  String get srvSectionActions => 'Azioni';

  @override
  String get srvRestartServer => 'Riavvia il server';

  @override
  String get srvRestartServerDesc => 'Arresta e riavvia il processo del server';

  @override
  String get srvManualEntry => 'Inserimento manuale';

  @override
  String srvSelectPath(String path) {
    return 'Seleziona \"$path\"';
  }

  @override
  String get srvBrowse => 'Sfoglia…';

  @override
  String get srvFolderPathHint => '/percorso/della/musica';

  @override
  String get srvFolderPathHelp =>
      'Inserisci il percorso assoluto della cartella sul server.';

  @override
  String get srvNoSubfolders => 'Nessuna sottocartella';

  @override
  String get srvPluginsTitle => 'Plugin';

  @override
  String get srvNotConnectedToServer => 'Non connesso al server';

  @override
  String srvPluginInstalled(String name) {
    return '$name installato';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name disinstallato';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name aggiornato';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name attivato';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name disattivato';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return 'Installazione non riuscita: $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return 'Disinstallazione non riuscita: $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return 'Aggiornamento non riuscito: $error';
  }

  @override
  String get srvPluginsTabStore => 'Store';

  @override
  String get srvPluginsTabInstalled => 'Installati';

  @override
  String get srvRestartRequired =>
      'Riavvio necessario per applicare le modifiche';

  @override
  String get srvPluginsSearchHint => 'Cerca plugin…';

  @override
  String get srvPluginsNoneFound => 'Nessun plugin trovato';

  @override
  String get srvPluginsNoneInstalled => 'Nessun plugin installato';

  @override
  String get srvPluginsBrowseStore => 'Sfoglia lo Store';

  @override
  String get srvPluginBadgeFeatured => 'In evidenza';

  @override
  String get srvPluginBadgeUpdate => 'Aggiornamento';

  @override
  String get srvPluginBadgeIncompatible => 'Incompatibile';

  @override
  String srvPluginByAuthor(String author) {
    return 'di $author';
  }

  @override
  String get srvPluginActionUpdate => 'Aggiorna';

  @override
  String get srvPluginActionInstall => 'Installa';

  @override
  String get srvPluginActionUninstall => 'Disinstalla';

  @override
  String get srvPluginStatusActive => 'Attivo';

  @override
  String get srvPluginStatusError => 'Errore';

  @override
  String get srvAutoFixTitle => 'Correzione automatica metadati';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count correzioni applicate',
      one: '1 correzione applicata',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence =>
      'Nessuna correzione ad alta affidabilità rimasta';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggerimenti rimanenti',
      one: '1 suggerimento rimanente',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => 'Applica alta affidabilità';

  @override
  String srvAutoFixTrackNumber(int id) {
    return 'Brano n. $id';
  }

  @override
  String get srvAutoFixCurrent => 'Attuale';

  @override
  String get srvAutoFixEmpty => '(vuoto)';

  @override
  String get srvAutoFixSuggested => 'Suggerito';

  @override
  String get srvAutoFixSkip => 'Salta';

  @override
  String get srvAutoFixApply => 'Applica';

  @override
  String get srvAutoFixIntroTitle => 'Correggi i metadati mancanti';

  @override
  String get srvAutoFixIntroBody =>
      'Analizza i brani privi di genere, anno o ID MusicBrainz e suggerisce correzioni da MusicBrainz.';

  @override
  String get srvAutoFixStartScan => 'Avvia scansione';

  @override
  String get srvAutoFixScanning => 'Ricerca su MusicBrainz…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total brani ($pct%)';
  }

  @override
  String get srvAutoFixLoadingTracks => 'Caricamento brani…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count correzioni trovate finora',
      one: '1 correzione trovata finora',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit =>
      'Limitato a 1 richiesta/s (policy di MusicBrainz)';

  @override
  String get srvAutoFixNoneNeeded => 'Nessuna correzione necessaria';

  @override
  String get srvAutoFixAllComplete => 'Tutti i brani hanno metadati completi.';

  @override
  String get srvAutoFixScanAgain => 'Scansiona di nuovo';

  @override
  String get srvAutoFixScanFailed => 'Scansione non riuscita';

  @override
  String get srvMpStepSetup => 'Configurazione';

  @override
  String get srvMpStepFineTune => 'Regolazione fine';

  @override
  String get srvMpListenTitle => 'Come ascolti?';

  @override
  String get srvMpListenSubtitle =>
      'Il profilo sarà adattato alla tua configurazione di ascolto';

  @override
  String get srvMpSpeakers => 'Diffusori';

  @override
  String get srvMpSpeakersSub => 'Sala d\'ascolto';

  @override
  String get srvMpHeadphones => 'Cuffie';

  @override
  String get srvMpHeadphonesSub => 'Ascolto personale';

  @override
  String get srvMpRoomTitle => 'Quanto è grande la stanza?';

  @override
  String get srvMpRoomSubtitle => 'Influenza le basse frequenze e il riverbero';

  @override
  String get srvMpRoomSmall => 'Piccola';

  @override
  String get srvMpRoomMedium => 'Media';

  @override
  String get srvMpRoomLarge => 'Grande';

  @override
  String get srvMpPlacementTitle => 'Posizionamento dei diffusori';

  @override
  String get srvMpPlacementSubtitle =>
      'La posizione influisce sulle riflessioni dei bassi';

  @override
  String get srvMpNearWall => 'Vicino a una parete';

  @override
  String get srvMpFreeStanding => 'In spazio libero';

  @override
  String get srvMpTuneSound => 'Regola il suono';

  @override
  String get srvMpCorrectionActive => 'Correzione attiva';

  @override
  String get srvMpCorrectionDesc => 'Applica il profilo alla zona corrente';

  @override
  String get srvMpBass => 'Bassi';

  @override
  String get srvMpBassDesc => 'Peso, calore, corpo del suono';

  @override
  String get srvMpBassLow => 'Asciutto';

  @override
  String get srvMpBassHigh => 'Pesante';

  @override
  String get srvMpMid => 'Voce / Medi';

  @override
  String get srvMpMidDesc => 'Presenza, chiarezza, intelligibilità';

  @override
  String get srvMpMidLow => 'Arretrato';

  @override
  String get srvMpMidHigh => 'In avanti';

  @override
  String get srvMpTreble => 'Alti';

  @override
  String get srvMpTrebleDesc => 'Brillantezza, dettaglio, ariosità del suono';

  @override
  String get srvMpTrebleLow => 'Scuro';

  @override
  String get srvMpTrebleHigh => 'Brillante';

  @override
  String get srvMpProfileApplied => 'Profilo applicato';

  @override
  String get srvMpApplying => 'Applicazione…';

  @override
  String get srvMpApply => 'Applica profilo';

  @override
  String get srvMpBackToQuestions => 'Torna alle domande';

  @override
  String get srvRemoteConfigBody =>
      'Connettiti a un server Tune nella tua rete per usare tutte le funzioni.';

  @override
  String get srvModeStandalone => 'Autonomo';

  @override
  String get srvStandaloneWarning =>
      'Modalità autonoma: Party, DJ, testi sincronizzati, EQ e consigli non sono disponibili. Consigliato: usare un server Tune remoto.';

  @override
  String get srvServerAddress => 'Indirizzo del server';

  @override
  String get srvNoServerYet => 'Non hai ancora un server?';

  @override
  String get srvDownloadServer =>
      'Scarica Tune Server: mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).';

  @override
  String get srvStreamingBody =>
      'Attiva i servizi di streaming che vuoi usare con Tune.';

  @override
  String get srvStreamingStandaloneWarning =>
      'In modalità autonoma i servizi di streaming non sono disponibili. Passa alla modalità server remoto per attivarli.';

  @override
  String get srvNoServiceAvailable =>
      'Nessun servizio disponibile. Verifica la connessione al server.';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servizi attivati',
      one: '1 servizio attivato',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connessi',
      one: '1 connesso',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => 'Attivato, non connesso';

  @override
  String get srvAudioCheckTitle => 'Diagnostica audio';

  @override
  String get srvAudioCheckBody =>
      'Verifica della configurazione audio del sistema.';

  @override
  String get srvDiagZones => 'Zone configurate';

  @override
  String get srvDiagOutputs => 'Uscite audio';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rilevate',
      one: '1 rilevata',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => 'Dispositivi di rete';

  @override
  String get srvDiagNone => 'Nessuno';

  @override
  String get srvDiagNoZoneWarning =>
      'Nessuna zona configurata. Puoi crearne una dalle impostazioni Zone.';

  @override
  String srvAudioCheckUnavailable(String error) {
    return 'Diagnostica audio non disponibile: $error';
  }

  @override
  String get srvRecheck => 'Verifica di nuovo';

  @override
  String get srvScanBody =>
      'Avvia una scansione per indicizzare i tuoi file musicali e recuperarne i metadati.';

  @override
  String get srvScanStart => 'Avvia scansione';

  @override
  String get srvScanStatScanned => 'Analizzati';

  @override
  String get srvScanStatAdded => 'Aggiunti';

  @override
  String get srvScanStatUpdated => 'Aggiornati';

  @override
  String get srvScanMayTakeMinutes => 'Potrebbe richiedere alcuni minuti…';

  @override
  String get srvScanComplete => 'Scansione completata!';

  @override
  String stgUpdateAvailable(String version) {
    return 'Aggiornamento disponibile: v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return 'Versione attuale: v$version';
  }

  @override
  String get stgOpen => 'Apri';

  @override
  String get stgMode => 'Modalità';

  @override
  String stgConnectedTo(String address) {
    return 'Connesso a $address';
  }

  @override
  String get stgModeRemote => 'Remoto';

  @override
  String get stgStandaloneTitle => 'Modalità autonoma — funzioni limitate';

  @override
  String get stgStandaloneBody =>
      'Party, DJ, testi sincronizzati, EQ, biografie degli album, consigli… richiedono un server Tune remoto.';

  @override
  String get stgServerAddress => 'Indirizzo del server';

  @override
  String get stgNotConfigured => 'Non configurato';

  @override
  String get stgScanNetwork => 'Scansiona la rete';

  @override
  String get stgSectionPlayback => 'RIPRODUZIONE';

  @override
  String get stgCrossfade => 'Dissolvenza incrociata';

  @override
  String get stgRepeatOneByDefault => 'Ripeti per impostazione predefinita';

  @override
  String get stgExclusiveMode => 'Modalità esclusiva (bit-perfect)';

  @override
  String get stgExclusiveModeDesc =>
      'WASAPI Exclusive — accesso diretto al DAC USB';

  @override
  String get stgSectionMetadataFields => 'CAMPI METADATI';

  @override
  String get stgSectionAdvancedAudio => 'AUDIO AVANZATO';

  @override
  String get stgEqualizer => 'Equalizzatore';

  @override
  String get stgEqualizerDesc =>
      'Assistente di calibrazione + EQ esperto a 10 bande';

  @override
  String get stgMetadataFieldsDesc =>
      'Configura i campi estesi (compositore, direttore…)';

  @override
  String get stgSpotifyConnectDesc =>
      'Tune come ricevitore (Premium richiesto sul client)';

  @override
  String get stgLastfmDesc => 'Scrobbling della cronologia di ascolto';

  @override
  String get stgListenBrainzDesc => 'Scrobbling su ListenBrainz';

  @override
  String get stgAutoFixMetadata => 'Correzione automatica metadati';

  @override
  String get stgAutoFixMetadataDesc =>
      'Completa genere, anno e MBID mancanti tramite MusicBrainz';

  @override
  String get stgDatabase => 'Database';

  @override
  String get stgImportExport => 'Importa / Esporta';

  @override
  String get stgSectionProfiles => 'PROFILI';

  @override
  String get stgSectionSystem => 'SISTEMA';

  @override
  String get stgServerConfig => 'Configurazione server';

  @override
  String get stgServerConfigDesc => 'Cartelle musicali, scansione, riavvio';

  @override
  String get stgNetworkDiagnostics => 'Diagnostica di rete';

  @override
  String get stgNetworkDiagnosticsDesc => 'Multicast, DNS, connettività';

  @override
  String get stgConfiguration => 'Configurazione';

  @override
  String get stgExportImport => 'Esporta / Importa';

  @override
  String get stgPlugins => 'Plugin';

  @override
  String get stgPluginsDesc => 'Estensioni installate';

  @override
  String get stgNetworkShares => 'Condivisioni di rete (SMB)';

  @override
  String get stgNetworkSharesDesc => 'Rileva e monta condivisioni';

  @override
  String get stgSectionCloud => 'CLOUD';

  @override
  String get stgSectionHelp => 'AIUTO';

  @override
  String get stgTroubleshooting => 'Risoluzione dei problemi';

  @override
  String get stgTroubleshootingDesc => 'Domande frequenti e soluzioni';

  @override
  String get stgSendBugReport => 'Invia una segnalazione di bug';

  @override
  String get stgSendBugReportDesc => 'Genera e copia un report tecnico';

  @override
  String get stgServerAddressHint => 'IP o nome host (es. 192.168.1.18)';

  @override
  String get stgServerPort => 'Porta del server';

  @override
  String get stgPortDefaultHint => 'Porta (predefinita: 8888)';

  @override
  String get stgWarnNoZones =>
      'Nessuna zona configurata. Creane una per avviare la riproduzione.';

  @override
  String get stgWarnNoNetworkDevices =>
      'Nessun dispositivo di rete rilevato (DLNA/BluOS/Chromecast).';

  @override
  String get stgSectionAudio => 'AUDIO';

  @override
  String get stgAudioOutputs => 'Uscite audio';

  @override
  String stgOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rilevate',
      one: '1 rilevata',
    );
    return '$_temp0';
  }

  @override
  String get stgNetworkDevices => 'Dispositivi di rete';

  @override
  String get stgZoneNameHint => 'es. Soggiorno, Studio';

  @override
  String get stgProfileActivated => 'Profilo attivato';

  @override
  String get stgNewProfile => 'Nuovo profilo';

  @override
  String get stgProfileName => 'Nome del profilo';

  @override
  String get stgProfileNameHint => 'es. Sera, Mattina';

  @override
  String get stgProfileUpdated => 'Profilo aggiornato';

  @override
  String get stgNoProfiles => 'Nessun profilo';

  @override
  String get stgProfile => 'Profilo';

  @override
  String get stgEditProfile => 'Modifica profilo';

  @override
  String get stgName => 'Nome';

  @override
  String get stgColor => 'Colore';

  @override
  String get stgScanInProgress => 'Scansione della rete in corso…';

  @override
  String stgScanChecking(int scanned, int total) {
    return 'Verifica $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'Nessun server Tune trovato';

  @override
  String stgServersFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count server trovati',
      one: '1 server trovato',
    );
    return '$_temp0';
  }

  @override
  String get stgTuneServers => 'Server Tune';

  @override
  String get stgFieldFormat => 'Formato (FLAC, MP3…)';

  @override
  String get stgFieldSampleRate => 'Frequenza di campionamento (96 kHz)';

  @override
  String get stgFieldBitDepth => 'Profondità in bit (24 bit)';

  @override
  String get stgFieldLabel => 'Etichetta';

  @override
  String get stgFieldComposer => 'Compositore';

  @override
  String get stgFieldDuration => 'Durata';

  @override
  String get stgFieldSource => 'Fonte (Tidal, Qobuz…)';

  @override
  String get stgMetadataFieldsIntro =>
      'Campi mostrati sotto ogni brano (ricerca, libreria, coda, cronologia)';

  @override
  String get stgAudiophileMode => 'Modalità audiofila';

  @override
  String get stgAudiophileModeDesc =>
      'DSP escluso, EQ disattivato, bit-perfect';

  @override
  String get stgCloudAccount => 'Account cloud';

  @override
  String stgConnectedAs(String email) {
    return 'Connesso ($email)';
  }

  @override
  String get stgTelemetry => 'Telemetria';

  @override
  String get stgTelemetryDesc => 'Invia statistiche di utilizzo anonime';

  @override
  String get stgSyncingLibrary => 'Sincronizzazione della libreria…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total brani';
  }

  @override
  String get stgConnectingStreaming => 'Connessione ai servizi di streaming…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'Novità della v$version';
  }

  @override
  String get stgWhatsNewLibrarySync =>
      'Sincronizzazione della libreria migliorata';

  @override
  String get stgWhatsNewMultiRoom =>
      'Multiroom e gestione delle zone ottimizzati';

  @override
  String get stgWhatsNewBugFixes =>
      'Correzioni di bug e miglioramenti della stabilità';

  @override
  String get stgStartServerFailed => 'Impossibile avviare il server';

  @override
  String stgStartServerFailedWith(String detail) {
    return 'Impossibile avviare il server: $detail';
  }

  @override
  String get stgConnectionFailed => 'Connessione non riuscita';

  @override
  String stgConnectionFailedWith(String detail) {
    return 'Connessione non riuscita: $detail';
  }

  @override
  String get stgStartingServer => 'Avvio di Tune Server…';

  @override
  String get stgTagline => 'Server musicale multiroom';

  @override
  String get stgLocalServer => 'Server locale';

  @override
  String get stgLocalServerDesc =>
      'Avvia Tune su questo dispositivo.\nLa tua musica, le tue regole.';

  @override
  String get stgRemoteControl => 'Telecomando';

  @override
  String get stgRemoteControlDesc =>
      'Connettiti a un server\nTune sulla tua rete.';

  @override
  String get stgRemoteConnection => 'Connessione remota';

  @override
  String get znZoneManagerTitle => 'Gestione zone';

  @override
  String get znCannotDeleteLastZone => 'Impossibile eliminare l\'ultima zona';

  @override
  String znZoneSwitchError(String error) {
    return 'Errore nel cambio di zona: $error';
  }

  @override
  String get znZoneSettings => 'Impostazioni zona';

  @override
  String get znPhoneSpeakers => 'Altoparlanti del telefono';

  @override
  String get znBtConnectedOutputs => 'Uscite Bluetooth connesse';

  @override
  String get znBtSystemOutput =>
      'Usa l\'uscita di sistema (Centro di Controllo)';

  @override
  String get znBtOutputsTitle => 'Uscite Bluetooth';

  @override
  String get znBtNoDevice =>
      'Nessun dispositivo Bluetooth connesso. Associa un dispositivo nelle impostazioni di sistema.';

  @override
  String get znBtAndroidRouting =>
      'L\'instradamento attivo dipende dalle impostazioni di sistema di Android.';

  @override
  String get znDsdMode => 'Modalità DSD';

  @override
  String get znDsdAuto => 'Auto';

  @override
  String get znDsdNative => 'Nativo';

  @override
  String get znGaplessDlnaDesc =>
      'Passaggi senza interruzioni tra i brani (DLNA)';

  @override
  String get znFixedVolume => 'Volume fisso';

  @override
  String get znFixedVolumeDesc => 'Disattiva il controllo software del volume';

  @override
  String get znCap16Bit => 'Limita a 16 bit';

  @override
  String get znCap16BitDesc =>
      'Attivalo se l’hi-res (24 bit) resta muto mentre il 16 bit funziona (Ruark R3). Converte in FLAC a 16 bit.';

  @override
  String get znZoneMuted => 'Zona silenziata';

  @override
  String get znZoneUnmuted => 'Audio riattivato';

  @override
  String znErrMute(String error) {
    return 'Errore di silenziamento: $error';
  }

  @override
  String znErrVolume(String error) {
    return 'Errore volume: $error';
  }

  @override
  String znErrLatency(String error) {
    return 'Errore di latenza: $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return 'Errore volume del gruppo: $error';
  }

  @override
  String get znCalibrationDone => 'Calibrazione completata';

  @override
  String znErrCalibration(String error) {
    return 'Errore di calibrazione: $error';
  }

  @override
  String znErrDissolve(String error) {
    return 'Impossibile sciogliere il gruppo: $error';
  }

  @override
  String get znRenameGroupTitle => 'Rinomina gruppo';

  @override
  String get znNewNameHint => 'Nuovo nome';

  @override
  String get znRename => 'Rinomina';

  @override
  String get znGroupRenamed => 'Gruppo rinominato';

  @override
  String znErrRename(String error) {
    return 'Errore di rinomina: $error';
  }

  @override
  String get znGroupNeedTwoZones =>
      'Servono almeno 2 zone per creare un gruppo';

  @override
  String get znGroupNameLabel => 'Nome del gruppo';

  @override
  String get znGroupNameHint => 'es. Soggiorno + Cucina';

  @override
  String get znChooseLeader => 'Scegli il leader';

  @override
  String get znMembers => 'Membri';

  @override
  String znErrCreateGroup(String error) {
    return 'Impossibile creare il gruppo: $error';
  }

  @override
  String get znProfileActivated => 'Profilo attivato';

  @override
  String znErrActivate(String error) {
    return 'Errore di attivazione: $error';
  }

  @override
  String get znProfileDeleted => 'Profilo eliminato';

  @override
  String znErrDelete(String error) {
    return 'Errore di eliminazione: $error';
  }

  @override
  String get znNoOfflineZones => 'Nessuna zona offline da rimuovere';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zone offline rimosse',
      one: '1 zona offline rimossa',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return 'Errore di pulizia: $error';
  }

  @override
  String get znSaveConfigTitle => 'Salva configurazione';

  @override
  String get znProfileNameLabel => 'Nome del profilo';

  @override
  String get znProfileNameHint => 'es. Festa, Mattina tranquilla';

  @override
  String get znDescriptionOptional => 'Descrizione (facoltativa)';

  @override
  String get znNameRequired => 'Il nome è obbligatorio';

  @override
  String get znProfileSaved => 'Profilo salvato';

  @override
  String znErrSave(String error) {
    return 'Errore di salvataggio: $error';
  }

  @override
  String get znCleanupOffline => 'Rimuovi le zone offline';

  @override
  String get znRemoteRequired =>
      'La gestione zone richiede la connessione a un server remoto.';

  @override
  String get znDataUnavailable => 'Dati non disponibili';

  @override
  String get znGroups => 'Gruppi';

  @override
  String get znNoGroups => 'Nessun gruppo';

  @override
  String get znGroupFallback => 'Gruppo';

  @override
  String znZoneFallback(String id) {
    return 'Zona $id';
  }

  @override
  String get znCalibrate => 'Calibra';

  @override
  String get znDissolve => 'Sciogli';

  @override
  String get znProfiles => 'Profili';

  @override
  String get znNoProfiles => 'Nessun profilo salvato';

  @override
  String get znSaveConfigButton => 'Salva config.';

  @override
  String get znProfileFallback => 'Profilo';

  @override
  String get znPins => 'Pin';

  @override
  String znPinFallback(int n) {
    return 'Pin $n';
  }

  @override
  String znPinInvoked(int n) {
    return 'Pin $n avviato';
  }

  @override
  String znPinInvokeError(String error) {
    return 'Impossibile avviare il pin: $error';
  }

  @override
  String get znNoPins => 'Nessun pin configurato';

  @override
  String get znMute => 'Silenzia';

  @override
  String get znUnmute => 'Riattiva audio';

  @override
  String get znLatency => 'Latenza';

  @override
  String get znLatencyError => 'errore';

  @override
  String znPartyAddError(String error) {
    return 'Impossibile aggiungere il brano: $error';
  }

  @override
  String znPartyVoteError(String error) {
    return 'Errore di voto: $error';
  }

  @override
  String get znPartyLinkCopied => 'Link della festa copiato negli appunti';

  @override
  String get znPartyTitle => 'Modalità festa';

  @override
  String get znPartyShareLink => 'Condividi link della festa';

  @override
  String get znPartyAddHint => 'Aggiungi un brano…';

  @override
  String get znPartyQueue => 'Coda';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => 'Zona sconosciuta';

  @override
  String get znUnknownTitle => 'Sconosciuto';

  @override
  String get znNowPlaying => 'In riproduzione';

  @override
  String get znUpvote => 'Vota';

  @override
  String znDjLoadOnDeck(String deck) {
    return 'Carica brano sul deck $deck';
  }

  @override
  String get znDjSearchHint => 'Cerca brani…';

  @override
  String get znDjSearchHelp =>
      'Inserisci il nome di un brano e tocca Cerca e carica';

  @override
  String get znDjNoTracksFound => 'Nessun brano trovato';

  @override
  String znDjSearchError(String error) {
    return 'Errore di ricerca: $error';
  }

  @override
  String get znDjSearchAndLoad => 'Cerca e carica';

  @override
  String znDjLoadError(String error) {
    return 'Errore di caricamento: $error';
  }

  @override
  String znDjPlayError(String error) {
    return 'Errore di riproduzione: $error';
  }

  @override
  String znDjPauseError(String error) {
    return 'Errore di pausa: $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return 'Errore di dissolvenza incrociata: $error';
  }

  @override
  String get znDjTitle => 'Modalità DJ';

  @override
  String get znDjDisabled => 'La modalità DJ è disattivata';

  @override
  String get znDjEnableHint => 'Attivala per iniziare a mixare';

  @override
  String znDjDeck(String deck) {
    return 'Deck $deck';
  }

  @override
  String get znDjCrossfade => 'Dissolvenza incrociata';

  @override
  String znDjDuration(String seconds) {
    return 'Durata: $seconds s';
  }

  @override
  String get znDjStartCrossfade => 'Avvia dissolvenza incrociata';

  @override
  String get znDjAutoCrossfade => 'Dissolvenza incrociata automatica';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return 'Sincronizza $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => 'Sincronizzazione non riuscita';

  @override
  String get znDjNoTrackLoaded => 'Nessun brano caricato';

  @override
  String get znDjLoadTrack => 'Carica brano';

  @override
  String get znDjGain => 'Guadagno';

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
