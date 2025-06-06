# Flutter Debug to Emulator Script
Write-Host "🚀 Starting Flutter Debug on Emulator..." -ForegroundColor Green

# Set up environment
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$PWD\.fvm\flutter_sdk\bin;$env:PATH"

# Available emulators
Write-Host "`n📱 Available Emulators:" -ForegroundColor Yellow
Write-Host "1. Pixel 8 Pro API 33" -ForegroundColor White
Write-Host "2. Test Phone" -ForegroundColor White
Write-Host "3. Chrome (Web)" -ForegroundColor White
Write-Host "4. Windows (Desktop)" -ForegroundColor White

# Get user choice
Write-Host "`n" -NoNewline
$choice = Read-Host "Select emulator (1-4)"

switch ($choice) {
    "1" {
        Write-Host "Starting Pixel 8 Pro emulator..." -ForegroundColor Yellow
        Start-Process -FilePath "$PWD\.fvm\flutter_sdk\bin\flutter.bat" -ArgumentList "emulators", "--launch", "Pixel_8_Pro_API_33" -NoNewWindow
        Write-Host "Waiting for emulator to boot..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        Write-Host "Running Flutter app in debug mode..." -ForegroundColor Green
        & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" run -d "emulator-5554"
    }
    "2" {
        Write-Host "Starting Test Phone emulator..." -ForegroundColor Yellow
        Start-Process -FilePath "$PWD\.fvm\flutter_sdk\bin\flutter.bat" -ArgumentList "emulators", "--launch", "Test_Phone" -NoNewWindow
        Write-Host "Waiting for emulator to boot..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        Write-Host "Running Flutter app in debug mode..." -ForegroundColor Green
        & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" run -d "emulator-5554"
    }
    "3" {
        Write-Host "Running Flutter app on Chrome..." -ForegroundColor Green
        & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" run -d chrome --web-renderer html
    }
    "4" {
        Write-Host "Running Flutter app on Windows..." -ForegroundColor Green
        & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" run -d windows
    }
    default {
        Write-Host "Invalid choice. Running on Chrome by default..." -ForegroundColor Yellow
        & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" run -d chrome --web-renderer html
    }
}

Write-Host "`n✅ Flutter app should now be running in debug mode!" -ForegroundColor Green
Write-Host "To stop debugging, press Ctrl+C in this terminal" -ForegroundColor Cyan
