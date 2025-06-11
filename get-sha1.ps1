# PowerShell script to get SHA-1 fingerprint for debug keystore

Write-Host "Getting SHA-1 fingerprint for debug keystore..." -ForegroundColor Green

# Change to Android directory
cd android

# Run gradle task to get signing report
.\gradlew signingReport

Write-Host ""
Write-Host "Look for the SHA1 value under 'Variant: debug' section above" -ForegroundColor Yellow
Write-Host "Copy this SHA1 value and add it to your Firebase Console" -ForegroundColor Yellow
Write-Host ""
Write-Host "Steps to add SHA1 to Firebase:" -ForegroundColor Cyan
Write-Host "1. Go to Firebase Console (https://console.firebase.google.com/)" -ForegroundColor White
Write-Host "2. Select your project: exachanger-app" -ForegroundColor White
Write-Host "3. Go to Project Settings > General" -ForegroundColor White
Write-Host "4. Scroll down to 'Your apps' section" -ForegroundColor White
Write-Host "5. Find your Android app (com.exachanger.app)" -ForegroundColor White
Write-Host "6. Click 'Add fingerprint' button" -ForegroundColor White
Write-Host "7. Paste the SHA1 value" -ForegroundColor White
Write-Host "8. Save and download the updated google-services.json" -ForegroundColor White
Write-Host "9. Replace the existing google-services.json file" -ForegroundColor White

pause
