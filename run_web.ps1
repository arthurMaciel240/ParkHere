# Script para rodar o ParkHere no Chrome sem depender do PATH do sistema
$flutterPath = "D:\flutter\bin\flutter.bat"
$port = 53426

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Iniciando ParkHere no Chrome..." -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

& $flutterPath run -d chrome --web-port $port

Write-Host ""
Write-Host "App encerrado." -ForegroundColor Yellow
