import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/signin_model.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:exachanger_get_app/app/services/auth_service.dart';
import 'package:exachanger_get_app/app/network/exceptions/api_exception.dart';
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
  final AuthService authService = Get.find<AuthService>();

  void doSignIn(Map<String, dynamic> data) {
    print("SignInController: doSignIn called with data: $data");
    var service = authRepository.getAuthData(data);

    print("SignInController: Starting authentication API call");
    callDataService(
      service,
      onStart: () {
        print("SignInController: onStart callback called");
        // Custom loading is handled in the view, so we don't need base loading
      },
      onSuccess: (data) async {
        print(
          "SignInController: onSuccess callback called - AUTHENTICATION SUCCESSFUL!",
        );
        // Close loading dialog
        Get.back();

        // Store signIn data in the controller
        signinData.value = data;

        print(
          "SignInController: Sign-in successful for user: ${data.data?.name} (${data.data?.email})",
        );
        print("SignInController: User type in response: ${data.data?.type}");
        print(
          "SignInController: Access token length: ${data.accessToken?.length ?? 0}",
        );
        print(
          "SignInController: Refresh token length: ${data.refreshToken?.length ?? 0}",
        );

        // CRITICAL: Clear any old authentication data first to avoid conflicts
        print(
          "SignInController: Clearing old authentication data before saving new data",
        );
        await preferenceManager.logout(); // This clears old data

        print(
          "SignInController: Old data cleared, proceeding with new data save",
        );

        // CRITICAL FIX: For email/password sign-in, manually set type to 0
        // The server might be returning wrong type, so we override it
        if (data.data != null) {
          print(
            "SignInController: Original user type from server: ${data.data!.type}",
          );
          print(
            "SignInController: Setting user type to 0 for email/password authentication",
          );

          // Create a new DataModel with the correct type
          var correctedDataModel = DataModel(
            id: data.data!.id,
            email: data.data!.email,
            name: data.data!.name,
            role: data.data!.role,
            type: 0, // Force email/password type
            permissions: data.data!.permissions,
            date: data.data!.date,
            expired: data.data!.expired,
          );

          // Create a new SigninModel with corrected data
          data = SigninModel(
            accessToken: data.accessToken,
            refreshToken: data.refreshToken,
            data: correctedDataModel,
            expiredIn: data.expiredIn,
          );
          print("SignInController: User type corrected to: ${data.data?.type}");
        }

        // Save all user data and tokens SYNCHRONOUSLY
        bool saveSuccess = await preferenceManager.saveUserDataFromSignin(data);

        if (saveSuccess) {
          print("SignInController: User data saved successfully");

          // Ensure AuthService state is properly updated and persisted
          await authService.ensureTokenPersistence(
            data.accessToken!,
            data.refreshToken!,
            data.data?.email,
          );

          print("SignInController: AuthService state synchronized");
        } else {
          print(
            "SignInController: CRITICAL ERROR - User data save failed, aborting sign-in",
          );

          // If save failed, show error and don't proceed
          Get.snackbar(
            'Sign In Error',
            'Failed to save authentication data. Please try again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            icon: Icon(Icons.error, color: Colors.white),
          );
          return; // Don't proceed with navigation
        }

        // Set auth token for API calls
        DioProvider.setAuthToken(data.accessToken!);

        // Update auth service state
        authService.updateAuthState(
          authenticated: true,
          email: data.data?.email,
        );

        print("SignInController: Authentication state updated in AuthService");

        // Show success message with context-aware messaging
        String welcomeMessage = 'You have successfully signed in.';
        String welcomeTitle = 'Welcome Back!';

        // Check if this was a Google Sign-In (we can add a field to track this)
        if (data.data?.name != null && data.data!.name!.isNotEmpty) {
          welcomeTitle = 'Welcome to Exachanger!';
          welcomeMessage =
              'Successfully signed in. Welcome ${data.data!.name}!';
        }

        Get.snackbar(
          welcomeTitle,
          welcomeMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 4), // Longer for Google Sign-In messaging
          icon: Icon(Icons.check_circle, color: Colors.white),
          margin: EdgeInsets.all(16), // Add margins for better spacing
          borderRadius: 8, // Add border radius for better appearance
          isDismissible: true, // Allow manual dismissal
          forwardAnimationCurve: Curves.easeOutBack,
        );

        // Small delay before navigation for better UX - but ensure save is complete
        Future.delayed(Duration(milliseconds: 300), () {
          Get.offNamed(Routes.MAIN);
        });
      },
      onError: (error) {
        // Close loading dialog
        Get.back();

        // Extract the actual error message from API response
        String errorMessage = 'Please check your credentials and try again.';
        String errorTitle = 'Sign In Failed';

        if (error is ApiException && error.message.isNotEmpty) {
          errorMessage = error.message;
        } else if (error.toString().contains('UserRegistrationException: ')) {
          // Handle our custom registration exception
          errorTitle = 'Registration Failed';
          errorMessage = error.toString().substring(
            24,
          ); // Remove "UserRegistrationException: " prefix
        } else {
          // Try to extract message from other exception types
          String errorStr = error.toString();
          if (errorStr.contains('Exception: ') && errorStr.length > 11) {
            String extractedError = errorStr.substring(
              11,
            ); // Remove "Exception: " prefix

            // Handle specific registration failure (legacy support)
            if (extractedError.startsWith('REGISTRATION_FAILED: ')) {
              errorTitle = 'Registration Failed';
              errorMessage = extractedError.substring(
                22,
              ); // Remove "REGISTRATION_FAILED: " prefix
            } else if (extractedError.contains(
              'Firebase Google sign-in failed',
            )) {
              // Handle Firebase authentication errors
              errorTitle = 'Authentication Failed';
              if (extractedError.contains('REGISTRATION_FAILED: ')) {
                // Extract the user-friendly message after the registration failed indicator
                int startIndex =
                    extractedError.indexOf('REGISTRATION_FAILED: ') + 22;
                errorMessage = extractedError.substring(startIndex);
              } else {
                errorMessage =
                    'Google Sign-In encountered an issue. Please try again.';
              }
            } else {
              errorMessage = extractedError;
            }
          }
        }

        // Show error with the actual API message
        Get.snackbar(
          errorTitle,
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
