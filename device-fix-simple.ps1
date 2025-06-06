# Simple Device Selection Fix
Write-Host "Fixing VS Code device selection..." -ForegroundColor Green

# Kill VS Code processes
Get-Process -Name "*Code*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Get absolute Flutter path
$absoluteFlutterPath = (Resolve-Path ".fvm\flutter_sdk").Path.Replace('\', '/')
Write-Host "Using Flutter SDK at: $absoluteFlutterPath" -ForegroundColor Yellow

# Clean VS Code cache
Remove-Item -Path "$env:APPDATA\Code\User\workspaceStorage" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Code\logs" -Recurse -Force -ErrorAction SilentlyContinue

# Create simple settings
$settings = @"
{
    "dart.flutterSdkPath": "$absoluteFlutterPath",
    "dart.checkForSdkUpdates": false,
    "dart.allowAnalytics": false
}
"@

# Write settings
if (!(Test-Path ".vscode")) { New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null }
$settings | Set-Content ".vscode\settings.json" -Encoding UTF8

Write-Host "Updated VS Code settings with absolute path" -ForegroundColor Green

# Test Flutter devices
Write-Host "Testing Flutter devices..." -ForegroundColor Yellow
& "$absoluteFlutterPath\bin\flutter.bat" devices

Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Open VS Code" -ForegroundColor White
Write-Host "2. Ctrl+Shift+P -> 'Flutter: Change SDK'" -ForegroundColor White
Write-Host "3. Select: $absoluteFlutterPath" -ForegroundColor Yellow
Write-Host "4. Wait for reload, then check devices" -ForegroundColor White
