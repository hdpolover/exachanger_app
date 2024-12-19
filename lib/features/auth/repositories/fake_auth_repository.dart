// lib/features/auth/repositories/fake_auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:exachanger_app/core/services/network_service.dart';
import 'package:exachanger_app/features/auth/models/signin_request.dart';
import 'package:exachanger_app/features/auth/models/signin_response.dart';
import 'package:exachanger_app/features/auth/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<NetworkResult<SignInResponse>> signIn(SignInRequest request) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    if (request.email == "test@test.com" && request.password == "password") {
      return Right(
        SignInResponse(
          token: 'fake_token',
          refreshToken: 'fake_refresh_token',
        ),
      );
    }

    return Left(
      NetworkFailure(
        message: 'Invalid credentials',
        statusCode: 401,
      ),
    );
  }

  @override
  Future<NetworkResult<void>> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }
}
