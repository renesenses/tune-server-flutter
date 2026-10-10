// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tune Server';

  @override
  String get btnOk => 'OK';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnAdd => 'Añadir';

  @override
  String get btnSave => 'Guardar';

  @override
  String get btnDelete => 'Eliminar';

  @override
  String get btnEdit => 'Editar';

  @override
  String get btnClose => 'Cerrar';

  @override
  String get btnRetry => 'Reintentar';

  @override
  String get btnCreate => 'Crear';

  @override
  String get btnClear => 'Borrar';

  @override
  String get btnNext => 'Siguiente';

  @override
  String get btnSkip => 'Omitir este paso';

  @override
  String get btnFinish => 'Finalizar configuración';

  @override
  String get btnStart => 'Comenzar';

  @override
  String get btnConnect => 'Conectar';

  @override
  String get btnDisconnect => 'Desconectar';

  @override
  String get btnDownload => 'Descargar';

  @override
  String get btnImport => 'Importar';

  @override
  String get btnExport => 'Exportar';

  @override
  String get btnReset => 'Restablecer';

  @override
  String get btnUse => 'Usar';

  @override
  String get btnShuffle => 'Mezclar';

  @override
  String get btnSeeAll => 'Ver todo';

  @override
  String get btnRefresh => 'Actualizar';

  @override
  String get btnScan => 'Escanear biblioteca';

  @override
  String get btnAddFolder => 'Añadir carpeta';

  @override
  String get actionIrreversible => 'Esta acción es irreversible.';

  @override
  String get rootStartError => 'Error de inicio';

  @override
  String get playbackErrorNoZone =>
      'No hay zona seleccionada — cree o seleccione una zona';

  @override
  String get playbackErrorZoneNotFound => 'Zona no encontrada';

  @override
  String get playbackErrorFailed => 'Error de reproducción';

  @override
  String zoneLimitReached(int limit) {
    return 'Plan gratuito limitado a $limit zonas — cambia a Premium para tener zonas ilimitadas';
  }

  @override
  String zoneLimitOverCap(int current, int limit) {
    return 'Tus $current zonas siguen funcionando, pero el plan gratuito permite $limit — elimina una o cambia a Premium para añadir una nueva';
  }

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navSearch => 'Búsqueda';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navRadios => 'Radios';

  @override
  String get navZones => 'Zonas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String get tabAlbums => 'Álbumes';

  @override
  String get tabArtists => 'Artistas';

  @override
  String get tabTracks => 'Pistas';

  @override
  String albumTracksDuration(int count, String duration) {
    return '$count pistas · $duration';
  }

  @override
  String get tabGenres => 'Géneros';

  @override
  String get tabPlaylists => 'Listas';

  @override
  String get tabFavorites => 'Favoritos';

  @override
  String get favoriteAdded => 'Añadido a favoritos';

  @override
  String get favoriteRemoved => 'Quitado de favoritos';

  @override
  String get libraryEmptyFavorites => 'Sin favoritos';

  @override
  String get tabAppleMusic => 'Apple Music';

  @override
  String get libraryEmptyAlbums => 'No hay álbumes en la biblioteca';

  @override
  String get libraryEmptyArtists => 'No hay artistas en la biblioteca';

  @override
  String get libraryEmptyTracks => 'No hay pistas en la biblioteca';

  @override
  String get libraryEmptyGenres => 'No hay géneros';

  @override
  String get libraryEmptyPlaylists => 'No hay listas de reproducción';

  @override
  String get libraryNoFilterResults => 'Ningún álbum coincide con los filtros';

  @override
  String get libraryPlayAll => 'Reproducir todo';

  @override
  String get libraryAddTo => 'Añadir a…';

  @override
  String get libraryEditAlbum => 'Editar álbum';

  @override
  String get libraryEditTrack => 'Editar pista';

  @override
  String get libraryPlay => 'Reproducir';

  @override
  String get genresAllTracks => 'Todas las pistas';

  @override
  String get playlistCreate => 'Crear lista';

  @override
  String get playlistName => 'Nombre de la lista';

  @override
  String get playlistEmpty => 'Sin pistas';

  @override
  String get playlistAddTo => 'Añadir a lista';

  @override
  String get playlistNewPlaylist => 'Nueva lista';

  @override
  String playlistTrackAdded(String name) {
    return 'Añadido a «$name»';
  }

  @override
  String playlistTrackAlreadyIn(String name) {
    return 'Ya está en «$name»';
  }

  @override
  String playlistTracksAdded(int count, String name) {
    return '$count pistas añadidas a \"$name\"';
  }

  @override
  String get playlistAddAllTracks => 'Añadir todo a una lista';

  @override
  String get playlistDeleteTitle => '¿Eliminar lista?';

  @override
  String get playlistDeleteBody => 'Esta lista se eliminará permanentemente.';

  @override
  String get searchHint => 'Buscar…';

  @override
  String get searchNoResults => 'Sin resultados';

  @override
  String get searchTopResult => 'Mejor resultado';

  @override
  String get searchSectionTracks => 'Pistas';

  @override
  String get searchSectionAlbums => 'Álbumes';

  @override
  String get searchSectionArtists => 'Artistas';

  @override
  String get searchSectionStreaming => 'Streaming';

  @override
  String get homeRecentlyPlayed => 'Reproducido recientemente';

  @override
  String get homeLibrary => 'Biblioteca';

  @override
  String get homeQuickAccess => 'Acceso rápido';

  @override
  String get homeHistory => 'Historial';

  @override
  String get homeBrowseDlna => 'Explorar DLNA';

  @override
  String get homeStatTracks => 'pistas';

  @override
  String get homeStatAlbums => 'álbumes';

  @override
  String get homeStatArtists => 'artistas';

  @override
  String get historyTitle => 'Historial';

  @override
  String get historyEmpty => 'Sin historial';

  @override
  String get historyClear => 'Borrar';

  @override
  String get historyClearTitle => 'Borrar historial';

  @override
  String get nowPlayingNoTrack => 'Sin pista';

  @override
  String get queueTitle => 'Cola de reproducción';

  @override
  String queueUpNextSummary(int count, String time) {
    return '$count a continuación · $time';
  }

  @override
  String get queueEmpty => 'Cola vacía';

  @override
  String get queueClearTitle => 'Vaciar cola?';

  @override
  String get queueClearBody =>
      'Se eliminarán todas las pistas de la cola de reproducción.';

  @override
  String get zonesTitle => 'Zonas';

  @override
  String get zonesNew => 'Nueva zona';

  @override
  String get zonesNewName => 'Nombre de zona';

  @override
  String get zonesNone => 'Sin zonas';

  @override
  String get zonesRename => 'Renombrar zona';

  @override
  String get zonesDelete => 'Eliminar zona';

  @override
  String get zonesDevices => 'Dispositivos disponibles';

  @override
  String get zonesOutputLocal => 'Local';

  @override
  String get zonesOutputDlna => 'DLNA / UPnP';

  @override
  String get zonesOutputAirplay => 'AirPlay';

  @override
  String get zonesAirplayPair => 'Emparejar (código PIN)';

  @override
  String get zonesAirplayPairTitle => 'Emparejamiento AirPlay';

  @override
  String get zonesAirplayPairIntro =>
      'Algunos televisores (Samsung, LG) y el Apple TV muestran un código de 4 dígitos en la pantalla. Inicia el emparejamiento y luego introduce el código.';

  @override
  String get zonesAirplayPairWaiting =>
      'Esperando el código mostrado en el dispositivo…';

  @override
  String get zonesAirplayPairEnterCode =>
      'Introduce el código mostrado en el dispositivo:';

  @override
  String get zonesAirplayPairStart => 'Iniciar emparejamiento';

  @override
  String get zonesAirplayPairSubmit => 'Validar código';

  @override
  String get zonesAirplayPairRetry => 'Reintentar';

  @override
  String get zonesOutputBluetooth => 'Bluetooth';

  @override
  String get zonesChangeOutput => 'Cambiar salida';

  @override
  String get zonesOutputTitle => 'Salida de audio';

  @override
  String get zonesAssignDevice => 'Asignar';

  @override
  String get zonesTransferTitle => 'Reproducir en...';

  @override
  String get zonesNowPlaying => 'Sonando aquí';

  @override
  String zonesActivated(String name) {
    return 'Zona activa: $name';
  }

  @override
  String get radiosTitle => 'Radios';

  @override
  String get radiosTabAll => 'Todas';

  @override
  String get radiosTabFavorites => 'Favoritas';

  @override
  String get radiosNone => 'Sin radios';

  @override
  String get radiosFavNone => 'Sin radios favoritas';

  @override
  String get radiosSavedFavorites => 'Favoritos guardados';

  @override
  String get radiosAdd => 'Añadir una radio';

  @override
  String get radiosName => 'Nombre';

  @override
  String get radiosStreamUrl => 'URL del flujo';

  @override
  String get radiosGenre => 'Género (opcional)';

  @override
  String get radiosPasteM3u => 'Pegar M3U';

  @override
  String get radiosImportUrl => 'Importar desde URL';

  @override
  String get radiosImportUrlLabel => 'URL del archivo M3U';

  @override
  String radiosImportResult(int count) {
    return '$count estación(es) importada(s)';
  }

  @override
  String radiosImportHttpError(int code) {
    return 'Error HTTP $code';
  }

  @override
  String get radiosImportFailed => 'No se pudo descargar el archivo';

  @override
  String get radiosFavSaved => 'Pista guardada';

  @override
  String get radioSaveFavorite => 'Guardar pista';

  @override
  String get radioFavTitle => 'Favoritos de radio';

  @override
  String get radioFavEmpty => 'Sin favoritos guardados';

  @override
  String get radioFavExportCsv => 'Exportar CSV';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get streamingConnected => 'Conectado';

  @override
  String get streamingNotConnected => 'No conectado';

  @override
  String get streamingEmail => 'Correo';

  @override
  String get streamingPassword => 'Contraseña';

  @override
  String get streamingSignIn => 'Iniciar sesión';

  @override
  String get streamingSigningIn => 'Iniciando sesión…';

  @override
  String get streamingDeviceCode => 'Código de verificación';

  @override
  String get streamingOpenLink => 'Abrir…';

  @override
  String get streamingLogoutTitle => '¿Desconectar?';

  @override
  String streamingLogoutBody(String service) {
    return '¿Desconectar de $service?';
  }

  @override
  String get streamingAuthError => 'Error de autenticación';

  @override
  String get streamingAlbumsSection => 'Álbumes';

  @override
  String get streamingPlaylistsSection => 'Listas';

  @override
  String get browseTitle => 'Explorar';

  @override
  String get browseRefreshTooltip => 'Actualizar';

  @override
  String get browseNoServers => 'No se detectaron servidores UPnP/DLNA';

  @override
  String get browseNoServersHint =>
      'Asegúrese de que su servidor está en la misma red Wi-Fi.';

  @override
  String get browseNoContent => 'Carpeta vacía';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLangSystem => 'Sistema';

  @override
  String get settingsSectionZones => 'Zonas';

  @override
  String get settingsDefaultZone => 'Zona predeterminada';

  @override
  String get settingsDefaultZoneAuto => 'Automático';

  @override
  String get settingsNoZones => 'Sin zonas';

  @override
  String get settingsSectionServer => 'Servidor';

  @override
  String get settingsHttpPort => 'Puerto HTTP';

  @override
  String get settingsHttpPortDesc => 'Puerto del servidor principal';

  @override
  String get settingsLocalIp => 'Dirección IP local';

  @override
  String get settingsSectionLibrary => 'Biblioteca';

  @override
  String get settingsMetadata => 'Música y Metadatos';

  @override
  String get settingsMetadataDesc => 'Carpetas, escaneo, estadísticas';

  @override
  String get settingsSetupWizard => 'Asistente de configuración';

  @override
  String get settingsSetupWizardDesc => 'Reconfigurar fuentes de música';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsVersion => 'Versión 0.1.0';

  @override
  String get settingsResetConfig => 'Restablecer configuración';

  @override
  String get settingsResetTitle => '¿Restablecer?';

  @override
  String get settingsResetBody =>
      'Se restablecerán todas las preferencias. El asistente de inicio aparecerá en el próximo lanzamiento.';

  @override
  String get settingsPortTitle => 'Puerto HTTP';

  @override
  String get settingsPortHint => 'Puerto (1024–65535)';

  @override
  String get metadataTitle => 'Música y Metadatos';

  @override
  String get metadataRefreshStats => 'Actualizar estadísticas';

  @override
  String get metadataSectionStats => 'Estadísticas';

  @override
  String get metadataStatTracks => 'Pistas';

  @override
  String get metadataStatAlbums => 'Álbumes';

  @override
  String get metadataStatArtists => 'Artistas';

  @override
  String get metadataStatPlaylists => 'Listas';

  @override
  String get metadataStatRadios => 'Radios';

  @override
  String get metadataStatArtwork => 'Caché de carátulas';

  @override
  String get metadataSectionScan => 'Escaneo de biblioteca';

  @override
  String metadataScanInProgress(int current, int total) {
    return 'Escaneando… $current/$total';
  }

  @override
  String metadataScanResult(int added, int updated) {
    return 'Último escaneo: +$added añadidas, $updated actualizadas';
  }

  @override
  String get metadataScanBtn => 'Escanear biblioteca';

  @override
  String get metadataScanDesc => 'Indexa todas las carpetas configuradas';

  @override
  String get metadataSectionFolders => 'Carpetas de música';

  @override
  String get metadataFoldersNone => 'Sin carpetas configuradas';

  @override
  String metadataFolderAddedOn(String date) {
    return 'Añadido el $date';
  }

  @override
  String get metadataAddFolder => 'Añadir carpeta';

  @override
  String get metadataFolderPath => 'Ruta de la carpeta';

  @override
  String get metadataFolderHint => '/storage/emulated/0/Music';

  @override
  String get metadataSectionCleanup => 'Limpieza';

  @override
  String get metadataCleanupOrphans => 'Eliminar huérfanos';

  @override
  String get metadataCleanupOrphansDesc => 'Álbumes y artistas sin pistas';

  @override
  String get metadataClearLibrary => 'Vaciar biblioteca';

  @override
  String get metadataClearLibraryDesc => 'Elimina todas las pistas locales';

  @override
  String get metadataCleanupOrphansTitle => '¿Eliminar huérfanos?';

  @override
  String get metadataCleanupOrphansBody =>
      'Los álbumes y artistas sin pistas asociadas serán eliminados de la base de datos.';

  @override
  String get metadataClearLibraryTitle => '¿Vaciar biblioteca?';

  @override
  String get metadataClearLibraryBody =>
      'Todas las pistas, álbumes y artistas locales serán eliminados. Esta acción es irreversible.';

  @override
  String get metadataOrphansDeleted => 'Huérfanos eliminados';

  @override
  String get metadataLibraryCleared => 'Biblioteca vaciada';

  @override
  String get metadataDeleteBtn => 'Eliminar';

  @override
  String get metadataClearBtn => 'Vaciar';

  @override
  String get setupWelcomeTitle => 'Bienvenido a\nTune Server';

  @override
  String get setupWelcomeBody =>
      'Su servidor de música multiroom integrado. Transmita su biblioteca local, sus servicios de streaming favoritos y sus radios a cualquier altavoz DLNA o AirPlay.';

  @override
  String get setupStart => 'Comenzar';

  @override
  String get setupLocalTitle => 'Biblioteca local';

  @override
  String get setupLocalBody =>
      'Indique la ruta de una carpeta con sus archivos de audio (FLAC, MP3, AAC…). Puede añadir más en Ajustes.';

  @override
  String get setupFolderPath => 'Ruta de la carpeta';

  @override
  String get setupFolderHint => '/storage/emulated/0/Music';

  @override
  String get setupAddFolder => 'Añadir esta carpeta';

  @override
  String get setupFolderAdded => 'Carpeta añadida — escaneando…';

  @override
  String get setupFolderEmpty => 'Por favor, introduzca una ruta de carpeta';

  @override
  String get setupUPnPTitle => 'Servidores UPnP/DLNA';

  @override
  String get setupUPnPBody =>
      'Tune Server descubre automáticamente servidores UPnP/DLNA en su red local. Explore sus bibliotecas en Búsqueda → Explorar.';

  @override
  String get setupFeatureSsdp => 'Descubrimiento SSDP automático';

  @override
  String get setupFeatureContentDir => 'Navegación ContentDirectory';

  @override
  String get setupFeaturePlayback => 'Reproducción directa de archivos DLNA';

  @override
  String get setupFinish => 'Finalizar configuración';

  @override
  String get libraryPlayAlbum => 'Reproducir álbum';

  @override
  String get libraryPlayNext => 'Reproducir después';

  @override
  String radioFavExportDone(String path) {
    return 'CSV exportado: $path';
  }

  @override
  String get radioFavExportError => 'Error de exportación';

  @override
  String get streamingViewAlbum => 'Ver álbum';

  @override
  String get streamingLogoutContent => 'Tu cuenta será desconectada.';

  @override
  String get streamingUrlCopied => 'URL copiada al portapapeles';

  @override
  String get streamingDeviceCodeHint =>
      'Ve a esta URL e ingresa el código de arriba:';

  @override
  String get searchHintFull => 'Buscar artistas, álbumes, pistas…';

  @override
  String get browseNavError => 'Error de navegación';

  @override
  String get streamingCodeEntered => 'He introducido el código';

  @override
  String get appleMusicAuthorize => 'Permitir acceso';

  @override
  String get smbNavTitle => 'Fuente SMB';

  @override
  String get smbTitle => 'Conexión SMB';

  @override
  String get smbHostHint => 'Introduzca la dirección del servidor SMB';

  @override
  String get smbHostLabel => 'Dirección IP (ej: 192.168.1.23)';

  @override
  String get smbUser => 'Usuario';

  @override
  String get smbPassword => 'Contraseña';

  @override
  String get smbConnect => 'Conectar';

  @override
  String get smbSelectShare => 'Seleccionar recurso compartido';

  @override
  String get smbBack => 'Volver';

  @override
  String get smbManualHint =>
      'No se pudieron listar los recursos automáticamente.\nIntroduzca el nombre manualmente:';

  @override
  String get smbShareName => 'Nombre del recurso (ej: Share, Music)';

  @override
  String get smbScan => 'Escanear';

  @override
  String get smbScanning => 'Escaneando…';

  @override
  String smbScanCount(int count) {
    return '$count archivos de audio encontrados';
  }

  @override
  String get smbDoneTitle => 'Indexación completada';

  @override
  String smbDoneBody(int count, String share) {
    return '$count pistas importadas desde $share';
  }

  @override
  String get smbAddAnother => 'Añadir otro recurso';

  @override
  String get settingsSmb => 'Fuentes SMB / Samba';

  @override
  String get settingsSmbDesc => 'Indexar bibliotecas en recursos de red';

  @override
  String get podcastsTitle => 'Podcasts';

  @override
  String get podcastsTabRadioFrance => 'Radio France';

  @override
  String get podcastsTabSearch => 'Buscar';

  @override
  String get podcastsEmpty => 'Sin podcasts';

  @override
  String get podcastsSearchHint => 'Buscar un podcast…';

  @override
  String get podcastsNoEpisodes => 'Sin episodios';

  @override
  String get navPodcasts => 'Podcasts';

  @override
  String get streamingConnectedSuccess => '¡Conectado!';

  @override
  String browseItemCount(int count) {
    return '$count elementos';
  }

  @override
  String get settingsSources => 'Fuentes y dispositivos';

  @override
  String get settingsSourcesDesc => 'Servidores UPnP, reproductores DLNA';

  @override
  String get sourcesTitle => 'Fuentes y dispositivos';

  @override
  String get sourcesServersSection => 'Servidores de contenido UPnP';

  @override
  String get sourcesRenderersSection => 'Reproductores DLNA';

  @override
  String get sourcesNoDevices => 'Ningún dispositivo encontrado';

  @override
  String get sourcesTypeServer => 'Servidor';

  @override
  String get sourcesTypeRenderer => 'Reproductor';

  @override
  String get sourcesAvailable => 'Disponible';

  @override
  String get sourcesUnavailable => 'Sin conexión';

  @override
  String get sourcesIndexBtn => 'Indexar biblioteca';

  @override
  String get sourcesRescanBtn => 'Volver a escanear';

  @override
  String get sourcesForget => 'Olvidar';

  @override
  String get sourcesAddManually => 'Añadir manualmente';

  @override
  String get sourcesAddTitle => 'Escaneo manual';

  @override
  String get sourcesIpLabel => 'Dirección IP';

  @override
  String get sourcesIpHint => '192.168.1.100';

  @override
  String get sourcesPortLabel => 'Puerto';

  @override
  String get sourcesPortHint => '49152';

  @override
  String get sourcesProbing => 'Buscando…';

  @override
  String get sourcesNotFound =>
      'No se encontró ningún dispositivo UPnP en esta dirección';

  @override
  String get zonesMultiRoom => 'Multi-Room';

  @override
  String get zonesCreateGroup => 'Crear grupo';

  @override
  String get zonesGroupLeader => 'Líder';

  @override
  String get zonesGroupFollower => 'Seguidor';

  @override
  String get zonesGroupDissolve => 'Disolver grupo';

  @override
  String get zonesGroupSyncDelay => 'Retardo de sincronización';

  @override
  String zonesGroupSyncDelayMs(int ms) {
    return '$ms ms';
  }

  @override
  String get zonesGroupSelectZones => 'Seleccionar zonas';

  @override
  String get zonesGroupSelectLeader => 'Seleccionar líder';

  @override
  String get zonesGroupNoZones => 'Sin grupos activos';

  @override
  String get zonesGroupNeedTwo => 'Seleccione al menos 2 zonas';

  @override
  String get zonesGroupCreated => 'Grupo creado';

  @override
  String get zonesGroupDissolved => 'Grupo disuelto';

  @override
  String get metadataSectionEnrich => 'Enriquecer';

  @override
  String get metadataSectionDuplicates => 'Duplicados';

  @override
  String get metadataSectionCorrect => 'Corregir';

  @override
  String get metadataFilterAll => 'Todos';

  @override
  String get metadataFilterMissingCover => 'Sin portada';

  @override
  String get metadataFilterMissingGenre => 'Sin género';

  @override
  String get metadataFilterMissingYear => 'Sin año';

  @override
  String get metadataFilterMissingArtist => 'Sin artista';

  @override
  String get metadataFilterDoubtful => 'Dudosos';

  @override
  String get metadataSearchHint => 'Buscar álbumes…';

  @override
  String get metadataArtistFilter => 'Artista';

  @override
  String get metadataGenreFilter => 'Género';

  @override
  String get metadataAllArtists => 'Todos los artistas';

  @override
  String get metadataAllGenres => 'Todos los géneros';

  @override
  String get metadataNoAlbums => 'Ningún álbum coincide';

  @override
  String get metadataEditAlbum => 'Editar álbum';

  @override
  String get metadataSaveChanges => 'Guardar';

  @override
  String get metadataWriteTags => 'Escribir tags';

  @override
  String metadataWriteTagsSuccess(int count) {
    return 'Tags escritos: $count archivos';
  }

  @override
  String get metadataMergeGroup => 'Fusionar';

  @override
  String metadataMergeConfirm(int count) {
    return '¿Fusionar estos $count álbumes? Se conservará el que tenga más pistas.';
  }

  @override
  String metadataMergeSuccess(int moved, int total) {
    return 'Fusionado: $moved pistas movidas, $total en total';
  }

  @override
  String get metadataUploadCover => 'Subir portada';

  @override
  String get metadataCoverUploaded => 'Portada subida';

  @override
  String get metadataAlbumSaved => 'Álbum guardado';

  @override
  String metadataDupAlbums(int count) {
    return '$count álbumes duplicados';
  }

  @override
  String get metadataDoubtfulReasons => 'Problemas';

  @override
  String get metadataArtistField => 'Artista';

  @override
  String get metadataAlbumField => 'Álbum';

  @override
  String get metadataGenreField => 'Género';

  @override
  String get metadataYearField => 'Año';

  @override
  String metadataTracksCount(int count) {
    return '$count pistas';
  }

  @override
  String get stereoPairsTitle => 'Pares estéreo';

  @override
  String get stereoPairCreate => 'Crear par estéreo';

  @override
  String get stereoPairName => 'Nombre del par';

  @override
  String get stereoPairNameHint => 'Ej: Salón Estéreo';

  @override
  String get stereoPairLeft => 'Izquierda (L)';

  @override
  String get stereoPairRight => 'Derecha (R)';

  @override
  String get stereoPairSelectDevice => 'Seleccionar dispositivo';

  @override
  String get stereoPairNone => 'Sin pares estéreo';

  @override
  String get stereoPairCreated => 'Par estéreo creado';

  @override
  String get stereoPairDissolved => 'Par estéreo disuelto';

  @override
  String get stereoPairDissolve => 'Disolver';

  @override
  String get stereoPairBadgeL => 'L';

  @override
  String get stereoPairBadgeR => 'R';

  @override
  String get streamingEnable => 'Activar';

  @override
  String get streamingDisable => 'Desactivar';

  @override
  String get streamingEnabled => 'Servicio activado';

  @override
  String get streamingDisabled => 'Servicio desactivado';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenido a Tune!';

  @override
  String get onboardingWelcomeBody =>
      'Tu servidor de música multiroom integrado. Configuremos tu instalación en unos pocos pasos.';

  @override
  String get onboardingWelcomeStart => 'Comenzar';

  @override
  String get onboardingConfigTitle => 'Configuración';

  @override
  String get onboardingConfigBody =>
      'Especifica una carpeta con tus archivos de audio o conéctate a un servidor Tune remoto.';

  @override
  String get onboardingConfigModeLocal => 'Servidor integrado';

  @override
  String get onboardingConfigModeRemote => 'Servidor remoto';

  @override
  String get onboardingZoneTitle => 'Crear una zona';

  @override
  String get onboardingZoneBody =>
      'Los dispositivos a continuación fueron descubiertos en tu red. Toca uno para crear tu primera zona de audio.';

  @override
  String get onboardingZoneEmpty =>
      'Aún no se han descubierto dispositivos. Puedes agregar más después.';

  @override
  String onboardingZoneCreated(String name) {
    return 'Zona creada: $name';
  }

  @override
  String get onboardingDoneTitle => '¡Listo!';

  @override
  String get onboardingDoneBody =>
      'Tu configuración está lista. ¡Disfruta tu música!';

  @override
  String get onboardingDoneButton => 'Ir al panel';

  @override
  String get artistBio => 'Biografía';

  @override
  String get artistAnecdotes => 'Anécdotas';

  @override
  String get artistSimilarArtists => 'Artistas similares';

  @override
  String get artistMembers => 'Miembros';

  @override
  String get artistDiscography => 'Discografía';

  @override
  String get artistEnriching => 'Enriquecimiento en curso…';

  @override
  String get artistGenres => 'Géneros';

  @override
  String get libraryShuffleAll => 'Reproducir todo aleatoriamente';

  @override
  String get librarySortBy => 'Ordenar por';

  @override
  String get librarySortTitle => 'Título';

  @override
  String get librarySortArtist => 'Artista';

  @override
  String get librarySortYear => 'Año';

  @override
  String get librarySortOriginalYear => 'Año original';

  @override
  String get librarySortAddedDate => 'Fecha de adición';

  @override
  String get librarySortAscending => 'Ascendente';

  @override
  String get librarySortDescending => 'Descendente';

  @override
  String get addFavorite => 'Añadir a favoritos';

  @override
  String get addFolder => 'Añadir una carpeta';

  @override
  String get addThisFolder => 'Añadir esta carpeta';

  @override
  String get addToPlaylist => 'Añadir a una lista';

  @override
  String get addedToPlaylist => 'Añadido a la lista';

  @override
  String get audioOutput => 'Salida de audio';

  @override
  String get audioOutputDesc =>
      'Cada zona del servidor es una salida (ALSA local, renderer Diretta…). Elige la zona donde reproducir.';

  @override
  String get authorizeInBrowser => 'Autoriza el acceso en tu navegador:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get connect => 'Conectar';

  @override
  String get connected => 'Conectado';

  @override
  String get cover => 'Carátula';

  @override
  String get create => 'Crear';

  @override
  String get createPlaylist => 'Crear una lista';

  @override
  String get delete => 'Eliminar';

  @override
  String get deletePlaylist => 'Eliminar lista';

  @override
  String get deletePlaylistConfirm => '¿Eliminar esta lista?';

  @override
  String get disabled => 'Desactivado';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get done => 'He terminado';

  @override
  String get dynamicPlaylists => 'Listas dinámicas';

  @override
  String get dynamicTag => 'Dinámica';

  @override
  String errorWith(String msg) {
    return 'Error: $msg';
  }

  @override
  String favError(String msg) {
    return 'Error de favorito: $msg';
  }

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get filterAll => 'Todo';

  @override
  String get freqLimit => 'Límite de frecuencia';

  @override
  String get gapless => 'Reproducción sin pausas';

  @override
  String get gaplessDesc =>
      'Desactiva si oyes ruido blanco / cortes entre pistas en este renderer.';

  @override
  String get host => 'Host';

  @override
  String get language => 'Idioma';

  @override
  String get loading => 'Cargando…';

  @override
  String get localLibrary => 'Biblioteca local';

  @override
  String get localLibraryDesc => 'Carpetas donde el servidor busca música';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String loginTo(String service) {
    return 'Iniciar sesión en $service';
  }

  @override
  String get maxBitDepth => 'Profundidad máx.';

  @override
  String get maxFrequency => 'Frecuencia máx.';

  @override
  String maxTracks(int n) {
    return 'máx. $n';
  }

  @override
  String get metadataFields => 'Campos de metadatos';

  @override
  String get metadataFieldsDesc =>
      'Información mostrada para la biblioteca local';

  @override
  String get metadataSaved => 'Metadatos guardados';

  @override
  String get musicFolders => 'Carpetas escaneadas';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get navPlaylists => 'Listas';

  @override
  String get newPlaylist => 'Nueva lista';

  @override
  String get noFavAlbums => 'Sin álbumes favoritos';

  @override
  String get noFavArtists => 'Sin artistas favoritos';

  @override
  String get noFavTracks => 'Sin pistas favoritas';

  @override
  String get noFolders => 'Ninguna carpeta configurada';

  @override
  String get noLimit => 'Sin límite';

  @override
  String get noPlaylists => 'Ninguna lista';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get noService => 'Ningún servicio';

  @override
  String get noTracks => 'Sin pistas';

  @override
  String get noZones => 'Ninguna zona disponible';

  @override
  String get notConnected => 'Configura el servidor en Ajustes';

  @override
  String get nothingPlaying => 'Nada en reproducción';

  @override
  String get openAuthPage => 'Abrir la página de autorización';

  @override
  String get password => 'Contraseña';

  @override
  String get pickFolder => 'Elegir una carpeta';

  @override
  String get playAll => 'Reproducir todo';

  @override
  String get playlistCreated => 'Lista creada';

  @override
  String get playlistDeleted => 'Lista eliminada';

  @override
  String get playlistsTitle => 'Listas';

  @override
  String get port => 'Puerto';

  @override
  String get qualityCd => 'CD (44.1 kHz / 16 bits)';

  @override
  String get qualityHires => 'Hi-Res (hasta 192 kHz)';

  @override
  String get qualityMax => 'Máxima';

  @override
  String get removeFavorite => 'Quitar de favoritos';

  @override
  String get removeFromPlaylist => 'Quitar de la lista';

  @override
  String get runScan => 'Escanear biblioteca';

  @override
  String get scanning => 'Escaneando…';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · tu biblioteca';

  @override
  String get searchEmptyTitle => 'Busca un título, un álbum o un artista';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get sectionAlbums => 'Álbumes';

  @override
  String get sectionArtists => 'Artistas';

  @override
  String get sectionPlaylists => 'Listas';

  @override
  String get sectionTracks => 'Pistas';

  @override
  String get server => 'Servidor';

  @override
  String get sourceLibrary => 'Biblioteca';

  @override
  String get streamingQuality => 'Calidad de streaming';

  @override
  String get streamingQualityDesc =>
      'Limita la frecuencia / resolución solicitada a los servicios (Qobuz, Tidal…).';

  @override
  String get streamingServices => 'Servicios de streaming';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get trackRemoved => 'Quitado de la lista';

  @override
  String tracksCount(int n) {
    return '$n pistas';
  }

  @override
  String get username => 'Usuario';

  @override
  String get visualizer => 'Visualizador';

  @override
  String get licenseSessionConflictTitle => 'Licencia activa en otro servidor';

  @override
  String get licenseSessionConflictBody =>
      'Tu licencia de Tune ya se está usando en otro de tus servidores. Este servidor volverá a Premium automáticamente unos minutos después de que el otro se detenga.';

  @override
  String licenseSessionConflictBodyNamed(String server) {
    return 'Tu licencia de Tune está activa en «$server». Este servidor volverá a Premium automáticamente unos minutos después de que el otro se detenga.';
  }

  @override
  String cfgSaveError(String detail) {
    return 'Error al guardar: $detail';
  }

  @override
  String get cfgReload => 'Recargar';

  @override
  String get cfgFieldsLoadError => 'No se pudieron cargar los campos';

  @override
  String get cfgFieldsNone => 'No hay campos disponibles';

  @override
  String get cfgFieldsHint =>
      'Elige qué campos de metadatos se muestran en el editor de pistas.';

  @override
  String get cfgMetaCompleteness => 'Completitud de metadatos';

  @override
  String get cfgMetaEnrichMusicBrainz => 'Enriquecer con MusicBrainz';

  @override
  String get cfgMetaEnrichMusicBrainzTask => 'Enriquecimiento MusicBrainz';

  @override
  String get cfgMetaFixYearsTidal => 'Corregir años (TIDAL)';

  @override
  String get cfgMetaFixYearsDiscogs => 'Corregir años (Discogs)';

  @override
  String get cfgMetaFixGenres => 'Corregir géneros';

  @override
  String get cfgMetaAutoFixAlbums => 'Corregir álbumes automáticamente';

  @override
  String cfgMetaSuggestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sugerencias pendientes',
      one: '1 sugerencia pendiente',
      zero: 'No hay sugerencias pendientes',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaAcceptAll => 'Aceptar todo';

  @override
  String get cfgMetaSuggestions => 'Sugerencias';

  @override
  String get cfgMetaScanDuplicates => 'Buscar duplicados';

  @override
  String get cfgMetaAutoMerge => 'Fusión automática';

  @override
  String get cfgMetaMergeDuplicatesTask => 'Fusión de duplicados';

  @override
  String cfgMetaDuplicatesSummary(int count, int groups) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$count álbumes duplicados ($groups grupos)',
      one: '$count álbumes duplicados (1 grupo)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreGroups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… y $count grupos más',
      one: '… y 1 grupo más',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaLastResult => 'Último resultado';

  @override
  String cfgMetaPercentComplete(String pct) {
    return '$pct % completo';
  }

  @override
  String cfgMetaActionError(String label, String detail) {
    return '$label: error — $detail';
  }

  @override
  String cfgMetaResultAccepted(String label, String count) {
    return '$label: $count aceptadas';
  }

  @override
  String cfgMetaResultFixedOfTotal(String label, String fixed, String total) {
    return '$label: $fixed/$total corregidos';
  }

  @override
  String cfgMetaResultFixed(String label, String fixed) {
    return '$label: $fixed corregidos';
  }

  @override
  String cfgMetaResultProcessed(String label, String total) {
    return '$label: $total procesados';
  }

  @override
  String cfgMetaResultDone(String label) {
    return '$label: completado';
  }

  @override
  String cfgMetaWriteTagsError(String detail) {
    return 'Error al escribir las etiquetas: $detail';
  }

  @override
  String cfgMetaUploadError(String detail) {
    return 'Error al subir: $detail';
  }

  @override
  String cfgMetaMergeTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Fusionar $count álbumes?',
      one: '¿Fusionar 1 álbum?',
    );
    return '$_temp0';
  }

  @override
  String get cfgMetaMergeBody =>
      'Se conservará el álbum con más pistas; los demás se eliminarán.';

  @override
  String cfgMetaMergeError(String detail) {
    return 'Error al fusionar: $detail';
  }

  @override
  String get cfgMetaStatsUnavailable => 'Estadísticas no disponibles';

  @override
  String cfgMetaAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count álbumes',
      one: '1 álbum',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaMoreAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '… y $count álbumes más (filtra para acotar)',
      one: '… y 1 álbum más (filtra para acotar)',
    );
    return '$_temp0';
  }

  @override
  String cfgMetaTrackCountText(String count) {
    return '$count pistas';
  }

  @override
  String get cfgMetaReasonArtistUppercase => 'Artista en mayúsculas';

  @override
  String get cfgMetaReasonArtistPlaceholder => 'Artista provisional';

  @override
  String get cfgMetaReasonArtistHasYear => 'Artista = carpeta';

  @override
  String get cfgMetaReasonGenrePlaceholder => 'Género provisional';

  @override
  String get cfgMetaReasonYearSuspicious => 'Año sospechoso';

  @override
  String get cfgMetaReasonTitleUppercase => 'Título en mayúsculas';

  @override
  String get cfgMetaReasonArtistMismatch => 'Artista distinto';

  @override
  String get cfgSmbNotConnected => 'No conectado a un servidor remoto';

  @override
  String cfgSmbMountTitle(String name) {
    return 'Montar $name';
  }

  @override
  String get cfgSmbMount => 'Montar';

  @override
  String cfgSmbMountSuccess(String name) {
    return '$name montado';
  }

  @override
  String get cfgSmbTitle => 'Recursos compartidos de red (SMB)';

  @override
  String get cfgSmbSearching => 'Buscando recursos SMB…';

  @override
  String get cfgSmbNone => 'No se encontraron recursos SMB';

  @override
  String get cfgSmbSaveCredentials => 'Guardar credenciales';

  @override
  String get cfgUnknown => 'Desconocido';

  @override
  String get cfgEqTitle => 'Ecualizador';

  @override
  String get cfgEqTabAssistant => 'Asistente';

  @override
  String get cfgEqTabExpert => 'Experto';

  @override
  String cfgEqError(String detail) {
    return 'Error del ecualizador: $detail';
  }

  @override
  String get cfgEqPresetFlat => 'Plano';

  @override
  String get cfgEqPresetBassBoost => 'Refuerzo de graves';

  @override
  String get cfgEqPresetClassical => 'Clásica';

  @override
  String get cfgEqPresetVocal => 'Voz';

  @override
  String get cfgNotConnectedToServer => 'No conectado al servidor';

  @override
  String get cfgCredentialsRequired => 'Se requieren usuario y contraseña';

  @override
  String cfgServiceConnected(String service) {
    return '$service conectado.';
  }

  @override
  String cfgServiceDisconnected(String service) {
    return '$service desconectado.';
  }

  @override
  String get cfgLastfmTitle => 'Scrobbling de Last.fm';

  @override
  String get cfgLastfmDesc =>
      'Envía tu historial de escucha a Last.fm. Las pistas se registran automáticamente al reproducirse en cualquier zona.';

  @override
  String get cfgDisconnecting => 'Desconectando…';

  @override
  String get cfgConnectHeader => 'CONECTAR';

  @override
  String get cfgConnecting => 'Conectando…';

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
    return 'Último: $date';
  }

  @override
  String get cfgTokenRequired => 'Introduce tu token de usuario';

  @override
  String get cfgScrobblerUnavailable => 'Scrobbler no disponible';

  @override
  String cfgConnectedAs(String name) {
    return 'Conectado como $name';
  }

  @override
  String get cfgListenbrainzDesc =>
      'Envía tu historial de escucha a ListenBrainz. Consigue tu token de usuario en listenbrainz.org/settings.';

  @override
  String get cfgUserToken => 'Token de usuario';

  @override
  String get cfgValidating => 'Validando…';

  @override
  String get cfgSaveAndConnect => 'Guardar y conectar';

  @override
  String get cfgScrobbleAuto => 'Las pistas se registrarán automáticamente';

  @override
  String cfgConfigExported(String path) {
    return 'Configuración exportada: $path';
  }

  @override
  String get cfgConfigImported => 'Configuración importada correctamente';

  @override
  String cfgImportError(String detail) {
    return 'Error al importar: $detail';
  }

  @override
  String get cfgConfigExportDesc =>
      'Guarda la configuración del servidor en un archivo JSON.';

  @override
  String get cfgConfigExportJson => 'Exportar JSON';

  @override
  String get cfgConfigImportDesc =>
      'Restaura una configuración desde un archivo JSON.';

  @override
  String get cfgChooseFile => 'Elegir un archivo';

  @override
  String get cfgDbNoServer => 'No hay ningún servidor conectado.';

  @override
  String cfgDbExportOk(String size, String path) {
    return 'Exportación correcta: $size MB\n$path';
  }

  @override
  String get cfgDbPathUnavailable => 'La ruta del archivo no es accesible.';

  @override
  String get cfgDbImportConfirmTitle => 'Confirmar importación';

  @override
  String cfgDbImportConfirmBody(String name) {
    return '¿Reemplazar la base de datos del servidor por «$name»?\n\nSe creará automáticamente una copia de seguridad. Habrá que reiniciar el servidor después de la importación.';
  }

  @override
  String cfgDbImportOk(String size, String engine) {
    return 'Importación correcta: $size MB ($engine).\nReinicia el servidor para aplicar los cambios.';
  }

  @override
  String get cfgDbTitle => 'Base de datos';

  @override
  String get cfgDbIntro =>
      'Exporta o importa la base de datos del servidor conectado.\nSQLite: archivo .db. PostgreSQL: volcado SQL.';

  @override
  String get cfgDbExporting => 'Exportando…';

  @override
  String get cfgDbExportBtn => 'Exportar la base de datos';

  @override
  String get cfgDbImporting => 'Importando…';

  @override
  String get cfgDbImportBtn => 'Importar un archivo';

  @override
  String get cfgDbFooter =>
      'Tras una importación, reinicia el servidor para aplicar los cambios. Antes del reemplazo se crea automáticamente una copia de seguridad.';

  @override
  String cfgStatusUnavailable(String detail) {
    return 'Estado no disponible: $detail';
  }

  @override
  String get cfgSpotifyIntro =>
      'Tune aparece como receptor Spotify Connect en la red local. En la app de Spotify, selecciona «Tune (…)» en la lista de dispositivos. Se requiere una cuenta Spotify Premium en el cliente.';

  @override
  String get cfgSpotifyNoLibrespot => 'librespot no detectado en el servidor';

  @override
  String get cfgSpotifyNoLibrespotHint =>
      'Reinstala Tune Server desde el tarball/zip oficial para que se incluya el binario, o instálalo por separado (apt install librespot / brew install librespot).';

  @override
  String get cfgTargetZone => 'Zona de destino';

  @override
  String get cfgDeviceName => 'Nombre del dispositivo';

  @override
  String get cfgPlaying => 'Reproduciendo';

  @override
  String get cfgNetDiagTitle => 'Diagnóstico de red';

  @override
  String get cfgNetSsdpActive => 'SSDP activo';

  @override
  String get cfgNetMulticastReachable => 'Multicast accesible';

  @override
  String get cfgError => 'Error';

  @override
  String get cfgNetResolution => 'Resolución';

  @override
  String get cfgNetLatency => 'Latencia';

  @override
  String get cfgNetPublicIp => 'IP pública';

  @override
  String get cfgNetInterfaces => 'INTERFACES DE RED';

  @override
  String get cfgStatusWarning => 'Advertencia';

  @override
  String libAlbumsFilteredCount(int shown, int total) {
    return '$shown / $total álbumes';
  }

  @override
  String get libNoCollectionsYet => 'Aún no hay colecciones';

  @override
  String libRatingError(String error) {
    return 'Error al valorar: $error';
  }

  @override
  String libDisc(int disc) {
    return 'Disco $disc';
  }

  @override
  String libDiscWithSubtitle(int disc, String subtitle) {
    return 'Disco $disc — $subtitle';
  }

  @override
  String get libQuickFavorite => 'Favorito rápido';

  @override
  String get libAddToCollection => 'Añadir a una colección';

  @override
  String get libAlbumNotes => 'Notas del álbum';

  @override
  String get libCredits => 'Créditos';

  @override
  String get libNoCredits => 'Sin créditos';

  @override
  String get libNoAlbumNotes => 'No hay notas para este álbum';

  @override
  String get libNoNotes => 'No hay notas disponibles';

  @override
  String get libSourceCommunity => 'Comunidad Tune';

  @override
  String libBioSource(String source) {
    return 'Fuente: $source';
  }

  @override
  String libBioSourceWithLicense(String source, String license) {
    return 'Fuente: $source · $license';
  }

  @override
  String get libAppleMusicAccessDenied =>
      'Acceso a la biblioteca de Apple Music denegado.';

  @override
  String get libAppleMusicPermissionRefused =>
      'Permiso denegado. Active el acceso en Ajustes > Privacidad > Multimedia y Apple Music.';

  @override
  String get libUnknownError => 'Error desconocido';

  @override
  String get libAppleMusicAccessTitle => 'Acceso a Apple Music';

  @override
  String get libAppleMusicAccessBody =>
      'Permita el acceso a su biblioteca musical para reproducir sus pistas de Apple Music.';

  @override
  String get libAppleMusicEmpty => 'La biblioteca de Apple Music está vacía';

  @override
  String get libReportImageTitle => 'Reportar imagen';

  @override
  String get libReportImageBody =>
      '¿Reportar esta imagen del artista como incorrecta? El servidor la reemplazará en el próximo enriquecimiento.';

  @override
  String get libReportAction => 'Reportar';

  @override
  String get libImageReported => 'Imagen reportada';

  @override
  String libServiceAlbums(String service) {
    return 'Álbumes de $service';
  }

  @override
  String libTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas',
      one: '1 pista',
    );
    return '$_temp0';
  }

  @override
  String get libDuplicateScanner => 'Buscador de duplicados';

  @override
  String libDuplicateGroupsFound(int groups, int tracks) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$groups grupos de duplicados encontrados',
      one: '1 grupo de duplicados encontrado',
    );
    return '$_temp0 ($tracks pistas en total)';
  }

  @override
  String get libFindDuplicatesTitle => 'Buscar pistas duplicadas';

  @override
  String get libFindDuplicatesBody =>
      'Analiza los hashes del contenido de audio para encontrar pistas idénticas en su biblioteca.';

  @override
  String get libStartScan => 'Iniciar análisis';

  @override
  String libScanProgress(int processed, int total, int percent) {
    return '$processed / $total pistas ($percent %)';
  }

  @override
  String get libLoadingTracks => 'Cargando pistas…';

  @override
  String get libNoDuplicatesFound => 'No se encontraron duplicados';

  @override
  String get libLibraryClean => 'Su biblioteca está limpia.';

  @override
  String get libScanAgain => 'Analizar de nuevo';

  @override
  String get libScanFailed => 'Error en el análisis';

  @override
  String get libTrackNumberField => 'Pista n.º';

  @override
  String get libDiscNumberField => 'Disco n.º';

  @override
  String get libExtendedMetadata => 'Metadatos ampliados';

  @override
  String get libGenreTreeSaved => 'Árbol de géneros guardado';

  @override
  String libSaveError(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get libGenreTree => 'Árbol de géneros';

  @override
  String get libAddRootGenre => 'Añadir género raíz';

  @override
  String get libGenreTreeRequiresRemote =>
      'El árbol de géneros requiere conexión con un servidor remoto.';

  @override
  String get libNoGenreHierarchy => 'No hay jerarquía de géneros definida';

  @override
  String libAddSubGenreTo(String parent) {
    return 'Añadir subgénero a «$parent»';
  }

  @override
  String get libGenreName => 'Nombre del género';

  @override
  String libSubGenreCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subgéneros',
      one: '1 subgénero',
    );
    return '$_temp0';
  }

  @override
  String get libAddSubGenre => 'Añadir subgénero';

  @override
  String get libRemove => 'Quitar';

  @override
  String libRemoveNamedConfirm(String name) {
    return '¿Quitar «$name»?';
  }

  @override
  String libRemoveGenreWithChildren(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'También se quitarán sus $count subgéneros.',
      one: 'También se quitará su subgénero.',
    );
    return '$_temp0';
  }

  @override
  String get libRemoveGenreBody => 'Este género se quitará del árbol.';

  @override
  String libAlbumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count álbumes',
      one: '1 álbum',
    );
    return '$_temp0';
  }

  @override
  String get libNoTracksForFilter => 'Ninguna pista coincide con este filtro';

  @override
  String get libQualityLossless => 'Sin pérdida';

  @override
  String get libQualityLossy => 'Con pérdida';

  @override
  String libTracksFilteredCount(int shown, int total) {
    return '$shown / $total pistas';
  }

  @override
  String get libNewCollection => 'Nueva colección';

  @override
  String get libCollectionName => 'Nombre de la colección';

  @override
  String libCreateError(String error) {
    return 'Error al crear: $error';
  }

  @override
  String libDeleteError(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get libCollectionsTitle => 'Colecciones';

  @override
  String get libCollectionsLoadFailed =>
      'No se pudieron cargar las colecciones';

  @override
  String get libDeleteCollectionTitle => '¿Eliminar la colección?';

  @override
  String libDeleteCollectionBody(String name) {
    return '«$name» se eliminará de forma permanente.';
  }

  @override
  String get libNoAlbumsInCollection => 'No hay álbumes en esta colección';

  @override
  String get libDeleteConfirmTitle => '¿Eliminar?';

  @override
  String get libDeleteSmartCollectionBody =>
      'Esta colección inteligente se eliminará de forma permanente.';

  @override
  String get libNoRules => 'sin reglas';

  @override
  String libRuleCreditSummary(String role, String artist) {
    return 'crédito: $role=$artist';
  }

  @override
  String get libAnd => 'Y';

  @override
  String get libOr => 'O';

  @override
  String get libSmartCollections => 'Colecciones inteligentes';

  @override
  String get libNewSmartCollection => 'Nueva colección inteligente';

  @override
  String get libNoSmartCollections => 'No hay colecciones inteligentes';

  @override
  String get libSmartCollectionsSeedHint =>
      'El servidor suele crear 7 colecciones predeterminadas en el primer inicio.';

  @override
  String get libCreateFirstSmartCollection =>
      'Crear mi primera colección inteligente';

  @override
  String get libNoMatchingAlbums => 'Ningún álbum coincide';

  @override
  String get libSmartCreditsHint =>
      'Para reglas basadas en créditos (engineer, performer, …), enriquezca primero la biblioteca desde Ajustes.';

  @override
  String get libFieldSampleRate => 'Frecuencia de muestreo';

  @override
  String get libFieldBitDepth => 'Profundidad de bits';

  @override
  String get libFieldTrackCount => 'N.º de pistas';

  @override
  String get libFieldFormat => 'Formato';

  @override
  String get libFieldLabel => 'Sello';

  @override
  String get libFieldAlbumTitle => 'Título del álbum';

  @override
  String get libFieldSource => 'Fuente';

  @override
  String get libFieldCredit => 'Crédito';

  @override
  String get libFieldPlayCount => 'N.º de reproducciones';

  @override
  String get libFieldLastPlayed => 'Última reproducción';

  @override
  String get libOpBetween => 'entre';

  @override
  String get libOpContains => 'contiene';

  @override
  String get libOpStartsWith => 'empieza por';

  @override
  String get libOpEmpty => 'vacío';

  @override
  String get libOpNotEmpty => 'no vacío';

  @override
  String get libOpNever => 'nunca';

  @override
  String get libOpAfter => 'después de';

  @override
  String get libOpBefore => 'antes de';

  @override
  String get libNameLabel => 'Nombre';

  @override
  String get libMatchMode => 'Combinación';

  @override
  String get libMatchAll => 'Todas las reglas (Y)';

  @override
  String get libMatchAny => 'Al menos una (O)';

  @override
  String get libAddRule => 'Añadir una regla';

  @override
  String get libMatchingAlbumsPending => '… álbumes coincidentes';

  @override
  String libMatchingAlbums(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count álbumes coincidentes',
      one: '1 álbum coincidente',
    );
    return '$_temp0';
  }

  @override
  String get libTimestampHint => 'now-30d o 2024-01-01';

  @override
  String get libValueHint => 'valor';

  @override
  String get libMinHint => 'mín';

  @override
  String get libMaxHint => 'máx';

  @override
  String get libCommaSeparatedHint => 'valores separados por comas';

  @override
  String get libCreditRoleHint => 'rol (engineer, performer, …)';

  @override
  String get libCreditArtistHint => 'artista (Rudy Van Gelder, …)';

  @override
  String get libCreditInstrumentHint => 'instrumento (Piano, …) — opcional';

  @override
  String get libDirectories => 'Directorios';

  @override
  String get libLoadError => 'Error de carga';

  @override
  String get libNoFolders => 'No hay carpetas';

  @override
  String get libAddFoldersInSettings => 'Añada carpetas de música en Ajustes';

  @override
  String get libFoldersHeader => 'Carpetas';

  @override
  String libTracksHeaderCount(int count) {
    return 'Pistas ($count)';
  }

  @override
  String get libPlayFromHere => 'Reproducir desde aquí';

  @override
  String get libTags => 'Etiquetas';

  @override
  String get libNewTagHint => 'Nueva etiqueta…';

  @override
  String get libJustNow => 'Ahora mismo';

  @override
  String libMinutesAgo(int count) {
    return 'Hace $count min';
  }

  @override
  String libHoursAgo(int count) {
    return 'Hace $count h';
  }

  @override
  String get libYesterday => 'Ayer';

  @override
  String libDaysAgo(int count) {
    return 'Hace $count d';
  }

  @override
  String get libNowListening => 'Escuchando ahora';

  @override
  String get libContinueListening => 'Seguir escuchando';

  @override
  String get libRecentlyAdded => 'Añadido recientemente';

  @override
  String get libTopTracks => 'Pistas más escuchadas';

  @override
  String get libTopArtists => 'Artistas más escuchados';

  @override
  String get libRecommendations => 'Recomendaciones';

  @override
  String get libSourceLocal => 'Local';

  @override
  String get libFieldDuration => 'Duración';

  @override
  String get libFilter => 'Filtrar';

  @override
  String get libRefreshAll => 'Actualizar todo';

  @override
  String get libPodcastsSubscribed => 'Suscripciones';

  @override
  String get libNoSubscriptions => 'Aún no hay suscripciones';

  @override
  String get libSubscribeRssFeed => 'Suscribirse a un feed RSS';

  @override
  String get libUnknown => 'Desconocido';

  @override
  String get libUnsubscribeTitle => '¿Cancelar la suscripción?';

  @override
  String libUnsubscribeBody(String name) {
    return '¿Cancelar la suscripción a «$name»?';
  }

  @override
  String get libUnsubscribe => 'Cancelar suscripción';

  @override
  String libEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodios',
      one: '1 episodio',
    );
    return '$_temp0';
  }

  @override
  String get libSubscribeToPodcast => 'Suscribirse a un pódcast';

  @override
  String get libRssFeedUrl => 'URL del feed RSS';

  @override
  String get libSubscribe => 'Suscribirse';

  @override
  String get libSubscribed => 'Suscripción realizada.';

  @override
  String libSubscribeError(String error) {
    return 'Error al suscribirse: $error';
  }

  @override
  String libUnsubscribeError(String error) {
    return 'Error al cancelar la suscripción: $error';
  }

  @override
  String get libPodcastRefreshed => 'Pódcast actualizado.';

  @override
  String libRefreshError(String error) {
    return 'Error al actualizar: $error';
  }

  @override
  String get libAllPodcastsRefreshed => 'Todos los pódcasts actualizados.';

  @override
  String get libToday => 'Hoy';

  @override
  String get miscNavFolders => 'Carpetas';

  @override
  String get miscNavCollections => 'Colecciones';

  @override
  String get miscNavSmartCollections => 'Colecciones inteligentes';

  @override
  String get miscNavDjMode => 'Modo DJ';

  @override
  String get miscNavPartyMode => 'Modo fiesta';

  @override
  String get miscNavDj => 'DJ';

  @override
  String get miscNavParty => 'Fiesta';

  @override
  String get miscNavSmartPlaylists => 'Listas inteligentes';

  @override
  String get miscNavAlarms => 'Alarmas';

  @override
  String get miscNavGenreTree => 'Árbol de géneros';

  @override
  String get miscNavDashboard => 'Panel';

  @override
  String get miscNavDiagnostics => 'Diagnóstico';

  @override
  String get miscNavAdmin => 'Administración';

  @override
  String get miscNavMore => 'Más';

  @override
  String get miscNextTrack => 'Pista siguiente';

  @override
  String get miscPreviousTrack => 'Pista anterior';

  @override
  String get miscUnknownError => 'Error desconocido';

  @override
  String get miscAuthorizationCode => 'Código de autorización';

  @override
  String get miscWaitingForValidation => 'Esperando la validación…';

  @override
  String miscCodeValue(String code) {
    return 'Código: $code';
  }

  @override
  String get miscQualityHigh => 'Alta';

  @override
  String get miscExplore => 'Explorar';

  @override
  String get miscFavoriteAlbums => 'Álbumes favoritos';

  @override
  String get miscFavoriteTracks => 'Pistas favoritas';

  @override
  String miscSeeAllTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ver las $count pistas',
      one: 'Ver 1 pista',
    );
    return '$_temp0';
  }

  @override
  String get miscMyPlaylists => 'Mis listas';

  @override
  String get miscNoApiClient => 'Sin cliente API';

  @override
  String miscServiceFavorites(String service) {
    return 'Favoritos de $service';
  }

  @override
  String miscPlayAllCount(int count) {
    return 'Reproducir todo ($count)';
  }

  @override
  String get miscServiceNotFound => 'Servicio no encontrado';

  @override
  String get miscYtHome => 'Inicio';

  @override
  String get miscYtCharts => 'Listas';

  @override
  String get miscYtMoods => 'Estados de ánimo';

  @override
  String get miscNoData => 'Sin datos';

  @override
  String get miscNoContentAvailable => 'No hay contenido disponible';

  @override
  String get miscNoChartsAvailable => 'No hay listas disponibles';

  @override
  String get miscNoMoodsAvailable => 'No hay estados de ánimo disponibles';

  @override
  String get miscDashTotalPlays => 'Reproducciones totales';

  @override
  String get miscDashListeningTime => 'Tiempo de escucha';

  @override
  String get miscDashUniqueTracks => 'Pistas distintas';

  @override
  String get miscDashUniqueArtists => 'Artistas distintos';

  @override
  String get miscDashTopArtists => 'ARTISTAS MÁS ESCUCHADOS';

  @override
  String get miscDashTopAlbums => 'ÁLBUMES MÁS ESCUCHADOS';

  @override
  String get miscDashTopTracks => 'PISTAS MÁS ESCUCHADAS';

  @override
  String get miscDashListeningByHour => 'ESCUCHA POR HORA';

  @override
  String get miscDashListeningByDay => 'ESCUCHA POR DÍA';

  @override
  String get miscDashAllTime => 'Todo el tiempo';

  @override
  String miscDashLastDays(int days) {
    return '$days días';
  }

  @override
  String get miscUnknown => 'Desconocido';

  @override
  String miscPlaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reproducciones',
      one: '1 reproducción',
    );
    return '$_temp0';
  }

  @override
  String get miscDashNoData => 'Aún no hay datos de escucha';

  @override
  String get miscDashNoDataHint =>
      'Reproduce música para ver aquí tus estadísticas.';

  @override
  String get miscDashLoadFailed => 'No se pudo cargar el panel';

  @override
  String get miscDiagRequiresRemote =>
      'El diagnóstico requiere una conexión a un servidor remoto.';

  @override
  String get miscDiagSystem => 'Sistema';

  @override
  String get miscDiagHealth => 'Estado';

  @override
  String get miscVersion => 'Versión';

  @override
  String get miscDiagUptime => 'Tiempo activo';

  @override
  String get miscDiagMemory => 'Memoria';

  @override
  String get miscDiagDatabase => 'Base de datos';

  @override
  String miscZoneNumbered(String id) {
    return 'Zona $id';
  }

  @override
  String get miscDiagLogs => 'Registros';

  @override
  String get miscDiagNoLogs => 'No hay registros disponibles';

  @override
  String get miscAdminTitle => 'Panel de administración';

  @override
  String get miscAdminNotConnected => 'No conectado a un servidor remoto';

  @override
  String get miscAdminSystemHealth => 'Estado del sistema';

  @override
  String get miscAdminStatus => 'Estado';

  @override
  String get miscAdminDisk => 'Disco';

  @override
  String miscAdminDiscoveredDevices(int count) {
    return 'Dispositivos detectados ($count)';
  }

  @override
  String miscAdminRecentErrors(int count) {
    return 'Errores recientes ($count)';
  }

  @override
  String get miscAdminNoRecentErrors => 'No hay errores recientes';

  @override
  String get miscTroubleshootingTitle => 'Solución de problemas';

  @override
  String get miscFaqHeader => 'Preguntas frecuentes';

  @override
  String get miscFaq1Title => 'No veo mi servidor';

  @override
  String get miscFaq1Step1 =>
      'Comprueba que el servidor Tune está en marcha y accesible.';

  @override
  String get miscFaq1Step2 =>
      'Asegúrate de que tu dispositivo está conectado a la misma red Wi-Fi que el servidor.';

  @override
  String get miscFaq1Step3 =>
      'Si usas una VPN, desactívala o activa el descubrimiento LAN (p. ej., nordvpn set lan-discovery on).';

  @override
  String get miscFaq1Step4 =>
      'Prueba a escanear la red desde Ajustes > Modo > Escanear la red.';

  @override
  String get miscFaq1Step5 =>
      'Comprueba que el puerto del servidor (8888 por defecto) no esté bloqueado por un cortafuegos.';

  @override
  String get miscFaq1Step6 => 'Reinicia el servidor y la aplicación.';

  @override
  String get miscFaq2Title => 'La música no se reproduce';

  @override
  String get miscFaq2Step1 =>
      'Comprueba que hay una zona de reproducción seleccionada (barra en la parte inferior de la pantalla).';

  @override
  String get miscFaq2Step2 =>
      'Si no existe ninguna zona, crea una en Ajustes > Audio > Zonas > Crear.';

  @override
  String get miscFaq2Step3 =>
      'Comprueba que el dispositivo de salida (altavoz, DAC) está encendido y en la misma red.';

  @override
  String get miscFaq2Step4 =>
      'Con los dispositivos DLNA, espera unos segundos tras el descubrimiento antes de iniciar la reproducción.';

  @override
  String get miscFaq2Step5 =>
      'Prueba con otro archivo: puede que el formato del actual no sea compatible.';

  @override
  String get miscFaq2Step6 => 'Reinicia la aplicación si el problema persiste.';

  @override
  String get miscFaq3Title => 'No se muestran las portadas';

  @override
  String get miscFaq3Step1 =>
      'Inicia un escaneo de la biblioteca desde Ajustes > Biblioteca > Fuentes.';

  @override
  String get miscFaq3Step2 =>
      'Comprueba que los archivos incluyen portadas incrustadas (etiquetas ID3/Vorbis).';

  @override
  String get miscFaq3Step3 =>
      'Coloca un archivo cover.jpg o folder.jpg en la carpeta del álbum.';

  @override
  String get miscFaq3Step4 =>
      'Activa la obtención automática de portadas en Ajustes > Biblioteca > Metadatos.';

  @override
  String get miscFaq3Step5 =>
      'Vacía la caché de imágenes reiniciando la aplicación.';

  @override
  String get miscFaq4Title => 'El escaneo se ha bloqueado';

  @override
  String get miscFaq4Step1 =>
      'Un primer escaneo puede tardar varios minutos según el tamaño de la biblioteca.';

  @override
  String get miscFaq4Step2 =>
      'Comprueba que las carpetas de música son accesibles (permisos, montajes SMB).';

  @override
  String get miscFaq4Step3 =>
      'Cierra y vuelve a abrir la aplicación para interrumpir un escaneo bloqueado.';

  @override
  String get miscFaq4Step4 =>
      'Revisa los registros del servidor para identificar un archivo problemático.';

  @override
  String get miscFaq4Step5 =>
      'Prueba a reducir el número de carpetas de origen para aislar el problema.';

  @override
  String get miscFaq5Title => 'Cómo conectar un dispositivo DLNA/AirPlay';

  @override
  String get miscFaq5Step1 =>
      'DLNA: el dispositivo debe estar encendido y en la misma red. Aparece automáticamente en la lista de salidas.';

  @override
  String get miscFaq5Step2 =>
      'Si el dispositivo no aparece, comprueba que el multicast funciona en tu router.';

  @override
  String get miscFaq5Step3 =>
      'Algunos routers bloquean el tráfico SSDP entre clientes Wi-Fi: activa el reenvío multicast.';

  @override
  String get miscFaq5Step4 =>
      'BluOS: los altavoces Bluesound se detectan automáticamente.';

  @override
  String get miscFaq5Step5 =>
      'Chromecast: los dispositivos Google Cast aparecen en las salidas disponibles.';

  @override
  String get miscFaq5Step6 =>
      'Tras la detección, crea una zona y asígnale el dispositivo como salida.';

  @override
  String get miscFaq6Title => 'Problemas de streaming';

  @override
  String get miscFaq6Step1 =>
      'Comprueba que tus credenciales del servicio (TIDAL, Qobuz, Deezer) son correctas en Ajustes > Streaming.';

  @override
  String get miscFaq6Step2 =>
      'Si la sesión ha caducado, desconecta y vuelve a conectar el servicio.';

  @override
  String get miscFaq6Step3 => 'Comprueba tu conexión a Internet.';

  @override
  String get miscFaq6Step4 =>
      'Algunas pistas pueden no estar disponibles en tu región.';

  @override
  String get miscFaq6Step5 =>
      'Para problemas de calidad, revisa los ajustes de calidad de streaming en Ajustes > Audio avanzado.';

  @override
  String get miscFaq6Step6 =>
      'Si el problema persiste, envía un informe de error desde Ajustes > Ayuda.';

  @override
  String get miscBugReportCopied => 'Informe copiado al portapapeles';

  @override
  String get miscBugReportSent => 'Error enviado, ¡gracias!';

  @override
  String get miscBugReportSendFailed =>
      'Error al enviar. Copia el informe en el foro.';

  @override
  String get miscBugReportTitle => 'Informe de error';

  @override
  String get miscRegenerate => 'Regenerar';

  @override
  String get miscBugReportGenerateFailed => 'No se pudo generar el informe';

  @override
  String get miscSent => '¡Enviado!';

  @override
  String get miscSending => 'Enviando…';

  @override
  String get miscSubmit => 'Enviar';

  @override
  String get miscCopied => '¡Copiado!';

  @override
  String get miscCopyReport => 'Copiar informe';

  @override
  String get miscAiServerNotConnected =>
      'Servidor no conectado. Comprueba la conexión.';

  @override
  String miscAiQueryFailed(int code) {
    return 'Error en la consulta de IA ($code)';
  }

  @override
  String get miscAiNoReply => 'Sin respuesta';

  @override
  String get miscAiAskHint => 'Haz una pregunta…';

  @override
  String get miscAiSend => 'Enviar';

  @override
  String get miscAiTitle => 'Asistente de IA';

  @override
  String get miscAiEmptyTitle => 'Asistente de IA de Tune';

  @override
  String get miscAiEmptyBody =>
      'Haz una pregunta sobre tu música,\npide recomendaciones…';

  @override
  String miscAiAction(String action) {
    return 'Acción: $action';
  }

  @override
  String get miscCreateAccount => 'Crear una cuenta';

  @override
  String get miscUsername => 'Nombre de usuario';

  @override
  String get miscUsernameRequired => 'Nombre de usuario obligatorio';

  @override
  String get miscEmailRequired => 'Correo electrónico obligatorio';

  @override
  String get miscEmailInvalid => 'Correo electrónico no válido';

  @override
  String get miscPasswordRequired => 'Contraseña obligatoria';

  @override
  String miscPasswordMinLength(int min) {
    return 'Mínimo $min caracteres';
  }

  @override
  String get miscHaveAccountSignIn => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get miscNoAccountSignUp => '¿No tienes cuenta? Regístrate';

  @override
  String get npRepeat => 'Repetir';

  @override
  String get npQueue => 'Cola';

  @override
  String get npFavorite => 'Favorito';

  @override
  String get npRadioFavAdded => 'Añadido a favoritos de radio';

  @override
  String get npLyrics => 'Letra';

  @override
  String get npAlarm => 'Alarma';

  @override
  String get npSleepTimer => 'Temporizador de apagado';

  @override
  String get npDspCrossfeed => 'Crossfeed DSP';

  @override
  String get npEqualizer => 'Ecualizador';

  @override
  String get npShare => 'Compartir';

  @override
  String get npTransfer => 'Transferir';

  @override
  String get npCopiedToClipboard => 'Copiado al portapapeles';

  @override
  String get npNoLyricsFound => 'No se encontró la letra';

  @override
  String get npNoLyricsAvailable => 'Letra no disponible';

  @override
  String get npLyricsOpenFromNowPlaying =>
      'Abre desde «Reproduciendo» para ver la letra completa';

  @override
  String get npLyricsLoadFailed => 'No se pudo cargar la letra';

  @override
  String get npLrcMetadataTooltip => 'Metadatos';

  @override
  String get npLrcMetadataTitle => 'Metadatos LRC';

  @override
  String get npLrcTitle => 'Título';

  @override
  String get npLrcCreatedBy => 'Creado por';

  @override
  String get npLrcOffset => 'Desfase (ms)';

  @override
  String get npLrcHint =>
      'Coloca un archivo .lrc con el mismo nombre junto al archivo de audio.';

  @override
  String get npEqFlat => 'Plano';

  @override
  String get npEqBassBoost => 'Refuerzo de graves';

  @override
  String get npEqTrebleBoost => 'Refuerzo de agudos';

  @override
  String get npEqVocal => 'Voces';

  @override
  String get npEqRock => 'Rock';

  @override
  String get npEqJazz => 'Jazz';

  @override
  String get npEqClassical => 'Clásica';

  @override
  String get npEqElectronic => 'Electrónica';

  @override
  String get npEqHipHop => 'Hip hop';

  @override
  String get npEqAcoustic => 'Acústica';

  @override
  String npEqApplied(String preset) {
    return 'Ecualizador: $preset';
  }

  @override
  String npEqError(String error) {
    return 'Error del ecualizador: $error';
  }

  @override
  String get npCrossfeedDesc =>
      'Mezcla los canales estéreo para una escucha con auriculares más natural';

  @override
  String get npCrossfeedOff => 'Desactivado';

  @override
  String get npCrossfeedLight => 'Suave';

  @override
  String get npCrossfeedMedium => 'Medio';

  @override
  String get npCrossfeedStrong => 'Fuerte';

  @override
  String npCrossfeedApplied(String level) {
    return 'Crossfeed: $level';
  }

  @override
  String npDspError(String error) {
    return 'Error de DSP: $error';
  }

  @override
  String get npTransferTitle => 'Transferir la reproducción';

  @override
  String get npNoOtherZones => 'No hay otras zonas disponibles';

  @override
  String npTransferredTo(String zone) {
    return 'Transferido a $zone';
  }

  @override
  String npTransferError(String error) {
    return 'Error de transferencia: $error';
  }

  @override
  String get npAlarmClock => 'Despertador';

  @override
  String npAlarmSetFor(String time) {
    return 'Alarma programada a las $time';
  }

  @override
  String npAlarmError(String error) {
    return 'Error de alarma: $error';
  }

  @override
  String get npAlarmCancelled => 'Alarma cancelada';

  @override
  String get npPause => 'Pausa';

  @override
  String get npStop => 'Detener';

  @override
  String get npRoleComposer => 'Compositor';

  @override
  String get npRoleLyricist => 'Letrista';

  @override
  String get npRoleArranger => 'Arreglista';

  @override
  String get npRoleConductor => 'Director';

  @override
  String get npRolePerformer => 'Intérprete';

  @override
  String get npRoleProducer => 'Productor';

  @override
  String get npRoleMixer => 'Mezcla';

  @override
  String get npRoleEngineer => 'Ingeniero de sonido';

  @override
  String get npCreditsEnriching => 'Enriqueciendo…';

  @override
  String get npCreditsEnrich => 'Enriquecer con MusicBrainz';

  @override
  String get npVolume => 'Volumen';

  @override
  String get npChangeZone => 'Cambiar de zona';

  @override
  String get npZoneFallback => 'Zona';

  @override
  String get npFollowMe => 'Sígueme';

  @override
  String get npMovePlaybackTo => 'Llevar la reproducción a…';

  @override
  String get npNowPlaying => 'Reproduciendo';

  @override
  String get npTabMore => 'Más';

  @override
  String npSleepTimerSet(int minutes, int fade) {
    return 'Temporizador programado: $minutes min (fundido: $fade s)';
  }

  @override
  String npSleepTimerError(String error) {
    return 'Error del temporizador: $error';
  }

  @override
  String get npSleepTimerCancelled => 'Temporizador cancelado';

  @override
  String get npSleepDuration => 'DURACIÓN';

  @override
  String get npSleepCustom => 'Personalizado';

  @override
  String get npSleepFadeOut => 'FUNDIDO DE SALIDA';

  @override
  String npSleepFadeDesc(int seconds) {
    return 'El volumen bajará gradualmente hasta cero durante los últimos $seconds segundos.';
  }

  @override
  String get npSleepStarting => 'Iniciando…';

  @override
  String npSleepStart(String duration) {
    return 'Iniciar ($duration)';
  }

  @override
  String get npSleepSelectDuration => 'Elige una duración';

  @override
  String get npSleepTimerActive => 'Temporizador activo';

  @override
  String get npSleepCancelTimer => 'Cancelar temporizador';

  @override
  String get npMoodChill => 'Relax';

  @override
  String get npMoodParty => 'Fiesta';

  @override
  String get npMoodFocus => 'Concentración';

  @override
  String get npMoodEnergetic => 'Enérgico';

  @override
  String get npNoZoneAvailable => 'No hay ninguna zona disponible';

  @override
  String npMoodNoTracks(String mood) {
    return 'No se encontraron pistas para $mood';
  }

  @override
  String get npMoodInvalidTrackIds => 'Error: ID de pista no válidos';

  @override
  String npMoodMixPlaying(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas en reproducción',
      one: '1 pista en reproducción',
    );
    return 'Mix $mood: $_temp0';
  }

  @override
  String npMoodMixQueued(String mood, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas añadidas a la cola',
      one: '1 pista añadida a la cola',
    );
    return 'Mix $mood: $_temp0';
  }

  @override
  String npSmartAutoplayError(String error) {
    return 'Error de Smart AutoPlay: $error';
  }

  @override
  String get npSmartAutoplayDesc =>
      'Elige un ambiente para generar una playlist inteligente';

  @override
  String get npAlarmsNotConnected => 'No conectado a un servidor remoto';

  @override
  String get npAlarmSnoozed => 'Alarma pospuesta 5 min';

  @override
  String get npAlarmsTitle => 'Alarmas';

  @override
  String get npAlarmsEmpty => 'No hay alarmas';

  @override
  String npZoneNumbered(String id) {
    return 'Zona $id';
  }

  @override
  String get npAlarmSkipsHolidays => 'Excepto festivos';

  @override
  String get npAlarmSnooze => 'Posponer';

  @override
  String get npAlarmDefaultName => 'Alarma';

  @override
  String get npAlarmEdit => 'Editar alarma';

  @override
  String get npAlarmNew => 'Nueva alarma';

  @override
  String get npAlarmTime => 'Hora';

  @override
  String get npAlarmNameHint => 'Despertar';

  @override
  String get npAlarmDays => 'Días';

  @override
  String get npAlarmSkipHolidays => 'Omitir los festivos';

  @override
  String get npAlarmCountry => 'País:';

  @override
  String get npCountryFR => 'Francia';

  @override
  String get npCountryBE => 'Bélgica';

  @override
  String get npCountryCH => 'Suiza';

  @override
  String get npCountryCA => 'Canadá';

  @override
  String get npCountryUS => 'EE. UU.';

  @override
  String get npCountryDE => 'Alemania';

  @override
  String get npCountryGB => 'Reino Unido';

  @override
  String get npAlarmSource => 'Fuente';

  @override
  String get npAlarmSourceType => 'Tipo';

  @override
  String get npSourceRadio => 'Radio';

  @override
  String get npSourcePlaylist => 'Playlist';

  @override
  String get npSourceAlbum => 'Álbum';

  @override
  String get npAlarmSourceName => 'Nombre de la fuente';

  @override
  String get npAlarmPlaylistId => 'ID de la playlist';

  @override
  String get npAlarmAlbumId => 'ID del álbum';

  @override
  String get npAlarmIdentifier => 'Identificador';

  @override
  String get npAlarmPlaybackZone => 'Zona de reproducción';

  @override
  String get npAlarmDefaultZone => 'Predeterminada';

  @override
  String npAlarmVolume(int percent) {
    return 'Volumen: $percent %';
  }

  @override
  String npAlarmFadeIn(int seconds) {
    return 'Fundido de entrada: $seconds s';
  }

  @override
  String get npAlarmEnabled => 'Activada';

  @override
  String get npAlarmDeleteTitle => '¿Eliminar la alarma?';

  @override
  String get npDayMon => 'Lun';

  @override
  String get npDayTue => 'Mar';

  @override
  String get npDayWed => 'Mié';

  @override
  String get npDayThu => 'Jue';

  @override
  String get npDayFri => 'Vie';

  @override
  String get npDaySat => 'Sáb';

  @override
  String get npDaySun => 'Dom';

  @override
  String get plHubTitle => 'Centro de listas';

  @override
  String get plTabSmartAi => 'IA';

  @override
  String get plTabTransfers => 'Transferencias';

  @override
  String get plSync => 'Sincronizar';

  @override
  String get plTabBackup => 'Copia';

  @override
  String get plCompare => 'Comparar';

  @override
  String get plComparing => 'Comparando…';

  @override
  String plCompareError(String detail) {
    return 'Error al comparar: $detail';
  }

  @override
  String get plNoPlaylistsAvailable => 'No hay listas disponibles';

  @override
  String get plSectionSource => 'ORIGEN';

  @override
  String get plSectionTarget => 'DESTINO';

  @override
  String get plServiceLabel => 'Servicio';

  @override
  String get plPlaylistLabel => 'Lista';

  @override
  String get plLocal => 'Local';

  @override
  String get plSourceLabel => 'Origen';

  @override
  String get plRestoreSnapshotTitle => 'Restaurar instantánea';

  @override
  String get plLocalPlaylistNameLabel => 'Nombre de la lista local:';

  @override
  String get plRestore => 'Restaurar';

  @override
  String plRestoreDone(String name, String matched, String notFound) {
    return '«$name» restaurada: $matched encontradas, $notFound no encontradas.';
  }

  @override
  String plRestoreReplaced(String name, String matched, String notFound) {
    return '«$name» reemplazada: $matched encontradas, $notFound no encontradas.';
  }

  @override
  String get plExistingTitle => 'La lista ya existe';

  @override
  String plExistingBody(String name) {
    return 'Ya existe una lista «$name». ¿Reemplazarla?';
  }

  @override
  String get plReplace => 'Reemplazar';

  @override
  String plDeleteSnapshotBody(String name) {
    return '¿Eliminar la instantánea de «$name»?';
  }

  @override
  String get plSyncIntervalTitle => 'Intervalo de sincronización automática';

  @override
  String get plSyncIntervalLabel => 'Minutos (0 = solo manual):';

  @override
  String get plSyncIntervalHint => 'p. ej. 60';

  @override
  String get plNoTransfers => 'Sin transferencias';

  @override
  String get plNoSyncLinks => 'Sin vínculos de sincronización';

  @override
  String get plNoSyncLinksHint => 'Crea vínculos desde una transferencia';

  @override
  String plPlaylistNumber(String id) {
    return 'Lista n.º $id';
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
    return 'Sincronización OK: +$addedLocal/-$removedLocal local, +$addedRemote/-$removedRemote remoto';
  }

  @override
  String plSyncConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ', $count conflictos',
      one: ', 1 conflicto',
    );
    return '$_temp0';
  }

  @override
  String plSyncError(String detail) {
    return 'Error de sincronización: $detail';
  }

  @override
  String get plSectionBackup => 'COPIA DE SEGURIDAD';

  @override
  String get plBackingUp => 'Creando copia…';

  @override
  String get plBackupAll => 'Copiar todas las listas';

  @override
  String plBackupResult(String playlists, String tracks) {
    return '$playlists listas · $tracks pistas';
  }

  @override
  String get plSectionSnapshots => 'INSTANTÁNEAS';

  @override
  String get plNoSnapshots =>
      'No hay instantáneas. Haz una copia para crear una.';

  @override
  String get plSectionBatchTransfer => 'TRANSFERENCIA EN LOTE';

  @override
  String get plBatchTransferHint =>
      'Transferir todas las listas de un servicio';

  @override
  String get plTransferring => 'Transfiriendo…';

  @override
  String get plTransferAll => 'Transferir todo';

  @override
  String plBatchResult(String count, String status) {
    return '$count listas — $status';
  }

  @override
  String get plMergeDone => 'Listas combinadas.';

  @override
  String plMergeError(String detail) {
    return 'Error al combinar: $detail';
  }

  @override
  String get plNameLabel => 'Nombre';

  @override
  String plDeleteNamed(String name) {
    return '¿Eliminar «$name»?';
  }

  @override
  String plImportedLocal(String name) {
    return '«$name» importada en local.';
  }

  @override
  String plImportError(String detail) {
    return 'Error al importar: $detail';
  }

  @override
  String get plFilterAll => 'Todas';

  @override
  String get plMerge => 'Combinar';

  @override
  String get plCancelMerge => 'Cancelar combinación';

  @override
  String get plMerging => 'Combinando…';

  @override
  String get plImportToLocal => 'Importar en local';

  @override
  String plSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionadas',
      one: '1 seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get plDedup => 'Sin duplicados';

  @override
  String get plMergedNameHint => 'Nombre de la lista combinada';

  @override
  String plTracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas',
      one: '1 pista',
    );
    return '$_temp0';
  }

  @override
  String get plSectionResults => 'RESULTADOS';

  @override
  String get plCommon => 'En común';

  @override
  String get plSourceOnly => 'Solo origen';

  @override
  String get plTargetOnly => 'Solo destino';

  @override
  String plMatchRate(String rate) {
    return '$rate % de coincidencia';
  }

  @override
  String plOnlyInSource(int count) {
    return 'Solo en el origen ($count)';
  }

  @override
  String plOnlyInTarget(int count) {
    return 'Solo en el destino ($count)';
  }

  @override
  String plMoreCount(int count) {
    return '+ $count más';
  }

  @override
  String get plTransferPlaylistTitle => 'Transferir lista';

  @override
  String get plCreateOnRemote => 'Crear en el servicio remoto';

  @override
  String get plTransfer => 'Transferir';

  @override
  String plTransferDone(String matched, String approximate, String notFound) {
    return 'Transferencia: $matched encontradas, $approximate aproximadas, $notFound faltantes.';
  }

  @override
  String get plRecover => 'Recuperar';

  @override
  String plRecoverDone(int available, int alternatives) {
    return 'Recuperación: $available disponibles, $alternatives alternativas encontradas.';
  }

  @override
  String plCopyName(String name) {
    return '$name (copia)';
  }

  @override
  String get plDuplicate => 'Duplicar';

  @override
  String plDuplicated(String name) {
    return 'Duplicada: $name';
  }

  @override
  String plDeleted(String name) {
    return 'Eliminada: $name';
  }

  @override
  String plTransferred(String name) {
    return 'Transferida: $name';
  }

  @override
  String get plTransferToLocal => 'Transferir a local';

  @override
  String get plExportJson => 'Exportar JSON';

  @override
  String get plExportCsv => 'Exportar CSV';

  @override
  String get plExportM3u => 'Exportar M3U';

  @override
  String get plExportJsonDone => 'Exportación JSON completada';

  @override
  String get plExportCsvDone => 'Exportación CSV completada';

  @override
  String plExportM3uDone(String path) {
    return 'M3U exportado: $path';
  }

  @override
  String plExportM3uError(String detail) {
    return 'Error al exportar M3U: $detail';
  }

  @override
  String plImportedM3u(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importada: $name ($count pistas)',
      one: 'Importada: $name (1 pista)',
    );
    return '$_temp0';
  }

  @override
  String plImportM3uError(String detail) {
    return 'Error al importar M3U: $detail';
  }

  @override
  String get plSmartTitle => 'Listas inteligentes';

  @override
  String plSmartLoadError(String detail) {
    return 'No se pudieron cargar las listas inteligentes: $detail';
  }

  @override
  String plDeleteError(String detail) {
    return 'Error al eliminar: $detail';
  }

  @override
  String get plSmartEmpty => 'No hay listas inteligentes';

  @override
  String get plUntitled => 'Sin título';

  @override
  String get plSmartDeleteTitle => '¿Eliminar la lista inteligente?';

  @override
  String plPreviewError(String detail) {
    return 'Error en la vista previa: $detail';
  }

  @override
  String get plEnterName => 'Introduce un nombre';

  @override
  String plSaveError(String detail) {
    return 'Error al guardar: $detail';
  }

  @override
  String get plSmartEditTitle => 'Editar lista inteligente';

  @override
  String get plSmartNewTitle => 'Nueva lista inteligente';

  @override
  String get plMatchLabel => 'Coincidir';

  @override
  String get plMatchAll => 'Todas las reglas';

  @override
  String get plMatchAny => 'Cualquier regla';

  @override
  String get plSectionRules => 'REGLAS';

  @override
  String get plAddRule => 'Añadir regla';

  @override
  String get plMaxTracksLabel => 'Máx. de pistas (opcional)';

  @override
  String get plNoLimit => 'Sin límite';

  @override
  String get plPreviewMatching => 'Vista previa de las pistas coincidentes';

  @override
  String plMatchingTracks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas coincidentes',
      one: '1 pista coincidente',
    );
    return '$_temp0';
  }

  @override
  String get plValueHint => 'Valor';

  @override
  String get plUnknownTitle => 'Desconocido';

  @override
  String plTracksLoadError(String detail) {
    return 'No se pudieron cargar las pistas: $detail';
  }

  @override
  String get plSmartNoTracks => 'Ninguna pista coincide con esta lista';

  @override
  String get plFieldGenre => 'Género';

  @override
  String get plFieldArtist => 'Artista';

  @override
  String get plFieldAlbum => 'Álbum';

  @override
  String get plFieldTitle => 'Título';

  @override
  String get plFieldYear => 'Año';

  @override
  String get plFieldRating => 'Valoración';

  @override
  String get plFieldPlayCount => 'Reproducciones';

  @override
  String get plFieldDuration => 'Duración (ms)';

  @override
  String get plFieldDateAdded => 'Fecha de adición';

  @override
  String get plFieldFavorite => 'Favorito';

  @override
  String get plOpContains => 'contiene';

  @override
  String get plOpEquals => 'es igual a';

  @override
  String get plOpStartsWith => 'empieza por';

  @override
  String get plOpEndsWith => 'termina en';

  @override
  String get plOpGreaterThan => 'mayor que';

  @override
  String get plOpLessThan => 'menor que';

  @override
  String get plOpIs => 'es';

  @override
  String get plOpIsNot => 'no es';

  @override
  String get srvConfigTitle => 'Configuración del servidor';

  @override
  String srvFolderAdded(String path) {
    return 'Carpeta añadida: $path';
  }

  @override
  String get srvRemoveFolderTitle => '¿Eliminar esta carpeta?';

  @override
  String srvScanStarted(String path) {
    return 'Escaneo iniciado: $path';
  }

  @override
  String get srvFullScanStarted => 'Escaneo completo iniciado';

  @override
  String get srvRestartTitle => '¿Reiniciar el servidor?';

  @override
  String get srvRestartBody =>
      'El servidor se detendrá y se reiniciará. La reproducción en curso se interrumpirá.';

  @override
  String get srvRestartBtn => 'Reiniciar';

  @override
  String get srvRestarting => 'Reiniciando el servidor…';

  @override
  String get srvRestartInProgress => 'Reinicio en curso…';

  @override
  String get srvLoadError => 'Error al cargar';

  @override
  String get srvScanFolderTooltip => 'Escanear esta carpeta';

  @override
  String get srvSectionServerInfo => 'Información del servidor';

  @override
  String get srvInfoVersion => 'Versión';

  @override
  String get srvInfoEngine => 'Motor';

  @override
  String get srvInfoDatabase => 'Base de datos';

  @override
  String get srvSectionActions => 'Acciones';

  @override
  String get srvRestartServer => 'Reiniciar el servidor';

  @override
  String get srvRestartServerDesc =>
      'Detiene y relanza el proceso del servidor';

  @override
  String get srvManualEntry => 'Introducir manualmente';

  @override
  String srvSelectPath(String path) {
    return 'Seleccionar «$path»';
  }

  @override
  String get srvBrowse => 'Explorar…';

  @override
  String get srvFolderPathHint => '/ruta/a/musica';

  @override
  String get srvFolderPathHelp =>
      'Introduce la ruta absoluta de la carpeta en el servidor.';

  @override
  String get srvNoSubfolders => 'Sin subcarpetas';

  @override
  String get srvPluginsTitle => 'Plugins';

  @override
  String get srvNotConnectedToServer => 'No conectado al servidor';

  @override
  String srvPluginInstalled(String name) {
    return '$name instalado';
  }

  @override
  String srvPluginUninstalled(String name) {
    return '$name desinstalado';
  }

  @override
  String srvPluginUpdated(String name) {
    return '$name actualizado';
  }

  @override
  String srvPluginEnabled(String name) {
    return '$name activado';
  }

  @override
  String srvPluginDisabled(String name) {
    return '$name desactivado';
  }

  @override
  String srvPluginInstallFailed(String error) {
    return 'Error de instalación: $error';
  }

  @override
  String srvPluginUninstallFailed(String error) {
    return 'Error de desinstalación: $error';
  }

  @override
  String srvPluginUpdateFailed(String error) {
    return 'Error de actualización: $error';
  }

  @override
  String get srvPluginsTabStore => 'Tienda';

  @override
  String get srvPluginsTabInstalled => 'Instalados';

  @override
  String get srvRestartRequired =>
      'Es necesario reiniciar para aplicar los cambios';

  @override
  String get srvPluginsSearchHint => 'Buscar plugins…';

  @override
  String get srvPluginsNoneFound => 'No se encontraron plugins';

  @override
  String get srvPluginsNoneInstalled => 'No hay plugins instalados';

  @override
  String get srvPluginsBrowseStore => 'Explorar la tienda';

  @override
  String get srvPluginBadgeFeatured => 'Destacado';

  @override
  String get srvPluginBadgeUpdate => 'Actualización';

  @override
  String get srvPluginBadgeIncompatible => 'Incompatible';

  @override
  String srvPluginByAuthor(String author) {
    return 'por $author';
  }

  @override
  String get srvPluginActionUpdate => 'Actualizar';

  @override
  String get srvPluginActionInstall => 'Instalar';

  @override
  String get srvPluginActionUninstall => 'Desinstalar';

  @override
  String get srvPluginStatusActive => 'Activo';

  @override
  String get srvPluginStatusError => 'Error';

  @override
  String get srvAutoFixTitle => 'Corrección automática de metadatos';

  @override
  String srvAutoFixApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count correcciones aplicadas',
      one: '1 corrección aplicada',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixNoHighConfidence =>
      'No quedan correcciones de alta confianza';

  @override
  String srvAutoFixRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quedan $count sugerencias',
      one: 'Queda 1 sugerencia',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixApplyHighConf => 'Aplicar alta confianza';

  @override
  String srvAutoFixTrackNumber(int id) {
    return 'Pista n.º $id';
  }

  @override
  String get srvAutoFixCurrent => 'Actual';

  @override
  String get srvAutoFixEmpty => '(vacío)';

  @override
  String get srvAutoFixSuggested => 'Sugerido';

  @override
  String get srvAutoFixSkip => 'Omitir';

  @override
  String get srvAutoFixApply => 'Aplicar';

  @override
  String get srvAutoFixIntroTitle => 'Corregir metadatos que faltan';

  @override
  String get srvAutoFixIntroBody =>
      'Analiza las pistas sin género, año o ID de MusicBrainz y sugiere correcciones de MusicBrainz.';

  @override
  String get srvAutoFixStartScan => 'Iniciar escaneo';

  @override
  String get srvAutoFixScanning => 'Buscando en MusicBrainz…';

  @override
  String srvAutoFixProgress(int processed, int total, int pct) {
    return '$processed / $total pistas ($pct %)';
  }

  @override
  String get srvAutoFixLoadingTracks => 'Cargando pistas…';

  @override
  String srvAutoFixFoundSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count correcciones encontradas hasta ahora',
      one: '1 corrección encontrada hasta ahora',
    );
    return '$_temp0';
  }

  @override
  String get srvAutoFixRateLimit =>
      'Limitado a 1 solicitud/s (política de MusicBrainz)';

  @override
  String get srvAutoFixNoneNeeded => 'No se necesitan correcciones';

  @override
  String get srvAutoFixAllComplete =>
      'Todas las pistas tienen metadatos completos.';

  @override
  String get srvAutoFixScanAgain => 'Volver a escanear';

  @override
  String get srvAutoFixScanFailed => 'Error en el escaneo';

  @override
  String get srvMpStepSetup => 'Configuración';

  @override
  String get srvMpStepFineTune => 'Ajuste fino';

  @override
  String get srvMpListenTitle => '¿Cómo escuchas?';

  @override
  String get srvMpListenSubtitle =>
      'El perfil se adaptará a tu configuración de escucha';

  @override
  String get srvMpSpeakers => 'Altavoces';

  @override
  String get srvMpSpeakersSub => 'Sala de escucha';

  @override
  String get srvMpHeadphones => 'Auriculares';

  @override
  String get srvMpHeadphonesSub => 'Escucha personal';

  @override
  String get srvMpRoomTitle => '¿Qué tamaño tiene la sala?';

  @override
  String get srvMpRoomSubtitle =>
      'Influye en las frecuencias graves y la reverberación';

  @override
  String get srvMpRoomSmall => 'Pequeña';

  @override
  String get srvMpRoomMedium => 'Mediana';

  @override
  String get srvMpRoomLarge => 'Grande';

  @override
  String get srvMpPlacementTitle => 'Colocación de los altavoces';

  @override
  String get srvMpPlacementSubtitle =>
      'La ubicación afecta a las reflexiones de graves';

  @override
  String get srvMpNearWall => 'Cerca de una pared';

  @override
  String get srvMpFreeStanding => 'En espacio libre';

  @override
  String get srvMpTuneSound => 'Ajustar el sonido';

  @override
  String get srvMpCorrectionActive => 'Corrección activa';

  @override
  String get srvMpCorrectionDesc => 'Aplica el perfil a la zona actual';

  @override
  String get srvMpBass => 'Graves';

  @override
  String get srvMpBassDesc => 'Peso, calidez, cuerpo del sonido';

  @override
  String get srvMpBassLow => 'Ligero';

  @override
  String get srvMpBassHigh => 'Pesado';

  @override
  String get srvMpMid => 'Voz / Medios';

  @override
  String get srvMpMidDesc => 'Presencia, claridad, inteligibilidad';

  @override
  String get srvMpMidLow => 'Atrás';

  @override
  String get srvMpMidHigh => 'Adelante';

  @override
  String get srvMpTreble => 'Agudos';

  @override
  String get srvMpTrebleDesc => 'Brillo, detalle, aire en el sonido';

  @override
  String get srvMpTrebleLow => 'Oscuro';

  @override
  String get srvMpTrebleHigh => 'Brillante';

  @override
  String get srvMpProfileApplied => 'Perfil aplicado';

  @override
  String get srvMpApplying => 'Aplicando…';

  @override
  String get srvMpApply => 'Aplicar perfil';

  @override
  String get srvMpBackToQuestions => 'Volver a las preguntas';

  @override
  String get srvRemoteConfigBody =>
      'Conéctate a un servidor Tune de tu red para disfrutar de todas las funciones.';

  @override
  String get srvModeStandalone => 'Autónomo';

  @override
  String get srvStandaloneWarning =>
      'Modo autónomo: Party, DJ, letras sincronizadas, EQ y recomendaciones no están disponibles. Recomendado: usar un servidor Tune remoto.';

  @override
  String get srvServerAddress => 'Dirección del servidor';

  @override
  String get srvNoServerYet => '¿Aún no tienes servidor?';

  @override
  String get srvDownloadServer =>
      'Descarga Tune Server: mozaiklabs.fr/download (Mac, Linux, Windows, Raspberry Pi, Docker NAS).';

  @override
  String get srvStreamingBody =>
      'Activa los servicios de streaming que quieras usar con Tune.';

  @override
  String get srvStreamingStandaloneWarning =>
      'En modo autónomo, los servicios de streaming no están disponibles. Cambia al modo servidor remoto para activarlos.';

  @override
  String get srvNoServiceAvailable =>
      'No hay servicios disponibles. Comprueba la conexión con el servidor.';

  @override
  String srvServicesEnabled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servicios activados',
      one: '1 servicio activado',
    );
    return '$_temp0';
  }

  @override
  String srvServicesConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conectados',
      one: '1 conectado',
    );
    return '$_temp0';
  }

  @override
  String get srvServiceEnabledNotConnected => 'Activado, no conectado';

  @override
  String get srvAudioCheckTitle => 'Diagnóstico de audio';

  @override
  String get srvAudioCheckBody =>
      'Comprobando la configuración de audio de tu sistema.';

  @override
  String get srvDiagZones => 'Zonas configuradas';

  @override
  String get srvDiagOutputs => 'Salidas de audio';

  @override
  String srvDiagOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count detectadas',
      one: '1 detectada',
    );
    return '$_temp0';
  }

  @override
  String get srvDiagNetworkDevices => 'Dispositivos de red';

  @override
  String get srvDiagNone => 'Ninguno';

  @override
  String get srvDiagNoZoneWarning =>
      'No hay ninguna zona configurada. Puedes crear una en los ajustes de Zonas.';

  @override
  String srvAudioCheckUnavailable(String error) {
    return 'Diagnóstico de audio no disponible: $error';
  }

  @override
  String get srvRecheck => 'Volver a comprobar';

  @override
  String get srvScanBody =>
      'Inicia un escaneo para indexar tus archivos de música y obtener sus metadatos.';

  @override
  String get srvScanStart => 'Iniciar escaneo';

  @override
  String get srvScanStatScanned => 'Escaneados';

  @override
  String get srvScanStatAdded => 'Añadidos';

  @override
  String get srvScanStatUpdated => 'Actualizados';

  @override
  String get srvScanMayTakeMinutes => 'Esto puede tardar unos minutos…';

  @override
  String get srvScanComplete => '¡Escaneo completado!';

  @override
  String stgUpdateAvailable(String version) {
    return 'Actualización disponible: v$version';
  }

  @override
  String stgCurrentVersion(String version) {
    return 'Versión actual: v$version';
  }

  @override
  String get stgOpen => 'Abrir';

  @override
  String get stgMode => 'Modo';

  @override
  String stgConnectedTo(String address) {
    return 'Conectado a $address';
  }

  @override
  String get stgModeRemote => 'Remoto';

  @override
  String get stgStandaloneTitle => 'Modo autónomo — funciones limitadas';

  @override
  String get stgStandaloneBody =>
      'Party, DJ, letras sincronizadas, EQ, biografías de álbumes, recomendaciones… requieren un servidor Tune remoto.';

  @override
  String get stgServerAddress => 'Dirección del servidor';

  @override
  String get stgNotConfigured => 'No configurado';

  @override
  String get stgScanNetwork => 'Escanear la red';

  @override
  String get stgSectionPlayback => 'REPRODUCCIÓN';

  @override
  String get stgCrossfade => 'Fundido cruzado';

  @override
  String get stgRepeatOneByDefault => 'Repetir por defecto';

  @override
  String get stgExclusiveMode => 'Modo exclusivo (bit-perfect)';

  @override
  String get stgExclusiveModeDesc =>
      'WASAPI Exclusive — acceso directo al DAC USB';

  @override
  String get stgSectionMetadataFields => 'CAMPOS DE METADATOS';

  @override
  String get stgSectionAdvancedAudio => 'AUDIO AVANZADO';

  @override
  String get stgEqualizer => 'Ecualizador';

  @override
  String get stgEqualizerDesc =>
      'Asistente de calibración + EQ experto de 10 bandas';

  @override
  String get stgMetadataFieldsDesc =>
      'Configurar campos ampliados (compositor, director…)';

  @override
  String get stgSpotifyConnectDesc =>
      'Tune como receptor (Premium necesario en el cliente)';

  @override
  String get stgLastfmDesc => 'Hacer scrobbling de tu historial de escucha';

  @override
  String get stgListenBrainzDesc => 'Scrobbling a ListenBrainz';

  @override
  String get stgAutoFixMetadata => 'Corrección automática de metadatos';

  @override
  String get stgAutoFixMetadataDesc =>
      'Completar género, año y MBID que faltan con MusicBrainz';

  @override
  String get stgDatabase => 'Base de datos';

  @override
  String get stgImportExport => 'Importar / Exportar';

  @override
  String get stgSectionProfiles => 'PERFILES';

  @override
  String get stgSectionSystem => 'SISTEMA';

  @override
  String get stgServerConfig => 'Configuración del servidor';

  @override
  String get stgServerConfigDesc => 'Carpetas de música, escaneo, reinicio';

  @override
  String get stgNetworkDiagnostics => 'Diagnóstico de red';

  @override
  String get stgNetworkDiagnosticsDesc => 'Multicast, DNS, conectividad';

  @override
  String get stgConfiguration => 'Configuración';

  @override
  String get stgExportImport => 'Exportar / Importar';

  @override
  String get stgPlugins => 'Complementos';

  @override
  String get stgPluginsDesc => 'Extensiones instaladas';

  @override
  String get stgNetworkShares => 'Recursos compartidos de red (SMB)';

  @override
  String get stgNetworkSharesDesc => 'Descubrir y montar recursos compartidos';

  @override
  String get stgSectionCloud => 'NUBE';

  @override
  String get stgSectionHelp => 'AYUDA';

  @override
  String get stgTroubleshooting => 'Solución de problemas';

  @override
  String get stgTroubleshootingDesc => 'Preguntas frecuentes y soluciones';

  @override
  String get stgSendBugReport => 'Enviar un informe de error';

  @override
  String get stgSendBugReportDesc => 'Generar y copiar un informe técnico';

  @override
  String get stgServerAddressHint =>
      'IP o nombre de host (p. ej. 192.168.1.18)';

  @override
  String get stgServerPort => 'Puerto del servidor';

  @override
  String get stgPortDefaultHint => 'Puerto (predeterminado: 8888)';

  @override
  String get stgWarnNoZones =>
      'No hay ninguna zona configurada. Crea una para empezar a reproducir.';

  @override
  String get stgWarnNoNetworkDevices =>
      'No se ha detectado ningún dispositivo de red (DLNA/BluOS/Chromecast).';

  @override
  String get stgSectionAudio => 'AUDIO';

  @override
  String get stgAudioOutputs => 'Salidas de audio';

  @override
  String stgOutputsDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count detectadas',
      one: '1 detectada',
    );
    return '$_temp0';
  }

  @override
  String get stgNetworkDevices => 'Dispositivos de red';

  @override
  String get stgZoneNameHint => 'p. ej. Salón, Despacho';

  @override
  String get stgProfileActivated => 'Perfil activado';

  @override
  String get stgNewProfile => 'Nuevo perfil';

  @override
  String get stgProfileName => 'Nombre del perfil';

  @override
  String get stgProfileNameHint => 'p. ej. Noche, Mañana';

  @override
  String get stgProfileUpdated => 'Perfil actualizado';

  @override
  String get stgNoProfiles => 'No hay perfiles';

  @override
  String get stgProfile => 'Perfil';

  @override
  String get stgEditProfile => 'Editar perfil';

  @override
  String get stgName => 'Nombre';

  @override
  String get stgColor => 'Color';

  @override
  String get stgScanInProgress => 'Escaneando la red…';

  @override
  String stgScanChecking(int scanned, int total) {
    return 'Comprobando $scanned/$total…';
  }

  @override
  String get stgNoServerFound => 'No se ha encontrado ningún servidor Tune';

  @override
  String stgServersFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servidores encontrados',
      one: '1 servidor encontrado',
    );
    return '$_temp0';
  }

  @override
  String get stgTuneServers => 'Servidores Tune';

  @override
  String get stgFieldFormat => 'Formato (FLAC, MP3…)';

  @override
  String get stgFieldSampleRate => 'Frecuencia de muestreo (96 kHz)';

  @override
  String get stgFieldBitDepth => 'Profundidad de bits (24 bits)';

  @override
  String get stgFieldLabel => 'Sello discográfico';

  @override
  String get stgFieldComposer => 'Compositor';

  @override
  String get stgFieldDuration => 'Duración';

  @override
  String get stgFieldSource => 'Fuente (Tidal, Qobuz…)';

  @override
  String get stgMetadataFieldsIntro =>
      'Campos mostrados bajo cada pista (búsqueda, biblioteca, cola, historial)';

  @override
  String get stgAudiophileMode => 'Modo audiófilo';

  @override
  String get stgAudiophileModeDesc =>
      'DSP omitido, EQ desactivado, bit-perfect';

  @override
  String get stgCloudAccount => 'Cuenta en la nube';

  @override
  String stgConnectedAs(String email) {
    return 'Conectado ($email)';
  }

  @override
  String get stgTelemetry => 'Telemetría';

  @override
  String get stgTelemetryDesc => 'Enviar estadísticas de uso anónimas';

  @override
  String get stgSyncingLibrary => 'Sincronizando la biblioteca…';

  @override
  String stgScanProgressTracks(int progress, int total) {
    return '$progress / $total pistas';
  }

  @override
  String get stgConnectingStreaming =>
      'Conectando con los servicios de streaming…';

  @override
  String stgWhatsNewTitle(String version) {
    return 'Novedades de la v$version';
  }

  @override
  String get stgWhatsNewLibrarySync =>
      'Sincronización de la biblioteca mejorada';

  @override
  String get stgWhatsNewMultiRoom =>
      'Multirroom y gestión de zonas optimizados';

  @override
  String get stgWhatsNewBugFixes =>
      'Corrección de errores y mejoras de estabilidad';

  @override
  String get stgStartServerFailed => 'No se pudo iniciar el servidor';

  @override
  String stgStartServerFailedWith(String detail) {
    return 'No se pudo iniciar el servidor: $detail';
  }

  @override
  String get stgConnectionFailed => 'Error de conexión';

  @override
  String stgConnectionFailedWith(String detail) {
    return 'Error de conexión: $detail';
  }

  @override
  String get stgStartingServer => 'Iniciando Tune Server…';

  @override
  String get stgTagline => 'Servidor de música multirroom';

  @override
  String get stgLocalServer => 'Servidor local';

  @override
  String get stgLocalServerDesc =>
      'Ejecuta Tune en este dispositivo.\nTu música, tus reglas.';

  @override
  String get stgRemoteControl => 'Mando a distancia';

  @override
  String get stgRemoteControlDesc => 'Conéctate a un servidor\nTune de tu red.';

  @override
  String get stgRemoteConnection => 'Conexión remota';

  @override
  String get znZoneManagerTitle => 'Gestor de zonas';

  @override
  String get znCannotDeleteLastZone => 'No se puede eliminar la última zona';

  @override
  String znZoneSwitchError(String error) {
    return 'Error al cambiar de zona: $error';
  }

  @override
  String get znZoneSettings => 'Ajustes de la zona';

  @override
  String get znPhoneSpeakers => 'Altavoces del teléfono';

  @override
  String get znBtConnectedOutputs => 'Salidas Bluetooth conectadas';

  @override
  String get znBtSystemOutput =>
      'Usa la salida del sistema (Centro de control)';

  @override
  String get znBtOutputsTitle => 'Salidas Bluetooth';

  @override
  String get znBtNoDevice =>
      'No hay ningún dispositivo Bluetooth conectado. Empareja uno en los ajustes del sistema.';

  @override
  String get znBtAndroidRouting =>
      'El enrutamiento activo depende de los ajustes del sistema Android.';

  @override
  String get znDsdMode => 'Modo DSD';

  @override
  String get znDsdAuto => 'Auto';

  @override
  String get znDsdNative => 'Nativo';

  @override
  String get znGaplessDlnaDesc => 'Transiciones sin cortes entre pistas (DLNA)';

  @override
  String get znFixedVolume => 'Volumen fijo';

  @override
  String get znFixedVolumeDesc =>
      'Desactiva el control de volumen por software';

  @override
  String get znCap16Bit => 'Limitar a 16 bits';

  @override
  String get znCap16BitDesc =>
      'Actívalo si el hi-res (24 bits) no suena pero el de 16 bits sí (Ruark R3). Convierte a FLAC de 16 bits.';

  @override
  String get znZoneMuted => 'Zona silenciada';

  @override
  String get znZoneUnmuted => 'Silencio desactivado';

  @override
  String znErrMute(String error) {
    return 'Error al silenciar: $error';
  }

  @override
  String znErrVolume(String error) {
    return 'Error de volumen: $error';
  }

  @override
  String znErrLatency(String error) {
    return 'Error de latencia: $error';
  }

  @override
  String znErrGroupVolume(String error) {
    return 'Error de volumen del grupo: $error';
  }

  @override
  String get znCalibrationDone => 'Calibración completada';

  @override
  String znErrCalibration(String error) {
    return 'Error de calibración: $error';
  }

  @override
  String znErrDissolve(String error) {
    return 'No se pudo disolver el grupo: $error';
  }

  @override
  String get znRenameGroupTitle => 'Renombrar grupo';

  @override
  String get znNewNameHint => 'Nuevo nombre';

  @override
  String get znRename => 'Renombrar';

  @override
  String get znGroupRenamed => 'Grupo renombrado';

  @override
  String znErrRename(String error) {
    return 'Error al renombrar: $error';
  }

  @override
  String get znGroupNeedTwoZones =>
      'Se necesitan al menos 2 zonas para crear un grupo';

  @override
  String get znGroupNameLabel => 'Nombre del grupo';

  @override
  String get znGroupNameHint => 'p. ej.: Salón + Cocina';

  @override
  String get znChooseLeader => 'Elige el líder';

  @override
  String get znMembers => 'Miembros';

  @override
  String znErrCreateGroup(String error) {
    return 'No se pudo crear el grupo: $error';
  }

  @override
  String get znProfileActivated => 'Perfil activado';

  @override
  String znErrActivate(String error) {
    return 'Error al activar: $error';
  }

  @override
  String get znProfileDeleted => 'Perfil eliminado';

  @override
  String znErrDelete(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get znNoOfflineZones => 'No hay zonas sin conexión que eliminar';

  @override
  String znOfflineZonesRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zonas sin conexión eliminadas',
      one: '1 zona sin conexión eliminada',
    );
    return '$_temp0';
  }

  @override
  String znErrCleanup(String error) {
    return 'Error de limpieza: $error';
  }

  @override
  String get znSaveConfigTitle => 'Guardar configuración';

  @override
  String get znProfileNameLabel => 'Nombre del perfil';

  @override
  String get znProfileNameHint => 'p. ej.: Fiesta, Mañana tranquila';

  @override
  String get znDescriptionOptional => 'Descripción (opcional)';

  @override
  String get znNameRequired => 'El nombre es obligatorio';

  @override
  String get znProfileSaved => 'Perfil guardado';

  @override
  String znErrSave(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get znCleanupOffline => 'Limpiar zonas sin conexión';

  @override
  String get znRemoteRequired =>
      'El gestor de zonas requiere conexión con un servidor remoto.';

  @override
  String get znDataUnavailable => 'Datos no disponibles';

  @override
  String get znGroups => 'Grupos';

  @override
  String get znNoGroups => 'Sin grupos';

  @override
  String get znGroupFallback => 'Grupo';

  @override
  String znZoneFallback(String id) {
    return 'Zona $id';
  }

  @override
  String get znCalibrate => 'Calibrar';

  @override
  String get znDissolve => 'Disolver';

  @override
  String get znProfiles => 'Perfiles';

  @override
  String get znNoProfiles => 'No hay perfiles guardados';

  @override
  String get znSaveConfigButton => 'Guardar config.';

  @override
  String get znProfileFallback => 'Perfil';

  @override
  String get znPins => 'Pines';

  @override
  String znPinFallback(int n) {
    return 'Pin $n';
  }

  @override
  String znPinInvoked(int n) {
    return 'Pin $n iniciado';
  }

  @override
  String znPinInvokeError(String error) {
    return 'No se pudo iniciar el pin: $error';
  }

  @override
  String get znNoPins => 'No hay pines configurados';

  @override
  String get znMute => 'Silenciar';

  @override
  String get znUnmute => 'Activar sonido';

  @override
  String get znLatency => 'Latencia';

  @override
  String get znLatencyError => 'error';

  @override
  String znPartyAddError(String error) {
    return 'No se pudo añadir la pista: $error';
  }

  @override
  String znPartyVoteError(String error) {
    return 'Error al votar: $error';
  }

  @override
  String get znPartyLinkCopied => 'Enlace de la fiesta copiado al portapapeles';

  @override
  String get znPartyTitle => 'Modo fiesta';

  @override
  String get znPartyShareLink => 'Compartir enlace de la fiesta';

  @override
  String get znPartyAddHint => 'Añadir una pista…';

  @override
  String get znPartyQueue => 'Cola';

  @override
  String znTrackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas',
      one: '1 pista',
    );
    return '$_temp0';
  }

  @override
  String get znUnknownZone => 'Zona desconocida';

  @override
  String get znUnknownTitle => 'Desconocido';

  @override
  String get znNowPlaying => 'Reproduciendo';

  @override
  String get znUpvote => 'Votar a favor';

  @override
  String znDjLoadOnDeck(String deck) {
    return 'Cargar pista en el deck $deck';
  }

  @override
  String get znDjSearchHint => 'Buscar pistas…';

  @override
  String get znDjSearchHelp =>
      'Escribe el nombre de una pista y pulsa Buscar y cargar';

  @override
  String get znDjNoTracksFound => 'No se encontraron pistas';

  @override
  String znDjSearchError(String error) {
    return 'Error de búsqueda: $error';
  }

  @override
  String get znDjSearchAndLoad => 'Buscar y cargar';

  @override
  String znDjLoadError(String error) {
    return 'Error de carga: $error';
  }

  @override
  String znDjPlayError(String error) {
    return 'Error de reproducción: $error';
  }

  @override
  String znDjPauseError(String error) {
    return 'Error al pausar: $error';
  }

  @override
  String znDjCrossfadeError(String error) {
    return 'Error de fundido cruzado: $error';
  }

  @override
  String get znDjTitle => 'Modo DJ';

  @override
  String get znDjDisabled => 'El modo DJ está desactivado';

  @override
  String get znDjEnableHint => 'Actívalo para empezar a mezclar';

  @override
  String znDjDeck(String deck) {
    return 'Deck $deck';
  }

  @override
  String get znDjCrossfade => 'Fundido cruzado';

  @override
  String znDjDuration(String seconds) {
    return 'Duración: $seconds s';
  }

  @override
  String get znDjStartCrossfade => 'Iniciar fundido cruzado';

  @override
  String get znDjAutoCrossfade => 'Fundido cruzado automático';

  @override
  String znDjSyncBpm(int bpmFrom, int bpmTo) {
    return 'Sincronizar $bpmFrom → $bpmTo BPM';
  }

  @override
  String get znDjSyncFailed => 'Error de sincronización';

  @override
  String get znDjNoTrackLoaded => 'Ninguna pista cargada';

  @override
  String get znDjLoadTrack => 'Cargar pista';

  @override
  String get znDjGain => 'Ganancia';

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
