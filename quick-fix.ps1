Write-Host "VS Code Device Selection Quick Fix" -ForegroundColor Green

# Kill VS Code
Get-Process -Name "*Code*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Get absolute path
$absolutePath = (Resolve-Path ".fvm\flutter_sdk").Path

# Clean extension cache
Remove-Item -Path "$env:APPDATA\Code\User\workspaceStorage" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Code\logs" -Recurse -Force -ErrorAction SilentlyContinue

# Update settings with absolute path
$settings = @"
{
    "dart.flutterSdkPath": "$($absolutePath.Replace('\', '/'))",
    "dart.checkForSdkUpdates": false,
    "dart.allowAnalytics": false
}
"@

$settings | Set-Content ".vscode\settings.json" -Encoding UTF8

Write-Host "Fixed! Absolute Flutter path: $absolutePath" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Open VS Code" -ForegroundColor White
Write-Host "2. Ctrl+Shift+P -> 'Flutter: Change SDK'" -ForegroundColor White
Write-Host "3. Select: $absolutePath" -ForegroundColor Cyan
Write-Host "4. Wait for reload, then check devices" -ForegroundColor White
