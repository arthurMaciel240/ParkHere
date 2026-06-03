@echo off
chcp 65001 >nul
echo ======================================
echo   Iniciando ParkHere Server
echo ======================================
echo.

python --version >nul 2>&1
if errorlevel 1 (
    py --version >nul 2>&1
    if errorlevel 1 (
        echo [ERRO] Python nao encontrado.
        echo.
        echo Para rodar este app, instale o Python:
        echo https://www.python.org/downloads
        echo.
        echo Durante a instalacao, MARQUE a opcao:
        echo "Add python.exe to PATH"
        echo.
        pause
        exit /b 1
    ) else (
        set PYTHON_CMD=py
    )
) else (
    set PYTHON_CMD=python
)

echo [OK] Python encontrado.
echo [INFO] Parando servidor anterior...
taskkill /FI "WINDOWTITLE eq ParkHere Server" /F >nul 2>&1

echo [INFO] Iniciando servidor HTTP na porta 8080...
start /min "ParkHere Server" %PYTHON_CMD% -m http.server 8080

echo [INFO] Aguardando 2 segundos...
timeout /t 2 /nobreak >nul

echo [OK] Abrindo navegador em http://127.0.0.1:8080
start http://127.0.0.1:8080

echo.
echo ======================================
echo  ParkHere esta rodando! ??
echo ======================================
echo.
echo Mantenha esta janela aberta.
echo Pressione qualquer tecla para ENCERRAR.
pause >nul

taskkill /FI "WINDOWTITLE eq ParkHere Server" /F >nul 2>&1
echo Servidor encerrado.
timeout /t 1 /nobreak >nul
