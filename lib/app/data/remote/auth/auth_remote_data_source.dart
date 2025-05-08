import '../../model/signin_model.dart';

abstract class AuthRemoteDataSource {
  Future<SigninModel> signIn(Map<String, dynamic> data);

  Future<void> signUp(Map<String, dynamic> data);

  Future<String> refreshToken(String refreshToken);

  Future<void> logout(String refreshToken);

  Future<bool> isLoggedIn();

  //forgot password
  Future<void> forgotPassword(String email);

  // verify otp
  Future<void> verifyOtp(String email, String otp);
}
