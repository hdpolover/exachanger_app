import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_connect/http/src/status/http_status.dart';

import '/app/core/base/base_controller.dart';
import '/app/network/dio_provider.dart';
import '/app/network/error_handlers.dart';
import '/app/network/exceptions/base_exception.dart';
import '/app/network/exceptions/network_exception.dart';
import '/flavors/build_config.dart';

abstract class BaseRemoteSource {
  Dio get dioClient => DioProvider.withAuth;

  final logger = BuildConfig.instance.config.logger;

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
      logger.e(
        "Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).message}",
      );

      // Show snackbar for network errors if a controller is available
      if (exception is NetworkException) {
        try {
          if (Get.isRegistered<BaseController>()) {
            BaseController controller = Get.find<BaseController>();
            controller.showNetworkErrorSnackbar();
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
}
