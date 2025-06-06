import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/connectivity_service.dart';

/// Enhanced error handler for network exceptions with connectivity awareness
class NetworkErrorHandler {
  static final ConnectivityService? _connectivityService =
      Get.isRegistered<ConnectivityService>()
      ? Get.find<ConnectivityService>()
      : null;

  /// Convert DioException to user-friendly error message
  static String getErrorMessage(DioException error) {
    // Check connectivity first
    if (_connectivityService?.isConnected.value == false) {
      return 'No internet connection. Please check your network settings and try again.';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';

      case DioExceptionType.sendTimeout:
        return 'Request timeout. The server is taking too long to respond.';

      case DioExceptionType.receiveTimeout:
        return 'Response timeout. The server is taking too long to respond.';

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return 'Network error. Please check your internet connection.';
        }
        return 'Connection failed. Please check your internet connection and try again.';

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Security error. Invalid server certificate.';

      case DioExceptionType.unknown:
        return _handleUnknownError(error);

      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Handle bad response errors (4xx, 5xx)
  static String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == null) {
      return 'Server error. Please try again.';
    }

    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input and try again.';
      case 401:
        return 'Authentication failed. Please log in again.';
      case 403:
        return 'Access denied. You don\'t have permission to perform this action.';
      case 404:
        return 'Resource not found. The requested content is not available.';
      case 408:
        return 'Request timeout. Please try again.';
      case 409:
        return 'Conflict. The request conflicts with the current state.';
      case 422:
        return 'Invalid data. Please check your input and try again.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. The server is temporarily unavailable.';
      case 503:
        return 'Service unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. The server is temporarily unavailable.';
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return 'Client error ($statusCode). Please check your request.';
        } else if (statusCode >= 500) {
          return 'Server error ($statusCode). Please try again later.';
        }
        return 'HTTP error ($statusCode). Please try again.';
    }
  }

  /// Handle unknown errors
  static String _handleUnknownError(DioException error) {
    if (error.error is SocketException) {
      final socketError = error.error as SocketException;
      if (socketError.osError?.errorCode == 7) {
        return 'No internet connection. Please check your network settings.';
      }
      return 'Network error. Please check your internet connection.';
    }

    if (error.error is HttpException) {
      return 'HTTP error. Please try again.';
    }

    if (error.error is FormatException) {
      return 'Invalid response format. Please try again.';
    }

    return error.message ?? 'An unexpected error occurred. Please try again.';
  }

  /// Get error title for dialogs
  static String getErrorTitle(DioException error) {
    if (_connectivityService?.isConnected.value == false) {
      return 'No Internet Connection';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection Timeout';

      case DioExceptionType.connectionError:
        return 'Connection Error';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return 'Server Error';
        }
        return 'Request Error';

      case DioExceptionType.cancel:
        return 'Request Cancelled';

      case DioExceptionType.badCertificate:
        return 'Security Error';

      default:
        return 'Error';
    }
  }

  /// Check if error is retryable
  static bool isRetryable(DioException error) {
    // Don't retry if offline
    if (_connectivityService != null &&
        !_connectivityService!.isConnected.value) {
      return false;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        // Retry on server errors (5xx) but not client errors (4xx)
        return statusCode != null && statusCode >= 500;

      case DioExceptionType.unknown:
        // Retry on network-related unknown errors
        return error.error is SocketException || error.error is HttpException;

      default:
        return false;
    }
  }

  /// Get appropriate icon for error type
  static String getErrorIcon(DioException error) {
    if (_connectivityService != null &&
        !_connectivityService!.isConnected.value) {
      return '📡'; // No signal
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '⏱️'; // Timer

      case DioExceptionType.connectionError:
        return '🔌'; // Unplugged

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return '🔧'; // Server error
        }
        return '❌'; // Client error

      case DioExceptionType.badCertificate:
        return '🔒'; // Security

      default:
        return '⚠️'; // Warning
    }
  }
}
