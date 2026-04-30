// HTTP-level tests for TuneApiClient using package:http/testing's MockClient.
// Verify each method hits the right URL with the right method/body and parses
// the response correctly. Establishes the baseline before splitting the
// 1500-line client into per-domain modules.
//
// Run with : flutter test test/services/tune_api_client_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tune_server/services/tune_api_client.dart';

void main() {
  const baseUrl = 'http://test.local/api/v1';

  /// Helper : build a TuneApiClient backed by a MockClient that asserts the
  /// request and returns the given body+status.
  TuneApiClient mockClient({
    required void Function(http.Request) verify,
    required Object responseBody,
    int statusCode = 200,
  }) {
    final client = MockClient((http.Request request) async {
      verify(request);
      return http.Response(jsonEncode(responseBody), statusCode);
    });
    return TuneApiClient.withClient(baseUrl, client);
  }

  group('Zones', () {
    test('getZones GETs /zones and parses array', () async {
      final api = mockClient(
        verify: (req) {
          expect(req.method, 'GET');
          expect(req.url.path, '/api/v1/zones');
        },
        responseBody: [
          {'id': 1, 'name': 'Salon'},
          {'id': 2, 'name': 'Cuisine'},
        ],
      );
      final zones = await api.getZones();
      expect(zones.length, 2);
      expect(zones[0]['name'], 'Salon');
    });

    test('getZone GETs /zones/<id>', () async {
      final api = mockClient(
        verify: (req) => expect(req.url.path, '/api/v1/zones/42'),
        responseBody: {'id': 42, 'name': 'Bureau'},
      );
      final zone = await api.getZone(42);
      expect(zone['id'], 42);
    });

    test('non-200 throws', () async {
      final api = mockClient(
        verify: (_) {},
        responseBody: 'oops',
        statusCode: 500,
      );
      expect(() => api.getZones(), throwsException);
    });
  });

  group('Playback', () {
    test('pause POSTs /zones/<id>/pause with no body', () async {
      final api = mockClient(
        verify: (req) {
          expect(req.method, 'POST');
          expect(req.url.path, '/api/v1/zones/1/pause');
          expect(req.body, isEmpty);
        },
        responseBody: {'ok': true},
      );
      await api.pause(1);
    });

    test('seek POSTs JSON body', () async {
      final api = mockClient(
        verify: (req) {
          expect(req.url.path, '/api/v1/zones/1/seek');
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['position_ms'], 12345);
        },
        responseBody: {'ok': true},
      );
      await api.seek(1, 12345);
    });

    test('setVolume POSTs volume value', () async {
      final api = mockClient(
        verify: (req) {
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['volume'], 0.5);
        },
        responseBody: {'ok': true},
      );
      await api.setVolume(1, 0.5);
    });
  });
}
