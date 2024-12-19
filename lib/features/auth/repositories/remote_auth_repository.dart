// lib/features/auth/repositories/fake_auth_repository.dart
import 'package:exachanger_app/core/services/network_service.dart';
import 'package:exachanger_app/features/auth/models/signin_request.dart';
import 'package:exachanger_app/features/auth/models/signin_response.dart';
import 'package:exachanger_app/features/auth/repositories/auth_repository.dart';

// lib/features/auth/repositories/remote_auth_repository.dart
class RemoteAuthRepository implements AuthRepository {
  final NetworkService _networkService;

  RemoteAuthRepository(this._networkService);

  @override
  Future<NetworkResult<SignInResponse>> signIn(SignInRequest request) async {
    return _networkService.post<SignInResponse>(
      '/auth/signin',
      data: request.toJson(),
      fromJson: (json) => SignInResponse.fromJson(json),
    );
  }

  @override
  Future<NetworkResult<void>> signOut() async {
    return _networkService.post('/auth/signout');
  }
}
