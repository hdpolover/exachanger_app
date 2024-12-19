// lib/features/auth/repositories/auth_repository.dart
import 'package:exachanger_app/core/services/network_service.dart';
import 'package:exachanger_app/features/auth/models/signin_request.dart';
import 'package:exachanger_app/features/auth/models/signin_response.dart';

abstract class AuthRepository {
  Future<NetworkResult<SignInResponse>> signIn(SignInRequest request);
  Future<NetworkResult<void>> signOut();
}
