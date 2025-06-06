@echo off
echo ======================================
echo Android Emulator - Ultra Stable Mode
echo ======================================

cd /d "%LOCALAPPDATA%\Android\sdk\emulator"

echo Starting emulator with stable settings...
echo This will prevent the window from disappearing.

emulator.exe -avd "Pixel_8_Pro_API_33" -gpu swiftshader -memory 1024 -no-snapshot -no-audio -verbose

echo.
echo If emulator closed, press any key to restart...
pause
