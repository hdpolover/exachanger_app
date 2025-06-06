# Quick Debug - Automatically start Pixel 8 Pro and run Flutter app
Write-Host "🚀 Quick Debug: Starting Pixel 8 Pro and Flutter app..." -ForegroundColor Green

# Set environment
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$PWD\.fvm\flutter_sdk\bin;$env:PATH"

Write-Host "Starting Pixel 8 Pro emulator..." -ForegroundColor Yellow
Start-Process -FilePath "$PWD\.fvm\flutter_sdk\bin\flutter.bat" -ArgumentList "emulators", "--launch", "Pixel_8_Pro_API_33" -WindowStyle Hidden

Write-Host "Waiting for emulator to boot (30 seconds)..." -ForegroundColor Yellow
for ($i = 30; $i -gt 0; $i--) {
    Write-Host "  $i seconds remaining..." -ForegroundColor Gray
    Start-Sleep -Seconds 1
}

Write-Host "Checking connected devices..." -ForegroundColor Yellow
& "$PWD\.fvm\flutter_sdk\bin\flutter.bat" devices

Write-Host "`nRunning Flutter app in debug mode..." -ForegroundColor Green
& "$PWD\.fvm\flutter_sdk\bin\flutter.bat" run
