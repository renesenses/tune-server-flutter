import 'dart:math';
import 'dart:typed_data';

// ---------------------------------------------------------------------------
// AudioMixer
// PCM mixing for 16/24-bit, volume control, interleave/deinterleave.
// Miroir de audio_mixer.rs (Rust)
// ---------------------------------------------------------------------------

class AudioMixer {
  AudioMixer._();

  // ---------------------------------------------------------------------------
  // Volume
  // ---------------------------------------------------------------------------

  /// Apply volume to 16-bit PCM samples in-place.
  /// [volume] : 0.0 (silent) to 1.0 (full) — values > 1.0 allowed for boost.
  static void applyVolume16(Int16List samples, double volume) {
    if (volume == 1.0) return;
    for (var i = 0; i < samples.length; i++) {
      samples[i] = (samples[i] * volume).round().clamp(-32768, 32767);
    }
  }

  /// Apply volume to 24-bit PCM samples stored as Int32 (sign-extended).
  static void applyVolume24(Int32List samples, double volume) {
    if (volume == 1.0) return;
    const maxVal = (1 << 23) - 1;   //  8388607
    const minVal = -(1 << 23);      // -8388608
    for (var i = 0; i < samples.length; i++) {
      samples[i] = (samples[i] * volume).round().clamp(minVal, maxVal);
    }
  }

  // ---------------------------------------------------------------------------
  // Mixing (sum two sources)
  // ---------------------------------------------------------------------------

  /// Mix two 16-bit PCM buffers into a new buffer.
  /// Both buffers must have the same length.
  /// Applies soft clipping to avoid harsh distortion.
  static Int16List mix16(Int16List a, Int16List b, {
    double volumeA = 1.0,
    double volumeB = 1.0,
  }) {
    final length = min(a.length, b.length);
    final result = Int16List(length);

    for (var i = 0; i < length; i++) {
      final mixed = (a[i] * volumeA + b[i] * volumeB).round();
      result[i] = _softClip16(mixed);
    }

    return result;
  }

  /// Mix two 24-bit PCM buffers (stored as Int32).
  static Int32List mix24(Int32List a, Int32List b, {
    double volumeA = 1.0,
    double volumeB = 1.0,
  }) {
    final length = min(a.length, b.length);
    final result = Int32List(length);

    const maxVal = (1 << 23) - 1;
    const minVal = -(1 << 23);

    for (var i = 0; i < length; i++) {
      final mixed = (a[i] * volumeA + b[i] * volumeB).round();
      result[i] = mixed.clamp(minVal, maxVal);
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Interleave / Deinterleave
  // ---------------------------------------------------------------------------

  /// Interleave separate channel buffers into a single interleaved buffer.
  /// [channels] : list of per-channel sample arrays (e.g. [left, right]).
  static Int16List interleave16(List<Int16List> channels) {
    if (channels.isEmpty) return Int16List(0);

    final channelCount = channels.length;
    final sampleCount = channels[0].length;
    final result = Int16List(sampleCount * channelCount);

    for (var s = 0; s < sampleCount; s++) {
      for (var c = 0; c < channelCount; c++) {
        result[s * channelCount + c] = channels[c][s];
      }
    }

    return result;
  }

  /// Deinterleave an interleaved buffer into separate channel buffers.
  static List<Int16List> deinterleave16(Int16List interleaved, int channelCount) {
    if (channelCount <= 0) return [];

    final sampleCount = interleaved.length ~/ channelCount;
    final channels = List.generate(channelCount, (_) => Int16List(sampleCount));

    for (var s = 0; s < sampleCount; s++) {
      for (var c = 0; c < channelCount; c++) {
        channels[c][s] = interleaved[s * channelCount + c];
      }
    }

    return channels;
  }

  /// Interleave 24-bit channels (stored as Int32).
  static Int32List interleave24(List<Int32List> channels) {
    if (channels.isEmpty) return Int32List(0);

    final channelCount = channels.length;
    final sampleCount = channels[0].length;
    final result = Int32List(sampleCount * channelCount);

    for (var s = 0; s < sampleCount; s++) {
      for (var c = 0; c < channelCount; c++) {
        result[s * channelCount + c] = channels[c][s];
      }
    }

    return result;
  }

  /// Deinterleave 24-bit buffer (stored as Int32).
  static List<Int32List> deinterleave24(Int32List interleaved, int channelCount) {
    if (channelCount <= 0) return [];

    final sampleCount = interleaved.length ~/ channelCount;
    final channels = List.generate(channelCount, (_) => Int32List(sampleCount));

    for (var s = 0; s < sampleCount; s++) {
      for (var c = 0; c < channelCount; c++) {
        channels[c][s] = interleaved[s * channelCount + c];
      }
    }

    return channels;
  }

  // ---------------------------------------------------------------------------
  // Byte conversion
  // ---------------------------------------------------------------------------

  /// Convert raw PCM bytes (little-endian 16-bit) to Int16List.
  static Int16List bytesToInt16(Uint8List bytes) {
    return bytes.buffer.asInt16List(bytes.offsetInBytes, bytes.length ~/ 2);
  }

  /// Convert Int16List back to raw PCM bytes (little-endian).
  static Uint8List int16ToBytes(Int16List samples) {
    return Uint8List.view(samples.buffer, samples.offsetInBytes, samples.length * 2);
  }

  /// Convert raw PCM bytes (little-endian 24-bit packed) to Int32List (sign-extended).
  static Int32List bytesToInt24(Uint8List bytes) {
    final sampleCount = bytes.length ~/ 3;
    final samples = Int32List(sampleCount);

    for (var i = 0; i < sampleCount; i++) {
      final offset = i * 3;
      var value = bytes[offset] | (bytes[offset + 1] << 8) | (bytes[offset + 2] << 16);
      // Sign extend from 24 to 32 bits
      if (value & 0x800000 != 0) {
        value |= 0xFF000000;
      }
      samples[i] = value;
    }

    return samples;
  }

  /// Convert Int32List (24-bit values) back to packed 24-bit PCM bytes.
  static Uint8List int24ToBytes(Int32List samples) {
    final bytes = Uint8List(samples.length * 3);

    for (var i = 0; i < samples.length; i++) {
      final offset = i * 3;
      final value = samples[i];
      bytes[offset] = value & 0xFF;
      bytes[offset + 1] = (value >> 8) & 0xFF;
      bytes[offset + 2] = (value >> 16) & 0xFF;
    }

    return bytes;
  }

  // ---------------------------------------------------------------------------
  // Fade
  // ---------------------------------------------------------------------------

  /// Apply a linear fade to 16-bit PCM samples.
  /// [startVolume] to [endVolume] over the entire buffer length.
  static void linearFade16(Int16List samples, double startVolume, double endVolume) {
    if (samples.isEmpty) return;
    final step = (endVolume - startVolume) / samples.length;

    for (var i = 0; i < samples.length; i++) {
      final volume = startVolume + step * i;
      samples[i] = (samples[i] * volume).round().clamp(-32768, 32767);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Soft clipping for 16-bit samples — tanh-style curve near max.
  static int _softClip16(int sample) {
    const threshold = 24576; // 75% of 32767
    if (sample.abs() <= threshold) return sample.clamp(-32768, 32767);

    // Smooth curve above threshold
    final sign = sample > 0 ? 1 : -1;
    final abs = sample.abs();
    final over = (abs - threshold).toDouble();
    final compressed = threshold + (over / (1.0 + over / (32767 - threshold))).round();
    return (sign * compressed).clamp(-32768, 32767);
  }
}
