import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '/app/network/exceptions/api_exception.dart';
import '/app/network/exceptions/app_exception.dart';
import '/app/network/exceptions/network_exception.dart';
import '/app/network/exceptions/not_found_exception.dart';
import '/app/network/exceptions/service_unavailable_exception.dart';
import '/flavors/build_config.dart';

Exception handleError(String error) {
  final logger = BuildConfig.instance.config.logger;
  logger.e("Generic exception: $error");

  return AppException(message: error);
}

Exception handleDioError(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.cancel:
      return AppException(message: "Request to API server was cancelled");
    case DioExceptionType.connectionTimeout:
      return AppException(message: "Connection timeout with API server");
    case DioExceptionType.connectionError:
      return NetworkException("There is no internet connection");
    case DioExceptionType.receiveTimeout:
      return TimeoutException("Receive timeout in connection with API server");
    case DioExceptionType.sendTimeout:
      return TimeoutException("Send timeout in connection with API server");
    case DioExceptionType.badResponse:
      return _parseDioErrorResponse(dioError);
    case DioExceptionType.badCertificate:
      return AppException(message: 'Bad certificate');
    case DioExceptionType.unknown:
      return NetworkException("There is no internet connection");
  }
}

Exception _parseDioErrorResponse(DioException dioError) {
  final logger = BuildConfig.instance.config.logger;

  int statusCode = dioError.response?.statusCode ?? -1;
  String? status;
  String? serverMessage;

  try {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      statusCode =
          dioError.response?.data["statusCode"] ??
          dioError.response?.data["code"];
    }
    status = dioError.response?.data["status"];

    // Check for message in different possible locations
    serverMessage =
        dioError.response?.data["message"] ??
        dioError.response?.data["error"] ??
        dioError.response?.data["detail"];
  } catch (e, s) {
    logger.i("$e");
    logger.i(s.toString());

    serverMessage = "Something went wrong. Please try again later.";
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable:
      return ServiceUnavailableException("Service Temporarily Unavailable");
    case HttpStatus.notFound:
      return NotFoundException(serverMessage ?? "", status ?? "");
    case HttpStatus.internalServerError:
      return ApiException(
        httpCode: statusCode,
        status: status ?? "",
        message:
            serverMessage ??
            "The server is currently experiencing issues. Please try again later.",
      );
    case HttpStatus.badGateway:
    case HttpStatus.gatewayTimeout:
      return ApiException(
        httpCode: statusCode,
        status: status ?? "",
        message:
            "Service is temporarily unavailable. Please try again in a few minutes.",
      );
    default:
      return ApiException(
        httpCode: statusCode,
        status: status ?? "",
        message:
            serverMessage ?? "Something went wrong. Please try again later.",
      );
  }
}
