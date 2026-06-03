@echo off
chcp 65001 >nul
echo ======================================
echo   ParkHere - Setup Android SDK
echo ======================================
echo.

set ANDROID_DIR=D:\Android
set CMDTOOLS_ZIP=%ANDROID_DIR%\cmdline-tools.zip
set CMDTOOLS_URL=https://dl.google.com/android/repository/commandlinetools-win-12266719_latest.zip

echo [1/5] Criando pasta D:\Android...
if not exist "%ANDROID_DIR%" mkdir "%ANDROID_DIR%"

echo [2/5] Baixando Android Command Line Tools...
echo Isso pode levar alguns minutos...
powershell -Command "Invoke-WebRequest -Uri '%CMDTOOLS_URL%' -OutFile '%CMDTOOLS_ZIP%'"
if errorlevel 1 (
    echo [ERRO] Falha no download. Verifique sua conexao.
    pause
    exit /b 1
)

echo [3/5] Extraindo arquivos...
powershell -Command "Expand-Archive -Path '%CMDTOOLS_ZIP%' -DestinationPath '%ANDROID_DIR%' -Force"

:: Reorganizar estrutura
echo [4/5] Organizando estrutura...
if exist "%ANDROID_DIR%\cmdline-tools" (
    ren "%ANDROID_DIR%\cmdline-tools" "latest_temp"
    mkdir "%ANDROID_DIR%\cmdline-tools" >nul 2>&1
    move /Y "%ANDROID_DIR%\latest_temp" "%ANDROID_DIR%\cmdline-tools\latest" >nul 2>&1
)
del "%CMDTOOLS_ZIP%" >nul 2>&1

echo [5/5] Instalando componentes Android...
call "%ANDROID_DIR%\cmdline-tools\latest\bin\sdkmanager.bat" "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo.
echo ======================================
echo  Configurando ambiente...
echo ======================================
echo.

:: Configurar Flutter
D:\flutter\bin\flutter.bat config --android-sdk %ANDROID_DIR%

echo [OK] Variaveis configuradas.
echo.
echo ======================================
echo  Verificando instalacao...
echo ======================================
echo.
D:\flutter\bin\flutter.bat doctor --android-licenses
echo y|D:\flutter\bin\flutter.bat doctor --android-licenses

echo.
echo ======================================
echo  Android SDK instalado!
echo ======================================
echo.
echo Agora execute:
echo   cd "D:\Trabalho Faculdade\park_here_app"
echo   flutter build apk --release
echo.
pause
