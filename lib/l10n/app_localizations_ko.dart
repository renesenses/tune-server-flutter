// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => '확인';

  @override
  String get btnCancel => '취소';

  @override
  String get btnAdd => '추가';

  @override
  String get btnSave => '저장';

  @override
  String get btnDelete => '삭제';

  @override
  String get btnEdit => '편집';

  @override
  String get btnClose => '닫기';

  @override
  String get btnRetry => '다시 시도';

  @override
  String get btnCreate => '만들기';

  @override
  String get btnClear => '지우기';

  @override
  String get btnNext => '다음';

  @override
  String get btnSkip => '이 단계 건너뛰기';

  @override
  String get btnFinish => '설정 완료';

  @override
  String get btnStart => '시작';

  @override
  String get btnConnect => '연결';

  @override
  String get btnDisconnect => '연결 해제';

  @override
  String get btnDownload => '다운로드';

  @override
  String get btnImport => '가져오기';

  @override
  String get btnExport => '내보내기';

  @override
  String get btnReset => '초기화';

  @override
  String get btnUse => '사용';

  @override
  String get btnShuffle => '셔플';

  @override
  String get btnSeeAll => '모두 보기';

  @override
  String get btnRefresh => '새로 고침';

  @override
  String get btnScan => '라이브러리 스캔';

  @override
  String get btnAddFolder => '폴더 추가';

  @override
  String get actionIrreversible => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get rootStartError => '시작 오류';

  @override
  String get playbackErrorNoZone => '선택된 존 없음 — 존을 생성하거나 선택하세요';

  @override
  String get playbackErrorZoneNotFound => '존을 찾을 수 없음';

  @override
  String get playbackErrorFailed => '재생 실패';

  @override
  String zoneLimitReached(int limit) {
    return '무료 플랜은 $limit개 존으로 제한됩니다 — 무제한을 원하면 Premium으로 업그레이드';
  }

  @override
  String get navLibrary => '라이브러리';

  @override
  String get navSearch => '검색';

  @override
  String get navStreaming => '스트리밍';

  @override
  String get navRadios => '라디오';

  @override
  String get navZones => '구역';

  @override
  String get navSettings => '설정';

  @override
  String get libraryTitle => '라이브러리';

  @override
  String get tabAlbums => '앨범';

  @override
  String get tabArtists => '아티스트';

  @override
  String get tabTracks => '트랙';

  @override
  String albumTracksDuration(int count, String duration) {
    return '$count곡 · $duration';
  }

  @override
  String get tabGenres => '장르';

  @override
  String get tabPlaylists => '플레이리스트';

  @override
  String get tabFavorites => '즐겨찾기';

  @override
  String get favoriteAdded => '즐겨찾기에 추가됨';

  @override
  String get favoriteRemoved => '즐겨찾기에서 제거됨';

  @override
  String get libraryEmptyFavorites => '즐겨찾기 없음';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => '라이브러리에 앨범이 없습니다';

  @override
  String get libraryEmptyArtists => '라이브러리에 아티스트가 없습니다';

  @override
  String get libraryEmptyTracks => '라이브러리에 트랙이 없습니다';

  @override
  String get libraryEmptyGenres => '장르 없음';

  @override
  String get libraryEmptyPlaylists => '플레이리스트 없음';

  @override
  String get libraryNoFilterResults => '필터와 일치하는 앨범 없음';

  @override
  String get libraryPlayAll => '모두 재생';

  @override
  String get libraryAddTo => '추가 대상…';

  @override
  String get libraryEditAlbum => '앨범 편집';

  @override
  String get libraryEditTrack => '트랙 편집';

  @override
  String get libraryPlay => '재생';

  @override
  String get genresAllTracks => '모든 트랙';

  @override
  String get playlistCreate => '플레이리스트 만들기';

  @override
  String get playlistName => '플레이리스트 이름';

  @override
  String get playlistEmpty => '트랙 없음';

  @override
  String get playlistAddTo => '플레이리스트에 추가';

  @override
  String get playlistNewPlaylist => '새 플레이리스트';

  @override
  String playlistTrackAdded(String name) {
    return '「$name」에 추가됨';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return '이미 「$name」에 있음';
  }

  @override
  String playlistTracksAdded(int count, String name) {
    return '\"$name\"에 $count곡 추가됨';
  }

  @override
  String get playlistAddAllTracks => '전체 플레이리스트에 추가';

  @override
  String get playlistDeleteTitle => '플레이리스트를 삭제하시겠습니까?';

  @override
  String get playlistDeleteBody => '이 플레이리스트는 영구적으로 삭제됩니다.';

  @override
  String get searchHint => '검색…';

  @override
  String get searchNoResults => '결과 없음';

  @override
  String get searchTopResult => '최상위 결과';

  @override
  String get searchSectionTracks => '트랙';

  @override
  String get searchSectionAlbums => '앨범';

  @override
  String get searchSectionArtists => '아티스트';

  @override
  String get searchSectionStreaming => '스트리밍';

  @override
  String get homeRecentlyPlayed => '최근 재생';

  @override
  String get homeLibrary => '라이브러리';

  @override
  String get homeQuickAccess => '빠른 접근';

  @override
  String get homeHistory => '기록';

  @override
  String get homeBrowseDlna => 'DLNA 탐색';

  @override
  String get homeStatTracks => '트랙';

  @override
  String get homeStatAlbums => '앨범';

  @override
  String get homeStatArtists => '아티스트';

  @override
  String get historyTitle => '기록';

  @override
  String get historyEmpty => '기록 없음';

  @override
  String get historyClear => '지우기';

  @override
  String get historyClearTitle => '기록 지우기';

  @override
  String get nowPlayingNoTrack => '트랙 없음';

  @override
  String get queueTitle => '재생 대기열';

  @override
  String queueUpNextSummary(int count, String time) {
    return '다음 $count곡 · $time';
  }

  @override
  String get queueEmpty => '대기열 비어 있음';

  @override
  String get queueClearTitle => '대기열을 비우시겠습니까?';

  @override
  String get queueClearBody => '재생 대기열에서 모든 트랙이 제거됩니다.';

  @override
  String get zonesTitle => '구역';

  @override
  String get zonesNew => '새 구역';

  @override
  String get zonesNewName => '구역 이름';

  @override
  String get zonesNone => '구역 없음';

  @override
  String get zonesRename => '구역 이름 바꾸기';

  @override
  String get zonesDelete => '구역 삭제';

  @override
  String get zonesDevices => '사용 가능한 기기';

  @override
  String get zonesOutputLocal => '로컬';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesAirplayPair => '페어링(PIN 코드)';

  @override
  String get zonesAirplayPairTitle => 'AirPlay 페어링';

  @override
  String get zonesAirplayPairIntro =>
      '일부 TV(삼성, LG)와 Apple TV는 화면에 4자리 코드를 표시합니다. 페어링을 시작한 다음 코드를 입력하세요.';

  @override
  String get zonesAirplayPairWaiting => '기기에 표시된 코드를 기다리는 중…';

  @override
  String get zonesAirplayPairEnterCode => '기기에 표시된 코드를 입력하세요:';

  @override
  String get zonesAirplayPairStart => '페어링 시작';

  @override
  String get zonesAirplayPairSubmit => '코드 제출';

  @override
  String get zonesAirplayPairRetry => '다시 시도';

  @override
  String get zonesOutputBluetooth => '블루투스';

  @override
  String get zonesChangeOutput => '출력 변경';

  @override
  String get zonesOutputTitle => '오디오 출력';

  @override
  String get zonesAssignDevice => '할당';

  @override
  String get zonesTransferTitle => '재생 위치...';

  @override
  String get zonesNowPlaying => '여기서 재생 중';

  @override
  String zonesActivated(String name) {
    return '활성 구역: $name';
  }

  @override
  String get radiosTitle => '라디오';

  @override
  String get radiosTabAll => '전체';

  @override
  String get radiosTabFavorites => '즐겨찾기';

  @override
  String get radiosNone => '라디오 없음';

  @override
  String get radiosFavNone => '즐겨찾는 라디오 없음';

  @override
  String get radiosSavedFavorites => '저장된 즐겨찾기';

  @override
  String get radiosAdd => '라디오 추가';

  @override
  String get radiosName => '이름';

  @override
  String get radiosStreamUrl => '스트림 URL';

  @override
  String get radiosGenre => '장르 (선택사항)';

  @override
  String get radiosPasteM3u => 'M3U 붙여넣기';

  @override
  String get radiosImportUrl => 'URL에서 가져오기';

  @override
  String get radiosImportUrlLabel => 'M3U 파일 URL';

  @override
  String radiosImportResult(int count) {
    return '$count개 방송국 가져옴';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'HTTP 오류 $code';
  }

  @override
  String get radiosImportFailed => '파일을 다운로드할 수 없습니다';

  @override
  String get radiosFavSaved => '트랙이 저장되었습니다';

  @override
  String get radioSaveFavorite => '트랙 저장';

  @override
  String get radioFavTitle => '라디오 즐겨찾기';

  @override
  String get radioFavEmpty => '저장된 즐겨찾기 없음';

  @override
  String get radioFavExportCsv => 'CSV 내보내기';

  @override
  String get streamingTitle => '스트리밍';

  @override
  String get streamingConnected => '연결됨';

  @override
  String get streamingNotConnected => '연결 안 됨';

  @override
  String get streamingEmail => '이메일';

  @override
  String get streamingPassword => '비밀번호';

  @override
  String get streamingSignIn => '로그인';

  @override
  String get streamingSigningIn => '로그인 중…';

  @override
  String get streamingDeviceCode => '확인 코드';

  @override
  String get streamingOpenLink => '열기…';

  @override
  String get streamingLogoutTitle => '연결 해제하시겠습니까?';

  @override
  String streamingLogoutBody(String service) {
    return '$service에서 연결 해제하시겠습니까?';
  }

  @override
  String get streamingAuthError => '인증 실패';

  @override
  String get streamingAlbumsSection => '앨범';

  @override
  String get streamingPlaylistsSection => '플레이리스트';

  @override
  String get browseTitle => '탐색';

  @override
  String get browseRefreshTooltip => '새로 고침';

  @override
  String get browseNoServers => 'UPnP/DLNA 서버가 감지되지 않았습니다';

  @override
  String get browseNoServersHint => '서버가 같은 Wi-Fi 네트워크에 있는지 확인하세요.';

  @override
  String get browseNoContent => '빈 폴더';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSectionAppearance => '외관';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsThemeSystem => '시스템';

  @override
  String get settingsThemeLight => '밝음';

  @override
  String get settingsThemeDark => '어두움';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLangSystem => '시스템';

  @override
  String get settingsSectionZones => '구역';

  @override
  String get settingsDefaultZone => '기본 구역';

  @override
  String get settingsDefaultZoneAuto => '자동';

  @override
  String get settingsNoZones => '구역 없음';

  @override
  String get settingsSectionServer => '서버';

  @override
  String get settingsHttpPort => 'HTTP 포트';

  @override
  String get settingsHttpPortDesc => '메인 서버 포트';

  @override
  String get settingsLocalIp => '로컬 IP 주소';

  @override
  String get settingsSectionLibrary => '라이브러리';

  @override
  String get settingsMetadata => '음악 및 메타데이터';

  @override
  String get settingsMetadataDesc => '폴더, 스캔, 통계';

  @override
  String get settingsSetupWizard => '설정 마법사';

  @override
  String get settingsSetupWizardDesc => '음악 소스 재구성';

  @override
  String get settingsSectionAbout => '정보';

  @override
  String get settingsVersion => '버전 0.1.0';

  @override
  String get settingsResetConfig => '설정 초기화';

  @override
  String get settingsResetTitle => '초기화하시겠습니까?';

  @override
  String get settingsResetBody => '모든 환경설정이 초기화됩니다. 다음 실행 시 시작 마법사가 표시됩니다.';

  @override
  String get settingsPortTitle => 'HTTP 포트';

  @override
  String get settingsPortHint => '포트 (1024–65535)';

  @override
  String get metadataTitle => '음악 및 메타데이터';

  @override
  String get metadataRefreshStats => '통계 새로 고침';

  @override
  String get metadataSectionStats => '통계';

  @override
  String get metadataStatTracks => '트랙';

  @override
  String get metadataStatAlbums => '앨범';

  @override
  String get metadataStatArtists => '아티스트';

  @override
  String get metadataStatPlaylists => '플레이리스트';

  @override
  String get metadataStatRadios => '라디오';

  @override
  String get metadataStatArtwork => '커버 캐시';

  @override
  String get metadataSectionScan => '라이브러리 스캔';

  @override
  String metadataScanInProgress(int current, int total) {
    return '스캔 중… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return '마지막 스캔: +$added개 추가, $updated개 업데이트';
  }

  @override
  String get metadataScanBtn => '라이브러리 스캔';

  @override
  String get metadataScanDesc => '설정된 모든 폴더를 인덱싱';

  @override
  String get metadataSectionFolders => '음악 폴더';

  @override
  String get metadataFoldersNone => '설정된 폴더 없음';

  @override
  String metadataFolderAddedOn(String date) {
    return '$date에 추가됨';
  }

  @override
  String get metadataAddFolder => '폴더 추가';

  @override
  String get metadataFolderPath => '폴더 경로';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => '정리';

  @override
  String get metadataCleanupOrphans => '고아 항목 삭제';

  @override
  String get metadataCleanupOrphansDesc => '트랙이 없는 앨범과 아티스트';

  @override
  String get metadataClearLibrary => '라이브러리 비우기';

  @override
  String get metadataClearLibraryDesc => '모든 로컬 트랙 삭제';

  @override
  String get metadataCleanupOrphansTitle => '고아 항목을 삭제하시겠습니까?';

  @override
  String get metadataCleanupOrphansBody =>
      '관련 트랙이 없는 앨범과 아티스트가 데이터베이스에서 삭제됩니다.';

  @override
  String get metadataClearLibraryTitle => '라이브러리를 비우시겠습니까?';

  @override
  String get metadataClearLibraryBody =>
      '모든 로컬 트랙, 앨범, 아티스트가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get metadataOrphansDeleted => '고아 항목이 삭제되었습니다';

  @override
  String get metadataLibraryCleared => '라이브러리가 비워졌습니다';

  @override
  String get metadataDeleteBtn => '삭제';

  @override
  String get metadataClearBtn => '비우기';

  @override
  String get setupWelcomeTitle => 'Tune Server에\n오신 것을 환영합니다';

  @override
  String get setupWelcomeBody =>
      '내장형 멀티룸 음악 서버입니다. 로컬 라이브러리, 스트리밍 서비스, 라디오를 모든 DLNA 또는 AirPlay 스피커로 전송하세요.';

  @override
  String get setupStart => '시작';

  @override
  String get setupLocalTitle => '로컬 라이브러리';

  @override
  String get setupLocalBody =>
      '오디오 파일(FLAC, MP3, AAC…)이 포함된 폴더 경로를 지정하세요. 나중에 설정에서 더 추가할 수 있습니다.';

  @override
  String get setupFolderPath => '폴더 경로';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => '이 폴더 추가';

  @override
  String get setupFolderAdded => '폴더가 추가되었습니다 — 스캔 중…';

  @override
  String get setupFolderEmpty => '폴더 경로를 입력하세요';

  @override
  String get setupUPnPTitle => 'UPnP/DLNA 서버';

  @override
  String get setupUPnPBody =>
      'Tune Server는 로컬 네트워크의 UPnP/DLNA 서버를 자동으로 검색합니다. 검색 → 탐색에서 라이브러리를 탐색하세요.';

  @override
  String get setupFeatureSsdp => '자동 SSDP 검색';

  @override
  String get setupFeatureContentDir => 'ContentDirectory 탐색';

  @override
  String get setupFeaturePlayback => 'DLNA 파일 직접 재생';

  @override
  String get setupFinish => '설정 완료';

  @override
  String get libraryPlayAlbum => '앨범 재생';

  @override
  String get libraryPlayNext => '다음에 재생';

  @override
  String radioFavExportDone(String path) {
    return 'CSV 내보내기 완료: $path';
  }

  @override
  String get radioFavExportError => '내보내기 오류';

  @override
  String get streamingViewAlbum => '앨범 보기';

  @override
  String get streamingLogoutContent => '계정 연결이 끊어집니다.';

  @override
  String get streamingUrlCopied => 'URL이 클립보드에 복사되었습니다';

  @override
  String get streamingDeviceCodeHint => '이 URL로 이동하여 위의 코드를 입력하세요:';

  @override
  String get searchHintFull => '아티스트, 앨범, 트랙 검색…';

  @override
  String get browseNavError => '탐색 오류';

  @override
  String get streamingCodeEntered => '코드를 입력했습니다';

  @override
  String get appleMusicAuthorize => '접근 허용';

  @override
  String get smbNavTitle => 'SMB 소스';

  @override
  String get smbTitle => 'SMB 연결';

  @override
  String get smbHostHint => 'SMB 서버 주소를 입력하세요';

  @override
  String get smbHostLabel => 'IP 주소（예：192.168.1.23）';

  @override
  String get smbUser => '사용자 이름';

  @override
  String get smbPassword => '비밀번호';

  @override
  String get smbConnect => '연결';

  @override
  String get smbSelectShare => '공유 선택';

  @override
  String get smbBack => '뒤로';

  @override
  String get smbManualHint => '공유를 자동으로 나열할 수 없습니다.\n공유 이름을 수동으로 입력하세요:';

  @override
  String get smbShareName => '공유 이름（예：Share, Music）';

  @override
  String get smbScan => '스캔';

  @override
  String get smbScanning => '스캔 중…';

  @override
  String smbScanCount(int count) {
    return '오디오 파일 $count개 발견';
  }

  @override
  String get smbDoneTitle => '인덱싱 완료';

  @override
  String smbDoneBody(int count, String share) {
    return '$share에서 $count개 트랙 가져옴';
  }

  @override
  String get smbAddAnother => '다른 공유 추가';

  @override
  String get settingsSmb => 'SMB / Samba 소스';

  @override
  String get settingsSmbDesc => '네트워크 공유에서 라이브러리 인덱싱';

  @override
  String get podcastsTitle => '팟캐스트';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => '검색';

  @override
  String get podcastsEmpty => '팟캐스트 없음';

  @override
  String get podcastsSearchHint => '팟캐스트 검색…';

  @override
  String get podcastsNoEpisodes => '에피소드 없음';

  @override
  String get navPodcasts => '팟캐스트';

  @override
  String get streamingConnectedSuccess => '연결됨!';

  @override
  String browseItemCount(int count) {
    return '$count 항목';
  }

  @override
  String get settingsSources => '소스 및 기기';

  @override
  String get settingsSourcesDesc => 'UPnP 서버, DLNA 렌더러';

  @override
  String get sourcesTitle => '소스 및 기기';

  @override
  String get sourcesServersSection => 'UPnP 콘텐츠 서버';

  @override
  String get sourcesRenderersSection => 'DLNA 렌더러';

  @override
  String get sourcesNoDevices => '발견된 기기 없음';

  @override
  String get sourcesTypeServer => '서버';

  @override
  String get sourcesTypeRenderer => '렌더러';

  @override
  String get sourcesAvailable => '사용 가능';

  @override
  String get sourcesUnavailable => '오프라인';

  @override
  String get sourcesIndexBtn => '라이브러리 인덱싱';

  @override
  String get sourcesRescanBtn => '다시 스캔';

  @override
  String get sourcesForget => '삭제';

  @override
  String get sourcesAddManually => '수동으로 추가';

  @override
  String get sourcesAddTitle => '수동 검색';

  @override
  String get sourcesIpLabel => 'IP 주소';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => '포트';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => '검색 중…';

  @override
  String get sourcesNotFound => '이 주소에서 UPnP 기기를 찾을 수 없습니다';

  @override
  String get zonesMultiRoom => '멀티룸';

  @override
  String get zonesCreateGroup => '그룹 만들기';

  @override
  String get zonesGroupLeader => '리더';

  @override
  String get zonesGroupFollower => '팔로워';

  @override
  String get zonesGroupDissolve => '그룹 해제';

  @override
  String get zonesGroupSyncDelay => '동기화 지연';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => '존 선택';

  @override
  String get zonesGroupSelectLeader => '리더 선택';

  @override
  String get zonesGroupNoZones => '활성 그룹 없음';

  @override
  String get zonesGroupNeedTwo => '최소 2개 존을 선택하세요';

  @override
  String get zonesGroupCreated => '그룹 생성됨';

  @override
  String get zonesGroupDissolved => '그룹 해제됨';

  @override
  String get metadataSectionEnrich => '보강';

  @override
  String get metadataSectionDuplicates => '중복';

  @override
  String get metadataSectionCorrect => '수정';

  @override
  String get metadataFilterAll => '전체';

  @override
  String get metadataFilterMissingCover => '커버 없음';

  @override
  String get metadataFilterMissingGenre => '장르 없음';

  @override
  String get metadataFilterMissingYear => '연도 없음';

  @override
  String get metadataFilterMissingArtist => '아티스트 없음';

  @override
  String get metadataFilterDoubtful => '의심스러운';

  @override
  String get metadataSearchHint => '앨범 검색…';

  @override
  String get metadataArtistFilter => '아티스트';

  @override
  String get metadataGenreFilter => '장르';

  @override
  String get metadataAllArtists => '모든 아티스트';

  @override
  String get metadataAllGenres => '모든 장르';

  @override
  String get metadataNoAlbums => '일치하는 앨범 없음';

  @override
  String get metadataEditAlbum => '앨범 편집';

  @override
  String get metadataSaveChanges => '저장';

  @override
  String get metadataWriteTags => '태그 쓰기';

  @override
  String metadataWriteTagsSuccess(int count) {
    return '태그 작성 완료: $count개 파일';
  }

  @override
  String get metadataMergeGroup => '병합';

  @override
  String metadataMergeConfirm(int count) {
    return '이 $count개 앨범을 병합하시겠습니까? 트랙이 가장 많은 앨범이 유지됩니다.';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return '병합 완료: $moved개 트랙 이동, 총 $total개';
  }

  @override
  String get metadataUploadCover => '커버 업로드';

  @override
  String get metadataCoverUploaded => '커버 업로드 완료';

  @override
  String get metadataAlbumSaved => '앨범 저장됨';

  @override
  String metadataDupAlbums(int count) {
    return '$count개 중복 앨범';
  }

  @override
  String get metadataDoubtfulReasons => '문제';

  @override
  String get metadataArtistField => '아티스트';

  @override
  String get metadataAlbumField => '앨범';

  @override
  String get metadataGenreField => '장르';

  @override
  String get metadataYearField => '연도';

  @override
  String metadataTracksCount(int count) {
    return '$count개 트랙';
  }

  @override
  String get stereoPairsTitle => '스테레오 페어';

  @override
  String get stereoPairCreate => '스테레오 페어 생성';

  @override
  String get stereoPairName => '페어 이름';

  @override
  String get stereoPairNameHint => '예: 거실 스테레오';

  @override
  String get stereoPairLeft => '왼쪽 (L)';

  @override
  String get stereoPairRight => '오른쪽 (R)';

  @override
  String get stereoPairSelectDevice => '장치 선택';

  @override
  String get stereoPairNone => '스테레오 페어 없음';

  @override
  String get stereoPairCreated => '스테레오 페어 생성됨';

  @override
  String get stereoPairDissolved => '스테레오 페어 해제됨';

  @override
  String get stereoPairDissolve => '해제';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => '활성화';

  @override
  String get streamingDisable => '비활성화';

  @override
  String get streamingEnabled => '서비스 활성화됨';

  @override
  String get streamingDisabled => '서비스 비활성화됨';

  @override
  String get onboardingWelcomeTitle => 'Tune에 오신 것을 환영합니다!';

  @override
  String get onboardingWelcomeBody => '내장 멀티룸 뮤직 서버입니다. 몇 가지 단계로 설치를 설정하겠습니다.';

  @override
  String get onboardingWelcomeStart => '시작하기';

  @override
  String get onboardingConfigTitle => '설정';

  @override
  String get onboardingConfigBody => '오디오 파일이 있는 폴더를 지정하거나 원격 Tune 서버에 연결하세요.';

  @override
  String get onboardingConfigModeLocal => '내장 서버';

  @override
  String get onboardingConfigModeRemote => '원격 서버';

  @override
  String get onboardingZoneTitle => '존 만들기';

  @override
  String get onboardingZoneBody =>
      '아래 장치가 네트워크에서 발견되었습니다. 하나를 탭하여 첫 번째 오디오 존을 만드세요.';

  @override
  String get onboardingZoneEmpty => '아직 장치가 발견되지 않았습니다. 나중에 추가할 수 있습니다.';

  @override
  String onboardingZoneCreated(String name) {
    return '존 생성됨: $name';
  }

  @override
  String get onboardingDoneTitle => '완료!';

  @override
  String get onboardingDoneBody => '설정이 완료되었습니다. 음악을 즐기세요!';

  @override
  String get onboardingDoneButton => '대시보드로 이동';

  @override
  String get artistBio => '바이오그래피';

  @override
  String get artistAnecdotes => '일화';

  @override
  String get artistSimilarArtists => '비슷한 아티스트';

  @override
  String get artistMembers => '멤버';

  @override
  String get artistDiscography => '디스코그래피';

  @override
  String get artistEnriching => '보강 진행 중…';

  @override
  String get artistGenres => '장르';

  @override
  String get libraryShuffleAll => '전체 셔플';

  @override
  String get librarySortBy => '정렬';

  @override
  String get librarySortTitle => '제목';

  @override
  String get librarySortArtist => '아티스트';

  @override
  String get librarySortYear => '연도';

  @override
  String get librarySortOriginalYear => '원본 연도';

  @override
  String get librarySortAddedDate => '추가 날짜';

  @override
  String get librarySortAscending => '오름차순';

  @override
  String get librarySortDescending => '내림차순';

  @override
  String get addFavorite => '즐겨찾기에 추가';

  @override
  String get addFolder => '폴더 추가';

  @override
  String get addThisFolder => '이 폴더 추가';

  @override
  String get addToPlaylist => '재생목록에 추가';

  @override
  String get addedToPlaylist => '재생목록에 추가됨';

  @override
  String get audioOutput => '오디오 출력';

  @override
  String get audioOutputDesc =>
      '각 서버 존은 하나의 출력입니다(로컬 ALSA, Diretta 렌더러…). 재생할 존을 선택하세요.';

  @override
  String get authorizeInBrowser => '브라우저에서 액세스를 승인하세요:';

  @override
  String get cancel => '취소';

  @override
  String get connect => '연결';

  @override
  String get connected => '연결됨';

  @override
  String get cover => '커버';

  @override
  String get create => '만들기';

  @override
  String get createPlaylist => '재생목록 만들기';

  @override
  String get delete => '삭제';

  @override
  String get deletePlaylist => '재생목록 삭제';

  @override
  String get deletePlaylistConfirm => '이 재생목록을 삭제할까요?';

  @override
  String get disabled => '비활성화됨';

  @override
  String get disconnected => '연결 안 됨';

  @override
  String get done => '완료했습니다';

  @override
  String get dynamicPlaylists => '동적 재생목록';

  @override
  String get dynamicTag => '동적';

  @override
  String errorWith(String msg) {
    return '오류: $msg';
  }

  @override
  String favError(String msg) {
    return '즐겨찾기 실패: $msg';
  }

  @override
  String get favoritesTitle => '즐겨찾기';

  @override
  String get filterAll => '전체';

  @override
  String get freqLimit => '주파수 제한';

  @override
  String get gapless => '갭리스 재생';

  @override
  String get gaplessDesc => '이 렌더러에서 트랙 사이에 백색 소음/끊김이 있으면 끄세요.';

  @override
  String get host => '호스트';

  @override
  String get language => '언어';

  @override
  String get loading => '불러오는 중…';

  @override
  String get localLibrary => '로컬 라이브러리';

  @override
  String get localLibraryDesc => '서버가 음악을 검색하는 폴더';

  @override
  String get logIn => '로그인';

  @override
  String get logOut => '로그아웃';

  @override
  String loginTo(String service) {
    return '$service에 로그인';
  }

  @override
  String get maxBitDepth => '최대 비트 심도';

  @override
  String get maxFrequency => '최대 주파수';

  @override
  String maxTracks(int n) {
    return '최대 $n';
  }

  @override
  String get metadataFields => '메타데이터 항목';

  @override
  String get metadataFieldsDesc => '로컬 라이브러리에 표시되는 정보';

  @override
  String get metadataSaved => '메타데이터 저장됨';

  @override
  String get musicFolders => '스캔된 폴더';

  @override
  String get navFavorites => '즐겨찾기';

  @override
  String get navPlaylists => '재생목록';

  @override
  String get newPlaylist => '새 재생목록';

  @override
  String get noFavAlbums => '즐겨찾는 앨범 없음';

  @override
  String get noFavArtists => '즐겨찾는 아티스트 없음';

  @override
  String get noFavTracks => '즐겨찾는 트랙 없음';

  @override
  String get noFolders => '구성된 폴더 없음';

  @override
  String get noLimit => '제한 없음';

  @override
  String get noPlaylists => '재생목록 없음';

  @override
  String get noResults => '결과 없음';

  @override
  String get noService => '서비스 없음';

  @override
  String get noTracks => '트랙 없음';

  @override
  String get noZones => '사용 가능한 존 없음';

  @override
  String get notConnected => '설정에서 서버를 구성하세요';

  @override
  String get nothingPlaying => '재생 중 아님';

  @override
  String get openAuthPage => '인증 페이지 열기';

  @override
  String get password => '비밀번호';

  @override
  String get pickFolder => '폴더 선택';

  @override
  String get playAll => '전체 재생';

  @override
  String get playlistCreated => '재생목록 생성됨';

  @override
  String get playlistDeleted => '재생목록 삭제됨';

  @override
  String get playlistsTitle => '재생목록';

  @override
  String get port => '포트';

  @override
  String get qualityCd => 'CD(44.1 kHz / 16비트)';

  @override
  String get qualityHires => 'Hi-Res(최대 192 kHz)';

  @override
  String get qualityMax => '최고';

  @override
  String get removeFavorite => '즐겨찾기에서 제거';

  @override
  String get removeFromPlaylist => '재생목록에서 제거';

  @override
  String get runScan => '라이브러리 스캔';

  @override
  String get scanning => '스캔 중…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · 내 라이브러리';

  @override
  String get searchEmptyTitle => '제목, 앨범 또는 아티스트 검색';

  @override
  String get searchTitle => '검색';

  @override
  String get sectionAlbums => '앨범';

  @override
  String get sectionArtists => '아티스트';

  @override
  String get sectionPlaylists => '재생목록';

  @override
  String get sectionTracks => '트랙';

  @override
  String get server => '서버';

  @override
  String get sourceLibrary => '라이브러리';

  @override
  String get streamingQuality => '스트리밍 품질';

  @override
  String get streamingQualityDesc => '서비스(Qobuz, Tidal…)에 요청하는 주파수/해상도를 제한합니다.';

  @override
  String get streamingServices => '스트리밍 서비스';

  @override
  String get systemLanguage => '시스템';

  @override
  String get trackRemoved => '재생목록에서 제거됨';

  @override
  String tracksCount(int n) {
    return '$n곡';
  }

  @override
  String get username => '사용자 이름';

  @override
  String get visualizer => '비주얼라이저';

  @override
  String get licenseSessionConflictTitle => '다른 서버에서 라이선스 사용 중';

  @override
  String get licenseSessionConflictBody =>
      'Tune 라이선스가 이미 다른 서버에서 사용 중입니다. 다른 서버가 중지된 후 몇 분 후에 이 서버가 자동으로 Premium으로 전환됩니다.';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'Tune 라이선스가 \'$server\'에서 사용 중입니다. 다른 서버가 중지된 후 몇 분 후에 이 서버가 자동으로 Premium으로 전환됩니다.';
  }

  @override
  String cfgSaveError(String detail) {
    return '저장 오류: $detail';
  }

  @override
  String get cfgReload => '새로고침';

  @override
  String get cfgFieldsLoadError => '필드를 불러올 수 없습니다';

  @override
  String get cfgFieldsNone => '사용 가능한 필드가 없습니다';

  @override
  String get cfgFieldsHint => '트랙 편집 화면에 표시할 메타데이터 필드를 선택하세요.';

  @override
  String get cfgMetaCompleteness => '메타데이터 완성도';

  @override
  String get cfgMetaEnrichMusicBrainz => 'MusicBrainz로 보강';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'MusicBrainz 보강';

  @override
  String get cfgMetaFixYearsTidal => '연도 수정 (TIDAL)';

  @override
  String get cfgMetaFixYearsDiscogs => '연도 수정 (Discogs)';

  @override
  String get cfgMetaFixGenres => '장르 수정';

  @override
  String get cfgMetaAutoFixAlbums => '앨범 자동 수정';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '대기 중인 제안 $count개',
      zero: '대기 중인 제안이 없습니다',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => '모두 수락';

  @override
  String get cfgMetaSuggestions => '제안';

  @override
  String get cfgMetaScanDuplicates => '중복 검색';

  @override
  String get cfgMetaAutoMerge => '자동 병합';

  @override
  String get cfgMetaMergeDuplicatesTask => '중복 병합';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '중복 앨범 $count개 ($groups개 그룹)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… 외 $count개 그룹',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => '최근 결과';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct% 완료';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label: 오류 — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label: $count개 수락됨';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label: $fixed/$total개 수정됨';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label: $fixed개 수정됨';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label: $total개 처리됨';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label: 완료';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return '태그 쓰기 오류: $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return '업로드 오류: $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '앨범 $count개를 병합할까요?',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody => '트랙이 가장 많은 앨범은 유지되고 나머지는 삭제됩니다.';

  @override
  String cfgMetaMergeError(String detail) {
    return '병합 오류: $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => '통계를 사용할 수 없습니다';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '앨범 $count개',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… 외 앨범 $count개 (필터로 좁혀 보세요)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count개 트랙';
  }

  @override
  String get cfgMetaReasonArtistUppercase => '아티스트 대문자';

  @override
  String get cfgMetaReasonArtistPlaceholder => '임시 아티스트';

  @override
  String get cfgMetaReasonArtistHasYear => '아티스트 = 폴더';

  @override
  String get cfgMetaReasonGenrePlaceholder => '임시 장르';

  @override
  String get cfgMetaReasonYearSuspicious => '의심스러운 연도';

  @override
  String get cfgMetaReasonTitleUppercase => '제목 대문자';

  @override
  String get cfgMetaReasonArtistMismatch => '아티스트 불일치';

  @override
  String get cfgSmbNotConnected => '원격 서버에 연결되어 있지 않습니다';

  @override
  String cfgSmbMountTitle(String name) {
    return '$name 마운트';
  }

  @override
  String get cfgSmbMount => '마운트';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name 마운트됨';
  }

  @override
  String get cfgSmbTitle => '네트워크 공유 (SMB)';

  @override
  String get cfgSmbSearching => 'SMB 공유 검색 중…';

  @override
  String get cfgSmbNone => 'SMB 공유를 찾지 못했습니다';

  @override
  String get cfgSmbSaveCredentials => '자격 증명 저장';

  @override
  String get cfgUnknown => '알 수 없음';

  @override
  String get cfgEqTitle => '이퀄라이저';

  @override
  String get cfgEqTabAssistant => '도우미';

  @override
  String get cfgEqTabExpert => '전문가';

  @override
  String cfgEqError(String detail) {
    return 'EQ 오류: $detail';
  }

  @override
  String get cfgEqPresetFlat => '플랫';

  @override
  String get cfgEqPresetBassBoost => '저음 강조';

  @override
  String get cfgEqPresetClassical => '클래식';

  @override
  String get cfgEqPresetVocal => '보컬';

  @override
  String get cfgNotConnectedToServer => '서버에 연결되어 있지 않습니다';

  @override
  String get cfgCredentialsRequired => '사용자 이름과 비밀번호가 필요합니다';

  @override
  String cfgServiceConnected(String service) {
    return '$service에 연결되었습니다.';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service 연결이 해제되었습니다.';
  }

  @override
  String get cfgLastfmTitle => 'Last.fm 스크로블';

  @override
  String get cfgLastfmDesc =>
      '청취 기록을 Last.fm에 스크로블합니다. 어느 존에서 재생하든 트랙이 자동으로 스크로블됩니다.';

  @override
  String get cfgDisconnecting => '연결 해제 중…';

  @override
  String get cfgConnectHeader => '연결';

  @override
  String get cfgConnecting => '연결 중…';

  @override
  String cfgScrobbleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '스크로블 $count회',
    );
    return '$_temp0';
  }

  @override
  String cfgLastScrobble(String date) {
    return '최근: $date';
  }

  @override
  String get cfgTokenRequired => '사용자 토큰을 입력하세요';

  @override
  String get cfgScrobblerUnavailable => '스크로블러를 사용할 수 없습니다';

  @override
  String cfgConnectedAs(String name) {
    return '$name(으)로 연결됨';
  }

  @override
  String get cfgListenbrainzDesc =>
      '청취 기록을 ListenBrainz에 스크로블합니다. 사용자 토큰은 listenbrainz.org/settings에서 받을 수 있습니다.';

  @override
  String get cfgUserToken => '사용자 토큰';

  @override
  String get cfgValidating => '확인 중…';

  @override
  String get cfgSaveAndConnect => '저장 후 연결';

  @override
  String get cfgScrobbleAuto => '트랙이 자동으로 스크로블됩니다';

  @override
  String cfgConfigExported(String path) {
    return '설정을 내보냈습니다: $path';
  }

  @override
  String get cfgConfigImported => '설정을 가져왔습니다';

  @override
  String cfgImportError(String detail) {
    return '가져오기 오류: $detail';
  }

  @override
  String get cfgConfigExportDesc => '서버 설정을 JSON 파일로 저장합니다.';

  @override
  String get cfgConfigExportJson => 'JSON 내보내기';

  @override
  String get cfgConfigImportDesc => 'JSON 파일에서 설정을 복원합니다.';

  @override
  String get cfgChooseFile => '파일 선택';

  @override
  String get cfgDbNoServer => '연결된 서버가 없습니다.';

  @override
  String cfgDbExportOk(String size, String path) {
    return '내보내기 완료: ${size}MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => '파일 경로에 접근할 수 없습니다.';

  @override
  String get cfgDbImportConfirmTitle => '가져오기 확인';

  @override
  String cfgDbImportConfirmBody(String name) {
    return '서버 데이터베이스를 \"$name\"(으)로 교체할까요?\n\n안전을 위한 백업이 자동으로 생성됩니다. 가져온 후에는 서버를 다시 시작해야 합니다.';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return '가져오기 완료: ${size}MB ($engine).\n변경 사항을 적용하려면 서버를 다시 시작하세요.';
  }

  @override
  String get cfgDbTitle => '데이터베이스';

  @override
  String get cfgDbIntro =>
      '연결된 서버의 데이터베이스를 내보내거나 가져옵니다.\nSQLite: .db 파일. PostgreSQL: SQL 덤프.';

  @override
  String get cfgDbExporting => '내보내는 중…';

  @override
  String get cfgDbExportBtn => '데이터베이스 내보내기';

  @override
  String get cfgDbImporting => '가져오는 중…';

  @override
  String get cfgDbImportBtn => '파일 가져오기';

  @override
  String get cfgDbFooter =>
      '가져온 후에는 변경 사항을 적용하려면 서버를 다시 시작하세요. 교체 전에 안전을 위한 백업이 자동으로 생성됩니다.';

  @override
  String cfgStatusUnavailable(String detail) {
    return '상태를 확인할 수 없습니다: $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune은 로컬 네트워크에서 Spotify Connect 수신기로 표시됩니다. Spotify 앱의 기기 목록에서 \"Tune (…)\"을 선택하세요. 클라이언트에 Spotify Premium 계정이 필요합니다.';

  @override
  String get cfgSpotifyNoLibrespot => '서버에서 librespot을 찾을 수 없습니다';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      '바이너리가 포함되도록 공식 tarball/zip으로 Tune Server를 다시 설치하거나 별도로 설치하세요 (apt install librespot / brew install librespot).';

  @override
  String get cfgTargetZone => '대상 존';

  @override
  String get cfgDeviceName => '기기 이름';

  @override
  String get cfgPlaying => '재생 중';

  @override
  String get cfgNetDiagTitle => '네트워크 진단';

  @override
  String get cfgNetSsdpActive => 'SSDP 활성';

  @override
  String get cfgNetMulticastReachable => '멀티캐스트 도달 가능';

  @override
  String get cfgError => '오류';

  @override
  String get cfgNetResolution => '확인 시간';

  @override
  String get cfgNetLatency => '지연 시간';

  @override
  String get cfgNetPublicIp => '공인 IP';

  @override
  String get cfgNetInterfaces => '네트워크 인터페이스';

  @override
  String get cfgStatusWarning => '주의';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total개 앨범';
  }

  @override
  String get libNoCollectionsYet => '아직 컬렉션이 없습니다';

  @override
  String libRatingError(String error) {
    return '평점 오류: $error';
  }

  @override
  String libDisc(int disc) {
    return '디스크 $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return '디스크 $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => '빠른 즐겨찾기';

  @override
  String get libAddToCollection => '컬렉션에 추가';

  @override
  String get libAlbumNotes => '앨범 노트';

  @override
  String get libCredits => '크레딧';

  @override
  String get libNoCredits => '크레딧 없음';

  @override
  String get libNoAlbumNotes => '사용 가능한 앨범 노트가 없습니다';

  @override
  String get libNoNotes => '사용 가능한 노트가 없습니다';

  @override
  String get libSourceCommunity => 'Tune 커뮤니티';

  @override
  String libBioSource(String source) {
    return '출처: $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return '출처: $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied => 'Apple Music 보관함 접근이 거부되었습니다.';

  @override
  String get libAppleMusicPermissionRefused =>
      '권한이 거부되었습니다. 설정 > 개인정보 보호 > 미디어 및 Apple Music에서 접근을 허용하세요.';

  @override
  String get libUnknownError => '알 수 없는 오류';

  @override
  String get libAppleMusicAccessTitle => 'Apple Music 접근';

  @override
  String get libAppleMusicAccessBody =>
      'Apple Music 트랙을 재생하려면 음악 보관함 접근을 허용하세요.';

  @override
  String get libAppleMusicEmpty => 'Apple Music 보관함이 비어 있습니다';

  @override
  String get libReportImageTitle => '이미지 신고';

  @override
  String get libReportImageBody =>
      '이 아티스트 이미지를 잘못된 것으로 신고할까요? 다음 보강 시 서버가 교체합니다.';

  @override
  String get libReportAction => '신고';

  @override
  String get libImageReported => '이미지를 신고했습니다';

  @override
  String libServiceAlbums(String service) {
    return '$service 앨범';
  }

  @override
  String libTrackCount(int count) {
    return '$count곡';
  }

  @override
  String get libDuplicateScanner => '중복 검사';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    return '중복 그룹 $groups개 발견 (총 $tracks곡)';
  }

  @override
  String get libFindDuplicatesTitle => '중복 트랙 찾기';

  @override
  String get libFindDuplicatesBody => '오디오 콘텐츠 해시를 검사해 라이브러리에서 동일한 트랙을 찾습니다.';

  @override
  String get libStartScan => '검사 시작';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total곡 ($percent%)';
  }

  @override
  String get libLoadingTracks => '트랙 불러오는 중…';

  @override
  String get libNoDuplicatesFound => '중복 항목이 없습니다';

  @override
  String get libLibraryClean => '라이브러리가 깔끔합니다.';

  @override
  String get libScanAgain => '다시 검사';

  @override
  String get libScanFailed => '검사 실패';

  @override
  String get libTrackNumberField => '트랙 번호';

  @override
  String get libDiscNumberField => '디스크 번호';

  @override
  String get libExtendedMetadata => '확장 메타데이터';

  @override
  String get libGenreTreeSaved => '장르 트리를 저장했습니다';

  @override
  String libSaveError(String error) {
    return '저장 오류: $error';
  }

  @override
  String get libGenreTree => '장르 트리';

  @override
  String get libAddRootGenre => '최상위 장르 추가';

  @override
  String get libGenreTreeRequiresRemote => '장르 트리를 사용하려면 원격 서버에 연결해야 합니다.';

  @override
  String get libNoGenreHierarchy => '정의된 장르 계층이 없습니다';

  @override
  String libAddSubGenreTo(String parent) {
    return '“$parent”에 하위 장르 추가';
  }

  @override
  String get libGenreName => '장르 이름';

  @override
  String libSubGenreCount(int count) {
    return '하위 장르 $count개';
  }

  @override
  String get libAddSubGenre => '하위 장르 추가';

  @override
  String get libRemove => '제거';

  @override
  String libRemoveNamedConfirm(String name) {
    return '“$name”을(를) 제거할까요?';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    return '하위 장르 $count개도 모두 제거됩니다.';
  }

  @override
  String get libRemoveGenreBody => '이 장르가 트리에서 제거됩니다.';

  @override
  String libAlbumCount(int count) {
    return '앨범 $count개';
  }

  @override
  String get libNoTracksForFilter => '이 필터에 맞는 트랙이 없습니다';

  @override
  String get libQualityLossless => '무손실';

  @override
  String get libQualityLossy => '손실';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total곡';
  }

  @override
  String get libNewCollection => '새 컬렉션';

  @override
  String get libCollectionName => '컬렉션 이름';

  @override
  String libCreateError(String error) {
    return '생성 오류: $error';
  }

  @override
  String libDeleteError(String error) {
    return '삭제 오류: $error';
  }

  @override
  String get libCollectionsTitle => '컬렉션';

  @override
  String get libCollectionsLoadFailed => '컬렉션을 불러오지 못했습니다';

  @override
  String get libDeleteCollectionTitle => '컬렉션을 삭제할까요?';

  @override
  String libDeleteCollectionBody(String name) {
    return '“$name”이(가) 영구적으로 삭제됩니다.';
  }

  @override
  String get libNoAlbumsInCollection => '이 컬렉션에 앨범이 없습니다';

  @override
  String get libDeleteConfirmTitle => '삭제할까요?';

  @override
  String get libDeleteSmartCollectionBody => '이 스마트 컬렉션이 영구적으로 삭제됩니다.';

  @override
  String get libNoRules => '규칙 없음';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return '크레딧: $role=$artist';
  }

  @override
  String get libAnd => '그리고';

  @override
  String get libOr => '또는';

  @override
  String get libSmartCollections => '스마트 컬렉션';

  @override
  String get libNewSmartCollection => '새 스마트 컬렉션';

  @override
  String get libNoSmartCollections => '스마트 컬렉션이 없습니다';

  @override
  String get libSmartCollectionsSeedHint => '서버는 보통 처음 시작할 때 기본 컬렉션 7개를 만듭니다.';

  @override
  String get libCreateFirstSmartCollection => '첫 스마트 컬렉션 만들기';

  @override
  String get libNoMatchingAlbums => '일치하는 앨범이 없습니다';

  @override
  String get libSmartCreditsHint =>
      '크레딧 기반 규칙(engineer, performer 등)을 쓰려면 먼저 설정에서 라이브러리를 보강하세요.';

  @override
  String get libFieldSampleRate => '샘플 레이트';

  @override
  String get libFieldBitDepth => '비트 심도';

  @override
  String get libFieldTrackCount => '트랙 수';

  @override
  String get libFieldFormat => '포맷';

  @override
  String get libFieldLabel => '레이블';

  @override
  String get libFieldAlbumTitle => '앨범 제목';

  @override
  String get libFieldSource => '소스';

  @override
  String get libFieldCredit => '크레딧';

  @override
  String get libFieldPlayCount => '재생 횟수';

  @override
  String get libFieldLastPlayed => '마지막 재생';

  @override
  String get libOpBetween => '사이';

  @override
  String get libOpContains => '포함';

  @override
  String get libOpStartsWith => '시작 문자';

  @override
  String get libOpEmpty => '비어 있음';

  @override
  String get libOpNotEmpty => '비어 있지 않음';

  @override
  String get libOpNever => '없음';

  @override
  String get libOpAfter => '이후';

  @override
  String get libOpBefore => '이전';

  @override
  String get libNameLabel => '이름';

  @override
  String get libMatchMode => '일치 조건';

  @override
  String get libMatchAll => '모든 규칙 (AND)';

  @override
  String get libMatchAny => '하나 이상 (OR)';

  @override
  String get libAddRule => '규칙 추가';

  @override
  String get libMatchingAlbumsPending => '일치하는 앨범 …개';

  @override
  String libMatchingAlbums(int count) {
    return '일치하는 앨범 $count개';
  }

  @override
  String get libTimestampHint => 'now-30d 또는 2024-01-01';

  @override
  String get libValueHint => '값';

  @override
  String get libMinHint => '최소';

  @override
  String get libMaxHint => '최대';

  @override
  String get libCommaSeparatedHint => '쉼표로 구분된 값';

  @override
  String get libCreditRoleHint => '역할 (engineer, performer, …)';

  @override
  String get libCreditArtistHint => '아티스트 (Rudy Van Gelder, …)';

  @override
  String get libCreditInstrumentHint => '악기 (Piano, …) — 선택 사항';

  @override
  String get libDirectories => '디렉터리';

  @override
  String get libLoadError => '불러오기 오류';

  @override
  String get libNoFolders => '폴더 없음';

  @override
  String get libAddFoldersInSettings => '설정에서 음악 폴더를 추가하세요';

  @override
  String get libFoldersHeader => '폴더';

  @override
  String libTracksHeaderCount(int count) {
    return '트랙 ($count)';
  }

  @override
  String get libPlayFromHere => '여기부터 재생';

  @override
  String get libTags => '태그';

  @override
  String get libNewTagHint => '새 태그…';

  @override
  String get libJustNow => '방금';

  @override
  String libMinutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String libHoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String get libYesterday => '어제';

  @override
  String libDaysAgo(int count) {
    return '$count일 전';
  }

  @override
  String get libNowListening => '지금 듣는 중';

  @override
  String get libContinueListening => '이어서 듣기';

  @override
  String get libRecentlyAdded => '최근 추가됨';

  @override
  String get libTopTracks => '인기 트랙';

  @override
  String get libTopArtists => '인기 아티스트';

  @override
  String get libRecommendations => '추천';

  @override
  String get libSourceLocal => '로컬';

  @override
  String get libFieldDuration => '재생 시간';

  @override
  String get libFilter => '필터';

  @override
  String get libRefreshAll => '모두 새로고침';

  @override
  String get libPodcastsSubscribed => '구독 중';

  @override
  String get libNoSubscriptions => '아직 구독이 없습니다';

  @override
  String get libSubscribeRssFeed => 'RSS 피드 구독';

  @override
  String get libUnknown => '알 수 없음';

  @override
  String get libUnsubscribeTitle => '구독을 취소할까요?';

  @override
  String libUnsubscribeBody(String name) {
    return '“$name” 구독을 취소할까요?';
  }

  @override
  String get libUnsubscribe => '구독 취소';

  @override
  String libEpisodeCount(int count) {
    return '에피소드 $count개';
  }

  @override
  String get libSubscribeToPodcast => '팟캐스트 구독';

  @override
  String get libRssFeedUrl => 'RSS 피드 URL';

  @override
  String get libSubscribe => '구독';

  @override
  String get libSubscribed => '구독했습니다.';

  @override
  String libSubscribeError(String error) {
    return '구독 오류: $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return '구독 취소 오류: $error';
  }

  @override
  String get libPodcastRefreshed => '팟캐스트를 새로고침했습니다.';

  @override
  String libRefreshError(String error) {
    return '새로고침 오류: $error';
  }

  @override
  String get libAllPodcastsRefreshed => '모든 팟캐스트를 새로고침했습니다.';

  @override
  String get libToday => '오늘';

  @override
  String get miscNavFolders => '폴더';

  @override
  String get miscNavCollections => '컬렉션';

  @override
  String get miscNavSmartCollections => '스마트 컬렉션';

  @override
  String get miscNavDjMode => 'DJ 모드';

  @override
  String get miscNavPartyMode => '파티 모드';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => '파티';

  @override
  String get miscNavSmartPlaylists => '스마트 재생목록';

  @override
  String get miscNavAlarms => '알람';

  @override
  String get miscNavGenreTree => '장르 트리';

  @override
  String get miscNavDashboard => '대시보드';

  @override
  String get miscNavDiagnostics => '진단';

  @override
  String get miscNavAdmin => '관리';

  @override
  String get miscNavMore => '더보기';

  @override
  String get miscNextTrack => '다음 트랙';

  @override
  String get miscPreviousTrack => '이전 트랙';

  @override
  String get miscUnknownError => '알 수 없는 오류';

  @override
  String get miscAuthorizationCode => '인증 코드';

  @override
  String get miscWaitingForValidation => '승인 대기 중…';

  @override
  String miscCodeValue(String code) {
    return '코드: $code';
  }

  @override
  String get miscQualityHigh => '높음';

  @override
  String get miscExplore => '탐색';

  @override
  String get miscFavoriteAlbums => '즐겨찾는 앨범';

  @override
  String get miscFavoriteTracks => '즐겨찾는 트랙';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '트랙 $count개 모두 보기',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => '내 재생목록';

  @override
  String get miscNoApiClient => 'API 클라이언트 없음';

  @override
  String miscServiceFavorites(String service) {
    return '$service 즐겨찾기';
  }

  @override
  String miscPlayAllCount(int count) {
    return '모두 재생 ($count)';
  }

  @override
  String get miscServiceNotFound => '서비스를 찾을 수 없습니다';

  @override
  String get miscYtHome => '홈';

  @override
  String get miscYtCharts => '차트';

  @override
  String get miscYtMoods => '분위기';

  @override
  String get miscNoData => '데이터 없음';

  @override
  String get miscNoContentAvailable => '사용 가능한 콘텐츠가 없습니다';

  @override
  String get miscNoChartsAvailable => '사용 가능한 차트가 없습니다';

  @override
  String get miscNoMoodsAvailable => '사용 가능한 분위기가 없습니다';

  @override
  String get miscDashTotalPlays => '총 재생 수';

  @override
  String get miscDashListeningTime => '청취 시간';

  @override
  String get miscDashUniqueTracks => '고유 트랙';

  @override
  String get miscDashUniqueArtists => '고유 아티스트';

  @override
  String get miscDashTopArtists => '인기 아티스트';

  @override
  String get miscDashTopAlbums => '인기 앨범';

  @override
  String get miscDashTopTracks => '인기 트랙';

  @override
  String get miscDashListeningByHour => '시간대별 청취';

  @override
  String get miscDashListeningByDay => '일별 청취';

  @override
  String get miscDashAllTime => '전체 기간';

  @override
  String miscDashLastDays(int days) {
    return '$days일';
  }

  @override
  String get miscUnknown => '알 수 없음';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count회 재생',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => '아직 청취 데이터가 없습니다';

  @override
  String get miscDashNoDataHint => '음악을 재생하면 여기에 통계가 표시됩니다.';

  @override
  String get miscDashLoadFailed => '대시보드를 불러오지 못했습니다';

  @override
  String get miscDiagRequiresRemote => '진단을 사용하려면 원격 서버 연결이 필요합니다.';

  @override
  String get miscDiagSystem => '시스템';

  @override
  String get miscDiagHealth => '상태';

  @override
  String get miscVersion => '버전';

  @override
  String get miscDiagUptime => '가동 시간';

  @override
  String get miscDiagMemory => '메모리';

  @override
  String get miscDiagDatabase => '데이터베이스';

  @override
  String miscZoneNumbered(String id) {
    return '구역 $id';
  }

  @override
  String get miscDiagLogs => '로그';

  @override
  String get miscDiagNoLogs => '사용 가능한 로그가 없습니다';

  @override
  String get miscAdminTitle => '관리 대시보드';

  @override
  String get miscAdminNotConnected => '원격 서버에 연결되어 있지 않습니다';

  @override
  String get miscAdminSystemHealth => '시스템 상태';

  @override
  String get miscAdminStatus => '상태';

  @override
  String get miscAdminDisk => '디스크';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return '검색된 기기 ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return '최근 오류 ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => '최근 오류 없음';

  @override
  String get miscTroubleshootingTitle => '문제 해결';

  @override
  String get miscFaqHeader => '자주 묻는 질문';

  @override
  String get miscFaq1Title => '서버가 보이지 않아요';

  @override
  String get miscFaq1Step1 => 'Tune 서버가 실행 중이며 접근 가능한지 확인하세요.';

  @override
  String get miscFaq1Step2 => '기기가 서버와 같은 Wi-Fi 네트워크에 연결되어 있는지 확인하세요.';

  @override
  String get miscFaq1Step3 =>
      'VPN을 사용 중이라면 끄거나 LAN 검색을 활성화하세요(예: nordvpn set lan-discovery on).';

  @override
  String get miscFaq1Step4 => '설정 > 모드 > 네트워크 검색에서 네트워크를 검색해 보세요.';

  @override
  String get miscFaq1Step5 => '서버 포트(기본값 8888)가 방화벽에 차단되지 않았는지 확인하세요.';

  @override
  String get miscFaq1Step6 => '서버와 앱을 다시 시작하세요.';

  @override
  String get miscFaq2Title => '음악이 재생되지 않아요';

  @override
  String get miscFaq2Step1 => '재생 구역이 선택되어 있는지 확인하세요(화면 하단 막대).';

  @override
  String get miscFaq2Step2 => '구역이 없다면 설정 > 오디오 > 구역 > 만들기에서 만드세요.';

  @override
  String get miscFaq2Step3 => '출력 기기(스피커, DAC)가 켜져 있고 같은 네트워크에 있는지 확인하세요.';

  @override
  String get miscFaq2Step4 => 'DLNA 기기는 검색된 뒤 몇 초 기다렸다가 재생을 시작하세요.';

  @override
  String get miscFaq2Step5 => '다른 파일을 시도해 보세요. 현재 파일 형식이 지원되지 않을 수 있습니다.';

  @override
  String get miscFaq2Step6 => '문제가 계속되면 앱을 다시 시작하세요.';

  @override
  String get miscFaq3Title => '커버가 표시되지 않아요';

  @override
  String get miscFaq3Step1 => '설정 > 라이브러리 > 소스에서 라이브러리 검색을 실행하세요.';

  @override
  String get miscFaq3Step2 => '파일에 커버가 내장되어 있는지 확인하세요(ID3/Vorbis 태그).';

  @override
  String get miscFaq3Step3 => '앨범 폴더에 cover.jpg 또는 folder.jpg 파일을 넣으세요.';

  @override
  String get miscFaq3Step4 => '설정 > 라이브러리 > 메타데이터에서 커버 자동 가져오기를 켜세요.';

  @override
  String get miscFaq3Step5 => '앱을 다시 시작해 이미지 캐시를 비우세요.';

  @override
  String get miscFaq4Title => '검색이 멈췄어요';

  @override
  String get miscFaq4Step1 => '첫 검색은 라이브러리 크기에 따라 몇 분이 걸릴 수 있습니다.';

  @override
  String get miscFaq4Step2 => '음악 폴더에 접근할 수 있는지 확인하세요(권한, SMB 마운트).';

  @override
  String get miscFaq4Step3 => '앱을 닫았다가 다시 실행하면 멈춘 검색을 중단할 수 있습니다.';

  @override
  String get miscFaq4Step4 => '서버 로그를 확인해 문제가 되는 파일을 찾으세요.';

  @override
  String get miscFaq4Step5 => '소스 폴더 수를 줄여 문제를 좁혀 보세요.';

  @override
  String get miscFaq5Title => 'DLNA/AirPlay 기기 연결 방법';

  @override
  String get miscFaq5Step1 =>
      'DLNA: 기기가 켜져 있고 같은 네트워크에 있어야 합니다. 출력 목록에 자동으로 나타납니다.';

  @override
  String get miscFaq5Step2 => '기기가 나타나지 않으면 라우터에서 멀티캐스트가 작동하는지 확인하세요.';

  @override
  String get miscFaq5Step3 =>
      '일부 라우터는 Wi-Fi 클라이언트 간 SSDP 트래픽을 차단합니다. 멀티캐스트 릴레이를 켜세요.';

  @override
  String get miscFaq5Step4 => 'BluOS: Bluesound 스피커는 자동으로 감지됩니다.';

  @override
  String get miscFaq5Step5 => 'Chromecast: Google Cast 기기는 사용 가능한 출력에 표시됩니다.';

  @override
  String get miscFaq5Step6 => '감지된 후 구역을 만들고 기기를 출력으로 지정하세요.';

  @override
  String get miscFaq6Title => '스트리밍 문제';

  @override
  String get miscFaq6Step1 =>
      '설정 > 스트리밍에서 서비스(TIDAL, Qobuz, Deezer) 로그인 정보가 올바른지 확인하세요.';

  @override
  String get miscFaq6Step2 => '세션이 만료되었다면 서비스 연결을 해제한 뒤 다시 연결하세요.';

  @override
  String get miscFaq6Step3 => '인터넷 연결을 확인하세요.';

  @override
  String get miscFaq6Step4 => '일부 트랙은 해당 지역에서 이용할 수 없을 수 있습니다.';

  @override
  String get miscFaq6Step5 => '음질 문제는 설정 > 고급 오디오의 스트리밍 품질 설정을 확인하세요.';

  @override
  String get miscFaq6Step6 => '문제가 계속되면 설정 > 도움말에서 버그 보고서를 보내세요.';

  @override
  String get miscBugReportCopied => '보고서를 클립보드에 복사했습니다';

  @override
  String get miscBugReportSent => '버그를 보냈습니다. 감사합니다!';

  @override
  String get miscBugReportSendFailed => '전송에 실패했습니다. 보고서를 포럼에 붙여 넣으세요.';

  @override
  String get miscBugReportTitle => '버그 보고서';

  @override
  String get miscRegenerate => '다시 생성';

  @override
  String get miscBugReportGenerateFailed => '보고서를 생성할 수 없습니다';

  @override
  String get miscSent => '전송됨!';

  @override
  String get miscSending => '전송 중…';

  @override
  String get miscSubmit => '제출';

  @override
  String get miscCopied => '복사됨!';

  @override
  String get miscCopyReport => '보고서 복사';

  @override
  String get miscAiServerNotConnected => '서버에 연결되어 있지 않습니다. 연결을 확인하세요.';

  @override
  String miscAiQueryFailed(int code) {
    return 'AI 요청 실패 ($code)';
  }

  @override
  String get miscAiNoReply => '응답 없음';

  @override
  String get miscAiAskHint => '질문을 입력하세요…';

  @override
  String get miscAiSend => '보내기';

  @override
  String get miscAiTitle => 'AI 어시스턴트';

  @override
  String get miscAiEmptyTitle => 'Tune AI 어시스턴트';

  @override
  String get miscAiEmptyBody => '음악에 대해 질문하거나\n추천을 요청해 보세요…';

  @override
  String miscAiAction(String action) {
    return '작업: $action';
  }

  @override
  String get miscCreateAccount => '계정 만들기';

  @override
  String get miscUsername => '사용자 이름';

  @override
  String get miscUsernameRequired => '사용자 이름을 입력하세요';

  @override
  String get miscEmailRequired => '이메일을 입력하세요';

  @override
  String get miscEmailInvalid => '잘못된 이메일';

  @override
  String get miscPasswordRequired => '비밀번호를 입력하세요';

  @override
  String miscPasswordMinLength(int min) {
    return '최소 $min자';
  }

  @override
  String get miscHaveAccountSignIn => '이미 계정이 있나요? 로그인';

  @override
  String get miscNoAccountSignUp => '계정이 없나요? 가입하기';

  @override
  String get npRepeat => '반복';

  @override
  String get npQueue => '대기열';

  @override
  String get npFavorite => '즐겨찾기';

  @override
  String get npRadioFavAdded => '라디오 즐겨찾기에 추가됨';

  @override
  String get npLyrics => '가사';

  @override
  String get npAlarm => '알람';

  @override
  String get npSleepTimer => '수면 타이머';

  @override
  String get npDspCrossfeed => 'DSP 크로스피드';

  @override
  String get npEqualizer => '이퀄라이저';

  @override
  String get npShare => '공유';

  @override
  String get npTransfer => '전송';

  @override
  String get npCopiedToClipboard => '클립보드에 복사됨';

  @override
  String get npNoLyricsFound => '가사를 찾을 수 없음';

  @override
  String get npNoLyricsAvailable => '가사 없음';

  @override
  String get npLyricsOpenFromNowPlaying => '전체 가사는 재생 중 화면에서 여세요';

  @override
  String get npLyricsLoadFailed => '가사를 불러오지 못했습니다';

  @override
  String get npLrcMetadataTooltip => '메타데이터';

  @override
  String get npLrcMetadataTitle => 'LRC 메타데이터';

  @override
  String get npLrcTitle => '제목';

  @override
  String get npLrcCreatedBy => '작성자';

  @override
  String get npLrcOffset => '오프셋 (ms)';

  @override
  String get npLrcHint => '같은 이름의 .lrc 파일을 오디오 파일 옆에 두세요.';

  @override
  String get npEqFlat => '플랫';

  @override
  String get npEqBassBoost => '저음 강화';

  @override
  String get npEqTrebleBoost => '고음 강화';

  @override
  String get npEqVocal => '보컬';

  @override
  String get npEqRock => '록';

  @override
  String get npEqJazz => '재즈';

  @override
  String get npEqClassical => '클래식';

  @override
  String get npEqElectronic => '일렉트로닉';

  @override
  String get npEqHipHop => '힙합';

  @override
  String get npEqAcoustic => '어쿠스틱';

  @override
  String npEqApplied(String preset) {
    return 'EQ: $preset';
  }

  @override
  String npEqError(String error) {
    return 'EQ 오류: $error';
  }

  @override
  String get npCrossfeedDesc => '스테레오 채널을 섞어 헤드폰에서 더 자연스럽게 들리게 합니다';

  @override
  String get npCrossfeedOff => '끄기';

  @override
  String get npCrossfeedLight => '약하게';

  @override
  String get npCrossfeedMedium => '중간';

  @override
  String get npCrossfeedStrong => '강하게';

  @override
  String npCrossfeedApplied(String level) {
    return '크로스피드: $level';
  }

  @override
  String npDspError(String error) {
    return 'DSP 오류: $error';
  }

  @override
  String get npTransferTitle => '재생 전송';

  @override
  String get npNoOtherZones => '사용 가능한 다른 구역이 없습니다';

  @override
  String npTransferredTo(String zone) {
    return '$zone(으)로 전송됨';
  }

  @override
  String npTransferError(String error) {
    return '전송 오류: $error';
  }

  @override
  String get npAlarmClock => '알람 시계';

  @override
  String npAlarmSetFor(String time) {
    return '$time에 알람이 설정됨';
  }

  @override
  String npAlarmError(String error) {
    return '알람 오류: $error';
  }

  @override
  String get npAlarmCancelled => '알람이 취소됨';

  @override
  String get npPause => '일시정지';

  @override
  String get npStop => '정지';

  @override
  String get npRoleComposer => '작곡';

  @override
  String get npRoleLyricist => '작사';

  @override
  String get npRoleArranger => '편곡';

  @override
  String get npRoleConductor => '지휘';

  @override
  String get npRolePerformer => '연주';

  @override
  String get npRoleProducer => '프로듀서';

  @override
  String get npRoleMixer => '믹싱';

  @override
  String get npRoleEngineer => '엔지니어';

  @override
  String get npCreditsEnriching => '보강 중…';

  @override
  String get npCreditsEnrich => 'MusicBrainz로 보강';

  @override
  String get npVolume => '볼륨';

  @override
  String get npChangeZone => '구역 변경';

  @override
  String get npZoneFallback => '구역';

  @override
  String get npFollowMe => '팔로우 미';

  @override
  String get npMovePlaybackTo => '재생 옮기기…';

  @override
  String get npNowPlaying => '재생 중';

  @override
  String get npTabMore => '더보기';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return '수면 타이머 설정: $minutes분 (페이드: $fade초)';
  }

  @override
  String npSleepTimerError(String error) {
    return '수면 타이머 오류: $error';
  }

  @override
  String get npSleepTimerCancelled => '수면 타이머가 취소됨';

  @override
  String get npSleepDuration => '시간';

  @override
  String get npSleepCustom => '사용자 지정';

  @override
  String get npSleepFadeOut => '페이드 아웃';

  @override
  String npSleepFadeDesc(int seconds) {
    return '마지막 $seconds초 동안 볼륨이 서서히 0으로 줄어듭니다.';
  }

  @override
  String get npSleepStarting => '시작 중…';

  @override
  String npSleepStart(String duration) {
    return '시작 ($duration)';
  }

  @override
  String get npSleepSelectDuration => '시간 선택';

  @override
  String get npSleepTimerActive => '타이머 작동 중';

  @override
  String get npSleepCancelTimer => '타이머 취소';

  @override
  String get npMoodChill => '칠';

  @override
  String get npMoodParty => '파티';

  @override
  String get npMoodFocus => '집중';

  @override
  String get npMoodEnergetic => '에너지';

  @override
  String get npNoZoneAvailable => '사용 가능한 구역이 없습니다';

  @override
  String npMoodNoTracks(String mood) {
    return '$mood에 맞는 트랙이 없습니다';
  }

  @override
  String get npMoodInvalidTrackIds => '오류: 잘못된 트랙 ID';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 트랙 재생 중',
      one: '1개 트랙 재생 중',
    );
    return '$mood 믹스: $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 트랙을 대기열에 추가함',
      one: '1개 트랙을 대기열에 추가함',
    );
    return '$mood 믹스: $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Smart AutoPlay 오류: $error';
  }

  @override
  String get npSmartAutoplayDesc => '분위기를 골라 스마트 플레이리스트를 만드세요';

  @override
  String get npAlarmsNotConnected => '원격 서버에 연결되지 않음';

  @override
  String get npAlarmSnoozed => '알람이 5분 후로 미뤄짐';

  @override
  String get npAlarmsTitle => '알람';

  @override
  String get npAlarmsEmpty => '알람 없음';

  @override
  String npZoneNumbered(String id) {
    return '구역 $id';
  }

  @override
  String get npAlarmSkipsHolidays => '공휴일 제외';

  @override
  String get npAlarmSnooze => '다시 알림';

  @override
  String get npAlarmDefaultName => '알람';

  @override
  String get npAlarmEdit => '알람 편집';

  @override
  String get npAlarmNew => '새 알람';

  @override
  String get npAlarmTime => '시간';

  @override
  String get npAlarmNameHint => '기상';

  @override
  String get npAlarmDays => '요일';

  @override
  String get npAlarmSkipHolidays => '공휴일 건너뛰기';

  @override
  String get npAlarmCountry => '국가:';

  @override
  String get npCountryFR => '프랑스';

  @override
  String get npCountryBE => '벨기에';

  @override
  String get npCountryCH => '스위스';

  @override
  String get npCountryCA => '캐나다';

  @override
  String get npCountryUS => '미국';

  @override
  String get npCountryDE => '독일';

  @override
  String get npCountryGB => '영국';

  @override
  String get npAlarmSource => '소스';

  @override
  String get npAlarmSourceType => '유형';

  @override
  String get npSourceRadio => '라디오';

  @override
  String get npSourcePlaylist => '플레이리스트';

  @override
  String get npSourceAlbum => '앨범';

  @override
  String get npAlarmSourceName => '소스 이름';

  @override
  String get npAlarmPlaylistId => '플레이리스트 ID';

  @override
  String get npAlarmAlbumId => '앨범 ID';

  @override
  String get npAlarmIdentifier => '식별자';

  @override
  String get npAlarmPlaybackZone => '재생 구역';

  @override
  String get npAlarmDefaultZone => '기본값';

  @override
  String npAlarmVolume(int percent) {
    return '볼륨: $percent%';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return '페이드 인: $seconds초';
  }

  @override
  String get npAlarmEnabled => '사용';

  @override
  String get npAlarmDeleteTitle => '알람을 삭제할까요?';

  @override
  String get npDayMon => '월';

  @override
  String get npDayTue => '화';

  @override
  String get npDayWed => '수';

  @override
  String get npDayThu => '목';

  @override
  String get npDayFri => '금';

  @override
  String get npDaySat => '토';

  @override
  String get npDaySun => '일';

  @override
  String get plHubTitle => '플레이리스트 허브';

  @override
  String get plTabSmartAi => 'AI';

  @override
  String get plTabTransfers => '전송';

  @override
  String get plSync => '동기화';

  @override
  String get plTabBackup => '백업';

  @override
  String get plCompare => '비교';

  @override
  String get plComparing => '비교 중…';

  @override
  String plCompareError(String detail) {
    return '비교 실패: $detail';
  }

  @override
  String get plNoPlaylistsAvailable => '사용 가능한 플레이리스트 없음';

  @override
  String get plSectionSource => '소스';

  @override
  String get plSectionTarget => '대상';

  @override
  String get plServiceLabel => '서비스';

  @override
  String get plPlaylistLabel => '플레이리스트';

  @override
  String get plLocal => '로컬';

  @override
  String get plSourceLabel => '소스';

  @override
  String get plRestoreSnapshotTitle => '스냅샷 복원';

  @override
  String get plLocalPlaylistNameLabel => '로컬 플레이리스트 이름:';

  @override
  String get plRestore => '복원';

  @override
  String plRestoreDone(String name, String matched, String notFound) {
    return '\"$name\" 복원됨: $matched곡 찾음, $notFound곡 찾을 수 없음.';
  }

  @override
  String plRestoreReplaced(String name, String matched, String notFound) {
    return '\"$name\" 대체됨: $matched곡 찾음, $notFound곡 찾을 수 없음.';
  }

  @override
  String get plExistingTitle => '이미 있는 플레이리스트';

  @override
  String plExistingBody(String name) {
    return '\"$name\" 플레이리스트가 이미 있습니다. 대체할까요?';
  }

  @override
  String get plReplace => '대체';

  @override
  String plDeleteSnapshotBody(String name) {
    return '\"$name\"의 스냅샷을 삭제할까요?';
  }

  @override
  String get plSyncIntervalTitle => '자동 동기화 간격';

  @override
  String get plSyncIntervalLabel => '분 (0 = 수동만):';

  @override
  String get plSyncIntervalHint => '예: 60';

  @override
  String get plNoTransfers => '전송 없음';

  @override
  String get plNoSyncLinks => '동기화 링크 없음';

  @override
  String get plNoSyncLinksHint => '전송에서 링크를 만드세요';

  @override
  String plPlaylistNumber(String id) {
    return '플레이리스트 #$id';
  }

  @override
  String plAutoEveryMinutes(String minutes) {
    return '자동 $minutes분';
  }

  @override
  String plSyncDone(
    String addedLocal,
    String removedLocal,
    String addedRemote,
    String removedRemote,
  ) {
    return '동기화 완료: 로컬 +$addedLocal/-$removedLocal, 원격 +$addedRemote/-$removedRemote';
  }

  @override
  String plSyncConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ', 충돌 $count건',
    );
    return '$_temp0';
  }

  @override
  String plSyncError(String detail) {
    return '동기화 실패: $detail';
  }

  @override
  String get plSectionBackup => '백업';

  @override
  String get plBackingUp => '백업 중…';

  @override
  String get plBackupAll => '모든 플레이리스트 백업';

  @override
  String plBackupResult(String playlists, String tracks) {
    return '플레이리스트 $playlists개 · $tracks곡';
  }

  @override
  String get plSectionSnapshots => '스냅샷';

  @override
  String get plNoSnapshots => '스냅샷이 없습니다. 백업을 실행해 만드세요.';

  @override
  String get plSectionBatchTransfer => '일괄 전송';

  @override
  String get plBatchTransferHint => '서비스의 모든 플레이리스트 전송';

  @override
  String get plTransferring => '전송 중…';

  @override
  String get plTransferAll => '모두 전송';

  @override
  String plBatchResult(String count, String status) {
    return '플레이리스트 $count개 — $status';
  }

  @override
  String get plMergeDone => '플레이리스트를 병합했습니다.';

  @override
  String plMergeError(String detail) {
    return '병합 실패: $detail';
  }

  @override
  String get plNameLabel => '이름';

  @override
  String plDeleteNamed(String name) {
    return '\"$name\"을(를) 삭제할까요?';
  }

  @override
  String plImportedLocal(String name) {
    return '\"$name\"을(를) 로컬로 가져왔습니다.';
  }

  @override
  String plImportError(String detail) {
    return '가져오기 실패: $detail';
  }

  @override
  String get plFilterAll => '전체';

  @override
  String get plMerge => '병합';

  @override
  String get plCancelMerge => '병합 취소';

  @override
  String get plMerging => '병합 중…';

  @override
  String get plImportToLocal => '로컬로 가져오기';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 선택됨',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => '중복 제거';

  @override
  String get plMergedNameHint => '병합된 플레이리스트 이름';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => '결과';

  @override
  String get plCommon => '공통';

  @override
  String get plSourceOnly => '소스에만';

  @override
  String get plTargetOnly => '대상에만';

  @override
  String plMatchRate(String rate) {
    return '일치율 $rate%';
  }

  @override
  String plOnlyInSource(int count) {
    return '소스에만 있음 ($count)';
  }

  @override
  String plOnlyInTarget(int count) {
    return '대상에만 있음 ($count)';
  }

  @override
  String plMoreCount(int count) {
    return '외 $count개';
  }

  @override
  String get plTransferPlaylistTitle => '플레이리스트 전송';

  @override
  String get plCreateOnRemote => '원격 서비스에 만들기';

  @override
  String get plTransfer => '전송';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return '전송: 일치 $matched, 유사 $approximate, 누락 $notFound.';
  }

  @override
  String get plRecover => '복구';

  @override
  String plRecoverDone(int available, int alternatives) {
    return '복구: 사용 가능 $available, 대체 항목 $alternatives개 찾음.';
  }

  @override
  String plCopyName(String name) {
    return '$name (사본)';
  }

  @override
  String get plDuplicate => '복제';

  @override
  String plDuplicated(String name) {
    return '복제됨: $name';
  }

  @override
  String plDeleted(String name) {
    return '삭제됨: $name';
  }

  @override
  String plTransferred(String name) {
    return '전송됨: $name';
  }

  @override
  String get plTransferToLocal => '로컬로 전송';

  @override
  String get plExportJson => 'JSON 내보내기';

  @override
  String get plExportCsv => 'CSV 내보내기';

  @override
  String get plExportM3u => 'M3U 내보내기';

  @override
  String get plExportJsonDone => 'JSON 내보내기 완료';

  @override
  String get plExportCsvDone => 'CSV 내보내기 완료';

  @override
  String plExportM3uDone(String path) {
    return 'M3U 내보냄: $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'M3U 내보내기 실패: $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '가져옴: $name ($count곡)',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'M3U 가져오기 실패: $detail';
  }

  @override
  String get plSmartTitle => '스마트 플레이리스트';

  @override
  String plSmartLoadError(String detail) {
    return '스마트 플레이리스트를 불러올 수 없습니다: $detail';
  }

  @override
  String plDeleteError(String detail) {
    return '삭제 실패: $detail';
  }

  @override
  String get plSmartEmpty => '스마트 플레이리스트 없음';

  @override
  String get plUntitled => '제목 없음';

  @override
  String get plSmartDeleteTitle => '스마트 플레이리스트를 삭제할까요?';

  @override
  String plPreviewError(String detail) {
    return '미리보기 실패: $detail';
  }

  @override
  String get plEnterName => '이름을 입력하세요';

  @override
  String plSaveError(String detail) {
    return '저장 실패: $detail';
  }

  @override
  String get plSmartEditTitle => '스마트 플레이리스트 편집';

  @override
  String get plSmartNewTitle => '새 스마트 플레이리스트';

  @override
  String get plMatchLabel => '일치';

  @override
  String get plMatchAll => '모든 규칙';

  @override
  String get plMatchAny => '하나 이상의 규칙';

  @override
  String get plSectionRules => '규칙';

  @override
  String get plAddRule => '규칙 추가';

  @override
  String get plMaxTracksLabel => '최대 곡 수 (선택)';

  @override
  String get plNoLimit => '제한 없음';

  @override
  String get plPreviewMatching => '일치하는 곡 미리보기';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '일치하는 곡 $count개',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => '값';

  @override
  String get plUnknownTitle => '알 수 없음';

  @override
  String plTracksLoadError(String detail) {
    return '곡을 불러올 수 없습니다: $detail';
  }

  @override
  String get plSmartNoTracks => '이 플레이리스트에 맞는 곡이 없습니다';

  @override
  String get plFieldGenre => '장르';

  @override
  String get plFieldArtist => '아티스트';

  @override
  String get plFieldAlbum => '앨범';

  @override
  String get plFieldTitle => '제목';

  @override
  String get plFieldYear => '연도';

  @override
  String get plFieldRating => '평점';

  @override
  String get plFieldPlayCount => '재생 횟수';

  @override
  String get plFieldDuration => '길이 (ms)';

  @override
  String get plFieldDateAdded => '추가한 날짜';

  @override
  String get plFieldFavorite => '즐겨찾기';

  @override
  String get plOpContains => '포함';

  @override
  String get plOpEquals => '같음';

  @override
  String get plOpStartsWith => '시작 문자';

  @override
  String get plOpEndsWith => '끝 문자';

  @override
  String get plOpGreaterThan => '보다 큼';

  @override
  String get plOpLessThan => '보다 작음';

  @override
  String get plOpIs => '일치';

  @override
  String get plOpIsNot => '불일치';

  @override
  String get srvConfigTitle => '서버 설정';

  @override
  String srvFolderAdded(String path) {
    return '폴더 추가됨: $path';
  }

  @override
  String get srvRemoveFolderTitle => '이 폴더를 삭제할까요?';

  @override
  String srvScanStarted(String path) {
    return '스캔 시작됨: $path';
  }

  @override
  String get srvFullScanStarted => '전체 스캔 시작됨';

  @override
  String get srvRestartTitle => '서버를 다시 시작할까요?';

  @override
  String get srvRestartBody => '서버가 중지된 후 다시 시작됩니다. 현재 재생이 중단됩니다.';

  @override
  String get srvRestartBtn => '다시 시작';

  @override
  String get srvRestarting => '서버 다시 시작 중…';

  @override
  String get srvRestartInProgress => '다시 시작하는 중…';

  @override
  String get srvLoadError => '불러오기 오류';

  @override
  String get srvScanFolderTooltip => '이 폴더 스캔';

  @override
  String get srvSectionServerInfo => '서버 정보';

  @override
  String get srvInfoVersion => '버전';

  @override
  String get srvInfoEngine => '엔진';

  @override
  String get srvInfoDatabase => '데이터베이스';

  @override
  String get srvSectionActions => '작업';

  @override
  String get srvRestartServer => '서버 다시 시작';

  @override
  String get srvRestartServerDesc => '서버 프로세스를 중지하고 다시 실행합니다';

  @override
  String get srvManualEntry => '직접 입력';

  @override
  String srvSelectPath(String path) {
    return '\"$path\" 선택';
  }

  @override
  String get srvBrowse => '찾아보기…';

  @override
  String get srvFolderPathHint => '/path/to/music';

  @override
  String get srvFolderPathHelp => '서버에 있는 폴더의 절대 경로를 입력하세요.';

  @override
  String get srvNoSubfolders => '하위 폴더 없음';

  @override
  String get srvPluginsTitle => '플러그인';

  @override
  String get srvNotConnectedToServer => '서버에 연결되지 않음';

  @override
  String srvPluginInstalled(String name) {
    return '$name 설치됨';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name 제거됨';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name 업데이트됨';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name 활성화됨';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name 비활성화됨';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return '설치 실패: $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return '제거 실패: $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return '업데이트 실패: $error';
  }

  @override
  String get srvPluginsTabStore => '스토어';

  @override
  String get srvPluginsTabInstalled => '설치됨';

  @override
  String get srvRestartRequired => '변경 사항을 적용하려면 다시 시작해야 합니다';

  @override
  String get srvPluginsSearchHint => '플러그인 검색…';

  @override
  String get srvPluginsNoneFound => '플러그인을 찾을 수 없음';

  @override
  String get srvPluginsNoneInstalled => '설치된 플러그인 없음';

  @override
  String get srvPluginsBrowseStore => '스토어 둘러보기';

  @override
  String get srvPluginBadgeFeatured => '추천';

  @override
  String get srvPluginBadgeUpdate => '업데이트';

  @override
  String get srvPluginBadgeIncompatible => '호환되지 않음';

  @override
  String srvPluginByAuthor(String author) {
    return '제작: $author';
  }

  @override
  String get srvPluginActionUpdate => '업데이트';

  @override
  String get srvPluginActionInstall => '설치';

  @override
  String get srvPluginActionUninstall => '제거';

  @override
  String get srvPluginStatusActive => '활성';

  @override
  String get srvPluginStatusError => '오류';

  @override
  String get srvAutoFixTitle => '메타데이터 자동 수정';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '수정 $count건 적용됨',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence => '신뢰도 높은 수정이 더 이상 없습니다';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '남은 제안 $count건',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => '신뢰도 높은 항목 적용';

  @override
  String srvAutoFixTrackNumber(int id) {
    return '트랙 #$id';
  }

  @override
  String get srvAutoFixCurrent => '현재';

  @override
  String get srvAutoFixEmpty => '(비어 있음)';

  @override
  String get srvAutoFixSuggested => '제안';

  @override
  String get srvAutoFixSkip => '건너뛰기';

  @override
  String get srvAutoFixApply => '적용';

  @override
  String get srvAutoFixIntroTitle => '누락된 메타데이터 수정';

  @override
  String get srvAutoFixIntroBody =>
      '장르, 연도 또는 MusicBrainz ID가 없는 트랙을 스캔하고 MusicBrainz 기반 수정을 제안합니다.';

  @override
  String get srvAutoFixStartScan => '스캔 시작';

  @override
  String get srvAutoFixScanning => 'MusicBrainz 검색 중…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total 트랙 ($pct%)';
  }

  @override
  String get srvAutoFixLoadingTracks => '트랙 불러오는 중…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '지금까지 수정 $count건 발견',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit => '초당 1회 요청으로 제한 (MusicBrainz 정책)';

  @override
  String get srvAutoFixNoneNeeded => '수정할 항목 없음';

  @override
  String get srvAutoFixAllComplete => '모든 트랙의 메타데이터가 완전합니다.';

  @override
  String get srvAutoFixScanAgain => '다시 스캔';

  @override
  String get srvAutoFixScanFailed => '스캔 실패';

  @override
  String get srvMpStepSetup => '설정';

  @override
  String get srvMpStepFineTune => '미세 조정';

  @override
  String get srvMpListenTitle => '어떻게 듣나요?';

  @override
  String get srvMpListenSubtitle => '프로필이 청취 환경에 맞게 조정됩니다';

  @override
  String get srvMpSpeakers => '스피커';

  @override
  String get srvMpSpeakersSub => '청취실';

  @override
  String get srvMpHeadphones => '헤드폰';

  @override
  String get srvMpHeadphonesSub => '개인 청취';

  @override
  String get srvMpRoomTitle => '방의 크기는 어느 정도인가요?';

  @override
  String get srvMpRoomSubtitle => '저음역과 잔향에 영향을 줍니다';

  @override
  String get srvMpRoomSmall => '작음';

  @override
  String get srvMpRoomMedium => '중간';

  @override
  String get srvMpRoomLarge => '큼';

  @override
  String get srvMpPlacementTitle => '스피커 배치';

  @override
  String get srvMpPlacementSubtitle => '배치는 저음 반사에 영향을 줍니다';

  @override
  String get srvMpNearWall => '벽 가까이';

  @override
  String get srvMpFreeStanding => '벽에서 떨어짐';

  @override
  String get srvMpTuneSound => '사운드 조정';

  @override
  String get srvMpCorrectionActive => '보정 활성화';

  @override
  String get srvMpCorrectionDesc => '현재 존에 프로필을 적용합니다';

  @override
  String get srvMpBass => '저음';

  @override
  String get srvMpBassDesc => '소리의 무게감, 따뜻함, 바디감';

  @override
  String get srvMpBassLow => '가벼움';

  @override
  String get srvMpBassHigh => '묵직함';

  @override
  String get srvMpMid => '보컬 / 중음';

  @override
  String get srvMpMidDesc => '존재감, 선명도, 명료도';

  @override
  String get srvMpMidLow => '뒤로';

  @override
  String get srvMpMidHigh => '앞으로';

  @override
  String get srvMpTreble => '고음';

  @override
  String get srvMpTrebleDesc => '광채, 디테일, 공기감';

  @override
  String get srvMpTrebleLow => '어두움';

  @override
  String get srvMpTrebleHigh => '밝음';

  @override
  String get srvMpProfileApplied => '프로필 적용됨';

  @override
  String get srvMpApplying => '적용 중…';

  @override
  String get srvMpApply => '프로필 적용';

  @override
  String get srvMpBackToQuestions => '질문으로 돌아가기';

  @override
  String get srvRemoteConfigBody => '네트워크의 Tune 서버에 연결하면 모든 기능을 사용할 수 있습니다.';

  @override
  String get srvModeStandalone => '단독 모드';

  @override
  String get srvStandaloneWarning =>
      '단독 모드에서는 Party, DJ, 싱크 가사, EQ, 추천 기능을 사용할 수 없습니다. 원격 Tune 서버 사용을 권장합니다.';

  @override
  String get srvServerAddress => '서버 주소';

  @override
  String get srvNoServerYet => '아직 서버가 없나요?';

  @override
  String get srvDownloadServer =>
      'Tune Server 다운로드: mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS)';

  @override
  String get srvStreamingBody => 'Tune에서 사용할 스트리밍 서비스를 활성화하세요.';

  @override
  String get srvStreamingStandaloneWarning =>
      '단독 모드에서는 스트리밍 서비스를 사용할 수 없습니다. 활성화하려면 원격 서버 모드로 전환하세요.';

  @override
  String get srvNoServiceAvailable => '사용 가능한 서비스가 없습니다. 서버 연결을 확인하세요.';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '서비스 $count개 활성화됨',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 연결됨',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => '활성화됨, 연결 안 됨';

  @override
  String get srvAudioCheckTitle => '오디오 진단';

  @override
  String get srvAudioCheckBody => '시스템의 오디오 구성을 확인하는 중입니다.';

  @override
  String get srvDiagZones => '설정된 존';

  @override
  String get srvDiagOutputs => '오디오 출력';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 감지됨',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => '네트워크 기기';

  @override
  String get srvDiagNone => '없음';

  @override
  String get srvDiagNoZoneWarning => '설정된 존이 없습니다. 존 설정에서 만들 수 있습니다.';

  @override
  String srvAudioCheckUnavailable(String error) {
    return '오디오 진단을 사용할 수 없음: $error';
  }

  @override
  String get srvRecheck => '다시 확인';

  @override
  String get srvScanBody => '스캔을 시작해 음악 파일을 인덱싱하고 메타데이터를 가져옵니다.';

  @override
  String get srvScanStart => '스캔 시작';

  @override
  String get srvScanStatScanned => '스캔됨';

  @override
  String get srvScanStatAdded => '추가됨';

  @override
  String get srvScanStatUpdated => '업데이트됨';

  @override
  String get srvScanMayTakeMinutes => '몇 분 정도 걸릴 수 있습니다…';

  @override
  String get srvScanComplete => '스캔 완료!';

  @override
  String stgUpdateAvailable(String version) {
    return '업데이트 가능: v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return '현재 버전: v$version';
  }

  @override
  String get stgOpen => '열기';

  @override
  String get stgMode => '모드';

  @override
  String stgConnectedTo(String address) {
    return '$address에 연결됨';
  }

  @override
  String get stgModeRemote => '원격';

  @override
  String get stgStandaloneTitle => '독립 실행 모드 — 기능 제한';

  @override
  String get stgStandaloneBody =>
      'Party, DJ, 동기화 가사, EQ, 앨범 소개, 추천… 기능은 원격 Tune 서버가 필요합니다.';

  @override
  String get stgServerAddress => '서버 주소';

  @override
  String get stgNotConfigured => '설정되지 않음';

  @override
  String get stgScanNetwork => '네트워크 검색';

  @override
  String get stgSectionPlayback => '재생';

  @override
  String get stgCrossfade => '크로스페이드';

  @override
  String get stgRepeatOneByDefault => '기본으로 반복 재생';

  @override
  String get stgExclusiveMode => '독점 모드 (비트 퍼펙트)';

  @override
  String get stgExclusiveModeDesc => 'WASAPI Exclusive — USB DAC 직접 접근';

  @override
  String get stgSectionMetadataFields => '메타데이터 항목';

  @override
  String get stgSectionAdvancedAudio => '고급 오디오';

  @override
  String get stgEqualizer => '이퀄라이저';

  @override
  String get stgEqualizerDesc => '보정 도우미 + 10밴드 전문가 EQ';

  @override
  String get stgMetadataFieldsDesc => '확장 항목 설정 (작곡가, 지휘자…)';

  @override
  String get stgSpotifyConnectDesc => 'Tune을 수신기로 사용 (클라이언트에 Premium 필요)';

  @override
  String get stgLastfmDesc => '청취 기록 Scrobble';

  @override
  String get stgListenBrainzDesc => 'ListenBrainz로 Scrobble';

  @override
  String get stgAutoFixMetadata => '메타데이터 자동 수정';

  @override
  String get stgAutoFixMetadataDesc => '누락된 장르, 연도, MBID를 MusicBrainz로 보완';

  @override
  String get stgDatabase => '데이터베이스';

  @override
  String get stgImportExport => '가져오기 / 내보내기';

  @override
  String get stgSectionProfiles => '프로필';

  @override
  String get stgSectionSystem => '시스템';

  @override
  String get stgServerConfig => '서버 설정';

  @override
  String get stgServerConfigDesc => '음악 폴더, 스캔, 재시작';

  @override
  String get stgNetworkDiagnostics => '네트워크 진단';

  @override
  String get stgNetworkDiagnosticsDesc => '멀티캐스트, DNS, 연결성';

  @override
  String get stgConfiguration => '구성';

  @override
  String get stgExportImport => '내보내기 / 가져오기';

  @override
  String get stgPlugins => '플러그인';

  @override
  String get stgPluginsDesc => '설치된 확장 기능';

  @override
  String get stgNetworkShares => '네트워크 공유 (SMB)';

  @override
  String get stgNetworkSharesDesc => '공유 검색 및 마운트';

  @override
  String get stgSectionCloud => '클라우드';

  @override
  String get stgSectionHelp => '도움말';

  @override
  String get stgTroubleshooting => '문제 해결';

  @override
  String get stgTroubleshootingDesc => '자주 묻는 질문 및 해결 방법';

  @override
  String get stgSendBugReport => '버그 보고서 보내기';

  @override
  String get stgSendBugReportDesc => '기술 보고서 생성 및 복사';

  @override
  String get stgServerAddressHint => 'IP 또는 호스트 이름 (예: 192.168.1.18)';

  @override
  String get stgServerPort => '서버 포트';

  @override
  String get stgPortDefaultHint => '포트 (기본값: 8888)';

  @override
  String get stgWarnNoZones => '설정된 구역이 없습니다. 재생하려면 구역을 만드세요.';

  @override
  String get stgWarnNoNetworkDevices =>
      '네트워크 장치가 감지되지 않았습니다 (DLNA/BluOS/Chromecast).';

  @override
  String get stgSectionAudio => '오디오';

  @override
  String get stgAudioOutputs => '오디오 출력';

  @override
  String stgOutputsDetected(int count) {
    return '$count개 감지됨';
  }

  @override
  String get stgNetworkDevices => '네트워크 장치';

  @override
  String get stgZoneNameHint => '예: 거실, 서재';

  @override
  String get stgProfileActivated => '프로필이 활성화되었습니다';

  @override
  String get stgNewProfile => '새 프로필';

  @override
  String get stgProfileName => '프로필 이름';

  @override
  String get stgProfileNameHint => '예: 저녁, 아침';

  @override
  String get stgProfileUpdated => '프로필이 업데이트되었습니다';

  @override
  String get stgNoProfiles => '프로필 없음';

  @override
  String get stgProfile => '프로필';

  @override
  String get stgEditProfile => '프로필 편집';

  @override
  String get stgName => '이름';

  @override
  String get stgColor => '색상';

  @override
  String get stgScanInProgress => '네트워크 검색 중…';

  @override
  String stgScanChecking(int scanned, int total) {
    return '확인 중 $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'Tune 서버를 찾을 수 없습니다';

  @override
  String stgServersFound(int count) {
    return '서버 $count개를 찾았습니다';
  }

  @override
  String get stgTuneServers => 'Tune 서버';

  @override
  String get stgFieldFormat => '포맷 (FLAC, MP3…)';

  @override
  String get stgFieldSampleRate => '샘플레이트 (96 kHz)';

  @override
  String get stgFieldBitDepth => '비트 심도 (24bit)';

  @override
  String get stgFieldLabel => '레이블';

  @override
  String get stgFieldComposer => '작곡가';

  @override
  String get stgFieldDuration => '재생 시간';

  @override
  String get stgFieldSource => '소스 (Tidal, Qobuz…)';

  @override
  String get stgMetadataFieldsIntro => '각 트랙 아래에 표시할 항목 (검색, 라이브러리, 대기열, 기록)';

  @override
  String get stgAudiophileMode => '오디오파일 모드';

  @override
  String get stgAudiophileModeDesc => 'DSP 우회, EQ 비활성화, 비트 퍼펙트';

  @override
  String get stgCloudAccount => '클라우드 계정';

  @override
  String stgConnectedAs(String email) {
    return '연결됨 ($email)';
  }

  @override
  String get stgTelemetry => '원격 분석';

  @override
  String get stgTelemetryDesc => '익명 사용 통계 보내기';

  @override
  String get stgSyncingLibrary => '라이브러리 동기화 중…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total 트랙';
  }

  @override
  String get stgConnectingStreaming => '스트리밍 서비스에 연결 중…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'v$version의 새로운 기능';
  }

  @override
  String get stgWhatsNewLibrarySync => '라이브러리 동기화 개선';

  @override
  String get stgWhatsNewMultiRoom => '멀티룸 및 구역 관리 최적화';

  @override
  String get stgWhatsNewBugFixes => '버그 수정 및 안정성 개선';

  @override
  String get stgStartServerFailed => '서버를 시작하지 못했습니다';

  @override
  String stgStartServerFailedWith(String detail) {
    return '서버를 시작하지 못했습니다: $detail';
  }

  @override
  String get stgConnectionFailed => '연결에 실패했습니다';

  @override
  String stgConnectionFailedWith(String detail) {
    return '연결에 실패했습니다: $detail';
  }

  @override
  String get stgStartingServer => 'Tune Server 시작 중…';

  @override
  String get stgTagline => '멀티룸 음악 서버';

  @override
  String get stgLocalServer => '로컬 서버';

  @override
  String get stgLocalServerDesc => '이 기기에서 Tune을 실행합니다.\n나의 음악, 나의 방식대로.';

  @override
  String get stgRemoteControl => '리모컨';

  @override
  String get stgRemoteControlDesc => '네트워크의\nTune 서버에 연결합니다.';

  @override
  String get stgRemoteConnection => '원격 연결';

  @override
  String get znZoneManagerTitle => '구역 관리자';

  @override
  String get znCannotDeleteLastZone => '마지막 구역은 삭제할 수 없습니다';

  @override
  String znZoneSwitchError(String error) {
    return '구역 전환 실패: $error';
  }

  @override
  String get znZoneSettings => '구역 설정';

  @override
  String get znPhoneSpeakers => '휴대폰 스피커';

  @override
  String get znBtConnectedOutputs => '연결된 Bluetooth 출력';

  @override
  String get znBtSystemOutput => '시스템 출력 사용(제어 센터)';

  @override
  String get znBtOutputsTitle => 'Bluetooth 출력';

  @override
  String get znBtNoDevice => '연결된 Bluetooth 기기가 없습니다. 시스템 설정에서 기기를 페어링하세요.';

  @override
  String get znBtAndroidRouting => '실제 출력 경로는 Android 시스템 설정에 따라 달라집니다.';

  @override
  String get znDsdMode => 'DSD 모드';

  @override
  String get znDsdAuto => '자동';

  @override
  String get znDsdNative => '네이티브';

  @override
  String get znGaplessDlnaDesc => '트랙 사이를 끊김 없이 재생(DLNA)';

  @override
  String get znFixedVolume => '고정 볼륨';

  @override
  String get znFixedVolumeDesc => '소프트웨어 볼륨 조절을 끕니다';

  @override
  String get znCap16Bit => '16비트로 제한';

  @override
  String get znCap16BitDesc =>
      '하이레즈(24비트)는 소리가 나지 않고 16비트는 재생될 때 켜세요(Ruark R3). 16비트 FLAC으로 변환합니다.';

  @override
  String get znZoneMuted => '구역 음소거됨';

  @override
  String get znZoneUnmuted => '음소거 해제됨';

  @override
  String znErrMute(String error) {
    return '음소거 오류: $error';
  }

  @override
  String znErrVolume(String error) {
    return '볼륨 오류: $error';
  }

  @override
  String znErrLatency(String error) {
    return '지연 시간 오류: $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return '그룹 볼륨 오류: $error';
  }

  @override
  String get znCalibrationDone => '보정 완료';

  @override
  String znErrCalibration(String error) {
    return '보정 오류: $error';
  }

  @override
  String znErrDissolve(String error) {
    return '그룹 해제 실패: $error';
  }

  @override
  String get znRenameGroupTitle => '그룹 이름 변경';

  @override
  String get znNewNameHint => '새 이름';

  @override
  String get znRename => '이름 변경';

  @override
  String get znGroupRenamed => '그룹 이름이 변경됨';

  @override
  String znErrRename(String error) {
    return '이름 변경 오류: $error';
  }

  @override
  String get znGroupNeedTwoZones => '그룹을 만들려면 구역이 2개 이상 필요합니다';

  @override
  String get znGroupNameLabel => '그룹 이름';

  @override
  String get znGroupNameHint => '예: 거실 + 주방';

  @override
  String get znChooseLeader => '리더 선택';

  @override
  String get znMembers => '구성원';

  @override
  String znErrCreateGroup(String error) {
    return '그룹 생성 실패: $error';
  }

  @override
  String get znProfileActivated => '프로필 활성화됨';

  @override
  String znErrActivate(String error) {
    return '활성화 오류: $error';
  }

  @override
  String get znProfileDeleted => '프로필 삭제됨';

  @override
  String znErrDelete(String error) {
    return '삭제 오류: $error';
  }

  @override
  String get znNoOfflineZones => '삭제할 오프라인 구역이 없습니다';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '오프라인 구역 $count개 삭제됨',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return '정리 오류: $error';
  }

  @override
  String get znSaveConfigTitle => '구성 저장';

  @override
  String get znProfileNameLabel => '프로필 이름';

  @override
  String get znProfileNameHint => '예: 파티, 조용한 아침';

  @override
  String get znDescriptionOptional => '설명(선택)';

  @override
  String get znNameRequired => '이름을 입력해야 합니다';

  @override
  String get znProfileSaved => '프로필 저장됨';

  @override
  String znErrSave(String error) {
    return '저장 오류: $error';
  }

  @override
  String get znCleanupOffline => '오프라인 구역 정리';

  @override
  String get znRemoteRequired => '구역 관리자를 사용하려면 원격 서버에 연결해야 합니다.';

  @override
  String get znDataUnavailable => '데이터를 사용할 수 없음';

  @override
  String get znGroups => '그룹';

  @override
  String get znNoGroups => '그룹 없음';

  @override
  String get znGroupFallback => '그룹';

  @override
  String znZoneFallback(String id) {
    return '구역 $id';
  }

  @override
  String get znCalibrate => '보정';

  @override
  String get znDissolve => '해제';

  @override
  String get znProfiles => '프로필';

  @override
  String get znNoProfiles => '저장된 프로필 없음';

  @override
  String get znSaveConfigButton => '구성 저장';

  @override
  String get znProfileFallback => '프로필';

  @override
  String get znPins => '핀';

  @override
  String znPinFallback(int n) {
    return '핀 $n';
  }

  @override
  String znPinInvoked(int n) {
    return '핀 $n 실행됨';
  }

  @override
  String znPinInvokeError(String error) {
    return '핀 실행 실패: $error';
  }

  @override
  String get znNoPins => '설정된 핀 없음';

  @override
  String get znMute => '음소거';

  @override
  String get znUnmute => '음소거 해제';

  @override
  String get znLatency => '지연 시간';

  @override
  String get znLatencyError => '오류';

  @override
  String znPartyAddError(String error) {
    return '트랙 추가 실패: $error';
  }

  @override
  String znPartyVoteError(String error) {
    return '투표 오류: $error';
  }

  @override
  String get znPartyLinkCopied => '파티 링크가 클립보드에 복사됨';

  @override
  String get znPartyTitle => '파티 모드';

  @override
  String get znPartyShareLink => '파티 링크 공유';

  @override
  String get znPartyAddHint => '트랙 추가…';

  @override
  String get znPartyQueue => '대기열';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => '알 수 없는 구역';

  @override
  String get znUnknownTitle => '알 수 없음';

  @override
  String get znNowPlaying => '재생 중';

  @override
  String get znUpvote => '추천';

  @override
  String znDjLoadOnDeck(String deck) {
    return '덱 $deck에 트랙 불러오기';
  }

  @override
  String get znDjSearchHint => '트랙 검색…';

  @override
  String get znDjSearchHelp => '트랙 이름을 입력하고 검색 후 불러오기를 누르세요';

  @override
  String get znDjNoTracksFound => '트랙을 찾을 수 없음';

  @override
  String znDjSearchError(String error) {
    return '검색 오류: $error';
  }

  @override
  String get znDjSearchAndLoad => '검색 후 불러오기';

  @override
  String znDjLoadError(String error) {
    return '불러오기 오류: $error';
  }

  @override
  String znDjPlayError(String error) {
    return '재생 오류: $error';
  }

  @override
  String znDjPauseError(String error) {
    return '일시정지 오류: $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return '크로스페이드 오류: $error';
  }

  @override
  String get znDjTitle => 'DJ 모드';

  @override
  String get znDjDisabled => 'DJ 모드가 꺼져 있습니다';

  @override
  String get znDjEnableHint => '켜면 믹싱을 시작할 수 있습니다';

  @override
  String znDjDeck(String deck) {
    return '덱 $deck';
  }

  @override
  String get znDjCrossfade => '크로스페이드';

  @override
  String znDjDuration(String seconds) {
    return '길이: $seconds초';
  }

  @override
  String get znDjStartCrossfade => '크로스페이드 시작';

  @override
  String get znDjAutoCrossfade => '자동 크로스페이드';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return '동기화 $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => '동기화 실패';

  @override
  String get znDjNoTrackLoaded => '불러온 트랙 없음';

  @override
  String get znDjLoadTrack => '트랙 불러오기';

  @override
  String get znDjGain => '게인';

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
