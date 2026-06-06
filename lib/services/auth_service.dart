import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// AuthService — JWT authentication against remote Tune server
// Stores token in SharedPreferences, exposes login/register/logout.
// ---------------------------------------------------------------------------

class AuthService extends ChangeNotifier {
  static const _kToken = 'auth_token';
  static const _kEmail = 'auth_email';

  String? _token;
  String? _email;
  SharedPreferences? _prefs;

  String? get token => _token;
  String? get email => _email;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  // ---------------------------------------------------------------------------
  // Init — load persisted token
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs?.getString(_kToken);
    _email = _prefs?.getString(_kEmail);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  /// POST /api/v1/auth/login — returns JWT token on success.
  Future<String> login(String baseUrl, String email, String password) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 30));

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final token = data['token'] as String? ?? data['access_token'] as String? ?? '';
      if (token.isEmpty) throw Exception('Token vide dans la reponse');
      await setToken(token);
      await _setEmail(email);
      return token;
    } else {
      final body = resp.body;
      String message;
      try {
        final data = jsonDecode(body) as Map<String, dynamic>;
        message = data['error'] as String? ?? data['message'] as String? ?? 'Echec connexion';
      } catch (_) {
        message = 'Echec connexion (${resp.statusCode})';
      }
      throw Exception(message);
    }
  }

  // ---------------------------------------------------------------------------
  // Register
  // ---------------------------------------------------------------------------

  /// POST /api/v1/auth/register — returns JWT token on success.
  Future<String> register(String baseUrl, String username, String email, String password) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 30));

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final token = data['token'] as String? ?? data['access_token'] as String? ?? '';
      if (token.isEmpty) throw Exception('Token vide dans la reponse');
      await setToken(token);
      await _setEmail(email);
      return token;
    } else {
      final body = resp.body;
      String message;
      try {
        final data = jsonDecode(body) as Map<String, dynamic>;
        message = data['error'] as String? ?? data['message'] as String? ?? 'Echec inscription';
      } catch (_) {
        message = 'Echec inscription (${resp.statusCode})';
      }
      throw Exception(message);
    }
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  Future<void> logout() async {
    _token = null;
    _email = null;
    await _prefs?.remove(_kToken);
    await _prefs?.remove(_kEmail);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Token management
  // ---------------------------------------------------------------------------

  Future<void> setToken(String token) async {
    _token = token;
    await _prefs?.setString(_kToken, token);
    notifyListeners();
  }

  String? getToken() => _token;

  Future<void> _setEmail(String email) async {
    _email = email;
    await _prefs?.setString(_kEmail, email);
  }

  // ---------------------------------------------------------------------------
  // Auth headers — inject into HTTP requests
  // ---------------------------------------------------------------------------

  Map<String, String> get authHeaders {
    if (_token == null || _token!.isEmpty) return {};
    return {'Authorization': 'Bearer $_token'};
  }
}
