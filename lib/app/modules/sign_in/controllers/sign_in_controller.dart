import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/signin_model.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../network/dio_provider.dart';
import '../../../routes/app_pages.dart';

class SignInController extends BaseController {
  final AuthRepository authRepository = Get.find(
    tag: (AuthRepository).toString(),
  );

  final Rx<SigninModel?> signinData = Rx<SigninModel?>(null);
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();

  void doSignIn(Map<String, dynamic> data) {
    var service = authRepository.getAuthData(data);

    callDataService(
      service,
      onStart: () {
        // Custom loading is handled in the view, so we don't need base loading
      },
      onSuccess: (data) {
        // Close loading dialog
        Get.back();

        // Store signIn data in the controller
        signinData.value = data;

        // Save all user data and tokens
        preferenceManager.saveUserDataFromSignin(data);

        // Set auth token for API calls
        DioProvider.setAuthToken(data.accessToken!);

        // Show success message
        Get.snackbar(
          'Welcome Back!',
          'You have successfully signed in.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );

        // Small delay before navigation for better UX
        Future.delayed(Duration(milliseconds: 300), () {
          Get.offNamed(Routes.MAIN);
        });
      },
      onError: (error) {
        // Close loading dialog
        Get.back();

        // Show error with beautiful snackbar
        Get.snackbar(
          'Sign In Failed',
          'Please check your credentials and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error, color: Colors.white),
        );

        showErrorMessage(error.toString());
      },
      onComplete: () {
        // Custom loading is handled in the view, so we don't need base loading
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
