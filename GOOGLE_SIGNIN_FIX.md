# Google Sign-In Error Fix Instructions

## Problem
Your Google Sign-In is failing with error code 10 (DEVELOPER_ERROR) because the SHA-1 fingerprint of your debug keystore is not registered in the Firebase Console.

## Your SHA-1 Fingerprint
**Debug SHA-1:** `08:48:0D:5B:70:0F:06:C4:59:97:F2:99:5E:30:25:D9:44:FD:6B:9D`

## Step-by-Step Fix

### 1. Add SHA-1 to Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **exachanger-app**
3. Click the gear icon ⚙️ and select **Project Settings**
4. Scroll down to **"Your apps"** section
5. Find your Android app: **com.exachanger.app**
6. Click **"Add fingerprint"** button
7. Paste this SHA-1: `08:48:0D:5B:70:0F:06:C4:59:97:F2:99:5E:30:25:D9:44:FD:6B:9D`
8. Click **Save**

### 2. Download Updated google-services.json
1. After adding the fingerprint, click **Download google-services.json**
2. Replace the existing file at: `android/app/google-services.json`

### 3. Enable Google Sign-In in Firebase Console
1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Click on **Google** provider
3. Click **Enable** toggle
4. Set the **Project support email** (required)
5. Click **Save**

### 4. Clean and Rebuild
After updating the google-services.json file:
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

### 5. Alternative Solution (if still not working)
Sometimes the google-services.json needs to be regenerated completely:

1. In Firebase Console, go to Project Settings
2. Delete the existing Android app
3. Add a new Android app with:
   - **Package name:** com.exachanger.app
   - **App nickname:** exachanger_get_app
   - **SHA-1:** 08:48:0D:5B:70:0F:06:C4:59:97:F2:99:5E:30:25:D9:44:FD:6B:9D
4. Download the new google-services.json
5. Replace the old file

## Verification
After following these steps, Google Sign-In should work without the error code 10.

## Additional Notes
- The SHA-1 fingerprint is specific to your debug keystore
- For release builds, you'll need to add the release keystore SHA-1 as well
- Make sure the package name in google-services.json matches your app's package name: `com.exachanger.app`
