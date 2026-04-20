// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => 'OK';

  @override
  String get btnCancel => 'キャンセル';

  @override
  String get btnAdd => '追加';

  @override
  String get btnSave => '保存';

  @override
  String get btnDelete => '削除';

  @override
  String get btnEdit => '編集';

  @override
  String get btnClose => '閉じる';

  @override
  String get btnRetry => '再試行';

  @override
  String get btnCreate => '作成';

  @override
  String get btnClear => '消去';

  @override
  String get btnNext => '次へ';

  @override
  String get btnSkip => 'このステップをスキップ';

  @override
  String get btnFinish => '設定を完了';

  @override
  String get btnStart => '始める';

  @override
  String get btnConnect => '接続';

  @override
  String get btnDisconnect => '切断';

  @override
  String get btnDownload => 'ダウンロード';

  @override
  String get btnImport => 'インポート';

  @override
  String get btnExport => 'エクスポート';

  @override
  String get btnReset => 'リセット';

  @override
  String get btnUse => '使用';

  @override
  String get btnShuffle => 'シャッフル';

  @override
  String get btnSeeAll => 'すべて表示';

  @override
  String get btnRefresh => '更新';

  @override
  String get btnScan => 'ライブラリをスキャン';

  @override
  String get btnAddFolder => 'フォルダを追加';

  @override
  String get actionIrreversible => 'この操作は元に戻せません。';

  @override
  String get rootStartError => '起動エラー';

  @override
  String get playbackErrorNoZone => 'ゾーンが選択されていません — ゾーンを作成または選択してください';

  @override
  String get playbackErrorZoneNotFound => 'ゾーンが見つかりません';

  @override
  String get playbackErrorFailed => '再生に失敗しました';

  @override
  String get navLibrary => 'ライブラリ';

  @override
  String get navSearch => '検索';

  @override
  String get navStreaming => 'ストリーミング';

  @override
  String get navRadios => 'ラジオ';

  @override
  String get navZones => 'ゾーン';

  @override
  String get navSettings => '設定';

  @override
  String get libraryTitle => 'ライブラリ';

  @override
  String get tabAlbums => 'アルバム';

  @override
  String get tabArtists => 'アーティスト';

  @override
  String get tabTracks => '曲';

  @override
  String get tabGenres => 'ジャンル';

  @override
  String get tabPlaylists => 'プレイリスト';

  @override
  String get tabFavorites => 'お気に入り';

  @override
  String get favoriteAdded => 'お気に入りに追加しました';

  @override
  String get favoriteRemoved => 'お気に入りから削除しました';

  @override
  String get libraryEmptyFavorites => 'お気に入りなし';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => 'ライブラリにアルバムがありません';

  @override
  String get libraryEmptyArtists => 'ライブラリにアーティストがありません';

  @override
  String get libraryEmptyTracks => 'ライブラリに曲がありません';

  @override
  String get libraryEmptyGenres => 'ジャンルなし';

  @override
  String get libraryEmptyPlaylists => 'プレイリストなし';

  @override
  String get libraryNoFilterResults => 'フィルターに一致するアルバムがありません';

  @override
  String get libraryPlayAll => 'すべて再生';

  @override
  String get libraryAddTo => '追加先…';

  @override
  String get libraryEditAlbum => 'アルバムを編集';

  @override
  String get libraryEditTrack => '曲を編集';

  @override
  String get libraryPlay => '再生';

  @override
  String get genresAllTracks => 'すべての曲';

  @override
  String get playlistCreate => 'プレイリストを作成';

  @override
  String get playlistName => 'プレイリスト名';

  @override
  String get playlistEmpty => '曲なし';

  @override
  String get playlistAddTo => 'プレイリストに追加';

  @override
  String get playlistNewPlaylist => '新規プレイリスト';

  @override
  String playlistTrackAdded(String name) {
    return '「$name」に追加しました';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return 'すでに「$name」にあります';
  }

  @override
  String get playlistDeleteTitle => 'プレイリストを削除？';

  @override
  String get playlistDeleteBody => 'このプレイリストは完全に削除されます。';

  @override
  String get searchHint => '検索…';

  @override
  String get searchNoResults => '結果なし';

  @override
  String get searchSectionTracks => '曲';

  @override
  String get searchSectionAlbums => 'アルバム';

  @override
  String get searchSectionArtists => 'アーティスト';

  @override
  String get searchSectionStreaming => 'ストリーミング';

  @override
  String get homeRecentlyPlayed => '最近再生した曲';

  @override
  String get homeLibrary => 'ライブラリ';

  @override
  String get homeQuickAccess => 'クイックアクセス';

  @override
  String get homeHistory => '履歴';

  @override
  String get homeBrowseDlna => 'DLNAを参照';

  @override
  String get homeStatTracks => '曲';

  @override
  String get homeStatAlbums => 'アルバム';

  @override
  String get homeStatArtists => 'アーティスト';

  @override
  String get historyTitle => '履歴';

  @override
  String get historyEmpty => '履歴なし';

  @override
  String get historyClear => '消去';

  @override
  String get historyClearTitle => '履歴を消去';

  @override
  String get nowPlayingNoTrack => '曲なし';

  @override
  String get queueTitle => '再生キュー';

  @override
  String get queueEmpty => 'キューが空';

  @override
  String get zonesTitle => 'ゾーン';

  @override
  String get zonesNew => '新しいゾーン';

  @override
  String get zonesNewName => 'ゾーン名';

  @override
  String get zonesNone => 'ゾーンなし';

  @override
  String get zonesRename => 'ゾーン名を変更';

  @override
  String get zonesDelete => 'ゾーンを削除';

  @override
  String get zonesDevices => '利用可能なデバイス';

  @override
  String get zonesOutputLocal => 'ローカル';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesOutputBluetooth => 'Bluetooth';

  @override
  String get zonesChangeOutput => '出力を変更';

  @override
  String get zonesOutputTitle => '音声出力';

  @override
  String get zonesAssignDevice => '割り当て';

  @override
  String get zonesTransferTitle => '再生先...';

  @override
  String get zonesNowPlaying => 'ここで再生中';

  @override
  String zonesActivated(String name) {
    return 'アクティブゾーン: $name';
  }

  @override
  String get radiosTitle => 'ラジオ';

  @override
  String get radiosTabAll => 'すべて';

  @override
  String get radiosTabFavorites => 'お気に入り';

  @override
  String get radiosNone => 'ラジオなし';

  @override
  String get radiosFavNone => 'お気に入りのラジオなし';

  @override
  String get radiosSavedFavorites => '保存したお気に入り';

  @override
  String get radiosAdd => 'ラジオを追加';

  @override
  String get radiosName => '名前';

  @override
  String get radiosStreamUrl => 'ストリームURL';

  @override
  String get radiosGenre => 'ジャンル（任意）';

  @override
  String get radiosPasteM3u => 'M3Uを貼り付け';

  @override
  String get radiosImportUrl => 'URLからインポート';

  @override
  String get radiosImportUrlLabel => 'M3UファイルURL';

  @override
  String radiosImportResult(int count) {
    return '$count局インポート済み';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'HTTPエラー $code';
  }

  @override
  String get radiosImportFailed => 'ファイルをダウンロードできません';

  @override
  String get radiosFavSaved => '曲を保存しました';

  @override
  String get radioSaveFavorite => '曲を保存';

  @override
  String get radioFavTitle => 'ラジオのお気に入り';

  @override
  String get radioFavEmpty => '保存したお気に入りなし';

  @override
  String get radioFavExportCsv => 'CSVをエクスポート';

  @override
  String get streamingTitle => 'ストリーミング';

  @override
  String get streamingConnected => '接続済み';

  @override
  String get streamingNotConnected => '未接続';

  @override
  String get streamingEmail => 'メール';

  @override
  String get streamingPassword => 'パスワード';

  @override
  String get streamingSignIn => 'サインイン';

  @override
  String get streamingSigningIn => 'サインイン中…';

  @override
  String get streamingDeviceCode => '確認コード';

  @override
  String get streamingOpenLink => '開く…';

  @override
  String get streamingLogoutTitle => '切断しますか？';

  @override
  String streamingLogoutBody(String service) {
    return '$serviceから切断しますか？';
  }

  @override
  String get streamingAuthError => '認証に失敗しました';

  @override
  String get streamingAlbumsSection => 'アルバム';

  @override
  String get streamingPlaylistsSection => 'プレイリスト';

  @override
  String get browseTitle => '参照';

  @override
  String get browseRefreshTooltip => '更新';

  @override
  String get browseNoServers => 'UPnP/DLNAサーバーが検出されませんでした';

  @override
  String get browseNoServersHint => 'サーバーが同じWi-Fiネットワーク上にあることを確認してください。';

  @override
  String get browseNoContent => '空のフォルダ';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionAppearance => '外観';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeSystem => 'システム';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLangSystem => 'システム';

  @override
  String get settingsSectionZones => 'ゾーン';

  @override
  String get settingsDefaultZone => 'デフォルトゾーン';

  @override
  String get settingsDefaultZoneAuto => '自動';

  @override
  String get settingsNoZones => 'ゾーンなし';

  @override
  String get settingsSectionServer => 'サーバー';

  @override
  String get settingsHttpPort => 'HTTPポート';

  @override
  String get settingsHttpPortDesc => 'メインサーバーポート';

  @override
  String get settingsLocalIp => 'ローカルIPアドレス';

  @override
  String get settingsSectionLibrary => 'ライブラリ';

  @override
  String get settingsMetadata => '音楽とメタデータ';

  @override
  String get settingsMetadataDesc => 'フォルダ、スキャン、統計';

  @override
  String get settingsSetupWizard => 'セットアップウィザード';

  @override
  String get settingsSetupWizardDesc => '音楽ソースを再設定';

  @override
  String get settingsSectionAbout => '情報';

  @override
  String get settingsVersion => 'バージョン 0.1.0';

  @override
  String get settingsResetConfig => '設定をリセット';

  @override
  String get settingsResetTitle => 'リセットしますか？';

  @override
  String get settingsResetBody => 'すべての設定がリセットされます。次回起動時にスタートアップウィザードが表示されます。';

  @override
  String get settingsPortTitle => 'HTTPポート';

  @override
  String get settingsPortHint => 'ポート (1024–65535)';

  @override
  String get metadataTitle => '音楽とメタデータ';

  @override
  String get metadataRefreshStats => '統計を更新';

  @override
  String get metadataSectionStats => '統計';

  @override
  String get metadataStatTracks => '曲';

  @override
  String get metadataStatAlbums => 'アルバム';

  @override
  String get metadataStatArtists => 'アーティスト';

  @override
  String get metadataStatPlaylists => 'プレイリスト';

  @override
  String get metadataStatRadios => 'ラジオ';

  @override
  String get metadataStatArtwork => 'カバーキャッシュ';

  @override
  String get metadataSectionScan => 'ライブラリスキャン';

  @override
  String metadataScanInProgress(int current, int total) {
    return 'スキャン中… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return '最後のスキャン: +$added追加、$updated更新';
  }

  @override
  String get metadataScanBtn => 'ライブラリをスキャン';

  @override
  String get metadataScanDesc => '設定済みフォルダをすべてインデックス';

  @override
  String get metadataSectionFolders => '音楽フォルダ';

  @override
  String get metadataFoldersNone => 'フォルダが設定されていません';

  @override
  String metadataFolderAddedOn(String date) {
    return '$dateに追加';
  }

  @override
  String get metadataAddFolder => 'フォルダを追加';

  @override
  String get metadataFolderPath => 'フォルダパス';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => 'クリーンアップ';

  @override
  String get metadataCleanupOrphans => '孤立項目を削除';

  @override
  String get metadataCleanupOrphansDesc => '曲のないアルバムとアーティスト';

  @override
  String get metadataClearLibrary => 'ライブラリを消去';

  @override
  String get metadataClearLibraryDesc => 'すべてのローカル曲を削除';

  @override
  String get metadataCleanupOrphansTitle => '孤立項目を削除しますか？';

  @override
  String get metadataCleanupOrphansBody =>
      '関連する曲がないアルバムとアーティストはデータベースから削除されます。';

  @override
  String get metadataClearLibraryTitle => 'ライブラリを消去しますか？';

  @override
  String get metadataClearLibraryBody =>
      'すべてのローカル曲、アルバム、アーティストがデータベースから削除されます。この操作は元に戻せません。';

  @override
  String get metadataOrphansDeleted => '孤立項目を削除しました';

  @override
  String get metadataLibraryCleared => 'ライブラリを消去しました';

  @override
  String get metadataDeleteBtn => '削除';

  @override
  String get metadataClearBtn => '消去';

  @override
  String get setupWelcomeTitle => 'Tune Serverへ\nようこそ';

  @override
  String get setupWelcomeBody =>
      '組み込み型マルチルーム音楽サーバー。ローカルライブラリ、ストリーミングサービス、ラジオをDLNAまたはAirPlayスピーカーに配信できます。';

  @override
  String get setupStart => '始める';

  @override
  String get setupLocalTitle => 'ローカルライブラリ';

  @override
  String get setupLocalBody =>
      'オーディオファイル（FLAC、MP3、AAC…）が含まれるフォルダのパスを指定してください。後で設定から追加できます。';

  @override
  String get setupFolderPath => 'フォルダパス';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => 'このフォルダを追加';

  @override
  String get setupFolderAdded => 'フォルダを追加しました — スキャン中…';

  @override
  String get setupFolderEmpty => 'フォルダパスを入力してください';

  @override
  String get setupUPnPTitle => 'UPnP/DLNAサーバー';

  @override
  String get setupUPnPBody =>
      'Tune Serverはローカルネットワーク上のUPnP/DLNAサーバーを自動的に検出します。検索 → 参照でライブラリを閲覧できます。';

  @override
  String get setupFeatureSsdp => '自動SSDP検出';

  @override
  String get setupFeatureContentDir => 'ContentDirectoryナビゲーション';

  @override
  String get setupFeaturePlayback => 'DLNAファイルの直接再生';

  @override
  String get setupFinish => '設定を完了';

  @override
  String get libraryPlayAlbum => 'アルバムを再生';

  @override
  String get libraryPlayNext => '次に再生';

  @override
  String radioFavExportDone(String path) {
    return 'CSVをエクスポートしました：$path';
  }

  @override
  String get radioFavExportError => 'エクスポートエラー';

  @override
  String get streamingViewAlbum => 'アルバムを見る';

  @override
  String get streamingLogoutContent => 'アカウントが切断されます。';

  @override
  String get streamingUrlCopied => 'URLをクリップボードにコピーしました';

  @override
  String get streamingDeviceCodeHint => 'このURLにアクセスして、上記のコードを入力してください：';

  @override
  String get searchHintFull => 'アーティスト、アルバム、トラックを検索…';

  @override
  String get browseNavError => 'ナビゲーションエラー';

  @override
  String get streamingCodeEntered => 'コードを入力しました';

  @override
  String get appleMusicAuthorize => 'アクセスを許可';

  @override
  String get smbNavTitle => 'SMBソース';

  @override
  String get smbTitle => 'SMB接続';

  @override
  String get smbHostHint => 'SMBサーバーのアドレスを入力';

  @override
  String get smbHostLabel => 'IPアドレス（例：192.168.1.23）';

  @override
  String get smbUser => 'ユーザー名';

  @override
  String get smbPassword => 'パスワード';

  @override
  String get smbConnect => '接続';

  @override
  String get smbSelectShare => '共有を選択';

  @override
  String get smbBack => '戻る';

  @override
  String get smbManualHint => '共有を自動で一覧できません。\n手動で共有名を入力してください：';

  @override
  String get smbShareName => '共有名（例：Share, Music）';

  @override
  String get smbScan => 'スキャン';

  @override
  String get smbScanning => 'スキャン中…';

  @override
  String smbScanCount(int count) {
    return '$count個のオーディオファイルが見つかりました';
  }

  @override
  String get smbDoneTitle => 'インデックス完了';

  @override
  String smbDoneBody(int count, String share) {
    return '$shareから$count曲をインポートしました';
  }

  @override
  String get smbAddAnother => '別の共有を追加';

  @override
  String get settingsSmb => 'SMB / Sambaソース';

  @override
  String get settingsSmbDesc => 'ネットワーク共有からライブラリをインデックス';

  @override
  String get podcastsTitle => 'ポッドキャスト';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => '検索';

  @override
  String get podcastsEmpty => 'ポッドキャストなし';

  @override
  String get podcastsSearchHint => 'ポッドキャストを検索…';

  @override
  String get podcastsNoEpisodes => 'エピソードなし';

  @override
  String get navPodcasts => 'ポッドキャスト';

  @override
  String get streamingConnectedSuccess => '接続しました！';

  @override
  String browseItemCount(int count) {
    return '$count 件';
  }

  @override
  String get settingsSources => 'ソースとデバイス';

  @override
  String get settingsSourcesDesc => 'UPnPサーバー、DLNAレンダラー';

  @override
  String get sourcesTitle => 'ソースとデバイス';

  @override
  String get sourcesServersSection => 'UPnPコンテンツサーバー';

  @override
  String get sourcesRenderersSection => 'DLNAレンダラー';

  @override
  String get sourcesNoDevices => 'デバイスが見つかりません';

  @override
  String get sourcesTypeServer => 'サーバー';

  @override
  String get sourcesTypeRenderer => 'レンダラー';

  @override
  String get sourcesAvailable => '利用可能';

  @override
  String get sourcesUnavailable => 'オフライン';

  @override
  String get sourcesIndexBtn => 'ライブラリをインデックス';

  @override
  String get sourcesRescanBtn => '再スキャン';

  @override
  String get sourcesForget => '削除';

  @override
  String get sourcesAddManually => '手動で追加';

  @override
  String get sourcesAddTitle => '手動スキャン';

  @override
  String get sourcesIpLabel => 'IPアドレス';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => 'ポート';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => 'スキャン中…';

  @override
  String get sourcesNotFound => 'このアドレスにUPnPデバイスが見つかりません';

  @override
  String get zonesMultiRoom => 'マルチルーム';

  @override
  String get zonesCreateGroup => 'グループ作成';

  @override
  String get zonesGroupLeader => 'リーダー';

  @override
  String get zonesGroupFollower => 'フォロワー';

  @override
  String get zonesGroupDissolve => 'グループ解除';

  @override
  String get zonesGroupSyncDelay => '同期遅延';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => 'ゾーン選択';

  @override
  String get zonesGroupSelectLeader => 'リーダー選択';

  @override
  String get zonesGroupNoZones => 'アクティブなグループなし';

  @override
  String get zonesGroupNeedTwo => '2つ以上のゾーンを選択してください';

  @override
  String get zonesGroupCreated => 'グループを作成しました';

  @override
  String get zonesGroupDissolved => 'グループを解除しました';

  @override
  String get metadataSectionEnrich => 'エンリッチ';

  @override
  String get metadataSectionDuplicates => '重複';

  @override
  String get metadataSectionCorrect => '修正';

  @override
  String get metadataFilterAll => 'すべて';

  @override
  String get metadataFilterMissingCover => 'カバーなし';

  @override
  String get metadataFilterMissingGenre => 'ジャンルなし';

  @override
  String get metadataFilterMissingYear => '年なし';

  @override
  String get metadataFilterMissingArtist => 'アーティストなし';

  @override
  String get metadataFilterDoubtful => '疑わしい';

  @override
  String get metadataSearchHint => 'アルバムを検索…';

  @override
  String get metadataArtistFilter => 'アーティスト';

  @override
  String get metadataGenreFilter => 'ジャンル';

  @override
  String get metadataAllArtists => 'すべてのアーティスト';

  @override
  String get metadataAllGenres => 'すべてのジャンル';

  @override
  String get metadataNoAlbums => '該当するアルバムなし';

  @override
  String get metadataEditAlbum => 'アルバムを編集';

  @override
  String get metadataSaveChanges => '保存';

  @override
  String get metadataWriteTags => 'タグを書き込む';

  @override
  String metadataWriteTagsSuccess(int count) {
    return 'タグ書き込み完了: $countファイル';
  }

  @override
  String get metadataMergeGroup => '統合';

  @override
  String metadataMergeConfirm(int count) {
    return 'これらの$countアルバムを統合しますか？トラック数が最も多いアルバムが残ります。';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return '統合完了: $movedトラック移動、合計$total';
  }

  @override
  String get metadataUploadCover => 'カバーをアップロード';

  @override
  String get metadataCoverUploaded => 'カバーアップロード完了';

  @override
  String get metadataAlbumSaved => 'アルバムを保存しました';

  @override
  String metadataDupAlbums(int count) {
    return '$count件の重複アルバム';
  }

  @override
  String get metadataDoubtfulReasons => '問題';

  @override
  String get metadataArtistField => 'アーティスト';

  @override
  String get metadataAlbumField => 'アルバム';

  @override
  String get metadataGenreField => 'ジャンル';

  @override
  String get metadataYearField => '年';

  @override
  String metadataTracksCount(int count) {
    return '$countトラック';
  }

  @override
  String get stereoPairsTitle => 'ステレオペア';

  @override
  String get stereoPairCreate => 'ステレオペアを作成';

  @override
  String get stereoPairName => 'ペア名';

  @override
  String get stereoPairNameHint => '例：リビングステレオ';

  @override
  String get stereoPairLeft => '左 (L)';

  @override
  String get stereoPairRight => '右 (R)';

  @override
  String get stereoPairSelectDevice => 'デバイスを選択';

  @override
  String get stereoPairNone => 'ステレオペアなし';

  @override
  String get stereoPairCreated => 'ステレオペアを作成しました';

  @override
  String get stereoPairDissolved => 'ステレオペアを解除しました';

  @override
  String get stereoPairDissolve => '解除';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => '有効にする';

  @override
  String get streamingDisable => '無効にする';

  @override
  String get streamingEnabled => 'サービスが有効になりました';

  @override
  String get streamingDisabled => 'サービスが無効になりました';

  @override
  String get onboardingWelcomeTitle => 'Tuneへようこそ！';

  @override
  String get onboardingWelcomeBody => '内蔵マルチルーム音楽サーバー。いくつかのステップでセットアップしましょう。';

  @override
  String get onboardingWelcomeStart => '始める';

  @override
  String get onboardingConfigTitle => '設定';

  @override
  String get onboardingConfigBody =>
      'オーディオファイルのフォルダを指定するか、リモートTuneサーバーに接続してください。';

  @override
  String get onboardingConfigModeLocal => '内蔵サーバー';

  @override
  String get onboardingConfigModeRemote => 'リモートサーバー';

  @override
  String get onboardingZoneTitle => 'ゾーンを作成';

  @override
  String get onboardingZoneBody =>
      '以下のデバイスがネットワーク上で発見されました。タップして最初のオーディオゾーンを作成してください。';

  @override
  String get onboardingZoneEmpty => 'まだデバイスが見つかりません。後で追加できます。';

  @override
  String onboardingZoneCreated(String name) {
    return 'ゾーンを作成しました: $name';
  }

  @override
  String get onboardingDoneTitle => '完了！';

  @override
  String get onboardingDoneBody => 'セットアップが完了しました。音楽をお楽しみください！';

  @override
  String get onboardingDoneButton => 'ダッシュボードへ';
}
