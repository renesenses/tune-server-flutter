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

  const UPnPCapabilities({
    this.contentDirectoryControlUrl,
    this.avTransportControlUrl,
    this.renderingControlUrl,
  });

  bool get hasContentDirectory => contentDirectoryControlUrl != null;
  bool get hasAvTransport => avTransportControlUrl != null;

  /// Renderer DLNA = AVTransport présent.
  bool get isRenderer => hasAvTransport;

  /// Serveur UPnP = ContentDirectory présent.
  bool get isServer => hasContentDirectory;

  Map<String, dynamic> toJson() => {
        if (contentDirectoryControlUrl != null)
          'contentDirectory': contentDirectoryControlUrl,
        if (avTransportControlUrl != null)
          'avTransport': avTransportControlUrl,
        if (renderingControlUrl != null)
          'renderingControl': renderingControlUrl,
      };

  factory UPnPCapabilities.fromJson(Map<String, dynamic> json) =>
      UPnPCapabilities(
        contentDirectoryControlUrl: json['contentDirectory'] as String?,
        avTransportControlUrl: json['avTransport'] as String?,
        renderingControlUrl: json['renderingControl'] as String?,
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

    final serviceList = _find(device, 'serviceList');
    if (serviceList == null) return const UPnPCapabilities();

    for (final service in serviceList.findElements('service')) {
      final type = _text(service, 'serviceType') ?? '';
      final controlUrl = _text(service, 'controlURL');
      if (controlUrl == null) continue;

      final resolved = _resolveUrl(controlUrl, baseUrl);

      if (type.contains('ContentDirectory')) {
        cdUrl = resolved;
      } else if (type.contains('AVTransport')) {
        avtUrl = resolved;
      } else if (type.contains('RenderingControl')) {
        rcUrl = resolved;
      }
    }

    return UPnPCapabilities(
      contentDirectoryControlUrl: cdUrl,
      avTransportControlUrl: avtUrl,
      renderingControlUrl: rcUrl,
    );
  }

  static UPnPCapabilities _mergeEmbeddedDevices(
      XmlElement root, UPnPCapabilities base, String baseUrl) {
    var cdUrl = base.contentDirectoryControlUrl;
    var avtUrl = base.avTransportControlUrl;
    var rcUrl = base.renderingControlUrl;

    final deviceList = _find(root, 'deviceList');
    if (deviceList == null) {
      return base;
    }

    for (final embedded in deviceList.findElements('device')) {
      final caps = _parseServices(embedded, baseUrl);
      cdUrl ??= caps.contentDirectoryControlUrl;
      avtUrl ??= caps.avTransportControlUrl;
      rcUrl ??= caps.renderingControlUrl;
    }

    return UPnPCapabilities(
      contentDirectoryControlUrl: cdUrl,
      avTransportControlUrl: avtUrl,
      renderingControlUrl: rcUrl,
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
