import 'dart:io';

import '../../models/enums.dart';
import '../audio/local_audio_output.dart';
import '../discovery/discovery_manager.dart';
import 'airplay_output.dart';
import 'dlna_output.dart';
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
  /// [device] est requis pour DLNA (contient les URLs SOAP).
  /// Sur Android, OutputType.airPlay est redirigé vers Local.
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
          // Pas de device → fallback local
          return LocalAudioOutput(displayName: 'Local (fallback)');
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

      case OutputType.airPlay:
        if (Platform.isIOS) {
          return AirPlayOutput();
        }
        // AirPlay non disponible sur Android → Local
        return LocalAudioOutput(displayName: 'Local (AirPlay non dispo)');

      case OutputType.bluetooth:
        // Bluetooth géré par le système audio → Local suffit
        return LocalAudioOutput(displayName: 'Bluetooth');
    }
  }

  /// Liste les types d'output disponibles sur la plateforme courante.
  static List<OutputType> availableTypes() {
    return [
      OutputType.local,
      OutputType.dlna,
      if (Platform.isIOS) OutputType.airPlay,
      OutputType.bluetooth,
    ];
  }
}
