import '/app/network/exceptions/api_exception.dart';
import '/app/network/exceptions/network_exception.dart';
import '/app/network/exceptions/timeout_exception.dart';

class ErrorMessageUtils {
  /// Get user-friendly error message based on the exception and context
  static String getUserFriendlyMessage(
    dynamic exception, {
    String? endpoint,
    String? context,
  }) {
    if (exception is NetworkException) {
      return "No internet connection. Please check your network settings and try again.";
    }

    if (exception is TimeoutException) {
      return "The request is taking too long. Please check your connection and try again.";
    }

    if (exception is ApiException) {
      return _getApiErrorMessage(
        exception,
        endpoint: endpoint,
        context: context,
      );
    }

    // Generic error message
    return "Something went wrong. Please try again later.";
  }

  /// Get specific error message for API exceptions
  static String _getApiErrorMessage(
    ApiException exception, {
    String? endpoint,
    String? context,
  }) {
    // Handle server errors (5xx)
    if (exception.httpCode >= 500 && exception.httpCode < 600) {
      if (endpoint?.contains('metadata') == true) {
        return "Unable to load page content. The app will use default content instead.";
      } else if (endpoint?.contains('auth') == true) {
        return "Authentication service is temporarily unavailable. Please try again later.";
      } else if (endpoint?.contains('transaction') == true) {
        return "Transaction service is temporarily unavailable. Please try again later.";
      } else if (endpoint?.contains('promo') == true) {
        return "Promotion service is temporarily unavailable. Please try again later.";
      }

      return "The server is currently experiencing issues. Please try again later.";
    }

    // Handle client errors (4xx)
    if (exception.httpCode >= 400 && exception.httpCode < 500) {
      switch (exception.httpCode) {
        case 400:
          return "Invalid request. Please check your input and try again.";
        case 401:
          return "Authentication required. Please log in again.";
        case 403:
          return "You don't have permission to access this resource.";
        case 404:
          return "The requested resource was not found.";
        case 429:
          return "Too many requests. Please wait a moment and try again.";
        default:
          return exception.message.isNotEmpty
              ? exception.message
              : "Invalid request. Please try again.";
      }
    }

    // Return server message if available, otherwise generic message
    return exception.message.isNotEmpty
        ? exception.message
        : "Something went wrong. Please try again later.";
  }

  /// Get error title based on the exception type
  static String getErrorTitle(dynamic exception) {
    if (exception is NetworkException) {
      return "Connection Error";
    }

    if (exception is TimeoutException) {
      return "Request Timeout";
    }

    if (exception is ApiException) {
      if (exception.httpCode >= 500) {
        return "Server Error";
      } else if (exception.httpCode >= 400) {
        return "Request Error";
      }
    }

    return "Error";
  }

  /// Check if the error is critical (should block user flow)
  static bool isCriticalError(dynamic exception, {String? endpoint}) {
    // Metadata errors are not critical - app can function without them
    if (endpoint?.contains('metadata') == true) {
      return false;
    }

    // Authentication errors are critical
    if (endpoint?.contains('auth') == true) {
      return true;
    }

    // Network errors are generally not critical unless it's auth
    if (exception is NetworkException) {
      return endpoint?.contains('auth') == true;
    }

    // Server errors are generally not critical except for auth
    if (exception is ApiException && exception.httpCode >= 500) {
      return endpoint?.contains('auth') == true;
    }

    return false;
  }
}
