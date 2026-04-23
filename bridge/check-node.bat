@echo off
echo Checking for Node.js...
where node >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Node.js found!
    node -v
) else (
    echo Node.js not found in PATH.
    echo Please ensure Node.js is installed from https://nodejs.org/
    echo If installed, you may need to restart your terminal or add it to your Environment Variables.
)
pause
