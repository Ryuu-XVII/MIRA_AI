@echo off
setlocal
cd /d "%~dp0"
mkdir bin 2>nul

echo [MIRA] Downloading verified llama.cpp binaries (b8022)...
curl -L -o llama-bin.zip "https://github.com/ggml-org/llama.cpp/releases/download/b8022/llama-b8022-bin-win-cuda-12.4-x64.zip"

echo [MIRA] Downloading CUDA runtime DLLs...
curl -L -o cuda-dlls.zip "https://github.com/ggml-org/llama.cpp/releases/download/b8022/cudart-llama-bin-win-cuda-12.4-x64.zip"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to download binaries.
    exit /b 1
)

echo [MIRA] Extracting binaries...
powershell -Command "Expand-Archive -Path llama-bin.zip -DestinationPath bin -Force"
powershell -Command "Expand-Archive -Path cuda-dlls.zip -DestinationPath bin -Force"

echo [MIRA] Setup complete. llama-server.exe and CUDA DLLs are ready in the bin folder.
del llama-bin.zip
del cuda-dlls.zip
