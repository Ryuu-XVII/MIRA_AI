@echo off
echo ========================================
echo MIRA AI - Complete System Startup
echo ========================================
echo.

REM Step 1: Check if Ollama is already running
echo [1/3] Checking Ollama Service...
netstat -ano | findstr ":11434" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Ollama already running on port 11434
) else (
    echo Starting Ollama Service...
    where ollama >nul 2>&1
    if %errorlevel% equ 0 (
        start "Ollama Service" ollama serve
        timeout /t 3 /nobreak >nul
        echo ✓ Ollama started on port 11434
    ) else (
        if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
            start "Ollama Service" "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" serve
            timeout /t 3 /nobreak >nul
            echo ✓ Ollama started from local programs
        ) else if exist "C:\Program Files\Ollama\ollama.exe" (
            start "Ollama Service" "C:\Program Files\Ollama\ollama.exe" serve
            timeout /t 3 /nobreak >nul
            echo ✓ Ollama started from system programs
        ) else (
            echo ⚠ Ollama not found!
            echo Please install Ollama or start it manually.
            echo Continuing anyway - make sure Ollama is running...
        )
    )
)
echo.

REM Step 2: Clean up old processes
echo [2/3] Cleaning up old Node processes...
taskkill /F /IM node.exe >nul 2>&1
echo ✓ Cleanup complete
echo.

REM Step 3: Start Mira Bridge and React UI
echo [3/3] Starting Mira Bridge and React UI...
echo ✓ React UI will be available at http://localhost:5173
echo ✓ Bridge Server listening at http://localhost:3002
echo.
echo ========================================
echo MIRA SYSTEM ONLINE
echo Access at: http://localhost:5173
echo ========================================
echo.

REM Wait a moment for Vite server to start, then open browser
start "" cmd /c "timeout /t 3 /nobreak >nul && start http://localhost:5173"

REM Start bridge and Vite frontend concurrently
npm start
