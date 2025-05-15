import 'package:exachanger_get_app/app/data/models/signin_model.dart';

abstract class AuthRepository {
  Future<SigninModel> getAuthData(Map<String, dynamic> data);

  // refresh token
  Future<String> refreshToken(String token);
}
