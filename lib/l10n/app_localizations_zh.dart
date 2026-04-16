// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => '确定';

  @override
  String get btnCancel => '取消';

  @override
  String get btnAdd => '添加';

  @override
  String get btnSave => '保存';

  @override
  String get btnDelete => '删除';

  @override
  String get btnEdit => '编辑';

  @override
  String get btnClose => '关闭';

  @override
  String get btnRetry => '重试';

  @override
  String get btnCreate => '创建';

  @override
  String get btnClear => '清除';

  @override
  String get btnNext => '下一步';

  @override
  String get btnSkip => '跳过此步骤';

  @override
  String get btnFinish => '完成配置';

  @override
  String get btnStart => '开始';

  @override
  String get btnConnect => '连接';

  @override
  String get btnDisconnect => '断开连接';

  @override
  String get btnDownload => '下载';

  @override
  String get btnImport => '导入';

  @override
  String get btnExport => '导出';

  @override
  String get btnReset => '重置';

  @override
  String get btnUse => '使用';

  @override
  String get btnShuffle => '随机播放';

  @override
  String get btnSeeAll => '查看全部';

  @override
  String get btnRefresh => '刷新';

  @override
  String get btnScan => '扫描媒体库';

  @override
  String get btnAddFolder => '添加文件夹';

  @override
  String get actionIrreversible => '此操作不可逆。';

  @override
  String get rootStartError => '启动错误';

  @override
  String get playbackErrorNoZone => '未选择区域 — 请创建或选择区域';

  @override
  String get playbackErrorZoneNotFound => '未找到区域';

  @override
  String get playbackErrorFailed => '播放失败';

  @override
  String get navLibrary => '媒体库';

  @override
  String get navSearch => '搜索';

  @override
  String get navStreaming => '流媒体';

  @override
  String get navRadios => '收音机';

  @override
  String get navZones => '区域';

  @override
  String get navSettings => '设置';

  @override
  String get libraryTitle => '媒体库';

  @override
  String get tabAlbums => '专辑';

  @override
  String get tabArtists => '艺术家';

  @override
  String get tabTracks => '曲目';

  @override
  String get tabGenres => '流派';

  @override
  String get tabPlaylists => '播放列表';

  @override
  String get tabFavorites => '收藏';

  @override
  String get favoriteAdded => '已添加到收藏';

  @override
  String get favoriteRemoved => '已从收藏移除';

  @override
  String get libraryEmptyFavorites => '无收藏';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => '媒体库中没有专辑';

  @override
  String get libraryEmptyArtists => '媒体库中没有艺术家';

  @override
  String get libraryEmptyTracks => '媒体库中没有曲目';

  @override
  String get libraryEmptyGenres => '没有流派';

  @override
  String get libraryEmptyPlaylists => '没有播放列表';

  @override
  String get libraryNoFilterResults => '没有匹配筛选条件的专辑';

  @override
  String get libraryPlayAll => '全部播放';

  @override
  String get libraryAddTo => '添加到…';

  @override
  String get libraryEditAlbum => '编辑专辑';

  @override
  String get libraryEditTrack => '编辑曲目';

  @override
  String get libraryPlay => '播放';

  @override
  String get genresAllTracks => '所有曲目';

  @override
  String get playlistCreate => '创建播放列表';

  @override
  String get playlistName => '播放列表名称';

  @override
  String get playlistEmpty => '没有曲目';

  @override
  String get playlistAddTo => '添加到播放列表';

  @override
  String get playlistNewPlaylist => '新播放列表';

  @override
  String playlistTrackAdded(String name) {
    return '已添加到\"$name\"';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return '已在\"$name\"中';
  }

  @override
  String get playlistDeleteTitle => '删除播放列表？';

  @override
  String get playlistDeleteBody => '此播放列表将被永久删除。';

  @override
  String get searchHint => '搜索…';

  @override
  String get searchNoResults => '没有结果';

  @override
  String get searchSectionTracks => '曲目';

  @override
  String get searchSectionAlbums => '专辑';

  @override
  String get searchSectionArtists => '艺术家';

  @override
  String get searchSectionStreaming => '流媒体';

  @override
  String get homeRecentlyPlayed => '最近播放';

  @override
  String get homeLibrary => '媒体库';

  @override
  String get homeQuickAccess => '快速访问';

  @override
  String get homeHistory => '历史记录';

  @override
  String get homeBrowseDlna => '浏览DLNA';

  @override
  String get homeStatTracks => '曲目';

  @override
  String get homeStatAlbums => '专辑';

  @override
  String get homeStatArtists => '艺术家';

  @override
  String get historyTitle => '历史记录';

  @override
  String get historyEmpty => '没有历史记录';

  @override
  String get historyClear => '清除';

  @override
  String get historyClearTitle => '清除历史记录';

  @override
  String get nowPlayingNoTrack => '没有曲目';

  @override
  String get queueTitle => '播放队列';

  @override
  String get queueEmpty => '队列为空';

  @override
  String get zonesTitle => '区域';

  @override
  String get zonesNew => '新区域';

  @override
  String get zonesNewName => '区域名称';

  @override
  String get zonesNone => '没有区域';

  @override
  String get zonesRename => '重命名区域';

  @override
  String get zonesDelete => '删除区域';

  @override
  String get zonesDevices => '可用设备';

  @override
  String get zonesOutputLocal => '本地';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesOutputBluetooth => '蓝牙';

  @override
  String get zonesChangeOutput => '更改输出';

  @override
  String get zonesOutputTitle => '音频输出';

  @override
  String get zonesAssignDevice => '分配';

  @override
  String get zonesTransferTitle => '播放到...';

  @override
  String get zonesNowPlaying => '正在播放';

  @override
  String zonesActivated(String name) {
    return '活动区域: $name';
  }

  @override
  String get radiosTitle => '收音机';

  @override
  String get radiosTabAll => '全部';

  @override
  String get radiosTabFavorites => '收藏';

  @override
  String get radiosNone => '没有收音机';

  @override
  String get radiosFavNone => '没有收藏的收音机';

  @override
  String get radiosSavedFavorites => '已保存收藏';

  @override
  String get radiosAdd => '添加收音机';

  @override
  String get radiosName => '名称';

  @override
  String get radiosStreamUrl => '流媒体URL';

  @override
  String get radiosGenre => '流派（可选）';

  @override
  String get radiosPasteM3u => '粘贴M3U';

  @override
  String get radiosImportUrl => '从URL导入';

  @override
  String get radiosImportUrlLabel => 'M3U文件URL';

  @override
  String radiosImportResult(int count) {
    return '已导入$count个电台';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'HTTP错误 $code';
  }

  @override
  String get radiosImportFailed => '无法下载文件';

  @override
  String get radiosFavSaved => '曲目已保存';

  @override
  String get radioSaveFavorite => '保存曲目';

  @override
  String get radioFavTitle => '收音机收藏';

  @override
  String get radioFavEmpty => '没有已保存的收藏';

  @override
  String get radioFavExportCsv => '导出CSV';

  @override
  String get streamingTitle => '流媒体';

  @override
  String get streamingConnected => '已连接';

  @override
  String get streamingNotConnected => '未连接';

  @override
  String get streamingEmail => '电子邮件';

  @override
  String get streamingPassword => '密码';

  @override
  String get streamingSignIn => '登录';

  @override
  String get streamingSigningIn => '登录中…';

  @override
  String get streamingDeviceCode => '验证码';

  @override
  String get streamingOpenLink => '打开…';

  @override
  String get streamingLogoutTitle => '断开连接？';

  @override
  String streamingLogoutBody(String service) {
    return '从$service断开连接？';
  }

  @override
  String get streamingAuthError => '认证失败';

  @override
  String get streamingAlbumsSection => '专辑';

  @override
  String get streamingPlaylistsSection => '播放列表';

  @override
  String get browseTitle => '浏览';

  @override
  String get browseRefreshTooltip => '刷新';

  @override
  String get browseNoServers => '未检测到UPnP/DLNA服务器';

  @override
  String get browseNoServersHint => '请确保您的服务器在同一Wi-Fi网络上。';

  @override
  String get browseNoContent => '空文件夹';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionAppearance => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLangSystem => '系统';

  @override
  String get settingsSectionZones => '区域';

  @override
  String get settingsDefaultZone => '默认区域';

  @override
  String get settingsDefaultZoneAuto => '自动';

  @override
  String get settingsNoZones => '没有区域';

  @override
  String get settingsSectionServer => '服务器';

  @override
  String get settingsHttpPort => 'HTTP端口';

  @override
  String get settingsHttpPortDesc => '主服务器端口';

  @override
  String get settingsLocalIp => '本地IP地址';

  @override
  String get settingsSectionLibrary => '媒体库';

  @override
  String get settingsMetadata => '音乐与元数据';

  @override
  String get settingsMetadataDesc => '文件夹、扫描、统计';

  @override
  String get settingsSetupWizard => '设置向导';

  @override
  String get settingsSetupWizardDesc => '重新配置音乐来源';

  @override
  String get settingsSectionAbout => '关于';

  @override
  String get settingsVersion => '版本 0.1.0';

  @override
  String get settingsResetConfig => '重置配置';

  @override
  String get settingsResetTitle => '重置？';

  @override
  String get settingsResetBody => '所有首选项将被重置。下次启动时将显示启动向导。';

  @override
  String get settingsPortTitle => 'HTTP端口';

  @override
  String get settingsPortHint => '端口 (1024–65535)';

  @override
  String get metadataTitle => '音乐与元数据';

  @override
  String get metadataRefreshStats => '刷新统计';

  @override
  String get metadataSectionStats => '统计';

  @override
  String get metadataStatTracks => '曲目';

  @override
  String get metadataStatAlbums => '专辑';

  @override
  String get metadataStatArtists => '艺术家';

  @override
  String get metadataStatPlaylists => '播放列表';

  @override
  String get metadataStatRadios => '收音机';

  @override
  String get metadataStatArtwork => '封面缓存';

  @override
  String get metadataSectionScan => '媒体库扫描';

  @override
  String metadataScanInProgress(int current, int total) {
    return '扫描中… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return '上次扫描：+$added新增，$updated更新';
  }

  @override
  String get metadataScanBtn => '扫描媒体库';

  @override
  String get metadataScanDesc => '索引所有已配置的文件夹';

  @override
  String get metadataSectionFolders => '音乐文件夹';

  @override
  String get metadataFoldersNone => '没有配置文件夹';

  @override
  String metadataFolderAddedOn(String date) {
    return '添加于 $date';
  }

  @override
  String get metadataAddFolder => '添加文件夹';

  @override
  String get metadataFolderPath => '文件夹路径';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => '清理';

  @override
  String get metadataCleanupOrphans => '删除孤立项';

  @override
  String get metadataCleanupOrphansDesc => '没有曲目的专辑和艺术家';

  @override
  String get metadataClearLibrary => '清空媒体库';

  @override
  String get metadataClearLibraryDesc => '删除所有本地曲目';

  @override
  String get metadataCleanupOrphansTitle => '删除孤立项？';

  @override
  String get metadataCleanupOrphansBody => '没有关联曲目的专辑和艺术家将从数据库中删除。';

  @override
  String get metadataClearLibraryTitle => '清空媒体库？';

  @override
  String get metadataClearLibraryBody => '所有本地曲目、专辑和艺术家将被删除。此操作不可逆。';

  @override
  String get metadataOrphansDeleted => '孤立项已删除';

  @override
  String get metadataLibraryCleared => '媒体库已清空';

  @override
  String get metadataDeleteBtn => '删除';

  @override
  String get metadataClearBtn => '清空';

  @override
  String get setupWelcomeTitle => '欢迎使用\nTune Server';

  @override
  String get setupWelcomeBody =>
      '您的嵌入式多房间音乐服务器。将本地媒体库、流媒体服务和收音机传输到任何DLNA或AirPlay音箱。';

  @override
  String get setupStart => '开始';

  @override
  String get setupLocalTitle => '本地媒体库';

  @override
  String get setupLocalBody => '指定包含音频文件的文件夹路径（FLAC、MP3、AAC…）。您可以稍后在设置中添加更多。';

  @override
  String get setupFolderPath => '文件夹路径';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => '添加此文件夹';

  @override
  String get setupFolderAdded => '文件夹已添加 — 扫描中…';

  @override
  String get setupFolderEmpty => '请输入文件夹路径';

  @override
  String get setupUPnPTitle => 'UPnP/DLNA服务器';

  @override
  String get setupUPnPBody =>
      'Tune Server自动发现本地网络上的UPnP/DLNA服务器。通过搜索 → 浏览来浏览其媒体库。';

  @override
  String get setupFeatureSsdp => '自动SSDP发现';

  @override
  String get setupFeatureContentDir => 'ContentDirectory导航';

  @override
  String get setupFeaturePlayback => '直接DLNA文件播放';

  @override
  String get setupFinish => '完成配置';

  @override
  String get libraryPlayAlbum => '播放专辑';

  @override
  String get libraryPlayNext => '下一首播放';

  @override
  String radioFavExportDone(String path) {
    return 'CSV 已导出：$path';
  }

  @override
  String get radioFavExportError => '导出错误';

  @override
  String get streamingViewAlbum => '查看专辑';

  @override
  String get streamingLogoutContent => '您的账户将断开连接。';

  @override
  String get streamingUrlCopied => 'URL 已复制到剪贴板';

  @override
  String get streamingDeviceCodeHint => '前往此网址并输入上方代码：';

  @override
  String get searchHintFull => '搜索艺术家、专辑、曲目…';

  @override
  String get browseNavError => '导航错误';

  @override
  String get streamingCodeEntered => '我已输入代码';

  @override
  String get appleMusicAuthorize => '允许访问';

  @override
  String get smbNavTitle => 'SMB来源';

  @override
  String get smbTitle => 'SMB连接';

  @override
  String get smbHostHint => '输入SMB服务器地址';

  @override
  String get smbHostLabel => 'IP地址（例：192.168.1.23）';

  @override
  String get smbUser => '用户名';

  @override
  String get smbPassword => '密码';

  @override
  String get smbConnect => '连接';

  @override
  String get smbSelectShare => '选择共享';

  @override
  String get smbBack => '返回';

  @override
  String get smbManualHint => '无法自动列出共享。\n请手动输入共享名称：';

  @override
  String get smbShareName => '共享名称（例：Share, Music）';

  @override
  String get smbScan => '扫描';

  @override
  String get smbScanning => '扫描中…';

  @override
  String smbScanCount(int count) {
    return '找到$count个音频文件';
  }

  @override
  String get smbDoneTitle => '索引完成';

  @override
  String smbDoneBody(int count, String share) {
    return '从$share导入了$count首曲目';
  }

  @override
  String get smbAddAnother => '添加其他共享';

  @override
  String get settingsSmb => 'SMB / Samba来源';

  @override
  String get settingsSmbDesc => '从网络共享索引音乐库';

  @override
  String get podcastsTitle => '播客';

  @override
  String get podcastsTabRadioFrance => '法国广播电台';

  @override
  String get podcastsTabSearch => '搜索';

  @override
  String get podcastsEmpty => '无播客';

  @override
  String get podcastsSearchHint => '搜索播客…';

  @override
  String get podcastsNoEpisodes => '无剧集';

  @override
  String get navPodcasts => '播客';

  @override
  String get streamingConnectedSuccess => '已连接！';

  @override
  String browseItemCount(int count) {
    return '$count 项目';
  }

  @override
  String get settingsSources => '来源与设备';

  @override
  String get settingsSourcesDesc => 'UPnP服务器、DLNA渲染器';

  @override
  String get sourcesTitle => '来源与设备';

  @override
  String get sourcesServersSection => 'UPnP内容服务器';

  @override
  String get sourcesRenderersSection => 'DLNA渲染器';

  @override
  String get sourcesNoDevices => '未发现设备';

  @override
  String get sourcesTypeServer => '服务器';

  @override
  String get sourcesTypeRenderer => '渲染器';

  @override
  String get sourcesAvailable => '可用';

  @override
  String get sourcesUnavailable => '离线';

  @override
  String get sourcesIndexBtn => '索引媒体库';

  @override
  String get sourcesRescanBtn => '重新扫描';

  @override
  String get sourcesForget => '忘记';

  @override
  String get sourcesAddManually => '手动添加';

  @override
  String get sourcesAddTitle => '手动扫描';

  @override
  String get sourcesIpLabel => 'IP地址';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => '端口';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => '扫描中…';

  @override
  String get sourcesNotFound => '在此地址未找到UPnP设备';

  @override
  String get zonesMultiRoom => '多房间';

  @override
  String get zonesCreateGroup => '创建分组';

  @override
  String get zonesGroupLeader => '主控';

  @override
  String get zonesGroupFollower => '跟随';

  @override
  String get zonesGroupDissolve => '解散分组';

  @override
  String get zonesGroupSyncDelay => '同步延迟';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms 毫秒';
  }

  @override
  String get zonesGroupSelectZones => '选择区域';

  @override
  String get zonesGroupSelectLeader => '选择主控';

  @override
  String get zonesGroupNoZones => '无活动分组';

  @override
  String get zonesGroupNeedTwo => '请至少选择2个区域';

  @override
  String get zonesGroupCreated => '分组已创建';

  @override
  String get zonesGroupDissolved => '分组已解散';

  @override
  String get metadataSectionEnrich => '丰富';

  @override
  String get metadataSectionDuplicates => '重复';

  @override
  String get metadataSectionCorrect => '修正';

  @override
  String get metadataFilterAll => '全部';

  @override
  String get metadataFilterMissingCover => '缺少封面';

  @override
  String get metadataFilterMissingGenre => '缺少流派';

  @override
  String get metadataFilterMissingYear => '缺少年份';

  @override
  String get metadataFilterMissingArtist => '缺少艺术家';

  @override
  String get metadataFilterDoubtful => '可疑';

  @override
  String get metadataSearchHint => '搜索专辑…';

  @override
  String get metadataArtistFilter => '艺术家';

  @override
  String get metadataGenreFilter => '流派';

  @override
  String get metadataAllArtists => '所有艺术家';

  @override
  String get metadataAllGenres => '所有流派';

  @override
  String get metadataNoAlbums => '没有匹配的专辑';

  @override
  String get metadataEditAlbum => '编辑专辑';

  @override
  String get metadataSaveChanges => '保存';

  @override
  String get metadataWriteTags => '写入标签';

  @override
  String metadataWriteTagsSuccess(int count) {
    return '标签已写入：$count个文件';
  }

  @override
  String get metadataMergeGroup => '合并';

  @override
  String metadataMergeConfirm(int count) {
    return '合并这$count个专辑？曲目最多的专辑将被保留。';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return '已合并：移动了$moved首曲目，共$total首';
  }

  @override
  String get metadataUploadCover => '上传封面';

  @override
  String get metadataCoverUploaded => '封面已上传';

  @override
  String get metadataAlbumSaved => '专辑已保存';

  @override
  String metadataDupAlbums(int count) {
    return '$count个重复专辑';
  }

  @override
  String get metadataDoubtfulReasons => '问题';

  @override
  String get metadataArtistField => '艺术家';

  @override
  String get metadataAlbumField => '专辑';

  @override
  String get metadataGenreField => '流派';

  @override
  String get metadataYearField => '年份';

  @override
  String metadataTracksCount(int count) {
    return '$count首曲目';
  }
}
