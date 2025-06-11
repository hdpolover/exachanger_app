# Google Sign-In Diagnostic Script

Write-Host "=== Google Sign-In Configuration Diagnostic ===" -ForegroundColor Cyan
Write-Host ""

# Check package name in build.gradle
Write-Host "1. Checking package name in build.gradle..." -ForegroundColor Yellow
$buildGradlePath = "android\app\build.gradle"
if (Test-Path $buildGradlePath) {
    $buildGradleContent = Get-Content $buildGradlePath
    $packageLine = $buildGradleContent | Select-String "applicationId"
    if ($packageLine) {
        Write-Host "   Package Name: $packageLine" -ForegroundColor Green
    } else {
        Write-Host "   Package Name not found in build.gradle" -ForegroundColor Red
    }
} else {
    Write-Host "   build.gradle not found" -ForegroundColor Red
}

Write-Host ""

# Check google-services.json
Write-Host "2. Checking google-services.json..." -ForegroundColor Yellow
$googleServicesPath = "android\app\google-services.json"
if (Test-Path $googleServicesPath) {
    Write-Host "   [OK] google-services.json exists" -ForegroundColor Green
    try {
        $googleServicesContent = Get-Content $googleServicesPath | ConvertFrom-Json
        $packageName = $googleServicesContent.client[0].client_info.android_client_info.package_name
        Write-Host "   Package Name in google-services.json: $packageName" -ForegroundColor Green
        
        # Check for OAuth client
        $oauthClients = $googleServicesContent.client[0].oauth_client
        $webClientExists = $false
        foreach ($client in $oauthClients) {
            if ($client.client_type -eq 3) {
                Write-Host "   [OK] Web OAuth client found: $($client.client_id)" -ForegroundColor Green
                $webClientExists = $true
            }
        }
        if (-not $webClientExists) {
            Write-Host "   [WARNING] No Web OAuth client found (client_type: 3)" -ForegroundColor Red
        }
    } catch {
        Write-Host "   [ERROR] Failed to parse google-services.json" -ForegroundColor Red
    }
} else {
    Write-Host "   [ERROR] google-services.json not found" -ForegroundColor Red
}

Write-Host ""

# Check Firebase dependencies
Write-Host "3. Checking Firebase dependencies in pubspec.yaml..." -ForegroundColor Yellow
$pubspecPath = "pubspec.yaml"
if (Test-Path $pubspecPath) {
    $pubspecContent = Get-Content $pubspecPath
    $firebaseAuth = $pubspecContent | Select-String "firebase_auth:"
    $googleSignIn = $pubspecContent | Select-String "google_sign_in:"
    $firebaseCore = $pubspecContent | Select-String "firebase_core:"
    
    if ($firebaseAuth) { Write-Host "   [OK] firebase_auth found" -ForegroundColor Green }
    if ($googleSignIn) { Write-Host "   [OK] google_sign_in found" -ForegroundColor Green }
    if ($firebaseCore) { Write-Host "   [OK] firebase_core found" -ForegroundColor Green }
    
    if (-not $firebaseAuth) { Write-Host "   [ERROR] firebase_auth missing" -ForegroundColor Red }
    if (-not $googleSignIn) { Write-Host "   [ERROR] google_sign_in missing" -ForegroundColor Red }
    if (-not $firebaseCore) { Write-Host "   [ERROR] firebase_core missing" -ForegroundColor Red }
} else {
    Write-Host "   [ERROR] pubspec.yaml not found" -ForegroundColor Red
}

Write-Host ""

# Show SHA-1 fingerprint reminder
Write-Host "4. SHA-1 Fingerprint Information:" -ForegroundColor Yellow
Write-Host "   Your Debug SHA-1: 08:48:0D:5B:70:0F:06:C4:59:97:F2:99:5E:30:25:D9:44:FD:6B:9D" -ForegroundColor Cyan
Write-Host "   Make sure this is added to Firebase Console!" -ForegroundColor Red

Write-Host ""

# Recommendations
Write-Host "=== Recommendations ===" -ForegroundColor Cyan
Write-Host "1. Ensure SHA-1 fingerprint is added to Firebase Console" -ForegroundColor White
Write-Host "2. Enable Google Sign-In in Firebase Authentication" -ForegroundColor White
Write-Host "3. Download updated google-services.json after adding SHA-1" -ForegroundColor White
Write-Host "4. Clean and rebuild the project" -ForegroundColor White

Write-Host ""
Write-Host "To fix Google Sign-In error code 10, run these commands:" -ForegroundColor Yellow
Write-Host "flutter clean" -ForegroundColor Green
Write-Host "flutter pub get" -ForegroundColor Green
Write-Host "cd android" -ForegroundColor Green
Write-Host ".\gradlew clean" -ForegroundColor Green
Write-Host "cd .." -ForegroundColor Green
Write-Host "flutter run" -ForegroundColor Green

pause
