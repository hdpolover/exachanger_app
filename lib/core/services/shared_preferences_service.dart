// lib/core/services/shared_preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String token) async {
    await _prefs.setString(tokenKey, token);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _prefs.setString(refreshTokenKey, refreshToken);
  }

  String? getToken() {
    return _prefs.getString(tokenKey);
  }

  String? getRefreshToken() {
    return _prefs.getString(refreshTokenKey);
  }

  Future<void> clearSession() async {
    await _prefs.remove(tokenKey);
    await _prefs.remove(refreshTokenKey);
  }
}
