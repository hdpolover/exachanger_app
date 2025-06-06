# Quick Fix for Android Emulator Maximization Issue
Write-Host "Quick Android Emulator Maximization Fix" -ForegroundColor Green

# Kill existing emulator
Write-Host "Stopping existing emulator..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -like "*emulator*"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Find Android SDK path  
$androidSdk = "$env:LOCALAPPDATA\Android\sdk"
if (-not (Test-Path $androidSdk)) {
    Write-Host "Android SDK not found. Please install Android Studio." -ForegroundColor Red
    exit 1
}

# Add ADB to PATH
$env:PATH += ";$androidSdk\platform-tools"

# Start emulator with proper settings
$emulatorPath = "$androidSdk\emulator\emulator.exe"
if (Test-Path $emulatorPath) {
    Write-Host "Starting emulator with maximization-friendly settings..." -ForegroundColor Yellow
    
    # Get available AVDs, filtering out INFO messages
    $avdOutput = & $emulatorPath -list-avds 2>$null
    $avds = $avdOutput | Where-Object { $_ -notmatch "^INFO" -and $_ -notmatch "^ERROR" -and $_.Trim() -ne "" }
    
    if ($avds) {
        $firstAvd = ($avds | Select-Object -First 1).Trim()
        Write-Host "Using AVD: $firstAvd" -ForegroundColor Cyan
        
        # Start with specific window settings for maximization
        Start-Process -FilePath $emulatorPath -ArgumentList @(
            "-avd", $firstAvd,
            "-gpu", "host",
            "-skin", "1080x1920",
            "-no-snapshot-load",
            "-window-scale", "1.0"
        ) -NoNewWindow
        
        Write-Host "Emulator started successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "MAXIMIZATION INSTRUCTIONS:" -ForegroundColor Yellow
        Write-Host "1. Right-click on the emulator window title bar" -ForegroundColor White
        Write-Host "2. Select 'Maximize' from the context menu" -ForegroundColor White
        Write-Host "3. OR press Alt+Space, then press X" -ForegroundColor White
        Write-Host "4. OR press F11 for fullscreen mode" -ForegroundColor White
        Write-Host ""
        Write-Host "If still having issues:" -ForegroundColor Yellow
        Write-Host "- Check Windows display scaling (set to 100%)" -ForegroundColor White
        Write-Host "- Try dragging window borders manually" -ForegroundColor White
        
        # Wait a moment then try to maximize programmatically
        Start-Sleep -Seconds 5
        Write-Host "Attempting to maximize emulator window..." -ForegroundColor Cyan
        
        # Try to find and maximize the emulator window
        Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;
            public class Win32 {
                [DllImport("user32.dll")]
                public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
                [DllImport("user32.dll")]
                public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
                public const int SW_MAXIMIZE = 3;
            }
"@
        
        # Find emulator window and maximize it
        $emulatorWindow = [Win32]::FindWindow($null, "Android Emulator - $firstAvd" + ":5554")
        if ($emulatorWindow -ne [IntPtr]::Zero) {
            [Win32]::ShowWindow($emulatorWindow, [Win32]::SW_MAXIMIZE)
            Write-Host "Emulator window maximized!" -ForegroundColor Green
        } else {
            Write-Host "Could not find emulator window to maximize automatically." -ForegroundColor Yellow
            Write-Host "Please use the manual instructions above." -ForegroundColor White
        }
        
    } else {
        Write-Host "No AVDs found. Create one in Android Studio first." -ForegroundColor Red
        Write-Host "Available AVDs should include: Pixel_8_Pro_API_33, Test_Phone" -ForegroundColor Yellow
    }
} else {
    Write-Host "Emulator executable not found." -ForegroundColor Red
}
