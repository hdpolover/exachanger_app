// lib/core/services/session_service.dart
import 'package:exachanger_app/core/services/shared_preferences_service.dart';
import 'package:exachanger_app/features/auth/models/signin_response.dart';

class SessionService {
  final SharedPreferencesService _prefsService;

  SessionService(this._prefsService);

  Future<void> saveSession(SignInResponse response) async {
    await _prefsService.setToken(response.token);
    await _prefsService.setRefreshToken(response.refreshToken);
  }

  Future<void> clearSession() async {
    await _prefsService.clearSession();
  }

  bool get isAuthenticated => _prefsService.getToken() != null;
}
