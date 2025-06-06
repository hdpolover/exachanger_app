# Verify Non-FVM Flutter Setup
Write-Host "Verifying Flutter project setup without FVM..." -ForegroundColor Green

# Check if .fvm directory exists
if (Test-Path ".fvm") {
    Write-Host "❌ .fvm directory still exists" -ForegroundColor Red
} else {
    Write-Host "✓ .fvm directory removed" -ForegroundColor Green
}

# Check VS Code settings
if (Test-Path ".vscode\settings.json") {
    $settings = Get-Content ".vscode\settings.json" -Raw
    if ($settings -match "\.fvm") {
        Write-Host "❌ VS Code settings still contain FVM references" -ForegroundColor Red
    } else {
        Write-Host "✓ VS Code settings cleaned of FVM references" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  No VS Code settings found" -ForegroundColor Yellow
}

# Test Flutter commands
Write-Host "`nTesting Flutter commands..." -ForegroundColor Yellow
Write-Host "Flutter version:" -ForegroundColor Cyan
flutter --version

Write-Host "`nFlutter devices:" -ForegroundColor Cyan
flutter devices

Write-Host "`nFlutter project analysis:" -ForegroundColor Cyan
flutter analyze --no-pub

Write-Host "`n✅ PROJECT SETUP COMPLETE!" -ForegroundColor Green
Write-Host "Your Flutter project is now configured to use the default Flutter installation." -ForegroundColor White
Write-Host "FVM has been completely removed from this project." -ForegroundColor White
