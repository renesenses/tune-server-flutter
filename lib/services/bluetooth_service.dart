import 'dart:io';

import 'package:flutter/services.dart';

class BluetoothAudioDevice {
  final String id;
  final String name;
  final String type; // 'a2dp' | 'sco' | 'other'

  const BluetoothAudioDevice({
    required this.id,
    required this.name,
    required this.type,
  });

  factory BluetoothAudioDevice.fromMap(Map<dynamic, dynamic> map) {
    return BluetoothAudioDevice(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Bluetooth',
      type: map['type']?.toString() ?? 'other',
    );
  }
}

/// Enumerates currently connected Bluetooth audio outputs on Android.
/// Always returns an empty list on iOS/macOS — Apple platforms do not expose
/// a public API for this; audio is routed to the user-selected BT device via
/// system settings (Control Center).
class BluetoothService {
  static const _channel = MethodChannel('com.mozaiklabs.tuneserver/bluetooth');

  Future<List<BluetoothAudioDevice>> listDevices() async {
    if (!Platform.isAndroid) return const [];
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('listDevices');
      if (result == null) return const [];
      return result
          .whereType<Map>()
          .map((m) => BluetoothAudioDevice.fromMap(m))
          .toList();
    } on MissingPluginException {
      return const [];
    } catch (_) {
      return const [];
    }
  }
}
