# Script PowerShell para iniciar um servidor web local com o build do ParkHere
# Ideal para apresentação acadêmica em sala de aula

$buildPath = "build\web"
$port = 8080

# Verifica se o build existe
if (-not (Test-Path $buildPath)) {
    Write-Host "ERRO: Pasta $buildPath nao encontrada!" -ForegroundColor Red
    Write-Host "Execute primeiro: D:\flutter\bin\flutter.bat build web" -ForegroundColor Yellow
    exit 1
}

# Tenta descobrir o IP local
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*" } | Select-Object -First 1).IPAddress

Write-Host "======================================" -ForegroundColor Green
Write-Host "  Servidor ParkHere iniciado!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Acesse no seu navegador:" -ForegroundColor Cyan
Write-Host "  Local:  http://localhost:$port" -ForegroundColor White
if ($ip) {
    Write-Host "  Rede:   http://${ip}:$port" -ForegroundColor White
}
Write-Host ""
Write-Host "Pressione CTRL+C para parar o servidor" -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Green

# Inicia o servidor Python
Set-Location $buildPath
python -m http.server $port
