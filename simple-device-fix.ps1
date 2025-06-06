# Simple Device Selection Fix (Default Flutter)
Write-Host "Fixing VS Code device selection for default Flutter installation..." -ForegroundColor Green

# Kill VS Code processes
Get-Process -Name "*Code*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Get Flutter path from system
$flutterPath = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if (-not $flutterPath) {
    Write-Host "Flutter not found in PATH. Please ensure Flutter is installed and added to PATH." -ForegroundColor Red
    exit 1
}

$flutterRoot = Split-Path -Parent $flutterPath
$flutterRoot = Split-Path -Parent $flutterRoot  # Go up one more level to get Flutter SDK root
Write-Host "Using Flutter SDK at: $flutterRoot" -ForegroundColor Yellow

# Create settings for default Flutter installation
$settingsContent = @"
{
    "cmake.sourceDirectory": "D:/Work/Repos/exachanger_get_app/windows",
    "dart.checkForSdkUpdates": false,
    "dart.enableSdkFormatter": true,
    "dart.analysisServerFolding": false,
    "dart.enableCompletionCommitCharacters": false,
    "dart.previewLsp": true,
    "dart.maxLogLineLength": 2000,
    "dart.flutterDaemonLogFile": "`${workspaceFolder}/.vscode/flutter-daemon.log",
    "dart.extensionLogFile": "`${workspaceFolder}/.vscode/dart-extension.log",
    "dart.allowAnalytics": false,
    "dart.analysisExcludedFolders": [
        "build",
        ".dart_tool",
        ".packages"
    ]
}
"@

# Write settings
if (!(Test-Path ".vscode")) { New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null }
$settingsContent | Set-Content ".vscode\settings.json" -Encoding UTF8

Write-Host "✓ Updated VS Code settings for default Flutter installation" -ForegroundColor Green

# Test Flutter
Write-Host "Testing Flutter devices..." -ForegroundColor Yellow
flutter devices

Write-Host "`nDEVICE SELECTION FIX COMPLETE!" -ForegroundColor Green
Write-Host "`nNEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Open VS Code" -ForegroundColor White
Write-Host "2. The Dart/Flutter extension should automatically detect the default Flutter installation" -ForegroundColor White
Write-Host "3. Check device selection in the bottom status bar" -ForegroundColor White
Write-Host "4. If needed, press Ctrl+Shift+P and run 'Flutter: Change SDK' to manually select Flutter" -ForegroundColor White
