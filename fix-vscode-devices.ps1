# VS Code Flutter Device Detection Fix
Write-Host "Forcing VS Code to detect Flutter devices..." -ForegroundColor Green

# Set environment for this session
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$PWD\.fvm\flutter_sdk\bin;$env:PATH"
$env:FLUTTER_ROOT = "$PWD\.fvm\flutter_sdk"

Write-Host "Testing device detection with FVM Flutter..." -ForegroundColor Yellow

# Test device detection
Write-Host "Available devices:" -ForegroundColor Cyan
& ".fvm\flutter_sdk\bin\flutter.bat" devices

Write-Host "`nRunning flutter doctor to verify setup..." -ForegroundColor Yellow
& ".fvm\flutter_sdk\bin\flutter.bat" doctor

Write-Host "`nTesting web device specifically..." -ForegroundColor Yellow
& ".fvm\flutter_sdk\bin\flutter.bat" devices --web

Write-Host "`nRestarting VS Code is recommended to pick up the new settings." -ForegroundColor Green
Write-Host "If devices still don't appear, try:" -ForegroundColor Yellow
Write-Host "1. Close VS Code completely" -ForegroundColor White
Write-Host "2. Reopen VS Code" -ForegroundColor White
Write-Host "3. Open Command Palette (Ctrl+Shift+P)" -ForegroundColor White
Write-Host "4. Run 'Flutter: Change SDK'" -ForegroundColor White
Write-Host "5. Select the .fvm/flutter_sdk folder" -ForegroundColor White
