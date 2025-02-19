import 'dart:convert';

import 'package:exachanger_get_app/app/data/model/api_response_model.dart';

import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../../network/dio_provider.dart';
import '../../model/signin_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl extends BaseRemoteSource
    implements AuthRemoteDataSource {
  @override
  Future<void> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<SigninModel> signIn(Map<String, dynamic> data) {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.signin}";
    var dioCall = dioClient.post(endpoint, data: jsonEncode(data));

    try {
      return callApiWithErrorParser(dioCall).then(
        (response) => SigninModel.fromJson(
          ApiResponseModel.fromJson(response.data).data,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout(String refreshToken) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<SigninModel> refreshToken(String refreshToken) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(Map<String, dynamic> data) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOtp(String email, String otp) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
}
