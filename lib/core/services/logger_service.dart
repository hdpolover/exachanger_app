// lib/core/services/logger_service.dart
import 'package:logger/logger.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() => _instance;

  late final Logger _logger;

  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to display
        errorMethodCount: 5, // Number of method calls if there's an error
        lineLength: 120, // Width of the output
        colors: true, // Enable colors
        printEmojis: true, // Enable emojis
        printTime: true, // Enable timestamps
      ),
    );
  }

  void logInfo(String message, [dynamic data]) {
    _logger.i('$message${data != null ? ': $data' : ''}');
  }

  void logDebug(String message, [dynamic data]) {
    _logger.d('$message${data != null ? ': $data' : ''}');
  }

  void logWarning(String message, [dynamic data]) {
    _logger.w('$message${data != null ? ': $data' : ''}');
  }

  void logError(String message, [dynamic data]) {
    _logger.e('$message${data != null ? ': $data' : ''}');
  }

  void logVerbose(String message, [dynamic data]) {
    _logger.t('$message${data != null ? ': $data' : ''}');
  }
}
