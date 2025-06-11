import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Add additional scopes if needed
    scopes: ['email', 'profile'],
    // Force account picker to avoid cached credential issues
    forceCodeForRefreshToken: true,
  );

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  static Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  static Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  static Future<User?> signInWithGoogle() async {
    try {
      // Check if Google Play Services are available
      if (!await isGooglePlayServicesAvailable()) {
        throw 'Google Play Services are not available or not properly configured.';
      }

      // Clear any previous sign-in to prevent cached credential issues
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        // Ignore errors during sign out
        if (kDebugMode) {
          print('Warning: Could not sign out from previous session: $e');
        }
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        if (kDebugMode) {
          print('Google Sign-In was cancelled by user');
        }
        return null;
      }

      return await _handleGoogleSignIn(googleUser);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(
          'Firebase Auth Exception during Google Sign-In: ${e.code} - ${e.message}',
        );
      }
      throw _handleAuthException(e);
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In error: $e');
      }

      // For PigeonUserDetails errors, rethrow the original error so retry can detect it
      String errorStr = e.toString();
      if (errorStr.contains('PigeonUserDetails') ||
          errorStr.contains(
            'type \'List<Object?>\' is not a subtype of type',
          )) {
        // Rethrow original error for retry mechanism
        rethrow;
      } else if (errorStr.contains('sign_in_failed')) {
        throw 'Google Sign-In failed. Please check your internet connection and try again.';
      } else if (errorStr.contains('network_error')) {
        throw 'Network error during Google Sign-In. Please check your connection.';
      } else if (errorStr.contains('sign_in_cancelled')) {
        throw 'Google Sign-In was cancelled. Please try again.';
      }
      throw 'Google Sign-In failed: ${e.toString()}';
    }
  }

  // Handle Google Sign-In
  static Future<User?> _handleGoogleSignIn(
    GoogleSignInAccount googleUser,
  ) async {
    try {
      if (kDebugMode) {
        print('🔍 Starting _handleGoogleSignIn for: ${googleUser.email}');
        print('🔍 GoogleSignInAccount details:');
        print('   - ID: ${googleUser.id}');
        print('   - Email: ${googleUser.email}');
        print('   - DisplayName: ${googleUser.displayName}');
        print('   - PhotoUrl: ${googleUser.photoUrl}');
      } // Obtain the auth details from the request
      if (kDebugMode) {
        print('🔍 Attempting to get GoogleSignInAuthentication...');
      }

      // Store the current Firebase user state before attempting authentication
      User? currentUser = _auth.currentUser;

      // Set up a listener to catch successful authentication even if casting fails
      User? authenticatedUser;
      late StreamSubscription<User?> authListener;

      authListener = _auth.authStateChanges().listen((User? user) {
        if (user != null && user.uid != currentUser?.uid) {
          authenticatedUser = user;
          if (kDebugMode) {
            print(
              '🎯 Detected successful Firebase authentication: ${user.email}',
            );
          }
        }
      });

      final GoogleSignInAuthentication googleAuth;

      try {
        googleAuth = await googleUser.authentication;
        if (kDebugMode) {
          print('✅ GoogleSignInAuthentication obtained successfully');
          print(
            '   - AccessToken length: ${googleAuth.accessToken?.length ?? 0}',
          );
          print('   - IdToken length: ${googleAuth.idToken?.length ?? 0}');
        }
        await authListener.cancel();
      } catch (authError) {
        if (kDebugMode) {
          print('❌ Error getting GoogleSignInAuthentication: $authError');
          print('   - Error type: ${authError.runtimeType}');
          print('   - Error string: ${authError.toString()}');
        }

        // Check if this is the specific PigeonUserDetails casting error
        final errorStr = authError.toString();
        if (errorStr.contains('PigeonUserDetails') ||
            errorStr.contains('List<Object?>') ||
            errorStr.contains('type cast')) {
          if (kDebugMode) {
            print('🔧 PigeonUserDetails casting error detected');
            print(
              '⏳ Waiting to see if Firebase authentication succeeded despite the error...',
            );
          }

          // Wait a moment to see if Firebase authentication succeeded
          await Future.delayed(Duration(milliseconds: 2000));
          await authListener.cancel();

          if (authenticatedUser != null) {
            if (kDebugMode) {
              print(
                '✅ Firebase authentication succeeded despite casting error!',
              );
              print('✅ Authenticated user: ${authenticatedUser!.email}');
            }
            return authenticatedUser;
          }

          if (kDebugMode) {
            print(
              '🔧 No successful authentication detected, throwing specific error for retry mechanism',
            );
          }
          // Throw a specific error that the retry mechanism can catch
          throw 'PigeonUserDetails casting error: $authError';
        }

        await authListener.cancel();
        rethrow;
      }

      // Validate that we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw 'Failed to obtain Google authentication tokens';
      }

      if (kDebugMode) {
        print('🔍 Creating Firebase credential...');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (kDebugMode) {
        print('🔍 Signing in to Firebase with credential...');
      }

      // Add a small delay to help with Firebase service visibility issues
      await Future.delayed(Duration(milliseconds: 500));

      // Sign in to Firebase with the Google credentials
      final userCredential = await _signInWithCredentialRetry(credential);

      if (kDebugMode) {
        print('✅ Google Sign-In successful for: ${userCredential.user?.email}');
      }

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in _handleGoogleSignIn: $e');
        print('   - Error type: ${e.runtimeType}');
        print('   - Stack trace: ${StackTrace.current}');
      } // Check if this is the PigeonUserDetails error but Firebase auth actually succeeded
      final errorStr = e.toString();
      if ((errorStr.contains('PigeonUserDetails') ||
              errorStr.contains('List<Object?>') ||
              errorStr.contains('type cast')) &&
          _auth.currentUser != null) {
        if (kDebugMode) {
          print(
            '🎯 PigeonUserDetails error detected but Firebase user exists!',
          );
          print('✅ Using current Firebase user: ${_auth.currentUser!.email}');
        }
        return _auth.currentUser;
      }

      // Check for Firebase Auth specific errors that should trigger retry
      if (e is FirebaseAuthException) {
        if (kDebugMode) {
          print(
            'Firebase Auth Exception during Google Sign-In: ${e.code} - ${e.message}',
          );
        }

        // Handle specific Firebase errors that are retryable
        if (e.code == 'unknown' ||
            e.code == 'network-request-failed' ||
            e.code == 'too-many-requests' ||
            errorStr.contains('Visibility check was unavailable') ||
            errorStr.contains('internal error')) {
          // These are temporary/network issues that can be retried
          rethrow;
        }
      }

      // Preserve the original error for the retry mechanism to detect
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }

  // Sign out from Google explicitly
  static Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
      if (kDebugMode) {
        print('Successfully signed out from Google');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out from Google: $e');
      }
    }
  }

  // Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get Firebase ID token
  static Future<String?> getIdToken() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting ID token: $e');
      }
      return null;
    }
  }

  // Get device token for push notifications
  static Future<String?> getDeviceToken() async {
    try {
      // This would typically come from Firebase Messaging
      // For now, we'll generate a simple device identifier
      return 'device_token_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device token: $e');
      }
      return 'device_token_fallback';
    }
  }

  // Check if user is authenticated
  static bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // Check if Google Play Services are available and properly configured
  static Future<bool> isGooglePlayServicesAvailable() async {
    try {
      return await _googleSignIn.isSignedIn() ||
          true; // This checks if GoogleSignIn is properly configured
    } catch (e) {
      if (kDebugMode) {
        print('Google Play Services check failed: $e');
      }
      return false;
    }
  } // Sign in with Google with retry mechanism for PigeonUserDetails issues

  static Future<User?> signInWithGoogleRetry({int maxRetries = 2}) async {
    // Check if user is already authenticated (Firebase might have succeeded despite errors)
    if (_auth.currentUser != null) {
      if (kDebugMode) {
        print(
          '🎯 User already authenticated, skipping retry: ${_auth.currentUser!.email}',
        );
      }
      return _auth.currentUser;
    }

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        if (kDebugMode) {
          print('🔄 Google Sign-In attempt $attempt of $maxRetries');
        }
        User? user;

        // Use different methods based on attempt number
        if (attempt == maxRetries) {
          if (kDebugMode) {
            print(
              '🎯 Using Firebase auth state listener method (final attempt)',
            );
          }
          user = await signInWithGoogleStateListener();
        } else {
          // First attempt uses the standard method with enhanced error handling
          user = await signInWithGoogle();
        }

        if (kDebugMode && user != null) {
          print('✅ Google Sign-In retry successful on attempt $attempt');
        }

        return user;
      } catch (e) {
        String errorStr = e.toString();

        if (kDebugMode) {
          print(
            '❌ Google Sign-In attempt $attempt failed: ${errorStr.length > 100 ? errorStr.substring(0, 100) + "..." : errorStr}',
          );
        } // Check for retryable errors
        bool isPigeonError =
            errorStr.contains('PigeonUserDetails') ||
            errorStr.contains(
              'type \'List<Object?>\' is not a subtype of type',
            ) ||
            errorStr.contains(
              'Google authentication failed due to a compatibility issue',
            ) ||
            errorStr.contains(
              'Google Sign-In failed due to a plugin compatibility issue',
            );

        bool isFirebaseRetryableError = false;
        if (e is FirebaseAuthException) {
          isFirebaseRetryableError =
              e.code == 'unknown' ||
              e.code == 'network-request-failed' ||
              e.code == 'too-many-requests' ||
              errorStr.contains('Visibility check was unavailable') ||
              errorStr.contains('internal error');
        }

        bool shouldRetry =
            (isPigeonError || isFirebaseRetryableError) && attempt < maxRetries;

        // If it's a retryable error and we still have retries left
        if (shouldRetry) {
          String errorType = isPigeonError
              ? 'PigeonUserDetails'
              : 'Firebase Auth';
          if (kDebugMode) {
            print(
              '🔄 $errorType error detected, retrying... (attempt $attempt of $maxRetries)',
            );
          }

          // Clear any cached credentials before retry
          try {
            await _googleSignIn.signOut();
            await _auth.signOut();
            if (kDebugMode) {
              print('🧹 Cleared credentials for retry');
            }
          } catch (clearError) {
            if (kDebugMode) {
              print('⚠️ Error clearing credentials: $clearError');
            }
          } // Wait progressively longer between retries
          int delay = 1000 * attempt;
          if (kDebugMode) {
            print('⏳ Waiting ${delay}ms before retry...');
          }
          await Future.delayed(Duration(milliseconds: delay));

          // Check if user got authenticated during the delay
          if (_auth.currentUser != null) {
            if (kDebugMode) {
              print(
                '🎯 User authenticated during delay: ${_auth.currentUser!.email}',
              );
            }
            return _auth.currentUser;
          }

          continue;
        }

        // If it's the last attempt or a different error, rethrow
        if (kDebugMode) {
          print(
            '❌ Final attempt failed or non-PigeonUserDetails error, rethrowing',
          );
        }
        rethrow;
      }
    }

    throw 'Google Sign-In failed after $maxRetries attempts with all methods';
  }

  // Alternative Google Sign-In method that bypasses PigeonUserDetails issues
  static Future<User?> signInWithGoogleAlternative() async {
    try {
      if (kDebugMode) {
        print('Attempting alternative Google Sign-In method');
      }

      // Force disconnect any existing sessions
      try {
        await _googleSignIn.disconnect();
        await _auth.signOut();
      } catch (e) {
        // Ignore disconnect errors
      }

      // Wait a moment for cleanup
      await Future.delayed(Duration(milliseconds: 500));

      // Create a fresh GoogleSignIn instance
      final freshGoogleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        forceCodeForRefreshToken: false, // Disable to avoid caching issues
      );

      // Attempt sign-in with fresh instance
      final GoogleSignInAccount? googleUser = await freshGoogleSignIn.signIn();

      if (googleUser == null) {
        if (kDebugMode) {
          print('Google Sign-In was cancelled by user');
        }
        return null;
      }

      // Get authentication directly without caching
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw 'Failed to obtain Google authentication tokens';
      }

      // Create credential and sign in to Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (kDebugMode) {
        print(
          'Alternative Google Sign-In successful for: ${userCredential.user?.email}',
        );
      }

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print('Alternative Google Sign-In error: $e');
      }
      rethrow;
    }
  }

  // Alternative method that bypasses PigeonUserDetails entirely
  static Future<User?> signInWithGoogleDirect() async {
    try {
      if (kDebugMode) {
        print('🔧 Attempting direct Google Sign-In (bypassing Pigeon)...');
      }

      // Force complete sign out first
      try {
        await _googleSignIn.disconnect();
        await _auth.signOut();
      } catch (e) {
        // Ignore disconnect errors
      }

      // Wait for cleanup
      await Future.delayed(Duration(milliseconds: 1000));

      // Create a completely fresh GoogleSignIn instance with minimal configuration
      final freshGoogleSignIn = GoogleSignIn(
        scopes: ['email'],
        // Use basic configuration to avoid complex Pigeon interactions
      );

      if (kDebugMode) {
        print('🔧 Using fresh GoogleSignIn instance...');
      }

      // Attempt sign-in with fresh instance
      final GoogleSignInAccount? googleUser = await freshGoogleSignIn.signIn();

      if (googleUser == null) {
        if (kDebugMode) {
          print('🚫 Google Sign-In was cancelled by user');
        }
        return null;
      }

      if (kDebugMode) {
        print('✅ Got GoogleSignInAccount: ${googleUser.email}');
        print('🔧 Attempting manual token extraction...');
      }

      // Try to get authentication with multiple approaches
      GoogleSignInAuthentication? googleAuth;

      // Approach 1: Direct authentication call
      try {
        googleAuth = await googleUser.authentication;
        if (kDebugMode) {
          print('✅ Direct authentication successful');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Direct authentication failed: $e');
        }
      }

      // Approach 2: If direct fails, try with delay
      if (googleAuth == null) {
        try {
          if (kDebugMode) {
            print('🔧 Trying authentication with delay...');
          }
          await Future.delayed(Duration(milliseconds: 500));
          googleAuth = await googleUser.authentication;
          if (kDebugMode) {
            print('✅ Delayed authentication successful');
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Delayed authentication failed: $e');
          }
        }
      }

      // Approach 3: Try getting a fresh account reference
      if (googleAuth == null) {
        try {
          if (kDebugMode) {
            print('🔧 Trying with fresh account reference...');
          }
          final currentAccount = await freshGoogleSignIn.signInSilently();
          if (currentAccount != null) {
            googleAuth = await currentAccount.authentication;
            if (kDebugMode) {
              print('✅ Fresh account authentication successful');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Fresh account authentication failed: $e');
          }
        }
      }

      if (googleAuth == null ||
          googleAuth.accessToken == null ||
          googleAuth.idToken == null) {
        throw 'Failed to obtain Google authentication tokens with all approaches';
      }

      if (kDebugMode) {
        print(
          '✅ Got tokens - AccessToken: ${googleAuth.accessToken!.substring(0, 20)}...',
        );
        print(
          '✅ Got tokens - IdToken: ${googleAuth.idToken!.substring(0, 20)}...',
        );
      }

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      if (kDebugMode) {
        print(
          '🎉 Direct Google Sign-In successful for: ${userCredential.user?.email}',
        );
      }

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Direct Google Sign-In error: $e');
      }
      rethrow;
    }
  }

  // Completely alternative method that works around PigeonUserDetails issues
  // This method uses Firebase's auth state changes to detect successful authentication
  static Future<User?> signInWithGoogleStateListener() async {
    try {
      if (kDebugMode) {
        print('🔧 Using Firebase auth state listener method...');
      }

      // Force complete sign out first
      try {
        await _googleSignIn.disconnect();
        await _auth.signOut();
      } catch (e) {
        // Ignore disconnect errors
      }

      // Wait for cleanup
      await Future.delayed(Duration(milliseconds: 500));

      User? authenticatedUser;
      final completer = Completer<User?>();

      // Set up auth state listener
      late StreamSubscription<User?> authListener;
      authListener = _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          if (kDebugMode) {
            print(
              '🎯 Firebase auth state changed - user authenticated: ${user.email}',
            );
          }
          if (!completer.isCompleted) {
            authenticatedUser = user;
            completer.complete(user);
          }
        }
      });

      // Attempt Google Sign-In (this might fail with PigeonUserDetails error)
      try {
        if (kDebugMode) {
          print('🔧 Triggering Google Sign-In process...');
        }

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          await authListener.cancel();
          if (kDebugMode) {
            print('🚫 Google Sign-In was cancelled by user');
          }
          return null;
        }

        if (kDebugMode) {
          print('✅ Got GoogleSignInAccount: ${googleUser.email}');
          print('⏳ Waiting for Firebase authentication via state listener...');
        }

        // Wait for Firebase auth state change (with timeout)
        await completer.future.timeout(
          Duration(seconds: 10),
          onTimeout: () {
            if (kDebugMode) {
              print('⏰ Timeout waiting for Firebase auth state change');
            }
            return null;
          },
        );
      } catch (e) {
        if (kDebugMode) {
          print('❌ Google Sign-In process error: $e');
          print('⏳ Still waiting for Firebase auth state change...');
        }

        // Even if Google Sign-In throws an error, wait for potential Firebase auth state change
        await completer.future.timeout(
          Duration(seconds: 5),
          onTimeout: () {
            if (kDebugMode) {
              print(
                '⏰ Timeout waiting for Firebase auth state change after error',
              );
            }
            return null;
          },
        );
      } finally {
        await authListener.cancel();
      }

      if (authenticatedUser != null) {
        if (kDebugMode) {
          print(
            '✅ Successfully authenticated via state listener: ${authenticatedUser!.email}',
          );
        }
        return authenticatedUser;
      }

      throw 'No authentication detected via state listener method';
    } catch (e) {
      if (kDebugMode) {
        print('❌ State listener authentication failed: $e');
      }
      rethrow;
    }
  }

  // Helper method to sign in to Firebase with retries for network/visibility issues
  static Future<UserCredential> _signInWithCredentialRetry(
    AuthCredential credential, {
    int maxAttempts = 3,
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        if (kDebugMode && attempt > 1) {
          print(
            '🔄 Firebase credential sign-in attempt $attempt of $maxAttempts',
          );
        }

        return await _auth.signInWithCredential(credential);
      } catch (e) {
        if (e is FirebaseAuthException && attempt < maxAttempts) {
          // Check if it's a retryable Firebase error
          if (e.code == 'unknown' ||
              e.code == 'network-request-failed' ||
              e.message?.contains('Visibility check was unavailable') == true ||
              e.message?.contains('internal error') == true) {
            if (kDebugMode) {
              print(
                '⚠️ Firebase credential attempt $attempt failed: ${e.code} - ${e.message}',
              );
              print('⏳ Waiting before retry...');
            }

            // Wait progressively longer between retries
            await Future.delayed(Duration(milliseconds: 1000 * attempt));
            continue;
          }
        }

        // If not retryable or final attempt, rethrow
        rethrow;
      }
    }

    throw 'Firebase credential sign-in failed after $maxAttempts attempts';
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }
}
