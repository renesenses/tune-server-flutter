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
  String get navLibrary => 'Library';

  @override
  String get navSearch => 'Search';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navRadios => 'Radios';

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
  String get tabGenres => 'Genres';

  @override
  String get tabPlaylists => 'Playlists';

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
  String get playlistDeleteTitle => 'Delete playlist?';

  @override
  String get playlistDeleteBody => 'This playlist will be permanently deleted.';

  @override
  String get searchHint => 'Search…';

  @override
  String get searchNoResults => 'No results';

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
  String get queueEmpty => 'Empty queue';

  @override
  String get zonesTitle => 'Zones';

  @override
  String get zonesNew => 'New zone';

  @override
  String get zonesNewName => 'Zone name';

  @override
  String get zonesNone => 'No zones';

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
  String get zonesOutputBluetooth => 'Bluetooth';

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
}
