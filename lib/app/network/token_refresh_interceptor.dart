import 'package:dio/dio.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import '/app/data/remote/auth/auth_remote_data_source.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  final AuthRemoteDataSource _authRemoteDataSource;
  final PreferenceManagerImpl _preferenceManager;

  TokenRefreshInterceptor(this._authRemoteDataSource, this._preferenceManager);

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // Get stored refresh token
        final refreshToken =
            await _preferenceManager.getString("refresh_token");

        // Call refresh token API
        final newAccessToken =
            await _authRemoteDataSource.refreshToken(refreshToken);

        // Store new tokens
        await _preferenceManager.setString("access_token", newAccessToken);

        // Update Authorization header
        err.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";

        // Retry original request with new token
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        // If refresh fails, logout
        // await _preferenceManager.logout();
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}
