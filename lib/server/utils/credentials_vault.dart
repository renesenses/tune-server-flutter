import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../database/database.dart';

// ---------------------------------------------------------------------------
// CredentialsVault
// Encrypted credential storage using the settings repository.
// Store/get/remove per service.
// Miroir de credentials_vault.rs (Rust)
//
// Encryption: XOR with SHA-256 derived key (lightweight obfuscation).
// For production, consider flutter_secure_storage or platform keychain.
// ---------------------------------------------------------------------------

class CredentialsVault {
  final TuneDatabase _db;

  /// Key prefix in settings table.
  static const _prefix = 'vault:';

  /// Derivation salt for the obfuscation key.
  static const _salt = 'tune-vault-2024';

  CredentialsVault(this._db);

  // ---------------------------------------------------------------------------
  // Store
  // ---------------------------------------------------------------------------

  /// Store credentials for a service.
  /// [service] : service identifier (e.g. 'tidal', 'qobuz', 'listenbrainz')
  /// [credentials] : map of credential key-value pairs
  Future<void> store(String service, Map<String, String> credentials) async {
    final json = jsonEncode(credentials);
    final encrypted = _encrypt(json, service);
    await _db.settingsRepo.set('$_prefix$service', encrypted);
    debugPrint('[CredentialsVault] Stored credentials for $service');
  }

  // ---------------------------------------------------------------------------
  // Get
  // ---------------------------------------------------------------------------

  /// Retrieve credentials for a service.
  /// Returns null if not found.
  Future<Map<String, String>?> get(String service) async {
    final encrypted = await _db.settingsRepo.get('$_prefix$service');
    if (encrypted == null) return null;

    try {
      final json = _decrypt(encrypted, service);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (e) {
      debugPrint('[CredentialsVault] Failed to decrypt credentials for $service: $e');
      return null;
    }
  }

  /// Get a single credential value.
  Future<String?> getValue(String service, String key) async {
    final creds = await get(service);
    return creds?[key];
  }

  // ---------------------------------------------------------------------------
  // Remove
  // ---------------------------------------------------------------------------

  /// Remove all credentials for a service.
  Future<void> remove(String service) async {
    await _db.settingsRepo.delete('$_prefix$service');
    debugPrint('[CredentialsVault] Removed credentials for $service');
  }

  // ---------------------------------------------------------------------------
  // List
  // ---------------------------------------------------------------------------

  /// List all services that have stored credentials.
  Future<List<String>> listServices() async {
    final allSettings = await _db.settingsRepo.all();
    return allSettings.keys
        .where((k) => k.startsWith(_prefix))
        .map((k) => k.substring(_prefix.length))
        .toList();
  }

  /// Check if credentials exist for a service.
  Future<bool> has(String service) async {
    final value = await _db.settingsRepo.get('$_prefix$service');
    return value != null;
  }

  // ---------------------------------------------------------------------------
  // Encryption (lightweight XOR obfuscation)
  // ---------------------------------------------------------------------------

  /// Derive a key from service name + salt using SHA-256.
  List<int> _deriveKey(String service) {
    return sha256.convert(utf8.encode('$_salt:$service')).bytes;
  }

  String _encrypt(String plaintext, String service) {
    final key = _deriveKey(service);
    final bytes = utf8.encode(plaintext);
    final encrypted = Uint8List(bytes.length);

    for (var i = 0; i < bytes.length; i++) {
      encrypted[i] = bytes[i] ^ key[i % key.length];
    }

    return base64.encode(encrypted);
  }

  String _decrypt(String ciphertext, String service) {
    final key = _deriveKey(service);
    final bytes = base64.decode(ciphertext);
    final decrypted = Uint8List(bytes.length);

    for (var i = 0; i < bytes.length; i++) {
      decrypted[i] = bytes[i] ^ key[i % key.length];
    }

    return utf8.decode(decrypted);
  }
}
