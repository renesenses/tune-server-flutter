/// Enums de base — miroir de Enums.swift (iOS)

enum Source {
  local,
  tidal,
  qobuz,
  youtube,
  amazon,
  spotify,
  deezer,
  radio;

  String get displayName {
    switch (this) {
      case Source.local:   return 'Local';
      case Source.tidal:   return 'Tidal';
      case Source.qobuz:   return 'Qobuz';
      case Source.youtube: return 'YouTube';
      case Source.amazon:  return 'Amazon';
      case Source.spotify: return 'Spotify';
      case Source.deezer:  return 'Deezer';
      case Source.radio:   return 'Radio';
    }
  }

  String get rawValue => name;

  static Source? fromRawValue(String value) {
    try {
      return Source.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

enum AudioFormat {
  flac,
  wav,
  mp3,
  aac,
  alac,
  ogg,
  opus,
  dsd,
  aiff,
  wma;

  String get rawValue => name;

  static AudioFormat? fromRawValue(String value) {
    try {
      return AudioFormat.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

enum PlaybackState {
  stopped,
  playing,
  paused,
  buffering;

  String get rawValue => name;

  static PlaybackState? fromRawValue(String value) {
    try {
      return PlaybackState.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

enum RepeatMode {
  off,
  one,
  all;

  String get rawValue => name;

  static RepeatMode? fromRawValue(String value) {
    try {
      return RepeatMode.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

enum OutputType {
  local,
  dlna,
  airplay,
  bluetooth;

  String get rawValue => name;

  static OutputType? fromRawValue(String value) {
    try {
      return OutputType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

enum ConnectionState {
  disconnected,
  connecting,
  connected,
}
