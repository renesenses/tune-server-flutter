import 'package:xml/xml.dart';

// ---------------------------------------------------------------------------
// T3.2 — UPnPDeviceParser
// Parse le XML de description d'un device UPnP (device description document).
// Miroir de UPnPDeviceParser.swift (iOS)
//
// Extrait :
//   - friendlyName, deviceType, UDN, manufacturer, modelName
//   - capabilities : ContentDirectory, AVTransport (URLs SOAP)
//   - iconUrl (pochette du device si disponible)
// ---------------------------------------------------------------------------

/// Capabilities d'un device UPnP.
class UPnPCapabilities {
  final String? contentDirectoryControlUrl;
  final String? avTransportControlUrl;
  final String? renderingControlUrl;

  // OpenHome service URLs
  final String? openHomeProductUrl;
  final String? openHomeVolumeUrl;
  final String? openHomeTransportUrl;
  final String? openHomePlaylistUrl;
  final String? openHomeInfoUrl;
  final String? openHomeTimeUrl;

  const UPnPCapabilities({
    this.contentDirectoryControlUrl,
    this.avTransportControlUrl,
    this.renderingControlUrl,
    this.openHomeProductUrl,
    this.openHomeVolumeUrl,
    this.openHomeTransportUrl,
    this.openHomePlaylistUrl,
    this.openHomeInfoUrl,
    this.openHomeTimeUrl,
  });

  bool get hasContentDirectory => contentDirectoryControlUrl != null;
  bool get hasAvTransport => avTransportControlUrl != null;
  bool get hasOpenHome =>
      openHomeProductUrl != null ||
      openHomeTransportUrl != null ||
      openHomePlaylistUrl != null;

  /// Renderer DLNA = AVTransport présent, or OpenHome renderer.
  bool get isRenderer => hasAvTransport || hasOpenHome;

  /// Serveur UPnP = ContentDirectory présent.
  bool get isServer => hasContentDirectory;

  Map<String, dynamic> toJson() => {
        if (contentDirectoryControlUrl != null)
          'contentDirectory': contentDirectoryControlUrl,
        if (avTransportControlUrl != null)
          'avTransport': avTransportControlUrl,
        if (renderingControlUrl != null)
          'renderingControl': renderingControlUrl,
        if (openHomeProductUrl != null) 'ohProduct': openHomeProductUrl,
        if (openHomeVolumeUrl != null) 'ohVolume': openHomeVolumeUrl,
        if (openHomeTransportUrl != null) 'ohTransport': openHomeTransportUrl,
        if (openHomePlaylistUrl != null) 'ohPlaylist': openHomePlaylistUrl,
        if (openHomeInfoUrl != null) 'ohInfo': openHomeInfoUrl,
        if (openHomeTimeUrl != null) 'ohTime': openHomeTimeUrl,
      };

  factory UPnPCapabilities.fromJson(Map<String, dynamic> json) =>
      UPnPCapabilities(
        contentDirectoryControlUrl: json['contentDirectory'] as String?,
        avTransportControlUrl: json['avTransport'] as String?,
        renderingControlUrl: json['renderingControl'] as String?,
        openHomeProductUrl: json['ohProduct'] as String?,
        openHomeVolumeUrl: json['ohVolume'] as String?,
        openHomeTransportUrl: json['ohTransport'] as String?,
        openHomePlaylistUrl: json['ohPlaylist'] as String?,
        openHomeInfoUrl: json['ohInfo'] as String?,
        openHomeTimeUrl: json['ohTime'] as String?,
      );
}

/// Résultat du parsing d'un device UPnP.
class UPnPDevice {
  final String udn;           // Unique Device Name (uuid:…)
  final String friendlyName;
  final String deviceType;
  final String? manufacturer;
  final String? modelName;
  final String? iconUrl;
  final UPnPCapabilities capabilities;
  final String baseUrl;       // URL de base pour résoudre les URLs relatives

  const UPnPDevice({
    required this.udn,
    required this.friendlyName,
    required this.deviceType,
    required this.capabilities,
    required this.baseUrl,
    this.manufacturer,
    this.modelName,
    this.iconUrl,
  });

  /// Identifiant stable — même format que DiscoveredDevice.id
  String get id => udn.isNotEmpty ? udn : friendlyName;
}

// ---------------------------------------------------------------------------
// DSD-capable device detection — known brands that support native DSF/DFF
// but often don't report it via GetProtocolInfo.
// Mirrors _DSD_CAPABLE_PATTERNS in tune-server-linux/audio/formats.py.
// ---------------------------------------------------------------------------

const _dsdCapablePatterns = [
  'dmp-a',      // Eversolo DMP-A8, DMP-A6
  'eversolo',
  'marantz',    // Marantz AVRs/streamers (SR7009, PM-10, SA-10, etc.)
  'denon',      // Denon AVRs/streamers (AVR-X series, DNP-800NE, etc.)
  'heos',       // Denon/Marantz HEOS platform
  'oppo',       // Oppo UDP/BDP
  'cambridge',  // Cambridge Audio
  'naim',       // Naim streamers
  'linn',       // Linn DS/DSM
  'lumin',      // Lumin streamers
  'auralic',    // Auralic Aries
  'micromega',  // Micromega M-One (ESS Sabre DAC)
  'diretta',    // DirettaRendererUPnP (DSD64-DSD1024)
  'wiim',       // WiiM Ultra/Pro
  'pioneer',    // Pioneer/Onkyo network players
  'onkyo',      // Onkyo AVRs with DSD support
  'yamaha',     // Yamaha WXC/WXA/R-N series
  'teac',       // TEAC NT/UD series
  'sony',       // Sony HAP/UDA series
  'technics',   // Technics SL-G700, SA-C600, etc.
  't+a',        // T+A DAC 8 DSD, MP series
  'esoteric',   // Esoteric network players
  'mcintosh',   // McIntosh network streamers
  'accuphase',  // Accuphase DP/DC series
  'ps audio',   // PS Audio DirectStream
];

/// Heuristic: check device name/model/manufacturer against known DSD-capable
/// device patterns.
bool detectDsdFromDeviceInfo(String name, String? model, String? manufacturer) {
  final combined = '$name ${model ?? ''} ${manufacturer ?? ''}'.toLowerCase();
  return _dsdCapablePatterns.any((p) => combined.contains(p));
}

class UPnPDeviceParser {
  UPnPDeviceParser._();

  /// Parse le XML de description d'un device UPnP.
  /// [xmlString] : contenu du document XML récupéré à la LOCATION SSDP.
  /// [baseUrl]   : URL de base pour résoudre les controlURL relatives.
  static UPnPDevice? parse(String xmlString, String baseUrl) {
    try {
      final doc = XmlDocument.parse(xmlString);
      final root = doc.rootElement;

      // Namespace UPnP commun (peut varier selon le device)
      final deviceEl = _find(root, 'device');
      if (deviceEl == null) return null;

      final udn = _text(deviceEl, 'UDN') ?? '';
      final friendlyName = _text(deviceEl, 'friendlyName') ?? 'Unknown Device';
      final deviceType = _text(deviceEl, 'deviceType') ?? '';
      final manufacturer = _text(deviceEl, 'manufacturer');
      final modelName = _text(deviceEl, 'modelName');

      // Icône (premier icon de la liste)
      final iconUrl = _parseIconUrl(deviceEl, baseUrl);

      // Services
      final capabilities = _parseServices(deviceEl, baseUrl);

      // Devices embarqués (embedded devices — ex: serveur avec renderer intégré)
      // On prend les capabilities des sous-devices aussi
      final merged = _mergeEmbeddedDevices(deviceEl, capabilities, baseUrl);

      return UPnPDevice(
        udn: udn,
        friendlyName: friendlyName,
        deviceType: deviceType,
        manufacturer: manufacturer,
        modelName: modelName,
        iconUrl: iconUrl,
        capabilities: merged,
        baseUrl: baseUrl,
      );
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Parsing services
  // ---------------------------------------------------------------------------

  static UPnPCapabilities _parseServices(XmlElement device, String baseUrl) {
    String? cdUrl, avtUrl, rcUrl;
    String? ohProductUrl, ohVolumeUrl, ohTransportUrl;
    String? ohPlaylistUrl, ohInfoUrl, ohTimeUrl;

    final serviceList = _find(device, 'serviceList');
    if (serviceList == null) return const UPnPCapabilities();

    for (final service in serviceList.findElements('service')) {
      final type = _text(service, 'serviceType') ?? '';
      final controlUrl = _text(service, 'controlURL');
      if (controlUrl == null) continue;

      final resolved = _resolveUrl(controlUrl, baseUrl);

      // UPnP/DLNA services
      if (type.contains('ContentDirectory')) {
        cdUrl = resolved;
      } else if (type.contains('AVTransport')) {
        avtUrl = resolved;
      } else if (type.contains('RenderingControl')) {
        rcUrl = resolved;
      }
      // OpenHome services (urn:av-openhome-org:service:*)
      else if (type.contains('av-openhome-org')) {
        if (type.contains('Product')) ohProductUrl = resolved;
        if (type.contains('Volume')) ohVolumeUrl = resolved;
        if (type.contains('Transport')) ohTransportUrl = resolved;
        if (type.contains('Playlist')) ohPlaylistUrl = resolved;
        if (type.contains('Info')) ohInfoUrl = resolved;
        if (type.contains('Time')) ohTimeUrl = resolved;
      }
    }

    return UPnPCapabilities(
      contentDirectoryControlUrl: cdUrl,
      avTransportControlUrl: avtUrl,
      renderingControlUrl: rcUrl,
      openHomeProductUrl: ohProductUrl,
      openHomeVolumeUrl: ohVolumeUrl,
      openHomeTransportUrl: ohTransportUrl,
      openHomePlaylistUrl: ohPlaylistUrl,
      openHomeInfoUrl: ohInfoUrl,
      openHomeTimeUrl: ohTimeUrl,
    );
  }

  static UPnPCapabilities _mergeEmbeddedDevices(
      XmlElement root, UPnPCapabilities base, String baseUrl) {
    var cdUrl = base.contentDirectoryControlUrl;
    var avtUrl = base.avTransportControlUrl;
    var rcUrl = base.renderingControlUrl;
    var ohProductUrl = base.openHomeProductUrl;
    var ohVolumeUrl = base.openHomeVolumeUrl;
    var ohTransportUrl = base.openHomeTransportUrl;
    var ohPlaylistUrl = base.openHomePlaylistUrl;
    var ohInfoUrl = base.openHomeInfoUrl;
    var ohTimeUrl = base.openHomeTimeUrl;

    final deviceList = _find(root, 'deviceList');
    if (deviceList == null) {
      return base;
    }

    for (final embedded in deviceList.findElements('device')) {
      final caps = _parseServices(embedded, baseUrl);
      cdUrl ??= caps.contentDirectoryControlUrl;
      avtUrl ??= caps.avTransportControlUrl;
      rcUrl ??= caps.renderingControlUrl;
      ohProductUrl ??= caps.openHomeProductUrl;
      ohVolumeUrl ??= caps.openHomeVolumeUrl;
      ohTransportUrl ??= caps.openHomeTransportUrl;
      ohPlaylistUrl ??= caps.openHomePlaylistUrl;
      ohInfoUrl ??= caps.openHomeInfoUrl;
      ohTimeUrl ??= caps.openHomeTimeUrl;
    }

    return UPnPCapabilities(
      contentDirectoryControlUrl: cdUrl,
      avTransportControlUrl: avtUrl,
      renderingControlUrl: rcUrl,
      openHomeProductUrl: ohProductUrl,
      openHomeVolumeUrl: ohVolumeUrl,
      openHomeTransportUrl: ohTransportUrl,
      openHomePlaylistUrl: ohPlaylistUrl,
      openHomeInfoUrl: ohInfoUrl,
      openHomeTimeUrl: ohTimeUrl,
    );
  }

  // ---------------------------------------------------------------------------
  // Parsing icône
  // ---------------------------------------------------------------------------

  static String? _parseIconUrl(XmlElement device, String baseUrl) {
    final iconList = _find(device, 'iconList');
    if (iconList == null) return null;

    // Préfère PNG > JPEG, prend le plus grand
    XmlElement? best;
    int bestSize = 0;

    for (final icon in iconList.findElements('icon')) {
      final mime = _text(icon, 'mimetype') ?? '';
      final w = int.tryParse(_text(icon, 'width') ?? '') ?? 0;
      final h = int.tryParse(_text(icon, 'height') ?? '') ?? 0;
      final size = w * h;

      if (size > bestSize) {
        bestSize = size;
        best = icon;
      } else if (size == bestSize && mime.contains('png')) {
        best = icon;
      }
    }

    final url = best != null ? _text(best, 'url') : null;
    if (url == null) return null;
    return _resolveUrl(url, baseUrl);
  }

  // ---------------------------------------------------------------------------
  // Helpers XML
  // ---------------------------------------------------------------------------

  static XmlElement? _find(XmlElement parent, String localName) {
    try {
      return parent.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.localName == localName);
    } catch (_) {
      return null;
    }
  }

  static String? _text(XmlElement parent, String localName) {
    try {
      return parent.descendants
          .whereType<XmlElement>()
          .firstWhere((e) => e.localName == localName)
          .innerText
          .trim();
    } catch (_) {
      return null;
    }
  }

  static String _resolveUrl(String url, String baseUrl) {
    if (url.startsWith('http')) return url;
    final base = Uri.parse(baseUrl);
    if (url.startsWith('/')) {
      return '${base.scheme}://${base.host}:${base.port}$url';
    }
    return '${base.scheme}://${base.host}:${base.port}/$url';
  }
}
