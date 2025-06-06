@echo off
echo Adding Git and Flutter to system PATH...
echo This requires administrator privileges.
echo.

REM Add Git paths to system PATH
setx PATH "%PATH%;C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\dev\flutter\bin" /M

echo.
echo PATH updated successfully!
echo Please restart your computer or VS Code for changes to take effect.
echo.
pause
