# Flutter Daemon Fix Script
Write-Host "Fixing Flutter Daemon startup issues..." -ForegroundColor Green

# Kill all existing Flutter/Dart processes
Write-Host "Stopping all Flutter and Dart processes..." -ForegroundColor Yellow
Get-Process -Name "*flutter*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process -Name "*dart*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Wait a moment for processes to fully terminate
Start-Sleep -Seconds 2

# Set up proper environment
Write-Host "Setting up environment..." -ForegroundColor Yellow
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$PWD\.fvm\flutter_sdk\bin;$env:PATH"
$env:FLUTTER_ROOT = "$PWD\.fvm\flutter_sdk"
$env:FLUTTER_SDK = "$PWD\.fvm\flutter_sdk"
$env:DART_SDK = "$PWD\.fvm\flutter_sdk\bin\cache\dart-sdk"

# Clean Flutter daemon cache
Write-Host "Cleaning Flutter daemon cache..." -ForegroundColor Yellow
$flutterCachePaths = @(
    "$env:USERPROFILE\.flutter",
    "$env:USERPROFILE\.dart",
    "$PWD\.fvm\flutter_sdk\bin\cache\lockfile",
    "$PWD\.dart_tool"
)

foreach ($path in $flutterCachePaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleaned: $path" -ForegroundColor Gray
    }
}

# Test basic Flutter functionality
Write-Host "Testing basic Flutter functionality..." -ForegroundColor Yellow
try {
    $flutterVersion = & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" --version 2>&1
    Write-Host "Flutter Version Check: SUCCESS" -ForegroundColor Green
    Write-Host "$flutterVersion" -ForegroundColor Gray
} catch {
    Write-Host "Flutter Version Check: FAILED" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Test Git accessibility (common daemon failure cause)
Write-Host "Testing Git accessibility..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "Git Check: SUCCESS - $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "Git Check: FAILED" -ForegroundColor Red
    Write-Host "Git is not accessible - this will cause daemon failures!" -ForegroundColor Red
    exit 1
}

# Test device detection
Write-Host "Testing device detection..." -ForegroundColor Yellow
try {
    $devices = & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" devices --machine 2>&1
    Write-Host "Device Detection: SUCCESS" -ForegroundColor Green
} catch {
    Write-Host "Device Detection: FAILED" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

# Clean VS Code extension data related to daemon
Write-Host "Cleaning VS Code daemon-related data..." -ForegroundColor Yellow
$vsCodePaths = @(
    "$env:APPDATA\Code\User\workspaceStorage",
    "$env:APPDATA\Code\logs",
    "$env:USERPROFILE\.vscode\extensions\dart-code.*\out\src\extension\utils\processes.js"
)

foreach ($path in $vsCodePaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleaned VS Code cache: $path" -ForegroundColor Gray
    }
}

Write-Host "`nFlutter Daemon fix complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Restart VS Code completely" -ForegroundColor White
Write-Host "2. Wait for VS Code to fully load" -ForegroundColor White
Write-Host "3. Open a Dart/Flutter file to trigger daemon startup" -ForegroundColor White
Write-Host "4. Check the Output panel (View > Output > Dart/Flutter) for any errors" -ForegroundColor White
Write-Host "`nIf daemon still fails:" -ForegroundColor Yellow
Write-Host "- Run Command Palette > 'Flutter: Change SDK'" -ForegroundColor White
Write-Host "- Select the .fvm/flutter_sdk folder" -ForegroundColor White
Write-Host "- Run Command Palette > 'Dart: Restart Analysis Server'" -ForegroundColor White
