# This script forces Flutter to ignore web devices
$env:FLUTTER_WEB_DEVICES = "disable"

# Get all available mobile devices
$deviceInfo = flutter devices | Where-Object { $_ -match "android|ios" -and $_ -notmatch "web" }

if (-not $deviceInfo) {
    Write-Host "No mobile devices found. Please start an emulator first." -ForegroundColor Red
    exit 1
}

# Display available devices
Write-Host "Available mobile devices:" -ForegroundColor Green
$deviceInfo | ForEach-Object { Write-Host $_ }

# Use the first available mobile device
$deviceId = ($deviceInfo[0] -split "\s+")[2]
Write-Host "`nUsing device with ID: $deviceId" -ForegroundColor Cyan

# Run Flutter with the specific device ID
flutter run -d $deviceId
