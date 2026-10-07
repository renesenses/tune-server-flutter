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
  String zoneLimitReached(int limit) {
    return '無料プランは$limitゾーンまでです — 無制限にするにはPremiumにアップグレード';
  }

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
  String albumTracksDuration(int count, String duration) {
    return '$count曲 · $duration';
  }

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
  String playlistTracksAdded(int count, String name) {
    return '$count曲を「$name」に追加しました';
  }

  @override
  String get playlistAddAllTracks => '全曲をプレイリストに追加';

  @override
  String get playlistDeleteTitle => 'プレイリストを削除？';

  @override
  String get playlistDeleteBody => 'このプレイリストは完全に削除されます。';

  @override
  String get searchHint => '検索…';

  @override
  String get searchNoResults => '結果なし';

  @override
  String get searchTopResult => 'トップ結果';

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
  String queueUpNextSummary(int count, String time) {
    return '次の$count曲 · $time';
  }

  @override
  String get queueEmpty => 'キューが空';

  @override
  String get queueClearTitle => 'キューをクリアしますか？';

  @override
  String get queueClearBody => '再生キューからすべてのトラックが削除されます。';

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
  String get zonesAirplayPair => 'ペアリング（PIN コード）';

  @override
  String get zonesAirplayPairTitle => 'AirPlay ペアリング';

  @override
  String get zonesAirplayPairIntro =>
      '一部のテレビ（Samsung、LG）や Apple TV は画面に 4 桁のコードを表示します。ペアリングを開始してから、コードを入力してください。';

  @override
  String get zonesAirplayPairWaiting => 'デバイスに表示されるコードを待っています…';

  @override
  String get zonesAirplayPairEnterCode => 'デバイスに表示されたコードを入力してください：';

  @override
  String get zonesAirplayPairStart => 'ペアリングを開始';

  @override
  String get zonesAirplayPairSubmit => 'コードを送信';

  @override
  String get zonesAirplayPairRetry => '再試行';

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

  @override
  String get artistBio => 'バイオグラフィー';

  @override
  String get artistAnecdotes => 'エピソード';

  @override
  String get artistSimilarArtists => '類似アーティスト';

  @override
  String get artistMembers => 'メンバー';

  @override
  String get artistDiscography => 'ディスコグラフィー';

  @override
  String get artistEnriching => 'エンリッチ中…';

  @override
  String get artistGenres => 'ジャンル';

  @override
  String get libraryShuffleAll => 'すべてシャッフル';

  @override
  String get librarySortBy => '並べ替え';

  @override
  String get librarySortTitle => 'タイトル';

  @override
  String get librarySortArtist => 'アーティスト';

  @override
  String get librarySortYear => '年';

  @override
  String get librarySortOriginalYear => 'オリジナル年';

  @override
  String get librarySortAddedDate => '追加日';

  @override
  String get librarySortAscending => '昇順';

  @override
  String get librarySortDescending => '降順';

  @override
  String get addFavorite => 'お気に入りに追加';

  @override
  String get addFolder => 'フォルダを追加';

  @override
  String get addThisFolder => 'このフォルダを追加';

  @override
  String get addToPlaylist => 'プレイリストに追加';

  @override
  String get addedToPlaylist => 'プレイリストに追加しました';

  @override
  String get audioOutput => 'オーディオ出力';

  @override
  String get audioOutputDesc =>
      '各サーバーゾーンが1つの出力です（ローカルALSA、Direttaレンダラー…）。再生するゾーンを選択してください。';

  @override
  String get authorizeInBrowser => 'ブラウザでアクセスを許可してください：';

  @override
  String get cancel => 'キャンセル';

  @override
  String get connect => '接続';

  @override
  String get connected => '接続済み';

  @override
  String get cover => 'ジャケット';

  @override
  String get create => '作成';

  @override
  String get createPlaylist => 'プレイリストを作成';

  @override
  String get delete => '削除';

  @override
  String get deletePlaylist => 'プレイリストを削除';

  @override
  String get deletePlaylistConfirm => 'このプレイリストを削除しますか？';

  @override
  String get disabled => '無効';

  @override
  String get disconnected => '未接続';

  @override
  String get done => '完了しました';

  @override
  String get dynamicPlaylists => 'ダイナミックプレイリスト';

  @override
  String get dynamicTag => 'ダイナミック';

  @override
  String errorWith(String msg) {
    return 'エラー: $msg';
  }

  @override
  String favError(String msg) {
    return 'お気に入りに失敗: $msg';
  }

  @override
  String get favoritesTitle => 'お気に入り';

  @override
  String get filterAll => 'すべて';

  @override
  String get freqLimit => '周波数の上限';

  @override
  String get gapless => 'ギャップレス再生';

  @override
  String get gaplessDesc => 'このレンダラーでトラック間にホワイトノイズ/途切れがある場合は無効にしてください。';

  @override
  String get host => 'ホスト';

  @override
  String get language => '言語';

  @override
  String get loading => '読み込み中…';

  @override
  String get localLibrary => 'ローカルライブラリ';

  @override
  String get localLibraryDesc => 'サーバーが音楽を探すフォルダ';

  @override
  String get logIn => 'ログイン';

  @override
  String get logOut => 'ログアウト';

  @override
  String loginTo(String service) {
    return '$service にログイン';
  }

  @override
  String get maxBitDepth => '最大ビット深度';

  @override
  String get maxFrequency => '最大周波数';

  @override
  String maxTracks(int n) {
    return '最大 $n';
  }

  @override
  String get metadataFields => 'メタデータ項目';

  @override
  String get metadataFieldsDesc => 'ローカルライブラリに表示される情報';

  @override
  String get metadataSaved => 'メタデータを保存しました';

  @override
  String get musicFolders => 'スキャン対象フォルダ';

  @override
  String get navFavorites => 'お気に入り';

  @override
  String get navPlaylists => 'プレイリスト';

  @override
  String get newPlaylist => '新規プレイリスト';

  @override
  String get noFavAlbums => 'お気に入りのアルバムなし';

  @override
  String get noFavArtists => 'お気に入りのアーティストなし';

  @override
  String get noFavTracks => 'お気に入りのトラックなし';

  @override
  String get noFolders => 'フォルダが未設定です';

  @override
  String get noLimit => '制限なし';

  @override
  String get noPlaylists => 'プレイリストなし';

  @override
  String get noResults => '結果なし';

  @override
  String get noService => 'サービスなし';

  @override
  String get noTracks => 'トラックなし';

  @override
  String get noZones => '利用可能なゾーンがありません';

  @override
  String get notConnected => '設定でサーバーを構成してください';

  @override
  String get nothingPlaying => '再生していません';

  @override
  String get openAuthPage => '認証ページを開く';

  @override
  String get password => 'パスワード';

  @override
  String get pickFolder => 'フォルダを選択';

  @override
  String get playAll => 'すべて再生';

  @override
  String get playlistCreated => 'プレイリストを作成しました';

  @override
  String get playlistDeleted => 'プレイリストを削除しました';

  @override
  String get playlistsTitle => 'プレイリスト';

  @override
  String get port => 'ポート';

  @override
  String get qualityCd => 'CD（44.1 kHz / 16ビット）';

  @override
  String get qualityHires => 'ハイレゾ（最大192 kHz）';

  @override
  String get qualityMax => '最高';

  @override
  String get removeFavorite => 'お気に入りから削除';

  @override
  String get removeFromPlaylist => 'プレイリストから削除';

  @override
  String get runScan => 'ライブラリをスキャン';

  @override
  String get scanning => 'スキャン中…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · ライブラリ';

  @override
  String get searchEmptyTitle => 'タイトル・アルバム・アーティストを検索';

  @override
  String get searchTitle => '検索';

  @override
  String get sectionAlbums => 'アルバム';

  @override
  String get sectionArtists => 'アーティスト';

  @override
  String get sectionPlaylists => 'プレイリスト';

  @override
  String get sectionTracks => 'トラック';

  @override
  String get server => 'サーバー';

  @override
  String get sourceLibrary => 'ライブラリ';

  @override
  String get streamingQuality => 'ストリーミング品質';

  @override
  String get streamingQualityDesc => 'サービス（Qobuz、Tidal…）に要求する周波数/解像度の上限を設定します。';

  @override
  String get streamingServices => 'ストリーミングサービス';

  @override
  String get systemLanguage => 'システム';

  @override
  String get trackRemoved => 'プレイリストから削除しました';

  @override
  String tracksCount(int n) {
    return '$n 曲';
  }

  @override
  String get username => 'ユーザー名';

  @override
  String get visualizer => 'ビジュアライザー';

  @override
  String get licenseSessionConflictTitle => '別のサーバーでライセンスが使用中';

  @override
  String get licenseSessionConflictBody =>
      'お使いの Tune ライセンスは、別のサーバーですでに使用されています。もう一方が停止してから数分後に、このサーバーは自動的に Premium に戻ります。';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'お使いの Tune ライセンスは「$server」で使用中です。もう一方が停止してから数分後に、このサーバーは自動的に Premium に戻ります。';
  }

  @override
  String cfgSaveError(String detail) {
    return '保存エラー: $detail';
  }

  @override
  String get cfgReload => '再読み込み';

  @override
  String get cfgFieldsLoadError => '項目を読み込めません';

  @override
  String get cfgFieldsNone => '利用できる項目はありません';

  @override
  String get cfgFieldsHint => 'トラック編集画面に表示するメタデータ項目を選択します。';

  @override
  String get cfgMetaCompleteness => 'メタデータの充足度';

  @override
  String get cfgMetaEnrichMusicBrainz => 'MusicBrainz で補完';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'MusicBrainz 補完';

  @override
  String get cfgMetaFixYearsTidal => '年を修正（TIDAL）';

  @override
  String get cfgMetaFixYearsDiscogs => '年を修正（Discogs）';

  @override
  String get cfgMetaFixGenres => 'ジャンルを修正';

  @override
  String get cfgMetaAutoFixAlbums => 'アルバムを自動修正';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '保留中の提案: $count 件',
      zero: '保留中の提案はありません',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => 'すべて承認';

  @override
  String get cfgMetaSuggestions => '提案';

  @override
  String get cfgMetaScanDuplicates => '重複をスキャン';

  @override
  String get cfgMetaAutoMerge => '自動統合';

  @override
  String get cfgMetaMergeDuplicatesTask => '重複の統合';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '重複アルバム $count 件（$groups グループ）',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… ほか $count グループ',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => '前回の結果';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct% 完了';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label: エラー — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label: $count 件承認';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label: $fixed/$total 件修正';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label: $fixed 件修正';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label: $total 件処理';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label: 完了';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return 'タグの書き込みエラー: $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return 'アップロードエラー: $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアルバムを統合しますか？',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody => 'トラック数が最も多いアルバムを残し、他は削除されます。';

  @override
  String cfgMetaMergeError(String detail) {
    return '統合エラー: $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => '統計を取得できません';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアルバム',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… ほか $count 件のアルバム（フィルターで絞り込み）',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count トラック';
  }

  @override
  String get cfgMetaReasonArtistUppercase => 'アーティストが大文字';

  @override
  String get cfgMetaReasonArtistPlaceholder => '仮のアーティスト';

  @override
  String get cfgMetaReasonArtistHasYear => 'アーティスト＝フォルダー';

  @override
  String get cfgMetaReasonGenrePlaceholder => '仮のジャンル';

  @override
  String get cfgMetaReasonYearSuspicious => '疑わしい年';

  @override
  String get cfgMetaReasonTitleUppercase => 'タイトルが大文字';

  @override
  String get cfgMetaReasonArtistMismatch => 'アーティスト不一致';

  @override
  String get cfgSmbNotConnected => 'リモートサーバーに接続されていません';

  @override
  String cfgSmbMountTitle(String name) {
    return '$name をマウント';
  }

  @override
  String get cfgSmbMount => 'マウント';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name をマウントしました';
  }

  @override
  String get cfgSmbTitle => 'ネットワーク共有（SMB）';

  @override
  String get cfgSmbSearching => 'SMB 共有を検索中…';

  @override
  String get cfgSmbNone => 'SMB 共有が見つかりません';

  @override
  String get cfgSmbSaveCredentials => '認証情報を保存';

  @override
  String get cfgUnknown => '不明';

  @override
  String get cfgEqTitle => 'イコライザー';

  @override
  String get cfgEqTabAssistant => 'アシスタント';

  @override
  String get cfgEqTabExpert => 'エキスパート';

  @override
  String cfgEqError(String detail) {
    return 'EQ エラー: $detail';
  }

  @override
  String get cfgEqPresetFlat => 'フラット';

  @override
  String get cfgEqPresetBassBoost => '低音強調';

  @override
  String get cfgEqPresetClassical => 'クラシック';

  @override
  String get cfgEqPresetVocal => 'ボーカル';

  @override
  String get cfgNotConnectedToServer => 'サーバーに接続されていません';

  @override
  String get cfgCredentialsRequired => 'ユーザー名とパスワードが必要です';

  @override
  String cfgServiceConnected(String service) {
    return '$service に接続しました。';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service の接続を解除しました。';
  }

  @override
  String get cfgLastfmTitle => 'Last.fm スクロブル';

  @override
  String get cfgLastfmDesc =>
      '再生履歴を Last.fm にスクロブルします。どのゾーンで再生したトラックも自動的にスクロブルされます。';

  @override
  String get cfgDisconnecting => '切断中…';

  @override
  String get cfgConnectHeader => '接続';

  @override
  String get cfgConnecting => '接続中…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のスクロブル',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return '最終: $date';
  }

  @override
  String get cfgTokenRequired => 'ユーザートークンを入力してください';

  @override
  String get cfgScrobblerUnavailable => 'スクロブラーを利用できません';

  @override
  String cfgConnectedAs(String name) {
    return '$name として接続しました';
  }

  @override
  String get cfgListenbrainzDesc =>
      '再生履歴を ListenBrainz にスクロブルします。ユーザートークンは listenbrainz.org/settings で取得できます。';

  @override
  String get cfgUserToken => 'ユーザートークン';

  @override
  String get cfgValidating => '確認中…';

  @override
  String get cfgSaveAndConnect => '保存して接続';

  @override
  String get cfgScrobbleAuto => 'トラックは自動的にスクロブルされます';

  @override
  String cfgConfigExported(String path) {
    return '設定をエクスポートしました: $path';
  }

  @override
  String get cfgConfigImported => '設定をインポートしました';

  @override
  String cfgImportError(String detail) {
    return 'インポートエラー: $detail';
  }

  @override
  String get cfgConfigExportDesc => 'サーバー設定を JSON ファイルに保存します。';

  @override
  String get cfgConfigExportJson => 'JSON をエクスポート';

  @override
  String get cfgConfigImportDesc => 'JSON ファイルから設定を復元します。';

  @override
  String get cfgChooseFile => 'ファイルを選択';

  @override
  String get cfgDbNoServer => '接続中のサーバーがありません。';

  @override
  String cfgDbExportOk(String size, String path) {
    return 'エクスポート完了: $size MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => 'ファイルのパスにアクセスできません。';

  @override
  String get cfgDbImportConfirmTitle => 'インポートの確認';

  @override
  String cfgDbImportConfirmBody(String name) {
    return 'サーバーのデータベースを「$name」で置き換えますか？\n\n安全のためのバックアップが自動的に作成されます。インポート後にサーバーを再起動する必要があります。';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return 'インポート完了: $size MB（$engine）。\n変更を反映するにはサーバーを再起動してください。';
  }

  @override
  String get cfgDbTitle => 'データベース';

  @override
  String get cfgDbIntro =>
      '接続中のサーバーのデータベースをエクスポート／インポートします。\nSQLite: .db ファイル。PostgreSQL: SQL ダンプ。';

  @override
  String get cfgDbExporting => 'エクスポート中…';

  @override
  String get cfgDbExportBtn => 'データベースをエクスポート';

  @override
  String get cfgDbImporting => 'インポート中…';

  @override
  String get cfgDbImportBtn => 'ファイルをインポート';

  @override
  String get cfgDbFooter =>
      'インポート後は変更を反映するためにサーバーを再起動してください。置き換えの前に安全のためのバックアップが自動的に作成されます。';

  @override
  String cfgStatusUnavailable(String detail) {
    return 'ステータスを取得できません: $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune はローカルネットワーク上で Spotify Connect レシーバーとして表示されます。Spotify アプリのデバイス一覧で「Tune (…)」を選択してください。クライアント側で Spotify Premium アカウントが必要です。';

  @override
  String get cfgSpotifyNoLibrespot => 'サーバーで librespot が見つかりません';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      'バイナリを含めるには公式の tarball/zip から Tune Server を再インストールするか、別途インストールしてください（apt install librespot / brew install librespot）。';

  @override
  String get cfgTargetZone => '対象ゾーン';

  @override
  String get cfgDeviceName => 'デバイス名';

  @override
  String get cfgPlaying => '再生中';

  @override
  String get cfgNetDiagTitle => 'ネットワーク診断';

  @override
  String get cfgNetSsdpActive => 'SSDP 有効';

  @override
  String get cfgNetMulticastReachable => 'マルチキャスト到達可能';

  @override
  String get cfgError => 'エラー';

  @override
  String get cfgNetResolution => '名前解決';

  @override
  String get cfgNetLatency => 'レイテンシ';

  @override
  String get cfgNetPublicIp => 'パブリック IP';

  @override
  String get cfgNetInterfaces => 'ネットワークインターフェース';

  @override
  String get cfgStatusWarning => '注意';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total アルバム';
  }

  @override
  String get libNoCollectionsYet => 'コレクションはまだありません';

  @override
  String libRatingError(String error) {
    return '評価エラー: $error';
  }

  @override
  String libDisc(int disc) {
    return 'ディスク $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return 'ディスク $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => 'クイックお気に入り';

  @override
  String get libAddToCollection => 'コレクションに追加';

  @override
  String get libAlbumNotes => 'アルバム解説';

  @override
  String get libCredits => 'クレジット';

  @override
  String get libNoCredits => 'クレジットなし';

  @override
  String get libNoAlbumNotes => 'アルバム解説はありません';

  @override
  String get libNoNotes => '解説はありません';

  @override
  String get libSourceCommunity => 'Tune コミュニティ';

  @override
  String libBioSource(String source) {
    return '出典: $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return '出典: $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied => 'Apple Music ライブラリへのアクセスが拒否されました。';

  @override
  String get libAppleMusicPermissionRefused =>
      '許可されませんでした。設定 > プライバシー > メディアと Apple Music でアクセスを有効にしてください。';

  @override
  String get libUnknownError => '不明なエラー';

  @override
  String get libAppleMusicAccessTitle => 'Apple Music へのアクセス';

  @override
  String get libAppleMusicAccessBody =>
      'Apple Music のトラックを再生するには、ミュージックライブラリへのアクセスを許可してください。';

  @override
  String get libAppleMusicEmpty => 'Apple Music ライブラリは空です';

  @override
  String get libReportImageTitle => '画像を報告';

  @override
  String get libReportImageBody =>
      'このアーティスト画像を誤りとして報告しますか？次回のメタデータ補完時にサーバーが差し替えます。';

  @override
  String get libReportAction => '報告';

  @override
  String get libImageReported => '画像を報告しました';

  @override
  String libServiceAlbums(String service) {
    return '$service のアルバム';
  }

  @override
  String libTrackCount(int count) {
    return '$count 曲';
  }

  @override
  String get libDuplicateScanner => '重複スキャン';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    return '$groups 件の重複グループが見つかりました（合計 $tracks 曲）';
  }

  @override
  String get libFindDuplicatesTitle => '重複トラックを検索';

  @override
  String get libFindDuplicatesBody => 'オーディオ内容のハッシュを照合し、ライブラリ内の同一トラックを見つけます。';

  @override
  String get libStartScan => 'スキャン開始';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total 曲（$percent%）';
  }

  @override
  String get libLoadingTracks => 'トラックを読み込み中…';

  @override
  String get libNoDuplicatesFound => '重複は見つかりませんでした';

  @override
  String get libLibraryClean => 'ライブラリはきれいです。';

  @override
  String get libScanAgain => '再スキャン';

  @override
  String get libScanFailed => 'スキャンに失敗しました';

  @override
  String get libTrackNumberField => 'トラック番号';

  @override
  String get libDiscNumberField => 'ディスク番号';

  @override
  String get libExtendedMetadata => '拡張メタデータ';

  @override
  String get libGenreTreeSaved => 'ジャンルツリーを保存しました';

  @override
  String libSaveError(String error) {
    return '保存エラー: $error';
  }

  @override
  String get libGenreTree => 'ジャンルツリー';

  @override
  String get libAddRootGenre => 'ルートジャンルを追加';

  @override
  String get libGenreTreeRequiresRemote => 'ジャンルツリーにはリモートサーバーへの接続が必要です。';

  @override
  String get libNoGenreHierarchy => 'ジャンル階層が定義されていません';

  @override
  String libAddSubGenreTo(String parent) {
    return '「$parent」にサブジャンルを追加';
  }

  @override
  String get libGenreName => 'ジャンル名';

  @override
  String libSubGenreCount(int count) {
    return 'サブジャンル $count 件';
  }

  @override
  String get libAddSubGenre => 'サブジャンルを追加';

  @override
  String get libRemove => '削除';

  @override
  String libRemoveNamedConfirm(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    return 'サブジャンル $count 件もすべて削除されます。';
  }

  @override
  String get libRemoveGenreBody => 'このジャンルはツリーから削除されます。';

  @override
  String libAlbumCount(int count) {
    return '$count 枚のアルバム';
  }

  @override
  String get libNoTracksForFilter => 'このフィルターに一致する曲はありません';

  @override
  String get libQualityLossless => 'ロスレス';

  @override
  String get libQualityLossy => '非可逆';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total 曲';
  }

  @override
  String get libNewCollection => '新しいコレクション';

  @override
  String get libCollectionName => 'コレクション名';

  @override
  String libCreateError(String error) {
    return '作成エラー: $error';
  }

  @override
  String libDeleteError(String error) {
    return '削除エラー: $error';
  }

  @override
  String get libCollectionsTitle => 'コレクション';

  @override
  String get libCollectionsLoadFailed => 'コレクションを読み込めませんでした';

  @override
  String get libDeleteCollectionTitle => 'コレクションを削除しますか？';

  @override
  String libDeleteCollectionBody(String name) {
    return '「$name」は完全に削除されます。';
  }

  @override
  String get libNoAlbumsInCollection => 'このコレクションにアルバムはありません';

  @override
  String get libDeleteConfirmTitle => '削除しますか？';

  @override
  String get libDeleteSmartCollectionBody => 'このスマートコレクションは完全に削除されます。';

  @override
  String get libNoRules => 'ルールなし';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return 'クレジット: $role=$artist';
  }

  @override
  String get libAnd => 'かつ';

  @override
  String get libOr => 'または';

  @override
  String get libSmartCollections => 'スマートコレクション';

  @override
  String get libNewSmartCollection => '新しいスマートコレクション';

  @override
  String get libNoSmartCollections => 'スマートコレクションはありません';

  @override
  String get libSmartCollectionsSeedHint =>
      'サーバーは通常、初回起動時に 7 つの既定コレクションを作成します。';

  @override
  String get libCreateFirstSmartCollection => '最初のスマートコレクションを作成';

  @override
  String get libNoMatchingAlbums => '一致するアルバムはありません';

  @override
  String get libSmartCreditsHint =>
      'クレジットに基づくルール（engineer、performer など）を使うには、先に設定からライブラリを補完してください。';

  @override
  String get libFieldSampleRate => 'サンプルレート';

  @override
  String get libFieldBitDepth => 'ビット深度';

  @override
  String get libFieldTrackCount => 'トラック数';

  @override
  String get libFieldFormat => 'フォーマット';

  @override
  String get libFieldLabel => 'レーベル';

  @override
  String get libFieldAlbumTitle => 'アルバム名';

  @override
  String get libFieldSource => 'ソース';

  @override
  String get libFieldCredit => 'クレジット';

  @override
  String get libFieldPlayCount => '再生回数';

  @override
  String get libFieldLastPlayed => '最終再生';

  @override
  String get libOpBetween => '範囲';

  @override
  String get libOpContains => '含む';

  @override
  String get libOpStartsWith => 'で始まる';

  @override
  String get libOpEmpty => '空';

  @override
  String get libOpNotEmpty => '空でない';

  @override
  String get libOpNever => 'なし';

  @override
  String get libOpAfter => '以降';

  @override
  String get libOpBefore => '以前';

  @override
  String get libNameLabel => '名前';

  @override
  String get libMatchMode => '一致条件';

  @override
  String get libMatchAll => 'すべてのルール（AND）';

  @override
  String get libMatchAny => 'いずれか（OR）';

  @override
  String get libAddRule => 'ルールを追加';

  @override
  String get libMatchingAlbumsPending => '… 件の一致するアルバム';

  @override
  String libMatchingAlbums(int count) {
    return '一致するアルバム $count 件';
  }

  @override
  String get libTimestampHint => 'now-30d または 2024-01-01';

  @override
  String get libValueHint => '値';

  @override
  String get libMinHint => '最小';

  @override
  String get libMaxHint => '最大';

  @override
  String get libCommaSeparatedHint => 'カンマ区切りの値';

  @override
  String get libCreditRoleHint => '役割（engineer、performer など）';

  @override
  String get libCreditArtistHint => 'アーティスト（Rudy Van Gelder など）';

  @override
  String get libCreditInstrumentHint => '楽器（Piano など）— 任意';

  @override
  String get libDirectories => 'フォルダ';

  @override
  String get libLoadError => '読み込みエラー';

  @override
  String get libNoFolders => 'フォルダがありません';

  @override
  String get libAddFoldersInSettings => '設定で音楽フォルダを追加してください';

  @override
  String get libFoldersHeader => 'フォルダ';

  @override
  String libTracksHeaderCount(int count) {
    return '曲（$count）';
  }

  @override
  String get libPlayFromHere => 'ここから再生';

  @override
  String get libTags => 'タグ';

  @override
  String get libNewTagHint => '新しいタグ…';

  @override
  String get libJustNow => 'たった今';

  @override
  String libMinutesAgo(int count) {
    return '$count 分前';
  }

  @override
  String libHoursAgo(int count) {
    return '$count 時間前';
  }

  @override
  String get libYesterday => '昨日';

  @override
  String libDaysAgo(int count) {
    return '$count 日前';
  }

  @override
  String get libNowListening => '再生中';

  @override
  String get libContinueListening => '続きから再生';

  @override
  String get libRecentlyAdded => '最近追加した項目';

  @override
  String get libTopTracks => 'よく聴く曲';

  @override
  String get libTopArtists => 'よく聴くアーティスト';

  @override
  String get libRecommendations => 'おすすめ';

  @override
  String get libSourceLocal => 'ローカル';

  @override
  String get libFieldDuration => '長さ';

  @override
  String get libFilter => 'フィルター';

  @override
  String get libRefreshAll => 'すべて更新';

  @override
  String get libPodcastsSubscribed => '登録済み';

  @override
  String get libNoSubscriptions => '登録はまだありません';

  @override
  String get libSubscribeRssFeed => 'RSS フィードを登録';

  @override
  String get libUnknown => '不明';

  @override
  String get libUnsubscribeTitle => '登録を解除しますか？';

  @override
  String libUnsubscribeBody(String name) {
    return '「$name」の登録を解除しますか？';
  }

  @override
  String get libUnsubscribe => '登録解除';

  @override
  String libEpisodeCount(int count) {
    return '$count エピソード';
  }

  @override
  String get libSubscribeToPodcast => 'ポッドキャストを登録';

  @override
  String get libRssFeedUrl => 'RSS フィードの URL';

  @override
  String get libSubscribe => '登録';

  @override
  String get libSubscribed => '登録しました。';

  @override
  String libSubscribeError(String error) {
    return '登録エラー: $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return '登録解除エラー: $error';
  }

  @override
  String get libPodcastRefreshed => 'ポッドキャストを更新しました。';

  @override
  String libRefreshError(String error) {
    return '更新エラー: $error';
  }

  @override
  String get libAllPodcastsRefreshed => 'すべてのポッドキャストを更新しました。';

  @override
  String get libToday => '今日';

  @override
  String get miscNavFolders => 'フォルダ';

  @override
  String get miscNavCollections => 'コレクション';

  @override
  String get miscNavSmartCollections => 'スマートコレクション';

  @override
  String get miscNavDjMode => 'DJモード';

  @override
  String get miscNavPartyMode => 'パーティーモード';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => 'パーティー';

  @override
  String get miscNavSmartPlaylists => 'スマートプレイリスト';

  @override
  String get miscNavAlarms => 'アラーム';

  @override
  String get miscNavGenreTree => 'ジャンルツリー';

  @override
  String get miscNavDashboard => 'ダッシュボード';

  @override
  String get miscNavDiagnostics => '診断';

  @override
  String get miscNavAdmin => '管理';

  @override
  String get miscNavMore => 'その他';

  @override
  String get miscNextTrack => '次のトラック';

  @override
  String get miscPreviousTrack => '前のトラック';

  @override
  String get miscUnknownError => '不明なエラー';

  @override
  String get miscAuthorizationCode => '認証コード';

  @override
  String get miscWaitingForValidation => '承認を待っています…';

  @override
  String miscCodeValue(String code) {
    return 'コード: $code';
  }

  @override
  String get miscQualityHigh => '高音質';

  @override
  String get miscExplore => '探索';

  @override
  String get miscFavoriteAlbums => 'お気に入りのアルバム';

  @override
  String get miscFavoriteTracks => 'お気に入りのトラック';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲をすべて表示',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => 'マイプレイリスト';

  @override
  String get miscNoApiClient => 'APIクライアントがありません';

  @override
  String miscServiceFavorites(String service) {
    return '$service のお気に入り';
  }

  @override
  String miscPlayAllCount(int count) {
    return 'すべて再生 ($count)';
  }

  @override
  String get miscServiceNotFound => 'サービスが見つかりません';

  @override
  String get miscYtHome => 'ホーム';

  @override
  String get miscYtCharts => 'チャート';

  @override
  String get miscYtMoods => 'ムード';

  @override
  String get miscNoData => 'データがありません';

  @override
  String get miscNoContentAvailable => '利用できるコンテンツがありません';

  @override
  String get miscNoChartsAvailable => '利用できるチャートがありません';

  @override
  String get miscNoMoodsAvailable => '利用できるムードがありません';

  @override
  String get miscDashTotalPlays => '総再生回数';

  @override
  String get miscDashListeningTime => '再生時間';

  @override
  String get miscDashUniqueTracks => 'ユニークトラック';

  @override
  String get miscDashUniqueArtists => 'ユニークアーティスト';

  @override
  String get miscDashTopArtists => 'トップアーティスト';

  @override
  String get miscDashTopAlbums => 'トップアルバム';

  @override
  String get miscDashTopTracks => 'トップトラック';

  @override
  String get miscDashListeningByHour => '時間帯別の再生';

  @override
  String get miscDashListeningByDay => '日別の再生';

  @override
  String get miscDashAllTime => '全期間';

  @override
  String miscDashLastDays(int days) {
    return '$days日間';
  }

  @override
  String get miscUnknown => '不明';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count回再生',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => 'まだ再生データがありません';

  @override
  String get miscDashNoDataHint => '音楽を再生すると、ここに統計が表示されます。';

  @override
  String get miscDashLoadFailed => 'ダッシュボードを読み込めませんでした';

  @override
  String get miscDiagRequiresRemote => '診断にはリモートサーバーへの接続が必要です。';

  @override
  String get miscDiagSystem => 'システム';

  @override
  String get miscDiagHealth => 'ヘルス';

  @override
  String get miscVersion => 'バージョン';

  @override
  String get miscDiagUptime => '稼働時間';

  @override
  String get miscDiagMemory => 'メモリ';

  @override
  String get miscDiagDatabase => 'データベース';

  @override
  String miscZoneNumbered(String id) {
    return 'ゾーン $id';
  }

  @override
  String get miscDiagLogs => 'ログ';

  @override
  String get miscDiagNoLogs => 'ログはありません';

  @override
  String get miscAdminTitle => '管理ダッシュボード';

  @override
  String get miscAdminNotConnected => 'リモートサーバーに接続されていません';

  @override
  String get miscAdminSystemHealth => 'システムの状態';

  @override
  String get miscAdminStatus => 'ステータス';

  @override
  String get miscAdminDisk => 'ディスク';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return '検出されたデバイス ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return '最近のエラー ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => '最近のエラーはありません';

  @override
  String get miscTroubleshootingTitle => 'トラブルシューティング';

  @override
  String get miscFaqHeader => 'よくある質問';

  @override
  String get miscFaq1Title => 'サーバーが表示されない';

  @override
  String get miscFaq1Step1 => 'Tune サーバーが起動していて、アクセスできることを確認してください。';

  @override
  String get miscFaq1Step2 => 'デバイスがサーバーと同じ Wi-Fi ネットワークに接続されていることを確認してください。';

  @override
  String get miscFaq1Step3 =>
      'VPN を使用している場合は、オフにするか LAN 検出を有効にしてください（例: nordvpn set lan-discovery on）。';

  @override
  String get miscFaq1Step4 => '設定 > モード > ネットワークをスキャン からネットワークをスキャンしてみてください。';

  @override
  String get miscFaq1Step5 =>
      'サーバーのポート（既定は 8888）がファイアウォールでブロックされていないか確認してください。';

  @override
  String get miscFaq1Step6 => 'サーバーとアプリを再起動してください。';

  @override
  String get miscFaq2Title => '音楽が再生されない';

  @override
  String get miscFaq2Step1 => '再生ゾーンが選択されていることを確認してください（画面下部のバー）。';

  @override
  String get miscFaq2Step2 => 'ゾーンがない場合は、設定 > オーディオ > ゾーン > 作成 で作成してください。';

  @override
  String get miscFaq2Step3 =>
      '出力デバイス（スピーカー、DAC）の電源が入っていて、同じネットワークにあることを確認してください。';

  @override
  String get miscFaq2Step4 => 'DLNA デバイスの場合、検出後に数秒待ってから再生を開始してください。';

  @override
  String get miscFaq2Step5 => '別のファイルを試してください。現在のファイル形式に対応していない可能性があります。';

  @override
  String get miscFaq2Step6 => '問題が解決しない場合はアプリを再起動してください。';

  @override
  String get miscFaq3Title => 'カバーアートが表示されない';

  @override
  String get miscFaq3Step1 => '設定 > ライブラリ > ソース からライブラリをスキャンしてください。';

  @override
  String get miscFaq3Step2 => 'ファイルにカバーアートが埋め込まれているか確認してください（ID3/Vorbis タグ）。';

  @override
  String get miscFaq3Step3 => 'アルバムのフォルダに cover.jpg または folder.jpg を置いてください。';

  @override
  String get miscFaq3Step4 => '設定 > ライブラリ > メタデータ でカバーアートの自動取得を有効にしてください。';

  @override
  String get miscFaq3Step5 => 'アプリを再起動して画像キャッシュをクリアしてください。';

  @override
  String get miscFaq4Title => 'スキャンが止まっている';

  @override
  String get miscFaq4Step1 => '初回のスキャンはライブラリの規模によって数分かかることがあります。';

  @override
  String get miscFaq4Step2 => '音楽フォルダにアクセスできるか確認してください（権限、SMB マウント）。';

  @override
  String get miscFaq4Step3 => 'アプリを閉じて再起動すると、止まったスキャンを中断できます。';

  @override
  String get miscFaq4Step4 => 'サーバーのログを確認して、問題のあるファイルを特定してください。';

  @override
  String get miscFaq4Step5 => 'ソースフォルダの数を減らして、問題を切り分けてみてください。';

  @override
  String get miscFaq5Title => 'DLNA/AirPlay デバイスの接続方法';

  @override
  String get miscFaq5Step1 =>
      'DLNA: デバイスの電源が入っていて、同じネットワークにある必要があります。出力の一覧に自動的に表示されます。';

  @override
  String get miscFaq5Step2 => 'デバイスが表示されない場合は、ルーターでマルチキャストが機能しているか確認してください。';

  @override
  String get miscFaq5Step3 =>
      '一部のルーターは Wi-Fi クライアント間の SSDP 通信をブロックします。マルチキャスト転送を有効にしてください。';

  @override
  String get miscFaq5Step4 => 'BluOS: Bluesound スピーカーは自動的に検出されます。';

  @override
  String get miscFaq5Step5 => 'Chromecast: Google Cast デバイスは利用可能な出力に表示されます。';

  @override
  String get miscFaq5Step6 => '検出後、ゾーンを作成してそのデバイスを出力として割り当ててください。';

  @override
  String get miscFaq6Title => 'ストリーミングの問題';

  @override
  String get miscFaq6Step1 =>
      '設定 > ストリーミング で、サービス（TIDAL、Qobuz、Deezer）の認証情報が正しいか確認してください。';

  @override
  String get miscFaq6Step2 => 'セッションの有効期限が切れた場合は、サービスの接続を解除してから再接続してください。';

  @override
  String get miscFaq6Step3 => 'インターネット接続を確認してください。';

  @override
  String get miscFaq6Step4 => '一部のトラックはお住まいの地域で利用できない場合があります。';

  @override
  String get miscFaq6Step5 => '音質の問題は、設定 > 詳細オーディオ のストリーミング品質設定を確認してください。';

  @override
  String get miscFaq6Step6 => '問題が解決しない場合は、設定 > ヘルプ からバグレポートを送信してください。';

  @override
  String get miscBugReportCopied => 'レポートをクリップボードにコピーしました';

  @override
  String get miscBugReportSent => 'バグを送信しました。ありがとうございます！';

  @override
  String get miscBugReportSendFailed => '送信に失敗しました。レポートをフォーラムに貼り付けてください。';

  @override
  String get miscBugReportTitle => 'バグレポート';

  @override
  String get miscRegenerate => '再生成';

  @override
  String get miscBugReportGenerateFailed => 'レポートを生成できませんでした';

  @override
  String get miscSent => '送信しました！';

  @override
  String get miscSending => '送信中…';

  @override
  String get miscSubmit => '送信';

  @override
  String get miscCopied => 'コピーしました！';

  @override
  String get miscCopyReport => 'レポートをコピー';

  @override
  String get miscAiServerNotConnected => 'サーバーに接続されていません。接続を確認してください。';

  @override
  String miscAiQueryFailed(int code) {
    return 'AI リクエストに失敗しました ($code)';
  }

  @override
  String get miscAiNoReply => '応答がありません';

  @override
  String get miscAiAskHint => '質問してください…';

  @override
  String get miscAiSend => '送信';

  @override
  String get miscAiTitle => 'AI アシスタント';

  @override
  String get miscAiEmptyTitle => 'Tune AI アシスタント';

  @override
  String get miscAiEmptyBody => '音楽について質問したり、\nおすすめを聞いたりできます…';

  @override
  String miscAiAction(String action) {
    return 'アクション: $action';
  }

  @override
  String get miscCreateAccount => 'アカウントを作成';

  @override
  String get miscUsername => 'ユーザー名';

  @override
  String get miscUsernameRequired => 'ユーザー名を入力してください';

  @override
  String get miscEmailRequired => 'メールアドレスを入力してください';

  @override
  String get miscEmailInvalid => 'メールアドレスが無効です';

  @override
  String get miscPasswordRequired => 'パスワードを入力してください';

  @override
  String miscPasswordMinLength(int min) {
    return '$min 文字以上';
  }

  @override
  String get miscHaveAccountSignIn => 'アカウントをお持ちですか？ログイン';

  @override
  String get miscNoAccountSignUp => 'アカウントをお持ちでないですか？登録';

  @override
  String get npRepeat => 'リピート';

  @override
  String get npQueue => 'キュー';

  @override
  String get npFavorite => 'お気に入り';

  @override
  String get npRadioFavAdded => 'ラジオのお気に入りに追加しました';

  @override
  String get npLyrics => '歌詞';

  @override
  String get npAlarm => 'アラーム';

  @override
  String get npSleepTimer => 'スリープタイマー';

  @override
  String get npDspCrossfeed => 'DSP クロスフィード';

  @override
  String get npEqualizer => 'イコライザー';

  @override
  String get npShare => '共有';

  @override
  String get npTransfer => '転送';

  @override
  String get npCopiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get npNoLyricsFound => '歌詞が見つかりません';

  @override
  String get npNoLyricsAvailable => '歌詞はありません';

  @override
  String get npLyricsOpenFromNowPlaying => '歌詞全文は再生中画面から開いてください';

  @override
  String get npLyricsLoadFailed => '歌詞を読み込めませんでした';

  @override
  String get npLrcMetadataTooltip => 'メタデータ';

  @override
  String get npLrcMetadataTitle => 'LRC メタデータ';

  @override
  String get npLrcTitle => 'タイトル';

  @override
  String get npLrcCreatedBy => '作成者';

  @override
  String get npLrcOffset => 'オフセット (ms)';

  @override
  String get npLrcHint => '同じ名前の .lrc ファイルを音声ファイルと同じ場所に置いてください。';

  @override
  String get npEqFlat => 'フラット';

  @override
  String get npEqBassBoost => '低音強調';

  @override
  String get npEqTrebleBoost => '高音強調';

  @override
  String get npEqVocal => 'ボーカル';

  @override
  String get npEqRock => 'ロック';

  @override
  String get npEqJazz => 'ジャズ';

  @override
  String get npEqClassical => 'クラシック';

  @override
  String get npEqElectronic => 'エレクトロニック';

  @override
  String get npEqHipHop => 'ヒップホップ';

  @override
  String get npEqAcoustic => 'アコースティック';

  @override
  String npEqApplied(String preset) {
    return 'EQ: $preset';
  }

  @override
  String npEqError(String error) {
    return 'EQ エラー: $error';
  }

  @override
  String get npCrossfeedDesc => 'ステレオチャンネルをブレンドし、ヘッドホンでより自然に聴こえるようにします';

  @override
  String get npCrossfeedOff => 'オフ';

  @override
  String get npCrossfeedLight => '弱';

  @override
  String get npCrossfeedMedium => '中';

  @override
  String get npCrossfeedStrong => '強';

  @override
  String npCrossfeedApplied(String level) {
    return 'クロスフィード: $level';
  }

  @override
  String npDspError(String error) {
    return 'DSP エラー: $error';
  }

  @override
  String get npTransferTitle => '再生を転送';

  @override
  String get npNoOtherZones => '他に利用できるゾーンはありません';

  @override
  String npTransferredTo(String zone) {
    return '$zone に転送しました';
  }

  @override
  String npTransferError(String error) {
    return '転送エラー: $error';
  }

  @override
  String get npAlarmClock => '目覚まし';

  @override
  String npAlarmSetFor(String time) {
    return '$time にアラームを設定しました';
  }

  @override
  String npAlarmError(String error) {
    return 'アラームエラー: $error';
  }

  @override
  String get npAlarmCancelled => 'アラームを取り消しました';

  @override
  String get npPause => '一時停止';

  @override
  String get npStop => '停止';

  @override
  String get npRoleComposer => '作曲';

  @override
  String get npRoleLyricist => '作詞';

  @override
  String get npRoleArranger => '編曲';

  @override
  String get npRoleConductor => '指揮';

  @override
  String get npRolePerformer => '演奏';

  @override
  String get npRoleProducer => 'プロデューサー';

  @override
  String get npRoleMixer => 'ミキシング';

  @override
  String get npRoleEngineer => 'エンジニア';

  @override
  String get npCreditsEnriching => '補完中…';

  @override
  String get npCreditsEnrich => 'MusicBrainz で補完';

  @override
  String get npVolume => '音量';

  @override
  String get npChangeZone => 'ゾーンを切り替え';

  @override
  String get npZoneFallback => 'ゾーン';

  @override
  String get npFollowMe => 'フォローミー';

  @override
  String get npMovePlaybackTo => '再生の移動先…';

  @override
  String get npNowPlaying => '再生中';

  @override
  String get npTabMore => 'その他';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return 'スリープタイマー設定: $minutes 分(フェード: $fade 秒)';
  }

  @override
  String npSleepTimerError(String error) {
    return 'スリープタイマーのエラー: $error';
  }

  @override
  String get npSleepTimerCancelled => 'スリープタイマーを解除しました';

  @override
  String get npSleepDuration => '時間';

  @override
  String get npSleepCustom => 'カスタム';

  @override
  String get npSleepFadeOut => 'フェードアウト';

  @override
  String npSleepFadeDesc(int seconds) {
    return '最後の $seconds 秒間で音量が徐々にゼロまで下がります。';
  }

  @override
  String get npSleepStarting => '開始中…';

  @override
  String npSleepStart(String duration) {
    return '開始 ($duration)';
  }

  @override
  String get npSleepSelectDuration => '時間を選択';

  @override
  String get npSleepTimerActive => 'タイマー作動中';

  @override
  String get npSleepCancelTimer => 'タイマーを解除';

  @override
  String get npMoodChill => 'チル';

  @override
  String get npMoodParty => 'パーティー';

  @override
  String get npMoodFocus => '集中';

  @override
  String get npMoodEnergetic => 'エネルギッシュ';

  @override
  String get npNoZoneAvailable => '利用できるゾーンがありません';

  @override
  String npMoodNoTracks(String mood) {
    return '$mood の曲が見つかりません';
  }

  @override
  String get npMoodInvalidTrackIds => 'エラー: 無効な曲 ID';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 曲を再生中',
      one: '1 曲を再生中',
    );
    return '$mood ミックス: $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 曲をキューに追加しました',
      one: '1 曲をキューに追加しました',
    );
    return '$mood ミックス: $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Smart AutoPlay エラー: $error';
  }

  @override
  String get npSmartAutoplayDesc => 'ムードを選ぶとスマートプレイリストを作成します';

  @override
  String get npAlarmsNotConnected => 'リモートサーバーに接続されていません';

  @override
  String get npAlarmSnoozed => 'アラームを 5 分スヌーズしました';

  @override
  String get npAlarmsTitle => 'アラーム';

  @override
  String get npAlarmsEmpty => 'アラームはありません';

  @override
  String npZoneNumbered(String id) {
    return 'ゾーン $id';
  }

  @override
  String get npAlarmSkipsHolidays => '祝日を除く';

  @override
  String get npAlarmSnooze => 'スヌーズ';

  @override
  String get npAlarmDefaultName => 'アラーム';

  @override
  String get npAlarmEdit => 'アラームを編集';

  @override
  String get npAlarmNew => '新規アラーム';

  @override
  String get npAlarmTime => '時刻';

  @override
  String get npAlarmNameHint => '起床';

  @override
  String get npAlarmDays => '曜日';

  @override
  String get npAlarmSkipHolidays => '祝日はスキップ';

  @override
  String get npAlarmCountry => '国:';

  @override
  String get npCountryFR => 'フランス';

  @override
  String get npCountryBE => 'ベルギー';

  @override
  String get npCountryCH => 'スイス';

  @override
  String get npCountryCA => 'カナダ';

  @override
  String get npCountryUS => 'アメリカ';

  @override
  String get npCountryDE => 'ドイツ';

  @override
  String get npCountryGB => 'イギリス';

  @override
  String get npAlarmSource => 'ソース';

  @override
  String get npAlarmSourceType => '種類';

  @override
  String get npSourceRadio => 'ラジオ';

  @override
  String get npSourcePlaylist => 'プレイリスト';

  @override
  String get npSourceAlbum => 'アルバム';

  @override
  String get npAlarmSourceName => 'ソース名';

  @override
  String get npAlarmPlaylistId => 'プレイリスト ID';

  @override
  String get npAlarmAlbumId => 'アルバム ID';

  @override
  String get npAlarmIdentifier => '識別子';

  @override
  String get npAlarmPlaybackZone => '再生ゾーン';

  @override
  String get npAlarmDefaultZone => 'デフォルト';

  @override
  String npAlarmVolume(int percent) {
    return '音量: $percent%';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return 'フェードイン: $seconds 秒';
  }

  @override
  String get npAlarmEnabled => '有効';

  @override
  String get npAlarmDeleteTitle => 'アラームを削除しますか?';

  @override
  String get npDayMon => '月';

  @override
  String get npDayTue => '火';

  @override
  String get npDayWed => '水';

  @override
  String get npDayThu => '木';

  @override
  String get npDayFri => '金';

  @override
  String get npDaySat => '土';

  @override
  String get npDaySun => '日';

  @override
  String get plHubTitle => 'プレイリストハブ';

  @override
  String get plTabSmartAi => 'AI';

  @override
  String get plTabTransfers => '転送';

  @override
  String get plSync => '同期';

  @override
  String get plTabBackup => 'バックアップ';

  @override
  String get plCompare => '比較';

  @override
  String get plComparing => '比較中…';

  @override
  String plCompareError(String detail) {
    return '比較に失敗しました: $detail';
  }

  @override
  String get plNoPlaylistsAvailable => '利用できるプレイリストはありません';

  @override
  String get plSectionSource => 'ソース';

  @override
  String get plSectionTarget => '転送先';

  @override
  String get plServiceLabel => 'サービス';

  @override
  String get plPlaylistLabel => 'プレイリスト';

  @override
  String get plLocal => 'ローカル';

  @override
  String get plRestore => '復元';

  @override
  String get plSyncIntervalTitle => '自動同期の間隔';

  @override
  String get plSyncIntervalLabel => '分（0 = 手動のみ）:';

  @override
  String get plSyncIntervalHint => '例: 60';

  @override
  String get plNoTransfers => '転送はありません';

  @override
  String get plNoSyncLinks => '同期リンクはありません';

  @override
  String get plNoSyncLinksHint => '転送からリンクを作成できます';

  @override
  String plAutoEveryMinutes(String minutes) {
    return '自動 $minutes 分';
  }

  @override
  String plSyncError(String detail) {
    return '同期に失敗しました: $detail';
  }

  @override
  String get plSectionBackup => 'バックアップ';

  @override
  String get plBackingUp => 'バックアップ中…';

  @override
  String get plBackupAll => 'すべてのプレイリストをバックアップ';

  @override
  String get plSectionSnapshots => 'スナップショット';

  @override
  String get plNoSnapshots => 'スナップショットはありません。バックアップを実行して作成してください。';

  @override
  String get plMergeDone => 'プレイリストを結合しました。';

  @override
  String plMergeError(String detail) {
    return '結合に失敗しました: $detail';
  }

  @override
  String get plNameLabel => '名前';

  @override
  String plDeleteNamed(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String plImportedLocal(String name) {
    return '「$name」をローカルに読み込みました。';
  }

  @override
  String plImportError(String detail) {
    return '読み込みに失敗しました: $detail';
  }

  @override
  String get plFilterAll => 'すべて';

  @override
  String get plMerge => '結合';

  @override
  String get plCancelMerge => '結合をキャンセル';

  @override
  String get plMerging => '結合中…';

  @override
  String get plImportToLocal => 'ローカルに読み込む';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件選択',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => '重複を除く';

  @override
  String get plMergedNameHint => '結合後のプレイリスト名';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 曲',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => '結果';

  @override
  String get plCommon => '共通';

  @override
  String get plSourceOnly => 'ソースのみ';

  @override
  String get plTargetOnly => '転送先のみ';

  @override
  String plMatchRate(String rate) {
    return '一致率 $rate%';
  }

  @override
  String plOnlyInSource(int count) {
    return 'ソースのみ（$count）';
  }

  @override
  String plOnlyInTarget(int count) {
    return '転送先のみ（$count）';
  }

  @override
  String plMoreCount(int count) {
    return '他 $count 件';
  }

  @override
  String get plTransferPlaylistTitle => 'プレイリストを転送';

  @override
  String get plCreateOnRemote => 'リモートサービスに作成';

  @override
  String get plTransfer => '転送';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return '転送: 一致 $matched、近似 $approximate、未検出 $notFound。';
  }

  @override
  String get plRecover => '修復';

  @override
  String plRecoverDone(int available, int alternatives) {
    return '修復: 利用可能 $available、代替候補 $alternatives 件。';
  }

  @override
  String plCopyName(String name) {
    return '$name（コピー）';
  }

  @override
  String get plDuplicate => '複製';

  @override
  String plDuplicated(String name) {
    return '複製しました: $name';
  }

  @override
  String plDeleted(String name) {
    return '削除しました: $name';
  }

  @override
  String plTransferred(String name) {
    return '転送しました: $name';
  }

  @override
  String get plTransferToLocal => 'ローカルに転送';

  @override
  String get plExportJson => 'JSON で書き出す';

  @override
  String get plExportCsv => 'CSV で書き出す';

  @override
  String get plExportM3u => 'M3U で書き出す';

  @override
  String get plExportJsonDone => 'JSON の書き出しが完了しました';

  @override
  String get plExportCsvDone => 'CSV の書き出しが完了しました';

  @override
  String plExportM3uDone(String path) {
    return 'M3U を書き出しました: $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'M3U の書き出しに失敗しました: $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '読み込みました: $name（$count 曲）',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'M3U の読み込みに失敗しました: $detail';
  }

  @override
  String get plSmartTitle => 'スマートプレイリスト';

  @override
  String plSmartLoadError(String detail) {
    return 'スマートプレイリストを読み込めませんでした: $detail';
  }

  @override
  String plDeleteError(String detail) {
    return '削除に失敗しました: $detail';
  }

  @override
  String get plSmartEmpty => 'スマートプレイリストはありません';

  @override
  String get plUntitled => '無題';

  @override
  String get plSmartDeleteTitle => 'スマートプレイリストを削除しますか？';

  @override
  String plPreviewError(String detail) {
    return 'プレビューに失敗しました: $detail';
  }

  @override
  String get plEnterName => '名前を入力してください';

  @override
  String plSaveError(String detail) {
    return '保存に失敗しました: $detail';
  }

  @override
  String get plSmartEditTitle => 'スマートプレイリストを編集';

  @override
  String get plSmartNewTitle => '新規スマートプレイリスト';

  @override
  String get plMatchLabel => '一致条件';

  @override
  String get plMatchAll => 'すべてのルール';

  @override
  String get plMatchAny => 'いずれかのルール';

  @override
  String get plSectionRules => 'ルール';

  @override
  String get plAddRule => 'ルールを追加';

  @override
  String get plMaxTracksLabel => '最大曲数（任意）';

  @override
  String get plNoLimit => '制限なし';

  @override
  String get plPreviewMatching => '一致する曲をプレビュー';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '一致する曲: $count',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => '値';

  @override
  String get plUnknownTitle => '不明';

  @override
  String plTracksLoadError(String detail) {
    return '曲を読み込めませんでした: $detail';
  }

  @override
  String get plSmartNoTracks => 'このプレイリストに一致する曲はありません';

  @override
  String get plFieldGenre => 'ジャンル';

  @override
  String get plFieldArtist => 'アーティスト';

  @override
  String get plFieldAlbum => 'アルバム';

  @override
  String get plFieldTitle => 'タイトル';

  @override
  String get plFieldYear => '年';

  @override
  String get plFieldRating => '評価';

  @override
  String get plFieldPlayCount => '再生回数';

  @override
  String get plFieldDuration => '長さ（ms）';

  @override
  String get plFieldDateAdded => '追加日';

  @override
  String get plFieldFavorite => 'お気に入り';

  @override
  String get plOpContains => 'を含む';

  @override
  String get plOpEquals => 'と等しい';

  @override
  String get plOpStartsWith => 'で始まる';

  @override
  String get plOpEndsWith => 'で終わる';

  @override
  String get plOpGreaterThan => 'より大きい';

  @override
  String get plOpLessThan => 'より小さい';

  @override
  String get plOpIs => 'である';

  @override
  String get plOpIsNot => 'ではない';

  @override
  String get srvConfigTitle => 'サーバー設定';

  @override
  String srvFolderAdded(String path) {
    return 'フォルダを追加しました: $path';
  }

  @override
  String get srvRemoveFolderTitle => 'このフォルダを削除しますか？';

  @override
  String srvScanStarted(String path) {
    return 'スキャンを開始しました: $path';
  }

  @override
  String get srvFullScanStarted => 'フルスキャンを開始しました';

  @override
  String get srvRestartTitle => 'サーバーを再起動しますか？';

  @override
  String get srvRestartBody => 'サーバーを停止して再起動します。再生中の音楽は中断されます。';

  @override
  String get srvRestartBtn => '再起動';

  @override
  String get srvRestarting => 'サーバーを再起動中…';

  @override
  String get srvRestartInProgress => '再起動中…';

  @override
  String get srvLoadError => '読み込みエラー';

  @override
  String get srvScanFolderTooltip => 'このフォルダをスキャン';

  @override
  String get srvSectionServerInfo => 'サーバー情報';

  @override
  String get srvInfoVersion => 'バージョン';

  @override
  String get srvInfoEngine => 'エンジン';

  @override
  String get srvInfoDatabase => 'データベース';

  @override
  String get srvSectionActions => '操作';

  @override
  String get srvRestartServer => 'サーバーを再起動';

  @override
  String get srvRestartServerDesc => 'サーバープロセスを停止して再起動します';

  @override
  String get srvManualEntry => '手動で入力';

  @override
  String srvSelectPath(String path) {
    return '「$path」を選択';
  }

  @override
  String get srvBrowse => '参照…';

  @override
  String get srvFolderPathHint => '/path/to/music';

  @override
  String get srvFolderPathHelp => 'サーバー上のフォルダの絶対パスを入力してください。';

  @override
  String get srvNoSubfolders => 'サブフォルダはありません';

  @override
  String get srvPluginsTitle => 'プラグイン';

  @override
  String get srvNotConnectedToServer => 'サーバーに接続されていません';

  @override
  String srvPluginInstalled(String name) {
    return '$name をインストールしました';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name をアンインストールしました';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name を更新しました';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name を有効にしました';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name を無効にしました';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return 'インストールに失敗しました: $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return 'アンインストールに失敗しました: $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return '更新に失敗しました: $error';
  }

  @override
  String get srvPluginsTabStore => 'ストア';

  @override
  String get srvPluginsTabInstalled => 'インストール済み';

  @override
  String get srvRestartRequired => '変更を適用するには再起動が必要です';

  @override
  String get srvPluginsSearchHint => 'プラグインを検索…';

  @override
  String get srvPluginsNoneFound => 'プラグインが見つかりません';

  @override
  String get srvPluginsNoneInstalled => 'インストール済みのプラグインはありません';

  @override
  String get srvPluginsBrowseStore => 'ストアを見る';

  @override
  String get srvPluginBadgeFeatured => 'おすすめ';

  @override
  String get srvPluginBadgeUpdate => 'アップデート';

  @override
  String get srvPluginBadgeIncompatible => '非対応';

  @override
  String srvPluginByAuthor(String author) {
    return '作者: $author';
  }

  @override
  String get srvPluginActionUpdate => '更新';

  @override
  String get srvPluginActionInstall => 'インストール';

  @override
  String get srvPluginActionUninstall => 'アンインストール';

  @override
  String get srvPluginStatusActive => '有効';

  @override
  String get srvPluginStatusError => 'エラー';

  @override
  String get srvAutoFixTitle => 'メタデータの自動修正';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の修正を適用しました',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence => '信頼度の高い修正は残っていません';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '残りの提案: $count 件',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => '高信頼度を適用';

  @override
  String srvAutoFixTrackNumber(int id) {
    return 'トラック #$id';
  }

  @override
  String get srvAutoFixCurrent => '現在';

  @override
  String get srvAutoFixEmpty => '（空）';

  @override
  String get srvAutoFixSuggested => '提案';

  @override
  String get srvAutoFixSkip => 'スキップ';

  @override
  String get srvAutoFixApply => '適用';

  @override
  String get srvAutoFixIntroTitle => '不足しているメタデータを修正';

  @override
  String get srvAutoFixIntroBody =>
      'ジャンル・年・MusicBrainz ID が欠けているトラックをスキャンし、MusicBrainz から修正を提案します。';

  @override
  String get srvAutoFixStartScan => 'スキャン開始';

  @override
  String get srvAutoFixScanning => 'MusicBrainz を検索中…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total トラック（$pct%）';
  }

  @override
  String get srvAutoFixLoadingTracks => 'トラックを読み込み中…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'これまでに $count 件の修正が見つかりました',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit => '1 リクエスト/秒に制限（MusicBrainz のポリシー）';

  @override
  String get srvAutoFixNoneNeeded => '修正の必要はありません';

  @override
  String get srvAutoFixAllComplete => 'すべてのトラックのメタデータが揃っています。';

  @override
  String get srvAutoFixScanAgain => '再スキャン';

  @override
  String get srvAutoFixScanFailed => 'スキャンに失敗しました';

  @override
  String get srvMpStepSetup => '設定';

  @override
  String get srvMpStepFineTune => '微調整';

  @override
  String get srvMpListenTitle => 'どのように聴きますか？';

  @override
  String get srvMpListenSubtitle => 'プロファイルはリスニング環境に合わせて調整されます';

  @override
  String get srvMpSpeakers => 'スピーカー';

  @override
  String get srvMpSpeakersSub => 'リスニングルーム';

  @override
  String get srvMpHeadphones => 'ヘッドホン';

  @override
  String get srvMpHeadphonesSub => 'パーソナルリスニング';

  @override
  String get srvMpRoomTitle => '部屋の広さは？';

  @override
  String get srvMpRoomSubtitle => '低音域と残響に影響します';

  @override
  String get srvMpRoomSmall => '小';

  @override
  String get srvMpRoomMedium => '中';

  @override
  String get srvMpRoomLarge => '大';

  @override
  String get srvMpPlacementTitle => 'スピーカーの配置';

  @override
  String get srvMpPlacementSubtitle => '配置は低音の反射に影響します';

  @override
  String get srvMpNearWall => '壁の近く';

  @override
  String get srvMpFreeStanding => '壁から離して';

  @override
  String get srvMpTuneSound => 'サウンドを調整';

  @override
  String get srvMpCorrectionActive => '補正を有効化';

  @override
  String get srvMpCorrectionDesc => '現在のゾーンにプロファイルを適用します';

  @override
  String get srvMpBass => '低音';

  @override
  String get srvMpBassDesc => '音の重み、温かみ、厚み';

  @override
  String get srvMpBassLow => '軽い';

  @override
  String get srvMpBassHigh => '重い';

  @override
  String get srvMpMid => 'ボーカル／中音域';

  @override
  String get srvMpMidDesc => '存在感、明瞭さ、聞き取りやすさ';

  @override
  String get srvMpMidLow => '控えめ';

  @override
  String get srvMpMidHigh => '前に出る';

  @override
  String get srvMpTreble => '高音';

  @override
  String get srvMpTrebleDesc => '輝き、ディテール、空気感';

  @override
  String get srvMpTrebleLow => '暗い';

  @override
  String get srvMpTrebleHigh => '明るい';

  @override
  String get srvMpProfileApplied => 'プロファイルを適用しました';

  @override
  String get srvMpApplying => '適用中…';

  @override
  String get srvMpApply => 'プロファイルを適用';

  @override
  String get srvMpBackToQuestions => '質問に戻る';

  @override
  String get srvRemoteConfigBody => 'ネットワーク上の Tune サーバーに接続すると、すべての機能を利用できます。';

  @override
  String get srvModeStandalone => 'スタンドアロン';

  @override
  String get srvStandaloneWarning =>
      'スタンドアロンモードでは、Party、DJ、同期歌詞、EQ、おすすめ機能は使えません。リモートの Tune サーバーの利用をおすすめします。';

  @override
  String get srvServerAddress => 'サーバーアドレス';

  @override
  String get srvNoServerYet => 'サーバーをお持ちでないですか？';

  @override
  String get srvDownloadServer =>
      'Tune Server のダウンロード: mozaiklabs.fr/download（Mac、Linux、Windows、Raspberry Pi、Docker NAS）';

  @override
  String get srvStreamingBody => 'Tune で使うストリーミングサービスを有効にしてください。';

  @override
  String get srvStreamingStandaloneWarning =>
      'スタンドアロンモードではストリーミングサービスを利用できません。有効にするにはリモートサーバーモードに切り替えてください。';

  @override
  String get srvNoServiceAvailable => '利用できるサービスがありません。サーバーへの接続を確認してください。';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のサービスが有効',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件が接続済み',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => '有効・未接続';

  @override
  String get srvAudioCheckTitle => 'オーディオ診断';

  @override
  String get srvAudioCheckBody => 'システムのオーディオ設定を確認しています。';

  @override
  String get srvDiagZones => '設定済みゾーン';

  @override
  String get srvDiagOutputs => 'オーディオ出力';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件検出',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => 'ネットワーク機器';

  @override
  String get srvDiagNone => 'なし';

  @override
  String get srvDiagNoZoneWarning => 'ゾーンが設定されていません。ゾーン設定から作成できます。';

  @override
  String srvAudioCheckUnavailable(String error) {
    return 'オーディオ診断を利用できません: $error';
  }

  @override
  String get srvRecheck => '再確認';

  @override
  String get srvScanBody => 'スキャンを開始して音楽ファイルをインデックスし、メタデータを取得します。';

  @override
  String get srvScanStart => 'スキャン開始';

  @override
  String get srvScanStatScanned => 'スキャン済み';

  @override
  String get srvScanStatAdded => '追加';

  @override
  String get srvScanStatUpdated => '更新';

  @override
  String get srvScanMayTakeMinutes => '数分かかる場合があります…';

  @override
  String get srvScanComplete => 'スキャン完了！';

  @override
  String stgUpdateAvailable(String version) {
    return 'アップデートがあります: v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return '現在のバージョン: v$version';
  }

  @override
  String get stgOpen => '開く';

  @override
  String get stgMode => 'モード';

  @override
  String stgConnectedTo(String address) {
    return '$address に接続済み';
  }

  @override
  String get stgModeRemote => 'リモート';

  @override
  String get stgStandaloneTitle => 'スタンドアロンモード — 機能制限あり';

  @override
  String get stgStandaloneBody =>
      'Party、DJ、同期歌詞、EQ、アルバム解説、おすすめ…にはリモートの Tune サーバーが必要です。';

  @override
  String get stgServerAddress => 'サーバーアドレス';

  @override
  String get stgNotConfigured => '未設定';

  @override
  String get stgScanNetwork => 'ネットワークをスキャン';

  @override
  String get stgSectionPlayback => '再生';

  @override
  String get stgCrossfade => 'クロスフェード';

  @override
  String get stgRepeatOneByDefault => 'デフォルトでリピート';

  @override
  String get stgExclusiveMode => '排他モード (ビットパーフェクト)';

  @override
  String get stgExclusiveModeDesc => 'WASAPI Exclusive — USB DAC へ直接アクセス';

  @override
  String get stgSectionMetadataFields => 'メタデータ項目';

  @override
  String get stgSectionAdvancedAudio => '詳細オーディオ';

  @override
  String get stgEqualizer => 'イコライザー';

  @override
  String get stgEqualizerDesc => 'キャリブレーションアシスタント + 10バンド エキスパートEQ';

  @override
  String get stgMetadataFieldsDesc => '拡張項目を設定 (作曲者、指揮者…)';

  @override
  String get stgSpotifyConnectDesc => 'Tune をレシーバーとして使用 (クライアント側で Premium が必要)';

  @override
  String get stgLastfmDesc => '再生履歴を Scrobble';

  @override
  String get stgListenBrainzDesc => 'ListenBrainz に Scrobble';

  @override
  String get stgAutoFixMetadata => 'メタデータの自動修正';

  @override
  String get stgAutoFixMetadataDesc => '不足しているジャンル・年・MBID を MusicBrainz で補完';

  @override
  String get stgDatabase => 'データベース';

  @override
  String get stgImportExport => 'インポート / エクスポート';

  @override
  String get stgSectionProfiles => 'プロフィール';

  @override
  String get stgSectionSystem => 'システム';

  @override
  String get stgServerConfig => 'サーバー設定';

  @override
  String get stgServerConfigDesc => '音楽フォルダ、スキャン、再起動';

  @override
  String get stgNetworkDiagnostics => 'ネットワーク診断';

  @override
  String get stgNetworkDiagnosticsDesc => 'マルチキャスト、DNS、接続性';

  @override
  String get stgConfiguration => '設定';

  @override
  String get stgExportImport => 'エクスポート / インポート';

  @override
  String get stgPlugins => 'プラグイン';

  @override
  String get stgPluginsDesc => 'インストール済みの拡張機能';

  @override
  String get stgNetworkShares => 'ネットワーク共有 (SMB)';

  @override
  String get stgNetworkSharesDesc => '共有を検出してマウント';

  @override
  String get stgSectionCloud => 'クラウド';

  @override
  String get stgSectionHelp => 'ヘルプ';

  @override
  String get stgTroubleshooting => 'トラブルシューティング';

  @override
  String get stgTroubleshootingDesc => 'よくある質問と解決方法';

  @override
  String get stgSendBugReport => 'バグレポートを送信';

  @override
  String get stgSendBugReportDesc => '技術レポートを生成してコピー';

  @override
  String get stgServerAddressHint => 'IP またはホスト名 (例: 192.168.1.18)';

  @override
  String get stgServerPort => 'サーバーポート';

  @override
  String get stgPortDefaultHint => 'ポート (デフォルト: 8888)';

  @override
  String get stgWarnNoZones => 'ゾーンが設定されていません。再生を始めるにはゾーンを作成してください。';

  @override
  String get stgWarnNoNetworkDevices =>
      'ネットワークデバイスが見つかりません (DLNA/BluOS/Chromecast)。';

  @override
  String get stgSectionAudio => 'オーディオ';

  @override
  String get stgAudioOutputs => 'オーディオ出力';

  @override
  String stgOutputsDetected(int count) {
    return '$count 件検出';
  }

  @override
  String get stgNetworkDevices => 'ネットワークデバイス';

  @override
  String get stgZoneNameHint => '例: リビング、書斎';

  @override
  String get stgProfileActivated => 'プロフィールを有効にしました';

  @override
  String get stgNewProfile => '新しいプロフィール';

  @override
  String get stgProfileName => 'プロフィール名';

  @override
  String get stgProfileNameHint => '例: 夜、朝';

  @override
  String get stgProfileUpdated => 'プロフィールを更新しました';

  @override
  String get stgNoProfiles => 'プロフィールがありません';

  @override
  String get stgProfile => 'プロフィール';

  @override
  String get stgEditProfile => 'プロフィールを編集';

  @override
  String get stgName => '名前';

  @override
  String get stgColor => 'カラー';

  @override
  String get stgScanInProgress => 'ネットワークをスキャン中…';

  @override
  String stgScanChecking(int scanned, int total) {
    return '確認中 $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'Tune サーバーが見つかりません';

  @override
  String stgServersFound(int count) {
    return '$count 台のサーバーが見つかりました';
  }

  @override
  String get stgTuneServers => 'Tune サーバー';

  @override
  String get stgFieldFormat => 'フォーマット (FLAC、MP3…)';

  @override
  String get stgFieldSampleRate => 'サンプルレート (96 kHz)';

  @override
  String get stgFieldBitDepth => 'ビット深度 (24bit)';

  @override
  String get stgFieldLabel => 'レーベル';

  @override
  String get stgFieldComposer => '作曲者';

  @override
  String get stgFieldDuration => '再生時間';

  @override
  String get stgFieldSource => 'ソース (Tidal、Qobuz…)';

  @override
  String get stgMetadataFieldsIntro => '各トラックの下に表示する項目 (検索、ライブラリ、キュー、履歴)';

  @override
  String get stgAudiophileMode => 'オーディオファイルモード';

  @override
  String get stgAudiophileModeDesc => 'DSP バイパス、EQ 無効、ビットパーフェクト';

  @override
  String get stgCloudAccount => 'クラウドアカウント';

  @override
  String stgConnectedAs(String email) {
    return '接続済み ($email)';
  }

  @override
  String get stgTelemetry => 'テレメトリー';

  @override
  String get stgTelemetryDesc => '匿名の利用統計を送信';

  @override
  String get stgSyncingLibrary => 'ライブラリを同期中…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total トラック';
  }

  @override
  String get stgConnectingStreaming => 'ストリーミングサービスに接続中…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'v$version の新機能';
  }

  @override
  String get stgWhatsNewLibrarySync => 'ライブラリ同期を改善';

  @override
  String get stgWhatsNewMultiRoom => 'マルチルームとゾーン管理を最適化';

  @override
  String get stgWhatsNewBugFixes => 'バグ修正と安定性の向上';

  @override
  String get stgStartServerFailed => 'サーバーを起動できませんでした';

  @override
  String stgStartServerFailedWith(String detail) {
    return 'サーバーを起動できませんでした: $detail';
  }

  @override
  String get stgConnectionFailed => '接続に失敗しました';

  @override
  String stgConnectionFailedWith(String detail) {
    return '接続に失敗しました: $detail';
  }

  @override
  String get stgStartingServer => 'Tune Server を起動中…';

  @override
  String get stgTagline => 'マルチルーム音楽サーバー';

  @override
  String get stgLocalServer => 'ローカルサーバー';

  @override
  String get stgLocalServerDesc => 'このデバイスで Tune を実行します。\nあなたの音楽を、あなたのルールで。';

  @override
  String get stgRemoteControl => 'リモコン';

  @override
  String get stgRemoteControlDesc => 'ネットワーク上の\nTune サーバーに接続します。';

  @override
  String get stgRemoteConnection => 'リモート接続';

  @override
  String get znZoneManagerTitle => 'ゾーンマネージャー';

  @override
  String get znCannotDeleteLastZone => '最後のゾーンは削除できません';

  @override
  String znZoneSwitchError(String error) {
    return 'ゾーンの切り替えに失敗しました: $error';
  }

  @override
  String get znZoneSettings => 'ゾーン設定';

  @override
  String get znPhoneSpeakers => 'スマートフォンのスピーカー';

  @override
  String get znBtConnectedOutputs => '接続中の Bluetooth 出力';

  @override
  String get znBtSystemOutput => 'システムの出力を使用（コントロールセンター）';

  @override
  String get znBtOutputsTitle => 'Bluetooth 出力';

  @override
  String get znBtNoDevice =>
      '接続中の Bluetooth デバイスがありません。システム設定でデバイスをペアリングしてください。';

  @override
  String get znBtAndroidRouting => '実際の出力先は Android のシステム設定によって決まります。';

  @override
  String get znDsdMode => 'DSD モード';

  @override
  String get znDsdAuto => '自動';

  @override
  String get znDsdNative => 'ネイティブ';

  @override
  String get znGaplessDlnaDesc => '曲間を途切れなくつなぐ（DLNA）';

  @override
  String get znFixedVolume => '固定音量';

  @override
  String get znFixedVolumeDesc => 'ソフトウェアによる音量調整を無効にします';

  @override
  String get znCap16Bit => '16 ビットに制限';

  @override
  String get znCap16BitDesc =>
      'ハイレゾ（24 ビット）が無音で 16 ビットは再生できる場合に有効にします（Ruark R3）。16 ビット FLAC に変換します。';

  @override
  String get znZoneMuted => 'ゾーンをミュートしました';

  @override
  String get znZoneUnmuted => 'ミュートを解除しました';

  @override
  String znErrMute(String error) {
    return 'ミュートエラー: $error';
  }

  @override
  String znErrVolume(String error) {
    return '音量エラー: $error';
  }

  @override
  String znErrLatency(String error) {
    return 'レイテンシーエラー: $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return 'グループ音量エラー: $error';
  }

  @override
  String get znCalibrationDone => 'キャリブレーションが完了しました';

  @override
  String znErrCalibration(String error) {
    return 'キャリブレーションエラー: $error';
  }

  @override
  String znErrDissolve(String error) {
    return 'グループを解除できませんでした: $error';
  }

  @override
  String get znRenameGroupTitle => 'グループ名を変更';

  @override
  String get znNewNameHint => '新しい名前';

  @override
  String get znRename => '名前を変更';

  @override
  String get znGroupRenamed => 'グループ名を変更しました';

  @override
  String znErrRename(String error) {
    return '名前変更エラー: $error';
  }

  @override
  String get znGroupNeedTwoZones => 'グループを作成するには 2 つ以上のゾーンが必要です';

  @override
  String get znGroupNameLabel => 'グループ名';

  @override
  String get znGroupNameHint => '例: リビング + キッチン';

  @override
  String get znChooseLeader => 'リーダーを選択';

  @override
  String get znMembers => 'メンバー';

  @override
  String znErrCreateGroup(String error) {
    return 'グループを作成できませんでした: $error';
  }

  @override
  String get znProfileActivated => 'プロファイルを有効にしました';

  @override
  String znErrActivate(String error) {
    return '有効化エラー: $error';
  }

  @override
  String get znProfileDeleted => 'プロファイルを削除しました';

  @override
  String znErrDelete(String error) {
    return '削除エラー: $error';
  }

  @override
  String get znNoOfflineZones => '削除するオフラインのゾーンはありません';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'オフラインのゾーンを $count 件削除しました',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return 'クリーンアップエラー: $error';
  }

  @override
  String get znSaveConfigTitle => '構成を保存';

  @override
  String get znProfileNameLabel => 'プロファイル名';

  @override
  String get znProfileNameHint => '例: パーティー、静かな朝';

  @override
  String get znDescriptionOptional => '説明（任意）';

  @override
  String get znNameRequired => '名前を入力してください';

  @override
  String get znProfileSaved => 'プロファイルを保存しました';

  @override
  String znErrSave(String error) {
    return '保存エラー: $error';
  }

  @override
  String get znCleanupOffline => 'オフラインのゾーンを整理';

  @override
  String get znRemoteRequired => 'ゾーンマネージャーにはリモートサーバーへの接続が必要です。';

  @override
  String get znDataUnavailable => 'データを取得できません';

  @override
  String get znGroups => 'グループ';

  @override
  String get znNoGroups => 'グループなし';

  @override
  String get znGroupFallback => 'グループ';

  @override
  String znZoneFallback(String id) {
    return 'ゾーン $id';
  }

  @override
  String get znCalibrate => 'キャリブレーション';

  @override
  String get znDissolve => '解除';

  @override
  String get znProfiles => 'プロファイル';

  @override
  String get znNoProfiles => '保存済みのプロファイルはありません';

  @override
  String get znSaveConfigButton => '構成を保存';

  @override
  String get znProfileFallback => 'プロファイル';

  @override
  String get znPins => 'ピン';

  @override
  String znPinFallback(int n) {
    return 'ピン $n';
  }

  @override
  String znPinInvoked(int n) {
    return 'ピン $n を実行しました';
  }

  @override
  String znPinInvokeError(String error) {
    return 'ピンを実行できませんでした: $error';
  }

  @override
  String get znNoPins => 'ピンが設定されていません';

  @override
  String get znMute => 'ミュート';

  @override
  String get znUnmute => 'ミュート解除';

  @override
  String get znLatency => 'レイテンシー';

  @override
  String get znLatencyError => 'エラー';

  @override
  String znPartyAddError(String error) {
    return '曲を追加できませんでした: $error';
  }

  @override
  String znPartyVoteError(String error) {
    return '投票エラー: $error';
  }

  @override
  String get znPartyLinkCopied => 'パーティーのリンクをクリップボードにコピーしました';

  @override
  String get znPartyTitle => 'パーティーモード';

  @override
  String get znPartyShareLink => 'パーティーのリンクを共有';

  @override
  String get znPartyAddHint => '曲を追加…';

  @override
  String get znPartyQueue => 'キュー';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 曲',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => '不明なゾーン';

  @override
  String get znUnknownTitle => '不明';

  @override
  String get znNowPlaying => '再生中';

  @override
  String get znUpvote => '投票する';

  @override
  String znDjLoadOnDeck(String deck) {
    return 'デッキ $deck に曲を読み込む';
  }

  @override
  String get znDjSearchHint => '曲を検索…';

  @override
  String get znDjSearchHelp => '曲名を入力して「検索して読み込む」をタップ';

  @override
  String get znDjNoTracksFound => '曲が見つかりません';

  @override
  String znDjSearchError(String error) {
    return '検索エラー: $error';
  }

  @override
  String get znDjSearchAndLoad => '検索して読み込む';

  @override
  String znDjLoadError(String error) {
    return '読み込みエラー: $error';
  }

  @override
  String znDjPlayError(String error) {
    return '再生エラー: $error';
  }

  @override
  String znDjPauseError(String error) {
    return '一時停止エラー: $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return 'クロスフェードエラー: $error';
  }

  @override
  String get znDjTitle => 'DJ モード';

  @override
  String get znDjDisabled => 'DJ モードはオフです';

  @override
  String get znDjEnableHint => 'オンにするとミックスを始められます';

  @override
  String znDjDeck(String deck) {
    return 'デッキ $deck';
  }

  @override
  String get znDjCrossfade => 'クロスフェード';

  @override
  String znDjDuration(String seconds) {
    return '長さ: $seconds 秒';
  }

  @override
  String get znDjStartCrossfade => 'クロスフェードを開始';

  @override
  String get znDjAutoCrossfade => '自動クロスフェード';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return '同期 $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => '同期に失敗しました';

  @override
  String get znDjNoTrackLoaded => '曲が読み込まれていません';

  @override
  String get znDjLoadTrack => '曲を読み込む';

  @override
  String get znDjGain => 'ゲイン';

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

  @override
  String get plPremiumTransfer =>
      'サービス間、またはサービスからライブラリへのプレイリスト転送は Tune Premium の機能です。ライブラリのプレイリストの複製は引き続き無料です。';

  @override
  String get plPremiumConverter => 'プレイリストの日付付きコピーと同期リンクは Tune Premium の機能です。';

  @override
  String get plConverterMissing =>
      'このサーバーには Playlists converter プラグインが読み込まれていません。';

  @override
  String get plSeeOffer => 'プランを見る';

  @override
  String get plSnapshotsNoDelete =>
      '各プレイリストの最新 10 件のコピーが保存され、最も古いものは自動的に置き換えられます。';

  @override
  String plBackupAllDone(int ok, int failed) {
    return '$ok 件のプレイリストを保存、$failed 件失敗しました。';
  }

  @override
  String plRestoreRecreateAsk(String name) {
    return '「$name」を最新のコピーから作り直しますか？現在のプレイリストは変更も削除もされません。';
  }

  @override
  String plRestoreRecreated(String name) {
    return '「$name」を最新のコピーから作り直しました。';
  }

  @override
  String plSnapshotCopies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のコピー',
    );
    return '$_temp0';
  }

  @override
  String plIntervalAdjusted(int minutes) {
    return '間隔を $minutes 分に調整しました（15 分〜1 週間、または 0 で手動）。';
  }

  @override
  String plLinkSyncDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 曲を追加',
    );
    return '同期しました：$_temp0。';
  }
}
