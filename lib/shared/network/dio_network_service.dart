import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:exachanger_app/shared/network/exception/network_handler_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:exachanger_app/models/response/response.dart' as response;
import '../util/app_exception.dart';
import 'network_values.dart';
import 'network_service.dart';

bool kTestMode = true;

class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  late Dio dio;

  DioNetworkService() {
    dio = Dio();
    if (!kTestMode) {
      dio.options = dioBaseOptions;
      if (kDebugMode) {
        dio.interceptors
            .add(LogInterceptor(requestBody: true, responseBody: true));
      }
    }
  }

  BaseOptions get dioBaseOptions => BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20));

  @override
  String get baseUrl => dotenv.env[NetworkEnv.BASE_URL.name] ?? '';

  @override
  String get apiKey => dotenv.env[NetworkEnv.API_KEY.name] ?? '';

  @override
  Map<String, Object> get headers => {
        'accept': 'application/json',
        'content-type': 'application/json',
      };

  @override
  Map<String, dynamic>? updateHeaders(Map<String, dynamic> data) {
    final header = {...data, ...headers};
    if (!kTestMode) {
      dio.options.headers = headers;
    }
    return header;
  }

  @override
  Future<Either<AppException, response.Response>> get(String endPoint,
      {Map<String, dynamic>? queryParams}) {
    queryParams ??= {};
    queryParams[Params.apiKey] = apiKey;
    final res = handleException(
      () => dio.get(
        endPoint,
        queryParameters: queryParams,
      ),
      endPoint: endPoint,
    );
    return res;
  }

  @override
  Future<Either<AppException, response.Response>> post(String endPoint,
      {Map<String, dynamic>? data}) {
    // queryParams[Params.apiKey] = apiKey;
    final res = handleException(
        () => dio.post(
              endPoint,
              data: data,
            ),
        endPoint: endPoint);
    return res;
  }
}
