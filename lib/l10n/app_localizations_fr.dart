// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => 'OK';

  @override
  String get btnCancel => 'Annuler';

  @override
  String get btnAdd => 'Ajouter';

  @override
  String get btnSave => 'Enregistrer';

  @override
  String get btnDelete => 'Supprimer';

  @override
  String get btnEdit => 'Modifier';

  @override
  String get btnClose => 'Fermer';

  @override
  String get btnRetry => 'Réessayer';

  @override
  String get btnCreate => 'Créer';

  @override
  String get btnClear => 'Effacer';

  @override
  String get btnNext => 'Suivant';

  @override
  String get btnSkip => 'Passer cette étape';

  @override
  String get btnFinish => 'Terminer la configuration';

  @override
  String get btnStart => 'Commencer';

  @override
  String get btnConnect => 'Se connecter';

  @override
  String get btnDisconnect => 'Déconnexion';

  @override
  String get btnDownload => 'Télécharger';

  @override
  String get btnImport => 'Importer';

  @override
  String get btnExport => 'Exporter';

  @override
  String get btnReset => 'Réinitialiser';

  @override
  String get btnUse => 'Utiliser';

  @override
  String get btnShuffle => 'Mélanger';

  @override
  String get btnSeeAll => 'Tout voir';

  @override
  String get btnRefresh => 'Actualiser';

  @override
  String get btnScan => 'Scanner la bibliothèque';

  @override
  String get btnAddFolder => 'Ajouter un dossier';

  @override
  String get actionIrreversible => 'Cette action est irréversible.';

  @override
  String get rootStartError => 'Erreur de démarrage';

  @override
  String get playbackErrorNoZone =>
      'Aucune zone sélectionnée — créez ou sélectionnez une zone';

  @override
  String get playbackErrorZoneNotFound => 'Zone introuvable';

  @override
  String get playbackErrorFailed => 'Échec de lecture';

  @override
  String zoneLimitReached(int limit) {
    return 'Offre gratuite limitée à $limit zones — passez à Premium pour un nombre illimité';
  }

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navRadios => 'Radios';

  @override
  String get navZones => 'Zones';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get libraryTitle => 'Bibliothèque';

  @override
  String get tabAlbums => 'Albums';

  @override
  String get tabArtists => 'Artistes';

  @override
  String get tabTracks => 'Pistes';

  @override
  String albumTracksDuration(int count, String duration) {
    return '$count pistes · $duration';
  }

  @override
  String get tabGenres => 'Genres';

  @override
  String get tabPlaylists => 'Playlists';

  @override
  String get tabFavorites => 'Favoris';

  @override
  String get favoriteAdded => 'Ajouté aux favoris';

  @override
  String get favoriteRemoved => 'Retiré des favoris';

  @override
  String get libraryEmptyFavorites => 'Aucun favori';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => 'Aucun album dans la bibliothèque';

  @override
  String get libraryEmptyArtists => 'Aucun artiste dans la bibliothèque';

  @override
  String get libraryEmptyTracks => 'Aucune piste dans la bibliothèque';

  @override
  String get libraryEmptyGenres => 'Aucun genre';

  @override
  String get libraryEmptyPlaylists => 'Aucune playlist';

  @override
  String get libraryNoFilterResults => 'Aucun album ne correspond aux filtres';

  @override
  String get libraryPlayAll => 'Écouter tout';

  @override
  String get libraryAddTo => 'Ajouter à…';

  @override
  String get libraryEditAlbum => 'Modifier l\'album';

  @override
  String get libraryEditTrack => 'Modifier la piste';

  @override
  String get libraryPlay => 'Écouter';

  @override
  String get genresAllTracks => 'Toutes les pistes';

  @override
  String get playlistCreate => 'Créer une playlist';

  @override
  String get playlistName => 'Nom de la playlist';

  @override
  String get playlistEmpty => 'Aucune piste';

  @override
  String get playlistAddTo => 'Ajouter à une playlist';

  @override
  String get playlistNewPlaylist => 'Nouvelle playlist';

  @override
  String playlistTrackAdded(String name) {
    return 'Ajouté à « $name »';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return 'Déjà présent dans « $name »';
  }

  @override
  String playlistTracksAdded(int count, String name) {
    return '$count pistes ajoutées à \"$name\"';
  }

  @override
  String get playlistAddAllTracks => 'Tout ajouter à une playlist';

  @override
  String get playlistDeleteTitle => 'Supprimer la playlist ?';

  @override
  String get playlistDeleteBody =>
      'Cette playlist sera définitivement supprimée.';

  @override
  String get searchHint => 'Rechercher…';

  @override
  String get searchNoResults => 'Aucun résultat';

  @override
  String get searchTopResult => 'Meilleur résultat';

  @override
  String get searchSectionTracks => 'Pistes';

  @override
  String get searchSectionAlbums => 'Albums';

  @override
  String get searchSectionArtists => 'Artistes';

  @override
  String get searchSectionStreaming => 'Streaming';

  @override
  String get homeRecentlyPlayed => 'Récemment joué';

  @override
  String get homeLibrary => 'Bibliothèque';

  @override
  String get homeQuickAccess => 'Accès rapide';

  @override
  String get homeHistory => 'Historique';

  @override
  String get homeBrowseDlna => 'Parcourir DLNA';

  @override
  String get homeStatTracks => 'pistes';

  @override
  String get homeStatAlbums => 'albums';

  @override
  String get homeStatArtists => 'artistes';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyEmpty => 'Aucun historique';

  @override
  String get historyClear => 'Effacer';

  @override
  String get historyClearTitle => 'Effacer l\'historique';

  @override
  String get nowPlayingNoTrack => 'Aucune piste';

  @override
  String get queueTitle => 'File de lecture';

  @override
  String queueUpNextSummary(int count, String time) {
    return '$count à suivre · $time';
  }

  @override
  String get queueEmpty => 'File vide';

  @override
  String get queueClearTitle => 'Vider la file ?';

  @override
  String get queueClearBody =>
      'Toutes les pistes seront supprimées de la file de lecture.';

  @override
  String get zonesTitle => 'Zones';

  @override
  String get zonesNew => 'Nouvelle zone';

  @override
  String get zonesNewName => 'Nom de la zone';

  @override
  String get zonesNone => 'Aucune zone';

  @override
  String get zonesRename => 'Renommer la zone';

  @override
  String get zonesDelete => 'Supprimer la zone';

  @override
  String get zonesDevices => 'Appareils disponibles';

  @override
  String get zonesOutputLocal => 'Local';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesAirplayPair => 'Appairer (code PIN)';

  @override
  String get zonesAirplayPairTitle => 'Appairage AirPlay';

  @override
  String get zonesAirplayPairIntro =>
      'Certaines TV (Samsung, LG) et l\'Apple TV affichent un code à 4 chiffres à l\'écran. Lancez l\'appairage puis saisissez le code.';

  @override
  String get zonesAirplayPairWaiting =>
      'En attente du code affiché sur l\'appareil…';

  @override
  String get zonesAirplayPairEnterCode =>
      'Saisissez le code affiché sur l\'appareil :';

  @override
  String get zonesAirplayPairStart => 'Lancer l\'appairage';

  @override
  String get zonesAirplayPairSubmit => 'Valider le code';

  @override
  String get zonesAirplayPairRetry => 'Réessayer';

  @override
  String get zonesOutputBluetooth => 'Bluetooth';

  @override
  String get zonesChangeOutput => 'Changer la sortie';

  @override
  String get zonesOutputTitle => 'Sortie audio';

  @override
  String get zonesAssignDevice => 'Assigner';

  @override
  String get zonesTransferTitle => 'Diffuser sur...';

  @override
  String get zonesNowPlaying => 'En cours ici';

  @override
  String zonesActivated(String name) {
    return 'Zone active : $name';
  }

  @override
  String get radiosTitle => 'Radios';

  @override
  String get radiosTabAll => 'Toutes';

  @override
  String get radiosTabFavorites => 'Favoris';

  @override
  String get radiosNone => 'Aucune radio';

  @override
  String get radiosFavNone => 'Aucune radio favorite';

  @override
  String get radiosSavedFavorites => 'Favoris sauvegardés';

  @override
  String get radiosAdd => 'Ajouter une radio';

  @override
  String get radiosName => 'Nom';

  @override
  String get radiosStreamUrl => 'URL du flux';

  @override
  String get radiosGenre => 'Genre (optionnel)';

  @override
  String get radiosPasteM3u => 'Coller un M3U';

  @override
  String get radiosImportUrl => 'Importer depuis une URL';

  @override
  String get radiosImportUrlLabel => 'URL du fichier M3U';

  @override
  String radiosImportResult(int count) {
    return '$count station(s) importée(s)';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'Erreur HTTP $code';
  }

  @override
  String get radiosImportFailed => 'Impossible de télécharger le fichier';

  @override
  String get radiosFavSaved => 'Morceau sauvegardé';

  @override
  String get radioSaveFavorite => 'Sauvegarder le morceau';

  @override
  String get radioFavTitle => 'Favoris radio';

  @override
  String get radioFavEmpty => 'Aucun favori sauvegardé';

  @override
  String get radioFavExportCsv => 'Exporter CSV';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get streamingConnected => 'Connecté';

  @override
  String get streamingNotConnected => 'Non connecté';

  @override
  String get streamingEmail => 'Email';

  @override
  String get streamingPassword => 'Mot de passe';

  @override
  String get streamingSignIn => 'Se connecter';

  @override
  String get streamingSigningIn => 'Connexion…';

  @override
  String get streamingDeviceCode => 'Code de vérification';

  @override
  String get streamingOpenLink => 'Ouvrir…';

  @override
  String get streamingLogoutTitle => 'Se déconnecter ?';

  @override
  String streamingLogoutBody(String service) {
    return 'Se déconnecter de $service ?';
  }

  @override
  String get streamingAuthError => 'Échec de l\'authentification';

  @override
  String get streamingAlbumsSection => 'Albums';

  @override
  String get streamingPlaylistsSection => 'Playlists';

  @override
  String get browseTitle => 'Parcourir';

  @override
  String get browseRefreshTooltip => 'Actualiser';

  @override
  String get browseNoServers => 'Aucun serveur UPnP/DLNA détecté';

  @override
  String get browseNoServersHint =>
      'Vérifiez que votre serveur est sur le même réseau Wi-Fi.';

  @override
  String get browseNoContent => 'Dossier vide';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLangSystem => 'Système';

  @override
  String get settingsSectionZones => 'Zones';

  @override
  String get settingsDefaultZone => 'Zone par défaut';

  @override
  String get settingsDefaultZoneAuto => 'Automatique';

  @override
  String get settingsNoZones => 'Aucune zone';

  @override
  String get settingsSectionServer => 'Serveur';

  @override
  String get settingsHttpPort => 'Port HTTP';

  @override
  String get settingsHttpPortDesc => 'Port du serveur principal';

  @override
  String get settingsLocalIp => 'Adresse IP locale';

  @override
  String get settingsSectionLibrary => 'Bibliothèque';

  @override
  String get settingsMetadata => 'Musique & Métadonnées';

  @override
  String get settingsMetadataDesc => 'Dossiers, scan, statistiques';

  @override
  String get settingsSetupWizard => 'Assistant de configuration';

  @override
  String get settingsSetupWizardDesc => 'Reconfigurer les sources musicales';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsVersion => 'Version 0.1.0';

  @override
  String get settingsResetConfig => 'Réinitialiser la configuration';

  @override
  String get settingsResetTitle => 'Réinitialiser ?';

  @override
  String get settingsResetBody =>
      'Toutes les préférences seront réinitialisées. L\'assistant de démarrage s\'affichera au prochain lancement.';

  @override
  String get settingsPortTitle => 'Port HTTP';

  @override
  String get settingsPortHint => 'Port (1024–65535)';

  @override
  String get metadataTitle => 'Musique & Métadonnées';

  @override
  String get metadataRefreshStats => 'Actualiser les stats';

  @override
  String get metadataSectionStats => 'Statistiques';

  @override
  String get metadataStatTracks => 'Pistes';

  @override
  String get metadataStatAlbums => 'Albums';

  @override
  String get metadataStatArtists => 'Artistes';

  @override
  String get metadataStatPlaylists => 'Playlists';

  @override
  String get metadataStatRadios => 'Radios';

  @override
  String get metadataStatArtwork => 'Cache pochettes';

  @override
  String get metadataSectionScan => 'Scan bibliothèque';

  @override
  String metadataScanInProgress(int current, int total) {
    return 'Scan en cours… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return 'Dernier scan : +$added ajoutées, $updated mises à jour';
  }

  @override
  String get metadataScanBtn => 'Scanner la bibliothèque';

  @override
  String get metadataScanDesc => 'Indexe tous les dossiers configurés';

  @override
  String get metadataSectionFolders => 'Dossiers musique';

  @override
  String get metadataFoldersNone => 'Aucun dossier configuré';

  @override
  String metadataFolderAddedOn(String date) {
    return 'Ajouté le $date';
  }

  @override
  String get metadataAddFolder => 'Ajouter un dossier';

  @override
  String get metadataFolderPath => 'Chemin du dossier';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => 'Nettoyage';

  @override
  String get metadataCleanupOrphans => 'Supprimer les orphelins';

  @override
  String get metadataCleanupOrphansDesc =>
      'Albums et artistes sans pistes associées';

  @override
  String get metadataClearLibrary => 'Vider la bibliothèque';

  @override
  String get metadataClearLibraryDesc => 'Supprime toutes les pistes locales';

  @override
  String get metadataCleanupOrphansTitle => 'Supprimer les orphelins ?';

  @override
  String get metadataCleanupOrphansBody =>
      'Les albums et artistes sans aucune piste associée seront supprimés de la base de données.';

  @override
  String get metadataClearLibraryTitle => 'Vider la bibliothèque ?';

  @override
  String get metadataClearLibraryBody =>
      'Toutes les pistes locales, albums et artistes seront supprimés de la base de données. Cette action est irréversible.';

  @override
  String get metadataOrphansDeleted => 'Orphelins supprimés';

  @override
  String get metadataLibraryCleared => 'Bibliothèque vidée';

  @override
  String get metadataDeleteBtn => 'Supprimer';

  @override
  String get metadataClearBtn => 'Vider';

  @override
  String get setupWelcomeTitle => 'Bienvenue dans\nTune Server';

  @override
  String get setupWelcomeBody =>
      'Votre serveur musical multi-room embarqué. Diffusez votre bibliothèque locale, vos services de streaming et vos radios vers n\'importe quelle enceinte DLNA ou AirPlay.';

  @override
  String get setupStart => 'Commencer';

  @override
  String get setupLocalTitle => 'Bibliothèque locale';

  @override
  String get setupLocalBody =>
      'Indiquez le chemin d\'un dossier contenant vos fichiers audio (FLAC, MP3, AAC…). Vous pourrez en ajouter d\'autres plus tard dans Paramètres.';

  @override
  String get setupFolderPath => 'Chemin du dossier';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => 'Ajouter ce dossier';

  @override
  String get setupFolderAdded => 'Dossier ajouté — scan en cours…';

  @override
  String get setupFolderEmpty => 'Veuillez indiquer un chemin de dossier';

  @override
  String get setupUPnPTitle => 'Serveurs UPnP/DLNA';

  @override
  String get setupUPnPBody =>
      'Tune Server découvre automatiquement les serveurs UPnP/DLNA sur votre réseau local. Naviguez dans leurs bibliothèques via Recherche → Parcourir.';

  @override
  String get setupFeatureSsdp => 'Découverte SSDP automatique';

  @override
  String get setupFeatureContentDir => 'Navigation ContentDirectory';

  @override
  String get setupFeaturePlayback => 'Lecture directe des fichiers DLNA';

  @override
  String get setupFinish => 'Terminer la configuration';

  @override
  String get libraryPlayAlbum => 'Lire l\'album';

  @override
  String get libraryPlayNext => 'Ajouter à la suite';

  @override
  String radioFavExportDone(String path) {
    return 'CSV exporté : $path';
  }

  @override
  String get radioFavExportError => 'Erreur lors de l\'export';

  @override
  String get streamingViewAlbum => 'Voir l\'album';

  @override
  String get streamingLogoutContent => 'Votre compte sera déconnecté.';

  @override
  String get streamingUrlCopied => 'URL copiée dans le presse-papiers';

  @override
  String get streamingDeviceCodeHint =>
      'Rendez-vous sur cette URL et entrez le code ci-dessus :';

  @override
  String get searchHintFull => 'Recherchez artistes, albums, pistes…';

  @override
  String get browseNavError => 'Erreur de navigation';

  @override
  String get streamingCodeEntered => 'J\'ai entré le code';

  @override
  String get appleMusicAuthorize => 'Autoriser l\'accès';

  @override
  String get smbNavTitle => 'Source SMB';

  @override
  String get smbTitle => 'Connexion SMB';

  @override
  String get smbHostHint => 'Entrez l\'adresse du serveur SMB';

  @override
  String get smbHostLabel => 'Adresse IP (ex: 192.168.1.23)';

  @override
  String get smbUser => 'Utilisateur';

  @override
  String get smbPassword => 'Mot de passe';

  @override
  String get smbConnect => 'Connexion';

  @override
  String get smbSelectShare => 'Sélectionnez un partage';

  @override
  String get smbBack => 'Retour';

  @override
  String get smbManualHint =>
      'Impossible de lister les partages automatiquement.\nEntrez le nom du partage manuellement :';

  @override
  String get smbShareName => 'Nom du partage (ex: Share, Music)';

  @override
  String get smbScan => 'Scanner';

  @override
  String get smbScanning => 'Scan en cours…';

  @override
  String smbScanCount(int count) {
    return '$count fichiers audio trouvés';
  }

  @override
  String get smbDoneTitle => 'Indexation terminée';

  @override
  String smbDoneBody(int count, String share) {
    return '$count pistes importées depuis $share';
  }

  @override
  String get smbAddAnother => 'Ajouter un autre partage';

  @override
  String get settingsSmb => 'Sources SMB / Samba';

  @override
  String get settingsSmbDesc => 'Indexer des bibliothèques sur partages réseau';

  @override
  String get podcastsTitle => 'Podcasts';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => 'Rechercher';

  @override
  String get podcastsEmpty => 'Aucun podcast';

  @override
  String get podcastsSearchHint => 'Rechercher un podcast…';

  @override
  String get podcastsNoEpisodes => 'Aucun épisode';

  @override
  String get navPodcasts => 'Podcasts';

  @override
  String get streamingConnectedSuccess => 'Connecté !';

  @override
  String browseItemCount(int count) {
    return '$count éléments';
  }

  @override
  String get settingsSources => 'Sources & Appareils';

  @override
  String get settingsSourcesDesc => 'Serveurs UPnP, renderers DLNA';

  @override
  String get sourcesTitle => 'Sources & Appareils';

  @override
  String get sourcesServersSection => 'Serveurs de contenu UPnP';

  @override
  String get sourcesRenderersSection => 'Renderers DLNA';

  @override
  String get sourcesNoDevices => 'Aucun appareil découvert';

  @override
  String get sourcesTypeServer => 'Serveur';

  @override
  String get sourcesTypeRenderer => 'Renderer';

  @override
  String get sourcesAvailable => 'Disponible';

  @override
  String get sourcesUnavailable => 'Hors ligne';

  @override
  String get sourcesIndexBtn => 'Indexer la bibliothèque';

  @override
  String get sourcesRescanBtn => 'Rescanner';

  @override
  String get sourcesForget => 'Oublier';

  @override
  String get sourcesAddManually => 'Ajouter manuellement';

  @override
  String get sourcesAddTitle => 'Sonde manuelle';

  @override
  String get sourcesIpLabel => 'Adresse IP';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => 'Port';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => 'Sondage en cours…';

  @override
  String get sourcesNotFound => 'Aucun appareil UPnP trouvé à cette adresse';

  @override
  String get zonesMultiRoom => 'Multi-Room';

  @override
  String get zonesCreateGroup => 'Créer un groupe';

  @override
  String get zonesGroupLeader => 'Leader';

  @override
  String get zonesGroupFollower => 'Suiveur';

  @override
  String get zonesGroupDissolve => 'Dissoudre le groupe';

  @override
  String get zonesGroupSyncDelay => 'Délai de synchro';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => 'Sélectionner les zones';

  @override
  String get zonesGroupSelectLeader => 'Sélectionner le leader';

  @override
  String get zonesGroupNoZones => 'Aucun groupe actif';

  @override
  String get zonesGroupNeedTwo => 'Sélectionnez au moins 2 zones';

  @override
  String get zonesGroupCreated => 'Groupe créé';

  @override
  String get zonesGroupDissolved => 'Groupe dissous';

  @override
  String get metadataSectionEnrich => 'Enrichir';

  @override
  String get metadataSectionDuplicates => 'Doublons';

  @override
  String get metadataSectionCorrect => 'Corriger';

  @override
  String get metadataFilterAll => 'Tous';

  @override
  String get metadataFilterMissingCover => 'Covers manquantes';

  @override
  String get metadataFilterMissingGenre => 'Genre manquant';

  @override
  String get metadataFilterMissingYear => 'Année manquante';

  @override
  String get metadataFilterMissingArtist => 'Artiste manquant';

  @override
  String get metadataFilterDoubtful => 'Douteux';

  @override
  String get metadataSearchHint => 'Rechercher des albums…';

  @override
  String get metadataArtistFilter => 'Artiste';

  @override
  String get metadataGenreFilter => 'Genre';

  @override
  String get metadataAllArtists => 'Tous les artistes';

  @override
  String get metadataAllGenres => 'Tous les genres';

  @override
  String get metadataNoAlbums => 'Aucun album correspondant';

  @override
  String get metadataEditAlbum => 'Modifier l\'album';

  @override
  String get metadataSaveChanges => 'Enregistrer';

  @override
  String get metadataWriteTags => 'Graver tags';

  @override
  String metadataWriteTagsSuccess(int count) {
    return 'Tags gravés : $count fichiers';
  }

  @override
  String get metadataMergeGroup => 'Fusionner';

  @override
  String metadataMergeConfirm(int count) {
    return 'Fusionner ces $count albums en un seul ? L\'album avec le plus de pistes sera conservé.';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return 'Fusionné : $moved pistes déplacées, $total au total';
  }

  @override
  String get metadataUploadCover => 'Uploader la cover';

  @override
  String get metadataCoverUploaded => 'Cover uploadée';

  @override
  String get metadataAlbumSaved => 'Album enregistré';

  @override
  String metadataDupAlbums(int count) {
    return '$count albums en double';
  }

  @override
  String get metadataDoubtfulReasons => 'Problèmes';

  @override
  String get metadataArtistField => 'Artiste';

  @override
  String get metadataAlbumField => 'Album';

  @override
  String get metadataGenreField => 'Genre';

  @override
  String get metadataYearField => 'Année';

  @override
  String metadataTracksCount(int count) {
    return '$count pistes';
  }

  @override
  String get stereoPairsTitle => 'Paires stéréo';

  @override
  String get stereoPairCreate => 'Créer une paire stéréo';

  @override
  String get stereoPairName => 'Nom de la paire';

  @override
  String get stereoPairNameHint => 'Ex : Salon Stéréo';

  @override
  String get stereoPairLeft => 'Gauche (L)';

  @override
  String get stereoPairRight => 'Droite (R)';

  @override
  String get stereoPairSelectDevice => 'Sélectionner un appareil';

  @override
  String get stereoPairNone => 'Aucune paire stéréo';

  @override
  String get stereoPairCreated => 'Paire stéréo créée';

  @override
  String get stereoPairDissolved => 'Paire stéréo dissoute';

  @override
  String get stereoPairDissolve => 'Dissoudre';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => 'Activer';

  @override
  String get streamingDisable => 'Désactiver';

  @override
  String get streamingEnabled => 'Service activé';

  @override
  String get streamingDisabled => 'Service désactivé';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Tune !';

  @override
  String get onboardingWelcomeBody =>
      'Votre serveur musical multi-room embarqué. Configurons ensemble votre installation en quelques étapes.';

  @override
  String get onboardingWelcomeStart => 'Commencer';

  @override
  String get onboardingConfigTitle => 'Configuration';

  @override
  String get onboardingConfigBody =>
      'Indiquez le chemin d\'un dossier contenant vos fichiers audio, ou connectez-vous à un serveur Tune distant.';

  @override
  String get onboardingConfigModeLocal => 'Serveur embarqué';

  @override
  String get onboardingConfigModeRemote => 'Serveur distant';

  @override
  String get onboardingZoneTitle => 'Créer une zone';

  @override
  String get onboardingZoneBody =>
      'Les appareils ci-dessous ont été découverts sur votre réseau. Touchez-en un pour créer votre première zone audio.';

  @override
  String get onboardingZoneEmpty =>
      'Aucun appareil découvert pour l\'instant. Vous pourrez en ajouter plus tard.';

  @override
  String onboardingZoneCreated(String name) {
    return 'Zone créée : $name';
  }

  @override
  String get onboardingDoneTitle => 'Terminé !';

  @override
  String get onboardingDoneBody =>
      'Votre installation est prête. Profitez de votre musique !';

  @override
  String get onboardingDoneButton => 'Accéder au tableau de bord';

  @override
  String get artistBio => 'Biographie';

  @override
  String get artistAnecdotes => 'Anecdotes';

  @override
  String get artistSimilarArtists => 'Artistes similaires';

  @override
  String get artistMembers => 'Membres';

  @override
  String get artistDiscography => 'Discographie';

  @override
  String get artistEnriching => 'Enrichissement en cours…';

  @override
  String get artistGenres => 'Genres';

  @override
  String get libraryShuffleAll => 'Lecture aléatoire de tout';

  @override
  String get librarySortBy => 'Trier par';

  @override
  String get librarySortTitle => 'Titre';

  @override
  String get librarySortArtist => 'Artiste';

  @override
  String get librarySortYear => 'Année';

  @override
  String get librarySortOriginalYear => 'Année originale';

  @override
  String get librarySortAddedDate => 'Date d\'ajout';

  @override
  String get librarySortAscending => 'Croissant';

  @override
  String get librarySortDescending => 'Décroissant';

  @override
  String get addFavorite => 'Ajouter aux favoris';

  @override
  String get addFolder => 'Ajouter un dossier';

  @override
  String get addThisFolder => 'Ajouter ce dossier';

  @override
  String get addToPlaylist => 'Ajouter à une playlist';

  @override
  String get addedToPlaylist => 'Ajouté à la playlist';

  @override
  String get audioOutput => 'Sortie audio';

  @override
  String get audioOutputDesc =>
      'Chaque zone du serveur correspond à une sortie (ALSA local, renderer Diretta…). Choisis la zone sur laquelle jouer.';

  @override
  String get authorizeInBrowser => 'Autorise l\'accès dans ton navigateur :';

  @override
  String get cancel => 'Annuler';

  @override
  String get connect => 'Connecter';

  @override
  String get connected => 'Connecté';

  @override
  String get cover => 'Pochette';

  @override
  String get create => 'Créer';

  @override
  String get createPlaylist => 'Créer une playlist';

  @override
  String get delete => 'Supprimer';

  @override
  String get deletePlaylist => 'Supprimer la playlist';

  @override
  String get deletePlaylistConfirm => 'Supprimer cette playlist ?';

  @override
  String get disabled => 'Désactivé';

  @override
  String get disconnected => 'Non connecté';

  @override
  String get done => 'J\'ai terminé';

  @override
  String get dynamicPlaylists => 'Playlists dynamiques';

  @override
  String get dynamicTag => 'Dynamique';

  @override
  String errorWith(String msg) {
    return 'Erreur : $msg';
  }

  @override
  String favError(String msg) {
    return 'Échec favori : $msg';
  }

  @override
  String get favoritesTitle => 'Favoris';

  @override
  String get filterAll => 'Tout';

  @override
  String get freqLimit => 'Limite de fréquence';

  @override
  String get gapless => 'Lecture enchaînée (gapless)';

  @override
  String get gaplessDesc =>
      'À désactiver si bruit blanc / glitch entre les pistes sur ce renderer.';

  @override
  String get host => 'Hôte';

  @override
  String get language => 'Langue';

  @override
  String get loading => 'Chargement…';

  @override
  String get localLibrary => 'Bibliothèque locale';

  @override
  String get localLibraryDesc => 'Dossiers où le serveur cherche la musique';

  @override
  String get logIn => 'Se connecter';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String loginTo(String service) {
    return 'Connexion $service';
  }

  @override
  String get maxBitDepth => 'Profondeur max';

  @override
  String get maxFrequency => 'Fréquence max';

  @override
  String maxTracks(int n) {
    return 'max $n';
  }

  @override
  String get metadataFields => 'Champs de métadonnées';

  @override
  String get metadataFieldsDesc =>
      'Infos affichées pour la bibliothèque locale';

  @override
  String get metadataSaved => 'Métadonnées enregistrées';

  @override
  String get musicFolders => 'Dossiers scannés';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get newPlaylist => 'Nouvelle playlist';

  @override
  String get noFavAlbums => 'Aucun album favori';

  @override
  String get noFavArtists => 'Aucun artiste favori';

  @override
  String get noFavTracks => 'Aucun titre favori';

  @override
  String get noFolders => 'Aucun dossier configuré';

  @override
  String get noLimit => 'Sans limite';

  @override
  String get noPlaylists => 'Aucune playlist';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noService => 'Aucun service';

  @override
  String get noTracks => 'Aucune piste';

  @override
  String get noZones => 'Aucune zone disponible';

  @override
  String get notConnected => 'Configure le serveur dans Paramètres';

  @override
  String get nothingPlaying => 'Rien en lecture';

  @override
  String get openAuthPage => 'Ouvrir la page d\'autorisation';

  @override
  String get password => 'Mot de passe';

  @override
  String get pickFolder => 'Choisir un dossier';

  @override
  String get playAll => 'Tout lire';

  @override
  String get playlistCreated => 'Playlist créée';

  @override
  String get playlistDeleted => 'Playlist supprimée';

  @override
  String get playlistsTitle => 'Playlists';

  @override
  String get port => 'Port';

  @override
  String get qualityCd => 'CD (44.1 kHz / 16 bit)';

  @override
  String get qualityHires => 'Hi-Res (jusqu\'à 192 kHz)';

  @override
  String get qualityMax => 'Maximum';

  @override
  String get removeFavorite => 'Retirer des favoris';

  @override
  String get removeFromPlaylist => 'Retirer de la playlist';

  @override
  String get runScan => 'Scanner la bibliothèque';

  @override
  String get scanning => 'Scan en cours…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · ta bibliothèque';

  @override
  String get searchEmptyTitle => 'Recherche un titre, un album ou un artiste';

  @override
  String get searchTitle => 'Recherche';

  @override
  String get sectionAlbums => 'Albums';

  @override
  String get sectionArtists => 'Artistes';

  @override
  String get sectionPlaylists => 'Playlists';

  @override
  String get sectionTracks => 'Titres';

  @override
  String get server => 'Serveur';

  @override
  String get sourceLibrary => 'Bibliothèque';

  @override
  String get streamingQuality => 'Qualité streaming';

  @override
  String get streamingQualityDesc =>
      'Plafonne la fréquence / résolution demandée aux services (Qobuz, Tidal…).';

  @override
  String get streamingServices => 'Services de streaming';

  @override
  String get systemLanguage => 'Système';

  @override
  String get trackRemoved => 'Retiré de la playlist';

  @override
  String tracksCount(int n) {
    return '$n pistes';
  }

  @override
  String get username => 'Identifiant / email';

  @override
  String get visualizer => 'Visualiseur';

  @override
  String get licenseSessionConflictTitle =>
      'Licence active sur un autre serveur';

  @override
  String get licenseSessionConflictBody =>
      'Votre licence Tune est déjà utilisée sur un autre de vos serveurs. Ce serveur repassera en Premium automatiquement quelques minutes après l\'arrêt de l\'autre.';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'Votre licence Tune est active sur « $server ». Ce serveur repassera en Premium automatiquement quelques minutes après l\'arrêt de l\'autre.';
  }

  @override
  String cfgSaveError(String detail) {
    return 'Erreur d\'enregistrement : $detail';
  }

  @override
  String get cfgReload => 'Recharger';

  @override
  String get cfgFieldsLoadError => 'Impossible de charger les champs';

  @override
  String get cfgFieldsNone => 'Aucun champ disponible';

  @override
  String get cfgFieldsHint =>
      'Choisissez les champs de métadonnées affichés dans la vue d\'édition de piste.';

  @override
  String get cfgMetaCompleteness => 'Complétude des métadonnées';

  @override
  String get cfgMetaEnrichMusicBrainz => 'Enrichir via MusicBrainz';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'Enrichissement MusicBrainz';

  @override
  String get cfgMetaFixYearsTidal => 'Corriger les années (TIDAL)';

  @override
  String get cfgMetaFixYearsDiscogs => 'Corriger les années (Discogs)';

  @override
  String get cfgMetaFixGenres => 'Corriger les genres';

  @override
  String get cfgMetaAutoFixAlbums => 'Corriger les albums automatiquement';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggestions en attente',
      one: '1 suggestion en attente',
      zero: 'Aucune suggestion en attente',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => 'Tout accepter';

  @override
  String get cfgMetaSuggestions => 'Suggestions';

  @override
  String get cfgMetaScanDuplicates => 'Rechercher les doublons';

  @override
  String get cfgMetaAutoMerge => 'Fusion automatique';

  @override
  String get cfgMetaMergeDuplicatesTask => 'Fusion des doublons';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$count albums en double ($groups groupes)',
      one: '$count albums en double (1 groupe)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… et $count autres groupes',
      one: '… et 1 autre groupe',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => 'Dernier résultat';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct % complet';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label : erreur — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label : $count acceptées';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label : $fixed/$total corrigés';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label : $fixed corrigés';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label : $total traités';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label : terminé';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return 'Erreur d\'écriture des tags : $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return 'Erreur d\'envoi : $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fusionner $count albums ?',
      one: 'Fusionner 1 album ?',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody =>
      'L\'album avec le plus de pistes sera conservé, les autres seront supprimés.';

  @override
  String cfgMetaMergeError(String detail) {
    return 'Erreur de fusion : $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => 'Statistiques indisponibles';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '1 album',
      zero: '0 album',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… et $count autres albums (filtrez pour affiner)',
      one: '… et 1 autre album (filtrez pour affiner)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count pistes';
  }

  @override
  String get cfgMetaReasonArtistUppercase => 'Artiste en MAJ';

  @override
  String get cfgMetaReasonArtistPlaceholder => 'Artiste provisoire';

  @override
  String get cfgMetaReasonArtistHasYear => 'Artiste = dossier';

  @override
  String get cfgMetaReasonGenrePlaceholder => 'Genre provisoire';

  @override
  String get cfgMetaReasonYearSuspicious => 'Année suspecte';

  @override
  String get cfgMetaReasonTitleUppercase => 'Titre en MAJ';

  @override
  String get cfgMetaReasonArtistMismatch => 'Artiste différent';

  @override
  String get cfgSmbNotConnected => 'Non connecté à un serveur distant';

  @override
  String cfgSmbMountTitle(String name) {
    return 'Monter $name';
  }

  @override
  String get cfgSmbMount => 'Monter';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name monté avec succès';
  }

  @override
  String get cfgSmbTitle => 'Partages réseau (SMB)';

  @override
  String get cfgSmbSearching => 'Recherche de partages SMB…';

  @override
  String get cfgSmbNone => 'Aucun partage SMB découvert';

  @override
  String get cfgSmbSaveCredentials => 'Sauvegarder les identifiants';

  @override
  String get cfgUnknown => 'Inconnu';

  @override
  String get cfgEqTitle => 'Égaliseur';

  @override
  String get cfgEqTabAssistant => 'Assistant';

  @override
  String get cfgEqTabExpert => 'Expert';

  @override
  String cfgEqError(String detail) {
    return 'Erreur EQ : $detail';
  }

  @override
  String get cfgEqPresetFlat => 'Plat';

  @override
  String get cfgEqPresetBassBoost => 'Basses renforcées';

  @override
  String get cfgEqPresetClassical => 'Classique';

  @override
  String get cfgEqPresetVocal => 'Voix';

  @override
  String get cfgNotConnectedToServer => 'Non connecté au serveur';

  @override
  String get cfgCredentialsRequired =>
      'L\'identifiant et le mot de passe sont requis';

  @override
  String cfgServiceConnected(String service) {
    return '$service connecté.';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service déconnecté.';
  }

  @override
  String get cfgLastfmTitle => 'Scrobbling Last.fm';

  @override
  String get cfgLastfmDesc =>
      'Envoyez votre historique d\'écoute à Last.fm. Les pistes sont scrobblées automatiquement lorsqu\'elles sont lues sur n\'importe quelle zone.';

  @override
  String get cfgDisconnecting => 'Déconnexion…';

  @override
  String get cfgConnectHeader => 'CONNEXION';

  @override
  String get cfgConnecting => 'Connexion…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scrobbles',
      one: '1 scrobble',
      zero: '0 scrobble',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return 'Dernier : $date';
  }

  @override
  String get cfgTokenRequired => 'Veuillez saisir votre jeton utilisateur';

  @override
  String get cfgScrobblerUnavailable => 'Scrobbler indisponible';

  @override
  String cfgConnectedAs(String name) {
    return 'Connecté en tant que $name';
  }

  @override
  String get cfgListenbrainzDesc =>
      'Envoyez votre historique d\'écoute à ListenBrainz. Récupérez votre jeton utilisateur sur listenbrainz.org/settings.';

  @override
  String get cfgUserToken => 'Jeton utilisateur';

  @override
  String get cfgValidating => 'Validation…';

  @override
  String get cfgSaveAndConnect => 'Enregistrer et connecter';

  @override
  String get cfgScrobbleAuto => 'Les pistes seront scrobblées automatiquement';

  @override
  String cfgConfigExported(String path) {
    return 'Configuration exportée : $path';
  }

  @override
  String get cfgConfigImported => 'Configuration importée avec succès';

  @override
  String cfgImportError(String detail) {
    return 'Erreur d\'import : $detail';
  }

  @override
  String get cfgConfigExportDesc =>
      'Sauvegarde la configuration du serveur dans un fichier JSON.';

  @override
  String get cfgConfigExportJson => 'Exporter en JSON';

  @override
  String get cfgConfigImportDesc =>
      'Restaure une configuration depuis un fichier JSON.';

  @override
  String get cfgChooseFile => 'Choisir un fichier';

  @override
  String get cfgDbNoServer => 'Aucun serveur connecté.';

  @override
  String cfgDbExportOk(String size, String path) {
    return 'Export réussi : $size Mo\n$path';
  }

  @override
  String get cfgDbPathUnavailable => 'Chemin du fichier inaccessible.';

  @override
  String get cfgDbImportConfirmTitle => 'Confirmer l\'import';

  @override
  String cfgDbImportConfirmBody(String name) {
    return 'Remplacer la base de données du serveur par « $name » ?\n\nUne sauvegarde de sécurité sera créée automatiquement. Le serveur devra être redémarré après l\'import.';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return 'Import réussi : $size Mo ($engine).\nRedémarrez le serveur pour appliquer les changements.';
  }

  @override
  String get cfgDbTitle => 'Base de données';

  @override
  String get cfgDbIntro =>
      'Exportez ou importez la base de données du serveur connecté.\nSQLite : fichier .db. PostgreSQL : dump SQL.';

  @override
  String get cfgDbExporting => 'Export en cours…';

  @override
  String get cfgDbExportBtn => 'Exporter la base';

  @override
  String get cfgDbImporting => 'Import en cours…';

  @override
  String get cfgDbImportBtn => 'Importer un fichier';

  @override
  String get cfgDbFooter =>
      'Après un import, redémarrez le serveur pour appliquer les changements. Une sauvegarde de sécurité est créée automatiquement avant le remplacement.';

  @override
  String cfgStatusUnavailable(String detail) {
    return 'Statut indisponible : $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune apparaît comme un récepteur Spotify Connect sur le réseau local. Depuis l\'app Spotify, sélectionnez « Tune (…) » dans la liste des appareils. Compte Spotify Premium requis côté client.';

  @override
  String get cfgSpotifyNoLibrespot => 'librespot non détecté sur le serveur';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      'Réinstallez Tune Server depuis le tarball/zip officiel pour que le binaire soit livré, ou installez-le séparément (apt install librespot / brew install librespot).';

  @override
  String get cfgTargetZone => 'Zone cible';

  @override
  String get cfgDeviceName => 'Nom de l\'appareil';

  @override
  String get cfgPlaying => 'En lecture';

  @override
  String get cfgNetDiagTitle => 'Diagnostic réseau';

  @override
  String get cfgNetSsdpActive => 'SSDP actif';

  @override
  String get cfgNetMulticastReachable => 'Multicast joignable';

  @override
  String get cfgError => 'Erreur';

  @override
  String get cfgNetResolution => 'Résolution';

  @override
  String get cfgNetLatency => 'Latence';

  @override
  String get cfgNetPublicIp => 'IP publique';

  @override
  String get cfgNetInterfaces => 'INTERFACES RÉSEAU';

  @override
  String get cfgStatusWarning => 'Attention';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total albums';
  }

  @override
  String get libNoCollectionsYet => 'Aucune collection pour le moment';

  @override
  String libRatingError(String error) {
    return 'Erreur de notation : $error';
  }

  @override
  String libDisc(int disc) {
    return 'Disque $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return 'Disque $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => 'Favori rapide';

  @override
  String get libAddToCollection => 'Ajouter à une collection';

  @override
  String get libAlbumNotes => 'Notes de l’album';

  @override
  String get libCredits => 'Crédits';

  @override
  String get libNoCredits => 'Aucun crédit';

  @override
  String get libNoAlbumNotes => 'Aucune note disponible pour cet album';

  @override
  String get libNoNotes => 'Aucune note disponible';

  @override
  String get libSourceCommunity => 'Communauté Tune';

  @override
  String libBioSource(String source) {
    return 'Source : $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return 'Source : $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied =>
      'Accès à la bibliothèque Apple Music refusé.';

  @override
  String get libAppleMusicPermissionRefused =>
      'Autorisation refusée. Activez l’accès dans Réglages > Confidentialité > Musique.';

  @override
  String get libUnknownError => 'Erreur inconnue';

  @override
  String get libAppleMusicAccessTitle => 'Accès à Apple Music';

  @override
  String get libAppleMusicAccessBody =>
      'Autorisez l’accès à votre bibliothèque musicale pour lire vos pistes Apple Music.';

  @override
  String get libAppleMusicEmpty => 'Bibliothèque Apple Music vide';

  @override
  String get libReportImageTitle => 'Signaler l’image';

  @override
  String get libReportImageBody =>
      'Signaler cette image d’artiste comme incorrecte ? Le serveur la remplacera lors du prochain enrichissement.';

  @override
  String get libReportAction => 'Signaler';

  @override
  String get libImageReported => 'Image signalée';

  @override
  String libServiceAlbums(String service) {
    return 'Albums $service';
  }

  @override
  String libTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistes',
      one: '1 piste',
      zero: '0 piste',
    );
    return '$_temp0';
  }

  @override
  String get libDuplicateScanner => 'Recherche de doublons';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$groups groupes de doublons trouvés',
      one: '1 groupe de doublons trouvé',
    );
    return '$_temp0 ($tracks pistes au total)';
  }

  @override
  String get libFindDuplicatesTitle => 'Rechercher les pistes en double';

  @override
  String get libFindDuplicatesBody =>
      'Analyse les empreintes du contenu audio pour trouver les pistes identiques de votre bibliothèque.';

  @override
  String get libStartScan => 'Lancer l’analyse';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total pistes ($percent %)';
  }

  @override
  String get libLoadingTracks => 'Chargement des pistes…';

  @override
  String get libNoDuplicatesFound => 'Aucun doublon trouvé';

  @override
  String get libLibraryClean => 'Votre bibliothèque est propre.';

  @override
  String get libScanAgain => 'Relancer l’analyse';

  @override
  String get libScanFailed => 'Échec de l’analyse';

  @override
  String get libTrackNumberField => 'Piste n°';

  @override
  String get libDiscNumberField => 'Disque n°';

  @override
  String get libExtendedMetadata => 'Métadonnées étendues';

  @override
  String get libGenreTreeSaved => 'Arborescence des genres enregistrée';

  @override
  String libSaveError(String error) {
    return 'Erreur d’enregistrement : $error';
  }

  @override
  String get libGenreTree => 'Arborescence des genres';

  @override
  String get libAddRootGenre => 'Ajouter un genre racine';

  @override
  String get libGenreTreeRequiresRemote =>
      'L’arborescence des genres nécessite une connexion à un serveur distant.';

  @override
  String get libNoGenreHierarchy => 'Aucune hiérarchie de genres définie';

  @override
  String libAddSubGenreTo(String parent) {
    return 'Ajouter un sous-genre à « $parent »';
  }

  @override
  String get libGenreName => 'Nom du genre';

  @override
  String libSubGenreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sous-genres',
      one: '1 sous-genre',
    );
    return '$_temp0';
  }

  @override
  String get libAddSubGenre => 'Ajouter un sous-genre';

  @override
  String get libRemove => 'Retirer';

  @override
  String libRemoveNamedConfirm(String name) {
    return 'Retirer « $name » ?';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ses $count sous-genres seront également retirés.',
      one: 'Son sous-genre sera également retiré.',
    );
    return '$_temp0';
  }

  @override
  String get libRemoveGenreBody => 'Ce genre sera retiré de l’arborescence.';

  @override
  String libAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '1 album',
      zero: '0 album',
    );
    return '$_temp0';
  }

  @override
  String get libNoTracksForFilter => 'Aucune piste avec ce filtre';

  @override
  String get libQualityLossless => 'Sans perte';

  @override
  String get libQualityLossy => 'Avec perte';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total pistes';
  }

  @override
  String get libNewCollection => 'Nouvelle collection';

  @override
  String get libCollectionName => 'Nom de la collection';

  @override
  String libCreateError(String error) {
    return 'Erreur de création : $error';
  }

  @override
  String libDeleteError(String error) {
    return 'Erreur de suppression : $error';
  }

  @override
  String get libCollectionsTitle => 'Collections';

  @override
  String get libCollectionsLoadFailed =>
      'Impossible de charger les collections';

  @override
  String get libDeleteCollectionTitle => 'Supprimer la collection ?';

  @override
  String libDeleteCollectionBody(String name) {
    return '« $name » sera supprimée définitivement.';
  }

  @override
  String get libNoAlbumsInCollection => 'Aucun album dans cette collection';

  @override
  String get libDeleteConfirmTitle => 'Supprimer ?';

  @override
  String get libDeleteSmartCollectionBody =>
      'Cette collection intelligente sera supprimée définitivement.';

  @override
  String get libNoRules => 'aucune règle';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return 'crédit : $role=$artist';
  }

  @override
  String get libAnd => 'ET';

  @override
  String get libOr => 'OU';

  @override
  String get libSmartCollections => 'Collections intelligentes';

  @override
  String get libNewSmartCollection => 'Nouvelle collection intelligente';

  @override
  String get libNoSmartCollections => 'Aucune collection intelligente';

  @override
  String get libSmartCollectionsSeedHint =>
      'Le serveur crée normalement 7 collections par défaut au premier démarrage.';

  @override
  String get libCreateFirstSmartCollection =>
      'Créer ma première collection intelligente';

  @override
  String get libNoMatchingAlbums => 'Aucun album ne correspond';

  @override
  String get libSmartCreditsHint =>
      'Pour les règles basées sur les crédits (engineer, performer, …), enrichissez d’abord la bibliothèque depuis les Paramètres.';

  @override
  String get libFieldSampleRate => 'Fréquence d’échantillonnage';

  @override
  String get libFieldBitDepth => 'Résolution (bits)';

  @override
  String get libFieldTrackCount => 'Nb de pistes';

  @override
  String get libFieldFormat => 'Format';

  @override
  String get libFieldLabel => 'Label';

  @override
  String get libFieldAlbumTitle => 'Titre de l’album';

  @override
  String get libFieldSource => 'Source';

  @override
  String get libFieldCredit => 'Crédit';

  @override
  String get libFieldPlayCount => 'Nb de lectures';

  @override
  String get libFieldLastPlayed => 'Dernière lecture';

  @override
  String get libOpBetween => 'entre';

  @override
  String get libOpContains => 'contient';

  @override
  String get libOpStartsWith => 'commence par';

  @override
  String get libOpEmpty => 'vide';

  @override
  String get libOpNotEmpty => 'non vide';

  @override
  String get libOpNever => 'jamais';

  @override
  String get libOpAfter => 'après';

  @override
  String get libOpBefore => 'avant';

  @override
  String get libNameLabel => 'Nom';

  @override
  String get libMatchMode => 'Combinaison';

  @override
  String get libMatchAll => 'Toutes les règles (ET)';

  @override
  String get libMatchAny => 'Au moins une (OU)';

  @override
  String get libAddRule => 'Ajouter une règle';

  @override
  String get libMatchingAlbumsPending => '… albums correspondants';

  @override
  String libMatchingAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums correspondants',
      one: '1 album correspondant',
      zero: '0 album correspondant',
    );
    return '$_temp0';
  }

  @override
  String get libTimestampHint => 'now-30d ou 2024-01-01';

  @override
  String get libValueHint => 'valeur';

  @override
  String get libMinHint => 'min';

  @override
  String get libMaxHint => 'max';

  @override
  String get libCommaSeparatedHint => 'valeurs séparées par des virgules';

  @override
  String get libCreditRoleHint => 'rôle (engineer, performer, …)';

  @override
  String get libCreditArtistHint => 'artiste (Rudy Van Gelder, …)';

  @override
  String get libCreditInstrumentHint => 'instrument (Piano, …) — facultatif';

  @override
  String get libDirectories => 'Répertoires';

  @override
  String get libLoadError => 'Erreur de chargement';

  @override
  String get libNoFolders => 'Aucun dossier';

  @override
  String get libAddFoldersInSettings =>
      'Ajoutez des dossiers musicaux dans les Paramètres';

  @override
  String get libFoldersHeader => 'Dossiers';

  @override
  String libTracksHeaderCount(int count) {
    return 'Pistes ($count)';
  }

  @override
  String get libPlayFromHere => 'Lire à partir d’ici';

  @override
  String get libTags => 'Tags';

  @override
  String get libNewTagHint => 'Nouveau tag…';

  @override
  String get libJustNow => 'À l’instant';

  @override
  String libMinutesAgo(int count) {
    return 'Il y a $count min';
  }

  @override
  String libHoursAgo(int count) {
    return 'Il y a $count h';
  }

  @override
  String get libYesterday => 'Hier';

  @override
  String libDaysAgo(int count) {
    return 'Il y a $count j';
  }

  @override
  String get libNowListening => 'En cours d’écoute';

  @override
  String get libContinueListening => 'Continuer l’écoute';

  @override
  String get libRecentlyAdded => 'Récemment ajouté';

  @override
  String get libTopTracks => 'Titres les plus écoutés';

  @override
  String get libTopArtists => 'Artistes les plus écoutés';

  @override
  String get libRecommendations => 'Recommandations';

  @override
  String get libSourceLocal => 'Local';

  @override
  String get libFieldDuration => 'Durée';

  @override
  String get libFilter => 'Filtrer';

  @override
  String get libRefreshAll => 'Tout actualiser';

  @override
  String get libPodcastsSubscribed => 'Abonnements';

  @override
  String get libNoSubscriptions => 'Aucun abonnement pour le moment';

  @override
  String get libSubscribeRssFeed => 'S’abonner à un flux RSS';

  @override
  String get libUnknown => 'Inconnu';

  @override
  String get libUnsubscribeTitle => 'Se désabonner ?';

  @override
  String libUnsubscribeBody(String name) {
    return 'Se désabonner de « $name » ?';
  }

  @override
  String get libUnsubscribe => 'Se désabonner';

  @override
  String libEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count épisodes',
      one: '1 épisode',
      zero: '0 épisode',
    );
    return '$_temp0';
  }

  @override
  String get libSubscribeToPodcast => 'S’abonner à un podcast';

  @override
  String get libRssFeedUrl => 'URL du flux RSS';

  @override
  String get libSubscribe => 'S’abonner';

  @override
  String get libSubscribed => 'Abonnement effectué.';

  @override
  String libSubscribeError(String error) {
    return 'Erreur d’abonnement : $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return 'Erreur de désabonnement : $error';
  }

  @override
  String get libPodcastRefreshed => 'Podcast actualisé.';

  @override
  String libRefreshError(String error) {
    return 'Erreur d’actualisation : $error';
  }

  @override
  String get libAllPodcastsRefreshed => 'Tous les podcasts ont été actualisés.';

  @override
  String get libToday => 'Aujourd’hui';

  @override
  String get miscNavFolders => 'Répertoires';

  @override
  String get miscNavCollections => 'Collections';

  @override
  String get miscNavSmartCollections => 'Collections intelligentes';

  @override
  String get miscNavDjMode => 'Mode DJ';

  @override
  String get miscNavPartyMode => 'Mode soirée';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => 'Soirée';

  @override
  String get miscNavSmartPlaylists => 'Playlists intelligentes';

  @override
  String get miscNavAlarms => 'Alarmes';

  @override
  String get miscNavGenreTree => 'Arbre des genres';

  @override
  String get miscNavDashboard => 'Tableau de bord';

  @override
  String get miscNavDiagnostics => 'Diagnostics';

  @override
  String get miscNavAdmin => 'Administration';

  @override
  String get miscNavMore => 'Plus';

  @override
  String get miscNextTrack => 'Piste suivante';

  @override
  String get miscPreviousTrack => 'Piste précédente';

  @override
  String get miscUnknownError => 'Erreur inconnue';

  @override
  String get miscAuthorizationCode => 'Code d\'autorisation';

  @override
  String get miscWaitingForValidation => 'En attente de la validation…';

  @override
  String miscCodeValue(String code) {
    return 'Code : $code';
  }

  @override
  String get miscQualityHigh => 'Haute';

  @override
  String get miscExplore => 'Explorer';

  @override
  String get miscFavoriteAlbums => 'Albums favoris';

  @override
  String get miscFavoriteTracks => 'Titres favoris';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voir les $count titres',
      one: 'Voir 1 titre',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => 'Mes playlists';

  @override
  String get miscNoApiClient => 'Aucun client API';

  @override
  String miscServiceFavorites(String service) {
    return 'Favoris $service';
  }

  @override
  String miscPlayAllCount(int count) {
    return 'Tout lire ($count)';
  }

  @override
  String get miscServiceNotFound => 'Service introuvable';

  @override
  String get miscYtHome => 'Accueil';

  @override
  String get miscYtCharts => 'Classements';

  @override
  String get miscYtMoods => 'Ambiances';

  @override
  String get miscNoData => 'Aucune donnée';

  @override
  String get miscNoContentAvailable => 'Aucun contenu disponible';

  @override
  String get miscNoChartsAvailable => 'Aucun classement disponible';

  @override
  String get miscNoMoodsAvailable => 'Aucune ambiance disponible';

  @override
  String get miscDashTotalPlays => 'Écoutes totales';

  @override
  String get miscDashListeningTime => 'Temps d\'écoute';

  @override
  String get miscDashUniqueTracks => 'Titres distincts';

  @override
  String get miscDashUniqueArtists => 'Artistes distincts';

  @override
  String get miscDashTopArtists => 'ARTISTES LES PLUS ÉCOUTÉS';

  @override
  String get miscDashTopAlbums => 'ALBUMS LES PLUS ÉCOUTÉS';

  @override
  String get miscDashTopTracks => 'TITRES LES PLUS ÉCOUTÉS';

  @override
  String get miscDashListeningByHour => 'ÉCOUTE PAR HEURE';

  @override
  String get miscDashListeningByDay => 'ÉCOUTE PAR JOUR';

  @override
  String get miscDashAllTime => 'Depuis le début';

  @override
  String miscDashLastDays(int days) {
    return '$days jours';
  }

  @override
  String get miscUnknown => 'Inconnu';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count écoutes',
      one: '1 écoute',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => 'Aucune donnée d\'écoute pour l\'instant';

  @override
  String get miscDashNoDataHint =>
      'Écoutez de la musique pour voir vos statistiques ici.';

  @override
  String get miscDashLoadFailed => 'Impossible de charger le tableau de bord';

  @override
  String get miscDiagRequiresRemote =>
      'Les diagnostics nécessitent une connexion à un serveur distant.';

  @override
  String get miscDiagSystem => 'Système';

  @override
  String get miscDiagHealth => 'État';

  @override
  String get miscVersion => 'Version';

  @override
  String get miscDiagUptime => 'Temps de fonctionnement';

  @override
  String get miscDiagMemory => 'Mémoire';

  @override
  String get miscDiagDatabase => 'Base de données';

  @override
  String miscZoneNumbered(String id) {
    return 'Zone $id';
  }

  @override
  String get miscDiagLogs => 'Journaux';

  @override
  String get miscDiagNoLogs => 'Aucun journal disponible';

  @override
  String get miscAdminTitle => 'Tableau de bord d\'administration';

  @override
  String get miscAdminNotConnected => 'Non connecté à un serveur distant';

  @override
  String get miscAdminSystemHealth => 'Santé du système';

  @override
  String get miscAdminStatus => 'Statut';

  @override
  String get miscAdminDisk => 'Disque';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return 'Appareils découverts ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return 'Erreurs récentes ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => 'Aucune erreur récente';

  @override
  String get miscTroubleshootingTitle => 'Dépannage';

  @override
  String get miscFaqHeader => 'Questions fréquentes';

  @override
  String get miscFaq1Title => 'Je ne vois pas mon serveur';

  @override
  String get miscFaq1Step1 =>
      'Vérifiez que le serveur Tune est démarré et accessible.';

  @override
  String get miscFaq1Step2 =>
      'Assurez-vous que votre appareil est connecté au même réseau Wi-Fi que le serveur.';

  @override
  String get miscFaq1Step3 =>
      'Si vous utilisez un VPN, désactivez-le ou activez la découverte LAN (ex. : nordvpn set lan-discovery on).';

  @override
  String get miscFaq1Step4 =>
      'Essayez de scanner le réseau depuis Paramètres > Mode > Scanner le réseau.';

  @override
  String get miscFaq1Step5 =>
      'Vérifiez que le port du serveur (8888 par défaut) n\'est pas bloqué par un pare-feu.';

  @override
  String get miscFaq1Step6 => 'Redémarrez le serveur et l\'application.';

  @override
  String get miscFaq2Title => 'La musique ne joue pas';

  @override
  String get miscFaq2Step1 =>
      'Vérifiez qu\'une zone de lecture est sélectionnée (barre en bas de l\'écran).';

  @override
  String get miscFaq2Step2 =>
      'Si aucune zone n\'existe, créez-en une dans Paramètres > Audio > Zones > Créer.';

  @override
  String get miscFaq2Step3 =>
      'Vérifiez que l\'appareil de sortie (enceinte, DAC) est allumé et sur le même réseau.';

  @override
  String get miscFaq2Step4 =>
      'Pour les appareils DLNA, attendez quelques secondes après la découverte avant de lancer la lecture.';

  @override
  String get miscFaq2Step5 =>
      'Essayez un autre fichier — le format du fichier actuel n\'est peut-être pas pris en charge.';

  @override
  String get miscFaq2Step6 =>
      'Redémarrez l\'application si le problème persiste.';

  @override
  String get miscFaq3Title => 'Les pochettes ne s\'affichent pas';

  @override
  String get miscFaq3Step1 =>
      'Lancez un scan de la bibliothèque depuis Paramètres > Bibliothèque > Sources.';

  @override
  String get miscFaq3Step2 =>
      'Vérifiez que les fichiers contiennent des pochettes embarquées (tags ID3/Vorbis).';

  @override
  String get miscFaq3Step3 =>
      'Placez un fichier cover.jpg ou folder.jpg dans le dossier de l\'album.';

  @override
  String get miscFaq3Step4 =>
      'Activez la récupération automatique des pochettes dans Paramètres > Bibliothèque > Métadonnées.';

  @override
  String get miscFaq3Step5 =>
      'Purgez le cache des images en redémarrant l\'application.';

  @override
  String get miscFaq4Title => 'Le scan est bloqué';

  @override
  String get miscFaq4Step1 =>
      'Un premier scan peut prendre plusieurs minutes selon la taille de la bibliothèque.';

  @override
  String get miscFaq4Step2 =>
      'Vérifiez que les dossiers musicaux sont accessibles (permissions, montages SMB).';

  @override
  String get miscFaq4Step3 =>
      'Fermez et relancez l\'application pour interrompre un scan bloqué.';

  @override
  String get miscFaq4Step4 =>
      'Consultez les journaux du serveur pour identifier un fichier problématique.';

  @override
  String get miscFaq4Step5 =>
      'Essayez de réduire le nombre de dossiers sources pour isoler le problème.';

  @override
  String get miscFaq5Title => 'Comment connecter un appareil DLNA/AirPlay';

  @override
  String get miscFaq5Step1 =>
      'DLNA : l\'appareil doit être allumé et sur le même réseau. Il apparaît automatiquement dans la liste des sorties.';

  @override
  String get miscFaq5Step2 =>
      'Si l\'appareil n\'apparaît pas, vérifiez que le multicast fonctionne sur votre routeur.';

  @override
  String get miscFaq5Step3 =>
      'Certains routeurs bloquent le trafic SSDP entre les clients Wi-Fi — activez le relais multicast.';

  @override
  String get miscFaq5Step4 =>
      'BluOS : les enceintes Bluesound sont détectées automatiquement.';

  @override
  String get miscFaq5Step5 =>
      'Chromecast : les appareils Google Cast apparaissent dans les sorties disponibles.';

  @override
  String get miscFaq5Step6 =>
      'Après la détection, créez une zone et assignez-y l\'appareil comme sortie.';

  @override
  String get miscFaq6Title => 'Problèmes de streaming';

  @override
  String get miscFaq6Step1 =>
      'Vérifiez que vos identifiants de service (TIDAL, Qobuz, Deezer) sont corrects dans Paramètres > Streaming.';

  @override
  String get miscFaq6Step2 =>
      'Si la session a expiré, déconnectez puis reconnectez le service.';

  @override
  String get miscFaq6Step3 => 'Vérifiez votre connexion Internet.';

  @override
  String get miscFaq6Step4 =>
      'Certains titres peuvent être indisponibles dans votre région.';

  @override
  String get miscFaq6Step5 =>
      'Pour les problèmes de qualité, vérifiez les réglages de qualité streaming dans Paramètres > Audio avancé.';

  @override
  String get miscFaq6Step6 =>
      'Si le problème persiste, envoyez un rapport de bug depuis Paramètres > Aide.';

  @override
  String get miscBugReportCopied => 'Rapport copié dans le presse-papiers';

  @override
  String get miscBugReportSent => 'Bug envoyé, merci !';

  @override
  String get miscBugReportSendFailed =>
      'Échec de l\'envoi. Copie le rapport dans le forum.';

  @override
  String get miscBugReportTitle => 'Rapport de bug';

  @override
  String get miscRegenerate => 'Régénérer';

  @override
  String get miscBugReportGenerateFailed => 'Impossible de générer le rapport';

  @override
  String get miscSent => 'Envoyé !';

  @override
  String get miscSending => 'Envoi…';

  @override
  String get miscSubmit => 'Soumettre';

  @override
  String get miscCopied => 'Copié !';

  @override
  String get miscCopyReport => 'Copier le rapport';

  @override
  String get miscAiServerNotConnected =>
      'Serveur non connecté. Vérifiez la connexion.';

  @override
  String miscAiQueryFailed(int code) {
    return 'Échec de la requête IA ($code)';
  }

  @override
  String get miscAiNoReply => 'Pas de réponse';

  @override
  String get miscAiAskHint => 'Posez une question…';

  @override
  String get miscAiSend => 'Envoyer';

  @override
  String get miscAiTitle => 'Assistant IA';

  @override
  String get miscAiEmptyTitle => 'Assistant IA Tune';

  @override
  String get miscAiEmptyBody =>
      'Posez une question sur votre musique,\ndemandez des recommandations…';

  @override
  String miscAiAction(String action) {
    return 'Action : $action';
  }

  @override
  String get miscCreateAccount => 'Créer un compte';

  @override
  String get miscUsername => 'Nom d\'utilisateur';

  @override
  String get miscUsernameRequired => 'Nom d\'utilisateur requis';

  @override
  String get miscEmailRequired => 'E-mail requis';

  @override
  String get miscEmailInvalid => 'E-mail invalide';

  @override
  String get miscPasswordRequired => 'Mot de passe requis';

  @override
  String miscPasswordMinLength(int min) {
    return '$min caractères minimum';
  }

  @override
  String get miscHaveAccountSignIn => 'Déjà un compte ? Se connecter';

  @override
  String get miscNoAccountSignUp => 'Pas de compte ? S\'inscrire';

  @override
  String get npRepeat => 'Répéter';

  @override
  String get npQueue => 'File de lecture';

  @override
  String get npFavorite => 'Favori';

  @override
  String get npRadioFavAdded => 'Ajouté aux favoris radio';

  @override
  String get npLyrics => 'Paroles';

  @override
  String get npAlarm => 'Réveil';

  @override
  String get npSleepTimer => 'Minuterie de veille';

  @override
  String get npDspCrossfeed => 'Crossfeed DSP';

  @override
  String get npEqualizer => 'Égaliseur';

  @override
  String get npShare => 'Partager';

  @override
  String get npTransfer => 'Transférer';

  @override
  String get npCopiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get npNoLyricsFound => 'Aucunes paroles trouvées';

  @override
  String get npNoLyricsAvailable => 'Paroles indisponibles';

  @override
  String get npLyricsOpenFromNowPlaying =>
      'Ouvrez depuis « Lecture en cours » pour les paroles complètes';

  @override
  String get npLyricsLoadFailed => 'Impossible de charger les paroles';

  @override
  String get npLrcMetadataTooltip => 'Métadonnées';

  @override
  String get npLrcMetadataTitle => 'Métadonnées LRC';

  @override
  String get npLrcTitle => 'Titre';

  @override
  String get npLrcCreatedBy => 'Créé par';

  @override
  String get npLrcOffset => 'Décalage (ms)';

  @override
  String get npLrcHint =>
      'Placez un fichier .lrc du même nom à côté du fichier audio.';

  @override
  String get npEqFlat => 'Neutre';

  @override
  String get npEqBassBoost => 'Basses renforcées';

  @override
  String get npEqTrebleBoost => 'Aigus renforcés';

  @override
  String get npEqVocal => 'Voix';

  @override
  String get npEqRock => 'Rock';

  @override
  String get npEqJazz => 'Jazz';

  @override
  String get npEqClassical => 'Classique';

  @override
  String get npEqElectronic => 'Électronique';

  @override
  String get npEqHipHop => 'Hip-hop';

  @override
  String get npEqAcoustic => 'Acoustique';

  @override
  String npEqApplied(String preset) {
    return 'Égaliseur : $preset';
  }

  @override
  String npEqError(String error) {
    return 'Erreur d’égaliseur : $error';
  }

  @override
  String get npCrossfeedDesc =>
      'Mélange les canaux stéréo pour une écoute au casque plus naturelle';

  @override
  String get npCrossfeedOff => 'Désactivé';

  @override
  String get npCrossfeedLight => 'Léger';

  @override
  String get npCrossfeedMedium => 'Moyen';

  @override
  String get npCrossfeedStrong => 'Fort';

  @override
  String npCrossfeedApplied(String level) {
    return 'Crossfeed : $level';
  }

  @override
  String npDspError(String error) {
    return 'Erreur DSP : $error';
  }

  @override
  String get npTransferTitle => 'Transférer la lecture';

  @override
  String get npNoOtherZones => 'Aucune autre zone disponible';

  @override
  String npTransferredTo(String zone) {
    return 'Transféré vers $zone';
  }

  @override
  String npTransferError(String error) {
    return 'Erreur de transfert : $error';
  }

  @override
  String get npAlarmClock => 'Réveil';

  @override
  String npAlarmSetFor(String time) {
    return 'Réveil réglé à $time';
  }

  @override
  String npAlarmError(String error) {
    return 'Erreur de réveil : $error';
  }

  @override
  String get npAlarmCancelled => 'Réveil annulé';

  @override
  String get npPause => 'Pause';

  @override
  String get npStop => 'Arrêter';

  @override
  String get npRoleComposer => 'Compositeur';

  @override
  String get npRoleLyricist => 'Parolier';

  @override
  String get npRoleArranger => 'Arrangeur';

  @override
  String get npRoleConductor => 'Chef d’orchestre';

  @override
  String get npRolePerformer => 'Interprète';

  @override
  String get npRoleProducer => 'Producteur';

  @override
  String get npRoleMixer => 'Mixage';

  @override
  String get npRoleEngineer => 'Ingénieur du son';

  @override
  String get npCreditsEnriching => 'Enrichissement…';

  @override
  String get npCreditsEnrich => 'Enrichir via MusicBrainz';

  @override
  String get npVolume => 'Volume';

  @override
  String get npChangeZone => 'Changer de zone';

  @override
  String get npZoneFallback => 'Zone';

  @override
  String get npFollowMe => 'Suivez-moi';

  @override
  String get npMovePlaybackTo => 'Amener la lecture vers…';

  @override
  String get npNowPlaying => 'Lecture en cours';

  @override
  String get npTabMore => 'Plus';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return 'Minuterie réglée : $minutes min (fondu : $fade s)';
  }

  @override
  String npSleepTimerError(String error) {
    return 'Erreur de minuterie : $error';
  }

  @override
  String get npSleepTimerCancelled => 'Minuterie annulée';

  @override
  String get npSleepDuration => 'DURÉE';

  @override
  String get npSleepCustom => 'Personnalisée';

  @override
  String get npSleepFadeOut => 'FONDU DE SORTIE';

  @override
  String npSleepFadeDesc(int seconds) {
    return 'Le volume baissera progressivement jusqu’à zéro pendant les $seconds dernières secondes.';
  }

  @override
  String get npSleepStarting => 'Démarrage…';

  @override
  String npSleepStart(String duration) {
    return 'Démarrer ($duration)';
  }

  @override
  String get npSleepSelectDuration => 'Choisir une durée';

  @override
  String get npSleepTimerActive => 'Minuterie active';

  @override
  String get npSleepCancelTimer => 'Annuler la minuterie';

  @override
  String get npMoodChill => 'Détente';

  @override
  String get npMoodParty => 'Fête';

  @override
  String get npMoodFocus => 'Concentration';

  @override
  String get npMoodEnergetic => 'Énergique';

  @override
  String get npNoZoneAvailable => 'Aucune zone disponible';

  @override
  String npMoodNoTracks(String mood) {
    return 'Aucune piste trouvée pour $mood';
  }

  @override
  String get npMoodInvalidTrackIds =>
      'Erreur : identifiants de pistes invalides';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistes en lecture',
      one: '1 piste en lecture',
    );
    return 'Mix $mood : $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistes ajoutées à la file',
      one: '1 piste ajoutée à la file',
    );
    return 'Mix $mood : $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Erreur Smart AutoPlay : $error';
  }

  @override
  String get npSmartAutoplayDesc =>
      'Choisissez une ambiance pour générer une playlist intelligente';

  @override
  String get npAlarmsNotConnected => 'Non connecté à un serveur distant';

  @override
  String get npAlarmSnoozed => 'Réveil reporté de 5 min';

  @override
  String get npAlarmsTitle => 'Réveils';

  @override
  String get npAlarmsEmpty => 'Aucun réveil';

  @override
  String npZoneNumbered(String id) {
    return 'Zone $id';
  }

  @override
  String get npAlarmSkipsHolidays => 'Hors jours fériés';

  @override
  String get npAlarmSnooze => 'Rappel';

  @override
  String get npAlarmDefaultName => 'Réveil';

  @override
  String get npAlarmEdit => 'Modifier le réveil';

  @override
  String get npAlarmNew => 'Nouveau réveil';

  @override
  String get npAlarmTime => 'Heure';

  @override
  String get npAlarmNameHint => 'Réveil';

  @override
  String get npAlarmDays => 'Jours';

  @override
  String get npAlarmSkipHolidays => 'Ignorer les jours fériés';

  @override
  String get npAlarmCountry => 'Pays :';

  @override
  String get npCountryFR => 'France';

  @override
  String get npCountryBE => 'Belgique';

  @override
  String get npCountryCH => 'Suisse';

  @override
  String get npCountryCA => 'Canada';

  @override
  String get npCountryUS => 'États-Unis';

  @override
  String get npCountryDE => 'Allemagne';

  @override
  String get npCountryGB => 'Royaume-Uni';

  @override
  String get npAlarmSource => 'Source';

  @override
  String get npAlarmSourceType => 'Type';

  @override
  String get npSourceRadio => 'Radio';

  @override
  String get npSourcePlaylist => 'Playlist';

  @override
  String get npSourceAlbum => 'Album';

  @override
  String get npAlarmSourceName => 'Nom de la source';

  @override
  String get npAlarmPlaylistId => 'ID de la playlist';

  @override
  String get npAlarmAlbumId => 'ID de l’album';

  @override
  String get npAlarmIdentifier => 'Identifiant';

  @override
  String get npAlarmPlaybackZone => 'Zone de lecture';

  @override
  String get npAlarmDefaultZone => 'Par défaut';

  @override
  String npAlarmVolume(int percent) {
    return 'Volume : $percent %';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return 'Fondu : $seconds s';
  }

  @override
  String get npAlarmEnabled => 'Activé';

  @override
  String get npAlarmDeleteTitle => 'Supprimer le réveil ?';

  @override
  String get npDayMon => 'Lun';

  @override
  String get npDayTue => 'Mar';

  @override
  String get npDayWed => 'Mer';

  @override
  String get npDayThu => 'Jeu';

  @override
  String get npDayFri => 'Ven';

  @override
  String get npDaySat => 'Sam';

  @override
  String get npDaySun => 'Dim';

  @override
  String get plHubTitle => 'Hub des playlists';

  @override
  String get plTabSmartAi => 'IA';

  @override
  String get plTabTransfers => 'Transferts';

  @override
  String get plSync => 'Synchro';

  @override
  String get plTabBackup => 'Sauvegarde';

  @override
  String get plCompare => 'Comparer';

  @override
  String get plComparing => 'Comparaison…';

  @override
  String plCompareError(String detail) {
    return 'Échec de la comparaison : $detail';
  }

  @override
  String get plNoPlaylistsAvailable => 'Aucune playlist disponible';

  @override
  String get plSectionSource => 'SOURCE';

  @override
  String get plSectionTarget => 'DESTINATION';

  @override
  String get plServiceLabel => 'Service';

  @override
  String get plPlaylistLabel => 'Playlist';

  @override
  String get plLocal => 'Local';

  @override
  String get plRestore => 'Restaurer';

  @override
  String get plSyncIntervalTitle => 'Intervalle de synchro auto';

  @override
  String get plSyncIntervalLabel => 'Minutes (0 = manuel uniquement) :';

  @override
  String get plSyncIntervalHint => 'ex. : 60';

  @override
  String get plNoTransfers => 'Aucun transfert';

  @override
  String get plNoSyncLinks => 'Aucun lien de synchro';

  @override
  String get plNoSyncLinksHint => 'Créez des liens depuis un transfert';

  @override
  String plAutoEveryMinutes(String minutes) {
    return 'auto $minutes min';
  }

  @override
  String plSyncError(String detail) {
    return 'Échec de la synchro : $detail';
  }

  @override
  String get plSectionBackup => 'SAUVEGARDE';

  @override
  String get plBackingUp => 'Sauvegarde en cours…';

  @override
  String get plBackupAll => 'Sauvegarder toutes les playlists';

  @override
  String get plSectionSnapshots => 'INSTANTANÉS';

  @override
  String get plNoSnapshots =>
      'Aucun instantané. Lancez une sauvegarde pour en créer.';

  @override
  String get plMergeDone => 'Playlists fusionnées.';

  @override
  String plMergeError(String detail) {
    return 'Échec de la fusion : $detail';
  }

  @override
  String get plNameLabel => 'Nom';

  @override
  String plDeleteNamed(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String plImportedLocal(String name) {
    return '« $name » importée en local.';
  }

  @override
  String plImportError(String detail) {
    return 'Échec de l’import : $detail';
  }

  @override
  String get plFilterAll => 'Toutes';

  @override
  String get plMerge => 'Fusionner';

  @override
  String get plCancelMerge => 'Annuler la fusion';

  @override
  String get plMerging => 'Fusion…';

  @override
  String get plImportToLocal => 'Importer en local';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnées',
      one: '1 sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => 'Dédoublonner';

  @override
  String get plMergedNameHint => 'Nom de la playlist fusionnée';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistes',
      one: '1 piste',
      zero: '0 piste',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => 'RÉSULTATS';

  @override
  String get plCommon => 'En commun';

  @override
  String get plSourceOnly => 'Source seule';

  @override
  String get plTargetOnly => 'Destination seule';

  @override
  String plMatchRate(String rate) {
    return '$rate % de correspondance';
  }

  @override
  String plOnlyInSource(int count) {
    return 'Uniquement dans la source ($count)';
  }

  @override
  String plOnlyInTarget(int count) {
    return 'Uniquement dans la destination ($count)';
  }

  @override
  String plMoreCount(int count) {
    return '+ $count de plus';
  }

  @override
  String get plTransferPlaylistTitle => 'Transférer la playlist';

  @override
  String get plCreateOnRemote => 'Créer sur le service distant';

  @override
  String get plTransfer => 'Transférer';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return 'Transfert : $matched trouvées, $approximate approchantes, $notFound manquantes.';
  }

  @override
  String get plRecover => 'Récupérer';

  @override
  String plRecoverDone(int available, int alternatives) {
    return 'Récupération : $available disponibles, $alternatives alternatives trouvées.';
  }

  @override
  String plCopyName(String name) {
    return '$name (copie)';
  }

  @override
  String get plDuplicate => 'Dupliquer';

  @override
  String plDuplicated(String name) {
    return 'Dupliquée : $name';
  }

  @override
  String plDeleted(String name) {
    return 'Supprimée : $name';
  }

  @override
  String plTransferred(String name) {
    return 'Transférée : $name';
  }

  @override
  String get plTransferToLocal => 'Transférer en local';

  @override
  String get plExportJson => 'Exporter en JSON';

  @override
  String get plExportCsv => 'Exporter en CSV';

  @override
  String get plExportM3u => 'Exporter en M3U';

  @override
  String get plExportJsonDone => 'Export JSON réussi';

  @override
  String get plExportCsvDone => 'Export CSV réussi';

  @override
  String plExportM3uDone(String path) {
    return 'M3U exporté : $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'Échec de l’export M3U : $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importée : $name ($count pistes)',
      one: 'Importée : $name (1 piste)',
      zero: 'Importée : $name (0 piste)',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'Échec de l’import M3U : $detail';
  }

  @override
  String get plSmartTitle => 'Playlists intelligentes';

  @override
  String plSmartLoadError(String detail) {
    return 'Impossible de charger les playlists intelligentes : $detail';
  }

  @override
  String plDeleteError(String detail) {
    return 'Échec de la suppression : $detail';
  }

  @override
  String get plSmartEmpty => 'Aucune playlist intelligente';

  @override
  String get plUntitled => 'Sans titre';

  @override
  String get plSmartDeleteTitle => 'Supprimer la playlist intelligente ?';

  @override
  String plPreviewError(String detail) {
    return 'Échec de l’aperçu : $detail';
  }

  @override
  String get plEnterName => 'Veuillez saisir un nom';

  @override
  String plSaveError(String detail) {
    return 'Échec de l’enregistrement : $detail';
  }

  @override
  String get plSmartEditTitle => 'Modifier la playlist intelligente';

  @override
  String get plSmartNewTitle => 'Nouvelle playlist intelligente';

  @override
  String get plMatchLabel => 'Correspondance';

  @override
  String get plMatchAll => 'Toutes les règles';

  @override
  String get plMatchAny => 'Au moins une règle';

  @override
  String get plSectionRules => 'RÈGLES';

  @override
  String get plAddRule => 'Ajouter une règle';

  @override
  String get plMaxTracksLabel => 'Pistes max. (facultatif)';

  @override
  String get plNoLimit => 'Sans limite';

  @override
  String get plPreviewMatching => 'Aperçu des pistes correspondantes';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistes correspondantes',
      one: '1 piste correspondante',
      zero: '0 piste correspondante',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => 'Valeur';

  @override
  String get plUnknownTitle => 'Inconnu';

  @override
  String plTracksLoadError(String detail) {
    return 'Impossible de charger les pistes : $detail';
  }

  @override
  String get plSmartNoTracks => 'Aucune piste ne correspond à cette playlist';

  @override
  String get plFieldGenre => 'Genre';

  @override
  String get plFieldArtist => 'Artiste';

  @override
  String get plFieldAlbum => 'Album';

  @override
  String get plFieldTitle => 'Titre';

  @override
  String get plFieldYear => 'Année';

  @override
  String get plFieldRating => 'Note';

  @override
  String get plFieldPlayCount => 'Nombre d’écoutes';

  @override
  String get plFieldDuration => 'Durée (ms)';

  @override
  String get plFieldDateAdded => 'Date d’ajout';

  @override
  String get plFieldFavorite => 'Favori';

  @override
  String get plOpContains => 'contient';

  @override
  String get plOpEquals => 'est égal à';

  @override
  String get plOpStartsWith => 'commence par';

  @override
  String get plOpEndsWith => 'se termine par';

  @override
  String get plOpGreaterThan => 'supérieur à';

  @override
  String get plOpLessThan => 'inférieur à';

  @override
  String get plOpIs => 'est';

  @override
  String get plOpIsNot => 'n’est pas';

  @override
  String get srvConfigTitle => 'Configuration du serveur';

  @override
  String srvFolderAdded(String path) {
    return 'Dossier ajouté : $path';
  }

  @override
  String get srvRemoveFolderTitle => 'Supprimer ce dossier ?';

  @override
  String srvScanStarted(String path) {
    return 'Analyse lancée : $path';
  }

  @override
  String get srvFullScanStarted => 'Analyse complète lancée';

  @override
  String get srvRestartTitle => 'Redémarrer le serveur ?';

  @override
  String get srvRestartBody =>
      'Le serveur sera arrêté puis relancé. La lecture en cours sera interrompue.';

  @override
  String get srvRestartBtn => 'Redémarrer';

  @override
  String get srvRestarting => 'Redémarrage du serveur…';

  @override
  String get srvRestartInProgress => 'Redémarrage en cours…';

  @override
  String get srvLoadError => 'Erreur de chargement';

  @override
  String get srvScanFolderTooltip => 'Analyser ce dossier';

  @override
  String get srvSectionServerInfo => 'Informations serveur';

  @override
  String get srvInfoVersion => 'Version';

  @override
  String get srvInfoEngine => 'Moteur';

  @override
  String get srvInfoDatabase => 'Base de données';

  @override
  String get srvSectionActions => 'Actions';

  @override
  String get srvRestartServer => 'Redémarrer le serveur';

  @override
  String get srvRestartServerDesc => 'Arrête et relance le processus serveur';

  @override
  String get srvManualEntry => 'Saisie manuelle';

  @override
  String srvSelectPath(String path) {
    return 'Sélectionner « $path »';
  }

  @override
  String get srvBrowse => 'Parcourir…';

  @override
  String get srvFolderPathHint => '/chemin/vers/musique';

  @override
  String get srvFolderPathHelp =>
      'Saisissez le chemin absolu du dossier sur le serveur.';

  @override
  String get srvNoSubfolders => 'Aucun sous-dossier';

  @override
  String get srvPluginsTitle => 'Plugins';

  @override
  String get srvNotConnectedToServer => 'Non connecté au serveur';

  @override
  String srvPluginInstalled(String name) {
    return '$name installé';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name désinstallé';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name mis à jour';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name activé';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name désactivé';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return 'Échec de l\'installation : $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return 'Échec de la désinstallation : $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return 'Échec de la mise à jour : $error';
  }

  @override
  String get srvPluginsTabStore => 'Store';

  @override
  String get srvPluginsTabInstalled => 'Installés';

  @override
  String get srvRestartRequired =>
      'Redémarrage requis pour appliquer les changements';

  @override
  String get srvPluginsSearchHint => 'Rechercher un plugin…';

  @override
  String get srvPluginsNoneFound => 'Aucun plugin trouvé';

  @override
  String get srvPluginsNoneInstalled => 'Aucun plugin installé';

  @override
  String get srvPluginsBrowseStore => 'Parcourir le Store';

  @override
  String get srvPluginBadgeFeatured => 'En vedette';

  @override
  String get srvPluginBadgeUpdate => 'Mise à jour';

  @override
  String get srvPluginBadgeIncompatible => 'Incompatible';

  @override
  String srvPluginByAuthor(String author) {
    return 'par $author';
  }

  @override
  String get srvPluginActionUpdate => 'Mettre à jour';

  @override
  String get srvPluginActionInstall => 'Installer';

  @override
  String get srvPluginActionUninstall => 'Désinstaller';

  @override
  String get srvPluginStatusActive => 'Actif';

  @override
  String get srvPluginStatusError => 'Erreur';

  @override
  String get srvAutoFixTitle => 'Correction auto des métadonnées';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count corrections appliquées',
      one: '1 correction appliquée',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence =>
      'Plus aucune correction à forte confiance';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggestions restantes',
      one: '1 suggestion restante',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => 'Appliquer (confiance élevée)';

  @override
  String srvAutoFixTrackNumber(int id) {
    return 'Piste n° $id';
  }

  @override
  String get srvAutoFixCurrent => 'Actuel';

  @override
  String get srvAutoFixEmpty => '(vide)';

  @override
  String get srvAutoFixSuggested => 'Suggéré';

  @override
  String get srvAutoFixSkip => 'Ignorer';

  @override
  String get srvAutoFixApply => 'Appliquer';

  @override
  String get srvAutoFixIntroTitle => 'Corriger les métadonnées manquantes';

  @override
  String get srvAutoFixIntroBody =>
      'Analyse les pistes sans genre, année ou identifiant MusicBrainz et propose des corrections issues de MusicBrainz.';

  @override
  String get srvAutoFixStartScan => 'Lancer l\'analyse';

  @override
  String get srvAutoFixScanning => 'Recherche sur MusicBrainz…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total pistes ($pct %)';
  }

  @override
  String get srvAutoFixLoadingTracks => 'Chargement des pistes…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count corrections trouvées pour l\'instant',
      one: '1 correction trouvée pour l\'instant',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit => 'Limité à 1 requête/s (règle MusicBrainz)';

  @override
  String get srvAutoFixNoneNeeded => 'Aucune correction nécessaire';

  @override
  String get srvAutoFixAllComplete =>
      'Toutes les pistes ont des métadonnées complètes.';

  @override
  String get srvAutoFixScanAgain => 'Relancer l\'analyse';

  @override
  String get srvAutoFixScanFailed => 'Échec de l\'analyse';

  @override
  String get srvMpStepSetup => 'Configuration';

  @override
  String get srvMpStepFineTune => 'Réglages fins';

  @override
  String get srvMpListenTitle => 'Comment écoutez-vous ?';

  @override
  String get srvMpListenSubtitle =>
      'Le profil sera adapté à votre configuration d\'écoute';

  @override
  String get srvMpSpeakers => 'Enceintes';

  @override
  String get srvMpSpeakersSub => 'Salle de musique';

  @override
  String get srvMpHeadphones => 'Casque';

  @override
  String get srvMpHeadphonesSub => 'Écoute personnelle';

  @override
  String get srvMpRoomTitle => 'Quelle est la taille de la pièce ?';

  @override
  String get srvMpRoomSubtitle =>
      'Influence les fréquences basses et la réverbération';

  @override
  String get srvMpRoomSmall => 'Petite';

  @override
  String get srvMpRoomMedium => 'Moyenne';

  @override
  String get srvMpRoomLarge => 'Grande';

  @override
  String get srvMpPlacementTitle => 'Placement des enceintes';

  @override
  String get srvMpPlacementSubtitle =>
      'L\'emplacement affecte les réflexions de basses';

  @override
  String get srvMpNearWall => 'Près d\'un mur';

  @override
  String get srvMpFreeStanding => 'En espace libre';

  @override
  String get srvMpTuneSound => 'Régler le son';

  @override
  String get srvMpCorrectionActive => 'Correction active';

  @override
  String get srvMpCorrectionDesc => 'Applique le profil à la zone en cours';

  @override
  String get srvMpBass => 'Graves';

  @override
  String get srvMpBassDesc => 'Poids, chaleur, corps du son';

  @override
  String get srvMpBassLow => 'Maigre';

  @override
  String get srvMpBassHigh => 'Lourd';

  @override
  String get srvMpMid => 'Voix / Médiums';

  @override
  String get srvMpMidDesc => 'Présence, clarté, intelligibilité';

  @override
  String get srvMpMidLow => 'En retrait';

  @override
  String get srvMpMidHigh => 'En avant';

  @override
  String get srvMpTreble => 'Aigus';

  @override
  String get srvMpTrebleDesc => 'Brillance, détail, air dans le son';

  @override
  String get srvMpTrebleLow => 'Sombre';

  @override
  String get srvMpTrebleHigh => 'Brillant';

  @override
  String get srvMpProfileApplied => 'Profil appliqué';

  @override
  String get srvMpApplying => 'Application…';

  @override
  String get srvMpApply => 'Appliquer le profil';

  @override
  String get srvMpBackToQuestions => 'Retour aux questions';

  @override
  String get srvRemoteConfigBody =>
      'Connectez-vous à un serveur Tune sur votre réseau pour profiter de toutes les fonctionnalités.';

  @override
  String get srvModeStandalone => 'Autonome';

  @override
  String get srvStandaloneWarning =>
      'Mode autonome : Party, DJ, paroles synchronisées, EQ et recommandations sont absents. Recommandé : utiliser un serveur Tune distant.';

  @override
  String get srvServerAddress => 'Adresse du serveur';

  @override
  String get srvNoServerYet => 'Pas encore de serveur ?';

  @override
  String get srvDownloadServer =>
      'Téléchargez Tune Server : mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).';

  @override
  String get srvStreamingBody =>
      'Activez les services de streaming que vous souhaitez utiliser avec Tune.';

  @override
  String get srvStreamingStandaloneWarning =>
      'En mode autonome, les services de streaming ne sont pas disponibles. Passez en mode serveur distant pour les activer.';

  @override
  String get srvNoServiceAvailable =>
      'Aucun service disponible. Vérifiez la connexion au serveur.';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services activés',
      one: '1 service activé',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connectés',
      one: '1 connecté',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => 'Activé, non connecté';

  @override
  String get srvAudioCheckTitle => 'Diagnostic audio';

  @override
  String get srvAudioCheckBody =>
      'Vérification de la configuration audio de votre système.';

  @override
  String get srvDiagZones => 'Zones configurées';

  @override
  String get srvDiagOutputs => 'Sorties audio';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count détectées',
      one: '1 détectée',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => 'Appareils réseau';

  @override
  String get srvDiagNone => 'Aucun';

  @override
  String get srvDiagNoZoneWarning =>
      'Aucune zone configurée. Vous pouvez en créer une depuis les paramètres Zones.';

  @override
  String srvAudioCheckUnavailable(String error) {
    return 'Diagnostic audio indisponible : $error';
  }

  @override
  String get srvRecheck => 'Revérifier';

  @override
  String get srvScanBody =>
      'Lancez une analyse pour indexer vos fichiers musicaux et récupérer les métadonnées.';

  @override
  String get srvScanStart => 'Lancer l\'analyse';

  @override
  String get srvScanStatScanned => 'Analysés';

  @override
  String get srvScanStatAdded => 'Ajoutés';

  @override
  String get srvScanStatUpdated => 'Mis à jour';

  @override
  String get srvScanMayTakeMinutes => 'Cela peut prendre quelques minutes…';

  @override
  String get srvScanComplete => 'Analyse terminée !';

  @override
  String stgUpdateAvailable(String version) {
    return 'Mise à jour disponible : v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return 'Version actuelle : v$version';
  }

  @override
  String get stgOpen => 'Ouvrir';

  @override
  String get stgMode => 'Mode';

  @override
  String stgConnectedTo(String address) {
    return 'Connecté à $address';
  }

  @override
  String get stgModeRemote => 'Distant';

  @override
  String get stgStandaloneTitle => 'Mode autonome — fonctionnalités limitées';

  @override
  String get stgStandaloneBody =>
      'Party, DJ, paroles synchronisées, EQ, bios d\'album, recommandations… nécessitent un serveur Tune distant.';

  @override
  String get stgServerAddress => 'Adresse du serveur';

  @override
  String get stgNotConfigured => 'Non configuré';

  @override
  String get stgScanNetwork => 'Scanner le réseau';

  @override
  String get stgSectionPlayback => 'LECTURE';

  @override
  String get stgCrossfade => 'Fondu enchaîné';

  @override
  String get stgRepeatOneByDefault => 'Lire en boucle par défaut';

  @override
  String get stgExclusiveMode => 'Mode exclusif (bit-perfect)';

  @override
  String get stgExclusiveModeDesc =>
      'WASAPI Exclusive — accès direct au DAC USB';

  @override
  String get stgSectionMetadataFields => 'CHAMPS DE MÉTADONNÉES';

  @override
  String get stgSectionAdvancedAudio => 'AUDIO AVANCÉ';

  @override
  String get stgEqualizer => 'Égaliseur';

  @override
  String get stgEqualizerDesc =>
      'Assistant de calibration + EQ 10 bandes expert';

  @override
  String get stgMetadataFieldsDesc =>
      'Configurer les champs étendus (compositeur, chef…)';

  @override
  String get stgSpotifyConnectDesc =>
      'Tune comme récepteur (Premium requis côté client)';

  @override
  String get stgLastfmDesc => 'Scrobbler votre historique d\'écoute';

  @override
  String get stgListenBrainzDesc => 'Scrobbler vers ListenBrainz';

  @override
  String get stgAutoFixMetadata => 'Correction auto des métadonnées';

  @override
  String get stgAutoFixMetadataDesc =>
      'Compléter genre, année, MBID manquants via MusicBrainz';

  @override
  String get stgDatabase => 'Base de données';

  @override
  String get stgImportExport => 'Import / Export';

  @override
  String get stgSectionProfiles => 'PROFILS';

  @override
  String get stgSectionSystem => 'SYSTÈME';

  @override
  String get stgServerConfig => 'Configuration serveur';

  @override
  String get stgServerConfigDesc => 'Dossiers musicaux, scan, redémarrage';

  @override
  String get stgNetworkDiagnostics => 'Diagnostics réseau';

  @override
  String get stgNetworkDiagnosticsDesc => 'Multicast, DNS, connectivité';

  @override
  String get stgConfiguration => 'Configuration';

  @override
  String get stgExportImport => 'Exporter / Importer';

  @override
  String get stgPlugins => 'Greffons';

  @override
  String get stgPluginsDesc => 'Extensions installées';

  @override
  String get stgNetworkShares => 'Partages réseau (SMB)';

  @override
  String get stgNetworkSharesDesc => 'Découvrir et monter des partages';

  @override
  String get stgSectionCloud => 'CLOUD';

  @override
  String get stgSectionHelp => 'AIDE';

  @override
  String get stgTroubleshooting => 'Dépannage';

  @override
  String get stgTroubleshootingDesc => 'Questions fréquentes et solutions';

  @override
  String get stgSendBugReport => 'Envoyer un rapport de bug';

  @override
  String get stgSendBugReportDesc => 'Générer et copier un rapport technique';

  @override
  String get stgServerAddressHint => 'IP ou nom d\'hôte (ex. : 192.168.1.18)';

  @override
  String get stgServerPort => 'Port du serveur';

  @override
  String get stgPortDefaultHint => 'Port (par défaut : 8888)';

  @override
  String get stgWarnNoZones =>
      'Aucune zone configurée. Créez-en une pour commencer la lecture.';

  @override
  String get stgWarnNoNetworkDevices =>
      'Aucun appareil réseau détecté (DLNA/BluOS/Chromecast).';

  @override
  String get stgSectionAudio => 'AUDIO';

  @override
  String get stgAudioOutputs => 'Sorties audio';

  @override
  String stgOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count détectées',
      one: '1 détectée',
      zero: '0 détectée',
    );
    return '$_temp0';
  }

  @override
  String get stgNetworkDevices => 'Appareils réseau';

  @override
  String get stgZoneNameHint => 'ex. : Salon, Bureau';

  @override
  String get stgProfileActivated => 'Profil activé';

  @override
  String get stgNewProfile => 'Nouveau profil';

  @override
  String get stgProfileName => 'Nom du profil';

  @override
  String get stgProfileNameHint => 'ex. : Soir, Matin';

  @override
  String get stgProfileUpdated => 'Profil mis à jour';

  @override
  String get stgNoProfiles => 'Aucun profil';

  @override
  String get stgProfile => 'Profil';

  @override
  String get stgEditProfile => 'Modifier le profil';

  @override
  String get stgName => 'Nom';

  @override
  String get stgColor => 'Couleur';

  @override
  String get stgScanInProgress => 'Scan du réseau en cours…';

  @override
  String stgScanChecking(int scanned, int total) {
    return 'Vérification $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'Aucun serveur Tune trouvé';

  @override
  String stgServersFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serveurs trouvés',
      one: '1 serveur trouvé',
    );
    return '$_temp0';
  }

  @override
  String get stgTuneServers => 'Serveurs Tune';

  @override
  String get stgFieldFormat => 'Format (FLAC, MP3…)';

  @override
  String get stgFieldSampleRate => 'Fréquence (96 kHz)';

  @override
  String get stgFieldBitDepth => 'Profondeur (24 bits)';

  @override
  String get stgFieldLabel => 'Label';

  @override
  String get stgFieldComposer => 'Compositeur';

  @override
  String get stgFieldDuration => 'Durée';

  @override
  String get stgFieldSource => 'Source (Tidal, Qobuz…)';

  @override
  String get stgMetadataFieldsIntro =>
      'Champs affichés sous chaque piste (recherche, bibliothèque, file, historique)';

  @override
  String get stgAudiophileMode => 'Mode audiophile';

  @override
  String get stgAudiophileModeDesc =>
      'DSP contourné, EQ désactivé, bit-perfect';

  @override
  String get stgCloudAccount => 'Compte cloud';

  @override
  String stgConnectedAs(String email) {
    return 'Connecté ($email)';
  }

  @override
  String get stgTelemetry => 'Télémétrie';

  @override
  String get stgTelemetryDesc =>
      'Envoyer des statistiques d\'utilisation anonymes';

  @override
  String get stgSyncingLibrary => 'Synchronisation de la bibliothèque…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total pistes';
  }

  @override
  String get stgConnectingStreaming => 'Connexion aux services de streaming…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'Nouveautés de la v$version';
  }

  @override
  String get stgWhatsNewLibrarySync =>
      'Synchronisation de bibliothèque améliorée';

  @override
  String get stgWhatsNewMultiRoom =>
      'Multi-room et gestion des zones optimisés';

  @override
  String get stgWhatsNewBugFixes =>
      'Corrections de bugs et améliorations de stabilité';

  @override
  String get stgStartServerFailed => 'Impossible de démarrer le serveur';

  @override
  String stgStartServerFailedWith(String detail) {
    return 'Impossible de démarrer le serveur : $detail';
  }

  @override
  String get stgConnectionFailed => 'Échec de la connexion';

  @override
  String stgConnectionFailedWith(String detail) {
    return 'Échec de la connexion : $detail';
  }

  @override
  String get stgStartingServer => 'Démarrage de Tune Server…';

  @override
  String get stgTagline => 'Serveur musical multi-room';

  @override
  String get stgLocalServer => 'Serveur local';

  @override
  String get stgLocalServerDesc =>
      'Lancez Tune sur cet appareil.\nVotre musique, vos règles.';

  @override
  String get stgRemoteControl => 'Télécommande';

  @override
  String get stgRemoteControlDesc =>
      'Connectez-vous à un serveur\nTune sur votre réseau.';

  @override
  String get stgRemoteConnection => 'Connexion distante';

  @override
  String get znZoneManagerTitle => 'Gestionnaire de zones';

  @override
  String get znCannotDeleteLastZone =>
      'Impossible de supprimer la dernière zone';

  @override
  String znZoneSwitchError(String error) {
    return 'Erreur lors du changement de zone : $error';
  }

  @override
  String get znZoneSettings => 'Réglages de la zone';

  @override
  String get znPhoneSpeakers => 'Haut-parleurs du téléphone';

  @override
  String get znBtConnectedOutputs => 'Sorties Bluetooth connectées';

  @override
  String get znBtSystemOutput =>
      'Utilise la sortie système (Centre de contrôle)';

  @override
  String get znBtOutputsTitle => 'Sorties Bluetooth';

  @override
  String get znBtNoDevice =>
      'Aucun appareil Bluetooth connecté. Jumelez un appareil dans les réglages du système.';

  @override
  String get znBtAndroidRouting =>
      'Le routage actif dépend des réglages système d’Android.';

  @override
  String get znDsdMode => 'Mode DSD';

  @override
  String get znDsdAuto => 'Auto';

  @override
  String get znDsdNative => 'Natif';

  @override
  String get znGaplessDlnaDesc => 'Enchaînement sans coupure (DLNA)';

  @override
  String get znFixedVolume => 'Volume fixe';

  @override
  String get znFixedVolumeDesc => 'Désactive le contrôle logiciel du volume';

  @override
  String get znCap16Bit => 'Limiter à 16 bits';

  @override
  String get znCap16BitDesc =>
      'À activer si le hi-res (24 bits) reste muet alors que le 16 bits fonctionne (Ruark R3). Reconvertit en FLAC 16 bits.';

  @override
  String get znZoneMuted => 'Zone en sourdine';

  @override
  String get znZoneUnmuted => 'Sourdine désactivée';

  @override
  String znErrMute(String error) {
    return 'Erreur de sourdine : $error';
  }

  @override
  String znErrVolume(String error) {
    return 'Erreur de volume : $error';
  }

  @override
  String znErrLatency(String error) {
    return 'Erreur de latence : $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return 'Erreur de volume du groupe : $error';
  }

  @override
  String get znCalibrationDone => 'Calibration terminée';

  @override
  String znErrCalibration(String error) {
    return 'Erreur de calibration : $error';
  }

  @override
  String znErrDissolve(String error) {
    return 'Erreur de dissolution : $error';
  }

  @override
  String get znRenameGroupTitle => 'Renommer le groupe';

  @override
  String get znNewNameHint => 'Nouveau nom';

  @override
  String get znRename => 'Renommer';

  @override
  String get znGroupRenamed => 'Groupe renommé';

  @override
  String znErrRename(String error) {
    return 'Erreur de renommage : $error';
  }

  @override
  String get znGroupNeedTwoZones =>
      'Il faut au moins 2 zones pour créer un groupe';

  @override
  String get znGroupNameLabel => 'Nom du groupe';

  @override
  String get znGroupNameHint => 'ex. : Salon + Cuisine';

  @override
  String get znChooseLeader => 'Choisir le leader';

  @override
  String get znMembers => 'Membres';

  @override
  String znErrCreateGroup(String error) {
    return 'Erreur de création du groupe : $error';
  }

  @override
  String get znProfileActivated => 'Profil activé';

  @override
  String znErrActivate(String error) {
    return 'Erreur d’activation : $error';
  }

  @override
  String get znProfileDeleted => 'Profil supprimé';

  @override
  String znErrDelete(String error) {
    return 'Erreur de suppression : $error';
  }

  @override
  String get znNoOfflineZones => 'Aucune zone hors ligne à supprimer';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zones hors ligne supprimées',
      one: '1 zone hors ligne supprimée',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return 'Erreur de nettoyage : $error';
  }

  @override
  String get znSaveConfigTitle => 'Sauvegarder la configuration';

  @override
  String get znProfileNameLabel => 'Nom du profil';

  @override
  String get znProfileNameHint => 'ex. : Soirée, Matin calme';

  @override
  String get znDescriptionOptional => 'Description (facultatif)';

  @override
  String get znNameRequired => 'Le nom est requis';

  @override
  String get znProfileSaved => 'Profil sauvegardé';

  @override
  String znErrSave(String error) {
    return 'Erreur de sauvegarde : $error';
  }

  @override
  String get znCleanupOffline => 'Nettoyer les zones hors ligne';

  @override
  String get znRemoteRequired =>
      'Le gestionnaire de zones nécessite une connexion au serveur distant.';

  @override
  String get znDataUnavailable => 'Données indisponibles';

  @override
  String get znGroups => 'Groupes';

  @override
  String get znNoGroups => 'Aucun groupe';

  @override
  String get znGroupFallback => 'Groupe';

  @override
  String znZoneFallback(String id) {
    return 'Zone $id';
  }

  @override
  String get znCalibrate => 'Calibrer';

  @override
  String get znDissolve => 'Dissoudre';

  @override
  String get znProfiles => 'Profils';

  @override
  String get znNoProfiles => 'Aucun profil sauvegardé';

  @override
  String get znSaveConfigButton => 'Sauvegarder la config';

  @override
  String get znProfileFallback => 'Profil';

  @override
  String get znPins => 'Épingles';

  @override
  String znPinFallback(int n) {
    return 'Épingle $n';
  }

  @override
  String znPinInvoked(int n) {
    return 'Épingle $n lancée';
  }

  @override
  String znPinInvokeError(String error) {
    return 'Impossible de lancer l’épingle : $error';
  }

  @override
  String get znNoPins => 'Aucune épingle configurée';

  @override
  String get znMute => 'Sourdine';

  @override
  String get znUnmute => 'Réactiver le son';

  @override
  String get znLatency => 'Latence';

  @override
  String get znLatencyError => 'erreur';

  @override
  String znPartyAddError(String error) {
    return 'Impossible d’ajouter le morceau : $error';
  }

  @override
  String znPartyVoteError(String error) {
    return 'Erreur de vote : $error';
  }

  @override
  String get znPartyLinkCopied =>
      'Lien de la soirée copié dans le presse-papiers';

  @override
  String get znPartyTitle => 'Mode soirée';

  @override
  String get znPartyShareLink => 'Partager le lien de la soirée';

  @override
  String get znPartyAddHint => 'Ajouter un morceau…';

  @override
  String get znPartyQueue => 'File d’attente';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count morceaux',
      one: '1 morceau',
      zero: '0 morceau',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => 'Zone inconnue';

  @override
  String get znUnknownTitle => 'Inconnu';

  @override
  String get znNowPlaying => 'En cours de lecture';

  @override
  String get znUpvote => 'Voter pour';

  @override
  String znDjLoadOnDeck(String deck) {
    return 'Charger un morceau sur la platine $deck';
  }

  @override
  String get znDjSearchHint => 'Rechercher des morceaux…';

  @override
  String get znDjSearchHelp =>
      'Saisissez un titre, puis touchez Rechercher et charger';

  @override
  String get znDjNoTracksFound => 'Aucun morceau trouvé';

  @override
  String znDjSearchError(String error) {
    return 'Erreur de recherche : $error';
  }

  @override
  String get znDjSearchAndLoad => 'Rechercher et charger';

  @override
  String znDjLoadError(String error) {
    return 'Erreur de chargement : $error';
  }

  @override
  String znDjPlayError(String error) {
    return 'Erreur de lecture : $error';
  }

  @override
  String znDjPauseError(String error) {
    return 'Erreur de pause : $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return 'Erreur de fondu enchaîné : $error';
  }

  @override
  String get znDjTitle => 'Mode DJ';

  @override
  String get znDjDisabled => 'Le mode DJ est désactivé';

  @override
  String get znDjEnableHint => 'Activez-le pour commencer à mixer';

  @override
  String znDjDeck(String deck) {
    return 'Platine $deck';
  }

  @override
  String get znDjCrossfade => 'Fondu enchaîné';

  @override
  String znDjDuration(String seconds) {
    return 'Durée : $seconds s';
  }

  @override
  String get znDjStartCrossfade => 'Lancer le fondu enchaîné';

  @override
  String get znDjAutoCrossfade => 'Fondu enchaîné automatique';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return 'Synchro $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => 'Échec de la synchro';

  @override
  String get znDjNoTrackLoaded => 'Aucun morceau chargé';

  @override
  String get znDjLoadTrack => 'Charger un morceau';

  @override
  String get znDjGain => 'Gain';

  @override
  String cfgSizeBytes(String size) {
    return '$size o';
  }

  @override
  String cfgSizeKilobytes(String size) {
    return '$size Ko';
  }

  @override
  String cfgSizeMegabytes(String size) {
    return '$size Mo';
  }

  @override
  String get plPremiumTransfer =>
      'Transférer une playlist entre services, ou d\'un service vers la bibliothèque, fait partie de Tune Premium. Dupliquer une playlist de la bibliothèque reste gratuit.';

  @override
  String get plPremiumConverter =>
      'Les copies datées et les liens de synchronisation de playlists font partie de Tune Premium.';

  @override
  String get plConverterMissing =>
      'Le greffon Playlists converter n\'est pas chargé sur ce serveur.';

  @override
  String get plSeeOffer => 'Voir l\'offre';

  @override
  String get plSnapshotsNoDelete =>
      'Les 10 dernières copies de chaque playlist sont gardées ; la plus ancienne est remplacée d\'elle-même.';

  @override
  String plBackupAllDone(int ok, int failed) {
    return '$ok playlists sauvegardées, $failed en échec.';
  }

  @override
  String plRestoreRecreateAsk(String name) {
    return 'Recréer « $name » depuis sa copie la plus récente ? La playlist actuelle n\'est ni modifiée ni supprimée.';
  }

  @override
  String plRestoreRecreated(String name) {
    return '« $name » recréée depuis sa copie la plus récente.';
  }

  @override
  String plSnapshotCopies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count copies',
      one: '1 copie',
    );
    return '$_temp0';
  }

  @override
  String plIntervalAdjusted(int minutes) {
    return 'Cadence ramenée à $minutes min (de 15 min à une semaine, ou 0 pour « à la demande »).';
  }

  @override
  String plLinkSyncDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres ajoutés',
      one: '1 titre ajouté',
      zero: 'aucun titre ajouté',
    );
    return 'Synchronisation faite : $_temp0.';
  }
}
