import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../services/connectivity_service.dart';
import '/flavors/build_config.dart';

/// Interceptor that automatically retries requests on network failures
class NetworkRetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final logger = BuildConfig.instance.config.logger;

  NetworkRetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;

    // Check if we should retry this error
    if (_shouldRetry(err) && _canRetry(requestOptions)) {
      final currentRetry = _getCurrentRetryCount(requestOptions);

      if (currentRetry < maxRetries) {
        logger.i(
          'Retrying request (${currentRetry + 1}/$maxRetries): ${requestOptions.path}',
        );

        // Wait before retrying
        await Future.delayed(_calculateRetryDelay(currentRetry));

        // Check connectivity before retrying
        if (Get.isRegistered<ConnectivityService>()) {
          final connectivityService = Get.find<ConnectivityService>();
          await connectivityService.checkConnectivity();

          if (!connectivityService.isConnected.value) {
            logger.w('No internet connection available for retry');
            return handler.next(err);
          }
        }

        // Update retry count
        requestOptions.extra['retryCount'] = currentRetry + 1;

        try {
          // Retry the request
          final response = await Dio().fetch(requestOptions);
          return handler.resolve(response);
        } catch (e) {
          // If the retry fails, continue with the error handling
          if (e is DioException) {
            return onError(e, handler);
          }
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  /// Check if the error is retryable
  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        // Retry on server errors (5xx) but not client errors (4xx)
        final statusCode = err.response?.statusCode;
        return statusCode != null && statusCode >= 500;
      case DioExceptionType.unknown:
        // Check if it's a network error
        if (err.error is SocketException ||
            err.error is HttpException ||
            err.message?.contains('connection') == true) {
          return true;
        }
        return false;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return false;
    }
  }

  /// Check if the request can be retried (only GET, HEAD, OPTIONS)
  bool _canRetry(RequestOptions requestOptions) {
    final method = requestOptions.method.toUpperCase();
    return ['GET', 'HEAD', 'OPTIONS'].contains(method);
  }

  /// Get current retry count from request options
  int _getCurrentRetryCount(RequestOptions requestOptions) {
    return requestOptions.extra['retryCount'] ?? 0;
  }

  /// Calculate retry delay with exponential backoff
  Duration _calculateRetryDelay(int retryCount) {
    return Duration(
      milliseconds: retryDelay.inMilliseconds * (1 << retryCount),
    );
  }
}
