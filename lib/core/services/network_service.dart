// lib/core/services/network_service.dart
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'logger_service.dart';

typedef NetworkResult<T> = Either<NetworkFailure, T>;

class NetworkService {
  final Dio _dio;
  final LoggerService _logger = LoggerService(); // Singleton instance

  NetworkService({BaseOptions? options})
      : _dio = Dio(options ?? BaseOptions()) {
    _dio.options = options ??
        BaseOptions(
          baseUrl: 'https://api.example.com',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<NetworkResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    _logger.logInfo('GET Request Initiated',
        {'path': path, 'queryParameters': queryParameters});
    return _handleRequest<T>(
      () => _dio.get(path, queryParameters: queryParameters),
      fromJson,
    );
  }

  Future<NetworkResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    _logger.logInfo('POST Request Initiated',
        {'path': path, 'data': data, 'queryParameters': queryParameters});
    return _handleRequest<T>(
      () => _dio.post(path, data: data, queryParameters: queryParameters),
      fromJson,
    );
  }

  Future<NetworkResult<T>> _handleRequest<T>(
    Future<Response<dynamic>> Function() request,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    try {
      final response = await request();
      _logger.logDebug('Response Received',
          {'statusCode': response.statusCode, 'data': response.data});

      final responseData = response.data;

      if (responseData is Map<String, dynamic> && fromJson != null) {
        return Right(fromJson(responseData));
      } else if (responseData is T) {
        return Right(responseData);
      }

      _logger.logWarning('Unexpected Response Format', {'data': responseData});
      return Left(NetworkFailure(
        message: 'Unexpected response format',
        statusCode: response.statusCode,
      ));
    } catch (error) {
      _logger.logError('Request Failed', {'error': error.toString()});
      return Left(NetworkFailure.fromException(error));
    }
  }
}

class NetworkFailure {
  final String message;
  final int? statusCode;

  NetworkFailure({
    required this.message,
    this.statusCode,
  });

  factory NetworkFailure.fromException(dynamic error) {
    if (error is DioException) {
      return NetworkFailure(
        message: error.message ?? 'Unknown network error occurred',
        statusCode: error.response?.statusCode,
      );
    }
    return NetworkFailure(message: error.toString());
  }

  @override
  String toString() {
    return 'NetworkFailure(message: $message, statusCode: $statusCode)';
  }
}
