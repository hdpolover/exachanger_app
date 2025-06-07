import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/core/utils/circuit_breaker.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class ServerErrorController extends BaseController {
  final RxString errorCode = ''.obs;
  final RxString serverErrorMessage = ''.obs;
  final RxString technicalDetails = ''.obs;
  final RxBool isRetrying = false.obs;

  // Track retry attempts
  final RxInt retryAttempts = 0.obs;
  final int maxRetryAttempts = 3;

  Timer? _retryTimer;
  @override
  void onInit() {
    super.onInit();
    // Don't start automatic connectivity check - let user control retries
    print('🔧 SERVER ERROR: Controller initialized - waiting for user action');
  }

  @override
  void onClose() {
    _retryTimer?.cancel();
    super.onClose();
  }

  /// Set error details for display
  void setError({
    required String code,
    required String message,
    String? technical,
  }) {
    errorCode.value = code;
    serverErrorMessage.value = message;
    technicalDetails.value = technical ?? '';
  }

  /// Retry connection to server
  Future<void> retryConnection() async {
    if (isRetrying.value || retryAttempts.value >= maxRetryAttempts) {
      return;
    }

    isRetrying.value = true;
    retryAttempts.value++;

    try {
      // Show loading indicator
      showLoading();

      // Reset all circuit breakers
      CircuitBreakers.resetAll();

      // Attempt to verify server connection
      bool isConnected = await _checkServerHealth();

      if (isConnected) {
        // Server is back online, navigate back to app
        _navigateBackToApp();
      } else {
        // Still failed, show error message
        _showRetryFailedMessage();
      }
    } catch (e) {
      logger.e('Retry connection failed: $e');
      _showRetryFailedMessage();
    } finally {
      isRetrying.value = false;
      hideLoading();
    }
  }

  /// Check if server is healthy by making a simple API call
  Future<bool> _checkServerHealth() async {
    try {
      print('🔧 SERVER ERROR: Performing real health check...');

      // Try to make a simple metadata request to verify server is back
      // This tests the same type of endpoint that originally failed
      try {
        final MetadataRepository metadataRepository = Get.find(
          tag: 'MetadataRepository',
        );
        // Make a lightweight metadata call
        await metadataRepository.getPageContent('health-check');

        print('🔧 SERVER ERROR: Health check passed - server is responsive');
        return true;
      } catch (e) {
        print(
          '🔧 SERVER ERROR: Repository not available for health check, using basic connectivity test',
        );

        // Fallback: just wait a bit and return false to force manual retry
        await Future.delayed(Duration(seconds: 1));
        return false;
      }
    } catch (e) {
      print(
        '🔧 SERVER ERROR: Health check failed - server still has issues: $e',
      );
      return false;
    }
  }

  /// Navigate back to the main app flow
  void _navigateBackToApp() {
    retryAttempts.value = 0;
    // Show success message
    Get.snackbar(
      'Connection Restored',
      'Server connection has been restored. Welcome back!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );

    print('🔧 SERVER ERROR: Navigating back to app with dependency check...');

    // Navigate back to splash with proper dependency handling
    // The SplashBinding will ensure dependencies are properly restored
    Get.offAllNamed('/splash');
  }

  /// Show message when retry fails
  void _showRetryFailedMessage() {
    String message;

    if (retryAttempts.value >= maxRetryAttempts) {
      message =
          'Maximum retry attempts reached. Please try again later or contact support.';
    } else {
      message =
          'Connection attempt failed. You can try again or contact support for assistance.';
    }
    Get.snackbar(
      'Connection Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      duration: Duration(seconds: 4),
    );
  }

  /// Get error severity color
  Color getErrorColor() {
    if (errorCode.value.startsWith('5')) {
      return Colors.red; // Server errors
    } else if (errorCode.value.startsWith('4')) {
      return Colors.orange; // Client errors
    } else {
      return Colors.grey; // Other errors
    }
  }

  /// Get appropriate error icon
  IconData getErrorIcon() {
    if (errorCode.value == '500') {
      return Icons.cloud_off_outlined;
    } else if (errorCode.value == '503') {
      return Icons.build_outlined;
    } else if (errorCode.value.startsWith('4')) {
      return Icons.warning_outlined;
    } else {
      return Icons.error_outline;
    }
  }

  /// Reset retry attempts (call this when user manually retries)
  void resetRetryAttempts() {
    retryAttempts.value = 0;
  }
}
