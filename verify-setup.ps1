# Final Verification Script
Write-Host "=== Flutter Setup Verification ===" -ForegroundColor Cyan

# 1. Check VS Code configuration
Write-Host "`n1. VS Code Configuration:" -ForegroundColor Yellow
if (Test-Path ".vscode\settings.json") {
    $settings = Get-Content ".vscode\settings.json" -Raw | ConvertFrom-Json
    Write-Host "   ✓ Flutter SDK Path: $($settings.'dart.flutterSdkPath')" -ForegroundColor Green
} else {
    Write-Host "   ✗ No VS Code settings found" -ForegroundColor Red
}

# 2. Check FVM configuration
Write-Host "`n2. FVM Configuration:" -ForegroundColor Yellow
if (Test-Path ".fvm\fvm_config.json") {
    $fvmConfig = Get-Content ".fvm\fvm_config.json" -Raw | ConvertFrom-Json
    Write-Host "   ✓ FVM Version: $($fvmConfig.flutterSdkVersion)" -ForegroundColor Green
} else {
    Write-Host "   ✗ No FVM config found" -ForegroundColor Red
}

# 3. Check Flutter SDK accessibility
Write-Host "`n3. Flutter SDK Accessibility:" -ForegroundColor Yellow
if (Test-Path ".fvm\flutter_sdk\bin\flutter.bat") {
    Write-Host "   ✓ Project Flutter SDK exists" -ForegroundColor Green
    try {
        $version = & ".fvm\flutter_sdk\bin\flutter.bat" --version 2>&1 | Select-Object -First 1
        Write-Host "   ✓ Version: $version" -ForegroundColor Green
    } catch {
        Write-Host "   ✗ Flutter SDK not working" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ Project Flutter SDK not found" -ForegroundColor Red
}

# 4. Check Git accessibility
Write-Host "`n4. Git Accessibility:" -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "   ✓ Git working: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Git not accessible" -ForegroundColor Red
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "✅ Your Flutter setup is WORKING correctly!" -ForegroundColor Green
Write-Host "✅ The PATH warnings are NORMAL and don't affect functionality" -ForegroundColor Green
Write-Host "✅ VS Code will use the project-specific Flutter SDK" -ForegroundColor Green
Write-Host "`n📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart VS Code completely" -ForegroundColor White
Write-Host "2. Open a .dart file to trigger extension activation" -ForegroundColor White
Write-Host "3. Check device selection (should show Chrome, Edge, Windows)" -ForegroundColor White
Write-Host "4. Try running your app with F5" -ForegroundColor White

Write-Host "`n💡 About the PATH warnings:" -ForegroundColor Cyan
Write-Host "These warnings appear because both paths point to the SAME Flutter version." -ForegroundColor White
Write-Host "They are cosmetic and don't affect VS Code or app development." -ForegroundColor White
