import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tune Server'**
  String get appTitle;

  /// No description provided for @btnOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get btnOk;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btnAdd;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @btnDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btnDelete;

  /// No description provided for @btnEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get btnEdit;

  /// No description provided for @btnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// No description provided for @btnRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get btnRetry;

  /// No description provided for @btnCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get btnCreate;

  /// No description provided for @btnClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get btnClear;

  /// No description provided for @btnNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get btnNext;

  /// No description provided for @btnSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip this step'**
  String get btnSkip;

  /// No description provided for @btnFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish configuration'**
  String get btnFinish;

  /// No description provided for @btnStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get btnStart;

  /// No description provided for @btnConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get btnConnect;

  /// No description provided for @btnDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get btnDisconnect;

  /// No description provided for @btnDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get btnDownload;

  /// No description provided for @btnImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get btnImport;

  /// No description provided for @btnExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get btnExport;

  /// No description provided for @btnReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get btnReset;

  /// No description provided for @btnUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get btnUse;

  /// No description provided for @btnShuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get btnShuffle;

  /// No description provided for @btnSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get btnSeeAll;

  /// No description provided for @btnRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get btnRefresh;

  /// No description provided for @btnScan.
  ///
  /// In en, this message translates to:
  /// **'Scan library'**
  String get btnScan;

  /// No description provided for @btnAddFolder.
  ///
  /// In en, this message translates to:
  /// **'Add a folder'**
  String get btnAddFolder;

  /// No description provided for @actionIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible.'**
  String get actionIrreversible;

  /// No description provided for @rootStartError.
  ///
  /// In en, this message translates to:
  /// **'Startup error'**
  String get rootStartError;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navStreaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get navStreaming;

  /// No description provided for @navRadios.
  ///
  /// In en, this message translates to:
  /// **'Radios'**
  String get navRadios;

  /// No description provided for @navZones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get navZones;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @tabAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get tabAlbums;

  /// No description provided for @tabArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get tabArtists;

  /// No description provided for @tabTracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get tabTracks;

  /// No description provided for @tabGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get tabGenres;

  /// No description provided for @tabPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get tabPlaylists;

  /// No description provided for @tabAppleMusic.
  ///
  /// In en, this message translates to:
  /// **'Apple Music'**
  String get tabAppleMusic;

  /// No description provided for @libraryEmptyAlbums.
  ///
  /// In en, this message translates to:
  /// **'No albums in library'**
  String get libraryEmptyAlbums;

  /// No description provided for @libraryEmptyArtists.
  ///
  /// In en, this message translates to:
  /// **'No artists in library'**
  String get libraryEmptyArtists;

  /// No description provided for @libraryEmptyTracks.
  ///
  /// In en, this message translates to:
  /// **'No tracks in library'**
  String get libraryEmptyTracks;

  /// No description provided for @libraryEmptyGenres.
  ///
  /// In en, this message translates to:
  /// **'No genres'**
  String get libraryEmptyGenres;

  /// No description provided for @libraryEmptyPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No playlists'**
  String get libraryEmptyPlaylists;

  /// No description provided for @libraryPlayAll.
  ///
  /// In en, this message translates to:
  /// **'Play all'**
  String get libraryPlayAll;

  /// No description provided for @libraryAddTo.
  ///
  /// In en, this message translates to:
  /// **'Add to...'**
  String get libraryAddTo;

  /// No description provided for @libraryEditAlbum.
  ///
  /// In en, this message translates to:
  /// **'Edit album'**
  String get libraryEditAlbum;

  /// No description provided for @libraryEditTrack.
  ///
  /// In en, this message translates to:
  /// **'Edit track'**
  String get libraryEditTrack;

  /// No description provided for @libraryPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get libraryPlay;

  /// No description provided for @genresAllTracks.
  ///
  /// In en, this message translates to:
  /// **'All tracks'**
  String get genresAllTracks;

  /// No description provided for @playlistCreate.
  ///
  /// In en, this message translates to:
  /// **'Create playlist'**
  String get playlistCreate;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistName;

  /// No description provided for @playlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tracks'**
  String get playlistEmpty;

  /// No description provided for @playlistAddTo.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get playlistAddTo;

  /// No description provided for @playlistNewPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get playlistNewPlaylist;

  /// No description provided for @playlistDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist?'**
  String get playlistDeleteTitle;

  /// No description provided for @playlistDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This playlist will be permanently deleted.'**
  String get playlistDeleteBody;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get searchHint;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get searchNoResults;

  /// No description provided for @searchSectionTracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get searchSectionTracks;

  /// No description provided for @searchSectionAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get searchSectionAlbums;

  /// No description provided for @searchSectionArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get searchSectionArtists;

  /// No description provided for @searchSectionStreaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get searchSectionStreaming;

  /// No description provided for @homeRecentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Recently played'**
  String get homeRecentlyPlayed;

  /// No description provided for @homeLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get homeLibrary;

  /// No description provided for @homeQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get homeQuickAccess;

  /// No description provided for @homeHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get homeHistory;

  /// No description provided for @homeBrowseDlna.
  ///
  /// In en, this message translates to:
  /// **'Browse DLNA'**
  String get homeBrowseDlna;

  /// No description provided for @homeStatTracks.
  ///
  /// In en, this message translates to:
  /// **'tracks'**
  String get homeStatTracks;

  /// No description provided for @homeStatAlbums.
  ///
  /// In en, this message translates to:
  /// **'albums'**
  String get homeStatAlbums;

  /// No description provided for @homeStatArtists.
  ///
  /// In en, this message translates to:
  /// **'artists'**
  String get homeStatArtists;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history'**
  String get historyEmpty;

  /// No description provided for @historyClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get historyClear;

  /// No description provided for @historyClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get historyClearTitle;

  /// No description provided for @nowPlayingNoTrack.
  ///
  /// In en, this message translates to:
  /// **'No track'**
  String get nowPlayingNoTrack;

  /// No description provided for @queueTitle.
  ///
  /// In en, this message translates to:
  /// **'Playback queue'**
  String get queueTitle;

  /// No description provided for @queueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty queue'**
  String get queueEmpty;

  /// No description provided for @zonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get zonesTitle;

  /// No description provided for @zonesNew.
  ///
  /// In en, this message translates to:
  /// **'New zone'**
  String get zonesNew;

  /// No description provided for @zonesNewName.
  ///
  /// In en, this message translates to:
  /// **'Zone name'**
  String get zonesNewName;

  /// No description provided for @zonesNone.
  ///
  /// In en, this message translates to:
  /// **'No zones'**
  String get zonesNone;

  /// No description provided for @zonesRename.
  ///
  /// In en, this message translates to:
  /// **'Rename zone'**
  String get zonesRename;

  /// No description provided for @zonesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete zone'**
  String get zonesDelete;

  /// No description provided for @zonesDevices.
  ///
  /// In en, this message translates to:
  /// **'Available devices'**
  String get zonesDevices;

  /// No description provided for @zonesOutputLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get zonesOutputLocal;

  /// No description provided for @zonesOutputDlna.
  ///
  /// In en, this message translates to:
  /// **'DLNA / UPnP'**
  String get zonesOutputDlna;

  /// No description provided for @zonesOutputAirplay.
  ///
  /// In en, this message translates to:
  /// **'AirPlay'**
  String get zonesOutputAirplay;

  /// No description provided for @zonesOutputBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get zonesOutputBluetooth;

  /// No description provided for @zonesChangeOutput.
  ///
  /// In en, this message translates to:
  /// **'Change output'**
  String get zonesChangeOutput;

  /// No description provided for @zonesOutputTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio output'**
  String get zonesOutputTitle;

  /// No description provided for @zonesAssignDevice.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get zonesAssignDevice;

  /// No description provided for @zonesTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Play on...'**
  String get zonesTransferTitle;

  /// No description provided for @zonesNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing here'**
  String get zonesNowPlaying;

  /// No description provided for @zonesActivated.
  ///
  /// In en, this message translates to:
  /// **'Active zone: {name}'**
  String zonesActivated(String name);

  /// No description provided for @radiosTitle.
  ///
  /// In en, this message translates to:
  /// **'Radios'**
  String get radiosTitle;

  /// No description provided for @radiosTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get radiosTabAll;

  /// No description provided for @radiosTabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get radiosTabFavorites;

  /// No description provided for @radiosNone.
  ///
  /// In en, this message translates to:
  /// **'No radios'**
  String get radiosNone;

  /// No description provided for @radiosFavNone.
  ///
  /// In en, this message translates to:
  /// **'No favorite radios'**
  String get radiosFavNone;

  /// No description provided for @radiosSavedFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved favorites'**
  String get radiosSavedFavorites;

  /// No description provided for @radiosAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a radio'**
  String get radiosAdd;

  /// No description provided for @radiosName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get radiosName;

  /// No description provided for @radiosStreamUrl.
  ///
  /// In en, this message translates to:
  /// **'Stream URL'**
  String get radiosStreamUrl;

  /// No description provided for @radiosGenre.
  ///
  /// In en, this message translates to:
  /// **'Genre (optional)'**
  String get radiosGenre;

  /// No description provided for @radiosPasteM3u.
  ///
  /// In en, this message translates to:
  /// **'Paste M3U'**
  String get radiosPasteM3u;

  /// No description provided for @radiosImportUrl.
  ///
  /// In en, this message translates to:
  /// **'Import from URL'**
  String get radiosImportUrl;

  /// No description provided for @radiosImportUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'M3U file URL'**
  String get radiosImportUrlLabel;

  /// No description provided for @radiosImportResult.
  ///
  /// In en, this message translates to:
  /// **'{count} station(s) imported'**
  String radiosImportResult(int count);

  /// No description provided for @radiosImportHttpError.
  ///
  /// In en, this message translates to:
  /// **'HTTP error {code}'**
  String radiosImportHttpError(int code);

  /// No description provided for @radiosImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download the file'**
  String get radiosImportFailed;

  /// No description provided for @radiosFavSaved.
  ///
  /// In en, this message translates to:
  /// **'Track saved'**
  String get radiosFavSaved;

  /// No description provided for @radioSaveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Save track'**
  String get radioSaveFavorite;

  /// No description provided for @radioFavTitle.
  ///
  /// In en, this message translates to:
  /// **'Radio favorites'**
  String get radioFavTitle;

  /// No description provided for @radioFavEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved favorites'**
  String get radioFavEmpty;

  /// No description provided for @radioFavExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get radioFavExportCsv;

  /// No description provided for @streamingTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streamingTitle;

  /// No description provided for @streamingConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get streamingConnected;

  /// No description provided for @streamingNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get streamingNotConnected;

  /// No description provided for @streamingEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get streamingEmail;

  /// No description provided for @streamingPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get streamingPassword;

  /// No description provided for @streamingSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get streamingSignIn;

  /// No description provided for @streamingSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get streamingSigningIn;

  /// No description provided for @streamingDeviceCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get streamingDeviceCode;

  /// No description provided for @streamingOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open…'**
  String get streamingOpenLink;

  /// No description provided for @streamingLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect?'**
  String get streamingLogoutTitle;

  /// No description provided for @streamingLogoutBody.
  ///
  /// In en, this message translates to:
  /// **'Disconnect from {service}?'**
  String streamingLogoutBody(String service);

  /// No description provided for @streamingAuthError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get streamingAuthError;

  /// No description provided for @streamingAlbumsSection.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get streamingAlbumsSection;

  /// No description provided for @streamingPlaylistsSection.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get streamingPlaylistsSection;

  /// No description provided for @browseTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browseTitle;

  /// No description provided for @browseRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get browseRefreshTooltip;

  /// No description provided for @browseNoServers.
  ///
  /// In en, this message translates to:
  /// **'No UPnP/DLNA servers detected'**
  String get browseNoServers;

  /// No description provided for @browseNoServersHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure your server is on the same Wi-Fi network.'**
  String get browseNoServersHint;

  /// No description provided for @browseNoContent.
  ///
  /// In en, this message translates to:
  /// **'Empty folder'**
  String get browseNoContent;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLangSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLangSystem;

  /// No description provided for @settingsSectionZones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get settingsSectionZones;

  /// No description provided for @settingsDefaultZone.
  ///
  /// In en, this message translates to:
  /// **'Default zone'**
  String get settingsDefaultZone;

  /// No description provided for @settingsDefaultZoneAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get settingsDefaultZoneAuto;

  /// No description provided for @settingsNoZones.
  ///
  /// In en, this message translates to:
  /// **'No zones'**
  String get settingsNoZones;

  /// No description provided for @settingsSectionServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get settingsSectionServer;

  /// No description provided for @settingsHttpPort.
  ///
  /// In en, this message translates to:
  /// **'HTTP port'**
  String get settingsHttpPort;

  /// No description provided for @settingsHttpPortDesc.
  ///
  /// In en, this message translates to:
  /// **'Main server port'**
  String get settingsHttpPortDesc;

  /// No description provided for @settingsLocalIp.
  ///
  /// In en, this message translates to:
  /// **'Local IP address'**
  String get settingsLocalIp;

  /// No description provided for @settingsSectionLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get settingsSectionLibrary;

  /// No description provided for @settingsMetadata.
  ///
  /// In en, this message translates to:
  /// **'Music & Metadata'**
  String get settingsMetadata;

  /// No description provided for @settingsMetadataDesc.
  ///
  /// In en, this message translates to:
  /// **'Folders, scan, statistics'**
  String get settingsMetadataDesc;

  /// No description provided for @settingsSetupWizard.
  ///
  /// In en, this message translates to:
  /// **'Setup wizard'**
  String get settingsSetupWizard;

  /// No description provided for @settingsSetupWizardDesc.
  ///
  /// In en, this message translates to:
  /// **'Reconfigure music sources'**
  String get settingsSetupWizardDesc;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 0.1.0'**
  String get settingsVersion;

  /// No description provided for @settingsResetConfig.
  ///
  /// In en, this message translates to:
  /// **'Reset configuration'**
  String get settingsResetConfig;

  /// No description provided for @settingsResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset?'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetBody.
  ///
  /// In en, this message translates to:
  /// **'All preferences will be reset. The startup wizard will appear on next launch.'**
  String get settingsResetBody;

  /// No description provided for @settingsPortTitle.
  ///
  /// In en, this message translates to:
  /// **'HTTP port'**
  String get settingsPortTitle;

  /// No description provided for @settingsPortHint.
  ///
  /// In en, this message translates to:
  /// **'Port (1024–65535)'**
  String get settingsPortHint;

  /// No description provided for @metadataTitle.
  ///
  /// In en, this message translates to:
  /// **'Music & Metadata'**
  String get metadataTitle;

  /// No description provided for @metadataRefreshStats.
  ///
  /// In en, this message translates to:
  /// **'Refresh stats'**
  String get metadataRefreshStats;

  /// No description provided for @metadataSectionStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get metadataSectionStats;

  /// No description provided for @metadataStatTracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get metadataStatTracks;

  /// No description provided for @metadataStatAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get metadataStatAlbums;

  /// No description provided for @metadataStatArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get metadataStatArtists;

  /// No description provided for @metadataStatPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get metadataStatPlaylists;

  /// No description provided for @metadataStatRadios.
  ///
  /// In en, this message translates to:
  /// **'Radios'**
  String get metadataStatRadios;

  /// No description provided for @metadataStatArtwork.
  ///
  /// In en, this message translates to:
  /// **'Artwork cache'**
  String get metadataStatArtwork;

  /// No description provided for @metadataSectionScan.
  ///
  /// In en, this message translates to:
  /// **'Library scan'**
  String get metadataSectionScan;

  /// No description provided for @metadataScanInProgress.
  ///
  /// In en, this message translates to:
  /// **'Scanning… {current}/{total}'**
  String metadataScanInProgress(int current, int total);

  /// No description provided for @metadataScanResult.
  ///
  /// In en, this message translates to:
  /// **'Last scan: +{added} added, {updated} updated'**
  String metadataScanResult(int added, int updated);

  /// No description provided for @metadataScanBtn.
  ///
  /// In en, this message translates to:
  /// **'Scan library'**
  String get metadataScanBtn;

  /// No description provided for @metadataScanDesc.
  ///
  /// In en, this message translates to:
  /// **'Indexes all configured folders'**
  String get metadataScanDesc;

  /// No description provided for @metadataSectionFolders.
  ///
  /// In en, this message translates to:
  /// **'Music folders'**
  String get metadataSectionFolders;

  /// No description provided for @metadataFoldersNone.
  ///
  /// In en, this message translates to:
  /// **'No folders configured'**
  String get metadataFoldersNone;

  /// No description provided for @metadataFolderAddedOn.
  ///
  /// In en, this message translates to:
  /// **'Added on {date}'**
  String metadataFolderAddedOn(String date);

  /// No description provided for @metadataAddFolder.
  ///
  /// In en, this message translates to:
  /// **'Add a folder'**
  String get metadataAddFolder;

  /// No description provided for @metadataFolderPath.
  ///
  /// In en, this message translates to:
  /// **'Folder path'**
  String get metadataFolderPath;

  /// No description provided for @metadataFolderHint.
  ///
  /// In en, this message translates to:
  /// **'/storage/emulated/0/Music'**
  String get metadataFolderHint;

  /// No description provided for @metadataSectionCleanup.
  ///
  /// In en, this message translates to:
  /// **'Cleanup'**
  String get metadataSectionCleanup;

  /// No description provided for @metadataCleanupOrphans.
  ///
  /// In en, this message translates to:
  /// **'Delete orphans'**
  String get metadataCleanupOrphans;

  /// No description provided for @metadataCleanupOrphansDesc.
  ///
  /// In en, this message translates to:
  /// **'Albums and artists with no tracks'**
  String get metadataCleanupOrphansDesc;

  /// No description provided for @metadataClearLibrary.
  ///
  /// In en, this message translates to:
  /// **'Clear library'**
  String get metadataClearLibrary;

  /// No description provided for @metadataClearLibraryDesc.
  ///
  /// In en, this message translates to:
  /// **'Deletes all local tracks'**
  String get metadataClearLibraryDesc;

  /// No description provided for @metadataCleanupOrphansTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete orphans?'**
  String get metadataCleanupOrphansTitle;

  /// No description provided for @metadataCleanupOrphansBody.
  ///
  /// In en, this message translates to:
  /// **'Albums and artists with no associated tracks will be deleted from the database.'**
  String get metadataCleanupOrphansBody;

  /// No description provided for @metadataClearLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear library?'**
  String get metadataClearLibraryTitle;

  /// No description provided for @metadataClearLibraryBody.
  ///
  /// In en, this message translates to:
  /// **'All local tracks, albums and artists will be deleted from the database. This action is irreversible.'**
  String get metadataClearLibraryBody;

  /// No description provided for @metadataOrphansDeleted.
  ///
  /// In en, this message translates to:
  /// **'Orphans deleted'**
  String get metadataOrphansDeleted;

  /// No description provided for @metadataLibraryCleared.
  ///
  /// In en, this message translates to:
  /// **'Library cleared'**
  String get metadataLibraryCleared;

  /// No description provided for @metadataDeleteBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get metadataDeleteBtn;

  /// No description provided for @metadataClearBtn.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get metadataClearBtn;

  /// No description provided for @setupWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nTune Server'**
  String get setupWelcomeTitle;

  /// No description provided for @setupWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your embedded multi-room music server. Stream your local library, your favorite streaming services and your radios to any DLNA or AirPlay speaker.'**
  String get setupWelcomeBody;

  /// No description provided for @setupStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get setupStart;

  /// No description provided for @setupLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Local library'**
  String get setupLocalTitle;

  /// No description provided for @setupLocalBody.
  ///
  /// In en, this message translates to:
  /// **'Specify the path of a folder containing your audio files (FLAC, MP3, AAC…). You can add more later in Settings.'**
  String get setupLocalBody;

  /// No description provided for @setupFolderPath.
  ///
  /// In en, this message translates to:
  /// **'Folder path'**
  String get setupFolderPath;

  /// No description provided for @setupFolderHint.
  ///
  /// In en, this message translates to:
  /// **'/storage/emulated/0/Music'**
  String get setupFolderHint;

  /// No description provided for @setupAddFolder.
  ///
  /// In en, this message translates to:
  /// **'Add this folder'**
  String get setupAddFolder;

  /// No description provided for @setupFolderAdded.
  ///
  /// In en, this message translates to:
  /// **'Folder added — scanning…'**
  String get setupFolderAdded;

  /// No description provided for @setupUPnPTitle.
  ///
  /// In en, this message translates to:
  /// **'UPnP/DLNA Servers'**
  String get setupUPnPTitle;

  /// No description provided for @setupUPnPBody.
  ///
  /// In en, this message translates to:
  /// **'Tune Server automatically discovers UPnP/DLNA servers on your local network. Browse their libraries via Search → Browse.'**
  String get setupUPnPBody;

  /// No description provided for @setupFeatureSsdp.
  ///
  /// In en, this message translates to:
  /// **'Automatic SSDP discovery'**
  String get setupFeatureSsdp;

  /// No description provided for @setupFeatureContentDir.
  ///
  /// In en, this message translates to:
  /// **'ContentDirectory navigation'**
  String get setupFeatureContentDir;

  /// No description provided for @setupFeaturePlayback.
  ///
  /// In en, this message translates to:
  /// **'Direct DLNA file playback'**
  String get setupFeaturePlayback;

  /// No description provided for @setupFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish configuration'**
  String get setupFinish;

  /// No description provided for @libraryPlayAlbum.
  ///
  /// In en, this message translates to:
  /// **'Play album'**
  String get libraryPlayAlbum;

  /// No description provided for @libraryPlayNext.
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get libraryPlayNext;

  /// No description provided for @radioFavExportDone.
  ///
  /// In en, this message translates to:
  /// **'CSV exported: {path}'**
  String radioFavExportDone(String path);

  /// No description provided for @radioFavExportError.
  ///
  /// In en, this message translates to:
  /// **'Export error'**
  String get radioFavExportError;

  /// No description provided for @streamingViewAlbum.
  ///
  /// In en, this message translates to:
  /// **'View album'**
  String get streamingViewAlbum;

  /// No description provided for @streamingLogoutContent.
  ///
  /// In en, this message translates to:
  /// **'Your account will be disconnected.'**
  String get streamingLogoutContent;

  /// No description provided for @streamingUrlCopied.
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get streamingUrlCopied;

  /// No description provided for @streamingDeviceCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Go to this URL and enter the code above:'**
  String get streamingDeviceCodeHint;

  /// No description provided for @searchHintFull.
  ///
  /// In en, this message translates to:
  /// **'Search artists, albums, tracks…'**
  String get searchHintFull;

  /// No description provided for @browseNavError.
  ///
  /// In en, this message translates to:
  /// **'Navigation error'**
  String get browseNavError;

  /// No description provided for @streamingCodeEntered.
  ///
  /// In en, this message translates to:
  /// **'I\'ve entered the code'**
  String get streamingCodeEntered;

  /// No description provided for @appleMusicAuthorize.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get appleMusicAuthorize;

  /// No description provided for @streamingConnectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connected!'**
  String get streamingConnectedSuccess;

  /// No description provided for @browseItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String browseItemCount(int count);

  /// No description provided for @settingsSources.
  ///
  /// In en, this message translates to:
  /// **'Sources & Devices'**
  String get settingsSources;

  /// No description provided for @settingsSourcesDesc.
  ///
  /// In en, this message translates to:
  /// **'UPnP servers, DLNA renderers'**
  String get settingsSourcesDesc;

  /// No description provided for @sourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sources & Devices'**
  String get sourcesTitle;

  /// No description provided for @sourcesServersSection.
  ///
  /// In en, this message translates to:
  /// **'UPnP Content Servers'**
  String get sourcesServersSection;

  /// No description provided for @sourcesRenderersSection.
  ///
  /// In en, this message translates to:
  /// **'DLNA Renderers'**
  String get sourcesRenderersSection;

  /// No description provided for @sourcesNoDevices.
  ///
  /// In en, this message translates to:
  /// **'No device discovered'**
  String get sourcesNoDevices;

  /// No description provided for @sourcesTypeServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get sourcesTypeServer;

  /// No description provided for @sourcesTypeRenderer.
  ///
  /// In en, this message translates to:
  /// **'Renderer'**
  String get sourcesTypeRenderer;

  /// No description provided for @sourcesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get sourcesAvailable;

  /// No description provided for @sourcesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get sourcesUnavailable;

  /// No description provided for @sourcesIndexBtn.
  ///
  /// In en, this message translates to:
  /// **'Index library'**
  String get sourcesIndexBtn;

  /// No description provided for @sourcesForget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get sourcesForget;

  /// No description provided for @sourcesAddManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get sourcesAddManually;

  /// No description provided for @sourcesAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual probe'**
  String get sourcesAddTitle;

  /// No description provided for @sourcesIpLabel.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get sourcesIpLabel;

  /// No description provided for @sourcesIpHint.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.100'**
  String get sourcesIpHint;

  /// No description provided for @sourcesPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get sourcesPortLabel;

  /// No description provided for @sourcesPortHint.
  ///
  /// In en, this message translates to:
  /// **'49152'**
  String get sourcesPortHint;

  /// No description provided for @sourcesProbing.
  ///
  /// In en, this message translates to:
  /// **'Probing…'**
  String get sourcesProbing;

  /// No description provided for @sourcesNotFound.
  ///
  /// In en, this message translates to:
  /// **'No UPnP device found at this address'**
  String get sourcesNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
