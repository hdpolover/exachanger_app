import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_connect/http/src/status/http_status.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/utils/error_message_utils.dart';
import '/app/services/critical_error_service.dart';
import '/app/services/auth_service.dart';
import '/app/network/dio_provider.dart';
import '/app/network/error_handlers.dart';
import '/app/network/exceptions/base_exception.dart';
import '/app/network/exceptions/base_api_exception.dart';
import '/app/network/exceptions/network_exception.dart';
import '/app/routes/app_pages.dart';
import '/flavors/build_config.dart';

abstract class BaseRemoteSource {
  Dio get dioClient => DioProvider.withAuth;

  final logger = BuildConfig.instance.config.logger;

  // Static flag to prevent multiple authentication error handling
  static bool _isHandlingAuthError = false;

  /// Reset the authentication error flag (call this after successful sign-in)
  static void resetAuthErrorFlag() {
    _isHandlingAuthError = false;
  }

  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> api) async {
    try {
      Response<T> response = await api;

      if (response.statusCode != HttpStatus.ok ||
          (response.data as Map<String, dynamic>)['statusCode'] !=
              HttpStatus.ok) {
        // TODO
      }

      return response;
    } on DioException catch (dioError) {
      Exception exception = handleDioError(dioError);

      // Get endpoint from request for better error context
      String? endpoint = dioError.requestOptions.path;

      // Log with better context
      String userFriendlyMessage = ErrorMessageUtils.getUserFriendlyMessage(
        exception,
        endpoint: endpoint,
      );

      logger.e(
        "API Error for endpoint '$endpoint' - User message: $userFriendlyMessage - Technical details: HTTP ${(exception as dynamic).httpCode ?? 'unknown'} - ${(exception as dynamic).message ?? exception.runtimeType}",
      );

      // Check if this should trigger server error page
      if (Get.isRegistered<CriticalErrorService>()) {
        final criticalErrorService = Get.find<CriticalErrorService>();

        if (criticalErrorService.shouldShowServerErrorPage(
          exception,
          endpoint,
        )) {
          criticalErrorService.showServerErrorPage(exception, endpoint);
          // This line won't be reached due to navigation, but satisfies the return type
          throw exception;
        }
      }

      // Handle authentication errors (401 - invalid/expired token)
      await _handleAuthenticationError(exception, endpoint);

      // Show snackbar for network errors if a controller is available
      if (exception is NetworkException) {
        try {
          if (Get.isRegistered<BaseController>()) {
            BaseController controller = Get.find<BaseController>();
            controller.showNetworkErrorSnackbar(
              customMessage: userFriendlyMessage,
            );
          }
        } catch (e) {
          logger.e("Error showing network error snackbar: $e");
        }
      }

      throw exception;
    } catch (error) {
      logger.e("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }

  /// Handles authentication errors (401) by resetting user data and redirecting to sign-in
  Future<void> _handleAuthenticationError(
    Exception exception,
    String? endpoint,
  ) async {
    // Check if this is an authentication error (HTTP 401)
    if (exception is BaseApiException &&
        exception.httpCode == HttpStatus.unauthorized) {
      // Check if we're already handling an auth error to prevent multiple calls
      if (_isHandlingAuthError) {
        logger.w(
          "Authentication error already being handled, skipping duplicate for endpoint '$endpoint'",
        );
        return;
      }

      // Set flag to prevent multiple authentication error handling
      _isHandlingAuthError = true;

      logger.w(
        "Authentication error detected for endpoint '$endpoint' - resetting user session",
      );

      try {
        // Reset user authentication data
        if (Get.isRegistered<AuthService>()) {
          final authService = Get.find<AuthService>();
          await authService.signOut();
          logger.i("User session cleared successfully");
        }

        // Show notification to user
        Get.snackbar(
          'Session Expired',
          'Your session has expired. Please sign in again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
        );

        // Navigate to sign-in page and clear navigation stack
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Brief delay for snackbar
        Get.offAllNamed(Routes.SIGN_IN);

        logger.i("Redirected to sign-in page due to authentication error");

        // Reset flag after successful handling (though this may not execute due to navigation)
        _isHandlingAuthError = false;
      } catch (e) {
        logger.e("Error handling authentication failure: $e");
        // Reset flag on error
        _isHandlingAuthError = false;
        // If there's an error in the logout process, still try to navigate to sign-in
        Get.offAllNamed(Routes.SIGN_IN);
      }
    }
  }
}
