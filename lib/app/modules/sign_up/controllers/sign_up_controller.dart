import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends BaseController {
  // Make formKey lazy-initialized to avoid duplicate keys
  late final formKey = GlobalKey<FormState>();

  String? fullName;
  String? email;
  String? phone;
  String? password;

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
    // Just reset the state if needed
    formKey.currentState?.reset();
    super.onClose();
  }

  void doSignUp(Map<String, dynamic> data) {
    // In a real app, you would call an API here
    showLoading();

    Future.delayed(Duration(seconds: 2), () {
      hideLoading();
      // After successful signup, navigate to login page
      Get.snackbar(
        'Success',
        'Your account has been created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to sign in screen
      Get.offAndToNamed(Routes.SIGN_IN);
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }
}
