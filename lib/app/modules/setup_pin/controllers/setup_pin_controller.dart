import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/signup_response_model.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_loading_dialog.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SetupPinController extends BaseController {
  final AuthRepository authRepository = Get.find(
    tag: (AuthRepository).toString(),
  );

  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();

  // PIN input controllers
  final List<TextEditingController> pinControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Focus nodes for PIN input
  final List<FocusNode> pinFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  // Current PIN value
  RxString currentPin = ''.obs;

  // Signature from sign-up response
  late String signature;
  @override
  void onInit() {
    super.onInit();
    // Get signature from arguments
    final args = Get.arguments;
    print('🔍 SetupPinController: Received arguments: $args');
    if (args != null && args is Map<String, dynamic>) {
      signature = args['signature'] ?? '';
      print(
        '🔍 SetupPinController: Extracted signature: "$signature"',
      ); // TEMPORARY: Alert if we received the literal "signature" string
      if (signature == 'signature') {
        print(
          '⚠️ SetupPinController: WARNING - Received literal "signature" string instead of actual signature',
        );
        print(
          '⚠️ SetupPinController: This indicates a signature extraction issue in the auth flow',
        );
        // For now, proceed with the placeholder signature to allow testing the PIN setup flow
      } else if (signature.length > 100) {
        print(
          '✅ SetupPinController: Received valid encrypted signature (${signature.length} chars)',
        );
      }
    } else {
      signature = '';
      print(
        '🔍 SetupPinController: No arguments received, using empty signature',
      );
    }

    print('🔍 SetupPinController: Final signature value: "$signature"');
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var focusNode in pinFocusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }

  void onPinChanged(String value, int index) {
    // Handle backspace - if current field is empty and we're deleting
    if (value.isEmpty && pinControllers[index].text.isEmpty && index > 0) {
      // Move to previous field and clear it
      pinControllers[index - 1].clear();
      pinFocusNodes[index - 1].requestFocus();
    } else {
      // Normal input handling
      pinControllers[index].text = value;

      // Move to next field if not empty and not last field
      if (value.isNotEmpty && index < 5) {
        pinFocusNodes[index + 1].requestFocus();
      }
    }

    // Build current PIN
    String pin = '';
    for (var controller in pinControllers) {
      pin += controller.text;
    }
    currentPin.value = pin;
  }

  void setupPin() {
    if (currentPin.value.length != 6) {
      // Add haptic feedback for error
      HapticFeedback.heavyImpact();

      // Shake animation effect (visual feedback handled in view)
      _showErrorFeedback();

      Get.snackbar(
        'Invalid PIN',
        'Please enter a 6-digit PIN',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.error, color: Colors.white),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return;
    }

    if (signature.isEmpty) {
      HapticFeedback.heavyImpact();
      _showErrorFeedback();

      Get.snackbar(
        'Error',
        'Invalid signature. Please try signing up again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.error, color: Colors.white),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return;
    }

    // Success haptic feedback
    HapticFeedback.lightImpact();

    // Show loading dialog
    Get.dialog(
      CustomLoadingDialog(
        message: 'Setting up your PIN...',
        backgroundColor: Colors.white,
        textColor: Colors.black87,
      ),
      barrierDismissible: false,
    );

    // Create request data
    final setupPinRequest = SetupPinRequest(
      signature: signature,
      pin: currentPin.value,
    );

    // Call the repository method
    var service = authRepository.setupPin(setupPinRequest.toJson());

    callDataService(
      service,
      onStart: () {
        // Already showing loading dialog
      },
      onSuccess: (data) async {
        // Success haptic feedback
        HapticFeedback.mediumImpact();

        // Close loading dialog
        Get.back();

        // Store authentication data and log in the user
        final setupPinResponse = SetupPinResponseModel.fromJson(data);
        if (setupPinResponse.data != null) {
          await _storeAuthData(setupPinResponse.data!);
        }

        // Show success message
        Get.snackbar(
          'Success!',
          'Your PIN has been set up successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.check_circle, color: Colors.white),
          margin: EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );

        // Navigate to home after delay
        Future.delayed(Duration(milliseconds: 1500), () {
          Get.offAllNamed(Routes.HOME);
        });
      },
      onError: (error) {
        // Error haptic feedback
        HapticFeedback.heavyImpact();

        // Close loading dialog
        Get.back();

        // Show error feedback animation
        _showErrorFeedback();

        // Handle specific error cases
        String errorMessage = 'Failed to setup PIN. Please try again.';
        if (error.toString().contains('Invalid signature')) {
          errorMessage = 'Invalid signature. Please sign up again.';
        } else if (error.toString().contains('network') ||
            error.toString().contains('timeout')) {
          errorMessage =
              'Network error. Please check your connection and try again.';
        }

        Get.snackbar(
          'Setup Failed',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.error, color: Colors.white),
          margin: EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      },
    );
  }

  void _showErrorFeedback() {
    // This could trigger a visual shake animation in the view
    // For now, we'll just clear the PIN to provide feedback
    Future.delayed(Duration(milliseconds: 100), () {
      // Quick visual feedback by temporarily changing focus
      for (int i = 0; i < pinControllers.length; i++) {
        if (pinControllers[i].text.isNotEmpty) {
          pinFocusNodes[i].requestFocus();
          Future.delayed(Duration(milliseconds: 50), () {
            pinFocusNodes[i].unfocus();
          });
        }
      }
    });
  }

  void clearPin() {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Clear all controllers with a small delay for visual effect
    for (int i = 0; i < pinControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        pinControllers[i].clear();
      });
    }

    currentPin.value = '';

    // Focus on first field after clearing
    Future.delayed(Duration(milliseconds: 300), () {
      pinFocusNodes[0].requestFocus();
    });
  }

  // Store authentication data locally
  Future<void> _storeAuthData(SetupPinData data) async {
    try {
      if (data.accessToken != null) {
        await preferenceManager.setString('access_token', data.accessToken!);
      }
      if (data.refreshToken != null) {
        await preferenceManager.setString('refresh_token', data.refreshToken!);
      }
      if (data.userData?.id != null) {
        await preferenceManager.setString('user_id', data.userData!.id!);
      }
      if (data.userData?.email != null) {
        await preferenceManager.setString('user_email', data.userData!.email!);
      }
      if (data.userData?.name != null) {
        await preferenceManager.setString('user_name', data.userData!.name!);
      }

      // Set login status
      await preferenceManager.setBool('is_logged_in', true);
    } catch (e) {
      print('Error storing auth data: $e');
    }
  }
}
