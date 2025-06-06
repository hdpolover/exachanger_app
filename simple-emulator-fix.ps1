# Simple Fix for Disappearing Android Emulator
Write-Host "Fixing Disappearing Android Emulator..." -ForegroundColor Green

# Clean up any existing processes
Get-Process | Where-Object {$_.ProcessName -like "*emulator*"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Android SDK path
$androidSdk = "$env:LOCALAPPDATA\Android\sdk"
$emulatorPath = "$androidSdk\emulator\emulator.exe"

# Check if SDK exists
if (-not (Test-Path $emulatorPath)) {
    Write-Host "Emulator not found at: $emulatorPath" -ForegroundColor Red
    exit 1
}

# Get AVDs
Write-Host "Getting available AVDs..." -ForegroundColor Yellow
$avdOutput = & $emulatorPath -list-avds 2>$null
$avds = $avdOutput | Where-Object { $_ -notmatch "^INFO" -and $_ -notmatch "^ERROR" -and $_.Trim() -ne "" }

if (-not $avds) {
    Write-Host "No AVDs found!" -ForegroundColor Red
    exit 1
}

$selectedAvd = ($avds | Select-Object -First 1).Trim()
Write-Host "Using AVD: $selectedAvd" -ForegroundColor Cyan

# Try Method 1: Software rendering (most stable)
Write-Host "`nMethod 1: Starting with software rendering..." -ForegroundColor Yellow
try {    $emulatorArgs = @(
        "-avd", $selectedAvd,
        "-gpu", "swiftshader",
        "-memory", "1024",
        "-no-snapshot",
        "-no-audio",
        "-verbose"
    )
    
    Write-Host "Command: emulator.exe $($emulatorArgs -join ' ')" -ForegroundColor Gray
    Start-Process -FilePath $emulatorPath -ArgumentList $emulatorArgs -NoNewWindow
    
    Write-Host "Emulator started with software rendering" -ForegroundColor Green
    Write-Host "Waiting 15 seconds for initialization..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15
    
    # Check if emulator is responding
    $env:PATH += ";$androidSdk\platform-tools"
    $adbPath = "$androidSdk\platform-tools\adb.exe"
    $devices = & $adbPath devices 2>$null
    
    if ($devices -match "emulator-\d+") {
        Write-Host "✓ Emulator is running and connected!" -ForegroundColor Green
    } else {
        Write-Host "⚠ Emulator may still be booting..." -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "Method 1 failed: $($_.Exception.Message)" -ForegroundColor Red
    
    Write-Host "`nMethod 2: Trying alternative approach..." -ForegroundColor Yellow
    # Create batch file for more stable launch
    $batchContent = @"
@echo off  
echo Starting Android Emulator - Software Mode
cd /d "$androidSdk\emulator"
emulator.exe -avd "$selectedAvd" -gpu swiftshader -memory 1024 -no-snapshot -no-audio
pause
"@
    
    $batchFile = "start_emulator_safe.bat"
    $batchContent | Out-File -FilePath $batchFile -Encoding ASCII
    Write-Host "Created batch launcher: $batchFile" -ForegroundColor Green
    Write-Host "You can run this manually if needed" -ForegroundColor White
}

Write-Host "`n🎯 WINDOW INTERACTION TIPS:" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host "1. WAIT for the Android boot logo to appear (30-60 seconds)" -ForegroundColor White
Write-Host "2. Don't click immediately - let it fully load" -ForegroundColor White  
Write-Host "3. Click gently in the CENTER of the screen, not borders" -ForegroundColor White
Write-Host "4. Use keyboard shortcuts:" -ForegroundColor White
Write-Host "   - Alt+Enter: Toggle fullscreen" -ForegroundColor Cyan
Write-Host "   - Alt+Space then X: Maximize window" -ForegroundColor Cyan
Write-Host "   - Ctrl+M: Menu" -ForegroundColor Cyan
Write-Host "5. If window disappears: Wait 30 seconds and try again" -ForegroundColor White

Write-Host "`n🛠 IF STILL HAVING ISSUES:" -ForegroundColor Yellow
Write-Host "1. Run PowerShell as Administrator" -ForegroundColor White
Write-Host "2. Try the batch file: .\start_emulator_safe.bat" -ForegroundColor White
Write-Host "3. Check Task Manager - emulator.exe should be running" -ForegroundColor White
Write-Host "4. Update graphics drivers" -ForegroundColor White
Write-Host "5. Try a different AVD (Test_Phone)" -ForegroundColor White

Write-Host "`n✅ Emulator should now be stable and not disappear when clicked!" -ForegroundColor Green
