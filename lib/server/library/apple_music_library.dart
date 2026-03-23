import 'dart:io';

import 'package:flutter/services.dart';

import '../database/database.dart';
import 'metadata_reader.dart';

// ---------------------------------------------------------------------------
// T7.5 — AppleMusicLibrary
// Platform channel iOS → MPMediaLibrary (bibliothèque iPod/Apple Music locale).
// Masqué sur Android (guard Platform.isIOS dans LibraryScanner / ServerEngine).
// Miroir de AppleMusicLibrary.swift (iOS)
// ---------------------------------------------------------------------------

class AppleMusicLibrary {
  static const _channel =
      MethodChannel('com.mozaiklabs.tuneserver/apple_music');

  const AppleMusicLibrary()
      : assert(true, 'Vérifier Platform.isIOS avant instanciation');

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  /// Retourne l'état d'autorisation actuel (sans le demander).
  Future<String> authorizationStatus() async {
    if (!Platform.isIOS) return 'restricted';
    try {
      return await _channel.invokeMethod<String>('authorizationStatus') ??
          'notDetermined';
    } on PlatformException {
      return 'notDetermined';
    }
  }

  /// Demande l'autorisation d'accès à la bibliothèque. Retourne true si accordée.
  Future<bool> requestAuthorization() async {
    if (!Platform.isIOS) return false;
    try {
      final status =
          await _channel.invokeMethod<String>('requestAuthorization');
      return status == 'authorized';
    } on PlatformException {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Bibliothèque
  // ---------------------------------------------------------------------------

  /// Retourne tous les items de la bibliothèque iPod sous forme de [TrackMetadata].
  /// Utilise un stream pour ne pas charger toute la bibliothèque en mémoire.
  Stream<TrackMetadata> allTracks() async* {
    if (!Platform.isIOS) return;

    try {
      final rawList =
          await _channel.invokeListMethod<dynamic>('allTracks');
      if (rawList == null) return;

      for (final raw in rawList) {
        if (raw is! Map) continue;
        final data = Map<String, dynamic>.from(raw);
        final meta = _mapMediaItem(data);
        if (meta != null) yield meta;
      }
    } on PlatformException {
      return;
    }
  }

  /// Retourne les albums de la bibliothèque.
  Future<List<Map<String, dynamic>>> allAlbums() async {
    if (!Platform.isIOS) return [];
    try {
      final raw = await _channel.invokeListMethod<dynamic>('allAlbums');
      return raw?.cast<Map<String, dynamic>>() ?? [];
    } on PlatformException {
      return [];
    }
  }

  /// Retourne les artistes de la bibliothèque.
  Future<List<Map<String, dynamic>>> allArtists() async {
    if (!Platform.isIOS) return [];
    try {
      final raw = await _channel.invokeListMethod<dynamic>('allArtists');
      return raw?.cast<Map<String, dynamic>>() ?? [];
    } on PlatformException {
      return [];
    }
  }

  /// Retourne l'URL de stream pour un item (persistentID).
  Future<String?> streamUrl(String persistentId) async {
    if (!Platform.isIOS) return null;
    try {
      return await _channel.invokeMethod<String>(
        'streamUrl',
        {'persistentId': persistentId},
      );
    } on PlatformException {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Mapping MPMediaItem → TrackMetadata
  // ---------------------------------------------------------------------------

  TrackMetadata? _mapMediaItem(Map<String, dynamic> item) {
    final persistentId = item['persistentID']?.toString();
    final title = item['title'] as String?;
    if (persistentId == null || title == null) return null;

    // L'URL de stream sur iOS est `ipod-library://item/item.m4a?id={persistentId}`
    final filePath = item['assetURL'] as String? ??
        'ipod-library://item/item.m4a?id=$persistentId';

    return TrackMetadata(
      filePath: filePath,
      title: title,
      artist: item['artist'] as String?,
      albumArtist: item['albumArtist'] as String?,
      album: item['albumTitle'] as String?,
      trackNumber: _parseInt(item['albumTrackNumber']),
      discNumber: _parseInt(item['discNumber']),
      year: _parseYear(item['releaseDate'] as String?),
      genre: item['genre'] as String?,
      durationMs: _parseDouble(item['playbackDuration']),
      format: 'aac', // iPod Library = M4A/AAC principalement
      hasCoverData: item['hasArtwork'] == true,
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static int? _parseDouble(dynamic v) {
    if (v == null) return null;
    final d = v is double ? v : double.tryParse(v.toString());
    return d != null ? (d * 1000).round() : null;
  }

  static int? _parseYear(String? dateStr) {
    if (dateStr == null || dateStr.length < 4) return null;
    return int.tryParse(dateStr.substring(0, 4));
  }
}
