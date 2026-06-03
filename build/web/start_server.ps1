$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$port/")
$listener.Start()

Write-Host "======================================" -ForegroundColor Green
Write-Host "  Servidor ParkHere iniciado!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Acesse no navegador:" -ForegroundColor Cyan
Write-Host "  http://127.0.0.1:$port" -ForegroundColor White
Write-Host ""
Write-Host "Pressione CTRL+C para parar o servidor" -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Green

# Abre o navegador automaticamente
Start-Process "http://127.0.0.1:$port"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $localPath = $request.Url.LocalPath.TrimStart('/')

    if ($localPath -eq "") { $localPath = "index.html" }
    $filePath = Join-Path (Get-Location) $localPath

    if (Test-Path $filePath -PathType Leaf) {
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("Arquivo nao encontrado: $localPath")
        $response.ContentLength64 = $msg.Length
        $response.OutputStream.Write($msg, 0, $msg.Length)
    }
    $response.Close()
}

$listener.Stop()
