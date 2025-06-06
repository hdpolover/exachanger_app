import 'package:dio/dio.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/network/token_refresh_interceptor.dart';
import 'package:exachanger_get_app/app/network/retry_interceptor.dart';
import 'package:exachanger_get_app/app/network/request_headers.dart';
import 'package:get/get.dart';

import '../../flavors/environment.dart';
import '../data/remote/auth/auth_remote_data_source.dart';
import '/app/network/pretty_dio_logger.dart';
import '/flavors/build_config.dart';

/// A provider class for Dio HTTP client instances with various configurations
class DioProvider {
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const int _maxLineWidth = 90;
  static const int _maxRetries = 3;

  static final String _baseUrl = BuildConfig.instance.config.baseUrl;

  static final _authRemoteDataSource = Get.find<AuthRemoteDataSource>(
    tag: (AuthRemoteDataSource).toString(),
  );
  static final _preferenceManager = Get.find<PreferenceManagerImpl>();

  static Dio? _instance;

  static final _prettyDioLogger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: BuildConfig.instance.environment == Environment.DEVELOPMENT,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: _maxLineWidth,
  );

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: _defaultTimeout,
    receiveTimeout: _defaultTimeout,
    contentType: 'application/json',
  );

  /// The base URL for all requests
  static String get baseUrl => _baseUrl;

  /// Returns a basic Dio instance with logging only
  static Dio get basic {
    _instance ??= Dio(_defaultOptions)..interceptors.add(_prettyDioLogger);
    return _instance!;
  }

  /// Returns a Dio instance with auth token, retry capability, and logging
  static Dio get withAuth {
    final dio = basic;

    // Remove any existing interceptors except logger
    dio.interceptors.removeWhere((i) => i is! PrettyDioLogger);

    // Add interceptors in correct order
    dio.interceptors
      ..add(RequestHeaderInterceptor())
      ..add(RetryInterceptor(maxRetries: _maxRetries))
      ..add(TokenRefreshInterceptor(_authRemoteDataSource, _preferenceManager));

    return dio;
  }

  /// Sets the authorization token in the headers
  static void setAuthToken(String token) {
    basic.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clears the authorization token from headers
  static void clearAuthToken() {
    basic.options.headers.remove('Authorization');
  }

  /// Sets a custom content type with version
  static void setContentType(String version) {
    basic.options.contentType = "user_defined_content_type+$version";
  }

  /// Sets the content type to application/json
  static void setContentTypeApplicationJson() {
    basic.options.contentType = "application/json";
  }
}
