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
  String get tabGenres => 'Géneros';

  @override
  String get tabPlaylists => 'Listas';

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
  String get playlistDeleteTitle => '¿Eliminar lista?';

  @override
  String get playlistDeleteBody => 'Esta lista se eliminará permanentemente.';

  @override
  String get searchHint => 'Buscar…';

  @override
  String get searchNoResults => 'Sin resultados';

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
  String get queueEmpty => 'Cola vacía';

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
}
