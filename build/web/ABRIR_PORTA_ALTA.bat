@echo off
chcp 65001 >nul
echo ======================================
echo   ParkHere - Porta Alternativa
echo ======================================
echo.

set PORT=8765

echo [INFO] Testando com porta %PORT% (evita bloqueio de VPN/proxy)...

python --version >nul 2>&1
if %errorlevel% == 0 (
    set PYTHON_CMD=python
) else (
    py --version >nul 2>&1
    if %errorlevel% == 0 (
        set PYTHON_CMD=py
    ) else (
        echo [ERRO] Python nao encontrado.
        pause
        exit /b 1
    )
)

REM Mata processos antigos na mesma porta
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%PORT%') do (
    taskkill /F /PID %%a >nul 2>&1
)

start /min "ParkHere Server" %PYTHON_CMD% -m http.server %PORT%
timeout /t 2 /nobreak >nul

echo [OK] Abrindo navegador em http://127.0.0.1:%PORT%
start http://127.0.0.1:%PORT%

echo.
echo DICA: Se ainda travar, desative a VPN momentaneamente
echo ou tente abrir no MODO ANONIMO do navegador (Ctrl+Shift+N)
echo.
echo Pressione qualquer tecla para encerrar.
pause >nul

for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%PORT%') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Servidor encerrado.
