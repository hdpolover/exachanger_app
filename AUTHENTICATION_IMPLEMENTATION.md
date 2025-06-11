# Authentication Implementation

This document describes the authentication system implemented in the Exachanger app with Firebase integration.

## Overview

The app now supports two types of authentication:
1. **Regular Email/Password Authentication** - Users can sign up and sign in using email and password
2. **Google Sign-In Authentication** - Users can sign up and sign in using their Google account

Both authentication methods are integrated with Firebase Authentication and your backend API.

## API Endpoints

The authentication system uses the following API endpoints:

### Sign In
- **Endpoint**: `POST /auth/sign-in`
- **Body**:
```json
{
    "email": "user@example.com",
    "password": "password123",
    "device_token": "device_token_value",
    "type": 0,  // 0: regular, 1: google
    "firebase_uid": "firebase_user_id",
    "firebase_token": "firebase_id_token"
}
```

### Sign Up
- **Endpoint**: `POST /auth/sign-up`
- **Body**:
```json
{
    "email": "user@example.com",
    "phone": "1234567890",
    "password": "password123",
    "referral_code": "REF123",  // Optional
    "device_token": "device_token_value",
    "type": 0,  // 0: regular, 1: google
    "firebase_uid": "firebase_user_id",
    "firebase_token": "firebase_id_token"
}
```

### Logout
- **Endpoint**: `POST /auth/logout`
- **Body**:
```json
{
    "refresh_token": "refresh_token_value"
}
```

## Key Components

### 1. FirebaseAuthService (`lib/app/services/firebase_auth_service.dart`)
Handles all Firebase Authentication operations:
- Email/password sign in and sign up
- Google Sign-In integration
- Firebase ID token management
- Device token generation
- Sign out functionality

### 2. AuthService (`lib/app/services/auth_service.dart`)
Manages the global authentication state:
- Observable authentication status
- Centralized logout functionality
- State synchronization between Firebase and local storage
- Navigation after authentication changes

### 3. Auth Repository & Remote Data Source
Handles API communication:
- Integrates Firebase authentication with backend API
- Sends Firebase UID and ID tokens to backend
- Manages refresh tokens
- Handles sign up, sign in, and logout operations

### 4. Updated UI Components
- **Sign In View**: Supports both email/password and Google sign-in
- **Sign Up View**: Supports both regular and Google sign-up with referral codes
- **Forgot Password**: Firebase-powered password reset
- **Profile View**: Updated logout functionality using AuthService

## Authentication Flow

### Regular Sign In Flow
1. User enters email and password
2. Firebase Authentication validates credentials
3. Firebase ID token is obtained
4. Request is sent to backend API with Firebase data
5. Backend validates Firebase token and returns app tokens
6. Local storage is updated with user data and tokens
7. User is navigated to main app

### Google Sign In Flow
1. User taps Google sign-in button
2. Google Sign-In flow is initiated
3. User authenticates with Google
4. Firebase Authentication processes Google credentials
5. Firebase ID token is obtained
6. Request is sent to backend API with Firebase data
7. Backend validates Firebase token and returns app tokens
8. Local storage is updated with user data and tokens
9. User is navigated to main app

### Sign Up Flow
Similar to sign in, but creates new user accounts in both Firebase and backend.

### Logout Flow
1. User initiates logout from profile screen
2. AuthService handles logout process
3. Backend API is notified (if possible)
4. Firebase sign out is performed
5. Local storage is cleared
6. User is navigated to sign-in screen

## Firebase Configuration

The app is already configured with Firebase:
- `firebase_options.dart` contains Firebase configuration
- `google-services.json` is configured for Android
- Firebase Auth and Google Sign-In dependencies are installed

## Security Features

1. **Firebase ID Token Validation**: Backend can validate Firebase ID tokens
2. **Device Token Tracking**: Each authentication includes device token
3. **Secure Logout**: Clears both local and Firebase authentication
4. **Error Handling**: Comprehensive error handling for authentication failures

## Usage Examples

### Using AuthService for Logout
```dart
final AuthService authService = Get.find<AuthService>();
authService.signOut(); // Handles complete logout process
```

### Checking Authentication Status
```dart
final AuthService authService = Get.find<AuthService>();
bool isLoggedIn = authService.isLoggedIn;
String? userEmail = authService.userEmail;
```

### Forgot Password
The forgot password functionality uses Firebase's built-in password reset:
```dart
// This is handled automatically in the ForgotPasswordDialog
await FirebaseAuthService.sendPasswordResetEmail(email);
```

## Testing

To test the authentication:
1. Run the app: `flutter run`
2. Try regular email/password sign up and sign in
3. Test Google Sign-In (requires proper Firebase configuration)
4. Test forgot password functionality
5. Test logout from profile screen

## Dependencies Added

The following dependencies were added to `pubspec.yaml`:
- `firebase_auth: ^4.15.3` - Firebase Authentication
- `google_sign_in: ^6.1.6` - Google Sign-In integration

## Error Handling

The system includes comprehensive error handling for:
- Firebase authentication errors
- Network connectivity issues
- API errors
- Invalid credentials
- Google Sign-In cancellation

All errors are displayed to users with appropriate messages and UI feedback.
