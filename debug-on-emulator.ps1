# This script forces debugging on Android emulator instead of Chrome
# Get the emulator device ID (assuming it's the one with "emulator" in the name)
$deviceInfo = flutter devices | Where-Object { $_ -match "emulator" } | Select-Object -First 1
if (-not $deviceInfo) {
    Write-Host "No emulator found. Please start an emulator first." -ForegroundColor Red
    exit 1
}

# Extract the device ID from the device info
$deviceId = ($deviceInfo -split "\s+")[2]
Write-Host "Using emulator with device ID: $deviceId" -ForegroundColor Green

# Run Flutter with the specific device ID
flutter run -d $deviceId --no-web-browser-launch
