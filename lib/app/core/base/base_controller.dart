import 'dart:async';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/page_state.dart';
import '/app/network/exceptions/api_exception.dart';
import '/app/network/exceptions/app_exception.dart';
import '/app/network/exceptions/json_format_exception.dart';
import '/app/network/exceptions/network_exception.dart';
import '/app/network/exceptions/not_found_exception.dart';
import '/app/network/exceptions/service_unavailable_exception.dart';
import '/app/network/exceptions/timeout_exception.dart';
import '/app/network/exceptions/unauthorize_exception.dart';
import '/app/services/connectivity_service.dart';
import '/flavors/build_config.dart';

abstract class BaseController extends GetxController {
  final Logger logger = BuildConfig.instance.config.logger;

  // AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

  final logoutController = false.obs;

  //Reload the page
  final _refreshController = false.obs;

  refreshPage(bool refresh) => _refreshController(refresh);

  //Controls page state
  final _pageSateController = PageState.DEFAULT.obs;

  PageState get pageState => _pageSateController.value;

  updatePageState(PageState state) => _pageSateController(state);

  resetPageState() => _pageSateController(PageState.DEFAULT);

  showLoading() => updatePageState(PageState.LOADING);

  hideLoading() => resetPageState();

  final _messageController = ''.obs;

  String get message => _messageController.value;

  showMessage(String msg) => _messageController(msg);

  final _errorMessageController = ''.obs;

  String get errorMessage => _errorMessageController.value;

  showErrorMessage(String msg) => _errorMessageController(msg);

  Future<void> showNetworkErrorSnackbar({String? customMessage}) async {
    bool isConnected = true;
    try {
      // Try to get connectivity service if it's registered
      if (Get.isRegistered<ConnectivityService>()) {
        isConnected = Get.find<ConnectivityService>().isConnected.value;
      }
    } catch (e) {
      logger.e('Error accessing connectivity service: $e');
    }

    // Show appropriate message based on connectivity state
    final message =
        customMessage ??
        (isConnected
            ? 'Unable to connect to server. Please try again later.'
            : 'No internet connection. Please check your network settings.');

    Get.snackbar(
      'Connection Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      icon: Icon(
        isConnected ? Icons.cloud_off : Icons.wifi_off,
        color: Colors.white,
      ),
      isDismissible: true,
      borderRadius: 8,
      margin: EdgeInsets.all(8),
    );
  }

  // Check if an error is related to network connectivity
  bool isNetworkError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();
    return errorMessage.contains('networkexception') ||
        errorMessage.contains('no internet') ||
        errorMessage.contains('failed host lookup') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('socket');
  }

  // ignore: long-parameter-list
  dynamic callDataService<T>(
    Future<T> future, {
    Function(Exception exception)? onError,
    Function(T response)? onSuccess,
    Function? onStart,
    Function? onComplete,
  }) async {
    Exception? ex;

    onStart == null ? showLoading() : onStart();

    try {
      final T response = await future;

      if (onSuccess != null) onSuccess(response);

      onComplete == null ? hideLoading() : onComplete();

      return response;
    } on ServiceUnavailableException catch (exception) {
      ex = exception;
      showErrorMessage(exception.message);
    } on UnauthorizedException catch (exception) {
      ex = exception;
      showErrorMessage(exception.message);
    } on TimeoutException catch (exception) {
      ex = exception;
      showErrorMessage(exception.message);
    } on NetworkException catch (exception) {
      ex = exception;
      showErrorMessage(exception.message);
    } on JsonFormatException catch (exception) {
      ex = exception;
      showErrorMessage(exception.message);
    } on NotFoundException catch (exception) {
      ex = exception;
      showErrorMessage(exception.message);
    } on ApiException catch (exception) {
      ex = exception;
    } on AppException catch (exception) {
      ex = exception;
      showErrorMessage(exception.message);
    } catch (error) {
      ex = AppException(message: "$error");
      logger.e("Controller>>>>>> error $error");
    }

    if (onError != null) onError(ex);

    onComplete == null ? hideLoading() : onComplete();
  }

  @override
  void onClose() {
    _messageController.close();
    _refreshController.close();
    _pageSateController.close();
    super.onClose();
  }
}
