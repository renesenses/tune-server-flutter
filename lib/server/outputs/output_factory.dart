import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../models/enums.dart';
import '../audio/local_audio_output.dart';
import '../discovery/discovery_manager.dart';
import 'airplay_output.dart';
import 'bluos_output.dart';
import 'chromecast_output.dart';
import 'dlna_output.dart';
import 'openhome_output.dart';
import 'output_target.dart';

// ---------------------------------------------------------------------------
// T4.5 — OutputFactory
// Instancie le bon OutputTarget selon OutputType et Platform.isIOS.
// Miroir de OutputFactory.swift (iOS)
// ---------------------------------------------------------------------------

class OutputFactory {
  OutputFactory._();

  /// Crée l'output approprié pour le [type] et le [device] fournis.
  ///
  /// [device] est requis pour DLNA et BluOS (contient host/port).
  /// Sur Android, OutputType.airplay est redirigé vers Local.
  static OutputTarget create({
    required OutputType type,
    DiscoveredDevice? device,
    String localIp = 'localhost',
  }) {
    switch (type) {
      case OutputType.local:
        return LocalAudioOutput();

      case OutputType.dlna:
        if (device == null) {
          debugPrint('[output_factory] DLNA requested but no device — fallback to Local');
          return LocalAudioOutput(displayName: 'Local (fallback)');
        }
        // Prefer OpenHome output if the device has OpenHome services
        if (device.capabilities.hasOpenHome) {
          debugPrint('[output_factory] Using OpenHome output for ${device.name}');
          return OpenHomeOutput(
            id: device.id,
            displayName: device.name,
            host: device.host,
            port: device.port,
            productUrl: device.capabilities.openHomeProductUrl,
            volumeUrl: device.capabilities.openHomeVolumeUrl,
            transportUrl: device.capabilities.openHomeTransportUrl,
            playlistUrl: device.capabilities.openHomePlaylistUrl,
            timeUrl: device.capabilities.openHomeTimeUrl,
          );
        }
        final avUrl = device.capabilities.avTransportControlUrl;
        if (avUrl == null) {
          return LocalAudioOutput(displayName: 'Local (no AVTransport)');
        }
        return DLNAOutput(
          id: device.id,
          displayName: device.name,
          avTransportUrl: avUrl,
          renderingControlUrl: device.capabilities.renderingControlUrl,
        );

      case OutputType.airplay:
      case OutputType.airplay2:
        if (Platform.isIOS) {
          return AirPlayOutput();
        }
        // AirPlay non disponible sur Android → Local
        return LocalAudioOutput(displayName: 'Local (AirPlay non dispo)');

      case OutputType.bluetooth:
        // Bluetooth géré par le système audio → Local suffit
        return LocalAudioOutput(displayName: 'Bluetooth');

      case OutputType.bluos:
        if (device == null) {
          debugPrint('[output_factory] BluOS requested but no device — fallback to Local');
          return LocalAudioOutput(displayName: 'Local (fallback)');
        }
        return BluOSOutput(
          id: device.id,
          displayName: device.name,
          host: device.host,
          port: device.port,
        );

      case OutputType.chromecast:
        if (device == null) {
          debugPrint('[output_factory] Chromecast requested but no device — fallback to Local');
          return LocalAudioOutput(displayName: 'Local (fallback)');
        }
        return ChromecastOutput(
          id: device.id,
          displayName: device.name,
          host: device.host,
          port: device.port,
        );

      case OutputType.openhome:
        if (device == null) {
          debugPrint('[output_factory] OpenHome requested but no device — fallback to Local');
          return LocalAudioOutput(displayName: 'Local (fallback)');
        }
        return OpenHomeOutput(
          id: device.id,
          displayName: device.name,
          host: device.host,
          port: device.port,
          productUrl: device.capabilities.openHomeProductUrl,
          volumeUrl: device.capabilities.openHomeVolumeUrl,
          transportUrl: device.capabilities.openHomeTransportUrl,
          playlistUrl: device.capabilities.openHomePlaylistUrl,
          timeUrl: device.capabilities.openHomeTimeUrl,
        );

      case OutputType.squeezebox:
        // Squeezebox/LMS — handled by Rust server, Flutter acts as remote
        return LocalAudioOutput(displayName: 'Squeezebox');

      case OutputType.oaat:
        // OAAT — handled by Rust server, Flutter acts as remote
        return LocalAudioOutput(displayName: 'OAAT');
    }
  }

  /// Liste les types d'output disponibles sur la plateforme courante.
  static List<OutputType> availableTypes() {
    return [
      OutputType.local,
      OutputType.dlna,
      OutputType.bluos,
      if (Platform.isIOS) OutputType.airplay,
      OutputType.bluetooth,
    ];
  }
}
