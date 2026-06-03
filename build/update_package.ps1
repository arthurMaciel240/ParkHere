Set-Location 'D:/Trabalho Faculdade/park_here_app/build'
Remove-Item -Recurse -Force 'ParkHere_Presentacao' -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path 'ParkHere_Presentacao/web' -Force | Out-Null

Get-ChildItem -Path 'web' | ForEach-Object {
    $dest = Join-Path 'ParkHere_Presentacao/web' $_.Name
    if ($_.PSIsContainer) {
        Copy-Item -Path $_.FullName -Destination $dest -Recurse -Force
    } else {
        Copy-Item -Path $_.FullName -Destination $dest -Force
    }
}

$readme = @"
======================================
  PARKHERE - PARA APRESENTACAO
======================================

COMO ABRIR:
------------
1. De DUPLO CLIQUE em ABRIR.bat
2. Aguarde 2 segundos
3. O navegador abrira automaticamente
4. Pronto! O app estara em http://127.0.0.1:8080

NOVAS FUNCIONALIDADES:
----------------------
- BUSCA DE REGIOES: No mapa, digite rua, bairro ou cidade
  e o mapa centraliza no local, mostrando estacionamentos proximos
  
- ROTAS: Nos cards dos estacionamentos ou na tela de detalhes,
  clique em 'Rota' ou 'Como chegar' para ver a distancia,
  tempo estimado e a linha da rota desenhada no mapa

CONTAS DE DEMONSTRACAO:
-----------------------
Motorista:    joao@email.com / 123456
Proprietario: maria@email.com / 123456

======================================
Boa apresentacao academica!
======================================
"@
$readme | Out-File -FilePath 'ParkHere_Presentacao/LEIA-ME.txt' -Encoding ASCII -Force

Remove-Item 'ParkHere_Presentacao.zip' -Force -ErrorAction SilentlyContinue
Compress-Archive -Path 'ParkHere_Presentacao/*' -DestinationPath 'ParkHere_Presentacao.zip' -Force

Write-Host 'PACOTE ATUALIZADO!' -ForegroundColor Green
Get-ChildItem 'ParkHere_Presentacao.zip' | Select-Object Name, @{N='Tamanho(MB)';E={[math]::Round($_.Length/1MB,2)}}, FullName
