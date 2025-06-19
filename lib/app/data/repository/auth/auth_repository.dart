import 'package:exachanger_get_app/app/data/models/signin_model.dart';
import 'package:exachanger_get_app/app/data/models/signup_response_model.dart';

abstract class AuthRepository {
  Future<SigninModel> getAuthData(Map<String, dynamic> data);
  Future<SignUpResponseModel> signUp(Map<String, dynamic> data);
  Future<Map<String, dynamic>> setupPin(Map<String, dynamic> data);
  Future<void> logout(String refreshToken);
  Future<void> forgotPassword(String email);
  Future<bool> isLoggedIn();

  // refresh token
  Future<String> refreshToken(String token);
}
