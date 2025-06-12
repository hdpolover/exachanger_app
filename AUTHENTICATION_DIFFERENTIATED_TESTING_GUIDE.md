# Comprehensive Authentication Testing Guide

## Overview
This app supports two distinct authentication flows with different validation requirements:
1. **Regular Email/Password Authentication** (type: 0) - Server-only validation
2. **Google Sign-In Authentication** (type: 1) - Firebase + server validation

## Authentication Flow Differences

### Regular Email/Password Users (type: 0)
- **Sign-In Process**: Direct API call to server with email/password
- **Persistence Check**: Only validates server tokens (access_token, refresh_token)
- **No Firebase Dependency**: Does not check Firebase authentication state
- **Storage**: User data and tokens stored in SharedPreferences

### Google Sign-In Users (type: 1)
- **Sign-In Process**: Firebase authentication → server registration/sign-in with Firebase token
- **Persistence Check**: Validates both Firebase authentication state AND server tokens
- **Dual Validation**: Must have valid Firebase user AND valid server tokens
- **Storage**: User data and tokens stored in SharedPreferences + Firebase state

## Testing Scenarios

### 1. Regular Email/Password Authentication Tests

#### Test Case 1.1: Basic Persistence
```
1. Sign up/sign in with email/password
2. Verify successful login (reaches main screen)
3. Force close app
4. Reopen app
5. EXPECTED: User stays logged in, goes directly to main screen
6. CHECK LOGS: "Regular user authentication validated and confirmed"
```

#### Test Case 1.2: Network Error Handling
```
1. Sign in with email/password while online
2. Force close app
3. Disconnect from internet
4. Reopen app
5. EXPECTED: User stays logged in (graceful offline handling)
6. CHECK LOGS: "Network error during regular user validation, keeping user logged in"
```

#### Test Case 1.3: Token Expiry/Invalid
```
1. Sign in with email/password
2. Wait for token to expire OR manually invalidate server-side
3. Reopen app
4. EXPECTED: App attempts token refresh OR redirects to sign-in
5. CHECK LOGS: "Regular user token validation failed, cleaning up"
```

### 2. Google Sign-In Authentication Tests

#### Test Case 2.1: Basic Google Persistence
```
1. Sign in with Google
2. Verify successful login (reaches main screen)
3. Force close app
4. Reopen app
5. EXPECTED: User stays logged in, both Firebase + server validated
6. CHECK LOGS: "Google user authentication validated (Firebase + server)"
```

#### Test Case 2.2: Firebase State Loss
```
1. Sign in with Google
2. Clear Firebase authentication (simulate Firebase logout)
3. Reopen app
4. EXPECTED: User logged out automatically
5. CHECK LOGS: "Google user missing Firebase authentication, cleaning up"
```

#### Test Case 2.3: Server Token Invalid, Firebase Valid
```
1. Sign in with Google
2. Invalidate server tokens (keep Firebase state)
3. Reopen app
4. EXPECTED: User logged out (both validations required)
5. CHECK LOGS: "Google user server token validation failed, cleaning up"
```

#### Test Case 2.4: Firebase Valid, Different Email
```
1. Sign in with Google account A
2. Manually change Firebase to different Google account B
3. Reopen app
4. EXPECTED: User logged out (email mismatch detected)
5. CHECK LOGS: "Firebase user email mismatch, cleaning up"
```

### 3. Cross-Authentication Tests

#### Test Case 3.1: Authentication Type Switching
```
1. Sign in with email/password
2. Log out completely
3. Sign in with Google
4. Force close app
5. Reopen app
6. EXPECTED: Google authentication flow used (Firebase + server validation)
7. CHECK LOGS: "Validating Google Sign-In user authentication"
```

#### Test Case 3.2: Corrupted User Type Data
```
1. Sign in with any method
2. Manually corrupt user type data in SharedPreferences
3. Reopen app
4. EXPECTED: User logged out, clean state restored
5. CHECK LOGS: "Inconsistent authentication state detected, cleaning up"
```

## Key Log Messages to Monitor

### Successful Authentication Flows

#### Regular User Success:
```
AuthService: Validating regular email/password user authentication
AuthService: Validating regular user authentication (server-only)
AuthService: Regular user authentication validated and confirmed
```

#### Google User Success:
```
AuthService: Validating Google Sign-In user authentication
AuthService: Validating Google user authentication (Firebase + server)
AuthService: Firebase user present: true
AuthService: Google user authentication validated (Firebase + server)
```

### Error Scenarios

#### Missing Firebase for Google User:
```
AuthService: Google user missing Firebase authentication, cleaning up
```

#### Email Mismatch for Google User:
```
AuthService: Firebase user email mismatch, cleaning up
- Firebase email: user@gmail.com
- Stored email: different@gmail.com
```

#### Network Error Handling:
```
AuthService: Network error during regular user validation, keeping user logged in
AuthService: Network error during Google user validation, keeping user logged in
```

#### General Authentication Failures:
```
AuthService: Inconsistent authentication state detected, cleaning up
- Missing tokens: false
- Missing sign-in flag: false
- Missing user data: true
```

## Implementation Verification

### Check Authentication Type Assignment

Verify that user types are correctly assigned during sign-up/sign-in:

#### Email/Password Registration:
```json
{
  "type": 0,
  "email": "user@example.com",
  "name": "User Name"
}
```

#### Google Sign-In Registration:
```json
{
  "type": 1,
  "email": "user@gmail.com", 
  "name": "User Name"
}
```

### Validate Storage Components

For both authentication types, verify these are properly stored:
- `access_token`: Non-empty string
- `refresh_token`: Non-empty string  
- `is_signed_in`: true
- `user_data`: Valid JSON with correct type field

For Google users additionally verify:
- Firebase authentication state is active
- Firebase user email matches stored user email

## Testing Environment Setup

### Prerequisites
1. Functioning backend API with both email/password and Google Sign-In endpoints
2. Proper Firebase configuration for Google Sign-In
3. Google test accounts for Google Sign-In testing
4. Network connectivity for initial tests
5. Ability to simulate network disconnection
6. Developer tools to inspect SharedPreferences (optional)

### Test Data Requirements
- Valid email/password combinations for regular authentication
- Google accounts for Google Sign-In testing
- Access to server logs for token validation verification
- Firebase console access for authentication state verification

## Success Criteria Summary

| Test Scenario | Regular User (type: 0) | Google User (type: 1) |
|---------------|------------------------|----------------------|
| Basic Persistence | ✅ Server tokens only | ✅ Firebase + server |
| Network Errors | ✅ Graceful offline | ✅ Graceful offline |
| Firebase State Loss | N/A (no Firebase dep.) | ❌ Should logout |
| Server Token Invalid | ❌ Should logout | ❌ Should logout |
| Email Mismatch | N/A | ❌ Should logout |

## Common Issues and Solutions

### Issue 1: Google User Keeps Getting Logged Out
**Possible Causes**:
- Firebase authentication not persisting
- Google Sign-In configuration issues
- Firebase email mismatch

**Debug Steps**:
1. Check Firebase console for active sessions
2. Verify Google Sign-In configuration
3. Look for "Firebase user email mismatch" logs

### Issue 2: Regular User Can't Stay Logged In
**Possible Causes**:
- Server token validation failing
- Network connectivity issues
- Token refresh logic problems

**Debug Steps**:
1. Check server endpoint availability
2. Verify token refresh mechanism
3. Look for "Regular user token validation failed" logs

### Issue 3: Authentication Type Confusion
**Possible Causes**:
- User type field not set correctly during registration
- Data corruption in SharedPreferences

**Debug Steps**:
1. Verify user type in registration API calls
2. Check stored user data structure
3. Look for "User type" in validation logs

This differentiated testing approach ensures that each authentication method is properly validated according to its specific requirements while maintaining security and user experience.
