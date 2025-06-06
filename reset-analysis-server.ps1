# Complete Dart Analysis Server Reset Script
Write-Host "Resetting Dart Analysis Server..." -ForegroundColor Green

# Kill any existing Dart processes
Write-Host "Stopping Dart processes..." -ForegroundColor Yellow
Get-Process -Name "*dart*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Clean VS Code extension data
Write-Host "Cleaning VS Code extension data..." -ForegroundColor Yellow
$vsCodePaths = @(
    "$env:USERPROFILE\.vscode\extensions\dart-code.*",
    "$env:APPDATA\Code\User\workspaceStorage",
    "$env:APPDATA\Code\User\globalStorage\dart-code.*",
    "$env:APPDATA\Code\logs"
)

foreach ($path in $vsCodePaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleaned: $path" -ForegroundColor Gray
    }
}

# Clean project-specific caches
Write-Host "Cleaning project caches..." -ForegroundColor Yellow
$projectPaths = @(
    ".dart_tool",
    "build",
    ".flutter-plugins",
    ".flutter-plugins-dependencies",
    ".packages"
)

foreach ($path in $projectPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleaned: $path" -ForegroundColor Gray
    }
}

# Set environment properly
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$PWD\.fvm\flutter_sdk\bin;$env:PATH"
$env:FLUTTER_ROOT = "$PWD\.fvm\flutter_sdk"

# Verify Flutter setup
Write-Host "Verifying Flutter setup..." -ForegroundColor Yellow
& ".fvm\flutter_sdk\bin\flutter.bat" --version

# Regenerate dependencies
Write-Host "Regenerating dependencies..." -ForegroundColor Yellow
& ".fvm\flutter_sdk\bin\flutter.bat" pub get

Write-Host "`nAnalysis server reset complete!" -ForegroundColor Green
Write-Host "Now restart VS Code completely for changes to take effect." -ForegroundColor Cyan
Write-Host "`nAfter restarting VS Code:" -ForegroundColor Yellow
Write-Host "1. Open Command Palette (Ctrl+Shift+P)" -ForegroundColor White
Write-Host "2. Run 'Dart: Restart Analysis Server'" -ForegroundColor White
Write-Host "3. If issues persist, run 'Flutter: Change SDK' and select '.fvm/flutter_sdk'" -ForegroundColor White
