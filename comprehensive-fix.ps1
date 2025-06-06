# Comprehensive Flutter/VS Code Fix Script
Write-Host "Starting comprehensive Flutter/VS Code fix..." -ForegroundColor Green

# 1. Kill all Flutter/Dart/VS Code processes
Write-Host "Step 1: Stopping all related processes..." -ForegroundColor Yellow
$processes = @("flutter*", "dart*", "Code", "Code - Insiders")
foreach ($process in $processes) {
    Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 3

# 2. Clean all caches
Write-Host "Step 2: Cleaning all caches..." -ForegroundColor Yellow
$cachePaths = @(
    "$env:USERPROFILE\.flutter",
    "$env:USERPROFILE\.dart",
    "$env:USERPROFILE\.pub-cache\hosted\pub.dartlang.org",
    "$env:APPDATA\Code\User\workspaceStorage",
    "$env:APPDATA\Code\logs",
    "$env:APPDATA\Code\CachedExtensions",
    "$PWD\.dart_tool",
    "$PWD\build",
    "$PWD\.packages",
    "$PWD\.flutter-plugins-dependencies"
)

foreach ($path in $cachePaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Cleaned: $path" -ForegroundColor Gray
    }
}

# 3. Set up proper environment
Write-Host "Step 3: Setting up environment..." -ForegroundColor Yellow
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$PWD\.fvm\flutter_sdk\bin;$env:PATH"
$env:FLUTTER_ROOT = "$PWD\.fvm\flutter_sdk"
$env:DART_SDK = "$PWD\.fvm\flutter_sdk\bin\cache\dart-sdk"
$env:PUB_CACHE = "$env:USERPROFILE\.pub-cache"

# 4. Verify Flutter SDK
Write-Host "Step 4: Verifying Flutter SDK..." -ForegroundColor Yellow
if (Test-Path "$PWD\.fvm\flutter_sdk\bin\flutter.bat") {
    try {
        $version = & "$PWD\.fvm\flutter_sdk\bin\flutter.bat" --version 2>&1
        Write-Host "  ✓ Flutter SDK working: $($version -split "`n" | Select-Object -First 1)" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Flutter SDK failed: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  ✗ Flutter SDK not found at .fvm\flutter_sdk" -ForegroundColor Red
    exit 1
}

# 5. Test Git (critical for daemon)
Write-Host "Step 5: Testing Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "  ✓ Git working: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Git not accessible!" -ForegroundColor Red
    exit 1
}

# 6. Reset Flutter cache and get dependencies
Write-Host "Step 6: Resetting Flutter and dependencies..." -ForegroundColor Yellow
& "$PWD\.fvm\flutter_sdk\bin\flutter.bat" clean 2>&1 | Out-Null
& "$PWD\.fvm\flutter_sdk\bin\flutter.bat" pub get 2>&1 | Out-Null
Write-Host "  ✓ Dependencies updated" -ForegroundColor Green

# 7. Test daemon capability
Write-Host "Step 7: Testing daemon capability..." -ForegroundColor Yellow
try {
    $daemonTest = Start-Process -FilePath "$PWD\.fvm\flutter_sdk\bin\flutter.bat" -ArgumentList "daemon" -PassThru -WindowStyle Hidden
    Start-Sleep -Seconds 2
    if (!$daemonTest.HasExited) {
        $daemonTest | Stop-Process -Force
        Write-Host "  ✓ Daemon can start" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Daemon failed to start" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Daemon test failed: $_" -ForegroundColor Red
}

Write-Host "`n🎉 Comprehensive fix completed!" -ForegroundColor Green
Write-Host "`n📋 Final Steps:" -ForegroundColor Cyan
Write-Host "1. Restart VS Code completely" -ForegroundColor White
Write-Host "2. When VS Code opens, go to Command Palette (Ctrl+Shift+P)" -ForegroundColor White
Write-Host "3. Run 'Flutter: Change SDK' and select '.fvm/flutter_sdk'" -ForegroundColor White
Write-Host "4. Run 'Dart: Restart Analysis Server'" -ForegroundColor White
Write-Host "5. Open a .dart file to trigger daemon startup" -ForegroundColor White
Write-Host "`n✨ Your Flutter setup should now work perfectly!" -ForegroundColor Green
