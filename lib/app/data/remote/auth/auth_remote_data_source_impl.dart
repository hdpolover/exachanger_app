import 'dart:convert';

import 'package:exachanger_get_app/app/data/models/api_response_model.dart';

import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../../network/dio_provider.dart';
import '../../models/signin_model.dart';
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
  Future<String> refreshToken(String refreshToken) {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.refreshToken}";
    var dioCall = dioClient.post(
      endpoint,
      data: jsonEncode({"refresh_token": refreshToken}),
    );

    try {
      return callApiWithErrorParser(dioCall).then(
        (response) =>
            ApiResponseModel.fromJson(response.data).data["access_token"],
      );
    } catch (e) {
      rethrow;
    }
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
