// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => 'OK';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnAdd => 'Add';

  @override
  String get btnSave => 'Save';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnEdit => 'Edit';

  @override
  String get btnClose => 'Close';

  @override
  String get btnRetry => 'Retry';

  @override
  String get btnCreate => 'Create';

  @override
  String get btnClear => 'Clear';

  @override
  String get btnNext => 'Next';

  @override
  String get btnSkip => 'Skip this step';

  @override
  String get btnFinish => 'Finish configuration';

  @override
  String get btnStart => 'Start';

  @override
  String get btnConnect => 'Connect';

  @override
  String get btnDisconnect => 'Disconnect';

  @override
  String get btnDownload => 'Download';

  @override
  String get btnImport => 'Import';

  @override
  String get btnExport => 'Export';

  @override
  String get btnReset => 'Reset';

  @override
  String get btnUse => 'Use';

  @override
  String get btnShuffle => 'Shuffle';

  @override
  String get btnSeeAll => 'See all';

  @override
  String get btnRefresh => 'Refresh';

  @override
  String get btnScan => 'Scan library';

  @override
  String get btnAddFolder => 'Add a folder';

  @override
  String get actionIrreversible => 'This action is irreversible.';

  @override
  String get rootStartError => 'Startup error';

  @override
  String get playbackErrorNoZone =>
      'No zone selected — create or select a zone';

  @override
  String get playbackErrorZoneNotFound => 'Zone not found';

  @override
  String get playbackErrorFailed => 'Playback failed';

  @override
  String zoneLimitReached(int limit) {
    return 'Free plan limited to $limit zones — upgrade to Premium for unlimited';
  }

  @override
  String get navLibrary => 'Library';

  @override
  String get navSearch => 'Search';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navRadios => 'Radios';

  @override
  String get navZones => 'Zones';

  @override
  String get navSettings => 'Settings';

  @override
  String get libraryTitle => 'Library';

  @override
  String get tabAlbums => 'Albums';

  @override
  String get tabArtists => 'Artists';

  @override
  String get tabTracks => 'Tracks';

  @override
  String albumTracksDuration(int count, String duration) {
    return '$count tracks · $duration';
  }

  @override
  String get tabGenres => 'Genres';

  @override
  String get tabPlaylists => 'Playlists';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get favoriteAdded => 'Added to favorites';

  @override
  String get favoriteRemoved => 'Removed from favorites';

  @override
  String get libraryEmptyFavorites => 'No favorites';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => 'No albums in library';

  @override
  String get libraryEmptyArtists => 'No artists in library';

  @override
  String get libraryEmptyTracks => 'No tracks in library';

  @override
  String get libraryEmptyGenres => 'No genres';

  @override
  String get libraryEmptyPlaylists => 'No playlists';

  @override
  String get libraryNoFilterResults => 'No albums match filters';

  @override
  String get libraryPlayAll => 'Play all';

  @override
  String get libraryAddTo => 'Add to...';

  @override
  String get libraryEditAlbum => 'Edit album';

  @override
  String get libraryEditTrack => 'Edit track';

  @override
  String get libraryPlay => 'Play';

  @override
  String get genresAllTracks => 'All tracks';

  @override
  String get playlistCreate => 'Create playlist';

  @override
  String get playlistName => 'Playlist name';

  @override
  String get playlistEmpty => 'No tracks';

  @override
  String get playlistAddTo => 'Add to playlist';

  @override
  String get playlistNewPlaylist => 'New playlist';

  @override
  String playlistTrackAdded(String name) {
    return 'Added to \"$name\"';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return 'Already in \"$name\"';
  }

  @override
  String playlistTracksAdded(int count, String name) {
    return '$count tracks added to \"$name\"';
  }

  @override
  String get playlistAddAllTracks => 'Add all to playlist';

  @override
  String get playlistDeleteTitle => 'Delete playlist?';

  @override
  String get playlistDeleteBody => 'This playlist will be permanently deleted.';

  @override
  String get searchHint => 'Search…';

  @override
  String get searchNoResults => 'No results';

  @override
  String get searchTopResult => 'Top result';

  @override
  String get searchSectionTracks => 'Tracks';

  @override
  String get searchSectionAlbums => 'Albums';

  @override
  String get searchSectionArtists => 'Artists';

  @override
  String get searchSectionStreaming => 'Streaming';

  @override
  String get homeRecentlyPlayed => 'Recently played';

  @override
  String get homeLibrary => 'Library';

  @override
  String get homeQuickAccess => 'Quick access';

  @override
  String get homeHistory => 'History';

  @override
  String get homeBrowseDlna => 'Browse DLNA';

  @override
  String get homeStatTracks => 'tracks';

  @override
  String get homeStatAlbums => 'albums';

  @override
  String get homeStatArtists => 'artists';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty => 'No history';

  @override
  String get historyClear => 'Clear';

  @override
  String get historyClearTitle => 'Clear history';

  @override
  String get nowPlayingNoTrack => 'No track';

  @override
  String get queueTitle => 'Playback queue';

  @override
  String queueUpNextSummary(int count, String time) {
    return '$count up next · $time';
  }

  @override
  String get queueEmpty => 'Empty queue';

  @override
  String get queueClearTitle => 'Clear queue?';

  @override
  String get queueClearBody =>
      'All tracks will be removed from the playback queue.';

  @override
  String get zonesTitle => 'Zones';

  @override
  String get zonesNew => 'New zone';

  @override
  String get zonesNewName => 'Zone name';

  @override
  String get zonesNone => 'No zones';

  @override
  String get zonesRename => 'Rename zone';

  @override
  String get zonesDelete => 'Delete zone';

  @override
  String get zonesDevices => 'Available devices';

  @override
  String get zonesOutputLocal => 'Local';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesAirplayPair => 'Pair (PIN code)';

  @override
  String get zonesAirplayPairTitle => 'AirPlay pairing';

  @override
  String get zonesAirplayPairIntro =>
      'Some TVs (Samsung, LG) and the Apple TV show a 4-digit code on screen. Start pairing, then enter the code.';

  @override
  String get zonesAirplayPairWaiting =>
      'Waiting for the code shown on the device…';

  @override
  String get zonesAirplayPairEnterCode => 'Enter the code shown on the device:';

  @override
  String get zonesAirplayPairStart => 'Start pairing';

  @override
  String get zonesAirplayPairSubmit => 'Submit code';

  @override
  String get zonesAirplayPairRetry => 'Try again';

  @override
  String get zonesOutputBluetooth => 'Bluetooth';

  @override
  String get zonesChangeOutput => 'Change output';

  @override
  String get zonesOutputTitle => 'Audio output';

  @override
  String get zonesAssignDevice => 'Assign';

  @override
  String get zonesTransferTitle => 'Play on...';

  @override
  String get zonesNowPlaying => 'Playing here';

  @override
  String zonesActivated(String name) {
    return 'Active zone: $name';
  }

  @override
  String get radiosTitle => 'Radios';

  @override
  String get radiosTabAll => 'All';

  @override
  String get radiosTabFavorites => 'Favorites';

  @override
  String get radiosNone => 'No radios';

  @override
  String get radiosFavNone => 'No favorite radios';

  @override
  String get radiosSavedFavorites => 'Saved favorites';

  @override
  String get radiosAdd => 'Add a radio';

  @override
  String get radiosName => 'Name';

  @override
  String get radiosStreamUrl => 'Stream URL';

  @override
  String get radiosGenre => 'Genre (optional)';

  @override
  String get radiosPasteM3u => 'Paste M3U';

  @override
  String get radiosImportUrl => 'Import from URL';

  @override
  String get radiosImportUrlLabel => 'M3U file URL';

  @override
  String radiosImportResult(int count) {
    return '$count station(s) imported';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'HTTP error $code';
  }

  @override
  String get radiosImportFailed => 'Could not download the file';

  @override
  String get radiosFavSaved => 'Track saved';

  @override
  String get radioSaveFavorite => 'Save track';

  @override
  String get radioFavTitle => 'Radio favorites';

  @override
  String get radioFavEmpty => 'No saved favorites';

  @override
  String get radioFavExportCsv => 'Export CSV';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get streamingConnected => 'Connected';

  @override
  String get streamingNotConnected => 'Not connected';

  @override
  String get streamingEmail => 'Email';

  @override
  String get streamingPassword => 'Password';

  @override
  String get streamingSignIn => 'Sign in';

  @override
  String get streamingSigningIn => 'Signing in…';

  @override
  String get streamingDeviceCode => 'Verification code';

  @override
  String get streamingOpenLink => 'Open…';

  @override
  String get streamingLogoutTitle => 'Disconnect?';

  @override
  String streamingLogoutBody(String service) {
    return 'Disconnect from $service?';
  }

  @override
  String get streamingAuthError => 'Authentication failed';

  @override
  String get streamingAlbumsSection => 'Albums';

  @override
  String get streamingPlaylistsSection => 'Playlists';

  @override
  String get browseTitle => 'Browse';

  @override
  String get browseRefreshTooltip => 'Refresh';

  @override
  String get browseNoServers => 'No UPnP/DLNA servers detected';

  @override
  String get browseNoServersHint =>
      'Make sure your server is on the same Wi-Fi network.';

  @override
  String get browseNoContent => 'Empty folder';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLangSystem => 'System';

  @override
  String get settingsSectionZones => 'Zones';

  @override
  String get settingsDefaultZone => 'Default zone';

  @override
  String get settingsDefaultZoneAuto => 'Automatic';

  @override
  String get settingsNoZones => 'No zones';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsHttpPort => 'HTTP port';

  @override
  String get settingsHttpPortDesc => 'Main server port';

  @override
  String get settingsLocalIp => 'Local IP address';

  @override
  String get settingsSectionLibrary => 'Library';

  @override
  String get settingsMetadata => 'Music & Metadata';

  @override
  String get settingsMetadataDesc => 'Folders, scan, statistics';

  @override
  String get settingsSetupWizard => 'Setup wizard';

  @override
  String get settingsSetupWizardDesc => 'Reconfigure music sources';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsVersion => 'Version 0.1.0';

  @override
  String get settingsResetConfig => 'Reset configuration';

  @override
  String get settingsResetTitle => 'Reset?';

  @override
  String get settingsResetBody =>
      'All preferences will be reset. The startup wizard will appear on next launch.';

  @override
  String get settingsPortTitle => 'HTTP port';

  @override
  String get settingsPortHint => 'Port (1024–65535)';

  @override
  String get metadataTitle => 'Music & Metadata';

  @override
  String get metadataRefreshStats => 'Refresh stats';

  @override
  String get metadataSectionStats => 'Statistics';

  @override
  String get metadataStatTracks => 'Tracks';

  @override
  String get metadataStatAlbums => 'Albums';

  @override
  String get metadataStatArtists => 'Artists';

  @override
  String get metadataStatPlaylists => 'Playlists';

  @override
  String get metadataStatRadios => 'Radios';

  @override
  String get metadataStatArtwork => 'Artwork cache';

  @override
  String get metadataSectionScan => 'Library scan';

  @override
  String metadataScanInProgress(int current, int total) {
    return 'Scanning… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return 'Last scan: +$added added, $updated updated';
  }

  @override
  String get metadataScanBtn => 'Scan library';

  @override
  String get metadataScanDesc => 'Indexes all configured folders';

  @override
  String get metadataSectionFolders => 'Music folders';

  @override
  String get metadataFoldersNone => 'No folders configured';

  @override
  String metadataFolderAddedOn(String date) {
    return 'Added on $date';
  }

  @override
  String get metadataAddFolder => 'Add a folder';

  @override
  String get metadataFolderPath => 'Folder path';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => 'Cleanup';

  @override
  String get metadataCleanupOrphans => 'Delete orphans';

  @override
  String get metadataCleanupOrphansDesc => 'Albums and artists with no tracks';

  @override
  String get metadataClearLibrary => 'Clear library';

  @override
  String get metadataClearLibraryDesc => 'Deletes all local tracks';

  @override
  String get metadataCleanupOrphansTitle => 'Delete orphans?';

  @override
  String get metadataCleanupOrphansBody =>
      'Albums and artists with no associated tracks will be deleted from the database.';

  @override
  String get metadataClearLibraryTitle => 'Clear library?';

  @override
  String get metadataClearLibraryBody =>
      'All local tracks, albums and artists will be deleted from the database. This action is irreversible.';

  @override
  String get metadataOrphansDeleted => 'Orphans deleted';

  @override
  String get metadataLibraryCleared => 'Library cleared';

  @override
  String get metadataDeleteBtn => 'Delete';

  @override
  String get metadataClearBtn => 'Clear';

  @override
  String get setupWelcomeTitle => 'Welcome to\nTune Server';

  @override
  String get setupWelcomeBody =>
      'Your embedded multi-room music server. Stream your local library, your favorite streaming services and your radios to any DLNA or AirPlay speaker.';

  @override
  String get setupStart => 'Start';

  @override
  String get setupLocalTitle => 'Local library';

  @override
  String get setupLocalBody =>
      'Specify the path of a folder containing your audio files (FLAC, MP3, AAC…). You can add more later in Settings.';

  @override
  String get setupFolderPath => 'Folder path';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => 'Add this folder';

  @override
  String get setupFolderAdded => 'Folder added — scanning…';

  @override
  String get setupFolderEmpty => 'Please enter a folder path';

  @override
  String get setupUPnPTitle => 'UPnP/DLNA Servers';

  @override
  String get setupUPnPBody =>
      'Tune Server automatically discovers UPnP/DLNA servers on your local network. Browse their libraries via Search → Browse.';

  @override
  String get setupFeatureSsdp => 'Automatic SSDP discovery';

  @override
  String get setupFeatureContentDir => 'ContentDirectory navigation';

  @override
  String get setupFeaturePlayback => 'Direct DLNA file playback';

  @override
  String get setupFinish => 'Finish configuration';

  @override
  String get libraryPlayAlbum => 'Play album';

  @override
  String get libraryPlayNext => 'Play next';

  @override
  String radioFavExportDone(String path) {
    return 'CSV exported: $path';
  }

  @override
  String get radioFavExportError => 'Export error';

  @override
  String get streamingViewAlbum => 'View album';

  @override
  String get streamingLogoutContent => 'Your account will be disconnected.';

  @override
  String get streamingUrlCopied => 'URL copied to clipboard';

  @override
  String get streamingDeviceCodeHint =>
      'Go to this URL and enter the code above:';

  @override
  String get searchHintFull => 'Search artists, albums, tracks…';

  @override
  String get browseNavError => 'Navigation error';

  @override
  String get streamingCodeEntered => 'I\'ve entered the code';

  @override
  String get appleMusicAuthorize => 'Allow access';

  @override
  String get smbNavTitle => 'SMB Source';

  @override
  String get smbTitle => 'SMB Connection';

  @override
  String get smbHostHint => 'Enter the address of the SMB server';

  @override
  String get smbHostLabel => 'IP Address (e.g. 192.168.1.23)';

  @override
  String get smbUser => 'Username';

  @override
  String get smbPassword => 'Password';

  @override
  String get smbConnect => 'Connect';

  @override
  String get smbSelectShare => 'Select a share';

  @override
  String get smbBack => 'Back';

  @override
  String get smbManualHint =>
      'Unable to list shares automatically.\nEnter the share name manually:';

  @override
  String get smbShareName => 'Share name (e.g. Share, Music)';

  @override
  String get smbScan => 'Scan';

  @override
  String get smbScanning => 'Scanning…';

  @override
  String smbScanCount(int count) {
    return '$count audio files found';
  }

  @override
  String get smbDoneTitle => 'Indexing complete';

  @override
  String smbDoneBody(int count, String share) {
    return '$count tracks imported from $share';
  }

  @override
  String get smbAddAnother => 'Add another share';

  @override
  String get settingsSmb => 'SMB / Samba Sources';

  @override
  String get settingsSmbDesc => 'Index libraries from network shares';

  @override
  String get podcastsTitle => 'Podcasts';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => 'Search';

  @override
  String get podcastsEmpty => 'No podcasts';

  @override
  String get podcastsSearchHint => 'Search for a podcast…';

  @override
  String get podcastsNoEpisodes => 'No episodes';

  @override
  String get navPodcasts => 'Podcasts';

  @override
  String get streamingConnectedSuccess => 'Connected!';

  @override
  String browseItemCount(int count) {
    return '$count items';
  }

  @override
  String get settingsSources => 'Sources & Devices';

  @override
  String get settingsSourcesDesc => 'UPnP servers, DLNA renderers';

  @override
  String get sourcesTitle => 'Sources & Devices';

  @override
  String get sourcesServersSection => 'UPnP Content Servers';

  @override
  String get sourcesRenderersSection => 'DLNA Renderers';

  @override
  String get sourcesNoDevices => 'No device discovered';

  @override
  String get sourcesTypeServer => 'Server';

  @override
  String get sourcesTypeRenderer => 'Renderer';

  @override
  String get sourcesAvailable => 'Available';

  @override
  String get sourcesUnavailable => 'Offline';

  @override
  String get sourcesIndexBtn => 'Index library';

  @override
  String get sourcesRescanBtn => 'Rescan';

  @override
  String get sourcesForget => 'Forget';

  @override
  String get sourcesAddManually => 'Add manually';

  @override
  String get sourcesAddTitle => 'Manual probe';

  @override
  String get sourcesIpLabel => 'IP address';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => 'Port';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => 'Probing…';

  @override
  String get sourcesNotFound => 'No UPnP device found at this address';

  @override
  String get zonesMultiRoom => 'Multi-Room';

  @override
  String get zonesCreateGroup => 'Create group';

  @override
  String get zonesGroupLeader => 'Leader';

  @override
  String get zonesGroupFollower => 'Follower';

  @override
  String get zonesGroupDissolve => 'Dissolve group';

  @override
  String get zonesGroupSyncDelay => 'Sync delay';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => 'Select zones';

  @override
  String get zonesGroupSelectLeader => 'Select leader';

  @override
  String get zonesGroupNoZones => 'No active groups';

  @override
  String get zonesGroupNeedTwo => 'Select at least 2 zones';

  @override
  String get zonesGroupCreated => 'Group created';

  @override
  String get zonesGroupDissolved => 'Group dissolved';

  @override
  String get metadataSectionEnrich => 'Enrich';

  @override
  String get metadataSectionDuplicates => 'Duplicates';

  @override
  String get metadataSectionCorrect => 'Correct';

  @override
  String get metadataFilterAll => 'All';

  @override
  String get metadataFilterMissingCover => 'Missing covers';

  @override
  String get metadataFilterMissingGenre => 'Missing genre';

  @override
  String get metadataFilterMissingYear => 'Missing year';

  @override
  String get metadataFilterMissingArtist => 'Missing artist';

  @override
  String get metadataFilterDoubtful => 'Doubtful';

  @override
  String get metadataSearchHint => 'Search albums…';

  @override
  String get metadataArtistFilter => 'Artist';

  @override
  String get metadataGenreFilter => 'Genre';

  @override
  String get metadataAllArtists => 'All artists';

  @override
  String get metadataAllGenres => 'All genres';

  @override
  String get metadataNoAlbums => 'No albums match';

  @override
  String get metadataEditAlbum => 'Edit album';

  @override
  String get metadataSaveChanges => 'Save';

  @override
  String get metadataWriteTags => 'Write Tags';

  @override
  String metadataWriteTagsSuccess(int count) {
    return 'Tags written: $count files';
  }

  @override
  String get metadataMergeGroup => 'Merge';

  @override
  String metadataMergeConfirm(int count) {
    return 'Merge these $count albums into one? The album with the most tracks will be kept.';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return 'Merged: $moved tracks moved, $total total';
  }

  @override
  String get metadataUploadCover => 'Upload cover';

  @override
  String get metadataCoverUploaded => 'Cover uploaded';

  @override
  String get metadataAlbumSaved => 'Album saved';

  @override
  String metadataDupAlbums(int count) {
    return '$count duplicate albums';
  }

  @override
  String get metadataDoubtfulReasons => 'Issues';

  @override
  String get metadataArtistField => 'Artist';

  @override
  String get metadataAlbumField => 'Album';

  @override
  String get metadataGenreField => 'Genre';

  @override
  String get metadataYearField => 'Year';

  @override
  String metadataTracksCount(int count) {
    return '$count tracks';
  }

  @override
  String get stereoPairsTitle => 'Stereo Pairs';

  @override
  String get stereoPairCreate => 'Create stereo pair';

  @override
  String get stereoPairName => 'Pair name';

  @override
  String get stereoPairNameHint => 'e.g. Living Room Stereo';

  @override
  String get stereoPairLeft => 'Left (L)';

  @override
  String get stereoPairRight => 'Right (R)';

  @override
  String get stereoPairSelectDevice => 'Select a device';

  @override
  String get stereoPairNone => 'No stereo pairs';

  @override
  String get stereoPairCreated => 'Stereo pair created';

  @override
  String get stereoPairDissolved => 'Stereo pair dissolved';

  @override
  String get stereoPairDissolve => 'Dissolve';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => 'Enable';

  @override
  String get streamingDisable => 'Disable';

  @override
  String get streamingEnabled => 'Service enabled';

  @override
  String get streamingDisabled => 'Service disabled';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Tune!';

  @override
  String get onboardingWelcomeBody =>
      'Your embedded multi-room music server. Let\'s set up your installation in a few steps.';

  @override
  String get onboardingWelcomeStart => 'Get started';

  @override
  String get onboardingConfigTitle => 'Configuration';

  @override
  String get onboardingConfigBody =>
      'Specify a folder containing your audio files, or connect to a remote Tune server.';

  @override
  String get onboardingConfigModeLocal => 'Embedded server';

  @override
  String get onboardingConfigModeRemote => 'Remote server';

  @override
  String get onboardingZoneTitle => 'Create a zone';

  @override
  String get onboardingZoneBody =>
      'The devices below were discovered on your network. Tap one to create your first audio zone.';

  @override
  String get onboardingZoneEmpty =>
      'No devices discovered yet. You can add more later.';

  @override
  String onboardingZoneCreated(String name) {
    return 'Zone created: $name';
  }

  @override
  String get onboardingDoneTitle => 'All done!';

  @override
  String get onboardingDoneBody => 'Your setup is ready. Enjoy your music!';

  @override
  String get onboardingDoneButton => 'Go to dashboard';

  @override
  String get artistBio => 'Biography';

  @override
  String get artistAnecdotes => 'Anecdotes';

  @override
  String get artistSimilarArtists => 'Similar artists';

  @override
  String get artistMembers => 'Members';

  @override
  String get artistDiscography => 'Discography';

  @override
  String get artistEnriching => 'Enrichment in progress…';

  @override
  String get artistGenres => 'Genres';

  @override
  String get libraryShuffleAll => 'Shuffle All';

  @override
  String get librarySortBy => 'Sort by';

  @override
  String get librarySortTitle => 'Title';

  @override
  String get librarySortArtist => 'Artist';

  @override
  String get librarySortYear => 'Year';

  @override
  String get librarySortOriginalYear => 'Original Year';

  @override
  String get librarySortAddedDate => 'Date Added';

  @override
  String get librarySortAscending => 'Ascending';

  @override
  String get librarySortDescending => 'Descending';

  @override
  String get addFavorite => 'Add to favorites';

  @override
  String get addFolder => 'Add a folder';

  @override
  String get addThisFolder => 'Add this folder';

  @override
  String get addToPlaylist => 'Add to a playlist';

  @override
  String get addedToPlaylist => 'Added to playlist';

  @override
  String get audioOutput => 'Audio output';

  @override
  String get audioOutputDesc =>
      'Each server zone is one output (local ALSA, Diretta renderer…). Pick the zone to play on.';

  @override
  String get authorizeInBrowser => 'Authorize access in your browser:';

  @override
  String get cancel => 'Cancel';

  @override
  String get connect => 'Connect';

  @override
  String get connected => 'Connected';

  @override
  String get cover => 'Cover';

  @override
  String get create => 'Create';

  @override
  String get createPlaylist => 'Create a playlist';

  @override
  String get delete => 'Delete';

  @override
  String get deletePlaylist => 'Delete playlist';

  @override
  String get deletePlaylistConfirm => 'Delete this playlist?';

  @override
  String get disabled => 'Disabled';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get done => 'I\'m done';

  @override
  String get dynamicPlaylists => 'Dynamic playlists';

  @override
  String get dynamicTag => 'Dynamic';

  @override
  String errorWith(String msg) {
    return 'Error: $msg';
  }

  @override
  String favError(String msg) {
    return 'Favorite failed: $msg';
  }

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get filterAll => 'All';

  @override
  String get freqLimit => 'Frequency limit';

  @override
  String get gapless => 'Gapless playback';

  @override
  String get gaplessDesc =>
      'Disable if you hear white noise / glitches between tracks on this renderer.';

  @override
  String get host => 'Host';

  @override
  String get language => 'Language';

  @override
  String get loading => 'Loading…';

  @override
  String get localLibrary => 'Local library';

  @override
  String get localLibraryDesc => 'Folders the server scans for music';

  @override
  String get logIn => 'Log in';

  @override
  String get logOut => 'Log out';

  @override
  String loginTo(String service) {
    return 'Sign in to $service';
  }

  @override
  String get maxBitDepth => 'Max bit depth';

  @override
  String get maxFrequency => 'Max frequency';

  @override
  String maxTracks(int n) {
    return 'max $n';
  }

  @override
  String get metadataFields => 'Metadata fields';

  @override
  String get metadataFieldsDesc => 'Info shown for the local library';

  @override
  String get metadataSaved => 'Metadata saved';

  @override
  String get musicFolders => 'Scanned folders';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get newPlaylist => 'New playlist';

  @override
  String get noFavAlbums => 'No favorite album';

  @override
  String get noFavArtists => 'No favorite artist';

  @override
  String get noFavTracks => 'No favorite track';

  @override
  String get noFolders => 'No folder configured';

  @override
  String get noLimit => 'No limit';

  @override
  String get noPlaylists => 'No playlist';

  @override
  String get noResults => 'No results';

  @override
  String get noService => 'No service';

  @override
  String get noTracks => 'No tracks';

  @override
  String get noZones => 'No zone available';

  @override
  String get notConnected => 'Set up the server in Settings';

  @override
  String get nothingPlaying => 'Nothing playing';

  @override
  String get openAuthPage => 'Open the authorization page';

  @override
  String get password => 'Password';

  @override
  String get pickFolder => 'Choose a folder';

  @override
  String get playAll => 'Play all';

  @override
  String get playlistCreated => 'Playlist created';

  @override
  String get playlistDeleted => 'Playlist deleted';

  @override
  String get playlistsTitle => 'Playlists';

  @override
  String get port => 'Port';

  @override
  String get qualityCd => 'CD (44.1 kHz / 16 bit)';

  @override
  String get qualityHires => 'Hi-Res (up to 192 kHz)';

  @override
  String get qualityMax => 'Maximum';

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String get removeFromPlaylist => 'Remove from playlist';

  @override
  String get runScan => 'Scan library';

  @override
  String get scanning => 'Scanning…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · your library';

  @override
  String get searchEmptyTitle => 'Search a title, an album or an artist';

  @override
  String get searchTitle => 'Search';

  @override
  String get sectionAlbums => 'Albums';

  @override
  String get sectionArtists => 'Artists';

  @override
  String get sectionPlaylists => 'Playlists';

  @override
  String get sectionTracks => 'Tracks';

  @override
  String get server => 'Server';

  @override
  String get sourceLibrary => 'Library';

  @override
  String get streamingQuality => 'Streaming quality';

  @override
  String get streamingQualityDesc =>
      'Caps the frequency / resolution requested from services (Qobuz, Tidal…).';

  @override
  String get streamingServices => 'Streaming services';

  @override
  String get systemLanguage => 'System';

  @override
  String get trackRemoved => 'Removed from playlist';

  @override
  String tracksCount(int n) {
    return '$n tracks';
  }

  @override
  String get username => 'Username';

  @override
  String get visualizer => 'Visualizer';

  @override
  String get licenseSessionConflictTitle => 'License active on another server';

  @override
  String get licenseSessionConflictBody =>
      'Your Tune license is already in use on another of your servers. This server will switch back to Premium automatically a few minutes after the other one stops.';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'Your Tune license is active on “$server”. This server will switch back to Premium automatically a few minutes after the other one stops.';
  }

  @override
  String cfgSaveError(String detail) {
    return 'Save failed: $detail';
  }

  @override
  String get cfgReload => 'Reload';

  @override
  String get cfgFieldsLoadError => 'Couldn\'t load fields';

  @override
  String get cfgFieldsNone => 'No fields available';

  @override
  String get cfgFieldsHint =>
      'Choose which metadata fields are shown in the track editor.';

  @override
  String get cfgMetaCompleteness => 'Metadata completeness';

  @override
  String get cfgMetaEnrichMusicBrainz => 'Enrich with MusicBrainz';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'MusicBrainz enrichment';

  @override
  String get cfgMetaFixYearsTidal => 'Fix years (TIDAL)';

  @override
  String get cfgMetaFixYearsDiscogs => 'Fix years (Discogs)';

  @override
  String get cfgMetaFixGenres => 'Fix genres';

  @override
  String get cfgMetaAutoFixAlbums => 'Auto-fix albums';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending suggestions',
      one: '1 pending suggestion',
      zero: 'No pending suggestions',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => 'Accept all';

  @override
  String get cfgMetaSuggestions => 'Suggestions';

  @override
  String get cfgMetaScanDuplicates => 'Scan for duplicates';

  @override
  String get cfgMetaAutoMerge => 'Auto-merge';

  @override
  String get cfgMetaMergeDuplicatesTask => 'Duplicate merge';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$count duplicate albums in $groups groups',
      one: '$count duplicate albums in 1 group',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… and $count more groups',
      one: '… and 1 more group',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => 'Last result';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct% complete';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label: error — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label: $count accepted';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label: $fixed/$total fixed';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label: $fixed fixed';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label: $total processed';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label: done';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return 'Tag writing failed: $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return 'Upload failed: $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Merge $count albums?',
      one: 'Merge 1 album?',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody =>
      'The album with the most tracks will be kept; the others will be deleted.';

  @override
  String cfgMetaMergeError(String detail) {
    return 'Merge failed: $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => 'Statistics unavailable';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '1 album',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… and $count more albums (filter to narrow down)',
      one: '… and 1 more album (filter to narrow down)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count tracks';
  }

  @override
  String get cfgMetaReasonArtistUppercase => 'Artist in caps';

  @override
  String get cfgMetaReasonArtistPlaceholder => 'Placeholder artist';

  @override
  String get cfgMetaReasonArtistHasYear => 'Artist = folder';

  @override
  String get cfgMetaReasonGenrePlaceholder => 'Placeholder genre';

  @override
  String get cfgMetaReasonYearSuspicious => 'Suspicious year';

  @override
  String get cfgMetaReasonTitleUppercase => 'Title in caps';

  @override
  String get cfgMetaReasonArtistMismatch => 'Artist mismatch';

  @override
  String get cfgSmbNotConnected => 'Not connected to a remote server';

  @override
  String cfgSmbMountTitle(String name) {
    return 'Mount $name';
  }

  @override
  String get cfgSmbMount => 'Mount';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name mounted';
  }

  @override
  String get cfgSmbTitle => 'Network shares (SMB)';

  @override
  String get cfgSmbSearching => 'Searching for SMB shares…';

  @override
  String get cfgSmbNone => 'No SMB shares found';

  @override
  String get cfgSmbSaveCredentials => 'Save credentials';

  @override
  String get cfgUnknown => 'Unknown';

  @override
  String get cfgEqTitle => 'Equalizer';

  @override
  String get cfgEqTabAssistant => 'Assistant';

  @override
  String get cfgEqTabExpert => 'Expert';

  @override
  String cfgEqError(String detail) {
    return 'EQ error: $detail';
  }

  @override
  String get cfgEqPresetFlat => 'Flat';

  @override
  String get cfgEqPresetBassBoost => 'Bass Boost';

  @override
  String get cfgEqPresetClassical => 'Classical';

  @override
  String get cfgEqPresetVocal => 'Vocal';

  @override
  String get cfgNotConnectedToServer => 'Not connected to the server';

  @override
  String get cfgCredentialsRequired => 'Username and password are required';

  @override
  String cfgServiceConnected(String service) {
    return '$service connected.';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service disconnected.';
  }

  @override
  String get cfgLastfmTitle => 'Last.fm scrobbling';

  @override
  String get cfgLastfmDesc =>
      'Scrobble your listening history to Last.fm. Tracks are scrobbled automatically when played on any zone.';

  @override
  String get cfgDisconnecting => 'Disconnecting…';

  @override
  String get cfgConnectHeader => 'CONNECT';

  @override
  String get cfgConnecting => 'Connecting…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scrobbles',
      one: '1 scrobble',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return 'Last: $date';
  }

  @override
  String get cfgTokenRequired => 'Please enter your user token';

  @override
  String get cfgScrobblerUnavailable => 'Scrobbler not available';

  @override
  String cfgConnectedAs(String name) {
    return 'Connected as $name';
  }

  @override
  String get cfgListenbrainzDesc =>
      'Scrobble your listening history to ListenBrainz. Get your user token from listenbrainz.org/settings.';

  @override
  String get cfgUserToken => 'User token';

  @override
  String get cfgValidating => 'Validating…';

  @override
  String get cfgSaveAndConnect => 'Save & connect';

  @override
  String get cfgScrobbleAuto => 'Tracks will be scrobbled automatically';

  @override
  String cfgConfigExported(String path) {
    return 'Configuration exported: $path';
  }

  @override
  String get cfgConfigImported => 'Configuration imported successfully';

  @override
  String cfgImportError(String detail) {
    return 'Import failed: $detail';
  }

  @override
  String get cfgConfigExportDesc =>
      'Saves the server configuration to a JSON file.';

  @override
  String get cfgConfigExportJson => 'Export JSON';

  @override
  String get cfgConfigImportDesc =>
      'Restores a configuration from a JSON file.';

  @override
  String get cfgChooseFile => 'Choose a file';

  @override
  String get cfgDbNoServer => 'No server connected.';

  @override
  String cfgDbExportOk(String size, String path) {
    return 'Export OK: $size MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => 'File path is not accessible.';

  @override
  String get cfgDbImportConfirmTitle => 'Confirm import';

  @override
  String cfgDbImportConfirmBody(String name) {
    return 'Replace the server database with \"$name\"?\n\nA safety backup will be created automatically. The server must be restarted after the import.';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return 'Import OK: $size MB ($engine).\nRestart the server to apply the changes.';
  }

  @override
  String get cfgDbTitle => 'Database';

  @override
  String get cfgDbIntro =>
      'Export or import the database of the connected server.\nSQLite: .db file. PostgreSQL: SQL dump.';

  @override
  String get cfgDbExporting => 'Exporting…';

  @override
  String get cfgDbExportBtn => 'Export database';

  @override
  String get cfgDbImporting => 'Importing…';

  @override
  String get cfgDbImportBtn => 'Import a file';

  @override
  String get cfgDbFooter =>
      'After an import, restart the server to apply the changes. A safety backup is created automatically before the replacement.';

  @override
  String cfgStatusUnavailable(String detail) {
    return 'Status unavailable: $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune shows up as a Spotify Connect receiver on the local network. In the Spotify app, select “Tune (…)” in the device list. A Spotify Premium account is required on the client side.';

  @override
  String get cfgSpotifyNoLibrespot => 'librespot not found on the server';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      'Reinstall Tune Server from the official tarball/zip so the binary is included, or install it separately (apt install librespot / brew install librespot).';

  @override
  String get cfgTargetZone => 'Target zone';

  @override
  String get cfgDeviceName => 'Device name';

  @override
  String get cfgPlaying => 'Playing';

  @override
  String get cfgNetDiagTitle => 'Network diagnostics';

  @override
  String get cfgNetSsdpActive => 'SSDP active';

  @override
  String get cfgNetMulticastReachable => 'Multicast reachable';

  @override
  String get cfgError => 'Error';

  @override
  String get cfgNetResolution => 'Resolution';

  @override
  String get cfgNetLatency => 'Latency';

  @override
  String get cfgNetPublicIp => 'Public IP';

  @override
  String get cfgNetInterfaces => 'NETWORK INTERFACES';

  @override
  String get cfgStatusWarning => 'Warning';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total albums';
  }

  @override
  String get libNoCollectionsYet => 'No collections yet';

  @override
  String libRatingError(String error) {
    return 'Rating error: $error';
  }

  @override
  String libDisc(int disc) {
    return 'Disc $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return 'Disc $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => 'Quick favorite';

  @override
  String get libAddToCollection => 'Add to collection';

  @override
  String get libAlbumNotes => 'Album notes';

  @override
  String get libCredits => 'Credits';

  @override
  String get libNoCredits => 'No credits';

  @override
  String get libNoAlbumNotes => 'No album notes available';

  @override
  String get libNoNotes => 'No notes available';

  @override
  String get libSourceCommunity => 'Tune Community';

  @override
  String libBioSource(String source) {
    return 'Source: $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return 'Source: $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied =>
      'Access to the Apple Music library denied.';

  @override
  String get libAppleMusicPermissionRefused =>
      'Permission denied. Enable access in Settings > Privacy > Media & Apple Music.';

  @override
  String get libUnknownError => 'Unknown error';

  @override
  String get libAppleMusicAccessTitle => 'Access to Apple Music';

  @override
  String get libAppleMusicAccessBody =>
      'Allow access to your music library to play your Apple Music tracks.';

  @override
  String get libAppleMusicEmpty => 'Apple Music library is empty';

  @override
  String get libReportImageTitle => 'Report image';

  @override
  String get libReportImageBody =>
      'Report this artist image as incorrect? The server will replace it during the next enrichment.';

  @override
  String get libReportAction => 'Report';

  @override
  String get libImageReported => 'Image reported';

  @override
  String libServiceAlbums(String service) {
    return '$service albums';
  }

  @override
  String libTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '1 track',
    );
    return '$_temp0';
  }

  @override
  String get libDuplicateScanner => 'Duplicate scanner';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$groups duplicate groups found',
      one: '1 duplicate group found',
    );
    return '$_temp0 ($tracks tracks total)';
  }

  @override
  String get libFindDuplicatesTitle => 'Find duplicate tracks';

  @override
  String get libFindDuplicatesBody =>
      'Scans audio content hashes to find identical tracks in your library.';

  @override
  String get libStartScan => 'Start scan';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total tracks ($percent%)';
  }

  @override
  String get libLoadingTracks => 'Loading tracks…';

  @override
  String get libNoDuplicatesFound => 'No duplicates found';

  @override
  String get libLibraryClean => 'Your library is clean.';

  @override
  String get libScanAgain => 'Scan again';

  @override
  String get libScanFailed => 'Scan failed';

  @override
  String get libTrackNumberField => 'Track no.';

  @override
  String get libDiscNumberField => 'Disc no.';

  @override
  String get libExtendedMetadata => 'Extended metadata';

  @override
  String get libGenreTreeSaved => 'Genre tree saved';

  @override
  String libSaveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get libGenreTree => 'Genre tree';

  @override
  String get libAddRootGenre => 'Add root genre';

  @override
  String get libGenreTreeRequiresRemote =>
      'The genre tree requires a connection to a remote server.';

  @override
  String get libNoGenreHierarchy => 'No genre hierarchy defined';

  @override
  String libAddSubGenreTo(String parent) {
    return 'Add sub-genre to “$parent”';
  }

  @override
  String get libGenreName => 'Genre name';

  @override
  String libSubGenreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sub-genres',
      one: '1 sub-genre',
    );
    return '$_temp0';
  }

  @override
  String get libAddSubGenre => 'Add sub-genre';

  @override
  String get libRemove => 'Remove';

  @override
  String libRemoveNamedConfirm(String name) {
    return 'Remove “$name”?';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This will also remove all $count sub-genres.',
      one: 'This will also remove its sub-genre.',
    );
    return '$_temp0';
  }

  @override
  String get libRemoveGenreBody => 'This genre will be removed from the tree.';

  @override
  String libAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums',
      one: '1 album',
    );
    return '$_temp0';
  }

  @override
  String get libNoTracksForFilter => 'No tracks match this filter';

  @override
  String get libQualityLossless => 'Lossless';

  @override
  String get libQualityLossy => 'Lossy';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total tracks';
  }

  @override
  String get libNewCollection => 'New collection';

  @override
  String get libCollectionName => 'Collection name';

  @override
  String libCreateError(String error) {
    return 'Create error: $error';
  }

  @override
  String libDeleteError(String error) {
    return 'Delete error: $error';
  }

  @override
  String get libCollectionsTitle => 'Collections';

  @override
  String get libCollectionsLoadFailed => 'Failed to load collections';

  @override
  String get libDeleteCollectionTitle => 'Delete collection?';

  @override
  String libDeleteCollectionBody(String name) {
    return 'This will permanently delete “$name”.';
  }

  @override
  String get libNoAlbumsInCollection => 'No albums in this collection';

  @override
  String get libDeleteConfirmTitle => 'Delete?';

  @override
  String get libDeleteSmartCollectionBody =>
      'This smart collection will be permanently deleted.';

  @override
  String get libNoRules => 'no rules';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return 'credit: $role=$artist';
  }

  @override
  String get libAnd => 'AND';

  @override
  String get libOr => 'OR';

  @override
  String get libSmartCollections => 'Smart Collections';

  @override
  String get libNewSmartCollection => 'New smart collection';

  @override
  String get libNoSmartCollections => 'No smart collections';

  @override
  String get libSmartCollectionsSeedHint =>
      'The server normally creates 7 default collections on first start.';

  @override
  String get libCreateFirstSmartCollection =>
      'Create my first smart collection';

  @override
  String get libNoMatchingAlbums => 'No matching albums';

  @override
  String get libSmartCreditsHint =>
      'For credit-based rules (engineer, performer, …), enrich the library from Settings first.';

  @override
  String get libFieldSampleRate => 'Sample rate';

  @override
  String get libFieldBitDepth => 'Bit depth';

  @override
  String get libFieldTrackCount => 'Track count';

  @override
  String get libFieldFormat => 'Format';

  @override
  String get libFieldLabel => 'Label';

  @override
  String get libFieldAlbumTitle => 'Album title';

  @override
  String get libFieldSource => 'Source';

  @override
  String get libFieldCredit => 'Credit';

  @override
  String get libFieldPlayCount => 'Play count';

  @override
  String get libFieldLastPlayed => 'Last played';

  @override
  String get libOpBetween => 'between';

  @override
  String get libOpContains => 'contains';

  @override
  String get libOpStartsWith => 'starts with';

  @override
  String get libOpEmpty => 'empty';

  @override
  String get libOpNotEmpty => 'not empty';

  @override
  String get libOpNever => 'never';

  @override
  String get libOpAfter => 'after';

  @override
  String get libOpBefore => 'before';

  @override
  String get libNameLabel => 'Name';

  @override
  String get libMatchMode => 'Match';

  @override
  String get libMatchAll => 'All rules (AND)';

  @override
  String get libMatchAny => 'At least one (OR)';

  @override
  String get libAddRule => 'Add a rule';

  @override
  String get libMatchingAlbumsPending => '… matching albums';

  @override
  String libMatchingAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matching albums',
      one: '1 matching album',
    );
    return '$_temp0';
  }

  @override
  String get libTimestampHint => 'now-30d or 2024-01-01';

  @override
  String get libValueHint => 'value';

  @override
  String get libMinHint => 'min';

  @override
  String get libMaxHint => 'max';

  @override
  String get libCommaSeparatedHint => 'comma-separated values';

  @override
  String get libCreditRoleHint => 'role (engineer, performer, …)';

  @override
  String get libCreditArtistHint => 'artist (Rudy Van Gelder, …)';

  @override
  String get libCreditInstrumentHint => 'instrument (Piano, …) — optional';

  @override
  String get libDirectories => 'Directories';

  @override
  String get libLoadError => 'Loading error';

  @override
  String get libNoFolders => 'No folders';

  @override
  String get libAddFoldersInSettings => 'Add music folders in Settings';

  @override
  String get libFoldersHeader => 'Folders';

  @override
  String libTracksHeaderCount(int count) {
    return 'Tracks ($count)';
  }

  @override
  String get libPlayFromHere => 'Play from here';

  @override
  String get libTags => 'Tags';

  @override
  String get libNewTagHint => 'New tag…';

  @override
  String get libJustNow => 'Just now';

  @override
  String libMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String libHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String get libYesterday => 'Yesterday';

  @override
  String libDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get libNowListening => 'Now listening';

  @override
  String get libContinueListening => 'Continue listening';

  @override
  String get libRecentlyAdded => 'Recently added';

  @override
  String get libTopTracks => 'Top tracks';

  @override
  String get libTopArtists => 'Top artists';

  @override
  String get libRecommendations => 'Recommendations';

  @override
  String get libSourceLocal => 'Local';

  @override
  String get libFieldDuration => 'Duration';

  @override
  String get libFilter => 'Filter';

  @override
  String get libRefreshAll => 'Refresh all';

  @override
  String get libPodcastsSubscribed => 'Subscribed';

  @override
  String get libNoSubscriptions => 'No subscriptions yet';

  @override
  String get libSubscribeRssFeed => 'Subscribe to an RSS feed';

  @override
  String get libUnknown => 'Unknown';

  @override
  String get libUnsubscribeTitle => 'Unsubscribe?';

  @override
  String libUnsubscribeBody(String name) {
    return 'Unsubscribe from “$name”?';
  }

  @override
  String get libUnsubscribe => 'Unsubscribe';

  @override
  String libEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodes',
      one: '1 episode',
    );
    return '$_temp0';
  }

  @override
  String get libSubscribeToPodcast => 'Subscribe to a podcast';

  @override
  String get libRssFeedUrl => 'RSS feed URL';

  @override
  String get libSubscribe => 'Subscribe';

  @override
  String get libSubscribed => 'Subscribed.';

  @override
  String libSubscribeError(String error) {
    return 'Subscribe error: $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return 'Unsubscribe error: $error';
  }

  @override
  String get libPodcastRefreshed => 'Podcast refreshed.';

  @override
  String libRefreshError(String error) {
    return 'Refresh error: $error';
  }

  @override
  String get libAllPodcastsRefreshed => 'All podcasts refreshed.';

  @override
  String get libToday => 'Today';

  @override
  String get miscNavFolders => 'Folders';

  @override
  String get miscNavCollections => 'Collections';

  @override
  String get miscNavSmartCollections => 'Smart Collections';

  @override
  String get miscNavDjMode => 'DJ Mode';

  @override
  String get miscNavPartyMode => 'Party Mode';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => 'Party';

  @override
  String get miscNavSmartPlaylists => 'Smart Playlists';

  @override
  String get miscNavAlarms => 'Alarms';

  @override
  String get miscNavGenreTree => 'Genre Tree';

  @override
  String get miscNavDashboard => 'Dashboard';

  @override
  String get miscNavDiagnostics => 'Diagnostics';

  @override
  String get miscNavAdmin => 'Admin';

  @override
  String get miscNavMore => 'More';

  @override
  String get miscNextTrack => 'Next track';

  @override
  String get miscPreviousTrack => 'Previous track';

  @override
  String get miscUnknownError => 'Unknown error';

  @override
  String get miscAuthorizationCode => 'Authorization code';

  @override
  String get miscWaitingForValidation => 'Waiting for approval…';

  @override
  String miscCodeValue(String code) {
    return 'Code: $code';
  }

  @override
  String get miscQualityHigh => 'High';

  @override
  String get miscExplore => 'Explore';

  @override
  String get miscFavoriteAlbums => 'Favorite albums';

  @override
  String get miscFavoriteTracks => 'Favorite tracks';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'See all $count tracks',
      one: 'See 1 track',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => 'My playlists';

  @override
  String get miscNoApiClient => 'No API client';

  @override
  String miscServiceFavorites(String service) {
    return '$service favorites';
  }

  @override
  String miscPlayAllCount(int count) {
    return 'Play all ($count)';
  }

  @override
  String get miscServiceNotFound => 'Service not found';

  @override
  String get miscYtHome => 'Home';

  @override
  String get miscYtCharts => 'Charts';

  @override
  String get miscYtMoods => 'Moods';

  @override
  String get miscNoData => 'No data';

  @override
  String get miscNoContentAvailable => 'No content available';

  @override
  String get miscNoChartsAvailable => 'No charts available';

  @override
  String get miscNoMoodsAvailable => 'No moods available';

  @override
  String get miscDashTotalPlays => 'Total plays';

  @override
  String get miscDashListeningTime => 'Listening time';

  @override
  String get miscDashUniqueTracks => 'Unique tracks';

  @override
  String get miscDashUniqueArtists => 'Unique artists';

  @override
  String get miscDashTopArtists => 'TOP ARTISTS';

  @override
  String get miscDashTopAlbums => 'TOP ALBUMS';

  @override
  String get miscDashTopTracks => 'TOP TRACKS';

  @override
  String get miscDashListeningByHour => 'LISTENING BY HOUR';

  @override
  String get miscDashListeningByDay => 'LISTENING BY DAY';

  @override
  String get miscDashAllTime => 'All time';

  @override
  String miscDashLastDays(int days) {
    return '$days days';
  }

  @override
  String get miscUnknown => 'Unknown';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plays',
      one: '1 play',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => 'No listening data yet';

  @override
  String get miscDashNoDataHint => 'Play some music to see your stats here.';

  @override
  String get miscDashLoadFailed => 'Failed to load dashboard';

  @override
  String get miscDiagRequiresRemote =>
      'Diagnostics requires a remote server connection.';

  @override
  String get miscDiagSystem => 'System';

  @override
  String get miscDiagHealth => 'Health';

  @override
  String get miscVersion => 'Version';

  @override
  String get miscDiagUptime => 'Uptime';

  @override
  String get miscDiagMemory => 'Memory';

  @override
  String get miscDiagDatabase => 'Database';

  @override
  String miscZoneNumbered(String id) {
    return 'Zone $id';
  }

  @override
  String get miscDiagLogs => 'Logs';

  @override
  String get miscDiagNoLogs => 'No logs available';

  @override
  String get miscAdminTitle => 'Admin dashboard';

  @override
  String get miscAdminNotConnected => 'Not connected to a remote server';

  @override
  String get miscAdminSystemHealth => 'System health';

  @override
  String get miscAdminStatus => 'Status';

  @override
  String get miscAdminDisk => 'Disk';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return 'Discovered devices ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return 'Recent errors ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => 'No recent errors';

  @override
  String get miscTroubleshootingTitle => 'Troubleshooting';

  @override
  String get miscFaqHeader => 'Frequently asked questions';

  @override
  String get miscFaq1Title => 'I can\'t see my server';

  @override
  String get miscFaq1Step1 =>
      'Check that the Tune server is running and reachable.';

  @override
  String get miscFaq1Step2 =>
      'Make sure your device is on the same Wi-Fi network as the server.';

  @override
  String get miscFaq1Step3 =>
      'If you use a VPN, turn it off or enable LAN discovery (e.g. nordvpn set lan-discovery on).';

  @override
  String get miscFaq1Step4 =>
      'Try scanning the network from Settings > Mode > Scan network.';

  @override
  String get miscFaq1Step5 =>
      'Check that the server port (8888 by default) is not blocked by a firewall.';

  @override
  String get miscFaq1Step6 => 'Restart the server and the app.';

  @override
  String get miscFaq2Title => 'Music won\'t play';

  @override
  String get miscFaq2Step1 =>
      'Check that a playback zone is selected (bar at the bottom of the screen).';

  @override
  String get miscFaq2Step2 =>
      'If no zone exists, create one in Settings > Audio > Zones > Create.';

  @override
  String get miscFaq2Step3 =>
      'Check that the output device (speaker, DAC) is switched on and on the same network.';

  @override
  String get miscFaq2Step4 =>
      'For DLNA devices, wait a few seconds after discovery before starting playback.';

  @override
  String get miscFaq2Step5 =>
      'Try another file — the current file\'s format may not be supported.';

  @override
  String get miscFaq2Step6 => 'Restart the app if the problem persists.';

  @override
  String get miscFaq3Title => 'Covers don\'t show up';

  @override
  String get miscFaq3Step1 =>
      'Run a library scan from Settings > Library > Sources.';

  @override
  String get miscFaq3Step2 =>
      'Check that the files contain embedded covers (ID3/Vorbis tags).';

  @override
  String get miscFaq3Step3 =>
      'Put a cover.jpg or folder.jpg file in the album folder.';

  @override
  String get miscFaq3Step4 =>
      'Enable automatic cover fetching in Settings > Library > Metadata.';

  @override
  String get miscFaq3Step5 => 'Clear the image cache by restarting the app.';

  @override
  String get miscFaq4Title => 'The scan is stuck';

  @override
  String get miscFaq4Step1 =>
      'An initial scan can take several minutes depending on the size of the library.';

  @override
  String get miscFaq4Step2 =>
      'Check that the music folders are accessible (permissions, SMB mounts).';

  @override
  String get miscFaq4Step3 =>
      'Close and relaunch the app to interrupt a stuck scan.';

  @override
  String get miscFaq4Step4 =>
      'Check the server logs to identify a problematic file.';

  @override
  String get miscFaq4Step5 =>
      'Try reducing the number of source folders to isolate the problem.';

  @override
  String get miscFaq5Title => 'How to connect a DLNA/AirPlay device';

  @override
  String get miscFaq5Step1 =>
      'DLNA: the device must be switched on and on the same network. It appears automatically in the list of outputs.';

  @override
  String get miscFaq5Step2 =>
      'If the device doesn\'t appear, check that multicast works on your router.';

  @override
  String get miscFaq5Step3 =>
      'Some routers block SSDP traffic between Wi-Fi clients — enable multicast forwarding.';

  @override
  String get miscFaq5Step4 =>
      'BluOS: Bluesound speakers are detected automatically.';

  @override
  String get miscFaq5Step5 =>
      'Chromecast: Google Cast devices appear in the available outputs.';

  @override
  String get miscFaq5Step6 =>
      'Once detected, create a zone and assign the device to it as its output.';

  @override
  String get miscFaq6Title => 'Streaming problems';

  @override
  String get miscFaq6Step1 =>
      'Check that your service credentials (TIDAL, Qobuz, Deezer) are correct in Settings > Streaming.';

  @override
  String get miscFaq6Step2 =>
      'If the session has expired, disconnect and then reconnect the service.';

  @override
  String get miscFaq6Step3 => 'Check your Internet connection.';

  @override
  String get miscFaq6Step4 => 'Some tracks may be unavailable in your region.';

  @override
  String get miscFaq6Step5 =>
      'For quality issues, check the streaming quality settings in Settings > Advanced audio.';

  @override
  String get miscFaq6Step6 =>
      'If the problem persists, send a bug report from Settings > Help.';

  @override
  String get miscBugReportCopied => 'Report copied to clipboard';

  @override
  String get miscBugReportSent => 'Bug sent, thank you!';

  @override
  String get miscBugReportSendFailed =>
      'Sending failed. Copy the report into the forum.';

  @override
  String get miscBugReportTitle => 'Bug report';

  @override
  String get miscRegenerate => 'Regenerate';

  @override
  String get miscBugReportGenerateFailed => 'Could not generate the report';

  @override
  String get miscSent => 'Sent!';

  @override
  String get miscSending => 'Sending…';

  @override
  String get miscSubmit => 'Submit';

  @override
  String get miscCopied => 'Copied!';

  @override
  String get miscCopyReport => 'Copy report';

  @override
  String get miscAiServerNotConnected =>
      'Server not connected. Check the connection.';

  @override
  String miscAiQueryFailed(int code) {
    return 'AI query failed ($code)';
  }

  @override
  String get miscAiNoReply => 'No reply';

  @override
  String get miscAiAskHint => 'Ask a question…';

  @override
  String get miscAiSend => 'Send';

  @override
  String get miscAiTitle => 'AI assistant';

  @override
  String get miscAiEmptyTitle => 'Tune AI assistant';

  @override
  String get miscAiEmptyBody =>
      'Ask a question about your music,\nask for recommendations…';

  @override
  String miscAiAction(String action) {
    return 'Action: $action';
  }

  @override
  String get miscCreateAccount => 'Create an account';

  @override
  String get miscUsername => 'Username';

  @override
  String get miscUsernameRequired => 'Username required';

  @override
  String get miscEmailRequired => 'Email required';

  @override
  String get miscEmailInvalid => 'Invalid email';

  @override
  String get miscPasswordRequired => 'Password required';

  @override
  String miscPasswordMinLength(int min) {
    return 'At least $min characters';
  }

  @override
  String get miscHaveAccountSignIn => 'Already have an account? Sign in';

  @override
  String get miscNoAccountSignUp => 'No account? Sign up';

  @override
  String get npRepeat => 'Repeat';

  @override
  String get npQueue => 'Queue';

  @override
  String get npFavorite => 'Favorite';

  @override
  String get npRadioFavAdded => 'Added to radio favorites';

  @override
  String get npLyrics => 'Lyrics';

  @override
  String get npAlarm => 'Alarm';

  @override
  String get npSleepTimer => 'Sleep timer';

  @override
  String get npDspCrossfeed => 'DSP Crossfeed';

  @override
  String get npEqualizer => 'Equalizer';

  @override
  String get npShare => 'Share';

  @override
  String get npTransfer => 'Transfer';

  @override
  String get npCopiedToClipboard => 'Copied to clipboard';

  @override
  String get npNoLyricsFound => 'No lyrics found';

  @override
  String get npNoLyricsAvailable => 'No lyrics available';

  @override
  String get npLyricsOpenFromNowPlaying =>
      'Open from Now Playing for full lyrics';

  @override
  String get npLyricsLoadFailed => 'Failed to load lyrics';

  @override
  String get npLrcMetadataTooltip => 'Metadata';

  @override
  String get npLrcMetadataTitle => 'LRC metadata';

  @override
  String get npLrcTitle => 'Title';

  @override
  String get npLrcCreatedBy => 'Created by';

  @override
  String get npLrcOffset => 'Offset (ms)';

  @override
  String get npLrcHint =>
      'Place a .lrc file next to the audio file with the same name.';

  @override
  String get npEqFlat => 'Flat';

  @override
  String get npEqBassBoost => 'Bass Boost';

  @override
  String get npEqTrebleBoost => 'Treble Boost';

  @override
  String get npEqVocal => 'Vocal';

  @override
  String get npEqRock => 'Rock';

  @override
  String get npEqJazz => 'Jazz';

  @override
  String get npEqClassical => 'Classical';

  @override
  String get npEqElectronic => 'Electronic';

  @override
  String get npEqHipHop => 'Hip Hop';

  @override
  String get npEqAcoustic => 'Acoustic';

  @override
  String npEqApplied(String preset) {
    return 'EQ: $preset';
  }

  @override
  String npEqError(String error) {
    return 'EQ error: $error';
  }

  @override
  String get npCrossfeedDesc =>
      'Blends stereo channels for a more natural headphone experience';

  @override
  String get npCrossfeedOff => 'Off';

  @override
  String get npCrossfeedLight => 'Light';

  @override
  String get npCrossfeedMedium => 'Medium';

  @override
  String get npCrossfeedStrong => 'Strong';

  @override
  String npCrossfeedApplied(String level) {
    return 'Crossfeed: $level';
  }

  @override
  String npDspError(String error) {
    return 'DSP error: $error';
  }

  @override
  String get npTransferTitle => 'Transfer playback';

  @override
  String get npNoOtherZones => 'No other zones available';

  @override
  String npTransferredTo(String zone) {
    return 'Transferred to $zone';
  }

  @override
  String npTransferError(String error) {
    return 'Transfer error: $error';
  }

  @override
  String get npAlarmClock => 'Alarm clock';

  @override
  String npAlarmSetFor(String time) {
    return 'Alarm set for $time';
  }

  @override
  String npAlarmError(String error) {
    return 'Alarm error: $error';
  }

  @override
  String get npAlarmCancelled => 'Alarm cancelled';

  @override
  String get npPause => 'Pause';

  @override
  String get npStop => 'Stop';

  @override
  String get npRoleComposer => 'Composer';

  @override
  String get npRoleLyricist => 'Lyricist';

  @override
  String get npRoleArranger => 'Arranger';

  @override
  String get npRoleConductor => 'Conductor';

  @override
  String get npRolePerformer => 'Performer';

  @override
  String get npRoleProducer => 'Producer';

  @override
  String get npRoleMixer => 'Mixer';

  @override
  String get npRoleEngineer => 'Engineer';

  @override
  String get npCreditsEnriching => 'Enriching…';

  @override
  String get npCreditsEnrich => 'Enrich via MusicBrainz';

  @override
  String get npVolume => 'Volume';

  @override
  String get npChangeZone => 'Switch zone';

  @override
  String get npZoneFallback => 'Zone';

  @override
  String get npFollowMe => 'Follow me';

  @override
  String get npMovePlaybackTo => 'Move playback to…';

  @override
  String get npNowPlaying => 'Now playing';

  @override
  String get npTabMore => 'More';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return 'Sleep timer set: $minutes min (fade: $fade s)';
  }

  @override
  String npSleepTimerError(String error) {
    return 'Sleep timer error: $error';
  }

  @override
  String get npSleepTimerCancelled => 'Sleep timer cancelled';

  @override
  String get npSleepDuration => 'DURATION';

  @override
  String get npSleepCustom => 'Custom';

  @override
  String get npSleepFadeOut => 'FADE OUT';

  @override
  String npSleepFadeDesc(int seconds) {
    return 'Volume will gradually fade to zero during the last $seconds seconds.';
  }

  @override
  String get npSleepStarting => 'Starting…';

  @override
  String npSleepStart(String duration) {
    return 'Start ($duration)';
  }

  @override
  String get npSleepSelectDuration => 'Select duration';

  @override
  String get npSleepTimerActive => 'Timer active';

  @override
  String get npSleepCancelTimer => 'Cancel timer';

  @override
  String get npMoodChill => 'Chill';

  @override
  String get npMoodParty => 'Party';

  @override
  String get npMoodFocus => 'Focus';

  @override
  String get npMoodEnergetic => 'Energetic';

  @override
  String get npNoZoneAvailable => 'No zone available';

  @override
  String npMoodNoTracks(String mood) {
    return 'No tracks found for $mood';
  }

  @override
  String get npMoodInvalidTrackIds => 'Error: invalid track IDs';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks playing',
      one: '1 track playing',
    );
    return '$mood Mix: $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks added to the queue',
      one: '1 track added to the queue',
    );
    return '$mood Mix: $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Smart AutoPlay error: $error';
  }

  @override
  String get npSmartAutoplayDesc => 'Pick a mood to generate a smart playlist';

  @override
  String get npAlarmsNotConnected => 'Not connected to a remote server';

  @override
  String get npAlarmSnoozed => 'Alarm snoozed for 5 min';

  @override
  String get npAlarmsTitle => 'Alarms';

  @override
  String get npAlarmsEmpty => 'No alarms';

  @override
  String npZoneNumbered(String id) {
    return 'Zone $id';
  }

  @override
  String get npAlarmSkipsHolidays => 'Skips public holidays';

  @override
  String get npAlarmSnooze => 'Snooze';

  @override
  String get npAlarmDefaultName => 'Alarm';

  @override
  String get npAlarmEdit => 'Edit alarm';

  @override
  String get npAlarmNew => 'New alarm';

  @override
  String get npAlarmTime => 'Time';

  @override
  String get npAlarmNameHint => 'Wake-up';

  @override
  String get npAlarmDays => 'Days';

  @override
  String get npAlarmSkipHolidays => 'Skip public holidays';

  @override
  String get npAlarmCountry => 'Country:';

  @override
  String get npCountryFR => 'France';

  @override
  String get npCountryBE => 'Belgium';

  @override
  String get npCountryCH => 'Switzerland';

  @override
  String get npCountryCA => 'Canada';

  @override
  String get npCountryUS => 'USA';

  @override
  String get npCountryDE => 'Germany';

  @override
  String get npCountryGB => 'UK';

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
  String get npAlarmSourceName => 'Source name';

  @override
  String get npAlarmPlaylistId => 'Playlist ID';

  @override
  String get npAlarmAlbumId => 'Album ID';

  @override
  String get npAlarmIdentifier => 'Identifier';

  @override
  String get npAlarmPlaybackZone => 'Playback zone';

  @override
  String get npAlarmDefaultZone => 'Default';

  @override
  String npAlarmVolume(int percent) {
    return 'Volume: $percent%';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return 'Fade-in: $seconds s';
  }

  @override
  String get npAlarmEnabled => 'Enabled';

  @override
  String get npAlarmDeleteTitle => 'Delete alarm?';

  @override
  String get npDayMon => 'Mon';

  @override
  String get npDayTue => 'Tue';

  @override
  String get npDayWed => 'Wed';

  @override
  String get npDayThu => 'Thu';

  @override
  String get npDayFri => 'Fri';

  @override
  String get npDaySat => 'Sat';

  @override
  String get npDaySun => 'Sun';

  @override
  String get plHubTitle => 'Playlists Hub';

  @override
  String get plTabSmartAi => 'Smart AI';

  @override
  String get plTabTransfers => 'Transfers';

  @override
  String get plSync => 'Sync';

  @override
  String get plTabBackup => 'Backup';

  @override
  String get plCompare => 'Compare';

  @override
  String get plComparing => 'Comparing…';

  @override
  String plCompareError(String detail) {
    return 'Comparison failed: $detail';
  }

  @override
  String get plNoPlaylistsAvailable => 'No playlists available';

  @override
  String get plSectionSource => 'SOURCE';

  @override
  String get plSectionTarget => 'TARGET';

  @override
  String get plServiceLabel => 'Service';

  @override
  String get plPlaylistLabel => 'Playlist';

  @override
  String get plLocal => 'Local';

  @override
  String get plSourceLabel => 'Source';

  @override
  String get plRestoreSnapshotTitle => 'Restore snapshot';

  @override
  String get plLocalPlaylistNameLabel => 'Local playlist name:';

  @override
  String get plRestore => 'Restore';

  @override
  String plRestoreDone(String name, String matched, String notFound) {
    return '“$name” restored: $matched found, $notFound not found.';
  }

  @override
  String plRestoreReplaced(String name, String matched, String notFound) {
    return '“$name” replaced: $matched found, $notFound not found.';
  }

  @override
  String get plExistingTitle => 'Playlist already exists';

  @override
  String plExistingBody(String name) {
    return 'A playlist named “$name” already exists. Replace it?';
  }

  @override
  String get plReplace => 'Replace';

  @override
  String plDeleteSnapshotBody(String name) {
    return 'Delete the snapshot of “$name”?';
  }

  @override
  String get plSyncIntervalTitle => 'Auto-sync interval';

  @override
  String get plSyncIntervalLabel => 'Minutes (0 = manual only):';

  @override
  String get plSyncIntervalHint => 'e.g. 60';

  @override
  String get plNoTransfers => 'No transfers';

  @override
  String get plNoSyncLinks => 'No sync links';

  @override
  String get plNoSyncLinksHint => 'Create links from a transfer';

  @override
  String plPlaylistNumber(String id) {
    return 'Playlist #$id';
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
    return 'Sync OK: +$addedLocal/-$removedLocal local, +$addedRemote/-$removedRemote remote';
  }

  @override
  String plSyncConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ', $count conflicts',
      one: ', 1 conflict',
    );
    return '$_temp0';
  }

  @override
  String plSyncError(String detail) {
    return 'Sync failed: $detail';
  }

  @override
  String get plSectionBackup => 'BACKUP';

  @override
  String get plBackingUp => 'Backing up…';

  @override
  String get plBackupAll => 'Back up all playlists';

  @override
  String plBackupResult(String playlists, String tracks) {
    return '$playlists playlists · $tracks tracks';
  }

  @override
  String get plSectionSnapshots => 'SNAPSHOTS';

  @override
  String get plNoSnapshots => 'No snapshots. Run a backup to create one.';

  @override
  String get plSectionBatchTransfer => 'BATCH TRANSFER';

  @override
  String get plBatchTransferHint => 'Transfer every playlist from a service';

  @override
  String get plTransferring => 'Transferring…';

  @override
  String get plTransferAll => 'Transfer all';

  @override
  String plBatchResult(String count, String status) {
    return '$count playlists — $status';
  }

  @override
  String get plMergeDone => 'Playlists merged.';

  @override
  String plMergeError(String detail) {
    return 'Merge failed: $detail';
  }

  @override
  String get plNameLabel => 'Name';

  @override
  String plDeleteNamed(String name) {
    return 'Delete “$name”?';
  }

  @override
  String plImportedLocal(String name) {
    return '“$name” imported to local.';
  }

  @override
  String plImportError(String detail) {
    return 'Import failed: $detail';
  }

  @override
  String get plFilterAll => 'All';

  @override
  String get plMerge => 'Merge';

  @override
  String get plCancelMerge => 'Cancel merge';

  @override
  String get plMerging => 'Merging…';

  @override
  String get plImportToLocal => 'Import to local';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => 'Dedupe';

  @override
  String get plMergedNameHint => 'Merged playlist name';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '1 track',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => 'RESULTS';

  @override
  String get plCommon => 'Common';

  @override
  String get plSourceOnly => 'Source only';

  @override
  String get plTargetOnly => 'Target only';

  @override
  String plMatchRate(String rate) {
    return '$rate% match rate';
  }

  @override
  String plOnlyInSource(int count) {
    return 'Only in source ($count)';
  }

  @override
  String plOnlyInTarget(int count) {
    return 'Only in target ($count)';
  }

  @override
  String plMoreCount(int count) {
    return '+ $count more';
  }

  @override
  String get plTransferPlaylistTitle => 'Transfer playlist';

  @override
  String get plCreateOnRemote => 'Create on the remote service';

  @override
  String get plTransfer => 'Transfer';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return 'Transfer: $matched matched, $approximate approximate, $notFound missing.';
  }

  @override
  String get plRecover => 'Recover';

  @override
  String plRecoverDone(int available, int alternatives) {
    return 'Recover: $available available, $alternatives alternatives found.';
  }

  @override
  String plCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String get plDuplicate => 'Duplicate';

  @override
  String plDuplicated(String name) {
    return 'Duplicated: $name';
  }

  @override
  String plDeleted(String name) {
    return 'Deleted: $name';
  }

  @override
  String plTransferred(String name) {
    return 'Transferred: $name';
  }

  @override
  String get plTransferToLocal => 'Transfer to local';

  @override
  String get plExportJson => 'Export JSON';

  @override
  String get plExportCsv => 'Export CSV';

  @override
  String get plExportM3u => 'Export M3U';

  @override
  String get plExportJsonDone => 'JSON export complete';

  @override
  String get plExportCsvDone => 'CSV export complete';

  @override
  String plExportM3uDone(String path) {
    return 'M3U exported: $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'M3U export failed: $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported: $name ($count tracks)',
      one: 'Imported: $name (1 track)',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'M3U import failed: $detail';
  }

  @override
  String get plSmartTitle => 'Smart Playlists';

  @override
  String plSmartLoadError(String detail) {
    return 'Could not load smart playlists: $detail';
  }

  @override
  String plDeleteError(String detail) {
    return 'Delete failed: $detail';
  }

  @override
  String get plSmartEmpty => 'No smart playlists';

  @override
  String get plUntitled => 'Untitled';

  @override
  String get plSmartDeleteTitle => 'Delete smart playlist?';

  @override
  String plPreviewError(String detail) {
    return 'Preview failed: $detail';
  }

  @override
  String get plEnterName => 'Please enter a name';

  @override
  String plSaveError(String detail) {
    return 'Save failed: $detail';
  }

  @override
  String get plSmartEditTitle => 'Edit smart playlist';

  @override
  String get plSmartNewTitle => 'New smart playlist';

  @override
  String get plMatchLabel => 'Match';

  @override
  String get plMatchAll => 'All rules';

  @override
  String get plMatchAny => 'Any rule';

  @override
  String get plSectionRules => 'RULES';

  @override
  String get plAddRule => 'Add rule';

  @override
  String get plMaxTracksLabel => 'Max tracks (optional)';

  @override
  String get plNoLimit => 'No limit';

  @override
  String get plPreviewMatching => 'Preview matching tracks';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matching tracks',
      one: '1 matching track',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => 'Value';

  @override
  String get plUnknownTitle => 'Unknown';

  @override
  String plTracksLoadError(String detail) {
    return 'Could not load tracks: $detail';
  }

  @override
  String get plSmartNoTracks => 'No tracks match this playlist';

  @override
  String get plFieldGenre => 'Genre';

  @override
  String get plFieldArtist => 'Artist';

  @override
  String get plFieldAlbum => 'Album';

  @override
  String get plFieldTitle => 'Title';

  @override
  String get plFieldYear => 'Year';

  @override
  String get plFieldRating => 'Rating';

  @override
  String get plFieldPlayCount => 'Play count';

  @override
  String get plFieldDuration => 'Duration (ms)';

  @override
  String get plFieldDateAdded => 'Date added';

  @override
  String get plFieldFavorite => 'Favorite';

  @override
  String get plOpContains => 'contains';

  @override
  String get plOpEquals => 'equals';

  @override
  String get plOpStartsWith => 'starts with';

  @override
  String get plOpEndsWith => 'ends with';

  @override
  String get plOpGreaterThan => 'greater than';

  @override
  String get plOpLessThan => 'less than';

  @override
  String get plOpIs => 'is';

  @override
  String get plOpIsNot => 'is not';

  @override
  String get srvConfigTitle => 'Server configuration';

  @override
  String srvFolderAdded(String path) {
    return 'Folder added: $path';
  }

  @override
  String get srvRemoveFolderTitle => 'Remove this folder?';

  @override
  String srvScanStarted(String path) {
    return 'Scan started: $path';
  }

  @override
  String get srvFullScanStarted => 'Full scan started';

  @override
  String get srvRestartTitle => 'Restart the server?';

  @override
  String get srvRestartBody =>
      'The server will be stopped and restarted. Current playback will be interrupted.';

  @override
  String get srvRestartBtn => 'Restart';

  @override
  String get srvRestarting => 'Server restarting…';

  @override
  String get srvRestartInProgress => 'Restart in progress…';

  @override
  String get srvLoadError => 'Failed to load';

  @override
  String get srvScanFolderTooltip => 'Scan this folder';

  @override
  String get srvSectionServerInfo => 'Server information';

  @override
  String get srvInfoVersion => 'Version';

  @override
  String get srvInfoEngine => 'Engine';

  @override
  String get srvInfoDatabase => 'Database';

  @override
  String get srvSectionActions => 'Actions';

  @override
  String get srvRestartServer => 'Restart server';

  @override
  String get srvRestartServerDesc => 'Stops and relaunches the server process';

  @override
  String get srvManualEntry => 'Enter manually';

  @override
  String srvSelectPath(String path) {
    return 'Select \"$path\"';
  }

  @override
  String get srvBrowse => 'Browse…';

  @override
  String get srvFolderPathHint => '/path/to/music';

  @override
  String get srvFolderPathHelp =>
      'Enter the absolute path of the folder on the server.';

  @override
  String get srvNoSubfolders => 'No subfolders';

  @override
  String get srvPluginsTitle => 'Plugins';

  @override
  String get srvNotConnectedToServer => 'Not connected to the server';

  @override
  String srvPluginInstalled(String name) {
    return '$name installed';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name uninstalled';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name updated';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name enabled';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name disabled';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return 'Install failed: $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return 'Uninstall failed: $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get srvPluginsTabStore => 'Store';

  @override
  String get srvPluginsTabInstalled => 'Installed';

  @override
  String get srvRestartRequired => 'Restart required to apply changes';

  @override
  String get srvPluginsSearchHint => 'Search plugins…';

  @override
  String get srvPluginsNoneFound => 'No plugins found';

  @override
  String get srvPluginsNoneInstalled => 'No plugins installed';

  @override
  String get srvPluginsBrowseStore => 'Browse the Store';

  @override
  String get srvPluginBadgeFeatured => 'Featured';

  @override
  String get srvPluginBadgeUpdate => 'Update';

  @override
  String get srvPluginBadgeIncompatible => 'Incompatible';

  @override
  String srvPluginByAuthor(String author) {
    return 'by $author';
  }

  @override
  String get srvPluginActionUpdate => 'Update';

  @override
  String get srvPluginActionInstall => 'Install';

  @override
  String get srvPluginActionUninstall => 'Uninstall';

  @override
  String get srvPluginStatusActive => 'Active';

  @override
  String get srvPluginStatusError => 'Error';

  @override
  String get srvAutoFixTitle => 'Auto-fix metadata';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fixes applied',
      one: '1 fix applied',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence => 'No high-confidence fixes left';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggestions left',
      one: '1 suggestion left',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => 'Apply high confidence';

  @override
  String srvAutoFixTrackNumber(int id) {
    return 'Track #$id';
  }

  @override
  String get srvAutoFixCurrent => 'Current';

  @override
  String get srvAutoFixEmpty => '(empty)';

  @override
  String get srvAutoFixSuggested => 'Suggested';

  @override
  String get srvAutoFixSkip => 'Skip';

  @override
  String get srvAutoFixApply => 'Apply';

  @override
  String get srvAutoFixIntroTitle => 'Fix missing metadata';

  @override
  String get srvAutoFixIntroBody =>
      'Scans tracks with a missing genre, year or MusicBrainz ID and suggests fixes from MusicBrainz.';

  @override
  String get srvAutoFixStartScan => 'Start scan';

  @override
  String get srvAutoFixScanning => 'Searching MusicBrainz…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total tracks ($pct%)';
  }

  @override
  String get srvAutoFixLoadingTracks => 'Loading tracks…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fixes found so far',
      one: '1 fix found so far',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit =>
      'Limited to 1 request/s (MusicBrainz policy)';

  @override
  String get srvAutoFixNoneNeeded => 'No fixes needed';

  @override
  String get srvAutoFixAllComplete => 'All tracks have complete metadata.';

  @override
  String get srvAutoFixScanAgain => 'Scan again';

  @override
  String get srvAutoFixScanFailed => 'Scan failed';

  @override
  String get srvMpStepSetup => 'Setup';

  @override
  String get srvMpStepFineTune => 'Fine-tuning';

  @override
  String get srvMpListenTitle => 'How do you listen?';

  @override
  String get srvMpListenSubtitle =>
      'The profile will be tailored to your listening setup';

  @override
  String get srvMpSpeakers => 'Speakers';

  @override
  String get srvMpSpeakersSub => 'Listening room';

  @override
  String get srvMpHeadphones => 'Headphones';

  @override
  String get srvMpHeadphonesSub => 'Personal listening';

  @override
  String get srvMpRoomTitle => 'How big is the room?';

  @override
  String get srvMpRoomSubtitle => 'Affects low frequencies and reverberation';

  @override
  String get srvMpRoomSmall => 'Small';

  @override
  String get srvMpRoomMedium => 'Medium';

  @override
  String get srvMpRoomLarge => 'Large';

  @override
  String get srvMpPlacementTitle => 'Speaker placement';

  @override
  String get srvMpPlacementSubtitle => 'Placement affects bass reflections';

  @override
  String get srvMpNearWall => 'Near a wall';

  @override
  String get srvMpFreeStanding => 'Free-standing';

  @override
  String get srvMpTuneSound => 'Adjust the sound';

  @override
  String get srvMpCorrectionActive => 'Correction enabled';

  @override
  String get srvMpCorrectionDesc => 'Applies the profile to the current zone';

  @override
  String get srvMpBass => 'Bass';

  @override
  String get srvMpBassDesc => 'Weight, warmth, body of the sound';

  @override
  String get srvMpBassLow => 'Lean';

  @override
  String get srvMpBassHigh => 'Heavy';

  @override
  String get srvMpMid => 'Voice / Mids';

  @override
  String get srvMpMidDesc => 'Presence, clarity, intelligibility';

  @override
  String get srvMpMidLow => 'Recessed';

  @override
  String get srvMpMidHigh => 'Forward';

  @override
  String get srvMpTreble => 'Treble';

  @override
  String get srvMpTrebleDesc => 'Brilliance, detail, air in the sound';

  @override
  String get srvMpTrebleLow => 'Dark';

  @override
  String get srvMpTrebleHigh => 'Bright';

  @override
  String get srvMpProfileApplied => 'Profile applied';

  @override
  String get srvMpApplying => 'Applying…';

  @override
  String get srvMpApply => 'Apply profile';

  @override
  String get srvMpBackToQuestions => 'Back to questions';

  @override
  String get srvRemoteConfigBody =>
      'Connect to a Tune server on your network to enjoy every feature.';

  @override
  String get srvModeStandalone => 'Standalone';

  @override
  String get srvStandaloneWarning =>
      'Standalone mode: Party, DJ, synced lyrics, EQ and recommendations are not available. Recommended: use a remote Tune server.';

  @override
  String get srvServerAddress => 'Server address';

  @override
  String get srvNoServerYet => 'No server yet?';

  @override
  String get srvDownloadServer =>
      'Download Tune Server: mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).';

  @override
  String get srvStreamingBody =>
      'Enable the streaming services you want to use with Tune.';

  @override
  String get srvStreamingStandaloneWarning =>
      'Streaming services are not available in standalone mode. Switch to remote server mode to enable them.';

  @override
  String get srvNoServiceAvailable =>
      'No services available. Check the server connection.';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services enabled',
      one: '1 service enabled',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connected',
      one: '1 connected',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => 'Enabled, not connected';

  @override
  String get srvAudioCheckTitle => 'Audio check';

  @override
  String get srvAudioCheckBody =>
      'Checking your system\'s audio configuration.';

  @override
  String get srvDiagZones => 'Configured zones';

  @override
  String get srvDiagOutputs => 'Audio outputs';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count detected',
      one: '1 detected',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => 'Network devices';

  @override
  String get srvDiagNone => 'None';

  @override
  String get srvDiagNoZoneWarning =>
      'No zone configured. You can create one from the Zones settings.';

  @override
  String srvAudioCheckUnavailable(String error) {
    return 'Audio check unavailable: $error';
  }

  @override
  String get srvRecheck => 'Check again';

  @override
  String get srvScanBody =>
      'Start a scan to index your music files and fetch their metadata.';

  @override
  String get srvScanStart => 'Start scan';

  @override
  String get srvScanStatScanned => 'Scanned';

  @override
  String get srvScanStatAdded => 'Added';

  @override
  String get srvScanStatUpdated => 'Updated';

  @override
  String get srvScanMayTakeMinutes => 'This may take a few minutes…';

  @override
  String get srvScanComplete => 'Scan complete!';

  @override
  String stgUpdateAvailable(String version) {
    return 'Update available: v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return 'Current version: v$version';
  }

  @override
  String get stgOpen => 'Open';

  @override
  String get stgMode => 'Mode';

  @override
  String stgConnectedTo(String address) {
    return 'Connected to $address';
  }

  @override
  String get stgModeRemote => 'Remote';

  @override
  String get stgStandaloneTitle => 'Standalone mode — limited features';

  @override
  String get stgStandaloneBody =>
      'Party, DJ, synced lyrics, EQ, album bios, recommendations… require a remote Tune server.';

  @override
  String get stgServerAddress => 'Server address';

  @override
  String get stgNotConfigured => 'Not configured';

  @override
  String get stgScanNetwork => 'Scan the network';

  @override
  String get stgSectionPlayback => 'PLAYBACK';

  @override
  String get stgCrossfade => 'Crossfade';

  @override
  String get stgRepeatOneByDefault => 'Repeat by default';

  @override
  String get stgExclusiveMode => 'Exclusive mode (bit-perfect)';

  @override
  String get stgExclusiveModeDesc =>
      'WASAPI Exclusive — direct access to the USB DAC';

  @override
  String get stgSectionMetadataFields => 'METADATA FIELDS';

  @override
  String get stgSectionAdvancedAudio => 'ADVANCED AUDIO';

  @override
  String get stgEqualizer => 'Equalizer';

  @override
  String get stgEqualizerDesc => 'Calibration assistant + expert 10-band EQ';

  @override
  String get stgMetadataFieldsDesc =>
      'Configure extended fields (composer, conductor…)';

  @override
  String get stgSpotifyConnectDesc =>
      'Tune as a receiver (Premium required on the client)';

  @override
  String get stgLastfmDesc => 'Scrobble your listening history';

  @override
  String get stgListenBrainzDesc => 'Scrobble to ListenBrainz';

  @override
  String get stgAutoFixMetadata => 'Auto-fix metadata';

  @override
  String get stgAutoFixMetadataDesc =>
      'Fill in missing genre, year, MBID via MusicBrainz';

  @override
  String get stgDatabase => 'Database';

  @override
  String get stgImportExport => 'Import / Export';

  @override
  String get stgSectionProfiles => 'PROFILES';

  @override
  String get stgSectionSystem => 'SYSTEM';

  @override
  String get stgServerConfig => 'Server configuration';

  @override
  String get stgServerConfigDesc => 'Music folders, scan, restart';

  @override
  String get stgNetworkDiagnostics => 'Network diagnostics';

  @override
  String get stgNetworkDiagnosticsDesc => 'Multicast, DNS, connectivity';

  @override
  String get stgConfiguration => 'Configuration';

  @override
  String get stgExportImport => 'Export / Import';

  @override
  String get stgPlugins => 'Plugins';

  @override
  String get stgPluginsDesc => 'Installed extensions';

  @override
  String get stgNetworkShares => 'Network shares (SMB)';

  @override
  String get stgNetworkSharesDesc => 'Discover and mount shares';

  @override
  String get stgSectionCloud => 'CLOUD';

  @override
  String get stgSectionHelp => 'HELP';

  @override
  String get stgTroubleshooting => 'Troubleshooting';

  @override
  String get stgTroubleshootingDesc =>
      'Frequently asked questions and solutions';

  @override
  String get stgSendBugReport => 'Send a bug report';

  @override
  String get stgSendBugReportDesc => 'Generate and copy a technical report';

  @override
  String get stgServerAddressHint => 'IP or hostname (e.g. 192.168.1.18)';

  @override
  String get stgServerPort => 'Server port';

  @override
  String get stgPortDefaultHint => 'Port (default: 8888)';

  @override
  String get stgWarnNoZones =>
      'No zone configured. Create one to start playback.';

  @override
  String get stgWarnNoNetworkDevices =>
      'No network device detected (DLNA/BluOS/Chromecast).';

  @override
  String get stgSectionAudio => 'AUDIO';

  @override
  String get stgAudioOutputs => 'Audio outputs';

  @override
  String stgOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count detected',
      one: '1 detected',
    );
    return '$_temp0';
  }

  @override
  String get stgNetworkDevices => 'Network devices';

  @override
  String get stgZoneNameHint => 'e.g. Living room, Office';

  @override
  String get stgProfileActivated => 'Profile activated';

  @override
  String get stgNewProfile => 'New profile';

  @override
  String get stgProfileName => 'Profile name';

  @override
  String get stgProfileNameHint => 'e.g. Evening, Morning';

  @override
  String get stgProfileUpdated => 'Profile updated';

  @override
  String get stgNoProfiles => 'No profiles';

  @override
  String get stgProfile => 'Profile';

  @override
  String get stgEditProfile => 'Edit profile';

  @override
  String get stgName => 'Name';

  @override
  String get stgColor => 'Color';

  @override
  String get stgScanInProgress => 'Scanning the network…';

  @override
  String stgScanChecking(int scanned, int total) {
    return 'Checking $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'No Tune server found';

  @override
  String stgServersFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servers found',
      one: '1 server found',
    );
    return '$_temp0';
  }

  @override
  String get stgTuneServers => 'Tune servers';

  @override
  String get stgFieldFormat => 'Format (FLAC, MP3…)';

  @override
  String get stgFieldSampleRate => 'Sample rate (96 kHz)';

  @override
  String get stgFieldBitDepth => 'Bit depth (24-bit)';

  @override
  String get stgFieldLabel => 'Label';

  @override
  String get stgFieldComposer => 'Composer';

  @override
  String get stgFieldDuration => 'Duration';

  @override
  String get stgFieldSource => 'Source (Tidal, Qobuz…)';

  @override
  String get stgMetadataFieldsIntro =>
      'Fields shown under each track (search, library, queue, history)';

  @override
  String get stgAudiophileMode => 'Audiophile mode';

  @override
  String get stgAudiophileModeDesc => 'DSP bypass, EQ disabled, bit-perfect';

  @override
  String get stgCloudAccount => 'Cloud account';

  @override
  String stgConnectedAs(String email) {
    return 'Connected ($email)';
  }

  @override
  String get stgTelemetry => 'Telemetry';

  @override
  String get stgTelemetryDesc => 'Send anonymous usage statistics';

  @override
  String get stgSyncingLibrary => 'Syncing library…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total tracks';
  }

  @override
  String get stgConnectingStreaming => 'Connecting to streaming services…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'New in v$version';
  }

  @override
  String get stgWhatsNewLibrarySync => 'Improved library sync';

  @override
  String get stgWhatsNewMultiRoom => 'Optimized multi-room and zone management';

  @override
  String get stgWhatsNewBugFixes => 'Bug fixes and stability improvements';

  @override
  String get stgStartServerFailed => 'Failed to start the server';

  @override
  String stgStartServerFailedWith(String detail) {
    return 'Failed to start the server: $detail';
  }

  @override
  String get stgConnectionFailed => 'Connection failed';

  @override
  String stgConnectionFailedWith(String detail) {
    return 'Connection failed: $detail';
  }

  @override
  String get stgStartingServer => 'Starting Tune Server…';

  @override
  String get stgTagline => 'Multi-room music server';

  @override
  String get stgLocalServer => 'Local server';

  @override
  String get stgLocalServerDesc =>
      'Run Tune on this device.\nYour music, your rules.';

  @override
  String get stgRemoteControl => 'Remote control';

  @override
  String get stgRemoteControlDesc =>
      'Connect to a Tune server\non your network.';

  @override
  String get stgRemoteConnection => 'Remote connection';

  @override
  String get znZoneManagerTitle => 'Zone Manager';

  @override
  String get znCannotDeleteLastZone => 'The last zone cannot be deleted';

  @override
  String znZoneSwitchError(String error) {
    return 'Could not switch zone: $error';
  }

  @override
  String get znZoneSettings => 'Zone settings';

  @override
  String get znPhoneSpeakers => 'Phone speakers';

  @override
  String get znBtConnectedOutputs => 'Connected Bluetooth outputs';

  @override
  String get znBtSystemOutput => 'Uses the system output (Control Center)';

  @override
  String get znBtOutputsTitle => 'Bluetooth outputs';

  @override
  String get znBtNoDevice =>
      'No Bluetooth device connected. Pair a device in the system settings.';

  @override
  String get znBtAndroidRouting =>
      'Active routing depends on the Android system settings.';

  @override
  String get znDsdMode => 'DSD mode';

  @override
  String get znDsdAuto => 'Auto';

  @override
  String get znDsdNative => 'Native';

  @override
  String get znGaplessDlnaDesc => 'Seamless transitions between tracks (DLNA)';

  @override
  String get znFixedVolume => 'Fixed volume';

  @override
  String get znFixedVolumeDesc => 'Disables software volume control';

  @override
  String get znCap16Bit => 'Limit to 16 bits';

  @override
  String get znCap16BitDesc =>
      'Turn on if hi-res (24-bit) stays silent while 16-bit plays (Ruark R3). Converts to 16-bit FLAC.';

  @override
  String get znZoneMuted => 'Zone muted';

  @override
  String get znZoneUnmuted => 'Zone unmuted';

  @override
  String znErrMute(String error) {
    return 'Mute error: $error';
  }

  @override
  String znErrVolume(String error) {
    return 'Volume error: $error';
  }

  @override
  String znErrLatency(String error) {
    return 'Latency error: $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return 'Group volume error: $error';
  }

  @override
  String get znCalibrationDone => 'Calibration complete';

  @override
  String znErrCalibration(String error) {
    return 'Calibration error: $error';
  }

  @override
  String znErrDissolve(String error) {
    return 'Could not dissolve group: $error';
  }

  @override
  String get znRenameGroupTitle => 'Rename group';

  @override
  String get znNewNameHint => 'New name';

  @override
  String get znRename => 'Rename';

  @override
  String get znGroupRenamed => 'Group renamed';

  @override
  String znErrRename(String error) {
    return 'Rename error: $error';
  }

  @override
  String get znGroupNeedTwoZones =>
      'At least 2 zones are needed to create a group';

  @override
  String get znGroupNameLabel => 'Group name';

  @override
  String get znGroupNameHint => 'e.g. Living room + Kitchen';

  @override
  String get znChooseLeader => 'Choose the leader';

  @override
  String get znMembers => 'Members';

  @override
  String znErrCreateGroup(String error) {
    return 'Could not create group: $error';
  }

  @override
  String get znProfileActivated => 'Profile activated';

  @override
  String znErrActivate(String error) {
    return 'Activation error: $error';
  }

  @override
  String get znProfileDeleted => 'Profile deleted';

  @override
  String znErrDelete(String error) {
    return 'Delete error: $error';
  }

  @override
  String get znNoOfflineZones => 'No offline zones to remove';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offline zones removed',
      one: '1 offline zone removed',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return 'Cleanup error: $error';
  }

  @override
  String get znSaveConfigTitle => 'Save configuration';

  @override
  String get znProfileNameLabel => 'Profile name';

  @override
  String get znProfileNameHint => 'e.g. Party, Quiet morning';

  @override
  String get znDescriptionOptional => 'Description (optional)';

  @override
  String get znNameRequired => 'A name is required';

  @override
  String get znProfileSaved => 'Profile saved';

  @override
  String znErrSave(String error) {
    return 'Save error: $error';
  }

  @override
  String get znCleanupOffline => 'Clean up offline zones';

  @override
  String get znRemoteRequired =>
      'Zone Manager requires a connection to a remote server.';

  @override
  String get znDataUnavailable => 'Data unavailable';

  @override
  String get znGroups => 'Groups';

  @override
  String get znNoGroups => 'No groups';

  @override
  String get znGroupFallback => 'Group';

  @override
  String znZoneFallback(String id) {
    return 'Zone $id';
  }

  @override
  String get znCalibrate => 'Calibrate';

  @override
  String get znDissolve => 'Dissolve';

  @override
  String get znProfiles => 'Profiles';

  @override
  String get znNoProfiles => 'No saved profiles';

  @override
  String get znSaveConfigButton => 'Save config';

  @override
  String get znProfileFallback => 'Profile';

  @override
  String get znPins => 'Pins';

  @override
  String znPinFallback(int n) {
    return 'Pin $n';
  }

  @override
  String znPinInvoked(int n) {
    return 'Pin $n launched';
  }

  @override
  String znPinInvokeError(String error) {
    return 'Could not launch pin: $error';
  }

  @override
  String get znNoPins => 'No pins configured';

  @override
  String get znMute => 'Mute';

  @override
  String get znUnmute => 'Unmute';

  @override
  String get znLatency => 'Latency';

  @override
  String get znLatencyError => 'error';

  @override
  String znPartyAddError(String error) {
    return 'Could not add track: $error';
  }

  @override
  String znPartyVoteError(String error) {
    return 'Vote error: $error';
  }

  @override
  String get znPartyLinkCopied => 'Party link copied to clipboard';

  @override
  String get znPartyTitle => 'Party Mode';

  @override
  String get znPartyShareLink => 'Share party link';

  @override
  String get znPartyAddHint => 'Add a track…';

  @override
  String get znPartyQueue => 'Queue';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '1 track',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => 'Unknown zone';

  @override
  String get znUnknownTitle => 'Unknown';

  @override
  String get znNowPlaying => 'Now playing';

  @override
  String get znUpvote => 'Upvote';

  @override
  String znDjLoadOnDeck(String deck) {
    return 'Load track on deck $deck';
  }

  @override
  String get znDjSearchHint => 'Search tracks…';

  @override
  String get znDjSearchHelp => 'Enter a track name, then tap Search & load';

  @override
  String get znDjNoTracksFound => 'No tracks found';

  @override
  String znDjSearchError(String error) {
    return 'Search error: $error';
  }

  @override
  String get znDjSearchAndLoad => 'Search & load';

  @override
  String znDjLoadError(String error) {
    return 'Load error: $error';
  }

  @override
  String znDjPlayError(String error) {
    return 'Playback error: $error';
  }

  @override
  String znDjPauseError(String error) {
    return 'Pause error: $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return 'Crossfade error: $error';
  }

  @override
  String get znDjTitle => 'DJ Mode';

  @override
  String get znDjDisabled => 'DJ Mode is off';

  @override
  String get znDjEnableHint => 'Turn it on to start mixing';

  @override
  String znDjDeck(String deck) {
    return 'Deck $deck';
  }

  @override
  String get znDjCrossfade => 'Crossfade';

  @override
  String znDjDuration(String seconds) {
    return 'Duration: $seconds s';
  }

  @override
  String get znDjStartCrossfade => 'Start crossfade';

  @override
  String get znDjAutoCrossfade => 'Auto crossfade';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return 'Sync $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => 'Sync failed';

  @override
  String get znDjNoTrackLoaded => 'No track loaded';

  @override
  String get znDjLoadTrack => 'Load track';

  @override
  String get znDjGain => 'Gain';

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
