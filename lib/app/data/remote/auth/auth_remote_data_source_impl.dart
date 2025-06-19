import 'dart:convert';

import 'package:exachanger_get_app/app/data/models/api_response_model.dart';
import 'package:exachanger_get_app/app/data/models/signup_response_model.dart';
import 'package:exachanger_get_app/app/services/firebase_auth_service.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../../network/dio_provider.dart';
import '../../models/signin_model.dart';
import 'auth_remote_data_source.dart';

// Custom exception for user registration failures that shouldn't trigger server error page
class UserRegistrationException implements Exception {
  final String message;
  UserRegistrationException(this.message);

  @override
  String toString() => 'UserRegistrationException: $message';
}

// Custom exception for new user registration that requires PIN setup
class NewUserRegistrationException implements Exception {
  final String message;
  final String signature;

  NewUserRegistrationException(this.message, this.signature) {
    print(
      '🔍 NewUserRegistrationException: Created with message="$message", signature="$signature"',
    );
  }

  @override
  String toString() =>
      'NewUserRegistrationException: $message [signature:$signature]';
}

class AuthRemoteDataSourceImpl extends BaseRemoteSource
    implements AuthRemoteDataSource {
  @override
  Future<void> forgotPassword(String email) async {
    try {
      // Use Firebase to send password reset email
      await FirebaseAuthService.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    // Check if user has valid tokens in preferences instead of just Firebase auth
    try {
      final preferenceManager = Get.find<PreferenceManagerImpl>();
      final accessToken = await preferenceManager.getString('access_token');
      return accessToken.isNotEmpty;
    } catch (e) {
      // Fallback to Firebase check for backward compatibility
      return FirebaseAuthService.isAuthenticated();
    }
  }

  @override
  Future<SigninModel> signIn(Map<String, dynamic> data) async {
    print('🔍 AuthRemoteDataSource: signIn called with data: $data');

    // Check if this is a Firebase auth request (type 1 = Google)
    if (data['type'] == 1) {
      print('🔍 AuthRemoteDataSource: Taking Google sign-in flow path');
      return await _handleGoogleSignInFlow(data);
    } else {
      print(
        '🔍 AuthRemoteDataSource: Taking regular email/password sign-in flow path',
      );
      // Regular email/password sign-in: Use only API endpoint /auth/sign-in (NO Firebase)
      var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.signin}";
      var dioCall = dioClient.post(endpoint, data: jsonEncode(data));

      try {
        final response = await callApiWithErrorParser(
          dioCall,
        ); // Check if this is a 202 response indicating PIN setup is required
        if (response.statusCode == 202) {
          // Extract signature from 202 response for PIN setup
          String signature = '';
          try {
            final responseData = response.data;
            print('🔍 [Regular Sign-In] 202 Response data: $responseData');
            print(
              '🔍 [Regular Sign-In] Response data type: ${responseData.runtimeType}',
            );

            if (responseData is Map<String, dynamic> &&
                responseData.containsKey('data')) {
              final dataField = responseData['data'];
              print('🔍 [Regular Sign-In] Data field: $dataField');
              print(
                '🔍 [Regular Sign-In] Data field type: ${dataField.runtimeType}',
              );

              if (dataField is Map<String, dynamic>) {
                print(
                  '🔍 [Regular Sign-In] Data field keys: ${dataField.keys.toList()}',
                );
                // The signature is the key of the data map
                signature = dataField.keys.first;
                print('🔍 [Regular Sign-In] Extracted signature: "$signature"');
              } else if (dataField is String) {
                // Fallback if it's directly a string
                signature = dataField;
                print(
                  '🔍 [Regular Sign-In] Using data field as signature: "$signature"',
                );
              }
            } else {
              print(
                '🔍 [Regular Sign-In] Response data does not contain data field',
              );
            }
          } catch (e) {
            if (kDebugMode) {
              print('🚨 Error extracting signature from 202 response: $e');
            }
          }
          print(
            '🔍 [Regular Sign-In] Final signature before exception: "$signature"',
          );

          // Throw custom exception with signature for PIN setup flow
          print(
            '🔍 [Regular Sign-In] Creating NewUserRegistrationException with signature: "$signature"',
          );
          throw NewUserRegistrationException(
            'User exists but PIN setup is required.',
            signature,
          );
        }

        // Normal 200 response - parse as SigninModel
        return SigninModel.fromJson(
          ApiResponseModel.fromJson(response.data).data,
        );
      } catch (e) {
        // If it's already our custom exception, rethrow it
        if (e is NewUserRegistrationException) {
          rethrow;
        }
        // For all other errors, rethrow so they can be handled by the calling code
        rethrow;
      }
    }
  }

  // Handle Google Sign-In flow with automatic registration if user doesn't exist
  Future<SigninModel> _handleGoogleSignInFlow(
    Map<String, dynamic> originalData,
  ) async {
    try {
      // Step 1: Authenticate with Google Firebase
      if (kDebugMode) {
        print('🔐 Starting Google authentication...');
      }

      final user = await FirebaseAuthService.signInWithGoogleRetry();

      if (user == null) {
        throw Exception('Google sign-in was cancelled');
      }

      if (kDebugMode) {
        print('✅ Google authentication successful for: ${user.email}');
      }

      // Get Firebase ID token
      final idToken = await user.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Step 2: Try to sign in to backend first
      if (kDebugMode) {
        print('🔍 Checking if user exists in backend...');
      }
      try {
        return await _attemptBackendSignIn(user, idToken, originalData);
      } catch (signInError) {
        // If it's a PIN setup required exception, rethrow immediately (don't try to register)
        if (signInError is NewUserRegistrationException) {
          rethrow;
        }

        // Step 3: If sign-in fails for other reasons, try to register the user
        if (kDebugMode) {
          print('👤 User not found in backend, attempting registration...');
        }
        try {
          final signature = await _registerGoogleUser(
            user,
            idToken,
            originalData,
          );

          if (kDebugMode) {
            print('✅ User registration successful, signature received');
          }

          // Throw special exception that includes signature for PIN setup
          if (signature != null && signature.isNotEmpty) {
            throw NewUserRegistrationException(
              'New user registered successfully. PIN setup required.',
              signature,
            );
          } else {
            // Step 4: After successful registration, sign in the user (fallback)
            return await _attemptBackendSignIn(user, idToken, originalData);
          }
        } catch (registerError) {
          if (kDebugMode) {
            print('❌ Registration failed: $registerError');
            print('🔄 Rolling back Firebase authentication...');
          }

          // Rollback: Sign out from Firebase and clear cached credentials
          try {
            await FirebaseAuthService.signOut();
            if (kDebugMode) {
              print('✅ Successfully rolled back Firebase authentication');
            }
          } catch (rollbackError) {
            if (kDebugMode) {
              print('⚠️ Error during rollback: $rollbackError');
            }
          }

          // If it's already a UserRegistrationException, just rethrow it
          if (registerError is UserRegistrationException) {
            rethrow;
          }

          // For any other errors, wrap them in UserRegistrationException
          String userMessage = 'Registration failed. Please try again.';
          throw UserRegistrationException(userMessage);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Google sign-in flow failed: $e');
      } // Check if this is a PigeonUserDetails error and pass it through for retry
      String errorStr = e.toString();
      if (errorStr.contains('PigeonUserDetails') ||
          errorStr.contains(
            'type \'List<Object?>\' is not a subtype of type',
          ) ||
          errorStr.contains(
            'Google Sign-In failed due to a plugin compatibility issue',
          )) {
        // Rethrow original error for potential retry at higher level
        rethrow;
      }

      // If it's a NewUserRegistrationException, rethrow it directly (don't wrap it)
      if (e is NewUserRegistrationException) {
        rethrow;
      }

      throw Exception('Firebase Google sign-in failed: ${e.toString()}');
    }
  }

  // Attempt to sign in to backend with Google credentials
  Future<SigninModel> _attemptBackendSignIn(
    User user,
    String idToken,
    Map<String, dynamic> originalData,
  ) async {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.signin}";

    Map<String, dynamic> signInData = {
      'email': user.email,
      'device_token':
          await FirebaseAuthService.getDeviceToken() ?? 'device_token_fallback',
      'type': 1,
      'firebase_uid': user.uid,
      'firebase_token': idToken,
    };
    var dioCall = dioClient.post(endpoint, data: jsonEncode(signInData));

    try {
      final response = await callApiWithErrorParser(dioCall);

      // Check if this is a 202 response indicating PIN setup is required
      if (response.statusCode == 202) {
        // Extract signature from 202 response for PIN setup
        String signature = '';
        try {
          final responseData = response.data;
          print('🔍 [Google Sign-In] 202 Response data: $responseData');
          print(
            '🔍 [Google Sign-In] Response data type: ${responseData.runtimeType}',
          );

          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('data')) {
            final dataField = responseData['data'];
            print('🔍 [Google Sign-In] Data field: $dataField');
            print(
              '🔍 [Google Sign-In] Data field type: ${dataField.runtimeType}',
            );

            if (dataField is Map<String, dynamic>) {
              print(
                '🔍 [Google Sign-In] Data field keys: ${dataField.keys.toList()}',
              );
              // The signature is the key of the data map
              signature = dataField.keys.first;
              print('🔍 [Google Sign-In] Extracted signature: "$signature"');
            } else if (dataField is String) {
              // Fallback if it's directly a string
              signature = dataField;
              print(
                '🔍 [Google Sign-In] Using data field as signature: "$signature"',
              );
            }
          } else {
            print(
              '🔍 [Google Sign-In] Response data does not contain data field',
            );
          }
        } catch (e) {
          if (kDebugMode) {
            print('🚨 Error extracting signature from 202 response: $e');
          }
        }
        print(
          '🔍 [Google Sign-In] Final signature before exception: "$signature"',
        );

        // Throw custom exception with signature for PIN setup flow
        print(
          '🔍 [Google Sign-In] Creating NewUserRegistrationException with signature: "$signature"',
        );
        throw NewUserRegistrationException(
          'User exists but PIN setup is required.',
          signature,
        );
      }

      // Normal 200 response - parse as SigninModel
      return SigninModel.fromJson(
        ApiResponseModel.fromJson(response.data).data,
      );
    } catch (e) {
      // If it's already our custom exception, rethrow it
      if (e is NewUserRegistrationException) {
        rethrow;
      }
      // For all other errors, rethrow so they can be handled by the calling code
      rethrow;
    }
  }

  // Register Google user in backend
  Future<String?> _registerGoogleUser(
    User user,
    String idToken,
    Map<String, dynamic> originalData,
  ) async {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.signup}";

    Map<String, dynamic> registerData = {
      'email': user.email,
      'name': user.displayName ?? user.email?.split('@').first ?? 'Google User',
      'device_token':
          await FirebaseAuthService.getDeviceToken() ?? 'device_token_fallback',
      'type': 1,
      'firebase_uid': user.uid,
      'firebase_token': idToken,
    };

    // Add phone and referral_code if they exist in original data
    if (originalData.containsKey('phone') &&
        originalData['phone'] != null &&
        originalData['phone'] != '') {
      registerData['phone'] = originalData['phone'];
    }
    if (originalData.containsKey('referral_code') &&
        originalData['referral_code'] != null &&
        originalData['referral_code'] != '') {
      registerData['referral_code'] = originalData['referral_code'];
    }

    try {
      var dioCall = dioClient.post(endpoint, data: jsonEncode(registerData));
      final response = await callApiWithErrorParser(dioCall);

      // Parse the response to get the signature
      final signUpResponse = SignUpResponseModel.fromJson(response.data);
      return signUpResponse.data?.signature;
    } catch (e) {
      // Handle registration errors locally to prevent server error page triggering
      if (kDebugMode) {
        print('🔍 Registration API call failed: $e');
      }

      // Convert API exceptions to user-friendly messages without triggering server error page
      String userMessage = 'Registration failed. Please try again.';
      if (e.toString().contains('500') ||
          e.toString().contains('server') ||
          e.toString().contains('Duplicate entry')) {
        userMessage =
            'Our registration service is temporarily unavailable. Please try again in a few moments.';
      } else if (e.toString().contains('401') || e.toString().contains('403')) {
        userMessage =
            'Authentication failed. Please check your account and try again.';
      } else if (e.toString().contains('network') ||
          e.toString().contains('timeout')) {
        userMessage =
            'Network connection issue. Please check your internet connection and try again.';
      }

      // Throw our custom exception that won't trigger server error page
      throw UserRegistrationException(userMessage);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      // Logout from the API if endpoint is available
      var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.logout}";
      var dioCall = dioClient.post(
        endpoint,
        data: jsonEncode({"refresh_token": refreshToken}),
      );

      try {
        await callApiWithErrorParser(dioCall);
      } catch (e) {
        // Continue with cleanup even if API call fails
        print('API logout failed: $e');
      }

      // Only logout from Firebase if the user was authenticated with Firebase
      // Check if user has Firebase credentials
      if (await FirebaseAuthService.isAuthenticated()) {
        await FirebaseAuthService.signOut();
      }
    } catch (e) {
      // Even if everything fails, try to logout from Firebase if authenticated
      if (await FirebaseAuthService.isAuthenticated()) {
        await FirebaseAuthService.signOut();
      }
      rethrow;
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.refreshToken}";
    var dioCall = dioClient.post(
      endpoint,
      data: jsonEncode({"refresh_token": refreshToken}),
    );

    try {
      return callApiWithErrorParser(dioCall).then(
        (response) =>
            ApiResponseModel.fromJson(response.data).data["access_token"],
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SignUpResponseModel> signUp(Map<String, dynamic> data) async {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.signup}";

    // Check if this is a Firebase auth request (type 1 = Google)
    if (data['type'] == 1) {
      try {
        // Sign up with Google Firebase using retry mechanism
        final user = await FirebaseAuthService.signInWithGoogleRetry();

        if (user == null) {
          throw Exception('Google sign-up was cancelled');
        }

        // Get Firebase ID token
        final idToken = await user.getIdToken();

        // Create clean request data for Google sign-up
        Map<String, dynamic> googleData = {
          'email': user.email,
          'name':
              user.displayName ?? user.email?.split('@').first ?? 'Google User',
          'device_token':
              await FirebaseAuthService.getDeviceToken() ??
              'device_token_fallback',
          'type': 1,
          'firebase_uid': user.uid,
          'firebase_token': idToken,
        };

        // Add phone and referral_code if they exist in original data
        if (data.containsKey('phone') &&
            data['phone'] != null &&
            data['phone'] != '') {
          googleData['phone'] = data['phone'];
        }
        if (data.containsKey('referral_code') &&
            data['referral_code'] != null) {
          googleData['referral_code'] = data['referral_code'];
        }

        var dioCall = dioClient.post(endpoint, data: jsonEncode(googleData));
        return callApiWithErrorParser(
          dioCall,
        ).then((response) => SignUpResponseModel.fromJson(response.data));
      } catch (e) {
        throw Exception('Firebase Google sign-up failed: ${e.toString()}');
      }
    } else {
      // Regular email/password sign-up: Use only API endpoint (NO Firebase)
      // Create clean request data for regular sign-up
      Map<String, dynamic> signUpData = {
        'email': data['email'],
        'name': data['name'] ?? data['email']?.split('@').first ?? 'User',
        'phone': data['phone'] ?? '',
        'password': data['password'],
        'device_token':
            await FirebaseAuthService.getDeviceToken() ??
            'device_token_fallback',
        'type': 0,
      };

      // Add referral_code if it exists
      if (data.containsKey('referral_code') && data['referral_code'] != null) {
        signUpData['referral_code'] = data['referral_code'];
      }

      var dioCall = dioClient.post(endpoint, data: jsonEncode(signUpData));
      return callApiWithErrorParser(
        dioCall,
      ).then((response) => SignUpResponseModel.fromJson(response.data));
    }
  }

  @override
  Future<Map<String, dynamic>> setupPin(Map<String, dynamic> data) async {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.setupPin}";
    var dioCall = dioClient.patch(endpoint, data: jsonEncode(data));

    try {
      final response = await callApiWithErrorParser(dioCall);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
}
