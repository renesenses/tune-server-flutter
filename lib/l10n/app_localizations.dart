import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
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
    Locale('hu'),
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

  /// No description provided for @playbackErrorNoZone.
  ///
  /// In en, this message translates to:
  /// **'No zone selected — create or select a zone'**
  String get playbackErrorNoZone;

  /// No description provided for @playbackErrorZoneNotFound.
  ///
  /// In en, this message translates to:
  /// **'Zone not found'**
  String get playbackErrorZoneNotFound;

  /// No description provided for @playbackErrorFailed.
  ///
  /// In en, this message translates to:
  /// **'Playback failed'**
  String get playbackErrorFailed;

  /// No description provided for @zoneLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Free plan limited to {limit} zones — upgrade to Premium for unlimited'**
  String zoneLimitReached(int limit);

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

  /// No description provided for @albumTracksDuration.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks · {duration}'**
  String albumTracksDuration(int count, String duration);

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

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tabFavorites;

  /// No description provided for @favoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemoved;

  /// No description provided for @libraryEmptyFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get libraryEmptyFavorites;

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

  /// No description provided for @libraryNoFilterResults.
  ///
  /// In en, this message translates to:
  /// **'No albums match filters'**
  String get libraryNoFilterResults;

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

  /// No description provided for @playlistTrackAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to \"{name}\"'**
  String playlistTrackAdded(String name);

  /// No description provided for @playlistTrackAlreadyIn.
  ///
  /// In en, this message translates to:
  /// **'Already in \"{name}\"'**
  String playlistTrackAlreadyIn(String name);

  /// No description provided for @playlistTracksAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks added to \"{name}\"'**
  String playlistTracksAdded(int count, String name);

  /// No description provided for @playlistAddAllTracks.
  ///
  /// In en, this message translates to:
  /// **'Add all to playlist'**
  String get playlistAddAllTracks;

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

  /// No description provided for @searchTopResult.
  ///
  /// In en, this message translates to:
  /// **'Top result'**
  String get searchTopResult;

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

  /// No description provided for @queueUpNextSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} up next · {time}'**
  String queueUpNextSummary(int count, String time);

  /// No description provided for @queueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty queue'**
  String get queueEmpty;

  /// No description provided for @queueClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear queue?'**
  String get queueClearTitle;

  /// No description provided for @queueClearBody.
  ///
  /// In en, this message translates to:
  /// **'All tracks will be removed from the playback queue.'**
  String get queueClearBody;

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

  /// No description provided for @zonesAirplayPair.
  ///
  /// In en, this message translates to:
  /// **'Pair (PIN code)'**
  String get zonesAirplayPair;

  /// No description provided for @zonesAirplayPairTitle.
  ///
  /// In en, this message translates to:
  /// **'AirPlay pairing'**
  String get zonesAirplayPairTitle;

  /// No description provided for @zonesAirplayPairIntro.
  ///
  /// In en, this message translates to:
  /// **'Some TVs (Samsung, LG) and the Apple TV show a 4-digit code on screen. Start pairing, then enter the code.'**
  String get zonesAirplayPairIntro;

  /// No description provided for @zonesAirplayPairWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the code shown on the device…'**
  String get zonesAirplayPairWaiting;

  /// No description provided for @zonesAirplayPairEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code shown on the device:'**
  String get zonesAirplayPairEnterCode;

  /// No description provided for @zonesAirplayPairStart.
  ///
  /// In en, this message translates to:
  /// **'Start pairing'**
  String get zonesAirplayPairStart;

  /// No description provided for @zonesAirplayPairSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit code'**
  String get zonesAirplayPairSubmit;

  /// No description provided for @zonesAirplayPairRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get zonesAirplayPairRetry;

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

  /// No description provided for @setupFolderEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a folder path'**
  String get setupFolderEmpty;

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

  /// No description provided for @smbNavTitle.
  ///
  /// In en, this message translates to:
  /// **'SMB Source'**
  String get smbNavTitle;

  /// No description provided for @smbTitle.
  ///
  /// In en, this message translates to:
  /// **'SMB Connection'**
  String get smbTitle;

  /// No description provided for @smbHostHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the address of the SMB server'**
  String get smbHostHint;

  /// No description provided for @smbHostLabel.
  ///
  /// In en, this message translates to:
  /// **'IP Address (e.g. 192.168.1.23)'**
  String get smbHostLabel;

  /// No description provided for @smbUser.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get smbUser;

  /// No description provided for @smbPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get smbPassword;

  /// No description provided for @smbConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get smbConnect;

  /// No description provided for @smbSelectShare.
  ///
  /// In en, this message translates to:
  /// **'Select a share'**
  String get smbSelectShare;

  /// No description provided for @smbBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get smbBack;

  /// No description provided for @smbManualHint.
  ///
  /// In en, this message translates to:
  /// **'Unable to list shares automatically.\nEnter the share name manually:'**
  String get smbManualHint;

  /// No description provided for @smbShareName.
  ///
  /// In en, this message translates to:
  /// **'Share name (e.g. Share, Music)'**
  String get smbShareName;

  /// No description provided for @smbScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get smbScan;

  /// No description provided for @smbScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get smbScanning;

  /// No description provided for @smbScanCount.
  ///
  /// In en, this message translates to:
  /// **'{count} audio files found'**
  String smbScanCount(int count);

  /// No description provided for @smbDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Indexing complete'**
  String get smbDoneTitle;

  /// No description provided for @smbDoneBody.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks imported from {share}'**
  String smbDoneBody(int count, String share);

  /// No description provided for @smbAddAnother.
  ///
  /// In en, this message translates to:
  /// **'Add another share'**
  String get smbAddAnother;

  /// No description provided for @settingsSmb.
  ///
  /// In en, this message translates to:
  /// **'SMB / Samba Sources'**
  String get settingsSmb;

  /// No description provided for @settingsSmbDesc.
  ///
  /// In en, this message translates to:
  /// **'Index libraries from network shares'**
  String get settingsSmbDesc;

  /// No description provided for @podcastsTitle.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get podcastsTitle;

  /// No description provided for @podcastsTabRadioFrance.
  ///
  /// In en, this message translates to:
  /// **'Radio France'**
  String get podcastsTabRadioFrance;

  /// No description provided for @podcastsTabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get podcastsTabSearch;

  /// No description provided for @podcastsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No podcasts'**
  String get podcastsEmpty;

  /// No description provided for @podcastsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a podcast…'**
  String get podcastsSearchHint;

  /// No description provided for @podcastsNoEpisodes.
  ///
  /// In en, this message translates to:
  /// **'No episodes'**
  String get podcastsNoEpisodes;

  /// No description provided for @navPodcasts.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get navPodcasts;

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

  /// No description provided for @sourcesRescanBtn.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get sourcesRescanBtn;

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

  /// No description provided for @zonesMultiRoom.
  ///
  /// In en, this message translates to:
  /// **'Multi-Room'**
  String get zonesMultiRoom;

  /// No description provided for @zonesCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get zonesCreateGroup;

  /// No description provided for @zonesGroupLeader.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get zonesGroupLeader;

  /// No description provided for @zonesGroupFollower.
  ///
  /// In en, this message translates to:
  /// **'Follower'**
  String get zonesGroupFollower;

  /// No description provided for @zonesGroupDissolve.
  ///
  /// In en, this message translates to:
  /// **'Dissolve group'**
  String get zonesGroupDissolve;

  /// No description provided for @zonesGroupSyncDelay.
  ///
  /// In en, this message translates to:
  /// **'Sync delay'**
  String get zonesGroupSyncDelay;

  /// No description provided for @zonesGroupSyncDelayMs.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String zonesGroupSyncDelayMs(int ms);

  /// No description provided for @zonesGroupSelectZones.
  ///
  /// In en, this message translates to:
  /// **'Select zones'**
  String get zonesGroupSelectZones;

  /// No description provided for @zonesGroupSelectLeader.
  ///
  /// In en, this message translates to:
  /// **'Select leader'**
  String get zonesGroupSelectLeader;

  /// No description provided for @zonesGroupNoZones.
  ///
  /// In en, this message translates to:
  /// **'No active groups'**
  String get zonesGroupNoZones;

  /// No description provided for @zonesGroupNeedTwo.
  ///
  /// In en, this message translates to:
  /// **'Select at least 2 zones'**
  String get zonesGroupNeedTwo;

  /// No description provided for @zonesGroupCreated.
  ///
  /// In en, this message translates to:
  /// **'Group created'**
  String get zonesGroupCreated;

  /// No description provided for @zonesGroupDissolved.
  ///
  /// In en, this message translates to:
  /// **'Group dissolved'**
  String get zonesGroupDissolved;

  /// No description provided for @metadataSectionEnrich.
  ///
  /// In en, this message translates to:
  /// **'Enrich'**
  String get metadataSectionEnrich;

  /// No description provided for @metadataSectionDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get metadataSectionDuplicates;

  /// No description provided for @metadataSectionCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get metadataSectionCorrect;

  /// No description provided for @metadataFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get metadataFilterAll;

  /// No description provided for @metadataFilterMissingCover.
  ///
  /// In en, this message translates to:
  /// **'Missing covers'**
  String get metadataFilterMissingCover;

  /// No description provided for @metadataFilterMissingGenre.
  ///
  /// In en, this message translates to:
  /// **'Missing genre'**
  String get metadataFilterMissingGenre;

  /// No description provided for @metadataFilterMissingYear.
  ///
  /// In en, this message translates to:
  /// **'Missing year'**
  String get metadataFilterMissingYear;

  /// No description provided for @metadataFilterMissingArtist.
  ///
  /// In en, this message translates to:
  /// **'Missing artist'**
  String get metadataFilterMissingArtist;

  /// No description provided for @metadataFilterDoubtful.
  ///
  /// In en, this message translates to:
  /// **'Doubtful'**
  String get metadataFilterDoubtful;

  /// No description provided for @metadataSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search albums…'**
  String get metadataSearchHint;

  /// No description provided for @metadataArtistFilter.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get metadataArtistFilter;

  /// No description provided for @metadataGenreFilter.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get metadataGenreFilter;

  /// No description provided for @metadataAllArtists.
  ///
  /// In en, this message translates to:
  /// **'All artists'**
  String get metadataAllArtists;

  /// No description provided for @metadataAllGenres.
  ///
  /// In en, this message translates to:
  /// **'All genres'**
  String get metadataAllGenres;

  /// No description provided for @metadataNoAlbums.
  ///
  /// In en, this message translates to:
  /// **'No albums match'**
  String get metadataNoAlbums;

  /// No description provided for @metadataEditAlbum.
  ///
  /// In en, this message translates to:
  /// **'Edit album'**
  String get metadataEditAlbum;

  /// No description provided for @metadataSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get metadataSaveChanges;

  /// No description provided for @metadataWriteTags.
  ///
  /// In en, this message translates to:
  /// **'Write Tags'**
  String get metadataWriteTags;

  /// No description provided for @metadataWriteTagsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tags written: {count} files'**
  String metadataWriteTagsSuccess(int count);

  /// No description provided for @metadataMergeGroup.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get metadataMergeGroup;

  /// No description provided for @metadataMergeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Merge these {count} albums into one? The album with the most tracks will be kept.'**
  String metadataMergeConfirm(int count);

  /// No description provided for @metadataMergeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Merged: {moved} tracks moved, {total} total'**
  String metadataMergeSuccess(int moved, int total);

  /// No description provided for @metadataUploadCover.
  ///
  /// In en, this message translates to:
  /// **'Upload cover'**
  String get metadataUploadCover;

  /// No description provided for @metadataCoverUploaded.
  ///
  /// In en, this message translates to:
  /// **'Cover uploaded'**
  String get metadataCoverUploaded;

  /// No description provided for @metadataAlbumSaved.
  ///
  /// In en, this message translates to:
  /// **'Album saved'**
  String get metadataAlbumSaved;

  /// No description provided for @metadataDupAlbums.
  ///
  /// In en, this message translates to:
  /// **'{count} duplicate albums'**
  String metadataDupAlbums(int count);

  /// No description provided for @metadataDoubtfulReasons.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get metadataDoubtfulReasons;

  /// No description provided for @metadataArtistField.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get metadataArtistField;

  /// No description provided for @metadataAlbumField.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get metadataAlbumField;

  /// No description provided for @metadataGenreField.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get metadataGenreField;

  /// No description provided for @metadataYearField.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get metadataYearField;

  /// No description provided for @metadataTracksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks'**
  String metadataTracksCount(int count);

  /// No description provided for @stereoPairsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stereo Pairs'**
  String get stereoPairsTitle;

  /// No description provided for @stereoPairCreate.
  ///
  /// In en, this message translates to:
  /// **'Create stereo pair'**
  String get stereoPairCreate;

  /// No description provided for @stereoPairName.
  ///
  /// In en, this message translates to:
  /// **'Pair name'**
  String get stereoPairName;

  /// No description provided for @stereoPairNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Living Room Stereo'**
  String get stereoPairNameHint;

  /// No description provided for @stereoPairLeft.
  ///
  /// In en, this message translates to:
  /// **'Left (L)'**
  String get stereoPairLeft;

  /// No description provided for @stereoPairRight.
  ///
  /// In en, this message translates to:
  /// **'Right (R)'**
  String get stereoPairRight;

  /// No description provided for @stereoPairSelectDevice.
  ///
  /// In en, this message translates to:
  /// **'Select a device'**
  String get stereoPairSelectDevice;

  /// No description provided for @stereoPairNone.
  ///
  /// In en, this message translates to:
  /// **'No stereo pairs'**
  String get stereoPairNone;

  /// No description provided for @stereoPairCreated.
  ///
  /// In en, this message translates to:
  /// **'Stereo pair created'**
  String get stereoPairCreated;

  /// No description provided for @stereoPairDissolved.
  ///
  /// In en, this message translates to:
  /// **'Stereo pair dissolved'**
  String get stereoPairDissolved;

  /// No description provided for @stereoPairDissolve.
  ///
  /// In en, this message translates to:
  /// **'Dissolve'**
  String get stereoPairDissolve;

  /// No description provided for @stereoPairBadgeL.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get stereoPairBadgeL;

  /// No description provided for @stereoPairBadgeR.
  ///
  /// In en, this message translates to:
  /// **'R'**
  String get stereoPairBadgeR;

  /// No description provided for @streamingEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get streamingEnable;

  /// No description provided for @streamingDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get streamingDisable;

  /// No description provided for @streamingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Service enabled'**
  String get streamingEnabled;

  /// No description provided for @streamingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Service disabled'**
  String get streamingDisabled;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tune!'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your embedded multi-room music server. Let\'s set up your installation in a few steps.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingWelcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingWelcomeStart;

  /// No description provided for @onboardingConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get onboardingConfigTitle;

  /// No description provided for @onboardingConfigBody.
  ///
  /// In en, this message translates to:
  /// **'Specify a folder containing your audio files, or connect to a remote Tune server.'**
  String get onboardingConfigBody;

  /// No description provided for @onboardingConfigModeLocal.
  ///
  /// In en, this message translates to:
  /// **'Embedded server'**
  String get onboardingConfigModeLocal;

  /// No description provided for @onboardingConfigModeRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote server'**
  String get onboardingConfigModeRemote;

  /// No description provided for @onboardingZoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a zone'**
  String get onboardingZoneTitle;

  /// No description provided for @onboardingZoneBody.
  ///
  /// In en, this message translates to:
  /// **'The devices below were discovered on your network. Tap one to create your first audio zone.'**
  String get onboardingZoneBody;

  /// No description provided for @onboardingZoneEmpty.
  ///
  /// In en, this message translates to:
  /// **'No devices discovered yet. You can add more later.'**
  String get onboardingZoneEmpty;

  /// No description provided for @onboardingZoneCreated.
  ///
  /// In en, this message translates to:
  /// **'Zone created: {name}'**
  String onboardingZoneCreated(String name);

  /// No description provided for @onboardingDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get onboardingDoneTitle;

  /// No description provided for @onboardingDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Your setup is ready. Enjoy your music!'**
  String get onboardingDoneBody;

  /// No description provided for @onboardingDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Go to dashboard'**
  String get onboardingDoneButton;

  /// No description provided for @artistBio.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get artistBio;

  /// No description provided for @artistAnecdotes.
  ///
  /// In en, this message translates to:
  /// **'Anecdotes'**
  String get artistAnecdotes;

  /// No description provided for @artistSimilarArtists.
  ///
  /// In en, this message translates to:
  /// **'Similar artists'**
  String get artistSimilarArtists;

  /// No description provided for @artistMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get artistMembers;

  /// No description provided for @artistDiscography.
  ///
  /// In en, this message translates to:
  /// **'Discography'**
  String get artistDiscography;

  /// No description provided for @artistEnriching.
  ///
  /// In en, this message translates to:
  /// **'Enrichment in progress…'**
  String get artistEnriching;

  /// No description provided for @artistGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get artistGenres;

  /// No description provided for @libraryShuffleAll.
  ///
  /// In en, this message translates to:
  /// **'Shuffle All'**
  String get libraryShuffleAll;

  /// No description provided for @librarySortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get librarySortBy;

  /// No description provided for @librarySortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get librarySortTitle;

  /// No description provided for @librarySortArtist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get librarySortArtist;

  /// No description provided for @librarySortYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get librarySortYear;

  /// No description provided for @librarySortOriginalYear.
  ///
  /// In en, this message translates to:
  /// **'Original Year'**
  String get librarySortOriginalYear;

  /// No description provided for @librarySortAddedDate.
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get librarySortAddedDate;

  /// No description provided for @librarySortAscending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get librarySortAscending;

  /// No description provided for @librarySortDescending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get librarySortDescending;

  /// No description provided for @addFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addFavorite;

  /// No description provided for @addFolder.
  ///
  /// In en, this message translates to:
  /// **'Add a folder'**
  String get addFolder;

  /// No description provided for @addThisFolder.
  ///
  /// In en, this message translates to:
  /// **'Add this folder'**
  String get addThisFolder;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to a playlist'**
  String get addToPlaylist;

  /// No description provided for @addedToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Added to playlist'**
  String get addedToPlaylist;

  /// No description provided for @audioOutput.
  ///
  /// In en, this message translates to:
  /// **'Audio output'**
  String get audioOutput;

  /// No description provided for @audioOutputDesc.
  ///
  /// In en, this message translates to:
  /// **'Each server zone is one output (local ALSA, Diretta renderer…). Pick the zone to play on.'**
  String get audioOutputDesc;

  /// No description provided for @authorizeInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Authorize access in your browser:'**
  String get authorizeInBrowser;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create a playlist'**
  String get createPlaylist;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist'**
  String get deletePlaylist;

  /// No description provided for @deletePlaylistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this playlist?'**
  String get deletePlaylistConfirm;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'I\'m done'**
  String get done;

  /// No description provided for @dynamicPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Dynamic playlists'**
  String get dynamicPlaylists;

  /// No description provided for @dynamicTag.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get dynamicTag;

  /// No description provided for @errorWith.
  ///
  /// In en, this message translates to:
  /// **'Error: {msg}'**
  String errorWith(String msg);

  /// No description provided for @favError.
  ///
  /// In en, this message translates to:
  /// **'Favorite failed: {msg}'**
  String favError(String msg);

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @freqLimit.
  ///
  /// In en, this message translates to:
  /// **'Frequency limit'**
  String get freqLimit;

  /// No description provided for @gapless.
  ///
  /// In en, this message translates to:
  /// **'Gapless playback'**
  String get gapless;

  /// No description provided for @gaplessDesc.
  ///
  /// In en, this message translates to:
  /// **'Disable if you hear white noise / glitches between tracks on this renderer.'**
  String get gaplessDesc;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @localLibrary.
  ///
  /// In en, this message translates to:
  /// **'Local library'**
  String get localLibrary;

  /// No description provided for @localLibraryDesc.
  ///
  /// In en, this message translates to:
  /// **'Folders the server scans for music'**
  String get localLibraryDesc;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @loginTo.
  ///
  /// In en, this message translates to:
  /// **'Sign in to {service}'**
  String loginTo(String service);

  /// No description provided for @maxBitDepth.
  ///
  /// In en, this message translates to:
  /// **'Max bit depth'**
  String get maxBitDepth;

  /// No description provided for @maxFrequency.
  ///
  /// In en, this message translates to:
  /// **'Max frequency'**
  String get maxFrequency;

  /// No description provided for @maxTracks.
  ///
  /// In en, this message translates to:
  /// **'max {n}'**
  String maxTracks(int n);

  /// No description provided for @metadataFields.
  ///
  /// In en, this message translates to:
  /// **'Metadata fields'**
  String get metadataFields;

  /// No description provided for @metadataFieldsDesc.
  ///
  /// In en, this message translates to:
  /// **'Info shown for the local library'**
  String get metadataFieldsDesc;

  /// No description provided for @metadataSaved.
  ///
  /// In en, this message translates to:
  /// **'Metadata saved'**
  String get metadataSaved;

  /// No description provided for @musicFolders.
  ///
  /// In en, this message translates to:
  /// **'Scanned folders'**
  String get musicFolders;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get navPlaylists;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylist;

  /// No description provided for @noFavAlbums.
  ///
  /// In en, this message translates to:
  /// **'No favorite album'**
  String get noFavAlbums;

  /// No description provided for @noFavArtists.
  ///
  /// In en, this message translates to:
  /// **'No favorite artist'**
  String get noFavArtists;

  /// No description provided for @noFavTracks.
  ///
  /// In en, this message translates to:
  /// **'No favorite track'**
  String get noFavTracks;

  /// No description provided for @noFolders.
  ///
  /// In en, this message translates to:
  /// **'No folder configured'**
  String get noFolders;

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noLimit;

  /// No description provided for @noPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No playlist'**
  String get noPlaylists;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @noService.
  ///
  /// In en, this message translates to:
  /// **'No service'**
  String get noService;

  /// No description provided for @noTracks.
  ///
  /// In en, this message translates to:
  /// **'No tracks'**
  String get noTracks;

  /// No description provided for @noZones.
  ///
  /// In en, this message translates to:
  /// **'No zone available'**
  String get noZones;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Set up the server in Settings'**
  String get notConnected;

  /// No description provided for @nothingPlaying.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get nothingPlaying;

  /// No description provided for @openAuthPage.
  ///
  /// In en, this message translates to:
  /// **'Open the authorization page'**
  String get openAuthPage;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pickFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder'**
  String get pickFolder;

  /// No description provided for @playAll.
  ///
  /// In en, this message translates to:
  /// **'Play all'**
  String get playAll;

  /// No description provided for @playlistCreated.
  ///
  /// In en, this message translates to:
  /// **'Playlist created'**
  String get playlistCreated;

  /// No description provided for @playlistDeleted.
  ///
  /// In en, this message translates to:
  /// **'Playlist deleted'**
  String get playlistDeleted;

  /// No description provided for @playlistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlistsTitle;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @qualityCd.
  ///
  /// In en, this message translates to:
  /// **'CD (44.1 kHz / 16 bit)'**
  String get qualityCd;

  /// No description provided for @qualityHires.
  ///
  /// In en, this message translates to:
  /// **'Hi-Res (up to 192 kHz)'**
  String get qualityHires;

  /// No description provided for @qualityMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get qualityMax;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFavorite;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylist;

  /// No description provided for @runScan.
  ///
  /// In en, this message translates to:
  /// **'Scan library'**
  String get runScan;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get scanning;

  /// No description provided for @searchEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Qobuz · YouTube · your library'**
  String get searchEmptySub;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Search a title, an album or an artist'**
  String get searchEmptyTitle;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @sectionAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get sectionAlbums;

  /// No description provided for @sectionArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get sectionArtists;

  /// No description provided for @sectionPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get sectionPlaylists;

  /// No description provided for @sectionTracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get sectionTracks;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @sourceLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get sourceLibrary;

  /// No description provided for @streamingQuality.
  ///
  /// In en, this message translates to:
  /// **'Streaming quality'**
  String get streamingQuality;

  /// No description provided for @streamingQualityDesc.
  ///
  /// In en, this message translates to:
  /// **'Caps the frequency / resolution requested from services (Qobuz, Tidal…).'**
  String get streamingQualityDesc;

  /// No description provided for @streamingServices.
  ///
  /// In en, this message translates to:
  /// **'Streaming services'**
  String get streamingServices;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @trackRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from playlist'**
  String get trackRemoved;

  /// No description provided for @tracksCount.
  ///
  /// In en, this message translates to:
  /// **'{n} tracks'**
  String tracksCount(int n);

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @visualizer.
  ///
  /// In en, this message translates to:
  /// **'Visualizer'**
  String get visualizer;

  /// No description provided for @licenseSessionConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'License active on another server'**
  String get licenseSessionConflictTitle;

  /// No description provided for @licenseSessionConflictBody.
  ///
  /// In en, this message translates to:
  /// **'Your Tune license is already in use on another of your servers. This server will switch back to Premium automatically a few minutes after the other one stops.'**
  String get licenseSessionConflictBody;

  /// No description provided for @licenseSessionConflictBodyNamed.
  ///
  /// In en, this message translates to:
  /// **'Your Tune license is active on “{server}”. This server will switch back to Premium automatically a few minutes after the other one stops.'**
  String licenseSessionConflictBodyNamed(String server);

  /// No description provided for @cfgSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {detail}'**
  String cfgSaveError(String detail);

  /// No description provided for @cfgReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get cfgReload;

  /// No description provided for @cfgFieldsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load fields'**
  String get cfgFieldsLoadError;

  /// No description provided for @cfgFieldsNone.
  ///
  /// In en, this message translates to:
  /// **'No fields available'**
  String get cfgFieldsNone;

  /// No description provided for @cfgFieldsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose which metadata fields are shown in the track editor.'**
  String get cfgFieldsHint;

  /// No description provided for @cfgMetaCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Metadata completeness'**
  String get cfgMetaCompleteness;

  /// No description provided for @cfgMetaEnrichMusicBrainz.
  ///
  /// In en, this message translates to:
  /// **'Enrich with MusicBrainz'**
  String get cfgMetaEnrichMusicBrainz;

  /// No description provided for @cfgMetaEnrichMusicBrainzTask.
  ///
  /// In en, this message translates to:
  /// **'MusicBrainz enrichment'**
  String get cfgMetaEnrichMusicBrainzTask;

  /// No description provided for @cfgMetaFixYearsTidal.
  ///
  /// In en, this message translates to:
  /// **'Fix years (TIDAL)'**
  String get cfgMetaFixYearsTidal;

  /// No description provided for @cfgMetaFixYearsDiscogs.
  ///
  /// In en, this message translates to:
  /// **'Fix years (Discogs)'**
  String get cfgMetaFixYearsDiscogs;

  /// No description provided for @cfgMetaFixGenres.
  ///
  /// In en, this message translates to:
  /// **'Fix genres'**
  String get cfgMetaFixGenres;

  /// No description provided for @cfgMetaAutoFixAlbums.
  ///
  /// In en, this message translates to:
  /// **'Auto-fix albums'**
  String get cfgMetaAutoFixAlbums;

  /// No description provided for @cfgMetaSuggestionsPending.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No pending suggestions} =1{1 pending suggestion} other{{count} pending suggestions}}'**
  String cfgMetaSuggestionsPending(int count);

  /// No description provided for @cfgMetaAcceptAll.
  ///
  /// In en, this message translates to:
  /// **'Accept all'**
  String get cfgMetaAcceptAll;

  /// No description provided for @cfgMetaSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get cfgMetaSuggestions;

  /// No description provided for @cfgMetaScanDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Scan for duplicates'**
  String get cfgMetaScanDuplicates;

  /// No description provided for @cfgMetaAutoMerge.
  ///
  /// In en, this message translates to:
  /// **'Auto-merge'**
  String get cfgMetaAutoMerge;

  /// No description provided for @cfgMetaMergeDuplicatesTask.
  ///
  /// In en, this message translates to:
  /// **'Duplicate merge'**
  String get cfgMetaMergeDuplicatesTask;

  /// No description provided for @cfgMetaDuplicatesSummary.
  ///
  /// In en, this message translates to:
  /// **'{groups, plural, =1{{count} duplicate albums in 1 group} other{{count} duplicate albums in {groups} groups}}'**
  String cfgMetaDuplicatesSummary(int count, int groups);

  /// No description provided for @cfgMetaMoreGroups.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{… and 1 more group} other{… and {count} more groups}}'**
  String cfgMetaMoreGroups(int count);

  /// No description provided for @cfgMetaLastResult.
  ///
  /// In en, this message translates to:
  /// **'Last result'**
  String get cfgMetaLastResult;

  /// No description provided for @cfgMetaPercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{pct}% complete'**
  String cfgMetaPercentComplete(String pct);

  /// No description provided for @cfgMetaActionError.
  ///
  /// In en, this message translates to:
  /// **'{label}: error — {detail}'**
  String cfgMetaActionError(String label, String detail);

  /// No description provided for @cfgMetaResultAccepted.
  ///
  /// In en, this message translates to:
  /// **'{label}: {count} accepted'**
  String cfgMetaResultAccepted(String label, String count);

  /// No description provided for @cfgMetaResultFixedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{label}: {fixed}/{total} fixed'**
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total);

  /// No description provided for @cfgMetaResultFixed.
  ///
  /// In en, this message translates to:
  /// **'{label}: {fixed} fixed'**
  String cfgMetaResultFixed(String label, String fixed);

  /// No description provided for @cfgMetaResultProcessed.
  ///
  /// In en, this message translates to:
  /// **'{label}: {total} processed'**
  String cfgMetaResultProcessed(String label, String total);

  /// No description provided for @cfgMetaResultDone.
  ///
  /// In en, this message translates to:
  /// **'{label}: done'**
  String cfgMetaResultDone(String label);

  /// No description provided for @cfgMetaWriteTagsError.
  ///
  /// In en, this message translates to:
  /// **'Tag writing failed: {detail}'**
  String cfgMetaWriteTagsError(String detail);

  /// No description provided for @cfgMetaUploadError.
  ///
  /// In en, this message translates to:
  /// **'Upload failed: {detail}'**
  String cfgMetaUploadError(String detail);

  /// No description provided for @cfgMetaMergeTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Merge 1 album?} other{Merge {count} albums?}}'**
  String cfgMetaMergeTitle(int count);

  /// No description provided for @cfgMetaMergeBody.
  ///
  /// In en, this message translates to:
  /// **'The album with the most tracks will be kept; the others will be deleted.'**
  String get cfgMetaMergeBody;

  /// No description provided for @cfgMetaMergeError.
  ///
  /// In en, this message translates to:
  /// **'Merge failed: {detail}'**
  String cfgMetaMergeError(String detail);

  /// No description provided for @cfgMetaStatsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Statistics unavailable'**
  String get cfgMetaStatsUnavailable;

  /// No description provided for @cfgMetaAlbumCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 album} other{{count} albums}}'**
  String cfgMetaAlbumCount(int count);

  /// No description provided for @cfgMetaMoreAlbums.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{… and 1 more album (filter to narrow down)} other{… and {count} more albums (filter to narrow down)}}'**
  String cfgMetaMoreAlbums(int count);

  /// No description provided for @cfgMetaTrackCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks'**
  String cfgMetaTrackCountText(String count);

  /// No description provided for @cfgMetaReasonArtistUppercase.
  ///
  /// In en, this message translates to:
  /// **'Artist in caps'**
  String get cfgMetaReasonArtistUppercase;

  /// No description provided for @cfgMetaReasonArtistPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Placeholder artist'**
  String get cfgMetaReasonArtistPlaceholder;

  /// No description provided for @cfgMetaReasonArtistHasYear.
  ///
  /// In en, this message translates to:
  /// **'Artist = folder'**
  String get cfgMetaReasonArtistHasYear;

  /// No description provided for @cfgMetaReasonGenrePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Placeholder genre'**
  String get cfgMetaReasonGenrePlaceholder;

  /// No description provided for @cfgMetaReasonYearSuspicious.
  ///
  /// In en, this message translates to:
  /// **'Suspicious year'**
  String get cfgMetaReasonYearSuspicious;

  /// No description provided for @cfgMetaReasonTitleUppercase.
  ///
  /// In en, this message translates to:
  /// **'Title in caps'**
  String get cfgMetaReasonTitleUppercase;

  /// No description provided for @cfgMetaReasonArtistMismatch.
  ///
  /// In en, this message translates to:
  /// **'Artist mismatch'**
  String get cfgMetaReasonArtistMismatch;

  /// No description provided for @cfgSmbNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected to a remote server'**
  String get cfgSmbNotConnected;

  /// No description provided for @cfgSmbMountTitle.
  ///
  /// In en, this message translates to:
  /// **'Mount {name}'**
  String cfgSmbMountTitle(String name);

  /// No description provided for @cfgSmbMount.
  ///
  /// In en, this message translates to:
  /// **'Mount'**
  String get cfgSmbMount;

  /// No description provided for @cfgSmbMountSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} mounted'**
  String cfgSmbMountSuccess(String name);

  /// No description provided for @cfgSmbTitle.
  ///
  /// In en, this message translates to:
  /// **'Network shares (SMB)'**
  String get cfgSmbTitle;

  /// No description provided for @cfgSmbSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for SMB shares…'**
  String get cfgSmbSearching;

  /// No description provided for @cfgSmbNone.
  ///
  /// In en, this message translates to:
  /// **'No SMB shares found'**
  String get cfgSmbNone;

  /// No description provided for @cfgSmbSaveCredentials.
  ///
  /// In en, this message translates to:
  /// **'Save credentials'**
  String get cfgSmbSaveCredentials;

  /// No description provided for @cfgUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get cfgUnknown;

  /// No description provided for @cfgEqTitle.
  ///
  /// In en, this message translates to:
  /// **'Equalizer'**
  String get cfgEqTitle;

  /// No description provided for @cfgEqTabAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get cfgEqTabAssistant;

  /// No description provided for @cfgEqTabExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get cfgEqTabExpert;

  /// No description provided for @cfgEqError.
  ///
  /// In en, this message translates to:
  /// **'EQ error: {detail}'**
  String cfgEqError(String detail);

  /// No description provided for @cfgEqPresetFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get cfgEqPresetFlat;

  /// No description provided for @cfgEqPresetBassBoost.
  ///
  /// In en, this message translates to:
  /// **'Bass Boost'**
  String get cfgEqPresetBassBoost;

  /// No description provided for @cfgEqPresetClassical.
  ///
  /// In en, this message translates to:
  /// **'Classical'**
  String get cfgEqPresetClassical;

  /// No description provided for @cfgEqPresetVocal.
  ///
  /// In en, this message translates to:
  /// **'Vocal'**
  String get cfgEqPresetVocal;

  /// No description provided for @cfgNotConnectedToServer.
  ///
  /// In en, this message translates to:
  /// **'Not connected to the server'**
  String get cfgNotConnectedToServer;

  /// No description provided for @cfgCredentialsRequired.
  ///
  /// In en, this message translates to:
  /// **'Username and password are required'**
  String get cfgCredentialsRequired;

  /// No description provided for @cfgServiceConnected.
  ///
  /// In en, this message translates to:
  /// **'{service} connected.'**
  String cfgServiceConnected(String service);

  /// No description provided for @cfgServiceDisconnected.
  ///
  /// In en, this message translates to:
  /// **'{service} disconnected.'**
  String cfgServiceDisconnected(String service);

  /// No description provided for @cfgLastfmTitle.
  ///
  /// In en, this message translates to:
  /// **'Last.fm scrobbling'**
  String get cfgLastfmTitle;

  /// No description provided for @cfgLastfmDesc.
  ///
  /// In en, this message translates to:
  /// **'Scrobble your listening history to Last.fm. Tracks are scrobbled automatically when played on any zone.'**
  String get cfgLastfmDesc;

  /// No description provided for @cfgDisconnecting.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting…'**
  String get cfgDisconnecting;

  /// No description provided for @cfgConnectHeader.
  ///
  /// In en, this message translates to:
  /// **'CONNECT'**
  String get cfgConnectHeader;

  /// No description provided for @cfgConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get cfgConnecting;

  /// No description provided for @cfgScrobbleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 scrobble} other{{count} scrobbles}}'**
  String cfgScrobbleCount(int count);

  /// No description provided for @cfgLastScrobble.
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String cfgLastScrobble(String date);

  /// No description provided for @cfgTokenRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your user token'**
  String get cfgTokenRequired;

  /// No description provided for @cfgScrobblerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scrobbler not available'**
  String get cfgScrobblerUnavailable;

  /// No description provided for @cfgConnectedAs.
  ///
  /// In en, this message translates to:
  /// **'Connected as {name}'**
  String cfgConnectedAs(String name);

  /// No description provided for @cfgListenbrainzDesc.
  ///
  /// In en, this message translates to:
  /// **'Scrobble your listening history to ListenBrainz. Get your user token from listenbrainz.org/settings.'**
  String get cfgListenbrainzDesc;

  /// No description provided for @cfgUserToken.
  ///
  /// In en, this message translates to:
  /// **'User token'**
  String get cfgUserToken;

  /// No description provided for @cfgValidating.
  ///
  /// In en, this message translates to:
  /// **'Validating…'**
  String get cfgValidating;

  /// No description provided for @cfgSaveAndConnect.
  ///
  /// In en, this message translates to:
  /// **'Save & connect'**
  String get cfgSaveAndConnect;

  /// No description provided for @cfgScrobbleAuto.
  ///
  /// In en, this message translates to:
  /// **'Tracks will be scrobbled automatically'**
  String get cfgScrobbleAuto;

  /// No description provided for @cfgConfigExported.
  ///
  /// In en, this message translates to:
  /// **'Configuration exported: {path}'**
  String cfgConfigExported(String path);

  /// No description provided for @cfgConfigImported.
  ///
  /// In en, this message translates to:
  /// **'Configuration imported successfully'**
  String get cfgConfigImported;

  /// No description provided for @cfgImportError.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {detail}'**
  String cfgImportError(String detail);

  /// No description provided for @cfgConfigExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Saves the server configuration to a JSON file.'**
  String get cfgConfigExportDesc;

  /// No description provided for @cfgConfigExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get cfgConfigExportJson;

  /// No description provided for @cfgConfigImportDesc.
  ///
  /// In en, this message translates to:
  /// **'Restores a configuration from a JSON file.'**
  String get cfgConfigImportDesc;

  /// No description provided for @cfgChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get cfgChooseFile;

  /// No description provided for @cfgDbNoServer.
  ///
  /// In en, this message translates to:
  /// **'No server connected.'**
  String get cfgDbNoServer;

  /// No description provided for @cfgDbExportOk.
  ///
  /// In en, this message translates to:
  /// **'Export OK: {size} MB\n{path}'**
  String cfgDbExportOk(String size, String path);

  /// No description provided for @cfgDbPathUnavailable.
  ///
  /// In en, this message translates to:
  /// **'File path is not accessible.'**
  String get cfgDbPathUnavailable;

  /// No description provided for @cfgDbImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm import'**
  String get cfgDbImportConfirmTitle;

  /// No description provided for @cfgDbImportConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Replace the server database with \"{name}\"?\n\nA safety backup will be created automatically. The server must be restarted after the import.'**
  String cfgDbImportConfirmBody(String name);

  /// No description provided for @cfgDbImportOk.
  ///
  /// In en, this message translates to:
  /// **'Import OK: {size} MB ({engine}).\nRestart the server to apply the changes.'**
  String cfgDbImportOk(String size, String engine);

  /// No description provided for @cfgDbTitle.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get cfgDbTitle;

  /// No description provided for @cfgDbIntro.
  ///
  /// In en, this message translates to:
  /// **'Export or import the database of the connected server.\nSQLite: .db file. PostgreSQL: SQL dump.'**
  String get cfgDbIntro;

  /// No description provided for @cfgDbExporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting…'**
  String get cfgDbExporting;

  /// No description provided for @cfgDbExportBtn.
  ///
  /// In en, this message translates to:
  /// **'Export database'**
  String get cfgDbExportBtn;

  /// No description provided for @cfgDbImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing…'**
  String get cfgDbImporting;

  /// No description provided for @cfgDbImportBtn.
  ///
  /// In en, this message translates to:
  /// **'Import a file'**
  String get cfgDbImportBtn;

  /// No description provided for @cfgDbFooter.
  ///
  /// In en, this message translates to:
  /// **'After an import, restart the server to apply the changes. A safety backup is created automatically before the replacement.'**
  String get cfgDbFooter;

  /// No description provided for @cfgStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Status unavailable: {detail}'**
  String cfgStatusUnavailable(String detail);

  /// No description provided for @cfgSpotifyIntro.
  ///
  /// In en, this message translates to:
  /// **'Tune shows up as a Spotify Connect receiver on the local network. In the Spotify app, select “Tune (…)” in the device list. A Spotify Premium account is required on the client side.'**
  String get cfgSpotifyIntro;

  /// No description provided for @cfgSpotifyNoLibrespot.
  ///
  /// In en, this message translates to:
  /// **'librespot not found on the server'**
  String get cfgSpotifyNoLibrespot;

  /// No description provided for @cfgSpotifyNoLibrespotHint.
  ///
  /// In en, this message translates to:
  /// **'Reinstall Tune Server from the official tarball/zip so the binary is included, or install it separately (apt install librespot / brew install librespot).'**
  String get cfgSpotifyNoLibrespotHint;

  /// No description provided for @cfgTargetZone.
  ///
  /// In en, this message translates to:
  /// **'Target zone'**
  String get cfgTargetZone;

  /// No description provided for @cfgDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get cfgDeviceName;

  /// No description provided for @cfgPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get cfgPlaying;

  /// No description provided for @cfgNetDiagTitle.
  ///
  /// In en, this message translates to:
  /// **'Network diagnostics'**
  String get cfgNetDiagTitle;

  /// No description provided for @cfgNetSsdpActive.
  ///
  /// In en, this message translates to:
  /// **'SSDP active'**
  String get cfgNetSsdpActive;

  /// No description provided for @cfgNetMulticastReachable.
  ///
  /// In en, this message translates to:
  /// **'Multicast reachable'**
  String get cfgNetMulticastReachable;

  /// No description provided for @cfgError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get cfgError;

  /// No description provided for @cfgNetResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get cfgNetResolution;

  /// No description provided for @cfgNetLatency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get cfgNetLatency;

  /// No description provided for @cfgNetPublicIp.
  ///
  /// In en, this message translates to:
  /// **'Public IP'**
  String get cfgNetPublicIp;

  /// No description provided for @cfgNetInterfaces.
  ///
  /// In en, this message translates to:
  /// **'NETWORK INTERFACES'**
  String get cfgNetInterfaces;

  /// No description provided for @cfgStatusWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get cfgStatusWarning;

  /// No description provided for @libAlbumsFilteredCount.
  ///
  /// In en, this message translates to:
  /// **'{shown} / {total} albums'**
  String libAlbumsFilteredCount(int shown, int total);

  /// No description provided for @libNoCollectionsYet.
  ///
  /// In en, this message translates to:
  /// **'No collections yet'**
  String get libNoCollectionsYet;

  /// No description provided for @libRatingError.
  ///
  /// In en, this message translates to:
  /// **'Rating error: {error}'**
  String libRatingError(String error);

  /// No description provided for @libDisc.
  ///
  /// In en, this message translates to:
  /// **'Disc {disc}'**
  String libDisc(int disc);

  /// No description provided for @libDiscWithSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disc {disc} — {subtitle}'**
  String libDiscWithSubtitle(int disc, String subtitle);

  /// No description provided for @libQuickFavorite.
  ///
  /// In en, this message translates to:
  /// **'Quick favorite'**
  String get libQuickFavorite;

  /// No description provided for @libAddToCollection.
  ///
  /// In en, this message translates to:
  /// **'Add to collection'**
  String get libAddToCollection;

  /// No description provided for @libAlbumNotes.
  ///
  /// In en, this message translates to:
  /// **'Album notes'**
  String get libAlbumNotes;

  /// No description provided for @libCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get libCredits;

  /// No description provided for @libNoCredits.
  ///
  /// In en, this message translates to:
  /// **'No credits'**
  String get libNoCredits;

  /// No description provided for @libNoAlbumNotes.
  ///
  /// In en, this message translates to:
  /// **'No album notes available'**
  String get libNoAlbumNotes;

  /// No description provided for @libNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes available'**
  String get libNoNotes;

  /// No description provided for @libSourceCommunity.
  ///
  /// In en, this message translates to:
  /// **'Tune Community'**
  String get libSourceCommunity;

  /// No description provided for @libBioSource.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String libBioSource(String source);

  /// No description provided for @libBioSourceWithLicense.
  ///
  /// In en, this message translates to:
  /// **'Source: {source} · {license}'**
  String libBioSourceWithLicense(String source, String license);

  /// No description provided for @libAppleMusicAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access to the Apple Music library denied.'**
  String get libAppleMusicAccessDenied;

  /// No description provided for @libAppleMusicPermissionRefused.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Enable access in Settings > Privacy > Media & Apple Music.'**
  String get libAppleMusicPermissionRefused;

  /// No description provided for @libUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get libUnknownError;

  /// No description provided for @libAppleMusicAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Access to Apple Music'**
  String get libAppleMusicAccessTitle;

  /// No description provided for @libAppleMusicAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Allow access to your music library to play your Apple Music tracks.'**
  String get libAppleMusicAccessBody;

  /// No description provided for @libAppleMusicEmpty.
  ///
  /// In en, this message translates to:
  /// **'Apple Music library is empty'**
  String get libAppleMusicEmpty;

  /// No description provided for @libReportImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Report image'**
  String get libReportImageTitle;

  /// No description provided for @libReportImageBody.
  ///
  /// In en, this message translates to:
  /// **'Report this artist image as incorrect? The server will replace it during the next enrichment.'**
  String get libReportImageBody;

  /// No description provided for @libReportAction.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get libReportAction;

  /// No description provided for @libImageReported.
  ///
  /// In en, this message translates to:
  /// **'Image reported'**
  String get libImageReported;

  /// No description provided for @libServiceAlbums.
  ///
  /// In en, this message translates to:
  /// **'{service} albums'**
  String libServiceAlbums(String service);

  /// No description provided for @libTrackCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 track} other{{count} tracks}}'**
  String libTrackCount(int count);

  /// No description provided for @libDuplicateScanner.
  ///
  /// In en, this message translates to:
  /// **'Duplicate scanner'**
  String get libDuplicateScanner;

  /// No description provided for @libDuplicateGroupsFound.
  ///
  /// In en, this message translates to:
  /// **'{groups, plural, =1{1 duplicate group found} other{{groups} duplicate groups found}} ({tracks} tracks total)'**
  String libDuplicateGroupsFound(int groups, int tracks);

  /// No description provided for @libFindDuplicatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Find duplicate tracks'**
  String get libFindDuplicatesTitle;

  /// No description provided for @libFindDuplicatesBody.
  ///
  /// In en, this message translates to:
  /// **'Scans audio content hashes to find identical tracks in your library.'**
  String get libFindDuplicatesBody;

  /// No description provided for @libStartScan.
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get libStartScan;

  /// No description provided for @libScanProgress.
  ///
  /// In en, this message translates to:
  /// **'{processed} / {total} tracks ({percent}%)'**
  String libScanProgress(int processed, int total, int percent);

  /// No description provided for @libLoadingTracks.
  ///
  /// In en, this message translates to:
  /// **'Loading tracks…'**
  String get libLoadingTracks;

  /// No description provided for @libNoDuplicatesFound.
  ///
  /// In en, this message translates to:
  /// **'No duplicates found'**
  String get libNoDuplicatesFound;

  /// No description provided for @libLibraryClean.
  ///
  /// In en, this message translates to:
  /// **'Your library is clean.'**
  String get libLibraryClean;

  /// No description provided for @libScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get libScanAgain;

  /// No description provided for @libScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed'**
  String get libScanFailed;

  /// No description provided for @libTrackNumberField.
  ///
  /// In en, this message translates to:
  /// **'Track no.'**
  String get libTrackNumberField;

  /// No description provided for @libDiscNumberField.
  ///
  /// In en, this message translates to:
  /// **'Disc no.'**
  String get libDiscNumberField;

  /// No description provided for @libExtendedMetadata.
  ///
  /// In en, this message translates to:
  /// **'Extended metadata'**
  String get libExtendedMetadata;

  /// No description provided for @libGenreTreeSaved.
  ///
  /// In en, this message translates to:
  /// **'Genre tree saved'**
  String get libGenreTreeSaved;

  /// No description provided for @libSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String libSaveError(String error);

  /// No description provided for @libGenreTree.
  ///
  /// In en, this message translates to:
  /// **'Genre tree'**
  String get libGenreTree;

  /// No description provided for @libAddRootGenre.
  ///
  /// In en, this message translates to:
  /// **'Add root genre'**
  String get libAddRootGenre;

  /// No description provided for @libGenreTreeRequiresRemote.
  ///
  /// In en, this message translates to:
  /// **'The genre tree requires a connection to a remote server.'**
  String get libGenreTreeRequiresRemote;

  /// No description provided for @libNoGenreHierarchy.
  ///
  /// In en, this message translates to:
  /// **'No genre hierarchy defined'**
  String get libNoGenreHierarchy;

  /// No description provided for @libAddSubGenreTo.
  ///
  /// In en, this message translates to:
  /// **'Add sub-genre to “{parent}”'**
  String libAddSubGenreTo(String parent);

  /// No description provided for @libGenreName.
  ///
  /// In en, this message translates to:
  /// **'Genre name'**
  String get libGenreName;

  /// No description provided for @libSubGenreCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sub-genre} other{{count} sub-genres}}'**
  String libSubGenreCount(int count);

  /// No description provided for @libAddSubGenre.
  ///
  /// In en, this message translates to:
  /// **'Add sub-genre'**
  String get libAddSubGenre;

  /// No description provided for @libRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get libRemove;

  /// No description provided for @libRemoveNamedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove “{name}”?'**
  String libRemoveNamedConfirm(String name);

  /// No description provided for @libRemoveGenreWithChildren.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This will also remove its sub-genre.} other{This will also remove all {count} sub-genres.}}'**
  String libRemoveGenreWithChildren(int count);

  /// No description provided for @libRemoveGenreBody.
  ///
  /// In en, this message translates to:
  /// **'This genre will be removed from the tree.'**
  String get libRemoveGenreBody;

  /// No description provided for @libAlbumCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 album} other{{count} albums}}'**
  String libAlbumCount(int count);

  /// No description provided for @libNoTracksForFilter.
  ///
  /// In en, this message translates to:
  /// **'No tracks match this filter'**
  String get libNoTracksForFilter;

  /// No description provided for @libQualityLossless.
  ///
  /// In en, this message translates to:
  /// **'Lossless'**
  String get libQualityLossless;

  /// No description provided for @libQualityLossy.
  ///
  /// In en, this message translates to:
  /// **'Lossy'**
  String get libQualityLossy;

  /// No description provided for @libTracksFilteredCount.
  ///
  /// In en, this message translates to:
  /// **'{shown} / {total} tracks'**
  String libTracksFilteredCount(int shown, int total);

  /// No description provided for @libNewCollection.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get libNewCollection;

  /// No description provided for @libCollectionName.
  ///
  /// In en, this message translates to:
  /// **'Collection name'**
  String get libCollectionName;

  /// No description provided for @libCreateError.
  ///
  /// In en, this message translates to:
  /// **'Create error: {error}'**
  String libCreateError(String error);

  /// No description provided for @libDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Delete error: {error}'**
  String libDeleteError(String error);

  /// No description provided for @libCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get libCollectionsTitle;

  /// No description provided for @libCollectionsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load collections'**
  String get libCollectionsLoadFailed;

  /// No description provided for @libDeleteCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete collection?'**
  String get libDeleteCollectionTitle;

  /// No description provided for @libDeleteCollectionBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete “{name}”.'**
  String libDeleteCollectionBody(String name);

  /// No description provided for @libNoAlbumsInCollection.
  ///
  /// In en, this message translates to:
  /// **'No albums in this collection'**
  String get libNoAlbumsInCollection;

  /// No description provided for @libDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get libDeleteConfirmTitle;

  /// No description provided for @libDeleteSmartCollectionBody.
  ///
  /// In en, this message translates to:
  /// **'This smart collection will be permanently deleted.'**
  String get libDeleteSmartCollectionBody;

  /// No description provided for @libNoRules.
  ///
  /// In en, this message translates to:
  /// **'no rules'**
  String get libNoRules;

  /// No description provided for @libRuleCreditSummary.
  ///
  /// In en, this message translates to:
  /// **'credit: {role}={artist}'**
  String libRuleCreditSummary(String role, String artist);

  /// No description provided for @libAnd.
  ///
  /// In en, this message translates to:
  /// **'AND'**
  String get libAnd;

  /// No description provided for @libOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get libOr;

  /// No description provided for @libSmartCollections.
  ///
  /// In en, this message translates to:
  /// **'Smart Collections'**
  String get libSmartCollections;

  /// No description provided for @libNewSmartCollection.
  ///
  /// In en, this message translates to:
  /// **'New smart collection'**
  String get libNewSmartCollection;

  /// No description provided for @libNoSmartCollections.
  ///
  /// In en, this message translates to:
  /// **'No smart collections'**
  String get libNoSmartCollections;

  /// No description provided for @libSmartCollectionsSeedHint.
  ///
  /// In en, this message translates to:
  /// **'The server normally creates 7 default collections on first start.'**
  String get libSmartCollectionsSeedHint;

  /// No description provided for @libCreateFirstSmartCollection.
  ///
  /// In en, this message translates to:
  /// **'Create my first smart collection'**
  String get libCreateFirstSmartCollection;

  /// No description provided for @libNoMatchingAlbums.
  ///
  /// In en, this message translates to:
  /// **'No matching albums'**
  String get libNoMatchingAlbums;

  /// No description provided for @libSmartCreditsHint.
  ///
  /// In en, this message translates to:
  /// **'For credit-based rules (engineer, performer, …), enrich the library from Settings first.'**
  String get libSmartCreditsHint;

  /// No description provided for @libFieldSampleRate.
  ///
  /// In en, this message translates to:
  /// **'Sample rate'**
  String get libFieldSampleRate;

  /// No description provided for @libFieldBitDepth.
  ///
  /// In en, this message translates to:
  /// **'Bit depth'**
  String get libFieldBitDepth;

  /// No description provided for @libFieldTrackCount.
  ///
  /// In en, this message translates to:
  /// **'Track count'**
  String get libFieldTrackCount;

  /// No description provided for @libFieldFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get libFieldFormat;

  /// No description provided for @libFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get libFieldLabel;

  /// No description provided for @libFieldAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Album title'**
  String get libFieldAlbumTitle;

  /// No description provided for @libFieldSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get libFieldSource;

  /// No description provided for @libFieldCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get libFieldCredit;

  /// No description provided for @libFieldPlayCount.
  ///
  /// In en, this message translates to:
  /// **'Play count'**
  String get libFieldPlayCount;

  /// No description provided for @libFieldLastPlayed.
  ///
  /// In en, this message translates to:
  /// **'Last played'**
  String get libFieldLastPlayed;

  /// No description provided for @libOpBetween.
  ///
  /// In en, this message translates to:
  /// **'between'**
  String get libOpBetween;

  /// No description provided for @libOpContains.
  ///
  /// In en, this message translates to:
  /// **'contains'**
  String get libOpContains;

  /// No description provided for @libOpStartsWith.
  ///
  /// In en, this message translates to:
  /// **'starts with'**
  String get libOpStartsWith;

  /// No description provided for @libOpEmpty.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get libOpEmpty;

  /// No description provided for @libOpNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'not empty'**
  String get libOpNotEmpty;

  /// No description provided for @libOpNever.
  ///
  /// In en, this message translates to:
  /// **'never'**
  String get libOpNever;

  /// No description provided for @libOpAfter.
  ///
  /// In en, this message translates to:
  /// **'after'**
  String get libOpAfter;

  /// No description provided for @libOpBefore.
  ///
  /// In en, this message translates to:
  /// **'before'**
  String get libOpBefore;

  /// No description provided for @libNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get libNameLabel;

  /// No description provided for @libMatchMode.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get libMatchMode;

  /// No description provided for @libMatchAll.
  ///
  /// In en, this message translates to:
  /// **'All rules (AND)'**
  String get libMatchAll;

  /// No description provided for @libMatchAny.
  ///
  /// In en, this message translates to:
  /// **'At least one (OR)'**
  String get libMatchAny;

  /// No description provided for @libAddRule.
  ///
  /// In en, this message translates to:
  /// **'Add a rule'**
  String get libAddRule;

  /// No description provided for @libMatchingAlbumsPending.
  ///
  /// In en, this message translates to:
  /// **'… matching albums'**
  String get libMatchingAlbumsPending;

  /// No description provided for @libMatchingAlbums.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 matching album} other{{count} matching albums}}'**
  String libMatchingAlbums(int count);

  /// No description provided for @libTimestampHint.
  ///
  /// In en, this message translates to:
  /// **'now-30d or 2024-01-01'**
  String get libTimestampHint;

  /// No description provided for @libValueHint.
  ///
  /// In en, this message translates to:
  /// **'value'**
  String get libValueHint;

  /// No description provided for @libMinHint.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get libMinHint;

  /// No description provided for @libMaxHint.
  ///
  /// In en, this message translates to:
  /// **'max'**
  String get libMaxHint;

  /// No description provided for @libCommaSeparatedHint.
  ///
  /// In en, this message translates to:
  /// **'comma-separated values'**
  String get libCommaSeparatedHint;

  /// No description provided for @libCreditRoleHint.
  ///
  /// In en, this message translates to:
  /// **'role (engineer, performer, …)'**
  String get libCreditRoleHint;

  /// No description provided for @libCreditArtistHint.
  ///
  /// In en, this message translates to:
  /// **'artist (Rudy Van Gelder, …)'**
  String get libCreditArtistHint;

  /// No description provided for @libCreditInstrumentHint.
  ///
  /// In en, this message translates to:
  /// **'instrument (Piano, …) — optional'**
  String get libCreditInstrumentHint;

  /// No description provided for @libDirectories.
  ///
  /// In en, this message translates to:
  /// **'Directories'**
  String get libDirectories;

  /// No description provided for @libLoadError.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get libLoadError;

  /// No description provided for @libNoFolders.
  ///
  /// In en, this message translates to:
  /// **'No folders'**
  String get libNoFolders;

  /// No description provided for @libAddFoldersInSettings.
  ///
  /// In en, this message translates to:
  /// **'Add music folders in Settings'**
  String get libAddFoldersInSettings;

  /// No description provided for @libFoldersHeader.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get libFoldersHeader;

  /// No description provided for @libTracksHeaderCount.
  ///
  /// In en, this message translates to:
  /// **'Tracks ({count})'**
  String libTracksHeaderCount(int count);

  /// No description provided for @libPlayFromHere.
  ///
  /// In en, this message translates to:
  /// **'Play from here'**
  String get libPlayFromHere;

  /// No description provided for @libTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get libTags;

  /// No description provided for @libNewTagHint.
  ///
  /// In en, this message translates to:
  /// **'New tag…'**
  String get libNewTagHint;

  /// No description provided for @libJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get libJustNow;

  /// No description provided for @libMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String libMinutesAgo(int count);

  /// No description provided for @libHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String libHoursAgo(int count);

  /// No description provided for @libYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get libYesterday;

  /// No description provided for @libDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String libDaysAgo(int count);

  /// No description provided for @libNowListening.
  ///
  /// In en, this message translates to:
  /// **'Now listening'**
  String get libNowListening;

  /// No description provided for @libContinueListening.
  ///
  /// In en, this message translates to:
  /// **'Continue listening'**
  String get libContinueListening;

  /// No description provided for @libRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get libRecentlyAdded;

  /// No description provided for @libTopTracks.
  ///
  /// In en, this message translates to:
  /// **'Top tracks'**
  String get libTopTracks;

  /// No description provided for @libTopArtists.
  ///
  /// In en, this message translates to:
  /// **'Top artists'**
  String get libTopArtists;

  /// No description provided for @libRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get libRecommendations;

  /// No description provided for @libSourceLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get libSourceLocal;

  /// No description provided for @libFieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get libFieldDuration;

  /// No description provided for @libFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get libFilter;

  /// No description provided for @libRefreshAll.
  ///
  /// In en, this message translates to:
  /// **'Refresh all'**
  String get libRefreshAll;

  /// No description provided for @libPodcastsSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get libPodcastsSubscribed;

  /// No description provided for @libNoSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions yet'**
  String get libNoSubscriptions;

  /// No description provided for @libSubscribeRssFeed.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to an RSS feed'**
  String get libSubscribeRssFeed;

  /// No description provided for @libUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get libUnknown;

  /// No description provided for @libUnsubscribeTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe?'**
  String get libUnsubscribeTitle;

  /// No description provided for @libUnsubscribeBody.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe from “{name}”?'**
  String libUnsubscribeBody(String name);

  /// No description provided for @libUnsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get libUnsubscribe;

  /// No description provided for @libEpisodeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 episode} other{{count} episodes}}'**
  String libEpisodeCount(int count);

  /// No description provided for @libSubscribeToPodcast.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to a podcast'**
  String get libSubscribeToPodcast;

  /// No description provided for @libRssFeedUrl.
  ///
  /// In en, this message translates to:
  /// **'RSS feed URL'**
  String get libRssFeedUrl;

  /// No description provided for @libSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get libSubscribe;

  /// No description provided for @libSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed.'**
  String get libSubscribed;

  /// No description provided for @libSubscribeError.
  ///
  /// In en, this message translates to:
  /// **'Subscribe error: {error}'**
  String libSubscribeError(String error);

  /// No description provided for @libUnsubscribeError.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe error: {error}'**
  String libUnsubscribeError(String error);

  /// No description provided for @libPodcastRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Podcast refreshed.'**
  String get libPodcastRefreshed;

  /// No description provided for @libRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Refresh error: {error}'**
  String libRefreshError(String error);

  /// No description provided for @libAllPodcastsRefreshed.
  ///
  /// In en, this message translates to:
  /// **'All podcasts refreshed.'**
  String get libAllPodcastsRefreshed;

  /// No description provided for @libToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get libToday;

  /// No description provided for @miscNavFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get miscNavFolders;

  /// No description provided for @miscNavCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get miscNavCollections;

  /// No description provided for @miscNavSmartCollections.
  ///
  /// In en, this message translates to:
  /// **'Smart Collections'**
  String get miscNavSmartCollections;

  /// No description provided for @miscNavDjMode.
  ///
  /// In en, this message translates to:
  /// **'DJ Mode'**
  String get miscNavDjMode;

  /// No description provided for @miscNavPartyMode.
  ///
  /// In en, this message translates to:
  /// **'Party Mode'**
  String get miscNavPartyMode;

  /// No description provided for @miscNavDj.
  ///
  /// In en, this message translates to:
  /// **'DJ'**
  String get miscNavDj;

  /// No description provided for @miscNavParty.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get miscNavParty;

  /// No description provided for @miscNavSmartPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Smart Playlists'**
  String get miscNavSmartPlaylists;

  /// No description provided for @miscNavAlarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get miscNavAlarms;

  /// No description provided for @miscNavGenreTree.
  ///
  /// In en, this message translates to:
  /// **'Genre Tree'**
  String get miscNavGenreTree;

  /// No description provided for @miscNavDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get miscNavDashboard;

  /// No description provided for @miscNavDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get miscNavDiagnostics;

  /// No description provided for @miscNavAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get miscNavAdmin;

  /// No description provided for @miscNavMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get miscNavMore;

  /// No description provided for @miscNextTrack.
  ///
  /// In en, this message translates to:
  /// **'Next track'**
  String get miscNextTrack;

  /// No description provided for @miscPreviousTrack.
  ///
  /// In en, this message translates to:
  /// **'Previous track'**
  String get miscPreviousTrack;

  /// No description provided for @miscUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get miscUnknownError;

  /// No description provided for @miscAuthorizationCode.
  ///
  /// In en, this message translates to:
  /// **'Authorization code'**
  String get miscAuthorizationCode;

  /// No description provided for @miscWaitingForValidation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval…'**
  String get miscWaitingForValidation;

  /// No description provided for @miscCodeValue.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String miscCodeValue(String code);

  /// No description provided for @miscQualityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get miscQualityHigh;

  /// No description provided for @miscExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get miscExplore;

  /// No description provided for @miscFavoriteAlbums.
  ///
  /// In en, this message translates to:
  /// **'Favorite albums'**
  String get miscFavoriteAlbums;

  /// No description provided for @miscFavoriteTracks.
  ///
  /// In en, this message translates to:
  /// **'Favorite tracks'**
  String get miscFavoriteTracks;

  /// No description provided for @miscSeeAllTracks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{See 1 track} other{See all {count} tracks}}'**
  String miscSeeAllTracks(int count);

  /// No description provided for @miscMyPlaylists.
  ///
  /// In en, this message translates to:
  /// **'My playlists'**
  String get miscMyPlaylists;

  /// No description provided for @miscNoApiClient.
  ///
  /// In en, this message translates to:
  /// **'No API client'**
  String get miscNoApiClient;

  /// No description provided for @miscServiceFavorites.
  ///
  /// In en, this message translates to:
  /// **'{service} favorites'**
  String miscServiceFavorites(String service);

  /// No description provided for @miscPlayAllCount.
  ///
  /// In en, this message translates to:
  /// **'Play all ({count})'**
  String miscPlayAllCount(int count);

  /// No description provided for @miscServiceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Service not found'**
  String get miscServiceNotFound;

  /// No description provided for @miscYtHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get miscYtHome;

  /// No description provided for @miscYtCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get miscYtCharts;

  /// No description provided for @miscYtMoods.
  ///
  /// In en, this message translates to:
  /// **'Moods'**
  String get miscYtMoods;

  /// No description provided for @miscNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get miscNoData;

  /// No description provided for @miscNoContentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No content available'**
  String get miscNoContentAvailable;

  /// No description provided for @miscNoChartsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No charts available'**
  String get miscNoChartsAvailable;

  /// No description provided for @miscNoMoodsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No moods available'**
  String get miscNoMoodsAvailable;

  /// No description provided for @miscDashTotalPlays.
  ///
  /// In en, this message translates to:
  /// **'Total plays'**
  String get miscDashTotalPlays;

  /// No description provided for @miscDashListeningTime.
  ///
  /// In en, this message translates to:
  /// **'Listening time'**
  String get miscDashListeningTime;

  /// No description provided for @miscDashUniqueTracks.
  ///
  /// In en, this message translates to:
  /// **'Unique tracks'**
  String get miscDashUniqueTracks;

  /// No description provided for @miscDashUniqueArtists.
  ///
  /// In en, this message translates to:
  /// **'Unique artists'**
  String get miscDashUniqueArtists;

  /// No description provided for @miscDashTopArtists.
  ///
  /// In en, this message translates to:
  /// **'TOP ARTISTS'**
  String get miscDashTopArtists;

  /// No description provided for @miscDashTopAlbums.
  ///
  /// In en, this message translates to:
  /// **'TOP ALBUMS'**
  String get miscDashTopAlbums;

  /// No description provided for @miscDashTopTracks.
  ///
  /// In en, this message translates to:
  /// **'TOP TRACKS'**
  String get miscDashTopTracks;

  /// No description provided for @miscDashListeningByHour.
  ///
  /// In en, this message translates to:
  /// **'LISTENING BY HOUR'**
  String get miscDashListeningByHour;

  /// No description provided for @miscDashListeningByDay.
  ///
  /// In en, this message translates to:
  /// **'LISTENING BY DAY'**
  String get miscDashListeningByDay;

  /// No description provided for @miscDashAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get miscDashAllTime;

  /// No description provided for @miscDashLastDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String miscDashLastDays(int days);

  /// No description provided for @miscUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get miscUnknown;

  /// No description provided for @miscPlaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 play} other{{count} plays}}'**
  String miscPlaysCount(int count);

  /// No description provided for @miscDashNoData.
  ///
  /// In en, this message translates to:
  /// **'No listening data yet'**
  String get miscDashNoData;

  /// No description provided for @miscDashNoDataHint.
  ///
  /// In en, this message translates to:
  /// **'Play some music to see your stats here.'**
  String get miscDashNoDataHint;

  /// No description provided for @miscDashLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard'**
  String get miscDashLoadFailed;

  /// No description provided for @miscDiagRequiresRemote.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics requires a remote server connection.'**
  String get miscDiagRequiresRemote;

  /// No description provided for @miscDiagSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get miscDiagSystem;

  /// No description provided for @miscDiagHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get miscDiagHealth;

  /// No description provided for @miscVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get miscVersion;

  /// No description provided for @miscDiagUptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get miscDiagUptime;

  /// No description provided for @miscDiagMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get miscDiagMemory;

  /// No description provided for @miscDiagDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get miscDiagDatabase;

  /// No description provided for @miscZoneNumbered.
  ///
  /// In en, this message translates to:
  /// **'Zone {id}'**
  String miscZoneNumbered(String id);

  /// No description provided for @miscDiagLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get miscDiagLogs;

  /// No description provided for @miscDiagNoLogs.
  ///
  /// In en, this message translates to:
  /// **'No logs available'**
  String get miscDiagNoLogs;

  /// No description provided for @miscAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin dashboard'**
  String get miscAdminTitle;

  /// No description provided for @miscAdminNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected to a remote server'**
  String get miscAdminNotConnected;

  /// No description provided for @miscAdminSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get miscAdminSystemHealth;

  /// No description provided for @miscAdminStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get miscAdminStatus;

  /// No description provided for @miscAdminDisk.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get miscAdminDisk;

  /// No description provided for @miscAdminDiscoveredDevices.
  ///
  /// In en, this message translates to:
  /// **'Discovered devices ({count})'**
  String miscAdminDiscoveredDevices(int count);

  /// No description provided for @miscAdminRecentErrors.
  ///
  /// In en, this message translates to:
  /// **'Recent errors ({count})'**
  String miscAdminRecentErrors(int count);

  /// No description provided for @miscAdminNoRecentErrors.
  ///
  /// In en, this message translates to:
  /// **'No recent errors'**
  String get miscAdminNoRecentErrors;

  /// No description provided for @miscTroubleshootingTitle.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get miscTroubleshootingTitle;

  /// No description provided for @miscFaqHeader.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get miscFaqHeader;

  /// No description provided for @miscFaq1Title.
  ///
  /// In en, this message translates to:
  /// **'I can\'t see my server'**
  String get miscFaq1Title;

  /// No description provided for @miscFaq1Step1.
  ///
  /// In en, this message translates to:
  /// **'Check that the Tune server is running and reachable.'**
  String get miscFaq1Step1;

  /// No description provided for @miscFaq1Step2.
  ///
  /// In en, this message translates to:
  /// **'Make sure your device is on the same Wi-Fi network as the server.'**
  String get miscFaq1Step2;

  /// No description provided for @miscFaq1Step3.
  ///
  /// In en, this message translates to:
  /// **'If you use a VPN, turn it off or enable LAN discovery (e.g. nordvpn set lan-discovery on).'**
  String get miscFaq1Step3;

  /// No description provided for @miscFaq1Step4.
  ///
  /// In en, this message translates to:
  /// **'Try scanning the network from Settings > Mode > Scan network.'**
  String get miscFaq1Step4;

  /// No description provided for @miscFaq1Step5.
  ///
  /// In en, this message translates to:
  /// **'Check that the server port (8888 by default) is not blocked by a firewall.'**
  String get miscFaq1Step5;

  /// No description provided for @miscFaq1Step6.
  ///
  /// In en, this message translates to:
  /// **'Restart the server and the app.'**
  String get miscFaq1Step6;

  /// No description provided for @miscFaq2Title.
  ///
  /// In en, this message translates to:
  /// **'Music won\'t play'**
  String get miscFaq2Title;

  /// No description provided for @miscFaq2Step1.
  ///
  /// In en, this message translates to:
  /// **'Check that a playback zone is selected (bar at the bottom of the screen).'**
  String get miscFaq2Step1;

  /// No description provided for @miscFaq2Step2.
  ///
  /// In en, this message translates to:
  /// **'If no zone exists, create one in Settings > Audio > Zones > Create.'**
  String get miscFaq2Step2;

  /// No description provided for @miscFaq2Step3.
  ///
  /// In en, this message translates to:
  /// **'Check that the output device (speaker, DAC) is switched on and on the same network.'**
  String get miscFaq2Step3;

  /// No description provided for @miscFaq2Step4.
  ///
  /// In en, this message translates to:
  /// **'For DLNA devices, wait a few seconds after discovery before starting playback.'**
  String get miscFaq2Step4;

  /// No description provided for @miscFaq2Step5.
  ///
  /// In en, this message translates to:
  /// **'Try another file — the current file\'s format may not be supported.'**
  String get miscFaq2Step5;

  /// No description provided for @miscFaq2Step6.
  ///
  /// In en, this message translates to:
  /// **'Restart the app if the problem persists.'**
  String get miscFaq2Step6;

  /// No description provided for @miscFaq3Title.
  ///
  /// In en, this message translates to:
  /// **'Covers don\'t show up'**
  String get miscFaq3Title;

  /// No description provided for @miscFaq3Step1.
  ///
  /// In en, this message translates to:
  /// **'Run a library scan from Settings > Library > Sources.'**
  String get miscFaq3Step1;

  /// No description provided for @miscFaq3Step2.
  ///
  /// In en, this message translates to:
  /// **'Check that the files contain embedded covers (ID3/Vorbis tags).'**
  String get miscFaq3Step2;

  /// No description provided for @miscFaq3Step3.
  ///
  /// In en, this message translates to:
  /// **'Put a cover.jpg or folder.jpg file in the album folder.'**
  String get miscFaq3Step3;

  /// No description provided for @miscFaq3Step4.
  ///
  /// In en, this message translates to:
  /// **'Enable automatic cover fetching in Settings > Library > Metadata.'**
  String get miscFaq3Step4;

  /// No description provided for @miscFaq3Step5.
  ///
  /// In en, this message translates to:
  /// **'Clear the image cache by restarting the app.'**
  String get miscFaq3Step5;

  /// No description provided for @miscFaq4Title.
  ///
  /// In en, this message translates to:
  /// **'The scan is stuck'**
  String get miscFaq4Title;

  /// No description provided for @miscFaq4Step1.
  ///
  /// In en, this message translates to:
  /// **'An initial scan can take several minutes depending on the size of the library.'**
  String get miscFaq4Step1;

  /// No description provided for @miscFaq4Step2.
  ///
  /// In en, this message translates to:
  /// **'Check that the music folders are accessible (permissions, SMB mounts).'**
  String get miscFaq4Step2;

  /// No description provided for @miscFaq4Step3.
  ///
  /// In en, this message translates to:
  /// **'Close and relaunch the app to interrupt a stuck scan.'**
  String get miscFaq4Step3;

  /// No description provided for @miscFaq4Step4.
  ///
  /// In en, this message translates to:
  /// **'Check the server logs to identify a problematic file.'**
  String get miscFaq4Step4;

  /// No description provided for @miscFaq4Step5.
  ///
  /// In en, this message translates to:
  /// **'Try reducing the number of source folders to isolate the problem.'**
  String get miscFaq4Step5;

  /// No description provided for @miscFaq5Title.
  ///
  /// In en, this message translates to:
  /// **'How to connect a DLNA/AirPlay device'**
  String get miscFaq5Title;

  /// No description provided for @miscFaq5Step1.
  ///
  /// In en, this message translates to:
  /// **'DLNA: the device must be switched on and on the same network. It appears automatically in the list of outputs.'**
  String get miscFaq5Step1;

  /// No description provided for @miscFaq5Step2.
  ///
  /// In en, this message translates to:
  /// **'If the device doesn\'t appear, check that multicast works on your router.'**
  String get miscFaq5Step2;

  /// No description provided for @miscFaq5Step3.
  ///
  /// In en, this message translates to:
  /// **'Some routers block SSDP traffic between Wi-Fi clients — enable multicast forwarding.'**
  String get miscFaq5Step3;

  /// No description provided for @miscFaq5Step4.
  ///
  /// In en, this message translates to:
  /// **'BluOS: Bluesound speakers are detected automatically.'**
  String get miscFaq5Step4;

  /// No description provided for @miscFaq5Step5.
  ///
  /// In en, this message translates to:
  /// **'Chromecast: Google Cast devices appear in the available outputs.'**
  String get miscFaq5Step5;

  /// No description provided for @miscFaq5Step6.
  ///
  /// In en, this message translates to:
  /// **'Once detected, create a zone and assign the device to it as its output.'**
  String get miscFaq5Step6;

  /// No description provided for @miscFaq6Title.
  ///
  /// In en, this message translates to:
  /// **'Streaming problems'**
  String get miscFaq6Title;

  /// No description provided for @miscFaq6Step1.
  ///
  /// In en, this message translates to:
  /// **'Check that your service credentials (TIDAL, Qobuz, Deezer) are correct in Settings > Streaming.'**
  String get miscFaq6Step1;

  /// No description provided for @miscFaq6Step2.
  ///
  /// In en, this message translates to:
  /// **'If the session has expired, disconnect and then reconnect the service.'**
  String get miscFaq6Step2;

  /// No description provided for @miscFaq6Step3.
  ///
  /// In en, this message translates to:
  /// **'Check your Internet connection.'**
  String get miscFaq6Step3;

  /// No description provided for @miscFaq6Step4.
  ///
  /// In en, this message translates to:
  /// **'Some tracks may be unavailable in your region.'**
  String get miscFaq6Step4;

  /// No description provided for @miscFaq6Step5.
  ///
  /// In en, this message translates to:
  /// **'For quality issues, check the streaming quality settings in Settings > Advanced audio.'**
  String get miscFaq6Step5;

  /// No description provided for @miscFaq6Step6.
  ///
  /// In en, this message translates to:
  /// **'If the problem persists, send a bug report from Settings > Help.'**
  String get miscFaq6Step6;

  /// No description provided for @miscBugReportCopied.
  ///
  /// In en, this message translates to:
  /// **'Report copied to clipboard'**
  String get miscBugReportCopied;

  /// No description provided for @miscBugReportSent.
  ///
  /// In en, this message translates to:
  /// **'Bug sent, thank you!'**
  String get miscBugReportSent;

  /// No description provided for @miscBugReportSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Sending failed. Copy the report into the forum.'**
  String get miscBugReportSendFailed;

  /// No description provided for @miscBugReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Bug report'**
  String get miscBugReportTitle;

  /// No description provided for @miscRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get miscRegenerate;

  /// No description provided for @miscBugReportGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate the report'**
  String get miscBugReportGenerateFailed;

  /// No description provided for @miscSent.
  ///
  /// In en, this message translates to:
  /// **'Sent!'**
  String get miscSent;

  /// No description provided for @miscSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get miscSending;

  /// No description provided for @miscSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get miscSubmit;

  /// No description provided for @miscCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get miscCopied;

  /// No description provided for @miscCopyReport.
  ///
  /// In en, this message translates to:
  /// **'Copy report'**
  String get miscCopyReport;

  /// No description provided for @miscAiServerNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Server not connected. Check the connection.'**
  String get miscAiServerNotConnected;

  /// No description provided for @miscAiQueryFailed.
  ///
  /// In en, this message translates to:
  /// **'AI query failed ({code})'**
  String miscAiQueryFailed(int code);

  /// No description provided for @miscAiNoReply.
  ///
  /// In en, this message translates to:
  /// **'No reply'**
  String get miscAiNoReply;

  /// No description provided for @miscAiAskHint.
  ///
  /// In en, this message translates to:
  /// **'Ask a question…'**
  String get miscAiAskHint;

  /// No description provided for @miscAiSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get miscAiSend;

  /// No description provided for @miscAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI assistant'**
  String get miscAiTitle;

  /// No description provided for @miscAiEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Tune AI assistant'**
  String get miscAiEmptyTitle;

  /// No description provided for @miscAiEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Ask a question about your music,\nask for recommendations…'**
  String get miscAiEmptyBody;

  /// No description provided for @miscAiAction.
  ///
  /// In en, this message translates to:
  /// **'Action: {action}'**
  String miscAiAction(String action);

  /// No description provided for @miscCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get miscCreateAccount;

  /// No description provided for @miscUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get miscUsername;

  /// No description provided for @miscUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username required'**
  String get miscUsernameRequired;

  /// No description provided for @miscEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email required'**
  String get miscEmailRequired;

  /// No description provided for @miscEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get miscEmailInvalid;

  /// No description provided for @miscPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get miscPasswordRequired;

  /// No description provided for @miscPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters'**
  String miscPasswordMinLength(int min);

  /// No description provided for @miscHaveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get miscHaveAccountSignIn;

  /// No description provided for @miscNoAccountSignUp.
  ///
  /// In en, this message translates to:
  /// **'No account? Sign up'**
  String get miscNoAccountSignUp;

  /// No description provided for @npRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get npRepeat;

  /// No description provided for @npQueue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get npQueue;

  /// No description provided for @npFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get npFavorite;

  /// No description provided for @npRadioFavAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to radio favorites'**
  String get npRadioFavAdded;

  /// No description provided for @npLyrics.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get npLyrics;

  /// No description provided for @npAlarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get npAlarm;

  /// No description provided for @npSleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer'**
  String get npSleepTimer;

  /// No description provided for @npDspCrossfeed.
  ///
  /// In en, this message translates to:
  /// **'DSP Crossfeed'**
  String get npDspCrossfeed;

  /// No description provided for @npEqualizer.
  ///
  /// In en, this message translates to:
  /// **'Equalizer'**
  String get npEqualizer;

  /// No description provided for @npShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get npShare;

  /// No description provided for @npTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get npTransfer;

  /// No description provided for @npCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get npCopiedToClipboard;

  /// No description provided for @npNoLyricsFound.
  ///
  /// In en, this message translates to:
  /// **'No lyrics found'**
  String get npNoLyricsFound;

  /// No description provided for @npNoLyricsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No lyrics available'**
  String get npNoLyricsAvailable;

  /// No description provided for @npLyricsOpenFromNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Open from Now Playing for full lyrics'**
  String get npLyricsOpenFromNowPlaying;

  /// No description provided for @npLyricsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load lyrics'**
  String get npLyricsLoadFailed;

  /// No description provided for @npLrcMetadataTooltip.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get npLrcMetadataTooltip;

  /// No description provided for @npLrcMetadataTitle.
  ///
  /// In en, this message translates to:
  /// **'LRC metadata'**
  String get npLrcMetadataTitle;

  /// No description provided for @npLrcTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get npLrcTitle;

  /// No description provided for @npLrcCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get npLrcCreatedBy;

  /// No description provided for @npLrcOffset.
  ///
  /// In en, this message translates to:
  /// **'Offset (ms)'**
  String get npLrcOffset;

  /// No description provided for @npLrcHint.
  ///
  /// In en, this message translates to:
  /// **'Place a .lrc file next to the audio file with the same name.'**
  String get npLrcHint;

  /// No description provided for @npEqFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get npEqFlat;

  /// No description provided for @npEqBassBoost.
  ///
  /// In en, this message translates to:
  /// **'Bass Boost'**
  String get npEqBassBoost;

  /// No description provided for @npEqTrebleBoost.
  ///
  /// In en, this message translates to:
  /// **'Treble Boost'**
  String get npEqTrebleBoost;

  /// No description provided for @npEqVocal.
  ///
  /// In en, this message translates to:
  /// **'Vocal'**
  String get npEqVocal;

  /// No description provided for @npEqRock.
  ///
  /// In en, this message translates to:
  /// **'Rock'**
  String get npEqRock;

  /// No description provided for @npEqJazz.
  ///
  /// In en, this message translates to:
  /// **'Jazz'**
  String get npEqJazz;

  /// No description provided for @npEqClassical.
  ///
  /// In en, this message translates to:
  /// **'Classical'**
  String get npEqClassical;

  /// No description provided for @npEqElectronic.
  ///
  /// In en, this message translates to:
  /// **'Electronic'**
  String get npEqElectronic;

  /// No description provided for @npEqHipHop.
  ///
  /// In en, this message translates to:
  /// **'Hip Hop'**
  String get npEqHipHop;

  /// No description provided for @npEqAcoustic.
  ///
  /// In en, this message translates to:
  /// **'Acoustic'**
  String get npEqAcoustic;

  /// No description provided for @npEqApplied.
  ///
  /// In en, this message translates to:
  /// **'EQ: {preset}'**
  String npEqApplied(String preset);

  /// No description provided for @npEqError.
  ///
  /// In en, this message translates to:
  /// **'EQ error: {error}'**
  String npEqError(String error);

  /// No description provided for @npCrossfeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Blends stereo channels for a more natural headphone experience'**
  String get npCrossfeedDesc;

  /// No description provided for @npCrossfeedOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get npCrossfeedOff;

  /// No description provided for @npCrossfeedLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get npCrossfeedLight;

  /// No description provided for @npCrossfeedMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get npCrossfeedMedium;

  /// No description provided for @npCrossfeedStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get npCrossfeedStrong;

  /// No description provided for @npCrossfeedApplied.
  ///
  /// In en, this message translates to:
  /// **'Crossfeed: {level}'**
  String npCrossfeedApplied(String level);

  /// No description provided for @npDspError.
  ///
  /// In en, this message translates to:
  /// **'DSP error: {error}'**
  String npDspError(String error);

  /// No description provided for @npTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer playback'**
  String get npTransferTitle;

  /// No description provided for @npNoOtherZones.
  ///
  /// In en, this message translates to:
  /// **'No other zones available'**
  String get npNoOtherZones;

  /// No description provided for @npTransferredTo.
  ///
  /// In en, this message translates to:
  /// **'Transferred to {zone}'**
  String npTransferredTo(String zone);

  /// No description provided for @npTransferError.
  ///
  /// In en, this message translates to:
  /// **'Transfer error: {error}'**
  String npTransferError(String error);

  /// No description provided for @npAlarmClock.
  ///
  /// In en, this message translates to:
  /// **'Alarm clock'**
  String get npAlarmClock;

  /// No description provided for @npAlarmSetFor.
  ///
  /// In en, this message translates to:
  /// **'Alarm set for {time}'**
  String npAlarmSetFor(String time);

  /// No description provided for @npAlarmError.
  ///
  /// In en, this message translates to:
  /// **'Alarm error: {error}'**
  String npAlarmError(String error);

  /// No description provided for @npAlarmCancelled.
  ///
  /// In en, this message translates to:
  /// **'Alarm cancelled'**
  String get npAlarmCancelled;

  /// No description provided for @npPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get npPause;

  /// No description provided for @npStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get npStop;

  /// No description provided for @npRoleComposer.
  ///
  /// In en, this message translates to:
  /// **'Composer'**
  String get npRoleComposer;

  /// No description provided for @npRoleLyricist.
  ///
  /// In en, this message translates to:
  /// **'Lyricist'**
  String get npRoleLyricist;

  /// No description provided for @npRoleArranger.
  ///
  /// In en, this message translates to:
  /// **'Arranger'**
  String get npRoleArranger;

  /// No description provided for @npRoleConductor.
  ///
  /// In en, this message translates to:
  /// **'Conductor'**
  String get npRoleConductor;

  /// No description provided for @npRolePerformer.
  ///
  /// In en, this message translates to:
  /// **'Performer'**
  String get npRolePerformer;

  /// No description provided for @npRoleProducer.
  ///
  /// In en, this message translates to:
  /// **'Producer'**
  String get npRoleProducer;

  /// No description provided for @npRoleMixer.
  ///
  /// In en, this message translates to:
  /// **'Mixer'**
  String get npRoleMixer;

  /// No description provided for @npRoleEngineer.
  ///
  /// In en, this message translates to:
  /// **'Engineer'**
  String get npRoleEngineer;

  /// No description provided for @npCreditsEnriching.
  ///
  /// In en, this message translates to:
  /// **'Enriching…'**
  String get npCreditsEnriching;

  /// No description provided for @npCreditsEnrich.
  ///
  /// In en, this message translates to:
  /// **'Enrich via MusicBrainz'**
  String get npCreditsEnrich;

  /// No description provided for @npVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get npVolume;

  /// No description provided for @npChangeZone.
  ///
  /// In en, this message translates to:
  /// **'Switch zone'**
  String get npChangeZone;

  /// No description provided for @npZoneFallback.
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get npZoneFallback;

  /// No description provided for @npFollowMe.
  ///
  /// In en, this message translates to:
  /// **'Follow me'**
  String get npFollowMe;

  /// No description provided for @npMovePlaybackTo.
  ///
  /// In en, this message translates to:
  /// **'Move playback to…'**
  String get npMovePlaybackTo;

  /// No description provided for @npNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get npNowPlaying;

  /// No description provided for @npTabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get npTabMore;

  /// No description provided for @npSleepTimerSet.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer set: {minutes} min (fade: {fade} s)'**
  String npSleepTimerSet(int minutes, int fade);

  /// No description provided for @npSleepTimerError.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer error: {error}'**
  String npSleepTimerError(String error);

  /// No description provided for @npSleepTimerCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer cancelled'**
  String get npSleepTimerCancelled;

  /// No description provided for @npSleepDuration.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get npSleepDuration;

  /// No description provided for @npSleepCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get npSleepCustom;

  /// No description provided for @npSleepFadeOut.
  ///
  /// In en, this message translates to:
  /// **'FADE OUT'**
  String get npSleepFadeOut;

  /// No description provided for @npSleepFadeDesc.
  ///
  /// In en, this message translates to:
  /// **'Volume will gradually fade to zero during the last {seconds} seconds.'**
  String npSleepFadeDesc(int seconds);

  /// No description provided for @npSleepStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get npSleepStarting;

  /// No description provided for @npSleepStart.
  ///
  /// In en, this message translates to:
  /// **'Start ({duration})'**
  String npSleepStart(String duration);

  /// No description provided for @npSleepSelectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select duration'**
  String get npSleepSelectDuration;

  /// No description provided for @npSleepTimerActive.
  ///
  /// In en, this message translates to:
  /// **'Timer active'**
  String get npSleepTimerActive;

  /// No description provided for @npSleepCancelTimer.
  ///
  /// In en, this message translates to:
  /// **'Cancel timer'**
  String get npSleepCancelTimer;

  /// No description provided for @npMoodChill.
  ///
  /// In en, this message translates to:
  /// **'Chill'**
  String get npMoodChill;

  /// No description provided for @npMoodParty.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get npMoodParty;

  /// No description provided for @npMoodFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get npMoodFocus;

  /// No description provided for @npMoodEnergetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get npMoodEnergetic;

  /// No description provided for @npNoZoneAvailable.
  ///
  /// In en, this message translates to:
  /// **'No zone available'**
  String get npNoZoneAvailable;

  /// No description provided for @npMoodNoTracks.
  ///
  /// In en, this message translates to:
  /// **'No tracks found for {mood}'**
  String npMoodNoTracks(String mood);

  /// No description provided for @npMoodInvalidTrackIds.
  ///
  /// In en, this message translates to:
  /// **'Error: invalid track IDs'**
  String get npMoodInvalidTrackIds;

  /// No description provided for @npMoodMixPlaying.
  ///
  /// In en, this message translates to:
  /// **'{mood} Mix: {count, plural, =1{1 track playing} other{{count} tracks playing}}'**
  String npMoodMixPlaying(String mood, int count);

  /// No description provided for @npMoodMixQueued.
  ///
  /// In en, this message translates to:
  /// **'{mood} Mix: {count, plural, =1{1 track added to the queue} other{{count} tracks added to the queue}}'**
  String npMoodMixQueued(String mood, int count);

  /// No description provided for @npSmartAutoplayError.
  ///
  /// In en, this message translates to:
  /// **'Smart AutoPlay error: {error}'**
  String npSmartAutoplayError(String error);

  /// No description provided for @npSmartAutoplayDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick a mood to generate a smart playlist'**
  String get npSmartAutoplayDesc;

  /// No description provided for @npAlarmsNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected to a remote server'**
  String get npAlarmsNotConnected;

  /// No description provided for @npAlarmSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Alarm snoozed for 5 min'**
  String get npAlarmSnoozed;

  /// No description provided for @npAlarmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get npAlarmsTitle;

  /// No description provided for @npAlarmsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No alarms'**
  String get npAlarmsEmpty;

  /// No description provided for @npZoneNumbered.
  ///
  /// In en, this message translates to:
  /// **'Zone {id}'**
  String npZoneNumbered(String id);

  /// No description provided for @npAlarmSkipsHolidays.
  ///
  /// In en, this message translates to:
  /// **'Skips public holidays'**
  String get npAlarmSkipsHolidays;

  /// No description provided for @npAlarmSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get npAlarmSnooze;

  /// No description provided for @npAlarmDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get npAlarmDefaultName;

  /// No description provided for @npAlarmEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit alarm'**
  String get npAlarmEdit;

  /// No description provided for @npAlarmNew.
  ///
  /// In en, this message translates to:
  /// **'New alarm'**
  String get npAlarmNew;

  /// No description provided for @npAlarmTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get npAlarmTime;

  /// No description provided for @npAlarmNameHint.
  ///
  /// In en, this message translates to:
  /// **'Wake-up'**
  String get npAlarmNameHint;

  /// No description provided for @npAlarmDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get npAlarmDays;

  /// No description provided for @npAlarmSkipHolidays.
  ///
  /// In en, this message translates to:
  /// **'Skip public holidays'**
  String get npAlarmSkipHolidays;

  /// No description provided for @npAlarmCountry.
  ///
  /// In en, this message translates to:
  /// **'Country:'**
  String get npAlarmCountry;

  /// No description provided for @npCountryFR.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get npCountryFR;

  /// No description provided for @npCountryBE.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get npCountryBE;

  /// No description provided for @npCountryCH.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get npCountryCH;

  /// No description provided for @npCountryCA.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get npCountryCA;

  /// No description provided for @npCountryUS.
  ///
  /// In en, this message translates to:
  /// **'USA'**
  String get npCountryUS;

  /// No description provided for @npCountryDE.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get npCountryDE;

  /// No description provided for @npCountryGB.
  ///
  /// In en, this message translates to:
  /// **'UK'**
  String get npCountryGB;

  /// No description provided for @npAlarmSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get npAlarmSource;

  /// No description provided for @npAlarmSourceType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get npAlarmSourceType;

  /// No description provided for @npSourceRadio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get npSourceRadio;

  /// No description provided for @npSourcePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get npSourcePlaylist;

  /// No description provided for @npSourceAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get npSourceAlbum;

  /// No description provided for @npAlarmSourceName.
  ///
  /// In en, this message translates to:
  /// **'Source name'**
  String get npAlarmSourceName;

  /// No description provided for @npAlarmPlaylistId.
  ///
  /// In en, this message translates to:
  /// **'Playlist ID'**
  String get npAlarmPlaylistId;

  /// No description provided for @npAlarmAlbumId.
  ///
  /// In en, this message translates to:
  /// **'Album ID'**
  String get npAlarmAlbumId;

  /// No description provided for @npAlarmIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get npAlarmIdentifier;

  /// No description provided for @npAlarmPlaybackZone.
  ///
  /// In en, this message translates to:
  /// **'Playback zone'**
  String get npAlarmPlaybackZone;

  /// No description provided for @npAlarmDefaultZone.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get npAlarmDefaultZone;

  /// No description provided for @npAlarmVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume: {percent}%'**
  String npAlarmVolume(int percent);

  /// No description provided for @npAlarmFadeIn.
  ///
  /// In en, this message translates to:
  /// **'Fade-in: {seconds} s'**
  String npAlarmFadeIn(int seconds);

  /// No description provided for @npAlarmEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get npAlarmEnabled;

  /// No description provided for @npAlarmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete alarm?'**
  String get npAlarmDeleteTitle;

  /// No description provided for @npDayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get npDayMon;

  /// No description provided for @npDayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get npDayTue;

  /// No description provided for @npDayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get npDayWed;

  /// No description provided for @npDayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get npDayThu;

  /// No description provided for @npDayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get npDayFri;

  /// No description provided for @npDaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get npDaySat;

  /// No description provided for @npDaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get npDaySun;

  /// No description provided for @plHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Playlists Hub'**
  String get plHubTitle;

  /// No description provided for @plTabSmartAi.
  ///
  /// In en, this message translates to:
  /// **'Smart AI'**
  String get plTabSmartAi;

  /// No description provided for @plTabTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get plTabTransfers;

  /// No description provided for @plSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get plSync;

  /// No description provided for @plTabBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get plTabBackup;

  /// No description provided for @plCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get plCompare;

  /// No description provided for @plComparing.
  ///
  /// In en, this message translates to:
  /// **'Comparing…'**
  String get plComparing;

  /// No description provided for @plCompareError.
  ///
  /// In en, this message translates to:
  /// **'Comparison failed: {detail}'**
  String plCompareError(String detail);

  /// No description provided for @plNoPlaylistsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No playlists available'**
  String get plNoPlaylistsAvailable;

  /// No description provided for @plSectionSource.
  ///
  /// In en, this message translates to:
  /// **'SOURCE'**
  String get plSectionSource;

  /// No description provided for @plSectionTarget.
  ///
  /// In en, this message translates to:
  /// **'TARGET'**
  String get plSectionTarget;

  /// No description provided for @plServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get plServiceLabel;

  /// No description provided for @plPlaylistLabel.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get plPlaylistLabel;

  /// No description provided for @plLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get plLocal;

  /// No description provided for @plRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get plRestore;

  /// No description provided for @plSyncIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-sync interval'**
  String get plSyncIntervalTitle;

  /// No description provided for @plSyncIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes (0 = manual only):'**
  String get plSyncIntervalLabel;

  /// No description provided for @plSyncIntervalHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 60'**
  String get plSyncIntervalHint;

  /// No description provided for @plNoTransfers.
  ///
  /// In en, this message translates to:
  /// **'No transfers'**
  String get plNoTransfers;

  /// No description provided for @plNoSyncLinks.
  ///
  /// In en, this message translates to:
  /// **'No sync links'**
  String get plNoSyncLinks;

  /// No description provided for @plNoSyncLinksHint.
  ///
  /// In en, this message translates to:
  /// **'Create links from a transfer'**
  String get plNoSyncLinksHint;

  /// No description provided for @plAutoEveryMinutes.
  ///
  /// In en, this message translates to:
  /// **'auto {minutes} min'**
  String plAutoEveryMinutes(String minutes);

  /// No description provided for @plSyncError.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {detail}'**
  String plSyncError(String detail);

  /// No description provided for @plSectionBackup.
  ///
  /// In en, this message translates to:
  /// **'BACKUP'**
  String get plSectionBackup;

  /// No description provided for @plBackingUp.
  ///
  /// In en, this message translates to:
  /// **'Backing up…'**
  String get plBackingUp;

  /// No description provided for @plBackupAll.
  ///
  /// In en, this message translates to:
  /// **'Back up all playlists'**
  String get plBackupAll;

  /// No description provided for @plSectionSnapshots.
  ///
  /// In en, this message translates to:
  /// **'SNAPSHOTS'**
  String get plSectionSnapshots;

  /// No description provided for @plNoSnapshots.
  ///
  /// In en, this message translates to:
  /// **'No snapshots. Run a backup to create one.'**
  String get plNoSnapshots;

  /// No description provided for @plMergeDone.
  ///
  /// In en, this message translates to:
  /// **'Playlists merged.'**
  String get plMergeDone;

  /// No description provided for @plMergeError.
  ///
  /// In en, this message translates to:
  /// **'Merge failed: {detail}'**
  String plMergeError(String detail);

  /// No description provided for @plNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get plNameLabel;

  /// No description provided for @plDeleteNamed.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String plDeleteNamed(String name);

  /// No description provided for @plImportedLocal.
  ///
  /// In en, this message translates to:
  /// **'“{name}” imported to local.'**
  String plImportedLocal(String name);

  /// No description provided for @plImportError.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {detail}'**
  String plImportError(String detail);

  /// No description provided for @plFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get plFilterAll;

  /// No description provided for @plMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get plMerge;

  /// No description provided for @plCancelMerge.
  ///
  /// In en, this message translates to:
  /// **'Cancel merge'**
  String get plCancelMerge;

  /// No description provided for @plMerging.
  ///
  /// In en, this message translates to:
  /// **'Merging…'**
  String get plMerging;

  /// No description provided for @plImportToLocal.
  ///
  /// In en, this message translates to:
  /// **'Import to local'**
  String get plImportToLocal;

  /// No description provided for @plSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String plSelectedCount(int count);

  /// No description provided for @plDedup.
  ///
  /// In en, this message translates to:
  /// **'Dedupe'**
  String get plDedup;

  /// No description provided for @plMergedNameHint.
  ///
  /// In en, this message translates to:
  /// **'Merged playlist name'**
  String get plMergedNameHint;

  /// No description provided for @plTracksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 track} other{{count} tracks}}'**
  String plTracksCount(int count);

  /// No description provided for @plSectionResults.
  ///
  /// In en, this message translates to:
  /// **'RESULTS'**
  String get plSectionResults;

  /// No description provided for @plCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get plCommon;

  /// No description provided for @plSourceOnly.
  ///
  /// In en, this message translates to:
  /// **'Source only'**
  String get plSourceOnly;

  /// No description provided for @plTargetOnly.
  ///
  /// In en, this message translates to:
  /// **'Target only'**
  String get plTargetOnly;

  /// No description provided for @plMatchRate.
  ///
  /// In en, this message translates to:
  /// **'{rate}% match rate'**
  String plMatchRate(String rate);

  /// No description provided for @plOnlyInSource.
  ///
  /// In en, this message translates to:
  /// **'Only in source ({count})'**
  String plOnlyInSource(int count);

  /// No description provided for @plOnlyInTarget.
  ///
  /// In en, this message translates to:
  /// **'Only in target ({count})'**
  String plOnlyInTarget(int count);

  /// No description provided for @plMoreCount.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more'**
  String plMoreCount(int count);

  /// No description provided for @plTransferPlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer playlist'**
  String get plTransferPlaylistTitle;

  /// No description provided for @plCreateOnRemote.
  ///
  /// In en, this message translates to:
  /// **'Create on the remote service'**
  String get plCreateOnRemote;

  /// No description provided for @plTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get plTransfer;

  /// No description provided for @plTransferDone.
  ///
  /// In en, this message translates to:
  /// **'Transfer: {matched} matched, {approximate} approximate, {notFound} missing.'**
  String plTransferDone(String matched, String approximate, String notFound);

  /// No description provided for @plRecover.
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get plRecover;

  /// No description provided for @plRecoverDone.
  ///
  /// In en, this message translates to:
  /// **'Recover: {available} available, {alternatives} alternatives found.'**
  String plRecoverDone(int available, int alternatives);

  /// No description provided for @plCopyName.
  ///
  /// In en, this message translates to:
  /// **'{name} (copy)'**
  String plCopyName(String name);

  /// No description provided for @plDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get plDuplicate;

  /// No description provided for @plDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Duplicated: {name}'**
  String plDuplicated(String name);

  /// No description provided for @plDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted: {name}'**
  String plDeleted(String name);

  /// No description provided for @plTransferred.
  ///
  /// In en, this message translates to:
  /// **'Transferred: {name}'**
  String plTransferred(String name);

  /// No description provided for @plTransferToLocal.
  ///
  /// In en, this message translates to:
  /// **'Transfer to local'**
  String get plTransferToLocal;

  /// No description provided for @plExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get plExportJson;

  /// No description provided for @plExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get plExportCsv;

  /// No description provided for @plExportM3u.
  ///
  /// In en, this message translates to:
  /// **'Export M3U'**
  String get plExportM3u;

  /// No description provided for @plExportJsonDone.
  ///
  /// In en, this message translates to:
  /// **'JSON export complete'**
  String get plExportJsonDone;

  /// No description provided for @plExportCsvDone.
  ///
  /// In en, this message translates to:
  /// **'CSV export complete'**
  String get plExportCsvDone;

  /// No description provided for @plExportM3uDone.
  ///
  /// In en, this message translates to:
  /// **'M3U exported: {path}'**
  String plExportM3uDone(String path);

  /// No description provided for @plExportM3uError.
  ///
  /// In en, this message translates to:
  /// **'M3U export failed: {detail}'**
  String plExportM3uError(String detail);

  /// No description provided for @plImportedM3u.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Imported: {name} (1 track)} other{Imported: {name} ({count} tracks)}}'**
  String plImportedM3u(String name, int count);

  /// No description provided for @plImportM3uError.
  ///
  /// In en, this message translates to:
  /// **'M3U import failed: {detail}'**
  String plImportM3uError(String detail);

  /// No description provided for @plSmartTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Playlists'**
  String get plSmartTitle;

  /// No description provided for @plSmartLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load smart playlists: {detail}'**
  String plSmartLoadError(String detail);

  /// No description provided for @plDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {detail}'**
  String plDeleteError(String detail);

  /// No description provided for @plSmartEmpty.
  ///
  /// In en, this message translates to:
  /// **'No smart playlists'**
  String get plSmartEmpty;

  /// No description provided for @plUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get plUntitled;

  /// No description provided for @plSmartDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete smart playlist?'**
  String get plSmartDeleteTitle;

  /// No description provided for @plPreviewError.
  ///
  /// In en, this message translates to:
  /// **'Preview failed: {detail}'**
  String plPreviewError(String detail);

  /// No description provided for @plEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get plEnterName;

  /// No description provided for @plSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {detail}'**
  String plSaveError(String detail);

  /// No description provided for @plSmartEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit smart playlist'**
  String get plSmartEditTitle;

  /// No description provided for @plSmartNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New smart playlist'**
  String get plSmartNewTitle;

  /// No description provided for @plMatchLabel.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get plMatchLabel;

  /// No description provided for @plMatchAll.
  ///
  /// In en, this message translates to:
  /// **'All rules'**
  String get plMatchAll;

  /// No description provided for @plMatchAny.
  ///
  /// In en, this message translates to:
  /// **'Any rule'**
  String get plMatchAny;

  /// No description provided for @plSectionRules.
  ///
  /// In en, this message translates to:
  /// **'RULES'**
  String get plSectionRules;

  /// No description provided for @plAddRule.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get plAddRule;

  /// No description provided for @plMaxTracksLabel.
  ///
  /// In en, this message translates to:
  /// **'Max tracks (optional)'**
  String get plMaxTracksLabel;

  /// No description provided for @plNoLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get plNoLimit;

  /// No description provided for @plPreviewMatching.
  ///
  /// In en, this message translates to:
  /// **'Preview matching tracks'**
  String get plPreviewMatching;

  /// No description provided for @plMatchingTracks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 matching track} other{{count} matching tracks}}'**
  String plMatchingTracks(int count);

  /// No description provided for @plValueHint.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get plValueHint;

  /// No description provided for @plUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get plUnknownTitle;

  /// No description provided for @plTracksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load tracks: {detail}'**
  String plTracksLoadError(String detail);

  /// No description provided for @plSmartNoTracks.
  ///
  /// In en, this message translates to:
  /// **'No tracks match this playlist'**
  String get plSmartNoTracks;

  /// No description provided for @plFieldGenre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get plFieldGenre;

  /// No description provided for @plFieldArtist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get plFieldArtist;

  /// No description provided for @plFieldAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get plFieldAlbum;

  /// No description provided for @plFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get plFieldTitle;

  /// No description provided for @plFieldYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get plFieldYear;

  /// No description provided for @plFieldRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get plFieldRating;

  /// No description provided for @plFieldPlayCount.
  ///
  /// In en, this message translates to:
  /// **'Play count'**
  String get plFieldPlayCount;

  /// No description provided for @plFieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (ms)'**
  String get plFieldDuration;

  /// No description provided for @plFieldDateAdded.
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get plFieldDateAdded;

  /// No description provided for @plFieldFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get plFieldFavorite;

  /// No description provided for @plOpContains.
  ///
  /// In en, this message translates to:
  /// **'contains'**
  String get plOpContains;

  /// No description provided for @plOpEquals.
  ///
  /// In en, this message translates to:
  /// **'equals'**
  String get plOpEquals;

  /// No description provided for @plOpStartsWith.
  ///
  /// In en, this message translates to:
  /// **'starts with'**
  String get plOpStartsWith;

  /// No description provided for @plOpEndsWith.
  ///
  /// In en, this message translates to:
  /// **'ends with'**
  String get plOpEndsWith;

  /// No description provided for @plOpGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'greater than'**
  String get plOpGreaterThan;

  /// No description provided for @plOpLessThan.
  ///
  /// In en, this message translates to:
  /// **'less than'**
  String get plOpLessThan;

  /// No description provided for @plOpIs.
  ///
  /// In en, this message translates to:
  /// **'is'**
  String get plOpIs;

  /// No description provided for @plOpIsNot.
  ///
  /// In en, this message translates to:
  /// **'is not'**
  String get plOpIsNot;

  /// No description provided for @srvConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Server configuration'**
  String get srvConfigTitle;

  /// No description provided for @srvFolderAdded.
  ///
  /// In en, this message translates to:
  /// **'Folder added: {path}'**
  String srvFolderAdded(String path);

  /// No description provided for @srvRemoveFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this folder?'**
  String get srvRemoveFolderTitle;

  /// No description provided for @srvScanStarted.
  ///
  /// In en, this message translates to:
  /// **'Scan started: {path}'**
  String srvScanStarted(String path);

  /// No description provided for @srvFullScanStarted.
  ///
  /// In en, this message translates to:
  /// **'Full scan started'**
  String get srvFullScanStarted;

  /// No description provided for @srvRestartTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart the server?'**
  String get srvRestartTitle;

  /// No description provided for @srvRestartBody.
  ///
  /// In en, this message translates to:
  /// **'The server will be stopped and restarted. Current playback will be interrupted.'**
  String get srvRestartBody;

  /// No description provided for @srvRestartBtn.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get srvRestartBtn;

  /// No description provided for @srvRestarting.
  ///
  /// In en, this message translates to:
  /// **'Server restarting…'**
  String get srvRestarting;

  /// No description provided for @srvRestartInProgress.
  ///
  /// In en, this message translates to:
  /// **'Restart in progress…'**
  String get srvRestartInProgress;

  /// No description provided for @srvLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get srvLoadError;

  /// No description provided for @srvScanFolderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Scan this folder'**
  String get srvScanFolderTooltip;

  /// No description provided for @srvSectionServerInfo.
  ///
  /// In en, this message translates to:
  /// **'Server information'**
  String get srvSectionServerInfo;

  /// No description provided for @srvInfoVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get srvInfoVersion;

  /// No description provided for @srvInfoEngine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get srvInfoEngine;

  /// No description provided for @srvInfoDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get srvInfoDatabase;

  /// No description provided for @srvSectionActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get srvSectionActions;

  /// No description provided for @srvRestartServer.
  ///
  /// In en, this message translates to:
  /// **'Restart server'**
  String get srvRestartServer;

  /// No description provided for @srvRestartServerDesc.
  ///
  /// In en, this message translates to:
  /// **'Stops and relaunches the server process'**
  String get srvRestartServerDesc;

  /// No description provided for @srvManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get srvManualEntry;

  /// No description provided for @srvSelectPath.
  ///
  /// In en, this message translates to:
  /// **'Select \"{path}\"'**
  String srvSelectPath(String path);

  /// No description provided for @srvBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse…'**
  String get srvBrowse;

  /// No description provided for @srvFolderPathHint.
  ///
  /// In en, this message translates to:
  /// **'/path/to/music'**
  String get srvFolderPathHint;

  /// No description provided for @srvFolderPathHelp.
  ///
  /// In en, this message translates to:
  /// **'Enter the absolute path of the folder on the server.'**
  String get srvFolderPathHelp;

  /// No description provided for @srvNoSubfolders.
  ///
  /// In en, this message translates to:
  /// **'No subfolders'**
  String get srvNoSubfolders;

  /// No description provided for @srvPluginsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plugins'**
  String get srvPluginsTitle;

  /// No description provided for @srvNotConnectedToServer.
  ///
  /// In en, this message translates to:
  /// **'Not connected to the server'**
  String get srvNotConnectedToServer;

  /// No description provided for @srvPluginInstalled.
  ///
  /// In en, this message translates to:
  /// **'{name} installed'**
  String srvPluginInstalled(String name);

  /// No description provided for @srvPluginUninstalled.
  ///
  /// In en, this message translates to:
  /// **'{name} uninstalled'**
  String srvPluginUninstalled(String name);

  /// No description provided for @srvPluginUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name} updated'**
  String srvPluginUpdated(String name);

  /// No description provided for @srvPluginEnabled.
  ///
  /// In en, this message translates to:
  /// **'{name} enabled'**
  String srvPluginEnabled(String name);

  /// No description provided for @srvPluginDisabled.
  ///
  /// In en, this message translates to:
  /// **'{name} disabled'**
  String srvPluginDisabled(String name);

  /// No description provided for @srvPluginInstallFailed.
  ///
  /// In en, this message translates to:
  /// **'Install failed: {error}'**
  String srvPluginInstallFailed(String error);

  /// No description provided for @srvPluginUninstallFailed.
  ///
  /// In en, this message translates to:
  /// **'Uninstall failed: {error}'**
  String srvPluginUninstallFailed(String error);

  /// No description provided for @srvPluginUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String srvPluginUpdateFailed(String error);

  /// No description provided for @srvPluginsTabStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get srvPluginsTabStore;

  /// No description provided for @srvPluginsTabInstalled.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get srvPluginsTabInstalled;

  /// No description provided for @srvRestartRequired.
  ///
  /// In en, this message translates to:
  /// **'Restart required to apply changes'**
  String get srvRestartRequired;

  /// No description provided for @srvPluginsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search plugins…'**
  String get srvPluginsSearchHint;

  /// No description provided for @srvPluginsNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No plugins found'**
  String get srvPluginsNoneFound;

  /// No description provided for @srvPluginsNoneInstalled.
  ///
  /// In en, this message translates to:
  /// **'No plugins installed'**
  String get srvPluginsNoneInstalled;

  /// No description provided for @srvPluginsBrowseStore.
  ///
  /// In en, this message translates to:
  /// **'Browse the Store'**
  String get srvPluginsBrowseStore;

  /// No description provided for @srvPluginBadgeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get srvPluginBadgeFeatured;

  /// No description provided for @srvPluginBadgeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get srvPluginBadgeUpdate;

  /// No description provided for @srvPluginBadgeIncompatible.
  ///
  /// In en, this message translates to:
  /// **'Incompatible'**
  String get srvPluginBadgeIncompatible;

  /// No description provided for @srvPluginByAuthor.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String srvPluginByAuthor(String author);

  /// No description provided for @srvPluginActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get srvPluginActionUpdate;

  /// No description provided for @srvPluginActionInstall.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get srvPluginActionInstall;

  /// No description provided for @srvPluginActionUninstall.
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get srvPluginActionUninstall;

  /// No description provided for @srvPluginStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get srvPluginStatusActive;

  /// No description provided for @srvPluginStatusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get srvPluginStatusError;

  /// No description provided for @srvAutoFixTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-fix metadata'**
  String get srvAutoFixTitle;

  /// No description provided for @srvAutoFixApplied.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 fix applied} other{{count} fixes applied}}'**
  String srvAutoFixApplied(int count);

  /// No description provided for @srvAutoFixNoHighConfidence.
  ///
  /// In en, this message translates to:
  /// **'No high-confidence fixes left'**
  String get srvAutoFixNoHighConfidence;

  /// No description provided for @srvAutoFixRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 suggestion left} other{{count} suggestions left}}'**
  String srvAutoFixRemaining(int count);

  /// No description provided for @srvAutoFixApplyHighConf.
  ///
  /// In en, this message translates to:
  /// **'Apply high confidence'**
  String get srvAutoFixApplyHighConf;

  /// No description provided for @srvAutoFixTrackNumber.
  ///
  /// In en, this message translates to:
  /// **'Track #{id}'**
  String srvAutoFixTrackNumber(int id);

  /// No description provided for @srvAutoFixCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get srvAutoFixCurrent;

  /// No description provided for @srvAutoFixEmpty.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get srvAutoFixEmpty;

  /// No description provided for @srvAutoFixSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get srvAutoFixSuggested;

  /// No description provided for @srvAutoFixSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get srvAutoFixSkip;

  /// No description provided for @srvAutoFixApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get srvAutoFixApply;

  /// No description provided for @srvAutoFixIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Fix missing metadata'**
  String get srvAutoFixIntroTitle;

  /// No description provided for @srvAutoFixIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Scans tracks with a missing genre, year or MusicBrainz ID and suggests fixes from MusicBrainz.'**
  String get srvAutoFixIntroBody;

  /// No description provided for @srvAutoFixStartScan.
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get srvAutoFixStartScan;

  /// No description provided for @srvAutoFixScanning.
  ///
  /// In en, this message translates to:
  /// **'Searching MusicBrainz…'**
  String get srvAutoFixScanning;

  /// No description provided for @srvAutoFixProgress.
  ///
  /// In en, this message translates to:
  /// **'{processed} / {total} tracks ({pct}%)'**
  String srvAutoFixProgress(int processed, int total, int pct);

  /// No description provided for @srvAutoFixLoadingTracks.
  ///
  /// In en, this message translates to:
  /// **'Loading tracks…'**
  String get srvAutoFixLoadingTracks;

  /// No description provided for @srvAutoFixFoundSoFar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 fix found so far} other{{count} fixes found so far}}'**
  String srvAutoFixFoundSoFar(int count);

  /// No description provided for @srvAutoFixRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Limited to 1 request/s (MusicBrainz policy)'**
  String get srvAutoFixRateLimit;

  /// No description provided for @srvAutoFixNoneNeeded.
  ///
  /// In en, this message translates to:
  /// **'No fixes needed'**
  String get srvAutoFixNoneNeeded;

  /// No description provided for @srvAutoFixAllComplete.
  ///
  /// In en, this message translates to:
  /// **'All tracks have complete metadata.'**
  String get srvAutoFixAllComplete;

  /// No description provided for @srvAutoFixScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get srvAutoFixScanAgain;

  /// No description provided for @srvAutoFixScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed'**
  String get srvAutoFixScanFailed;

  /// No description provided for @srvMpStepSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get srvMpStepSetup;

  /// No description provided for @srvMpStepFineTune.
  ///
  /// In en, this message translates to:
  /// **'Fine-tuning'**
  String get srvMpStepFineTune;

  /// No description provided for @srvMpListenTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you listen?'**
  String get srvMpListenTitle;

  /// No description provided for @srvMpListenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The profile will be tailored to your listening setup'**
  String get srvMpListenSubtitle;

  /// No description provided for @srvMpSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get srvMpSpeakers;

  /// No description provided for @srvMpSpeakersSub.
  ///
  /// In en, this message translates to:
  /// **'Listening room'**
  String get srvMpSpeakersSub;

  /// No description provided for @srvMpHeadphones.
  ///
  /// In en, this message translates to:
  /// **'Headphones'**
  String get srvMpHeadphones;

  /// No description provided for @srvMpHeadphonesSub.
  ///
  /// In en, this message translates to:
  /// **'Personal listening'**
  String get srvMpHeadphonesSub;

  /// No description provided for @srvMpRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'How big is the room?'**
  String get srvMpRoomTitle;

  /// No description provided for @srvMpRoomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Affects low frequencies and reverberation'**
  String get srvMpRoomSubtitle;

  /// No description provided for @srvMpRoomSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get srvMpRoomSmall;

  /// No description provided for @srvMpRoomMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get srvMpRoomMedium;

  /// No description provided for @srvMpRoomLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get srvMpRoomLarge;

  /// No description provided for @srvMpPlacementTitle.
  ///
  /// In en, this message translates to:
  /// **'Speaker placement'**
  String get srvMpPlacementTitle;

  /// No description provided for @srvMpPlacementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Placement affects bass reflections'**
  String get srvMpPlacementSubtitle;

  /// No description provided for @srvMpNearWall.
  ///
  /// In en, this message translates to:
  /// **'Near a wall'**
  String get srvMpNearWall;

  /// No description provided for @srvMpFreeStanding.
  ///
  /// In en, this message translates to:
  /// **'Free-standing'**
  String get srvMpFreeStanding;

  /// No description provided for @srvMpTuneSound.
  ///
  /// In en, this message translates to:
  /// **'Adjust the sound'**
  String get srvMpTuneSound;

  /// No description provided for @srvMpCorrectionActive.
  ///
  /// In en, this message translates to:
  /// **'Correction enabled'**
  String get srvMpCorrectionActive;

  /// No description provided for @srvMpCorrectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Applies the profile to the current zone'**
  String get srvMpCorrectionDesc;

  /// No description provided for @srvMpBass.
  ///
  /// In en, this message translates to:
  /// **'Bass'**
  String get srvMpBass;

  /// No description provided for @srvMpBassDesc.
  ///
  /// In en, this message translates to:
  /// **'Weight, warmth, body of the sound'**
  String get srvMpBassDesc;

  /// No description provided for @srvMpBassLow.
  ///
  /// In en, this message translates to:
  /// **'Lean'**
  String get srvMpBassLow;

  /// No description provided for @srvMpBassHigh.
  ///
  /// In en, this message translates to:
  /// **'Heavy'**
  String get srvMpBassHigh;

  /// No description provided for @srvMpMid.
  ///
  /// In en, this message translates to:
  /// **'Voice / Mids'**
  String get srvMpMid;

  /// No description provided for @srvMpMidDesc.
  ///
  /// In en, this message translates to:
  /// **'Presence, clarity, intelligibility'**
  String get srvMpMidDesc;

  /// No description provided for @srvMpMidLow.
  ///
  /// In en, this message translates to:
  /// **'Recessed'**
  String get srvMpMidLow;

  /// No description provided for @srvMpMidHigh.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get srvMpMidHigh;

  /// No description provided for @srvMpTreble.
  ///
  /// In en, this message translates to:
  /// **'Treble'**
  String get srvMpTreble;

  /// No description provided for @srvMpTrebleDesc.
  ///
  /// In en, this message translates to:
  /// **'Brilliance, detail, air in the sound'**
  String get srvMpTrebleDesc;

  /// No description provided for @srvMpTrebleLow.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get srvMpTrebleLow;

  /// No description provided for @srvMpTrebleHigh.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get srvMpTrebleHigh;

  /// No description provided for @srvMpProfileApplied.
  ///
  /// In en, this message translates to:
  /// **'Profile applied'**
  String get srvMpProfileApplied;

  /// No description provided for @srvMpApplying.
  ///
  /// In en, this message translates to:
  /// **'Applying…'**
  String get srvMpApplying;

  /// No description provided for @srvMpApply.
  ///
  /// In en, this message translates to:
  /// **'Apply profile'**
  String get srvMpApply;

  /// No description provided for @srvMpBackToQuestions.
  ///
  /// In en, this message translates to:
  /// **'Back to questions'**
  String get srvMpBackToQuestions;

  /// No description provided for @srvRemoteConfigBody.
  ///
  /// In en, this message translates to:
  /// **'Connect to a Tune server on your network to enjoy every feature.'**
  String get srvRemoteConfigBody;

  /// No description provided for @srvModeStandalone.
  ///
  /// In en, this message translates to:
  /// **'Standalone'**
  String get srvModeStandalone;

  /// No description provided for @srvStandaloneWarning.
  ///
  /// In en, this message translates to:
  /// **'Standalone mode: Party, DJ, synced lyrics, EQ and recommendations are not available. Recommended: use a remote Tune server.'**
  String get srvStandaloneWarning;

  /// No description provided for @srvServerAddress.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get srvServerAddress;

  /// No description provided for @srvNoServerYet.
  ///
  /// In en, this message translates to:
  /// **'No server yet?'**
  String get srvNoServerYet;

  /// No description provided for @srvDownloadServer.
  ///
  /// In en, this message translates to:
  /// **'Download Tune Server: mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).'**
  String get srvDownloadServer;

  /// No description provided for @srvStreamingBody.
  ///
  /// In en, this message translates to:
  /// **'Enable the streaming services you want to use with Tune.'**
  String get srvStreamingBody;

  /// No description provided for @srvStreamingStandaloneWarning.
  ///
  /// In en, this message translates to:
  /// **'Streaming services are not available in standalone mode. Switch to remote server mode to enable them.'**
  String get srvStreamingStandaloneWarning;

  /// No description provided for @srvNoServiceAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services available. Check the server connection.'**
  String get srvNoServiceAvailable;

  /// No description provided for @srvServicesEnabled.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 service enabled} other{{count} services enabled}}'**
  String srvServicesEnabled(int count);

  /// No description provided for @srvServicesConnected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 connected} other{{count} connected}}'**
  String srvServicesConnected(int count);

  /// No description provided for @srvServiceEnabledNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Enabled, not connected'**
  String get srvServiceEnabledNotConnected;

  /// No description provided for @srvAudioCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio check'**
  String get srvAudioCheckTitle;

  /// No description provided for @srvAudioCheckBody.
  ///
  /// In en, this message translates to:
  /// **'Checking your system\'s audio configuration.'**
  String get srvAudioCheckBody;

  /// No description provided for @srvDiagZones.
  ///
  /// In en, this message translates to:
  /// **'Configured zones'**
  String get srvDiagZones;

  /// No description provided for @srvDiagOutputs.
  ///
  /// In en, this message translates to:
  /// **'Audio outputs'**
  String get srvDiagOutputs;

  /// No description provided for @srvDiagOutputsDetected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 detected} other{{count} detected}}'**
  String srvDiagOutputsDetected(int count);

  /// No description provided for @srvDiagNetworkDevices.
  ///
  /// In en, this message translates to:
  /// **'Network devices'**
  String get srvDiagNetworkDevices;

  /// No description provided for @srvDiagNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get srvDiagNone;

  /// No description provided for @srvDiagNoZoneWarning.
  ///
  /// In en, this message translates to:
  /// **'No zone configured. You can create one from the Zones settings.'**
  String get srvDiagNoZoneWarning;

  /// No description provided for @srvAudioCheckUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Audio check unavailable: {error}'**
  String srvAudioCheckUnavailable(String error);

  /// No description provided for @srvRecheck.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get srvRecheck;

  /// No description provided for @srvScanBody.
  ///
  /// In en, this message translates to:
  /// **'Start a scan to index your music files and fetch their metadata.'**
  String get srvScanBody;

  /// No description provided for @srvScanStart.
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get srvScanStart;

  /// No description provided for @srvScanStatScanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get srvScanStatScanned;

  /// No description provided for @srvScanStatAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get srvScanStatAdded;

  /// No description provided for @srvScanStatUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get srvScanStatUpdated;

  /// No description provided for @srvScanMayTakeMinutes.
  ///
  /// In en, this message translates to:
  /// **'This may take a few minutes…'**
  String get srvScanMayTakeMinutes;

  /// No description provided for @srvScanComplete.
  ///
  /// In en, this message translates to:
  /// **'Scan complete!'**
  String get srvScanComplete;

  /// No description provided for @stgUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available: v{version}'**
  String stgUpdateAvailable(String version);

  /// No description provided for @stgCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current version: v{version}'**
  String stgCurrentVersion(String version);

  /// No description provided for @stgOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get stgOpen;

  /// No description provided for @stgMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get stgMode;

  /// No description provided for @stgConnectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {address}'**
  String stgConnectedTo(String address);

  /// No description provided for @stgModeRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get stgModeRemote;

  /// No description provided for @stgStandaloneTitle.
  ///
  /// In en, this message translates to:
  /// **'Standalone mode — limited features'**
  String get stgStandaloneTitle;

  /// No description provided for @stgStandaloneBody.
  ///
  /// In en, this message translates to:
  /// **'Party, DJ, synced lyrics, EQ, album bios, recommendations… require a remote Tune server.'**
  String get stgStandaloneBody;

  /// No description provided for @stgServerAddress.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get stgServerAddress;

  /// No description provided for @stgNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get stgNotConfigured;

  /// No description provided for @stgScanNetwork.
  ///
  /// In en, this message translates to:
  /// **'Scan the network'**
  String get stgScanNetwork;

  /// No description provided for @stgSectionPlayback.
  ///
  /// In en, this message translates to:
  /// **'PLAYBACK'**
  String get stgSectionPlayback;

  /// No description provided for @stgCrossfade.
  ///
  /// In en, this message translates to:
  /// **'Crossfade'**
  String get stgCrossfade;

  /// No description provided for @stgRepeatOneByDefault.
  ///
  /// In en, this message translates to:
  /// **'Repeat by default'**
  String get stgRepeatOneByDefault;

  /// No description provided for @stgExclusiveMode.
  ///
  /// In en, this message translates to:
  /// **'Exclusive mode (bit-perfect)'**
  String get stgExclusiveMode;

  /// No description provided for @stgExclusiveModeDesc.
  ///
  /// In en, this message translates to:
  /// **'WASAPI Exclusive — direct access to the USB DAC'**
  String get stgExclusiveModeDesc;

  /// No description provided for @stgSectionMetadataFields.
  ///
  /// In en, this message translates to:
  /// **'METADATA FIELDS'**
  String get stgSectionMetadataFields;

  /// No description provided for @stgSectionAdvancedAudio.
  ///
  /// In en, this message translates to:
  /// **'ADVANCED AUDIO'**
  String get stgSectionAdvancedAudio;

  /// No description provided for @stgEqualizer.
  ///
  /// In en, this message translates to:
  /// **'Equalizer'**
  String get stgEqualizer;

  /// No description provided for @stgEqualizerDesc.
  ///
  /// In en, this message translates to:
  /// **'Calibration assistant + expert 10-band EQ'**
  String get stgEqualizerDesc;

  /// No description provided for @stgMetadataFieldsDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure extended fields (composer, conductor…)'**
  String get stgMetadataFieldsDesc;

  /// No description provided for @stgSpotifyConnectDesc.
  ///
  /// In en, this message translates to:
  /// **'Tune as a receiver (Premium required on the client)'**
  String get stgSpotifyConnectDesc;

  /// No description provided for @stgLastfmDesc.
  ///
  /// In en, this message translates to:
  /// **'Scrobble your listening history'**
  String get stgLastfmDesc;

  /// No description provided for @stgListenBrainzDesc.
  ///
  /// In en, this message translates to:
  /// **'Scrobble to ListenBrainz'**
  String get stgListenBrainzDesc;

  /// No description provided for @stgAutoFixMetadata.
  ///
  /// In en, this message translates to:
  /// **'Auto-fix metadata'**
  String get stgAutoFixMetadata;

  /// No description provided for @stgAutoFixMetadataDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill in missing genre, year, MBID via MusicBrainz'**
  String get stgAutoFixMetadataDesc;

  /// No description provided for @stgDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get stgDatabase;

  /// No description provided for @stgImportExport.
  ///
  /// In en, this message translates to:
  /// **'Import / Export'**
  String get stgImportExport;

  /// No description provided for @stgSectionProfiles.
  ///
  /// In en, this message translates to:
  /// **'PROFILES'**
  String get stgSectionProfiles;

  /// No description provided for @stgSectionSystem.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM'**
  String get stgSectionSystem;

  /// No description provided for @stgServerConfig.
  ///
  /// In en, this message translates to:
  /// **'Server configuration'**
  String get stgServerConfig;

  /// No description provided for @stgServerConfigDesc.
  ///
  /// In en, this message translates to:
  /// **'Music folders, scan, restart'**
  String get stgServerConfigDesc;

  /// No description provided for @stgNetworkDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Network diagnostics'**
  String get stgNetworkDiagnostics;

  /// No description provided for @stgNetworkDiagnosticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Multicast, DNS, connectivity'**
  String get stgNetworkDiagnosticsDesc;

  /// No description provided for @stgConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get stgConfiguration;

  /// No description provided for @stgExportImport.
  ///
  /// In en, this message translates to:
  /// **'Export / Import'**
  String get stgExportImport;

  /// No description provided for @stgPlugins.
  ///
  /// In en, this message translates to:
  /// **'Plugins'**
  String get stgPlugins;

  /// No description provided for @stgPluginsDesc.
  ///
  /// In en, this message translates to:
  /// **'Installed extensions'**
  String get stgPluginsDesc;

  /// No description provided for @stgNetworkShares.
  ///
  /// In en, this message translates to:
  /// **'Network shares (SMB)'**
  String get stgNetworkShares;

  /// No description provided for @stgNetworkSharesDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover and mount shares'**
  String get stgNetworkSharesDesc;

  /// No description provided for @stgSectionCloud.
  ///
  /// In en, this message translates to:
  /// **'CLOUD'**
  String get stgSectionCloud;

  /// No description provided for @stgSectionHelp.
  ///
  /// In en, this message translates to:
  /// **'HELP'**
  String get stgSectionHelp;

  /// No description provided for @stgTroubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get stgTroubleshooting;

  /// No description provided for @stgTroubleshootingDesc.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions and solutions'**
  String get stgTroubleshootingDesc;

  /// No description provided for @stgSendBugReport.
  ///
  /// In en, this message translates to:
  /// **'Send a bug report'**
  String get stgSendBugReport;

  /// No description provided for @stgSendBugReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate and copy a technical report'**
  String get stgSendBugReportDesc;

  /// No description provided for @stgServerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'IP or hostname (e.g. 192.168.1.18)'**
  String get stgServerAddressHint;

  /// No description provided for @stgServerPort.
  ///
  /// In en, this message translates to:
  /// **'Server port'**
  String get stgServerPort;

  /// No description provided for @stgPortDefaultHint.
  ///
  /// In en, this message translates to:
  /// **'Port (default: 8888)'**
  String get stgPortDefaultHint;

  /// No description provided for @stgWarnNoZones.
  ///
  /// In en, this message translates to:
  /// **'No zone configured. Create one to start playback.'**
  String get stgWarnNoZones;

  /// No description provided for @stgWarnNoNetworkDevices.
  ///
  /// In en, this message translates to:
  /// **'No network device detected (DLNA/BluOS/Chromecast).'**
  String get stgWarnNoNetworkDevices;

  /// No description provided for @stgSectionAudio.
  ///
  /// In en, this message translates to:
  /// **'AUDIO'**
  String get stgSectionAudio;

  /// No description provided for @stgAudioOutputs.
  ///
  /// In en, this message translates to:
  /// **'Audio outputs'**
  String get stgAudioOutputs;

  /// No description provided for @stgOutputsDetected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 detected} other{{count} detected}}'**
  String stgOutputsDetected(int count);

  /// No description provided for @stgNetworkDevices.
  ///
  /// In en, this message translates to:
  /// **'Network devices'**
  String get stgNetworkDevices;

  /// No description provided for @stgZoneNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Living room, Office'**
  String get stgZoneNameHint;

  /// No description provided for @stgProfileActivated.
  ///
  /// In en, this message translates to:
  /// **'Profile activated'**
  String get stgProfileActivated;

  /// No description provided for @stgNewProfile.
  ///
  /// In en, this message translates to:
  /// **'New profile'**
  String get stgNewProfile;

  /// No description provided for @stgProfileName.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get stgProfileName;

  /// No description provided for @stgProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Evening, Morning'**
  String get stgProfileNameHint;

  /// No description provided for @stgProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get stgProfileUpdated;

  /// No description provided for @stgNoProfiles.
  ///
  /// In en, this message translates to:
  /// **'No profiles'**
  String get stgNoProfiles;

  /// No description provided for @stgProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get stgProfile;

  /// No description provided for @stgEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get stgEditProfile;

  /// No description provided for @stgName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get stgName;

  /// No description provided for @stgColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get stgColor;

  /// No description provided for @stgScanInProgress.
  ///
  /// In en, this message translates to:
  /// **'Scanning the network…'**
  String get stgScanInProgress;

  /// No description provided for @stgScanChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking {scanned}/{total}…'**
  String stgScanChecking(int scanned, int total);

  /// No description provided for @stgNoServerFound.
  ///
  /// In en, this message translates to:
  /// **'No Tune server found'**
  String get stgNoServerFound;

  /// No description provided for @stgServersFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 server found} other{{count} servers found}}'**
  String stgServersFound(int count);

  /// No description provided for @stgTuneServers.
  ///
  /// In en, this message translates to:
  /// **'Tune servers'**
  String get stgTuneServers;

  /// No description provided for @stgFieldFormat.
  ///
  /// In en, this message translates to:
  /// **'Format (FLAC, MP3…)'**
  String get stgFieldFormat;

  /// No description provided for @stgFieldSampleRate.
  ///
  /// In en, this message translates to:
  /// **'Sample rate (96 kHz)'**
  String get stgFieldSampleRate;

  /// No description provided for @stgFieldBitDepth.
  ///
  /// In en, this message translates to:
  /// **'Bit depth (24-bit)'**
  String get stgFieldBitDepth;

  /// No description provided for @stgFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get stgFieldLabel;

  /// No description provided for @stgFieldComposer.
  ///
  /// In en, this message translates to:
  /// **'Composer'**
  String get stgFieldComposer;

  /// No description provided for @stgFieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get stgFieldDuration;

  /// No description provided for @stgFieldSource.
  ///
  /// In en, this message translates to:
  /// **'Source (Tidal, Qobuz…)'**
  String get stgFieldSource;

  /// No description provided for @stgMetadataFieldsIntro.
  ///
  /// In en, this message translates to:
  /// **'Fields shown under each track (search, library, queue, history)'**
  String get stgMetadataFieldsIntro;

  /// No description provided for @stgAudiophileMode.
  ///
  /// In en, this message translates to:
  /// **'Audiophile mode'**
  String get stgAudiophileMode;

  /// No description provided for @stgAudiophileModeDesc.
  ///
  /// In en, this message translates to:
  /// **'DSP bypass, EQ disabled, bit-perfect'**
  String get stgAudiophileModeDesc;

  /// No description provided for @stgCloudAccount.
  ///
  /// In en, this message translates to:
  /// **'Cloud account'**
  String get stgCloudAccount;

  /// No description provided for @stgConnectedAs.
  ///
  /// In en, this message translates to:
  /// **'Connected ({email})'**
  String stgConnectedAs(String email);

  /// No description provided for @stgTelemetry.
  ///
  /// In en, this message translates to:
  /// **'Telemetry'**
  String get stgTelemetry;

  /// No description provided for @stgTelemetryDesc.
  ///
  /// In en, this message translates to:
  /// **'Send anonymous usage statistics'**
  String get stgTelemetryDesc;

  /// No description provided for @stgSyncingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Syncing library…'**
  String get stgSyncingLibrary;

  /// No description provided for @stgScanProgressTracks.
  ///
  /// In en, this message translates to:
  /// **'{progress} / {total} tracks'**
  String stgScanProgressTracks(int progress, int total);

  /// No description provided for @stgConnectingStreaming.
  ///
  /// In en, this message translates to:
  /// **'Connecting to streaming services…'**
  String get stgConnectingStreaming;

  /// No description provided for @stgWhatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New in v{version}'**
  String stgWhatsNewTitle(String version);

  /// No description provided for @stgWhatsNewLibrarySync.
  ///
  /// In en, this message translates to:
  /// **'Improved library sync'**
  String get stgWhatsNewLibrarySync;

  /// No description provided for @stgWhatsNewMultiRoom.
  ///
  /// In en, this message translates to:
  /// **'Optimized multi-room and zone management'**
  String get stgWhatsNewMultiRoom;

  /// No description provided for @stgWhatsNewBugFixes.
  ///
  /// In en, this message translates to:
  /// **'Bug fixes and stability improvements'**
  String get stgWhatsNewBugFixes;

  /// No description provided for @stgStartServerFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start the server'**
  String get stgStartServerFailed;

  /// No description provided for @stgStartServerFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Failed to start the server: {detail}'**
  String stgStartServerFailedWith(String detail);

  /// No description provided for @stgConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get stgConnectionFailed;

  /// No description provided for @stgConnectionFailedWith.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {detail}'**
  String stgConnectionFailedWith(String detail);

  /// No description provided for @stgStartingServer.
  ///
  /// In en, this message translates to:
  /// **'Starting Tune Server…'**
  String get stgStartingServer;

  /// No description provided for @stgTagline.
  ///
  /// In en, this message translates to:
  /// **'Multi-room music server'**
  String get stgTagline;

  /// No description provided for @stgLocalServer.
  ///
  /// In en, this message translates to:
  /// **'Local server'**
  String get stgLocalServer;

  /// No description provided for @stgLocalServerDesc.
  ///
  /// In en, this message translates to:
  /// **'Run Tune on this device.\nYour music, your rules.'**
  String get stgLocalServerDesc;

  /// No description provided for @stgRemoteControl.
  ///
  /// In en, this message translates to:
  /// **'Remote control'**
  String get stgRemoteControl;

  /// No description provided for @stgRemoteControlDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect to a Tune server\non your network.'**
  String get stgRemoteControlDesc;

  /// No description provided for @stgRemoteConnection.
  ///
  /// In en, this message translates to:
  /// **'Remote connection'**
  String get stgRemoteConnection;

  /// No description provided for @znZoneManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Zone Manager'**
  String get znZoneManagerTitle;

  /// No description provided for @znCannotDeleteLastZone.
  ///
  /// In en, this message translates to:
  /// **'The last zone cannot be deleted'**
  String get znCannotDeleteLastZone;

  /// No description provided for @znZoneSwitchError.
  ///
  /// In en, this message translates to:
  /// **'Could not switch zone: {error}'**
  String znZoneSwitchError(String error);

  /// No description provided for @znZoneSettings.
  ///
  /// In en, this message translates to:
  /// **'Zone settings'**
  String get znZoneSettings;

  /// No description provided for @znPhoneSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Phone speakers'**
  String get znPhoneSpeakers;

  /// No description provided for @znBtConnectedOutputs.
  ///
  /// In en, this message translates to:
  /// **'Connected Bluetooth outputs'**
  String get znBtConnectedOutputs;

  /// No description provided for @znBtSystemOutput.
  ///
  /// In en, this message translates to:
  /// **'Uses the system output (Control Center)'**
  String get znBtSystemOutput;

  /// No description provided for @znBtOutputsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth outputs'**
  String get znBtOutputsTitle;

  /// No description provided for @znBtNoDevice.
  ///
  /// In en, this message translates to:
  /// **'No Bluetooth device connected. Pair a device in the system settings.'**
  String get znBtNoDevice;

  /// No description provided for @znBtAndroidRouting.
  ///
  /// In en, this message translates to:
  /// **'Active routing depends on the Android system settings.'**
  String get znBtAndroidRouting;

  /// No description provided for @znDsdMode.
  ///
  /// In en, this message translates to:
  /// **'DSD mode'**
  String get znDsdMode;

  /// No description provided for @znDsdAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get znDsdAuto;

  /// No description provided for @znDsdNative.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get znDsdNative;

  /// No description provided for @znGaplessDlnaDesc.
  ///
  /// In en, this message translates to:
  /// **'Seamless transitions between tracks (DLNA)'**
  String get znGaplessDlnaDesc;

  /// No description provided for @znFixedVolume.
  ///
  /// In en, this message translates to:
  /// **'Fixed volume'**
  String get znFixedVolume;

  /// No description provided for @znFixedVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Disables software volume control'**
  String get znFixedVolumeDesc;

  /// No description provided for @znCap16Bit.
  ///
  /// In en, this message translates to:
  /// **'Limit to 16 bits'**
  String get znCap16Bit;

  /// No description provided for @znCap16BitDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn on if hi-res (24-bit) stays silent while 16-bit plays (Ruark R3). Converts to 16-bit FLAC.'**
  String get znCap16BitDesc;

  /// No description provided for @znZoneMuted.
  ///
  /// In en, this message translates to:
  /// **'Zone muted'**
  String get znZoneMuted;

  /// No description provided for @znZoneUnmuted.
  ///
  /// In en, this message translates to:
  /// **'Zone unmuted'**
  String get znZoneUnmuted;

  /// No description provided for @znErrMute.
  ///
  /// In en, this message translates to:
  /// **'Mute error: {error}'**
  String znErrMute(String error);

  /// No description provided for @znErrVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume error: {error}'**
  String znErrVolume(String error);

  /// No description provided for @znErrLatency.
  ///
  /// In en, this message translates to:
  /// **'Latency error: {error}'**
  String znErrLatency(String error);

  /// No description provided for @znErrGroupVolume.
  ///
  /// In en, this message translates to:
  /// **'Group volume error: {error}'**
  String znErrGroupVolume(String error);

  /// No description provided for @znCalibrationDone.
  ///
  /// In en, this message translates to:
  /// **'Calibration complete'**
  String get znCalibrationDone;

  /// No description provided for @znErrCalibration.
  ///
  /// In en, this message translates to:
  /// **'Calibration error: {error}'**
  String znErrCalibration(String error);

  /// No description provided for @znErrDissolve.
  ///
  /// In en, this message translates to:
  /// **'Could not dissolve group: {error}'**
  String znErrDissolve(String error);

  /// No description provided for @znRenameGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename group'**
  String get znRenameGroupTitle;

  /// No description provided for @znNewNameHint.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get znNewNameHint;

  /// No description provided for @znRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get znRename;

  /// No description provided for @znGroupRenamed.
  ///
  /// In en, this message translates to:
  /// **'Group renamed'**
  String get znGroupRenamed;

  /// No description provided for @znErrRename.
  ///
  /// In en, this message translates to:
  /// **'Rename error: {error}'**
  String znErrRename(String error);

  /// No description provided for @znGroupNeedTwoZones.
  ///
  /// In en, this message translates to:
  /// **'At least 2 zones are needed to create a group'**
  String get znGroupNeedTwoZones;

  /// No description provided for @znGroupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get znGroupNameLabel;

  /// No description provided for @znGroupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Living room + Kitchen'**
  String get znGroupNameHint;

  /// No description provided for @znChooseLeader.
  ///
  /// In en, this message translates to:
  /// **'Choose the leader'**
  String get znChooseLeader;

  /// No description provided for @znMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get znMembers;

  /// No description provided for @znErrCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Could not create group: {error}'**
  String znErrCreateGroup(String error);

  /// No description provided for @znProfileActivated.
  ///
  /// In en, this message translates to:
  /// **'Profile activated'**
  String get znProfileActivated;

  /// No description provided for @znErrActivate.
  ///
  /// In en, this message translates to:
  /// **'Activation error: {error}'**
  String znErrActivate(String error);

  /// No description provided for @znProfileDeleted.
  ///
  /// In en, this message translates to:
  /// **'Profile deleted'**
  String get znProfileDeleted;

  /// No description provided for @znErrDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete error: {error}'**
  String znErrDelete(String error);

  /// No description provided for @znNoOfflineZones.
  ///
  /// In en, this message translates to:
  /// **'No offline zones to remove'**
  String get znNoOfflineZones;

  /// No description provided for @znOfflineZonesRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 offline zone removed} other{{count} offline zones removed}}'**
  String znOfflineZonesRemoved(int count);

  /// No description provided for @znErrCleanup.
  ///
  /// In en, this message translates to:
  /// **'Cleanup error: {error}'**
  String znErrCleanup(String error);

  /// No description provided for @znSaveConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Save configuration'**
  String get znSaveConfigTitle;

  /// No description provided for @znProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get znProfileNameLabel;

  /// No description provided for @znProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Party, Quiet morning'**
  String get znProfileNameHint;

  /// No description provided for @znDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get znDescriptionOptional;

  /// No description provided for @znNameRequired.
  ///
  /// In en, this message translates to:
  /// **'A name is required'**
  String get znNameRequired;

  /// No description provided for @znProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get znProfileSaved;

  /// No description provided for @znErrSave.
  ///
  /// In en, this message translates to:
  /// **'Save error: {error}'**
  String znErrSave(String error);

  /// No description provided for @znCleanupOffline.
  ///
  /// In en, this message translates to:
  /// **'Clean up offline zones'**
  String get znCleanupOffline;

  /// No description provided for @znRemoteRequired.
  ///
  /// In en, this message translates to:
  /// **'Zone Manager requires a connection to a remote server.'**
  String get znRemoteRequired;

  /// No description provided for @znDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Data unavailable'**
  String get znDataUnavailable;

  /// No description provided for @znGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get znGroups;

  /// No description provided for @znNoGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups'**
  String get znNoGroups;

  /// No description provided for @znGroupFallback.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get znGroupFallback;

  /// No description provided for @znZoneFallback.
  ///
  /// In en, this message translates to:
  /// **'Zone {id}'**
  String znZoneFallback(String id);

  /// No description provided for @znCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Calibrate'**
  String get znCalibrate;

  /// No description provided for @znDissolve.
  ///
  /// In en, this message translates to:
  /// **'Dissolve'**
  String get znDissolve;

  /// No description provided for @znProfiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get znProfiles;

  /// No description provided for @znNoProfiles.
  ///
  /// In en, this message translates to:
  /// **'No saved profiles'**
  String get znNoProfiles;

  /// No description provided for @znSaveConfigButton.
  ///
  /// In en, this message translates to:
  /// **'Save config'**
  String get znSaveConfigButton;

  /// No description provided for @znProfileFallback.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get znProfileFallback;

  /// No description provided for @znPins.
  ///
  /// In en, this message translates to:
  /// **'Pins'**
  String get znPins;

  /// No description provided for @znPinFallback.
  ///
  /// In en, this message translates to:
  /// **'Pin {n}'**
  String znPinFallback(int n);

  /// No description provided for @znPinInvoked.
  ///
  /// In en, this message translates to:
  /// **'Pin {n} launched'**
  String znPinInvoked(int n);

  /// No description provided for @znPinInvokeError.
  ///
  /// In en, this message translates to:
  /// **'Could not launch pin: {error}'**
  String znPinInvokeError(String error);

  /// No description provided for @znNoPins.
  ///
  /// In en, this message translates to:
  /// **'No pins configured'**
  String get znNoPins;

  /// No description provided for @znMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get znMute;

  /// No description provided for @znUnmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get znUnmute;

  /// No description provided for @znLatency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get znLatency;

  /// No description provided for @znLatencyError.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get znLatencyError;

  /// No description provided for @znPartyAddError.
  ///
  /// In en, this message translates to:
  /// **'Could not add track: {error}'**
  String znPartyAddError(String error);

  /// No description provided for @znPartyVoteError.
  ///
  /// In en, this message translates to:
  /// **'Vote error: {error}'**
  String znPartyVoteError(String error);

  /// No description provided for @znPartyLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Party link copied to clipboard'**
  String get znPartyLinkCopied;

  /// No description provided for @znPartyTitle.
  ///
  /// In en, this message translates to:
  /// **'Party Mode'**
  String get znPartyTitle;

  /// No description provided for @znPartyShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share party link'**
  String get znPartyShareLink;

  /// No description provided for @znPartyAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a track…'**
  String get znPartyAddHint;

  /// No description provided for @znPartyQueue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get znPartyQueue;

  /// No description provided for @znTrackCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 track} other{{count} tracks}}'**
  String znTrackCount(int count);

  /// No description provided for @znUnknownZone.
  ///
  /// In en, this message translates to:
  /// **'Unknown zone'**
  String get znUnknownZone;

  /// No description provided for @znUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get znUnknownTitle;

  /// No description provided for @znNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get znNowPlaying;

  /// No description provided for @znUpvote.
  ///
  /// In en, this message translates to:
  /// **'Upvote'**
  String get znUpvote;

  /// No description provided for @znDjLoadOnDeck.
  ///
  /// In en, this message translates to:
  /// **'Load track on deck {deck}'**
  String znDjLoadOnDeck(String deck);

  /// No description provided for @znDjSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tracks…'**
  String get znDjSearchHint;

  /// No description provided for @znDjSearchHelp.
  ///
  /// In en, this message translates to:
  /// **'Enter a track name, then tap Search & load'**
  String get znDjSearchHelp;

  /// No description provided for @znDjNoTracksFound.
  ///
  /// In en, this message translates to:
  /// **'No tracks found'**
  String get znDjNoTracksFound;

  /// No description provided for @znDjSearchError.
  ///
  /// In en, this message translates to:
  /// **'Search error: {error}'**
  String znDjSearchError(String error);

  /// No description provided for @znDjSearchAndLoad.
  ///
  /// In en, this message translates to:
  /// **'Search & load'**
  String get znDjSearchAndLoad;

  /// No description provided for @znDjLoadError.
  ///
  /// In en, this message translates to:
  /// **'Load error: {error}'**
  String znDjLoadError(String error);

  /// No description provided for @znDjPlayError.
  ///
  /// In en, this message translates to:
  /// **'Playback error: {error}'**
  String znDjPlayError(String error);

  /// No description provided for @znDjPauseError.
  ///
  /// In en, this message translates to:
  /// **'Pause error: {error}'**
  String znDjPauseError(String error);

  /// No description provided for @znDjCrossfadeError.
  ///
  /// In en, this message translates to:
  /// **'Crossfade error: {error}'**
  String znDjCrossfadeError(String error);

  /// No description provided for @znDjTitle.
  ///
  /// In en, this message translates to:
  /// **'DJ Mode'**
  String get znDjTitle;

  /// No description provided for @znDjDisabled.
  ///
  /// In en, this message translates to:
  /// **'DJ Mode is off'**
  String get znDjDisabled;

  /// No description provided for @znDjEnableHint.
  ///
  /// In en, this message translates to:
  /// **'Turn it on to start mixing'**
  String get znDjEnableHint;

  /// No description provided for @znDjDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck {deck}'**
  String znDjDeck(String deck);

  /// No description provided for @znDjCrossfade.
  ///
  /// In en, this message translates to:
  /// **'Crossfade'**
  String get znDjCrossfade;

  /// No description provided for @znDjDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {seconds} s'**
  String znDjDuration(String seconds);

  /// No description provided for @znDjStartCrossfade.
  ///
  /// In en, this message translates to:
  /// **'Start crossfade'**
  String get znDjStartCrossfade;

  /// No description provided for @znDjAutoCrossfade.
  ///
  /// In en, this message translates to:
  /// **'Auto crossfade'**
  String get znDjAutoCrossfade;

  /// No description provided for @znDjSyncBpm.
  ///
  /// In en, this message translates to:
  /// **'Sync {bpmFrom} → {bpmTo} BPM'**
  String znDjSyncBpm(int bpmFrom, int bpmTo);

  /// No description provided for @znDjSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get znDjSyncFailed;

  /// No description provided for @znDjNoTrackLoaded.
  ///
  /// In en, this message translates to:
  /// **'No track loaded'**
  String get znDjNoTrackLoaded;

  /// No description provided for @znDjLoadTrack.
  ///
  /// In en, this message translates to:
  /// **'Load track'**
  String get znDjLoadTrack;

  /// No description provided for @znDjGain.
  ///
  /// In en, this message translates to:
  /// **'Gain'**
  String get znDjGain;

  /// No description provided for @cfgSizeBytes.
  ///
  /// In en, this message translates to:
  /// **'{size} B'**
  String cfgSizeBytes(String size);

  /// No description provided for @cfgSizeKilobytes.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String cfgSizeKilobytes(String size);

  /// No description provided for @cfgSizeMegabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String cfgSizeMegabytes(String size);

  /// No description provided for @plPremiumTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transferring a playlist between services, or from a service to the library, is part of Tune Premium. Duplicating a library playlist stays free.'**
  String get plPremiumTransfer;

  /// No description provided for @plPremiumConverter.
  ///
  /// In en, this message translates to:
  /// **'Dated playlist copies and playlist sync links are part of Tune Premium.'**
  String get plPremiumConverter;

  /// No description provided for @plConverterMissing.
  ///
  /// In en, this message translates to:
  /// **'The Playlists converter plugin is not loaded on this server.'**
  String get plConverterMissing;

  /// No description provided for @plSeeOffer.
  ///
  /// In en, this message translates to:
  /// **'See the offer'**
  String get plSeeOffer;

  /// No description provided for @plSnapshotsNoDelete.
  ///
  /// In en, this message translates to:
  /// **'The last 10 copies of each playlist are kept; the oldest one is replaced automatically.'**
  String get plSnapshotsNoDelete;

  /// No description provided for @plBackupAllDone.
  ///
  /// In en, this message translates to:
  /// **'{ok} playlists backed up, {failed} failed.'**
  String plBackupAllDone(int ok, int failed);

  /// No description provided for @plRestoreRecreateAsk.
  ///
  /// In en, this message translates to:
  /// **'Recreate “{name}” from its most recent copy? The current playlist is neither changed nor deleted.'**
  String plRestoreRecreateAsk(String name);

  /// No description provided for @plRestoreRecreated.
  ///
  /// In en, this message translates to:
  /// **'“{name}” recreated from its most recent copy.'**
  String plRestoreRecreated(String name);

  /// No description provided for @plSnapshotCopies.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 copy} other{{count} copies}}'**
  String plSnapshotCopies(int count);

  /// No description provided for @plIntervalAdjusted.
  ///
  /// In en, this message translates to:
  /// **'Interval set to {minutes} min (15 min to one week, or 0 for on demand).'**
  String plIntervalAdjusted(int minutes);

  /// No description provided for @plLinkSyncDone.
  ///
  /// In en, this message translates to:
  /// **'Sync done: {count, plural, =0{no track added} =1{1 track added} other{{count} tracks added}}.'**
  String plLinkSyncDone(int count);
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
    'hu',
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
    case 'hu':
      return AppLocalizationsHu();
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
