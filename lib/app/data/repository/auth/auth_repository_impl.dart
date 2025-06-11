import 'package:exachanger_get_app/app/data/models/signin_model.dart';
import 'package:exachanger_get_app/app/data/remote/auth/auth_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:get/get.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteSource = Get.find(
    tag: (AuthRemoteDataSource).toString(),
  );

  @override
  Future<SigninModel> getAuthData(Map<String, dynamic> data) {
    return _remoteSource.signIn(data);
  }

  @override
  Future<void> signUp(Map<String, dynamic> data) {
    return _remoteSource.signUp(data);
  }

  @override
  Future<void> logout(String refreshToken) {
    return _remoteSource.logout(refreshToken);
  }

  @override
  Future<void> forgotPassword(String email) {
    return _remoteSource.forgotPassword(email);
  }

  @override
  Future<bool> isLoggedIn() {
    return _remoteSource.isLoggedIn();
  }

  @override
  Future<String> refreshToken(String token) {
    return _remoteSource.refreshToken(token);
  }
}
