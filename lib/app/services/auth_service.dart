import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:exachanger_get_app/app/services/firebase_auth_service.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:exachanger_get_app/app/network/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exachanger_get_app/app/data/models/user_model.dart';

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
    try {
      // Perform comprehensive authentication state validation
      bool isValidAuth = await validateAndRepairAuthState();
      print("AuthService: Authentication state initialization complete");
      print("- Authentication valid: $isValidAuth");
      print("- Current auth state: ${isAuthenticated.value}");
      print("- Current user email: ${currentUserEmail.value}");

      // TODO: Re-enable Firebase auth state listener with proper user type checking
      // For now, commenting out to prevent logout issues for email/password users
      /*
      // Listen to Firebase auth state changes
      FirebaseAuthService.authStateChanges.listen((user) {
        print(
          "AuthService: Firebase auth state changed - user: ${user?.email ?? 'null'}",
        );

        // Only sync Firebase state for Google users (type: 1)
        // Regular email/password users (type: 0) should not be affected by Firebase state
        if (user == null && isAuthenticated.value) {
          // Check if current user is a Google user before syncing Firebase state
          _checkIfGoogleUserBeforeSync();
        }
      });
      */
    } catch (e) {
      print("AuthService: Error initializing auth state: $e");
      isAuthenticated.value = false;
      currentUserEmail.value = null;
      // Clean up any corrupted state
      await _preferenceManager.logout();
    }
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
    print("AuthService: updateAuthState called");
    print("- Setting authenticated: $authenticated");
    print("- Setting email: $email");

    // DO NOT set any persistent storage here - only update reactive state
    // The persistent storage should only be updated by PreferenceManager methods
    isAuthenticated.value = authenticated;
    currentUserEmail.value = email;

    print("AuthService: updateAuthState completed - MEMORY STATE ONLY");
    print("- Current authenticated state: ${isAuthenticated.value}");
    print("- Current email: ${currentUserEmail.value}");
    print("- NOTE: This does NOT affect persistent storage validation");
  }

  bool get isLoggedIn => isAuthenticated.value;
  String? get userEmail => currentUserEmail
      .value; // Add a method to validate and repair authentication state
  Future<bool> validateAndRepairAuthState() async {
    try {
      print("AuthService: Validating authentication state consistency");

      final token = await _preferenceManager.getString('access_token');
      final refreshToken = await _preferenceManager.getString('refresh_token');
      final isSignedIn = await _preferenceManager.getBool('is_signed_in');
      final userData = await _preferenceManager.getUserData();

      print("AuthService: Auth state components:");
      print("- Access token: ${token.isNotEmpty}");
      print("- Refresh token: ${refreshToken.isNotEmpty}");
      print("- Is signed in flag: $isSignedIn");
      print("- User data: ${userData != null}");
      print("- User type: ${userData?.type} (0=email/password, 1=google)");

      // Check for basic inconsistencies
      bool hasTokens = token.isNotEmpty && refreshToken.isNotEmpty;
      bool hasCompleteState = hasTokens && isSignedIn && userData != null;

      if (!hasCompleteState) {
        print(
          "AuthService: Inconsistent authentication state detected, cleaning up",
        );
        print("- Missing tokens: ${!hasTokens}");
        print("- Missing sign-in flag: ${!isSignedIn}");
        print("- Missing user data: ${userData == null}");

        await _handleSignOut();
        return false;
      } // Now validate based on authentication type
      bool isGoogleUser = userData.type == 1;

      if (isGoogleUser) {
        print("AuthService: Validating Google Sign-In user authentication");
        return await _validateGoogleUserAuth(token, refreshToken, userData);
      } else {
        print(
          "AuthService: Validating regular email/password user authentication",
        );
        return await _validateRegularUserAuth(token, refreshToken, userData);
      }
    } catch (e) {
      print("AuthService: Error validating auth state: $e");
      await _handleSignOut();
      return false;
    }
  }

  // Validate regular email/password user (no Firebase dependency)
  Future<bool> _validateRegularUserAuth(
    String token,
    String refreshToken,
    UserModel userData,
  ) async {
    try {
      print(
        "AuthService: Validating regular user authentication (server-only)",
      );

      // Set the token temporarily to test it
      DioProvider.setAuthToken(token);

      // Try to validate the token by making a simple API call
      bool tokenValid = await _authRepository.isLoggedIn();

      if (tokenValid) {
        // Token is valid, update service state
        isAuthenticated.value = true;
        currentUserEmail.value = userData.email;
        print(
          "AuthService: Regular user authentication validated and confirmed",
        );
        return true;
      } else {
        print("AuthService: Regular user token validation failed, cleaning up");
        await _handleSignOut();
        return false;
      }
    } catch (e) {
      print("AuthService: Error validating regular user token: $e");
      // Handle network errors gracefully for regular users
      if (e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('timeout')) {
        print(
          "AuthService: Network error during regular user validation, keeping user logged in",
        );
        isAuthenticated.value = true;
        currentUserEmail.value = userData.email;
        DioProvider.setAuthToken(token);
        return true;
      } else {
        // Other errors suggest corrupted auth state
        print("AuthService: Regular user auth validation error, cleaning up");
        await _handleSignOut();
        return false;
      }
    }
  }

  // Validate Google Sign-In user (Firebase + server validation)
  Future<bool> _validateGoogleUserAuth(
    String token,
    String refreshToken,
    UserModel userData,
  ) async {
    try {
      print(
        "AuthService: Validating Google user authentication (Firebase + server)",
      );

      // First check Firebase authentication state
      final firebaseUser = FirebaseAuthService.currentUser;
      print("AuthService: Firebase user present: ${firebaseUser != null}");

      if (firebaseUser == null) {
        print(
          "AuthService: Google user missing Firebase authentication, cleaning up",
        );
        await _handleSignOut();
        return false;
      }

      // Verify Firebase user email matches stored user email
      if (firebaseUser.email != userData.email) {
        print("AuthService: Firebase user email mismatch, cleaning up");
        print("- Firebase email: ${firebaseUser.email}");
        print("- Stored email: ${userData.email}");
        await _handleSignOut();
        return false;
      }

      // Now validate server token
      DioProvider.setAuthToken(token);
      bool tokenValid = await _authRepository.isLoggedIn();

      if (tokenValid) {
        // Both Firebase and server validation passed
        isAuthenticated.value = true;
        currentUserEmail.value = userData.email;
        print(
          "AuthService: Google user authentication validated (Firebase + server)",
        );
        return true;
      } else {
        print(
          "AuthService: Google user server token validation failed, cleaning up",
        );
        await _handleSignOut();
        return false;
      }
    } catch (e) {
      print("AuthService: Error validating Google user auth: $e");
      // Handle network errors gracefully for Google users too
      if (e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('timeout')) {
        print(
          "AuthService: Network error during Google user validation, keeping user logged in",
        );
        // Still check Firebase state even during network issues
        final firebaseUser = FirebaseAuthService.currentUser;
        if (firebaseUser != null && firebaseUser.email == userData.email) {
          isAuthenticated.value = true;
          currentUserEmail.value = userData.email;
          DioProvider.setAuthToken(token);
          return true;
        } else {
          print(
            "AuthService: Firebase state invalid during network error, cleaning up",
          );
          await _handleSignOut();
          return false;
        }
      } else {
        // Other errors suggest corrupted auth state
        print("AuthService: Google user auth validation error, cleaning up");
        await _handleSignOut();
        return false;
      }
    }
  }

  // Method to ensure proper token persistence on successful authentication
  Future<void> ensureTokenPersistence(
    String accessToken,
    String refreshToken,
    String? userEmail,
  ) async {
    try {
      print("AuthService: Ensuring token persistence");

      // Set tokens in Dio
      DioProvider.setAuthToken(accessToken);

      // Update local state
      isAuthenticated.value = true;
      currentUserEmail.value = userEmail;

      print("AuthService: Token persistence ensured");
      print("- Authenticated: ${isAuthenticated.value}");
      print("- User email: ${currentUserEmail.value}");
    } catch (e) {
      print("AuthService: Error ensuring token persistence: $e");
    }
  }

  /*
  // Check if current user is Google user before syncing Firebase state
  Future<void> _checkIfGoogleUserBeforeSync() async {
    try {
      final userData = await _preferenceManager.getUserData();
      if (userData != null && userData.type == 1) {
        // This is a Google user, Firebase state matters
        print(
          "AuthService: Firebase sign out detected for Google user, syncing local state",
        );
        _handleSignOut();
      } else {
        // This is a regular email/password user, ignore Firebase state changes
        print(
          "AuthService: Firebase sign out detected but user is email/password type, ignoring",
        );
      }
    } catch (e) {
      print("AuthService: Error checking user type for Firebase sync: $e");
      // If we can't determine user type, err on the side of caution
      print(
        "AuthService: Could not determine user type, syncing Firebase state",
      );
      _handleSignOut();
    }
  }
  */
}
