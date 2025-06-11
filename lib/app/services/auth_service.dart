import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:exachanger_get_app/app/services/firebase_auth_service.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:exachanger_get_app/app/network/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final AuthRepository _authRepository = Get.find(
    tag: (AuthRepository).toString(),
  );
  final PreferenceManagerImpl _preferenceManager =
      Get.find<PreferenceManagerImpl>();

  // Observable user authentication state
  final RxBool isAuthenticated = false.obs;
  final Rx<String?> currentUserEmail = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeAuthState();
  }

  void _initializeAuthState() async {
    // Check if user is already logged in
    final token = await _preferenceManager.getString('access_token');
    final isSignedIn = await _preferenceManager.getBool('is_signed_in');
    final userData = await _preferenceManager.getUserData();

    if (token.isNotEmpty && isSignedIn) {
      isAuthenticated.value = true;
      currentUserEmail.value = userData?.email;
      DioProvider.setAuthToken(token);
    } else {
      isAuthenticated.value = false;
      currentUserEmail.value = null;
    }

    // Listen to Firebase auth state changes
    FirebaseAuthService.authStateChanges.listen((user) {
      if (user == null && isAuthenticated.value) {
        // User signed out from Firebase, sync with local state
        _handleSignOut();
      }
    });
  }

  Future<void> signOut() async {
    try {
      // Get refresh token for API logout
      final refreshToken = await _preferenceManager.getString('refresh_token');

      if (refreshToken.isNotEmpty) {
        try {
          await _authRepository.logout(refreshToken);
        } catch (e) {
          // Continue with logout even if API call fails
          print('API logout failed: $e');
        }
      }

      await _handleSignOut();

      // Show success message
      Get.snackbar(
        'Signed Out',
        'You have been successfully signed out.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.logout, color: Colors.white),
      );

      // Navigate to sign in page
      Get.offAllNamed(Routes.SIGN_IN);
    } catch (e) {
      Get.snackbar(
        'Sign Out Error',
        'There was a problem signing you out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> _handleSignOut() async {
    // Use the existing logout method which clears relevant data
    await _preferenceManager.logout();

    // Sign out from Firebase
    await FirebaseAuthService.signOut();

    // Update state
    isAuthenticated.value = false;
    currentUserEmail.value = null;
  }

  void updateAuthState({required bool authenticated, String? email}) {
    isAuthenticated.value = authenticated;
    currentUserEmail.value = email;
  }

  bool get isLoggedIn => isAuthenticated.value;
  String? get userEmail => currentUserEmail.value;
}
