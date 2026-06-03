@echo off
echo ======================================
echo   Iniciando ParkHere (sem Python)
echo ======================================
echo.
echo [INFO] Tentando iniciar servidor via PowerShell...
echo [INFO] Acesse: http://127.0.0.1:8080
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0start_server.ps1"
