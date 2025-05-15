import 'package:exachanger_get_app/app/data/models/signin_model.dart';
import 'package:exachanger_get_app/app/data/remote/auth/auth_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:get/get.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteSource =
      Get.find(tag: (AuthRemoteDataSource).toString());

  @override
  Future<SigninModel> getAuthData(Map<String, dynamic> data) {
    return _remoteSource.signIn(data);
  }

  @override
  Future<String> refreshToken(String token) {
    // TODO: implement refreshToken
    return _remoteSource.refreshToken(token);
  }
}
