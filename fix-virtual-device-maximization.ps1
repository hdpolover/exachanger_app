# Android Virtual Device Maximization Fix
# This script addresses common issues preventing Android emulator from maximizing properly

Write-Host "🔧 Android Virtual Device Maximization Fix" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Step 1: Check Android SDK and ADB path
Write-Host "`n📍 Step 1: Checking Android SDK path..." -ForegroundColor Yellow

$androidSdkPath = $null
$possiblePaths = @(
    "$env:LOCALAPPDATA\Android\sdk",
    "$env:ANDROID_HOME",
    "$env:ANDROID_SDK_ROOT"
)

foreach ($path in $possiblePaths) {
    if ($path -and (Test-Path $path)) {
        $androidSdkPath = $path
        Write-Host "✓ Found Android SDK at: $androidSdkPath" -ForegroundColor Green
        break
    }
}

if (-not $androidSdkPath) {
    Write-Host "❌ Android SDK not found. Please ensure Android Studio is installed properly." -ForegroundColor Red
    exit 1
}

# Step 2: Add ADB to PATH temporarily
$adbPath = Join-Path $androidSdkPath "platform-tools"
if (Test-Path $adbPath) {
    $env:PATH += ";$adbPath"
    Write-Host "✓ Added ADB to PATH: $adbPath" -ForegroundColor Green
} else {
    Write-Host "❌ ADB not found at: $adbPath" -ForegroundColor Red
}

# Step 3: Check emulator status
Write-Host "`n📍 Step 2: Checking emulator status..." -ForegroundColor Yellow
try {
    $adbDevices = & "$adbPath\adb.exe" devices 2>$null
    if ($adbDevices) {
        Write-Host "✓ ADB connection working" -ForegroundColor Green
        Write-Host $adbDevices
    }
} catch {
    Write-Host "⚠️  ADB connection issue: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Step 4: Kill and restart emulator with proper settings
Write-Host "`n📍 Step 3: Restarting emulator with optimal settings..." -ForegroundColor Yellow

# Kill existing emulator processes
Write-Host "Stopping existing emulator processes..." -ForegroundColor Cyan
try {
    & "$adbPath\adb.exe" emu kill 2>$null
    Get-Process | Where-Object {$_.ProcessName -like "*emulator*"} | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    Write-Host "✓ Stopped existing emulator processes" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not stop some processes (this is normal)" -ForegroundColor Yellow
}

# Step 5: Get available AVDs
Write-Host "`n📍 Step 4: Finding available Android Virtual Devices..." -ForegroundColor Yellow
$emulatorPath = Join-Path $androidSdkPath "emulator"
if (Test-Path $emulatorPath) {
    try {
        $avdList = & "$emulatorPath\emulator.exe" -list-avds 2>$null
        if ($avdList) {
            Write-Host "✓ Available AVDs:" -ForegroundColor Green
            $avdList | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
            
            # Use the first available AVD
            $firstAvd = ($avdList | Select-Object -First 1).Trim()
            if ($firstAvd) {
                Write-Host "`nStarting AVD: $firstAvd with optimized settings..." -ForegroundColor Cyan
                
                # Start emulator with specific flags for maximization
                $emulatorArgs = @(
                    "-avd", $firstAvd,
                    "-gpu", "host",
                    "-skin", "1080x1920",
                    "-skindir", (Join-Path $androidSdkPath "skins"),
                    "-no-snapshot-load",
                    "-wipe-data",
                    "-no-audio"
                )
                
                Write-Host "Starting emulator with command: emulator.exe $($emulatorArgs -join ' ')" -ForegroundColor Gray
                Start-Process -FilePath "$emulatorPath\emulator.exe" -ArgumentList $emulatorArgs -NoNewWindow
                
                Write-Host "✓ Emulator started with maximization-friendly settings" -ForegroundColor Green
            }
        } else {
            Write-Host "❌ No AVDs found. Please create an Android Virtual Device first." -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Error accessing emulator: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Emulator not found at: $emulatorPath" -ForegroundColor Red
}

# Step 6: Windows-specific fixes
Write-Host "`n📍 Step 5: Applying Windows-specific fixes..." -ForegroundColor Yellow

# Create registry fixes for DPI awareness (requires admin)
$registryFixes = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Google\AndroidEmulatorDpiSettings]
"WindowWidth"=dword:00000500
"WindowHeight"=dword:00000800
"DensityFactor"=dword:00000001

[HKEY_CURRENT_USER\Software\Google\AndroidEmulator]
"MaximizeWindow"=dword:00000001
"EnableGpuHost"=dword:00000001
"@

$regFile = Join-Path $PSScriptRoot "emulator-fixes.reg"
$registryFixes | Out-File -FilePath $regFile -Encoding ASCII

Write-Host "✓ Created registry fix file: $regFile" -ForegroundColor Green
Write-Host "  You can run this file as administrator to apply DPI fixes" -ForegroundColor White

# Step 7: VS Code launch configuration update
Write-Host "`n📍 Step 6: Updating VS Code launch configuration..." -ForegroundColor Yellow

$launchJsonPath = ".vscode\launch.json"
if (Test-Path $launchJsonPath) {
    $launchConfig = Get-Content $launchJsonPath -Raw | ConvertFrom-Json
    
    # Add Android emulator configuration if not exists
    $androidConfig = $launchConfig.configurations | Where-Object { $_.name -eq "Flutter (Android Emulator)" }
    
    if (-not $androidConfig) {
        $newAndroidConfig = [PSCustomObject]@{
            name = "Flutter (Android Emulator)"
            request = "launch"
            type = "dart"
            program = "lib/main.dart"
            deviceId = "emulator-5554"
            flutterMode = "debug"
            args = @("--enable-software-rendering")
        }
        
        $launchConfig.configurations += $newAndroidConfig
        $launchConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $launchJsonPath -Encoding UTF8
        Write-Host "✓ Added Android emulator configuration to launch.json" -ForegroundColor Green
    } else {
        Write-Host "✓ Android emulator configuration already exists" -ForegroundColor Green
    }
}

# Step 8: Wait for emulator and test
Write-Host "`n📍 Step 7: Waiting for emulator to boot..." -ForegroundColor Yellow
Write-Host "This may take 1-2 minutes..." -ForegroundColor Gray

$timeout = 120 # 2 minutes
$elapsed = 0
$interval = 5

while ($elapsed -lt $timeout) {
    try {
        $devices = & "$adbPath\adb.exe" devices 2>$null
        if ($devices -match "emulator-\d+\s+device") {
            Write-Host "✓ Emulator is ready!" -ForegroundColor Green
            break
        }
    } catch {
        # Continue waiting
    }
    
    Start-Sleep -Seconds $interval
    $elapsed += $interval
    Write-Host "." -NoNewline -ForegroundColor Gray
}

if ($elapsed -ge $timeout) {
    Write-Host "`n⚠️  Emulator taking longer than expected to boot" -ForegroundColor Yellow
} else {
    Write-Host "`n✓ Emulator is ready for use!" -ForegroundColor Green
}

# Final instructions
Write-Host "`n🎯 MAXIMIZATION INSTRUCTIONS:" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green
Write-Host "1. Right-click on the emulator window title bar" -ForegroundColor White
Write-Host "2. Select 'Maximize' from the context menu" -ForegroundColor White
Write-Host "3. Or press Alt+Space, then X to maximize" -ForegroundColor White
Write-Host "4. If still not working, try:" -ForegroundColor White
Write-Host "   - Press F11 to toggle fullscreen mode" -ForegroundColor White
Write-Host "   - Drag the window borders to resize manually" -ForegroundColor White
Write-Host "   - Check Windows display scaling (100% recommended)" -ForegroundColor White

Write-Host "`n🚀 Ready to run Flutter app!" -ForegroundColor Green
Write-Host "Use: flutter run -d emulator-5554" -ForegroundColor Cyan
