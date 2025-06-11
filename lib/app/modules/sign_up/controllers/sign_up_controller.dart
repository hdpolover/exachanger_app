import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:exachanger_get_app/app/network/exceptions/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends BaseController {
  // Make formKey lazy-initialized to avoid duplicate keys
  late final formKey = GlobalKey<FormState>();

  final AuthRepository authRepository = Get.find(
    tag: (AuthRepository).toString(),
  );

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
    var service = authRepository.signUp(data);

    callDataService(
      service,
      onStart: () {
        // Custom loading is handled in the view
      },
      onSuccess: (response) {
        // Close loading dialog
        Get.back();

        // Show success message
        Get.snackbar(
          'Welcome!',
          'Your account has been created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3), // Slightly increased duration
          icon: Icon(Icons.check_circle, color: Colors.white),
          margin: EdgeInsets.all(16), // Add margins for better spacing
          borderRadius: 8, // Add border radius for better appearance
          isDismissible: true, // Allow manual dismissal
          forwardAnimationCurve: Curves.easeOutBack,
        );

        // Small delay before navigation for better UX
        Future.delayed(Duration(milliseconds: 300), () {
          Get.offAndToNamed(Routes.SIGN_IN);
        });
      },
      onError: (error) {
        // Close loading dialog
        Get.back();

        // Extract the actual error message from API response
        String errorMessage = 'Please check your information and try again.';

        if (error is ApiException && error.message.isNotEmpty) {
          errorMessage = error.message;
        } else {
          // Try to extract message from other exception types
          String errorStr = error.toString();
          if (errorStr.contains('Exception: ') && errorStr.length > 11) {
            errorMessage = errorStr.substring(
              11,
            ); // Remove "Exception: " prefix
          }
        }

        // Show error with the actual API message
        Get.snackbar(
          'Sign Up Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(
            seconds: 5,
          ), // Increased duration for better readability
          icon: Icon(Icons.error, color: Colors.white),
          margin: EdgeInsets.all(16), // Add margins for better spacing
          borderRadius: 8, // Add border radius for better appearance
          isDismissible: true, // Allow manual dismissal
          forwardAnimationCurve: Curves.easeOutBack,
        );
      },
      onComplete: () {
        // Custom loading is handled in the view
      },
    );
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
