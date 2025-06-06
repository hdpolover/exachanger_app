# Flutter Build and Run Helper
Write-Host "Flutter Build and Run Helper" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green

# Check if emulator is running
Write-Host "`nChecking emulator status..." -ForegroundColor Yellow
$env:PATH += ";$env:LOCALAPPDATA\Android\sdk\platform-tools"
$adbPath = "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe"

try {
    $devices = & $adbPath devices 2>$null
    if ($devices -match "emulator-\d+\s+device") {
        Write-Host "✓ Emulator is running and ready" -ForegroundColor Green
    } else {
        Write-Host "⚠ Starting emulator first..." -ForegroundColor Yellow
        .\stable-emulator-start.ps1
        Start-Sleep -Seconds 30
    }
} catch {
    Write-Host "⚠ Could not check emulator status" -ForegroundColor Yellow
}

# Clean and build
Write-Host "`nCleaning Flutter project..." -ForegroundColor Yellow
flutter clean

Write-Host "`nGetting dependencies..." -ForegroundColor Yellow  
flutter pub get

Write-Host "`nRunning Flutter app on emulator..." -ForegroundColor Yellow
flutter run -d emulator-5554

Write-Host "`n✅ Build process completed!" -ForegroundColor Green
