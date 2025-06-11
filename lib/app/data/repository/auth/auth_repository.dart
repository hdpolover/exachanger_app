import 'package:exachanger_get_app/app/data/models/signin_model.dart';

abstract class AuthRepository {
  Future<SigninModel> getAuthData(Map<String, dynamic> data);
  Future<void> signUp(Map<String, dynamic> data);
  Future<void> logout(String refreshToken);
  Future<void> forgotPassword(String email);
  Future<bool> isLoggedIn();

  // refresh token
  Future<String> refreshToken(String token);
}
