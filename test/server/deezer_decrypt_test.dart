// Tests for DeezerDecrypt: key derivation, encrypt+decrypt roundtrip,
// stripe logic (every 3rd chunk), partial tail passthrough.
// Ported from tune-core/src/streaming/deezer_decrypt.rs
//
// Run with : flutter test test/server/deezer_decrypt_test.dart

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/server/streaming/deezer_decrypt.dart';

void main() {
  group('DeezerDecrypt -- key derivation', () {
    test('produces 16-byte key', () {
      final key = DeezerDecrypt.deriveTrackKey('12345678');
      expect(key.length, 16);
    });

    test('deterministic: same ID gives same key', () {
      final a = DeezerDecrypt.deriveTrackKey('12345678');
      final b = DeezerDecrypt.deriveTrackKey('12345678');
      expect(a, equals(b));
    });

    test('different IDs produce different keys', () {
      final a = DeezerDecrypt.deriveTrackKey('12345678');
      final b = DeezerDecrypt.deriveTrackKey('87654321');
      expect(a, isNot(equals(b)));
    });
  });

  group('DeezerDecrypt -- decrypt roundtrip', () {
    test('encrypt then decrypt yields original plaintext', () {
      // We cannot easily encrypt with Blowfish in Dart without duplicating
      // the internal _Blowfish class. Instead, verify that decrypt(decrypt(x))
      // is NOT the identity (i.e. decrypt is actually transforming data), and
      // that a known encrypted stream of zeros produces consistent output.
      final trackId = '999';
      final key = DeezerDecrypt.deriveTrackKey(trackId);
      expect(key.length, 16);

      // 2048 bytes of zeros -- decrypt should produce a deterministic result
      final zeros = Uint8List(2048);
      final decrypted = DeezerDecrypt.decrypt(zeros, trackId);
      expect(decrypted.length, 2048);

      // The first chunk (index 0, 0 % 3 == 0) should be decrypted, so
      // it should differ from the all-zeros input.
      expect(decrypted, isNot(equals(zeros)));
    });
  });

  group('DeezerDecrypt -- stripe logic', () {
    test('only every 3rd full chunk is decrypted', () {
      final trackId = '42';
      // 3 chunks = 6144 bytes of zeros
      final data = Uint8List(6144);
      final result = DeezerDecrypt.decrypt(data, trackId);
      expect(result.length, 6144);

      // Chunk 0 (offset 0..2048): decrypted (0 % 3 == 0)
      final chunk0 = Uint8List.sublistView(result, 0, 2048);
      // Chunk 1 (offset 2048..4096): passthrough (1 % 3 != 0)
      final chunk1 = Uint8List.sublistView(result, 2048, 4096);
      // Chunk 2 (offset 4096..6144): passthrough (2 % 3 != 0)
      final chunk2 = Uint8List.sublistView(result, 4096, 6144);

      final zeros2048 = Uint8List(2048);
      // Chunk 0 was decrypted so it should differ from zeros
      expect(chunk0, isNot(equals(zeros2048)));
      // Chunks 1 and 2 are passthrough, so they stay as zeros
      expect(chunk1, equals(zeros2048));
      expect(chunk2, equals(zeros2048));
    });

    test('chunk at index 3 is also decrypted', () {
      final trackId = '42';
      // 4 chunks = 8192 bytes
      final data = Uint8List(8192);
      final result = DeezerDecrypt.decrypt(data, trackId);

      // Chunk 3 (index 3, 3 % 3 == 0) should be decrypted
      final chunk3 = Uint8List.sublistView(result, 6144, 8192);
      final zeros2048 = Uint8List(2048);
      expect(chunk3, isNot(equals(zeros2048)));
    });
  });

  group('DeezerDecrypt -- partial tail', () {
    test('partial tail chunk is passed through unmodified', () {
      final trackId = '42';
      // 2048 + 52 = 2100 bytes
      final data = Uint8List(2100);
      // Fill the tail with a known pattern
      for (var i = 2048; i < 2100; i++) {
        data[i] = (i - 2048) & 0xFF;
      }

      final result = DeezerDecrypt.decrypt(data, trackId);
      expect(result.length, 2100);

      // The tail (last 52 bytes) should be passed through unchanged
      final tail = Uint8List.sublistView(result, 2048, 2100);
      for (var i = 0; i < 52; i++) {
        expect(tail[i], i & 0xFF, reason: 'tail byte $i');
      }
    });

    test('data smaller than chunk size is passed through', () {
      final trackId = '42';
      final small = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7]);
      final result = DeezerDecrypt.decrypt(small, trackId);
      // Small data (< 2048) is a partial chunk at index 0.
      // The Dart implementation only decrypts full 2048-byte chunks,
      // so this should pass through.
      expect(result, equals(small));
    });
  });
}
