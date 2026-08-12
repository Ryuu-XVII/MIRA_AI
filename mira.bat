@echo off
echo ========================================
echo MIRA AI - Complete System Startup
echo ========================================
echo.

REM Step 1: Check if LM Studio Local Server is running
echo [1/3] Checking LM Studio Local Server (Port 1234)...
netstat -ano | findstr ":1234" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ LM Studio Server running on port 1234
) else (
    echo ⚠ LM Studio Server not detected on port 1234!
    echo Please launch LM Studio and ensure the Local Server is started.
    echo Continuing anyway...
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
