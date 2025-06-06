import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../services/connectivity_service.dart';

/// Interceptor that automatically retries failed requests due to network issues
class RetryInterceptor extends dio.Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final ConnectivityService? _connectivityService;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  }) : _connectivityService = Get.isRegistered<ConnectivityService>()
           ? Get.find<ConnectivityService>()
           : null;

  @override
  Future<void> onError(
    dio.DioException err,
    dio.ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    // Check if we should retry this request
    if (_shouldRetry(err, retryCount)) {
      print('Retrying request (attempt ${retryCount + 1}/${maxRetries})...');

      // Wait for connectivity if no internet
      if (_connectivityService != null &&
          !_connectivityService.isConnected.value) {
        await _waitForConnectivity();
      }

      // Add delay before retry
      await Future.delayed(
        Duration(
          milliseconds: (retryDelay.inMilliseconds * (retryCount + 1)).round(),
        ),
      );

      // Increment retry count
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      try {
        // Retry the request
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // If retry fails, continue with original error handling
        print('Retry ${retryCount + 1} failed: $e');
      }
    }

    // Pass through the error if we can't/shouldn't retry
    handler.next(err);
  }

  /// Determine if the request should be retried
  bool _shouldRetry(dio.DioException err, int retryCount) {
    // Don't retry if max retries exceeded
    if (retryCount >= maxRetries) {
      return false;
    }

    // Don't retry client errors (4xx)
    if (err.response?.statusCode != null &&
        err.response!.statusCode! >= 400 &&
        err.response!.statusCode! < 500) {
      return false;
    }

    // Retry on these conditions
    switch (err.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
      case dio.DioExceptionType.connectionError:
        return true;
      case dio.DioExceptionType.badResponse:
        // Retry on server errors (5xx)
        return err.response?.statusCode != null &&
            err.response!.statusCode! >= 500;
      case dio.DioExceptionType.unknown:
        // Retry on socket exceptions and timeout exceptions
        return err.error is SocketException ||
            err.error is TimeoutException ||
            err.error is HttpException;
      default:
        return false;
    }
  }

  /// Wait for connectivity to be restored
  Future<void> _waitForConnectivity() async {
    if (_connectivityService == null) return;

    print('Waiting for internet connectivity...');

    // Wait up to 30 seconds for connectivity
    final completer = Completer<void>();

    // Set up timeout
    final timeout = Timer(const Duration(seconds: 30), () {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    // Listen for connectivity changes
    final subscription = _connectivityService.isConnected.listen((isConnected) {
      if (isConnected && !completer.isCompleted) {
        timeout.cancel();
        completer.complete();
      }
    });

    // Check current status
    if (_connectivityService.isConnected.value) {
      timeout.cancel();
      subscription.cancel();
      return;
    }

    await completer.future;
    subscription.cancel();
    timeout.cancel();
  }

  /// Retry the failed request
  Future<dio.Response<T>> _retryRequest<T>(
    dio.RequestOptions requestOptions,
  ) async {
    final retryDio = dio.Dio();
    return await retryDio.fetch<T>(requestOptions);
  }
}
