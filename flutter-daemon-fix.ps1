# Flutter Daemon Fix Script
Write-Host "Fixing Flutter Daemon PATH issue..." -ForegroundColor Green

# Kill existing Flutter/Dart processes
Write-Host "Stopping existing Flutter processes..." -ForegroundColor Yellow
Get-Process -Name "dart" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "flutter" -ErrorAction SilentlyContinue | Stop-Process -Force

# Set environment variables for current session
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\dev\flutter\bin;$env:PATH"
$env:GIT_INSTALL_PATH = "C:\Program Files\Git"
$env:FLUTTER_ROOT = "C:\dev\flutter"

Write-Host "Environment variables set for current session." -ForegroundColor Green

# Test Flutter
Write-Host "Testing Flutter..." -ForegroundColor Yellow
flutter --version

Write-Host "`nFlutter Daemon should now work!" -ForegroundColor Green
Write-Host "Please restart VS Code for best results." -ForegroundColor Cyan

# Keep window open
Read-Host "Press Enter to continue..."
