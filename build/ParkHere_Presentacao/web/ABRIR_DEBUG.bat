@echo off
chcp 65001 >nul
echo ======================================
echo   ParkHere - Modo Diagnostico
echo ======================================
echo.

python --version >nul 2>&1
if %errorlevel% == 0 (
    echo [OK] Python encontrado.
    echo [INFO] Iniciando servidor na porta 8080...
    echo [INFO] Acesse: http://127.0.0.1:8080
    echo.
    python -m http.server 8080
    goto :end
)

py --version >nul 2>&1
if %errorlevel% == 0 (
    echo [OK] Python (py) encontrado.
    echo [INFO] Iniciando servidor na porta 8080...
    echo [INFO] Acesse: http://127.0.0.1:8080
    echo.
    py -m http.server 8080
    goto :end
)

echo [ERRO] Python nao encontrado neste computador.
echo.
echo Solucoes:
echo 1. Instale o Python pelo site: https://python.org
echo 2. Ou abra esta pasta no VS Code e use a extensao Live Server
echo 3. Ou instale o Node.js e execute: npx serve
pause

:end
