@echo off
chcp 65001 >nul
echo ======================================
echo   ParkHere - Modo Teste/Diagnostico
echo ======================================
echo.

REM Verifica Python
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

echo [OK] Python encontrado.
echo [INFO] Limpando processos antigos na porta 8080...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo [INFO] Iniciando servidor HTTP...
start /min "ParkHere Server" %PYTHON_CMD% -m http.server 8080
echo [INFO] Aguardando servidor iniciar...
timeout /t 3 /nobreak >nul

echo [INFO] Testando conexao com o servidor...
curl -s -o nul -w "%%{http_code}" http://127.0.0.1:8080 > temp_status.txt
set /p STATUS=<temp_status.txt
del temp_status.txt >nul 2>&1

echo [INFO] Resposta do servidor: %STATUS%

if "%STATUS%"=="200" (
    echo [OK] Servidor funcionando corretamente!
    echo [INFO] Abrindo navegador em http://127.0.0.1:8080
    start http://127.0.0.1:8080
) else (
    echo [AVISO] Servidor pode nao estar pronto ainda.
    echo [INFO] Abrindo navegador mesmo assim...
    start http://127.0.0.1:8080
)

echo.
echo ======================================
echo  DICAS SE FICAR CARREGANDO:
echo ======================================
echo 1. Pressione F12 no navegador e veja o Console
echo 2. Tente Ctrl+Shift+R para limpar o cache
echo 3. Tente outro navegador (Edge, Firefox)
echo 4. Verifique se o antivirus esta bloqueando
echo ======================================
echo.
echo Pressione qualquer tecla para encerrar o servidor.
pause >nul

taskkill /FI "WINDOWTITLE eq ParkHere Server" >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Servidor encerrado.
