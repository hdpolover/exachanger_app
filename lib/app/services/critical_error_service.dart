import 'package:get/get.dart';
import 'package:exachanger_get_app/app/core/utils/circuit_breaker.dart';
import 'package:exachanger_get_app/app/modules/server_error/controllers/server_error_controller.dart';
import 'package:exachanger_get_app/app/network/exceptions/api_exception.dart';
import 'package:exachanger_get_app/app/network/exceptions/network_exception.dart';

class CriticalErrorService extends GetxService {
  // Track critical endpoints that if failed, should show server error page
  final List<String> criticalEndpoints = [
    '/metadata', // Now considered critical for app functionality
    '/auth',
    '/profile',
    '/dashboard',
    '/balance',
    '/transactions',
  ]; // Track non-critical endpoints that can fail without showing error page
  final List<String> nonCriticalEndpoints = ['/promo', '/news'];

  /// Check if an API error should trigger the server error page
  bool shouldShowServerErrorPage(dynamic error, String? endpoint) {
    print('🔍 CRITICAL ERROR SERVICE: Checking endpoint: $endpoint');
    print('🔍 Error type: ${error.runtimeType}');

    // Never show error page for non-critical endpoints
    if (endpoint != null && _isNonCriticalEndpoint(endpoint)) {
      print('🔍 Non-critical endpoint - no server error page');
      return false;
    } // Network errors don't trigger server error page (show network error instead)
    if (error is NetworkException) {
      print('🔍 Network error - no server error page');
      return false;
    }

    // User registration errors don't trigger server error page (handled gracefully)
    if (error.toString().contains('UserRegistrationException')) {
      print('🔍 User registration error - no server error page');
      return false;
    }

    // API errors with 5xx status codes on critical endpoints
    if (error is ApiException) {
      bool shouldTrigger = _shouldTriggerForApiError(error, endpoint);
      print(
        '🔍 API error - HTTP ${error.httpCode} - Should trigger: $shouldTrigger',
      );
      return shouldTrigger;
    }

    // Circuit breaker exceptions for critical services
    if (error is CircuitBreakerOpenException) {
      bool isCritical = _isCriticalEndpoint(endpoint);
      print('🔍 Circuit breaker error - Is critical: $isCritical');
      return isCritical;
    }

    print('🔍 Other error type - no server error page');
    return false;
  }

  /// Show the server error page with appropriate error details
  void showServerErrorPage(dynamic error, String? endpoint) {
    print(
      '🚨 CRITICAL ERROR SERVICE: Showing server error page for endpoint: $endpoint',
    );
    print('🚨 Error type: ${error.runtimeType}');

    // Ensure controller is registered
    if (!Get.isRegistered<ServerErrorController>()) {
      print('🚨 Registering ServerErrorController...');
      Get.put(ServerErrorController());
    }

    String errorCode = _getErrorCode(error);
    String errorMessage = _getErrorMessage(error, endpoint);
    String technicalDetails = _getTechnicalDetails(error, endpoint);

    print('🚨 Error details - Code: $errorCode, Message: $errorMessage');

    // Set error details
    Get.find<ServerErrorController>().setError(
      code: errorCode,
      message: errorMessage,
      technical: technicalDetails,
    );

    print('🚨 Navigating to server error page...');
    // Store current route for potential restoration
    _storeCurrentRoute();

    // Navigate to server error page
    Get.offAllNamed('/server-error');
  }

  /// Store the current route before showing server error page
  void _storeCurrentRoute() {
    try {
      String currentRoute = Get.currentRoute;
      if (currentRoute != '/server-error') {
        print('🔍 Storing current route: $currentRoute');
        // You could store this in preferences or a service if needed for restoration
      }
    } catch (e) {
      print('🔍 Error storing current route: $e');
    }
  }

  /// Reset failure tracking for an endpoint
  void resetFailureCount(String? endpoint) {
    // No longer tracking consecutive failures
  }

  /// Reset all failure tracking
  void resetAllFailures() {
    // No longer tracking consecutive failures
  }

  bool _isNonCriticalEndpoint(String endpoint) {
    return nonCriticalEndpoints.any((pattern) => endpoint.contains(pattern));
  }

  bool _isCriticalEndpoint(String? endpoint) {
    if (endpoint == null) return false;
    return criticalEndpoints.any((pattern) => endpoint.contains(pattern));
  }

  bool _shouldTriggerForApiError(ApiException error, String? endpoint) {
    print(
      '🔍 _shouldTriggerForApiError: HTTP ${error.httpCode} for endpoint $endpoint',
    );

    // Only 5xx errors can trigger server error page
    if (error.httpCode < 500) {
      print('🔍 Not a 5xx error - no trigger');
      return false;
    }

    // For critical endpoints, trigger immediately on first 5xx error
    if (_isCriticalEndpoint(endpoint)) {
      print('🔍 Critical endpoint with 5xx error - TRIGGER SERVER ERROR PAGE');
      return true; // Immediate trigger for critical endpoints
    }

    // For non-critical endpoints, only trigger on 503 (Service Unavailable)
    bool shouldTrigger = error.httpCode == 503;
    print('🔍 Non-critical endpoint - only 503 triggers: $shouldTrigger');
    return shouldTrigger;
  }

  String _getErrorCode(dynamic error) {
    if (error is ApiException) {
      return error.httpCode.toString();
    } else if (error is CircuitBreakerOpenException) {
      return 'CB_OPEN';
    } else {
      return 'SERVER_ERROR';
    }
  }

  String _getErrorMessage(dynamic error, String? endpoint) {
    if (error is ApiException) {
      switch (error.httpCode) {
        case 500:
          return 'Our servers are experiencing technical difficulties. We\'re working to resolve this issue as quickly as possible.';
        case 502:
          return 'There\'s a temporary issue with our server connection. Please try again in a few minutes.';
        case 503:
          return 'Our service is temporarily unavailable for maintenance. We\'ll be back shortly.';
        case 504:
          return 'Our servers are taking longer than usual to respond. Please try again later.';
        default:
          return 'We\'re experiencing server issues that prevent the app from functioning properly.';
      }
    } else if (error is CircuitBreakerOpenException) {
      return 'Multiple connection attempts have failed. The service is temporarily unavailable to prevent further issues.';
    } else {
      return 'A critical error has occurred that prevents the app from functioning properly.';
    }
  }

  String _getTechnicalDetails(dynamic error, String? endpoint) {
    StringBuffer details = StringBuffer();

    details.writeln('Timestamp: ${DateTime.now().toIso8601String()}');

    if (endpoint != null) {
      details.writeln('Endpoint: $endpoint');
    }

    if (error is ApiException) {
      details.writeln('HTTP Status: ${error.httpCode}');
      details.writeln('Status: ${error.status}');
      details.writeln('Message: ${error.message}');
    } else {
      details.writeln('Error Type: ${error.runtimeType}');
      details.writeln('Error: $error');
    }

    // Add circuit breaker states
    details.writeln('\nCircuit Breaker States:');
    // Note: This would need to be implemented in CircuitBreakers class
    // For now, just add a placeholder
    details.writeln('- Auth Service: Unknown');
    details.writeln('- Transaction Service: Unknown');
    details.writeln('- Profile Service: Unknown');

    return details.toString();
  }
}
