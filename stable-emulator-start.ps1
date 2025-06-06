# Emulator Window Fix - Simple Version
Write-Host "Starting Android Emulator with Stable Settings" -ForegroundColor Green

# Kill existing emulators
Get-Process -Name "*emulator*" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Paths
$androidSdk = "$env:LOCALAPPDATA\Android\sdk"
$emulatorExe = "$androidSdk\emulator\emulator.exe"

# Check emulator exists
if (-not (Test-Path $emulatorExe)) {
    Write-Host "ERROR: Emulator not found!" -ForegroundColor Red
    exit 1
}

# Get AVDs
Write-Host "Getting AVD list..." -ForegroundColor Yellow
$avdList = & $emulatorExe -list-avds 2>$null | Where-Object { $_ -and $_ -notmatch "INFO|ERROR" }

if (-not $avdList) {
    Write-Host "ERROR: No AVDs found!" -ForegroundColor Red
    exit 1
}

$avdName = $avdList[0].Trim()
Write-Host "Using AVD: $avdName" -ForegroundColor Cyan

# Start emulator with safe settings
Write-Host "Starting emulator..." -ForegroundColor Yellow

$arguments = "-avd `"$avdName`" -gpu swiftshader -memory 1024 -no-snapshot -no-audio"
Write-Host "Command: emulator.exe $arguments" -ForegroundColor Gray

Start-Process -FilePath $emulatorExe -ArgumentList $arguments.Split(' ') -NoNewWindow

Write-Host ""
Write-Host "SUCCESS: Emulator started with stable settings!" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT TIPS:" -ForegroundColor Yellow
Write-Host "1. Wait 30-60 seconds for Android to boot completely" -ForegroundColor White
Write-Host "2. Don't click on window borders - click center of screen" -ForegroundColor White  
Write-Host "3. To maximize: Alt+Space then X" -ForegroundColor White
Write-Host "4. For fullscreen: Alt+Enter" -ForegroundColor White
Write-Host ""
Write-Host "The window should NOT disappear now!" -ForegroundColor Green
