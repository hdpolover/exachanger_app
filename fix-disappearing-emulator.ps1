# Fix for Disappearing Android Emulator Window
Write-Host "Fixing Disappearing Android Emulator Window Issue" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green

# Kill any existing emulator processes
Write-Host "`nStep 1: Cleaning up existing processes..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -like "*emulator*" -or $_.ProcessName -like "*qemu*"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Find Android SDK
$androidSdk = "$env:LOCALAPPDATA\Android\sdk"
if (-not (Test-Path $androidSdk)) {
    Write-Host "Android SDK not found!" -ForegroundColor Red
    exit 1
}

$emulatorPath = "$androidSdk\emulator\emulator.exe"
$adbPath = "$androidSdk\platform-tools\adb.exe"

# Add to PATH
$env:PATH += ";$androidSdk\platform-tools;$androidSdk\emulator"

Write-Host "Step 2: Starting emulator with stable settings..." -ForegroundColor Yellow

# Get available AVDs
$avdOutput = & $emulatorPath -list-avds 2>$null
$avds = $avdOutput | Where-Object { $_ -notmatch "^INFO" -and $_ -notmatch "^ERROR" -and $_.Trim() -ne "" }

if (-not $avds) {
    Write-Host "No AVDs found! Please create one in Android Studio." -ForegroundColor Red
    exit 1
}

$selectedAvd = ($avds | Select-Object -First 1).Trim()
Write-Host "Using AVD: $selectedAvd" -ForegroundColor Cyan

# Start emulator with STABLE settings to prevent disappearing
Write-Host "Starting emulator with anti-disappearing settings..." -ForegroundColor Cyan

# Create a batch file to launch emulator (more stable than PowerShell direct launch)
$batchContent = @"
@echo off
cd /d "$androidSdk\emulator"
echo Starting Android Emulator...
emulator.exe -avd "$selectedAvd" -gpu host -no-snapshot-load -no-snapshot-save -wipe-data -memory 2048 -cores 2 -partition-size 2048 -no-audio -netdelay none -netspeed full -show-kernel -verbose
pause
"@

$batchFile = Join-Path $PSScriptRoot "start_emulator_stable.bat"
$batchContent | Out-File -FilePath $batchFile -Encoding ASCII

Write-Host "Created stable launcher: $batchFile" -ForegroundColor Green

# Alternative: Start with minimal settings
Write-Host "`nStarting emulator with minimal stable configuration..." -ForegroundColor Yellow

try {
    # Use Start-Process with specific parameters to prevent disappearing
    $process = Start-Process -FilePath $emulatorPath -ArgumentList @(
        "-avd", $selectedAvd,
        "-gpu", "swiftshader_indirect",  # More stable than host GPU
        "-memory", "2048",
        "-cores", "2", 
        "-no-snapshot-load",
        "-no-snapshot-save",
        "-no-audio",
        "-verbose"
    ) -PassThru -WindowStyle Normal
    
    Write-Host "Emulator started with PID: $($process.Id)" -ForegroundColor Green
    
    # Wait for emulator to initialize
    Write-Host "Waiting for emulator to initialize..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    # Check if process is still running
    if (-not $process.HasExited) {
        Write-Host "✓ Emulator process is stable and running" -ForegroundColor Green
        
        # Wait for device to be ready
        $timeout = 60
        $elapsed = 0
        Write-Host "Waiting for device to be ready (this may take up to 2 minutes)..." -ForegroundColor Yellow
          while ($elapsed -lt $timeout -and -not $process.HasExited) {
            Start-Sleep -Seconds 5
            $elapsed += 5
            Write-Host "." -NoNewline -ForegroundColor Gray
            
            try {
                $devices = & $adbPath devices 2>$null
                if ($devices -match "emulator-\d+\s+device") {
                    Write-Host "`n✓ Emulator is ready!" -ForegroundColor Green
                    break
                }
            } catch {
                # Continue waiting
            }
        }
        
        if ($process.HasExited) {
            Write-Host "`nEmulator process exited unexpectedly!" -ForegroundColor Red
            Write-Host "Exit code: $($process.ExitCode)" -ForegroundColor Red
        } else {
            Write-Host "`n🎉 EMULATOR IS RUNNING SUCCESSFULLY!" -ForegroundColor Green
            Write-Host ""
            Write-Host "WINDOW INTERACTION TIPS:" -ForegroundColor Yellow
            Write-Host "- Don't click on the window border immediately" -ForegroundColor White  
            Write-Host "- Wait for the Android logo/boot screen to appear" -ForegroundColor White
            Write-Host "- Click gently in the center of the emulator screen" -ForegroundColor White
            Write-Host "- Use keyboard shortcuts instead of mouse when possible" -ForegroundColor White
            Write-Host "- To maximize: Alt+Space then X (don't right-click initially)" -ForegroundColor White
            Write-Host ""
            Write-Host "If window still disappears:" -ForegroundColor Yellow
            Write-Host "- Run the batch file: start_emulator_stable.bat" -ForegroundColor White
            Write-Host "- Or try the software rendering mode below" -ForegroundColor White
        }
    } else {
        Write-Host "Emulator process crashed immediately!" -ForegroundColor Red
        Write-Host "Trying software rendering mode..." -ForegroundColor Yellow
        
        # Try with software rendering (most stable)
        $process2 = Start-Process -FilePath $emulatorPath -ArgumentList @(
            "-avd", $selectedAvd,
            "-gpu", "swiftshader",
            "-memory", "1024",
            "-no-snapshot-load",
            "-no-audio"
        ) -PassThru -WindowStyle Normal
        
        Start-Sleep -Seconds 5
        if (-not $process2.HasExited) {
            Write-Host "✓ Emulator started in software rendering mode" -ForegroundColor Green
        }
    }
    
} catch {
    Write-Host "Error starting emulator: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please try running the batch file manually: $batchFile" -ForegroundColor Yellow
}

Write-Host "`nTROUBLESHOoting if window keeps disappearing:" -ForegroundColor Yellow
Write-Host "1. Run as Administrator" -ForegroundColor White
Write-Host "2. Disable Windows Defender real-time protection temporarily" -ForegroundColor White  
Write-Host "3. Check Windows Event Viewer for crash details" -ForegroundColor White
Write-Host "4. Try different AVD (Test_Phone instead of Pixel_8_Pro_API_33)" -ForegroundColor White
Write-Host "5. Update graphics drivers" -ForegroundColor White
