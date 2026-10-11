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
  String zoneLimitReached(int limit) {
    return '免费版限制为 $limit 个区域 — 升级到高级版可无限使用';
  }

  @override
  String zoneLimitOverCap(int current, int limit) {
    return '您现有的 $current 个区域仍可正常使用，但免费版上限为 $limit 个 — 请删除一个区域或升级到高级版以添加新区域';
  }

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
  String albumTracksDuration(int count, String duration) {
    return '$count 首 · $duration';
  }

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
  String playlistTracksAdded(int count, String name) {
    return '已将$count首曲目添加到「$name」';
  }

  @override
  String get playlistAddAllTracks => '全部添加到播放列表';

  @override
  String get playlistDeleteTitle => '删除播放列表？';

  @override
  String get playlistDeleteBody => '此播放列表将被永久删除。';

  @override
  String get searchHint => '搜索…';

  @override
  String get searchNoResults => '没有结果';

  @override
  String get searchTopResult => '最佳结果';

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
  String queueUpNextSummary(int count, String time) {
    return '接下来 $count 首 · $time';
  }

  @override
  String get queueEmpty => '队列为空';

  @override
  String get queueClearTitle => '清空队列？';

  @override
  String get queueClearBody => '播放队列中的所有曲目将被移除。';

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
  String get zonesAirplayPair => '配对（PIN 码）';

  @override
  String get zonesAirplayPairTitle => 'AirPlay 配对';

  @override
  String get zonesAirplayPairIntro =>
      '部分电视（三星、LG）和 Apple TV 会在屏幕上显示 4 位代码。请先开始配对，然后输入代码。';

  @override
  String get zonesAirplayPairWaiting => '正在等待设备上显示的代码…';

  @override
  String get zonesAirplayPairEnterCode => '请输入设备上显示的代码：';

  @override
  String get zonesAirplayPairStart => '开始配对';

  @override
  String get zonesAirplayPairSubmit => '提交代码';

  @override
  String get zonesAirplayPairRetry => '重试';

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

  @override
  String get stereoPairsTitle => '立体声配对';

  @override
  String get stereoPairCreate => '创建立体声配对';

  @override
  String get stereoPairName => '配对名称';

  @override
  String get stereoPairNameHint => '例如：客厅立体声';

  @override
  String get stereoPairLeft => '左声道 (L)';

  @override
  String get stereoPairRight => '右声道 (R)';

  @override
  String get stereoPairSelectDevice => '选择设备';

  @override
  String get stereoPairNone => '无立体声配对';

  @override
  String get stereoPairCreated => '立体声配对已创建';

  @override
  String get stereoPairDissolved => '立体声配对已解除';

  @override
  String get stereoPairDissolve => '解除';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => '启用';

  @override
  String get streamingDisable => '禁用';

  @override
  String get streamingEnabled => '服务已启用';

  @override
  String get streamingDisabled => '服务已禁用';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 Tune！';

  @override
  String get onboardingWelcomeBody => '您的内置多房间音乐服务器。让我们通过几个步骤来设置您的安装。';

  @override
  String get onboardingWelcomeStart => '开始';

  @override
  String get onboardingConfigTitle => '配置';

  @override
  String get onboardingConfigBody => '指定包含音频文件的文件夹，或连接到远程 Tune 服务器。';

  @override
  String get onboardingConfigModeLocal => '内置服务器';

  @override
  String get onboardingConfigModeRemote => '远程服务器';

  @override
  String get onboardingZoneTitle => '创建区域';

  @override
  String get onboardingZoneBody => '以下设备已在您的网络中发现。点击一个来创建您的第一个音频区域。';

  @override
  String get onboardingZoneEmpty => '尚未发现设备。您可以稍后添加。';

  @override
  String onboardingZoneCreated(String name) {
    return '区域已创建：$name';
  }

  @override
  String get onboardingDoneTitle => '完成！';

  @override
  String get onboardingDoneBody => '您的设置已就绪。享受您的音乐吧！';

  @override
  String get onboardingDoneButton => '进入仪表板';

  @override
  String get artistBio => '传记';

  @override
  String get artistAnecdotes => '轶事';

  @override
  String get artistSimilarArtists => '相似艺术家';

  @override
  String get artistMembers => '成员';

  @override
  String get artistDiscography => '唱片目录';

  @override
  String get artistEnriching => '正在丰富信息…';

  @override
  String get artistGenres => '流派';

  @override
  String get libraryShuffleAll => '随机播放全部';

  @override
  String get librarySortBy => '排序方式';

  @override
  String get librarySortTitle => '标题';

  @override
  String get librarySortArtist => '艺术家';

  @override
  String get librarySortYear => '年份';

  @override
  String get librarySortOriginalYear => '原始年份';

  @override
  String get librarySortAddedDate => '添加日期';

  @override
  String get librarySortAscending => '升序';

  @override
  String get librarySortDescending => '降序';

  @override
  String get addFavorite => '加入收藏';

  @override
  String get addFolder => '添加文件夹';

  @override
  String get addThisFolder => '添加此文件夹';

  @override
  String get addToPlaylist => '添加到播放列表';

  @override
  String get addedToPlaylist => '已添加到播放列表';

  @override
  String get audioOutput => '音频输出';

  @override
  String get audioOutputDesc => '每个服务器区域对应一个输出（本地 ALSA、Diretta 渲染器…）。选择要播放的区域。';

  @override
  String get authorizeInBrowser => '在浏览器中授权访问：';

  @override
  String get cancel => '取消';

  @override
  String get connect => '连接';

  @override
  String get connected => '已连接';

  @override
  String get cover => '封面';

  @override
  String get create => '创建';

  @override
  String get createPlaylist => '创建播放列表';

  @override
  String get delete => '删除';

  @override
  String get deletePlaylist => '删除播放列表';

  @override
  String get deletePlaylistConfirm => '删除此播放列表？';

  @override
  String get disabled => '已禁用';

  @override
  String get disconnected => '未连接';

  @override
  String get done => '我已完成';

  @override
  String get dynamicPlaylists => '动态播放列表';

  @override
  String get dynamicTag => '动态';

  @override
  String errorWith(String msg) {
    return '错误：$msg';
  }

  @override
  String favError(String msg) {
    return '收藏失败：$msg';
  }

  @override
  String get favoritesTitle => '收藏';

  @override
  String get filterAll => '全部';

  @override
  String get freqLimit => '频率上限';

  @override
  String get gapless => '无缝播放';

  @override
  String get gaplessDesc => '如果在此渲染器上曲目之间出现白噪声/卡顿，请关闭。';

  @override
  String get host => '主机';

  @override
  String get language => '语言';

  @override
  String get loading => '加载中…';

  @override
  String get localLibrary => '本地音乐库';

  @override
  String get localLibraryDesc => '服务器扫描音乐的文件夹';

  @override
  String get logIn => '登录';

  @override
  String get logOut => '登出';

  @override
  String loginTo(String service) {
    return '登录 $service';
  }

  @override
  String get maxBitDepth => '最高位深';

  @override
  String get maxFrequency => '最高频率';

  @override
  String maxTracks(int n) {
    return '最多 $n';
  }

  @override
  String get metadataFields => '元数据字段';

  @override
  String get metadataFieldsDesc => '为本地音乐库显示的信息';

  @override
  String get metadataSaved => '元数据已保存';

  @override
  String get musicFolders => '已扫描的文件夹';

  @override
  String get navFavorites => '收藏';

  @override
  String get navPlaylists => '播放列表';

  @override
  String get newPlaylist => '新建播放列表';

  @override
  String get noFavAlbums => '没有收藏的专辑';

  @override
  String get noFavArtists => '没有收藏的艺人';

  @override
  String get noFavTracks => '没有收藏的曲目';

  @override
  String get noFolders => '未配置文件夹';

  @override
  String get noLimit => '无限制';

  @override
  String get noPlaylists => '没有播放列表';

  @override
  String get noResults => '无结果';

  @override
  String get noService => '无服务';

  @override
  String get noTracks => '没有曲目';

  @override
  String get noZones => '没有可用区域';

  @override
  String get notConnected => '请在设置中配置服务器';

  @override
  String get nothingPlaying => '没有在播放';

  @override
  String get openAuthPage => '打开授权页面';

  @override
  String get password => '密码';

  @override
  String get pickFolder => '选择文件夹';

  @override
  String get playAll => '全部播放';

  @override
  String get playlistCreated => '播放列表已创建';

  @override
  String get playlistDeleted => '播放列表已删除';

  @override
  String get playlistsTitle => '播放列表';

  @override
  String get port => '端口';

  @override
  String get qualityCd => 'CD（44.1 kHz / 16 位）';

  @override
  String get qualityHires => 'Hi-Res（最高 192 kHz）';

  @override
  String get qualityMax => '最高';

  @override
  String get removeFavorite => '取消收藏';

  @override
  String get removeFromPlaylist => '从播放列表移除';

  @override
  String get runScan => '扫描音乐库';

  @override
  String get scanning => '扫描中…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · 你的音乐库';

  @override
  String get searchEmptyTitle => '搜索标题、专辑或艺人';

  @override
  String get searchTitle => '搜索';

  @override
  String get sectionAlbums => '专辑';

  @override
  String get sectionArtists => '艺人';

  @override
  String get sectionPlaylists => '播放列表';

  @override
  String get sectionTracks => '曲目';

  @override
  String get server => '服务器';

  @override
  String get sourceLibrary => '音乐库';

  @override
  String get streamingQuality => '流媒体质量';

  @override
  String get streamingQualityDesc => '限制向服务（Qobuz、Tidal…）请求的频率/分辨率。';

  @override
  String get streamingServices => '流媒体服务';

  @override
  String get systemLanguage => '系统';

  @override
  String get trackRemoved => '已从播放列表移除';

  @override
  String tracksCount(int n) {
    return '$n 首';
  }

  @override
  String get username => '用户名';

  @override
  String get visualizer => '可视化';

  @override
  String get licenseSessionConflictTitle => '许可证已在其他服务器上使用';

  @override
  String get licenseSessionConflictBody =>
      '您的 Tune 许可证已在您的另一台服务器上使用。另一台停止后几分钟，此服务器将自动恢复为 Premium。';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return '您的 Tune 许可证正在“$server”上使用。另一台停止后几分钟，此服务器将自动恢复为 Premium。';
  }

  @override
  String cfgSaveError(String detail) {
    return '保存失败：$detail';
  }

  @override
  String get cfgReload => '重新加载';

  @override
  String get cfgFieldsLoadError => '无法加载字段';

  @override
  String get cfgFieldsNone => '没有可用字段';

  @override
  String get cfgFieldsHint => '选择在曲目编辑视图中显示的元数据字段。';

  @override
  String get cfgMetaCompleteness => '元数据完整度';

  @override
  String get cfgMetaEnrichMusicBrainz => '通过 MusicBrainz 补全';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'MusicBrainz 补全';

  @override
  String get cfgMetaFixYearsTidal => '修正年份（TIDAL）';

  @override
  String get cfgMetaFixYearsDiscogs => '修正年份（Discogs）';

  @override
  String get cfgMetaFixGenres => '修正流派';

  @override
  String get cfgMetaAutoFixAlbums => '自动修正专辑';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条待处理建议',
      zero: '没有待处理的建议',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => '全部接受';

  @override
  String get cfgMetaSuggestions => '建议';

  @override
  String get cfgMetaScanDuplicates => '扫描重复项';

  @override
  String get cfgMetaAutoMerge => '自动合并';

  @override
  String get cfgMetaMergeDuplicatesTask => '合并重复项';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$count 张重复专辑（$groups 组）',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… 另有 $count 组',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => '上次结果';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '已完成 $pct%';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label：错误 — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label：已接受 $count 条';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label：已修正 $fixed/$total';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label：已修正 $fixed 项';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label：已处理 $total 项';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label：完成';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return '写入标签失败：$detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return '上传失败：$detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '合并 $count 张专辑？',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody => '将保留曲目最多的专辑，其余专辑将被删除。';

  @override
  String cfgMetaMergeError(String detail) {
    return '合并失败：$detail';
  }

  @override
  String get cfgMetaStatsUnavailable => '统计信息不可用';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 张专辑',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… 另有 $count 张专辑（请使用筛选缩小范围）',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count 首曲目';
  }

  @override
  String get cfgMetaReasonArtistUppercase => '艺人全大写';

  @override
  String get cfgMetaReasonArtistPlaceholder => '占位艺人';

  @override
  String get cfgMetaReasonArtistHasYear => '艺人 = 文件夹';

  @override
  String get cfgMetaReasonGenrePlaceholder => '占位流派';

  @override
  String get cfgMetaReasonYearSuspicious => '年份可疑';

  @override
  String get cfgMetaReasonTitleUppercase => '标题全大写';

  @override
  String get cfgMetaReasonArtistMismatch => '艺人不一致';

  @override
  String get cfgSmbNotConnected => '未连接到远程服务器';

  @override
  String cfgSmbMountTitle(String name) {
    return '挂载 $name';
  }

  @override
  String get cfgSmbMount => '挂载';

  @override
  String cfgSmbMountSuccess(String name) {
    return '已挂载 $name';
  }

  @override
  String get cfgSmbTitle => '网络共享（SMB）';

  @override
  String get cfgSmbSearching => '正在搜索 SMB 共享…';

  @override
  String get cfgSmbNone => '未发现 SMB 共享';

  @override
  String get cfgSmbSaveCredentials => '保存凭据';

  @override
  String get cfgUnknown => '未知';

  @override
  String get cfgEqTitle => '均衡器';

  @override
  String get cfgEqTabAssistant => '助手';

  @override
  String get cfgEqTabExpert => '专家';

  @override
  String cfgEqError(String detail) {
    return '均衡器错误：$detail';
  }

  @override
  String get cfgEqPresetFlat => '平直';

  @override
  String get cfgEqPresetBassBoost => '低音增强';

  @override
  String get cfgEqPresetClassical => '古典';

  @override
  String get cfgEqPresetVocal => '人声';

  @override
  String get cfgNotConnectedToServer => '未连接到服务器';

  @override
  String get cfgCredentialsRequired => '需要用户名和密码';

  @override
  String cfgServiceConnected(String service) {
    return '已连接 $service。';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '已断开 $service。';
  }

  @override
  String get cfgLastfmTitle => 'Last.fm 播放记录';

  @override
  String get cfgLastfmDesc => '将收听记录同步到 Last.fm。在任意区域播放的曲目都会自动记录。';

  @override
  String get cfgDisconnecting => '正在断开…';

  @override
  String get cfgConnectHeader => '连接';

  @override
  String get cfgConnecting => '正在连接…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次记录',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return '最近：$date';
  }

  @override
  String get cfgTokenRequired => '请输入用户令牌';

  @override
  String get cfgScrobblerUnavailable => '记录服务不可用';

  @override
  String cfgConnectedAs(String name) {
    return '已以 $name 身份连接';
  }

  @override
  String get cfgListenbrainzDesc =>
      '将收听记录同步到 ListenBrainz。用户令牌可在 listenbrainz.org/settings 获取。';

  @override
  String get cfgUserToken => '用户令牌';

  @override
  String get cfgValidating => '正在验证…';

  @override
  String get cfgSaveAndConnect => '保存并连接';

  @override
  String get cfgScrobbleAuto => '曲目将自动记录';

  @override
  String cfgConfigExported(String path) {
    return '配置已导出：$path';
  }

  @override
  String get cfgConfigImported => '配置导入成功';

  @override
  String cfgImportError(String detail) {
    return '导入失败：$detail';
  }

  @override
  String get cfgConfigExportDesc => '将服务器配置保存为 JSON 文件。';

  @override
  String get cfgConfigExportJson => '导出 JSON';

  @override
  String get cfgConfigImportDesc => '从 JSON 文件恢复配置。';

  @override
  String get cfgChooseFile => '选择文件';

  @override
  String get cfgDbNoServer => '未连接服务器。';

  @override
  String cfgDbExportOk(String size, String path) {
    return '导出成功：$size MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => '无法访问文件路径。';

  @override
  String get cfgDbImportConfirmTitle => '确认导入';

  @override
  String cfgDbImportConfirmBody(String name) {
    return '用“$name”替换服务器数据库？\n\n系统将自动创建安全备份。导入后需要重启服务器。';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return '导入成功：$size MB（$engine）。\n请重启服务器以应用更改。';
  }

  @override
  String get cfgDbTitle => '数据库';

  @override
  String get cfgDbIntro => '导出或导入已连接服务器的数据库。\nSQLite：.db 文件。PostgreSQL：SQL 转储。';

  @override
  String get cfgDbExporting => '正在导出…';

  @override
  String get cfgDbExportBtn => '导出数据库';

  @override
  String get cfgDbImporting => '正在导入…';

  @override
  String get cfgDbImportBtn => '导入文件';

  @override
  String get cfgDbFooter => '导入后请重启服务器以应用更改。替换前会自动创建安全备份。';

  @override
  String cfgStatusUnavailable(String detail) {
    return '状态不可用：$detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune 会在本地网络中显示为 Spotify Connect 接收器。在 Spotify 应用的设备列表中选择“Tune (…)”。客户端需要 Spotify Premium 账户。';

  @override
  String get cfgSpotifyNoLibrespot => '服务器上未检测到 librespot';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      '请从官方 tarball/zip 重新安装 Tune Server 以包含该二进制文件，或单独安装（apt install librespot / brew install librespot）。';

  @override
  String get cfgTargetZone => '目标区域';

  @override
  String get cfgDeviceName => '设备名称';

  @override
  String get cfgPlaying => '正在播放';

  @override
  String get cfgNetDiagTitle => '网络诊断';

  @override
  String get cfgNetSsdpActive => 'SSDP 已启用';

  @override
  String get cfgNetMulticastReachable => '组播可达';

  @override
  String get cfgError => '错误';

  @override
  String get cfgNetResolution => '解析';

  @override
  String get cfgNetLatency => '延迟';

  @override
  String get cfgNetPublicIp => '公网 IP';

  @override
  String get cfgNetInterfaces => '网络接口';

  @override
  String get cfgStatusWarning => '警告';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total 张专辑';
  }

  @override
  String get libNoCollectionsYet => '暂无合集';

  @override
  String libRatingError(String error) {
    return '评分出错：$error';
  }

  @override
  String libDisc(int disc) {
    return '光盘 $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return '光盘 $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => '快速收藏';

  @override
  String get libAddToCollection => '添加到合集';

  @override
  String get libAlbumNotes => '专辑介绍';

  @override
  String get libCredits => '演职人员';

  @override
  String get libNoCredits => '无演职人员信息';

  @override
  String get libNoAlbumNotes => '暂无专辑介绍';

  @override
  String get libNoNotes => '暂无介绍';

  @override
  String get libSourceCommunity => 'Tune 社区';

  @override
  String libBioSource(String source) {
    return '来源：$source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return '来源：$source · $license';
  }

  @override
  String get libAppleMusicAccessDenied => 'Apple Music 资料库访问被拒绝。';

  @override
  String get libAppleMusicPermissionRefused =>
      '权限被拒绝。请在“设置 > 隐私 > 媒体与 Apple Music”中开启访问。';

  @override
  String get libUnknownError => '未知错误';

  @override
  String get libAppleMusicAccessTitle => '访问 Apple Music';

  @override
  String get libAppleMusicAccessBody => '允许访问您的音乐资料库，以播放 Apple Music 曲目。';

  @override
  String get libAppleMusicEmpty => 'Apple Music 资料库为空';

  @override
  String get libReportImageTitle => '报告图片';

  @override
  String get libReportImageBody => '将此艺人图片报告为错误？服务器会在下次补充信息时替换它。';

  @override
  String get libReportAction => '报告';

  @override
  String get libImageReported => '已报告图片';

  @override
  String libServiceAlbums(String service) {
    return '$service 专辑';
  }

  @override
  String libTrackCount(int count) {
    return '$count 首曲目';
  }

  @override
  String get libDuplicateScanner => '重复项扫描';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    return '找到 $groups 组重复项（共 $tracks 首曲目）';
  }

  @override
  String get libFindDuplicatesTitle => '查找重复曲目';

  @override
  String get libFindDuplicatesBody => '扫描音频内容哈希，查找媒体库中相同的曲目。';

  @override
  String get libStartScan => '开始扫描';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total 首曲目（$percent%）';
  }

  @override
  String get libLoadingTracks => '正在加载曲目…';

  @override
  String get libNoDuplicatesFound => '未发现重复项';

  @override
  String get libLibraryClean => '您的媒体库很干净。';

  @override
  String get libScanAgain => '重新扫描';

  @override
  String get libScanFailed => '扫描失败';

  @override
  String get libTrackNumberField => '曲目编号';

  @override
  String get libDiscNumberField => '光盘编号';

  @override
  String get libExtendedMetadata => '扩展元数据';

  @override
  String get libGenreTreeSaved => '流派树已保存';

  @override
  String libSaveError(String error) {
    return '保存出错：$error';
  }

  @override
  String get libGenreTree => '流派树';

  @override
  String get libAddRootGenre => '添加顶级流派';

  @override
  String get libGenreTreeRequiresRemote => '流派树需要连接到远程服务器。';

  @override
  String get libNoGenreHierarchy => '尚未定义流派层级';

  @override
  String libAddSubGenreTo(String parent) {
    return '向“$parent”添加子流派';
  }

  @override
  String get libGenreName => '流派名称';

  @override
  String libSubGenreCount(int count) {
    return '$count 个子流派';
  }

  @override
  String get libAddSubGenre => '添加子流派';

  @override
  String get libRemove => '移除';

  @override
  String libRemoveNamedConfirm(String name) {
    return '移除“$name”？';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    return '这也会移除其全部 $count 个子流派。';
  }

  @override
  String get libRemoveGenreBody => '此流派将从树中移除。';

  @override
  String libAlbumCount(int count) {
    return '$count 张专辑';
  }

  @override
  String get libNoTracksForFilter => '没有符合此筛选条件的曲目';

  @override
  String get libQualityLossless => '无损';

  @override
  String get libQualityLossy => '有损';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total 首曲目';
  }

  @override
  String get libNewCollection => '新建合集';

  @override
  String get libCollectionName => '合集名称';

  @override
  String libCreateError(String error) {
    return '创建出错：$error';
  }

  @override
  String libDeleteError(String error) {
    return '删除出错：$error';
  }

  @override
  String get libCollectionsTitle => '合集';

  @override
  String get libCollectionsLoadFailed => '无法加载合集';

  @override
  String get libDeleteCollectionTitle => '删除合集？';

  @override
  String libDeleteCollectionBody(String name) {
    return '“$name”将被永久删除。';
  }

  @override
  String get libNoAlbumsInCollection => '此合集中没有专辑';

  @override
  String get libDeleteConfirmTitle => '删除？';

  @override
  String get libDeleteSmartCollectionBody => '此智能合集将被永久删除。';

  @override
  String get libNoRules => '无规则';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return '演职人员：$role=$artist';
  }

  @override
  String get libAnd => '且';

  @override
  String get libOr => '或';

  @override
  String get libSmartCollections => '智能合集';

  @override
  String get libNewSmartCollection => '新建智能合集';

  @override
  String get libNoSmartCollections => '没有智能合集';

  @override
  String get libSmartCollectionsSeedHint => '服务器通常会在首次启动时创建 7 个默认合集。';

  @override
  String get libCreateFirstSmartCollection => '创建我的第一个智能合集';

  @override
  String get libNoMatchingAlbums => '没有匹配的专辑';

  @override
  String get libSmartCreditsHint =>
      '若要使用基于演职人员的规则（engineer、performer…），请先在设置中补充媒体库信息。';

  @override
  String get libFieldSampleRate => '采样率';

  @override
  String get libFieldBitDepth => '位深';

  @override
  String get libFieldTrackCount => '曲目数';

  @override
  String get libFieldFormat => '格式';

  @override
  String get libFieldLabel => '唱片公司';

  @override
  String get libFieldAlbumTitle => '专辑标题';

  @override
  String get libFieldSource => '来源';

  @override
  String get libFieldCredit => '演职人员';

  @override
  String get libFieldPlayCount => '播放次数';

  @override
  String get libFieldLastPlayed => '上次播放';

  @override
  String get libOpBetween => '介于';

  @override
  String get libOpContains => '包含';

  @override
  String get libOpStartsWith => '开头为';

  @override
  String get libOpEmpty => '为空';

  @override
  String get libOpNotEmpty => '不为空';

  @override
  String get libOpNever => '从未';

  @override
  String get libOpAfter => '晚于';

  @override
  String get libOpBefore => '早于';

  @override
  String get libNameLabel => '名称';

  @override
  String get libMatchMode => '匹配方式';

  @override
  String get libMatchAll => '全部规则（且）';

  @override
  String get libMatchAny => '至少一条（或）';

  @override
  String get libAddRule => '添加规则';

  @override
  String get libMatchingAlbumsPending => '… 张匹配的专辑';

  @override
  String libMatchingAlbums(int count) {
    return '$count 张匹配的专辑';
  }

  @override
  String get libTimestampHint => 'now-30d 或 2024-01-01';

  @override
  String get libValueHint => '值';

  @override
  String get libMinHint => '最小';

  @override
  String get libMaxHint => '最大';

  @override
  String get libCommaSeparatedHint => '以逗号分隔的值';

  @override
  String get libCreditRoleHint => '角色（engineer、performer…）';

  @override
  String get libCreditArtistHint => '艺人（Rudy Van Gelder…）';

  @override
  String get libCreditInstrumentHint => '乐器（Piano…）— 可选';

  @override
  String get libDirectories => '目录';

  @override
  String get libLoadError => '加载出错';

  @override
  String get libNoFolders => '没有文件夹';

  @override
  String get libAddFoldersInSettings => '请在设置中添加音乐文件夹';

  @override
  String get libFoldersHeader => '文件夹';

  @override
  String libTracksHeaderCount(int count) {
    return '曲目（$count）';
  }

  @override
  String get libPlayFromHere => '从这里播放';

  @override
  String get libTags => '标签';

  @override
  String get libNewTagHint => '新标签…';

  @override
  String get libJustNow => '刚刚';

  @override
  String libMinutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String libHoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String get libYesterday => '昨天';

  @override
  String libDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String get libNowListening => '正在收听';

  @override
  String get libContinueListening => '继续收听';

  @override
  String get libRecentlyAdded => '最近添加';

  @override
  String get libTopTracks => '热门曲目';

  @override
  String get libTopArtists => '热门艺人';

  @override
  String get libRecommendations => '推荐';

  @override
  String get libSourceLocal => '本地';

  @override
  String get libFieldDuration => '时长';

  @override
  String get libFilter => '筛选';

  @override
  String get libRefreshAll => '全部刷新';

  @override
  String get libPodcastsSubscribed => '已订阅';

  @override
  String get libNoSubscriptions => '暂无订阅';

  @override
  String get libSubscribeRssFeed => '订阅 RSS 源';

  @override
  String get libUnknown => '未知';

  @override
  String get libUnsubscribeTitle => '取消订阅？';

  @override
  String libUnsubscribeBody(String name) {
    return '取消订阅“$name”？';
  }

  @override
  String get libUnsubscribe => '取消订阅';

  @override
  String libEpisodeCount(int count) {
    return '$count 集';
  }

  @override
  String get libSubscribeToPodcast => '订阅播客';

  @override
  String get libRssFeedUrl => 'RSS 源网址';

  @override
  String get libSubscribe => '订阅';

  @override
  String get libSubscribed => '已订阅。';

  @override
  String libSubscribeError(String error) {
    return '订阅出错：$error';
  }

  @override
  String libUnsubscribeError(String error) {
    return '取消订阅出错：$error';
  }

  @override
  String get libPodcastRefreshed => '播客已刷新。';

  @override
  String libRefreshError(String error) {
    return '刷新出错：$error';
  }

  @override
  String get libAllPodcastsRefreshed => '所有播客已刷新。';

  @override
  String get libToday => '今天';

  @override
  String get miscNavFolders => '文件夹';

  @override
  String get miscNavCollections => '收藏集';

  @override
  String get miscNavSmartCollections => '智能收藏集';

  @override
  String get miscNavDjMode => 'DJ 模式';

  @override
  String get miscNavPartyMode => '派对模式';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => '派对';

  @override
  String get miscNavSmartPlaylists => '智能播放列表';

  @override
  String get miscNavAlarms => '闹钟';

  @override
  String get miscNavGenreTree => '流派树';

  @override
  String get miscNavDashboard => '仪表板';

  @override
  String get miscNavDiagnostics => '诊断';

  @override
  String get miscNavAdmin => '管理';

  @override
  String get miscNavMore => '更多';

  @override
  String get miscNextTrack => '下一首';

  @override
  String get miscPreviousTrack => '上一首';

  @override
  String get miscUnknownError => '未知错误';

  @override
  String get miscAuthorizationCode => '授权码';

  @override
  String get miscWaitingForValidation => '正在等待验证…';

  @override
  String miscCodeValue(String code) {
    return '代码：$code';
  }

  @override
  String get miscQualityHigh => '高';

  @override
  String get miscExplore => '探索';

  @override
  String get miscFavoriteAlbums => '收藏的专辑';

  @override
  String get miscFavoriteTracks => '收藏的曲目';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '查看全部 $count 首曲目',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => '我的播放列表';

  @override
  String get miscNoApiClient => '无 API 客户端';

  @override
  String miscServiceFavorites(String service) {
    return '$service 收藏';
  }

  @override
  String miscPlayAllCount(int count) {
    return '全部播放 ($count)';
  }

  @override
  String get miscServiceNotFound => '未找到服务';

  @override
  String get miscYtHome => '首页';

  @override
  String get miscYtCharts => '排行榜';

  @override
  String get miscYtMoods => '心情';

  @override
  String get miscNoData => '无数据';

  @override
  String get miscNoContentAvailable => '暂无内容';

  @override
  String get miscNoChartsAvailable => '暂无排行榜';

  @override
  String get miscNoMoodsAvailable => '暂无心情分类';

  @override
  String get miscDashTotalPlays => '总播放次数';

  @override
  String get miscDashListeningTime => '收听时长';

  @override
  String get miscDashUniqueTracks => '不同曲目';

  @override
  String get miscDashUniqueArtists => '不同艺人';

  @override
  String get miscDashTopArtists => '热门艺人';

  @override
  String get miscDashTopAlbums => '热门专辑';

  @override
  String get miscDashTopTracks => '热门曲目';

  @override
  String get miscDashListeningByHour => '按小时收听';

  @override
  String get miscDashListeningByDay => '按天收听';

  @override
  String get miscDashAllTime => '全部时间';

  @override
  String miscDashLastDays(int days) {
    return '$days 天';
  }

  @override
  String get miscUnknown => '未知';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次播放',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => '暂无收听数据';

  @override
  String get miscDashNoDataHint => '播放音乐后即可在此查看统计。';

  @override
  String get miscDashLoadFailed => '无法加载仪表板';

  @override
  String get miscDiagRequiresRemote => '诊断需要连接到远程服务器。';

  @override
  String get miscDiagSystem => '系统';

  @override
  String get miscDiagHealth => '健康状况';

  @override
  String get miscVersion => '版本';

  @override
  String get miscDiagUptime => '运行时间';

  @override
  String get miscDiagMemory => '内存';

  @override
  String get miscDiagDatabase => '数据库';

  @override
  String miscZoneNumbered(String id) {
    return '区域 $id';
  }

  @override
  String get miscDiagLogs => '日志';

  @override
  String get miscDiagNoLogs => '暂无日志';

  @override
  String get miscAdminTitle => '管理仪表板';

  @override
  String get miscAdminNotConnected => '未连接到远程服务器';

  @override
  String get miscAdminSystemHealth => '系统健康状况';

  @override
  String get miscAdminStatus => '状态';

  @override
  String get miscAdminDisk => '磁盘';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return '已发现的设备 ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return '最近的错误 ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => '最近没有错误';

  @override
  String get miscTroubleshootingTitle => '故障排除';

  @override
  String get miscFaqHeader => '常见问题';

  @override
  String get miscFaq1Title => '找不到我的服务器';

  @override
  String get miscFaq1Step1 => '请确认 Tune 服务器已启动且可以访问。';

  @override
  String get miscFaq1Step2 => '请确保设备与服务器连接在同一 Wi-Fi 网络。';

  @override
  String get miscFaq1Step3 =>
      '如果使用 VPN，请将其关闭或启用局域网发现（例如 nordvpn set lan-discovery on）。';

  @override
  String get miscFaq1Step4 => '尝试在 设置 > 模式 > 扫描网络 中扫描网络。';

  @override
  String get miscFaq1Step5 => '请确认服务器端口（默认 8888）未被防火墙阻止。';

  @override
  String get miscFaq1Step6 => '重启服务器和应用。';

  @override
  String get miscFaq2Title => '无法播放音乐';

  @override
  String get miscFaq2Step1 => '请确认已选择播放区域（屏幕底部的栏）。';

  @override
  String get miscFaq2Step2 => '如果没有区域，请在 设置 > 音频 > 区域 > 创建 中新建一个。';

  @override
  String get miscFaq2Step3 => '请确认输出设备（音箱、DAC）已开启且位于同一网络。';

  @override
  String get miscFaq2Step4 => '对于 DLNA 设备，发现后请等待几秒再开始播放。';

  @override
  String get miscFaq2Step5 => '请尝试其他文件——当前文件的格式可能不受支持。';

  @override
  String get miscFaq2Step6 => '如果问题仍然存在，请重启应用。';

  @override
  String get miscFaq3Title => '封面不显示';

  @override
  String get miscFaq3Step1 => '在 设置 > 媒体库 > 来源 中扫描媒体库。';

  @override
  String get miscFaq3Step2 => '请确认文件包含内嵌封面（ID3/Vorbis 标签）。';

  @override
  String get miscFaq3Step3 => '在专辑文件夹中放入 cover.jpg 或 folder.jpg 文件。';

  @override
  String get miscFaq3Step4 => '在 设置 > 媒体库 > 元数据 中启用自动获取封面。';

  @override
  String get miscFaq3Step5 => '重启应用以清除图片缓存。';

  @override
  String get miscFaq4Title => '扫描卡住了';

  @override
  String get miscFaq4Step1 => '首次扫描可能需要几分钟，具体取决于媒体库大小。';

  @override
  String get miscFaq4Step2 => '请确认音乐文件夹可以访问（权限、SMB 挂载）。';

  @override
  String get miscFaq4Step3 => '关闭并重新打开应用以中断卡住的扫描。';

  @override
  String get miscFaq4Step4 => '查看服务器日志以找出有问题的文件。';

  @override
  String get miscFaq4Step5 => '尝试减少来源文件夹的数量以定位问题。';

  @override
  String get miscFaq5Title => '如何连接 DLNA/AirPlay 设备';

  @override
  String get miscFaq5Step1 => 'DLNA：设备需开启并位于同一网络，它会自动出现在输出列表中。';

  @override
  String get miscFaq5Step2 => '如果设备未出现，请确认路由器上的组播功能正常。';

  @override
  String get miscFaq5Step3 => '部分路由器会阻止 Wi-Fi 客户端之间的 SSDP 流量——请启用组播转发。';

  @override
  String get miscFaq5Step4 => 'BluOS：Bluesound 音箱会被自动检测。';

  @override
  String get miscFaq5Step5 => 'Chromecast：Google Cast 设备会出现在可用输出中。';

  @override
  String get miscFaq5Step6 => '检测到后，创建一个区域并将该设备指定为其输出。';

  @override
  String get miscFaq6Title => '流媒体问题';

  @override
  String get miscFaq6Step1 => '请在 设置 > 流媒体 中确认服务（TIDAL、Qobuz、Deezer）的凭据正确。';

  @override
  String get miscFaq6Step2 => '如果会话已过期，请断开后重新连接该服务。';

  @override
  String get miscFaq6Step3 => '请检查网络连接。';

  @override
  String get miscFaq6Step4 => '部分曲目可能在您所在的地区不可用。';

  @override
  String get miscFaq6Step5 => '如遇音质问题，请在 设置 > 高级音频 中检查流媒体音质设置。';

  @override
  String get miscFaq6Step6 => '如果问题仍然存在，请在 设置 > 帮助 中发送错误报告。';

  @override
  String get miscBugReportCopied => '报告已复制到剪贴板';

  @override
  String get miscBugReportSent => '错误已发送，谢谢！';

  @override
  String get miscBugReportSendFailed => '发送失败。请将报告复制到论坛。';

  @override
  String get miscBugReportTitle => '错误报告';

  @override
  String get miscRegenerate => '重新生成';

  @override
  String get miscBugReportGenerateFailed => '无法生成报告';

  @override
  String get miscSent => '已发送！';

  @override
  String get miscSending => '正在发送…';

  @override
  String get miscSubmit => '提交';

  @override
  String get miscCopied => '已复制！';

  @override
  String get miscCopyReport => '复制报告';

  @override
  String get miscAiServerNotConnected => '服务器未连接。请检查连接。';

  @override
  String miscAiQueryFailed(int code) {
    return 'AI 请求失败 ($code)';
  }

  @override
  String get miscAiNoReply => '无回复';

  @override
  String get miscAiAskHint => '提个问题…';

  @override
  String get miscAiSend => '发送';

  @override
  String get miscAiTitle => 'AI 助手';

  @override
  String get miscAiEmptyTitle => 'Tune AI 助手';

  @override
  String get miscAiEmptyBody => '询问关于你的音乐的问题，\n或请求推荐…';

  @override
  String miscAiAction(String action) {
    return '操作：$action';
  }

  @override
  String get miscCreateAccount => '创建账户';

  @override
  String get miscUsername => '用户名';

  @override
  String get miscUsernameRequired => '请输入用户名';

  @override
  String get miscEmailRequired => '请输入邮箱';

  @override
  String get miscEmailInvalid => '邮箱无效';

  @override
  String get miscPasswordRequired => '请输入密码';

  @override
  String miscPasswordMinLength(int min) {
    return '至少 $min 个字符';
  }

  @override
  String get miscHaveAccountSignIn => '已有账户？登录';

  @override
  String get miscNoAccountSignUp => '没有账户？注册';

  @override
  String get npRepeat => '重复播放';

  @override
  String get npQueue => '播放队列';

  @override
  String get npFavorite => '收藏';

  @override
  String get npRadioFavAdded => '已添加到电台收藏';

  @override
  String get npLyrics => '歌词';

  @override
  String get npAlarm => '闹钟';

  @override
  String get npSleepTimer => '睡眠定时器';

  @override
  String get npDspCrossfeed => 'DSP 交叉馈送';

  @override
  String get npEqualizer => '均衡器';

  @override
  String get npShare => '分享';

  @override
  String get npTransfer => '转移';

  @override
  String get npCopiedToClipboard => '已复制到剪贴板';

  @override
  String get npNoLyricsFound => '未找到歌词';

  @override
  String get npNoLyricsAvailable => '暂无歌词';

  @override
  String get npLyricsOpenFromNowPlaying => '请从“正在播放”打开以查看完整歌词';

  @override
  String get npLyricsLoadFailed => '歌词加载失败';

  @override
  String get npLrcMetadataTooltip => '元数据';

  @override
  String get npLrcMetadataTitle => 'LRC 元数据';

  @override
  String get npLrcTitle => '标题';

  @override
  String get npLrcCreatedBy => '创建者';

  @override
  String get npLrcOffset => '偏移 (ms)';

  @override
  String get npLrcHint => '请将同名的 .lrc 文件放在音频文件旁边。';

  @override
  String get npEqFlat => '平直';

  @override
  String get npEqBassBoost => '低音增强';

  @override
  String get npEqTrebleBoost => '高音增强';

  @override
  String get npEqVocal => '人声';

  @override
  String get npEqRock => '摇滚';

  @override
  String get npEqJazz => '爵士';

  @override
  String get npEqClassical => '古典';

  @override
  String get npEqElectronic => '电子';

  @override
  String get npEqHipHop => '嘻哈';

  @override
  String get npEqAcoustic => '原声';

  @override
  String npEqApplied(String preset) {
    return '均衡器：$preset';
  }

  @override
  String npEqError(String error) {
    return '均衡器错误：$error';
  }

  @override
  String get npCrossfeedDesc => '混合立体声声道，让耳机聆听更自然';

  @override
  String get npCrossfeedOff => '关闭';

  @override
  String get npCrossfeedLight => '轻度';

  @override
  String get npCrossfeedMedium => '中度';

  @override
  String get npCrossfeedStrong => '强';

  @override
  String npCrossfeedApplied(String level) {
    return '交叉馈送：$level';
  }

  @override
  String npDspError(String error) {
    return 'DSP 错误：$error';
  }

  @override
  String get npTransferTitle => '转移播放';

  @override
  String get npNoOtherZones => '没有其他可用区域';

  @override
  String npTransferredTo(String zone) {
    return '已转移到 $zone';
  }

  @override
  String npTransferError(String error) {
    return '转移错误：$error';
  }

  @override
  String get npAlarmClock => '闹钟';

  @override
  String npAlarmSetFor(String time) {
    return '闹钟已设为 $time';
  }

  @override
  String npAlarmError(String error) {
    return '闹钟错误：$error';
  }

  @override
  String get npAlarmCancelled => '闹钟已取消';

  @override
  String get npPause => '暂停';

  @override
  String get npStop => '停止';

  @override
  String get npRoleComposer => '作曲';

  @override
  String get npRoleLyricist => '作词';

  @override
  String get npRoleArranger => '编曲';

  @override
  String get npRoleConductor => '指挥';

  @override
  String get npRolePerformer => '演奏者';

  @override
  String get npRoleProducer => '制作人';

  @override
  String get npRoleMixer => '混音';

  @override
  String get npRoleEngineer => '录音师';

  @override
  String get npCreditsEnriching => '正在补充…';

  @override
  String get npCreditsEnrich => '通过 MusicBrainz 补充';

  @override
  String get npVolume => '音量';

  @override
  String get npChangeZone => '切换区域';

  @override
  String get npZoneFallback => '区域';

  @override
  String get npFollowMe => '跟随我';

  @override
  String get npMovePlaybackTo => '将播放移至…';

  @override
  String get npNowPlaying => '正在播放';

  @override
  String get npTabMore => '更多';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return '睡眠定时器已设置：$minutes 分钟(淡出：$fade 秒)';
  }

  @override
  String npSleepTimerError(String error) {
    return '睡眠定时器错误：$error';
  }

  @override
  String get npSleepTimerCancelled => '睡眠定时器已取消';

  @override
  String get npSleepDuration => '时长';

  @override
  String get npSleepCustom => '自定义';

  @override
  String get npSleepFadeOut => '淡出';

  @override
  String npSleepFadeDesc(int seconds) {
    return '音量将在最后 $seconds 秒内逐渐降为零。';
  }

  @override
  String get npSleepStarting => '正在启动…';

  @override
  String npSleepStart(String duration) {
    return '开始($duration)';
  }

  @override
  String get npSleepSelectDuration => '选择时长';

  @override
  String get npSleepTimerActive => '定时器运行中';

  @override
  String get npSleepCancelTimer => '取消定时器';

  @override
  String get npMoodChill => '放松';

  @override
  String get npMoodParty => '派对';

  @override
  String get npMoodFocus => '专注';

  @override
  String get npMoodEnergetic => '活力';

  @override
  String get npNoZoneAvailable => '没有可用区域';

  @override
  String npMoodNoTracks(String mood) {
    return '未找到适合“$mood”的曲目';
  }

  @override
  String get npMoodInvalidTrackIds => '错误：曲目 ID 无效';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在播放 $count 首曲目',
      one: '正在播放 1 首曲目',
    );
    return '$mood混音：$_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已将 $count 首曲目加入队列',
      one: '已将 1 首曲目加入队列',
    );
    return '$mood混音：$_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Smart AutoPlay 错误：$error';
  }

  @override
  String get npSmartAutoplayDesc => '选择一种氛围来生成智能播放列表';

  @override
  String get npAlarmsNotConnected => '未连接到远程服务器';

  @override
  String get npAlarmSnoozed => '闹钟已推迟 5 分钟';

  @override
  String get npAlarmsTitle => '闹钟';

  @override
  String get npAlarmsEmpty => '没有闹钟';

  @override
  String npZoneNumbered(String id) {
    return '区域 $id';
  }

  @override
  String get npAlarmSkipsHolidays => '节假日除外';

  @override
  String get npAlarmSnooze => '稍后提醒';

  @override
  String get npAlarmDefaultName => '闹钟';

  @override
  String get npAlarmEdit => '编辑闹钟';

  @override
  String get npAlarmNew => '新建闹钟';

  @override
  String get npAlarmTime => '时间';

  @override
  String get npAlarmNameHint => '起床';

  @override
  String get npAlarmDays => '日期';

  @override
  String get npAlarmSkipHolidays => '跳过节假日';

  @override
  String get npAlarmCountry => '国家：';

  @override
  String get npCountryFR => '法国';

  @override
  String get npCountryBE => '比利时';

  @override
  String get npCountryCH => '瑞士';

  @override
  String get npCountryCA => '加拿大';

  @override
  String get npCountryUS => '美国';

  @override
  String get npCountryDE => '德国';

  @override
  String get npCountryGB => '英国';

  @override
  String get npAlarmSource => '来源';

  @override
  String get npAlarmSourceType => '类型';

  @override
  String get npSourceRadio => '电台';

  @override
  String get npSourcePlaylist => '播放列表';

  @override
  String get npSourceAlbum => '专辑';

  @override
  String get npAlarmSourceName => '来源名称';

  @override
  String get npAlarmPlaylistId => '播放列表 ID';

  @override
  String get npAlarmAlbumId => '专辑 ID';

  @override
  String get npAlarmIdentifier => '标识符';

  @override
  String get npAlarmPlaybackZone => '播放区域';

  @override
  String get npAlarmDefaultZone => '默认';

  @override
  String npAlarmVolume(int percent) {
    return '音量：$percent%';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return '淡入：$seconds 秒';
  }

  @override
  String get npAlarmEnabled => '已启用';

  @override
  String get npAlarmDeleteTitle => '删除闹钟？';

  @override
  String get npDayMon => '周一';

  @override
  String get npDayTue => '周二';

  @override
  String get npDayWed => '周三';

  @override
  String get npDayThu => '周四';

  @override
  String get npDayFri => '周五';

  @override
  String get npDaySat => '周六';

  @override
  String get npDaySun => '周日';

  @override
  String get plHubTitle => '播放列表中心';

  @override
  String get plTabSmartAi => '智能 AI';

  @override
  String get plTabTransfers => '转移';

  @override
  String get plSync => '同步';

  @override
  String get plTabBackup => '备份';

  @override
  String get plCompare => '比较';

  @override
  String get plComparing => '正在比较…';

  @override
  String plCompareError(String detail) {
    return '比较失败：$detail';
  }

  @override
  String get plNoPlaylistsAvailable => '没有可用的播放列表';

  @override
  String get plSectionSource => '来源';

  @override
  String get plSectionTarget => '目标';

  @override
  String get plServiceLabel => '服务';

  @override
  String get plPlaylistLabel => '播放列表';

  @override
  String get plLocal => '本地';

  @override
  String get plSourceLabel => '来源';

  @override
  String get plRestoreSnapshotTitle => '恢复快照';

  @override
  String get plLocalPlaylistNameLabel => '本地播放列表名称：';

  @override
  String get plRestore => '恢复';

  @override
  String plRestoreDone(String name, String matched, String notFound) {
    return '“$name”已恢复：找到 $matched 首，$notFound 首未找到。';
  }

  @override
  String plRestoreReplaced(String name, String matched, String notFound) {
    return '“$name”已替换：找到 $matched 首，$notFound 首未找到。';
  }

  @override
  String get plExistingTitle => '播放列表已存在';

  @override
  String plExistingBody(String name) {
    return '已存在名为“$name”的播放列表。要替换吗？';
  }

  @override
  String get plReplace => '替换';

  @override
  String plDeleteSnapshotBody(String name) {
    return '删除“$name”的快照？';
  }

  @override
  String get plSyncIntervalTitle => '自动同步间隔';

  @override
  String get plSyncIntervalLabel => '分钟（0 = 仅手动）：';

  @override
  String get plSyncIntervalHint => '例如 60';

  @override
  String get plNoTransfers => '没有转移记录';

  @override
  String get plNoSyncLinks => '没有同步链接';

  @override
  String get plNoSyncLinksHint => '可在转移时创建链接';

  @override
  String plPlaylistNumber(String id) {
    return '播放列表 #$id';
  }

  @override
  String plAutoEveryMinutes(String minutes) {
    return '自动 $minutes 分钟';
  }

  @override
  String plSyncDone(
    String addedLocal,
    String removedLocal,
    String addedRemote,
    String removedRemote,
  ) {
    return '同步完成：本地 +$addedLocal/-$removedLocal，远程 +$addedRemote/-$removedRemote';
  }

  @override
  String plSyncConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '，$count 个冲突',
    );
    return '$_temp0';
  }

  @override
  String plSyncError(String detail) {
    return '同步失败：$detail';
  }

  @override
  String get plSectionBackup => '备份';

  @override
  String get plBackingUp => '正在备份…';

  @override
  String get plBackupAll => '备份所有播放列表';

  @override
  String plBackupResult(String playlists, String tracks) {
    return '$playlists 个播放列表 · $tracks 首';
  }

  @override
  String get plSectionSnapshots => '快照';

  @override
  String get plNoSnapshots => '没有快照。运行备份即可创建。';

  @override
  String get plSectionBatchTransfer => '批量转移';

  @override
  String get plBatchTransferHint => '转移某个服务的全部播放列表';

  @override
  String get plTransferring => '正在转移…';

  @override
  String get plTransferAll => '全部转移';

  @override
  String plBatchResult(String count, String status) {
    return '$count 个播放列表 — $status';
  }

  @override
  String get plMergeDone => '播放列表已合并。';

  @override
  String plMergeError(String detail) {
    return '合并失败：$detail';
  }

  @override
  String get plNameLabel => '名称';

  @override
  String plDeleteNamed(String name) {
    return '删除“$name”？';
  }

  @override
  String plImportedLocal(String name) {
    return '“$name”已导入本地。';
  }

  @override
  String plImportError(String detail) {
    return '导入失败：$detail';
  }

  @override
  String get plFilterAll => '全部';

  @override
  String get plMerge => '合并';

  @override
  String get plCancelMerge => '取消合并';

  @override
  String get plMerging => '正在合并…';

  @override
  String get plImportToLocal => '导入本地';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选 $count 个',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => '去重';

  @override
  String get plMergedNameHint => '合并后的播放列表名称';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => '结果';

  @override
  String get plCommon => '共同';

  @override
  String get plSourceOnly => '仅来源';

  @override
  String get plTargetOnly => '仅目标';

  @override
  String plMatchRate(String rate) {
    return '匹配率 $rate%';
  }

  @override
  String plOnlyInSource(int count) {
    return '仅在来源中（$count）';
  }

  @override
  String plOnlyInTarget(int count) {
    return '仅在目标中（$count）';
  }

  @override
  String plMoreCount(int count) {
    return '还有 $count 个';
  }

  @override
  String get plTransferPlaylistTitle => '转移播放列表';

  @override
  String get plCreateOnRemote => '在远程服务上创建';

  @override
  String get plTransfer => '转移';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return '转移：匹配 $matched，近似 $approximate，缺失 $notFound。';
  }

  @override
  String get plRecover => '修复';

  @override
  String plRecoverDone(int available, int alternatives) {
    return '修复：可用 $available，找到 $alternatives 个替代项。';
  }

  @override
  String plCopyName(String name) {
    return '$name（副本）';
  }

  @override
  String get plDuplicate => '复制';

  @override
  String plDuplicated(String name) {
    return '已复制：$name';
  }

  @override
  String plDeleted(String name) {
    return '已删除：$name';
  }

  @override
  String plTransferred(String name) {
    return '已转移：$name';
  }

  @override
  String get plTransferToLocal => '转移到本地';

  @override
  String get plExportJson => '导出 JSON';

  @override
  String get plExportCsv => '导出 CSV';

  @override
  String get plExportM3u => '导出 M3U';

  @override
  String get plExportJsonDone => 'JSON 导出成功';

  @override
  String get plExportCsvDone => 'CSV 导出成功';

  @override
  String plExportM3uDone(String path) {
    return 'M3U 已导出：$path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'M3U 导出失败：$detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已导入：$name（$count 首）',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'M3U 导入失败：$detail';
  }

  @override
  String get plSmartTitle => '智能播放列表';

  @override
  String plSmartLoadError(String detail) {
    return '无法加载智能播放列表：$detail';
  }

  @override
  String plDeleteError(String detail) {
    return '删除失败：$detail';
  }

  @override
  String get plSmartEmpty => '没有智能播放列表';

  @override
  String get plUntitled => '未命名';

  @override
  String get plSmartDeleteTitle => '删除智能播放列表？';

  @override
  String plPreviewError(String detail) {
    return '预览失败：$detail';
  }

  @override
  String get plEnterName => '请输入名称';

  @override
  String plSaveError(String detail) {
    return '保存失败：$detail';
  }

  @override
  String get plSmartEditTitle => '编辑智能播放列表';

  @override
  String get plSmartNewTitle => '新建智能播放列表';

  @override
  String get plMatchLabel => '匹配';

  @override
  String get plMatchAll => '全部规则';

  @override
  String get plMatchAny => '任一规则';

  @override
  String get plSectionRules => '规则';

  @override
  String get plAddRule => '添加规则';

  @override
  String get plMaxTracksLabel => '最大曲目数（可选）';

  @override
  String get plNoLimit => '不限';

  @override
  String get plPreviewMatching => '预览匹配的曲目';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首匹配曲目',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => '值';

  @override
  String get plUnknownTitle => '未知';

  @override
  String plTracksLoadError(String detail) {
    return '无法加载曲目：$detail';
  }

  @override
  String get plSmartNoTracks => '没有符合此播放列表的曲目';

  @override
  String get plFieldGenre => '流派';

  @override
  String get plFieldArtist => '艺人';

  @override
  String get plFieldAlbum => '专辑';

  @override
  String get plFieldTitle => '标题';

  @override
  String get plFieldYear => '年份';

  @override
  String get plFieldRating => '评分';

  @override
  String get plFieldPlayCount => '播放次数';

  @override
  String get plFieldDuration => '时长（毫秒）';

  @override
  String get plFieldDateAdded => '添加日期';

  @override
  String get plFieldFavorite => '收藏';

  @override
  String get plOpContains => '包含';

  @override
  String get plOpEquals => '等于';

  @override
  String get plOpStartsWith => '开头为';

  @override
  String get plOpEndsWith => '结尾为';

  @override
  String get plOpGreaterThan => '大于';

  @override
  String get plOpLessThan => '小于';

  @override
  String get plOpIs => '是';

  @override
  String get plOpIsNot => '不是';

  @override
  String get srvConfigTitle => '服务器配置';

  @override
  String srvFolderAdded(String path) {
    return '已添加文件夹：$path';
  }

  @override
  String get srvRemoveFolderTitle => '删除此文件夹？';

  @override
  String srvScanStarted(String path) {
    return '已开始扫描：$path';
  }

  @override
  String get srvFullScanStarted => '已开始完整扫描';

  @override
  String get srvRestartTitle => '重启服务器？';

  @override
  String get srvRestartBody => '服务器将停止并重新启动，当前播放将被中断。';

  @override
  String get srvRestartBtn => '重启';

  @override
  String get srvRestarting => '服务器正在重启…';

  @override
  String get srvRestartInProgress => '正在重启…';

  @override
  String get srvLoadError => '加载失败';

  @override
  String get srvScanFolderTooltip => '扫描此文件夹';

  @override
  String get srvSectionServerInfo => '服务器信息';

  @override
  String get srvInfoVersion => '版本';

  @override
  String get srvInfoEngine => '引擎';

  @override
  String get srvInfoDatabase => '数据库';

  @override
  String get srvSectionActions => '操作';

  @override
  String get srvRestartServer => '重启服务器';

  @override
  String get srvRestartServerDesc => '停止并重新启动服务器进程';

  @override
  String get srvManualEntry => '手动输入';

  @override
  String srvSelectPath(String path) {
    return '选择“$path”';
  }

  @override
  String get srvBrowse => '浏览…';

  @override
  String get srvFolderPathHint => '/path/to/music';

  @override
  String get srvFolderPathHelp => '请输入服务器上文件夹的绝对路径。';

  @override
  String get srvNoSubfolders => '没有子文件夹';

  @override
  String get srvPluginsTitle => '插件';

  @override
  String get srvNotConnectedToServer => '未连接到服务器';

  @override
  String srvPluginInstalled(String name) {
    return '已安装 $name';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '已卸载 $name';
  }

  @override
  String srvPluginUpdated(String name) {
    return '已更新 $name';
  }

  @override
  String srvPluginEnabled(String name) {
    return '已启用 $name';
  }

  @override
  String srvPluginDisabled(String name) {
    return '已停用 $name';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return '安装失败：$error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return '卸载失败：$error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return '更新失败：$error';
  }

  @override
  String get srvPluginsTabStore => '商店';

  @override
  String get srvPluginsTabInstalled => '已安装';

  @override
  String get srvRestartRequired => '需要重启才能应用更改';

  @override
  String get srvPluginsSearchHint => '搜索插件…';

  @override
  String get srvPluginsNoneFound => '未找到插件';

  @override
  String get srvPluginsNoneInstalled => '未安装插件';

  @override
  String get srvPluginsBrowseStore => '浏览商店';

  @override
  String get srvPluginBadgeFeatured => '精选';

  @override
  String get srvPluginBadgeUpdate => '更新';

  @override
  String get srvPluginBadgeIncompatible => '不兼容';

  @override
  String srvPluginByAuthor(String author) {
    return '作者：$author';
  }

  @override
  String get srvPluginActionUpdate => '更新';

  @override
  String get srvPluginActionInstall => '安装';

  @override
  String get srvPluginActionUninstall => '卸载';

  @override
  String get srvPluginStatusActive => '已启用';

  @override
  String get srvPluginStatusError => '错误';

  @override
  String get srvAutoFixTitle => '自动修复元数据';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已应用 $count 项修正',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence => '没有剩余的高置信度修正';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '剩余 $count 条建议',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => '应用高置信度';

  @override
  String srvAutoFixTrackNumber(int id) {
    return '曲目 #$id';
  }

  @override
  String get srvAutoFixCurrent => '当前';

  @override
  String get srvAutoFixEmpty => '（空）';

  @override
  String get srvAutoFixSuggested => '建议';

  @override
  String get srvAutoFixSkip => '跳过';

  @override
  String get srvAutoFixApply => '应用';

  @override
  String get srvAutoFixIntroTitle => '修复缺失的元数据';

  @override
  String get srvAutoFixIntroBody =>
      '扫描缺少流派、年份或 MusicBrainz ID 的曲目，并根据 MusicBrainz 提供修正建议。';

  @override
  String get srvAutoFixStartScan => '开始扫描';

  @override
  String get srvAutoFixScanning => '正在查询 MusicBrainz…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total 首曲目（$pct%）';
  }

  @override
  String get srvAutoFixLoadingTracks => '正在加载曲目…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '目前已找到 $count 项修正',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit => '限制为每秒 1 次请求（MusicBrainz 政策）';

  @override
  String get srvAutoFixNoneNeeded => '无需修正';

  @override
  String get srvAutoFixAllComplete => '所有曲目的元数据均已完整。';

  @override
  String get srvAutoFixScanAgain => '重新扫描';

  @override
  String get srvAutoFixScanFailed => '扫描失败';

  @override
  String get srvMpStepSetup => '设置';

  @override
  String get srvMpStepFineTune => '微调';

  @override
  String get srvMpListenTitle => '您如何聆听？';

  @override
  String get srvMpListenSubtitle => '配置文件将根据您的聆听环境进行调整';

  @override
  String get srvMpSpeakers => '音箱';

  @override
  String get srvMpSpeakersSub => '听音室';

  @override
  String get srvMpHeadphones => '耳机';

  @override
  String get srvMpHeadphonesSub => '个人聆听';

  @override
  String get srvMpRoomTitle => '房间有多大？';

  @override
  String get srvMpRoomSubtitle => '影响低频和混响';

  @override
  String get srvMpRoomSmall => '小';

  @override
  String get srvMpRoomMedium => '中';

  @override
  String get srvMpRoomLarge => '大';

  @override
  String get srvMpPlacementTitle => '音箱摆放';

  @override
  String get srvMpPlacementSubtitle => '摆放位置会影响低音反射';

  @override
  String get srvMpNearWall => '靠近墙壁';

  @override
  String get srvMpFreeStanding => '远离墙壁';

  @override
  String get srvMpTuneSound => '调整声音';

  @override
  String get srvMpCorrectionActive => '启用校正';

  @override
  String get srvMpCorrectionDesc => '将配置文件应用于当前区域';

  @override
  String get srvMpBass => '低音';

  @override
  String get srvMpBassDesc => '声音的重量、温暖感与厚度';

  @override
  String get srvMpBassLow => '单薄';

  @override
  String get srvMpBassHigh => '厚重';

  @override
  String get srvMpMid => '人声 / 中音';

  @override
  String get srvMpMidDesc => '临场感、清晰度、可懂度';

  @override
  String get srvMpMidLow => '靠后';

  @override
  String get srvMpMidHigh => '靠前';

  @override
  String get srvMpTreble => '高音';

  @override
  String get srvMpTrebleDesc => '明亮度、细节与空气感';

  @override
  String get srvMpTrebleLow => '暗淡';

  @override
  String get srvMpTrebleHigh => '明亮';

  @override
  String get srvMpProfileApplied => '已应用配置文件';

  @override
  String get srvMpApplying => '正在应用…';

  @override
  String get srvMpApply => '应用配置文件';

  @override
  String get srvMpBackToQuestions => '返回问题';

  @override
  String get srvRemoteConfigBody => '连接到网络中的 Tune 服务器即可使用全部功能。';

  @override
  String get srvModeStandalone => '独立模式';

  @override
  String get srvStandaloneWarning =>
      '独立模式下无法使用 Party、DJ、同步歌词、EQ 和推荐功能。建议使用远程 Tune 服务器。';

  @override
  String get srvServerAddress => '服务器地址';

  @override
  String get srvNoServerYet => '还没有服务器？';

  @override
  String get srvDownloadServer =>
      '下载 Tune Server：mozaiklabs.fr/download（Mac、Linux、Windows、Raspberry Pi、Docker NAS）';

  @override
  String get srvStreamingBody => '启用您想在 Tune 中使用的流媒体服务。';

  @override
  String get srvStreamingStandaloneWarning => '独立模式下无法使用流媒体服务。请切换到远程服务器模式以启用。';

  @override
  String get srvNoServiceAvailable => '没有可用的服务。请检查与服务器的连接。';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已启用 $count 项服务',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项已连接',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => '已启用，未连接';

  @override
  String get srvAudioCheckTitle => '音频诊断';

  @override
  String get srvAudioCheckBody => '正在检查系统的音频配置。';

  @override
  String get srvDiagZones => '已配置区域';

  @override
  String get srvDiagOutputs => '音频输出';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已检测到 $count 个',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => '网络设备';

  @override
  String get srvDiagNone => '无';

  @override
  String get srvDiagNoZoneWarning => '尚未配置区域。您可以在“区域”设置中创建。';

  @override
  String srvAudioCheckUnavailable(String error) {
    return '音频诊断不可用：$error';
  }

  @override
  String get srvRecheck => '重新检查';

  @override
  String get srvScanBody => '开始扫描以索引您的音乐文件并获取元数据。';

  @override
  String get srvScanStart => '开始扫描';

  @override
  String get srvScanStatScanned => '已扫描';

  @override
  String get srvScanStatAdded => '已添加';

  @override
  String get srvScanStatUpdated => '已更新';

  @override
  String get srvScanMayTakeMinutes => '这可能需要几分钟…';

  @override
  String get srvScanComplete => '扫描完成！';

  @override
  String stgUpdateAvailable(String version) {
    return '有可用更新：v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return '当前版本：v$version';
  }

  @override
  String get stgOpen => '打开';

  @override
  String get stgMode => '模式';

  @override
  String stgConnectedTo(String address) {
    return '已连接到 $address';
  }

  @override
  String get stgModeRemote => '远程';

  @override
  String get stgStandaloneTitle => '独立模式 — 功能受限';

  @override
  String get stgStandaloneBody => 'Party、DJ、同步歌词、EQ、专辑简介、推荐……需要远程 Tune 服务器。';

  @override
  String get stgServerAddress => '服务器地址';

  @override
  String get stgNotConfigured => '未配置';

  @override
  String get stgScanNetwork => '扫描网络';

  @override
  String get stgSectionPlayback => '播放';

  @override
  String get stgCrossfade => '交叉淡入淡出';

  @override
  String get stgRepeatOneByDefault => '默认循环播放';

  @override
  String get stgExclusiveMode => '独占模式（比特完美）';

  @override
  String get stgExclusiveModeDesc => 'WASAPI Exclusive — 直接访问 USB DAC';

  @override
  String get stgSectionMetadataFields => '元数据字段';

  @override
  String get stgSectionAdvancedAudio => '高级音频';

  @override
  String get stgEqualizer => '均衡器';

  @override
  String get stgEqualizerDesc => '校准助手 + 10 段专家 EQ';

  @override
  String get stgMetadataFieldsDesc => '配置扩展字段（作曲家、指挥……）';

  @override
  String get stgSpotifyConnectDesc => '将 Tune 用作接收器（客户端需 Premium）';

  @override
  String get stgLastfmDesc => 'Scrobble 收听记录';

  @override
  String get stgListenBrainzDesc => 'Scrobble 到 ListenBrainz';

  @override
  String get stgAutoFixMetadata => '自动修复元数据';

  @override
  String get stgAutoFixMetadataDesc => '通过 MusicBrainz 补全缺失的流派、年份、MBID';

  @override
  String get stgDatabase => '数据库';

  @override
  String get stgImportExport => '导入 / 导出';

  @override
  String get stgSectionProfiles => '个人资料';

  @override
  String get stgSectionSystem => '系统';

  @override
  String get stgServerConfig => '服务器配置';

  @override
  String get stgServerConfigDesc => '音乐文件夹、扫描、重启';

  @override
  String get stgNetworkDiagnostics => '网络诊断';

  @override
  String get stgNetworkDiagnosticsDesc => '组播、DNS、连通性';

  @override
  String get stgConfiguration => '配置';

  @override
  String get stgExportImport => '导出 / 导入';

  @override
  String get stgPlugins => '插件';

  @override
  String get stgPluginsDesc => '已安装的扩展';

  @override
  String get stgNetworkShares => '网络共享（SMB）';

  @override
  String get stgNetworkSharesDesc => '发现并挂载共享';

  @override
  String get stgSectionCloud => '云';

  @override
  String get stgSectionHelp => '帮助';

  @override
  String get stgTroubleshooting => '故障排除';

  @override
  String get stgTroubleshootingDesc => '常见问题与解决方案';

  @override
  String get stgSendBugReport => '发送错误报告';

  @override
  String get stgSendBugReportDesc => '生成并复制技术报告';

  @override
  String get stgServerAddressHint => 'IP 或主机名（例如 192.168.1.18）';

  @override
  String get stgServerPort => '服务器端口';

  @override
  String get stgPortDefaultHint => '端口（默认：8888）';

  @override
  String get stgWarnNoZones => '尚未配置区域。请创建一个区域以开始播放。';

  @override
  String get stgWarnNoNetworkDevices => '未检测到网络设备（DLNA/BluOS/Chromecast）。';

  @override
  String get stgSectionAudio => '音频';

  @override
  String get stgAudioOutputs => '音频输出';

  @override
  String stgOutputsDetected(int count) {
    return '已检测到 $count 个';
  }

  @override
  String get stgNetworkDevices => '网络设备';

  @override
  String get stgZoneNameHint => '例如：客厅、书房';

  @override
  String get stgProfileActivated => '已启用个人资料';

  @override
  String get stgNewProfile => '新建个人资料';

  @override
  String get stgProfileName => '个人资料名称';

  @override
  String get stgProfileNameHint => '例如：晚上、早上';

  @override
  String get stgProfileUpdated => '个人资料已更新';

  @override
  String get stgNoProfiles => '暂无个人资料';

  @override
  String get stgProfile => '个人资料';

  @override
  String get stgEditProfile => '编辑个人资料';

  @override
  String get stgName => '名称';

  @override
  String get stgColor => '颜色';

  @override
  String get stgScanInProgress => '正在扫描网络…';

  @override
  String stgScanChecking(int scanned, int total) {
    return '正在检查 $scanned/$total…';
  }

  @override
  String get stgNoServerFound => '未找到 Tune 服务器';

  @override
  String stgServersFound(int count) {
    return '找到 $count 台服务器';
  }

  @override
  String get stgTuneServers => 'Tune 服务器';

  @override
  String get stgFieldFormat => '格式（FLAC、MP3…）';

  @override
  String get stgFieldSampleRate => '采样率（96 kHz）';

  @override
  String get stgFieldBitDepth => '位深（24bit）';

  @override
  String get stgFieldLabel => '唱片公司';

  @override
  String get stgFieldComposer => '作曲家';

  @override
  String get stgFieldDuration => '时长';

  @override
  String get stgFieldSource => '来源（Tidal、Qobuz…）';

  @override
  String get stgMetadataFieldsIntro => '在每首曲目下显示的字段（搜索、音乐库、队列、历史）';

  @override
  String get stgAudiophileMode => '发烧友模式';

  @override
  String get stgAudiophileModeDesc => '绕过 DSP，停用 EQ，比特完美';

  @override
  String get stgCloudAccount => '云账户';

  @override
  String stgConnectedAs(String email) {
    return '已连接（$email）';
  }

  @override
  String get stgTelemetry => '遥测';

  @override
  String get stgTelemetryDesc => '发送匿名使用统计';

  @override
  String get stgSyncingLibrary => '正在同步音乐库…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total 首曲目';
  }

  @override
  String get stgConnectingStreaming => '正在连接流媒体服务…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'v$version 新功能';
  }

  @override
  String get stgWhatsNewLibrarySync => '改进的音乐库同步';

  @override
  String get stgWhatsNewMultiRoom => '优化多房间与区域管理';

  @override
  String get stgWhatsNewBugFixes => '错误修复与稳定性改进';

  @override
  String get stgStartServerFailed => '无法启动服务器';

  @override
  String stgStartServerFailedWith(String detail) {
    return '无法启动服务器：$detail';
  }

  @override
  String get stgConnectionFailed => '连接失败';

  @override
  String stgConnectionFailedWith(String detail) {
    return '连接失败：$detail';
  }

  @override
  String get stgStartingServer => '正在启动 Tune Server…';

  @override
  String get stgTagline => '多房间音乐服务器';

  @override
  String get stgLocalServer => '本地服务器';

  @override
  String get stgLocalServerDesc => '在此设备上运行 Tune。\n你的音乐，你做主。';

  @override
  String get stgRemoteControl => '遥控器';

  @override
  String get stgRemoteControlDesc => '连接到你网络中的\nTune 服务器。';

  @override
  String get stgRemoteConnection => '远程连接';

  @override
  String get znZoneManagerTitle => '区域管理器';

  @override
  String get znCannotDeleteLastZone => '无法删除最后一个区域';

  @override
  String znZoneSwitchError(String error) {
    return '切换区域失败：$error';
  }

  @override
  String get znZoneSettings => '区域设置';

  @override
  String get znPhoneSpeakers => '手机扬声器';

  @override
  String get znBtConnectedOutputs => '已连接的蓝牙输出';

  @override
  String get znBtSystemOutput => '使用系统输出（控制中心）';

  @override
  String get znBtOutputsTitle => '蓝牙输出';

  @override
  String get znBtNoDevice => '未连接蓝牙设备。请在系统设置中配对设备。';

  @override
  String get znBtAndroidRouting => '实际输出路由取决于 Android 系统设置。';

  @override
  String get znDsdMode => 'DSD 模式';

  @override
  String get znDsdAuto => '自动';

  @override
  String get znDsdNative => '原生';

  @override
  String get znGaplessDlnaDesc => '曲目之间无缝衔接（DLNA）';

  @override
  String get znFixedVolume => '固定音量';

  @override
  String get znFixedVolumeDesc => '停用软件音量控制';

  @override
  String get znCap16Bit => '限制为 16 位';

  @override
  String get znCap16BitDesc =>
      '若高解析度（24 位）无声而 16 位正常（Ruark R3），请开启。将转换为 16 位 FLAC。';

  @override
  String get znZoneMuted => '区域已静音';

  @override
  String get znZoneUnmuted => '已取消静音';

  @override
  String znErrMute(String error) {
    return '静音出错：$error';
  }

  @override
  String znErrVolume(String error) {
    return '音量出错：$error';
  }

  @override
  String znErrLatency(String error) {
    return '延迟出错：$error';
  }

  @override
  String znErrGroupVolume(String error) {
    return '分组音量出错：$error';
  }

  @override
  String get znCalibrationDone => '校准完成';

  @override
  String znErrCalibration(String error) {
    return '校准出错：$error';
  }

  @override
  String znErrDissolve(String error) {
    return '解散分组失败：$error';
  }

  @override
  String get znRenameGroupTitle => '重命名分组';

  @override
  String get znNewNameHint => '新名称';

  @override
  String get znRename => '重命名';

  @override
  String get znGroupRenamed => '分组已重命名';

  @override
  String znErrRename(String error) {
    return '重命名出错：$error';
  }

  @override
  String get znGroupNeedTwoZones => '至少需要 2 个区域才能创建分组';

  @override
  String get znGroupNameLabel => '分组名称';

  @override
  String get znGroupNameHint => '例如：客厅 + 厨房';

  @override
  String get znChooseLeader => '选择主控';

  @override
  String get znMembers => '成员';

  @override
  String znErrCreateGroup(String error) {
    return '创建分组失败：$error';
  }

  @override
  String get znProfileActivated => '配置已启用';

  @override
  String znErrActivate(String error) {
    return '启用出错：$error';
  }

  @override
  String get znProfileDeleted => '配置已删除';

  @override
  String znErrDelete(String error) {
    return '删除出错：$error';
  }

  @override
  String get znNoOfflineZones => '没有可删除的离线区域';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已删除 $count 个离线区域',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return '清理出错：$error';
  }

  @override
  String get znSaveConfigTitle => '保存配置';

  @override
  String get znProfileNameLabel => '配置名称';

  @override
  String get znProfileNameHint => '例如：派对、安静的早晨';

  @override
  String get znDescriptionOptional => '描述（可选）';

  @override
  String get znNameRequired => '名称为必填项';

  @override
  String get znProfileSaved => '配置已保存';

  @override
  String znErrSave(String error) {
    return '保存出错：$error';
  }

  @override
  String get znCleanupOffline => '清理离线区域';

  @override
  String get znRemoteRequired => '区域管理器需要连接到远程服务器。';

  @override
  String get znDataUnavailable => '数据不可用';

  @override
  String get znGroups => '分组';

  @override
  String get znNoGroups => '没有分组';

  @override
  String get znGroupFallback => '分组';

  @override
  String znZoneFallback(String id) {
    return '区域 $id';
  }

  @override
  String get znCalibrate => '校准';

  @override
  String get znDissolve => '解散';

  @override
  String get znProfiles => '配置';

  @override
  String get znNoProfiles => '没有已保存的配置';

  @override
  String get znSaveConfigButton => '保存配置';

  @override
  String get znProfileFallback => '配置';

  @override
  String get znPins => '固定项';

  @override
  String znPinFallback(int n) {
    return '固定项 $n';
  }

  @override
  String znPinInvoked(int n) {
    return '已启动固定项 $n';
  }

  @override
  String znPinInvokeError(String error) {
    return '无法启动固定项：$error';
  }

  @override
  String get znNoPins => '未配置固定项';

  @override
  String get znMute => '静音';

  @override
  String get znUnmute => '取消静音';

  @override
  String get znLatency => '延迟';

  @override
  String get znLatencyError => '错误';

  @override
  String znPartyAddError(String error) {
    return '无法添加曲目：$error';
  }

  @override
  String znPartyVoteError(String error) {
    return '投票出错：$error';
  }

  @override
  String get znPartyLinkCopied => '派对链接已复制到剪贴板';

  @override
  String get znPartyTitle => '派对模式';

  @override
  String get znPartyShareLink => '分享派对链接';

  @override
  String get znPartyAddHint => '添加曲目…';

  @override
  String get znPartyQueue => '队列';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首曲目',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => '未知区域';

  @override
  String get znUnknownTitle => '未知';

  @override
  String get znNowPlaying => '正在播放';

  @override
  String get znUpvote => '投票';

  @override
  String znDjLoadOnDeck(String deck) {
    return '将曲目载入 $deck 号碟';
  }

  @override
  String get znDjSearchHint => '搜索曲目…';

  @override
  String get znDjSearchHelp => '输入曲目名称，然后点按“搜索并载入”';

  @override
  String get znDjNoTracksFound => '未找到曲目';

  @override
  String znDjSearchError(String error) {
    return '搜索出错：$error';
  }

  @override
  String get znDjSearchAndLoad => '搜索并载入';

  @override
  String znDjLoadError(String error) {
    return '载入出错：$error';
  }

  @override
  String znDjPlayError(String error) {
    return '播放出错：$error';
  }

  @override
  String znDjPauseError(String error) {
    return '暂停出错：$error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return '交叉淡化出错：$error';
  }

  @override
  String get znDjTitle => 'DJ 模式';

  @override
  String get znDjDisabled => 'DJ 模式已关闭';

  @override
  String get znDjEnableHint => '开启后即可开始混音';

  @override
  String znDjDeck(String deck) {
    return '$deck 号碟';
  }

  @override
  String get znDjCrossfade => '交叉淡化';

  @override
  String znDjDuration(String seconds) {
    return '时长：$seconds 秒';
  }

  @override
  String get znDjStartCrossfade => '开始交叉淡化';

  @override
  String get znDjAutoCrossfade => '自动交叉淡化';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return '同步 $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => '同步失败';

  @override
  String get znDjNoTrackLoaded => '未载入曲目';

  @override
  String get znDjLoadTrack => '载入曲目';

  @override
  String get znDjGain => '增益';

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
