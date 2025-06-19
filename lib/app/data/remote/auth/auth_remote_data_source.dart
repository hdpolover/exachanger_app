import '../../models/signin_model.dart';
import '../../models/signup_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<SigninModel> signIn(Map<String, dynamic> data);

  Future<SignUpResponseModel> signUp(Map<String, dynamic> data);

  Future<Map<String, dynamic>> setupPin(Map<String, dynamic> data);

  Future<String> refreshToken(String refreshToken);

  Future<void> logout(String refreshToken);

  Future<bool> isLoggedIn();

  //forgot password
  Future<void> forgotPassword(String email);

  // verify otp
  Future<void> verifyOtp(String email, String otp);
}
