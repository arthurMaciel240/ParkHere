' ParkHere - Iniciador Silencioso
' Nao precisa de Python, Node.js ou Flutter. Usa apenas o Windows.

Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Descobre a pasta onde este arquivo .vbs esta
webFolder = FSO.GetParentFolderName(WScript.ScriptFullName)

' Comando PowerShell para iniciar servidor HTTP nativo do Windows
psCommand = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -Command """ & _
    "cd '" & webFolder & "'; " & _
    "$listener = New-Object System.Net.HttpListener; " & _
    "$listener.Prefixes.Add('http://127.0.0.1:8080/'); " & _
    "$listener.Start(); " & _
    "Start-Process 'http://127.0.0.1:8080'; " & _
    "while ($listener.IsListening) { " & _
    "  $ctx = $listener.GetContext(); " & _
    "  $req = $ctx.Request; $res = $ctx.Response; " & _
    "  $path = $req.Url.LocalPath.TrimStart('/'); " & _
    "  if ($path -eq '') { $path = 'index.html' }; " & _
    "  $file = Join-Path (Get-Location) $path; " & _
    "  if (Test-Path $file -PathType Leaf) { " & _
    "    $buf = [System.IO.File]::ReadAllBytes($file); " & _
    "    $res.ContentLength64 = $buf.Length; " & _
    "    $res.OutputStream.Write($buf, 0, $buf.Length) " & _
    "  } else { " & _
    "    $res.StatusCode = 404; " & _
    "    $msg = [System.Text.Encoding]::UTF8.GetBytes('Arquivo nao encontrado: ' + $path); " & _
    "    $res.ContentLength64 = $msg.Length; " & _
    "    $res.OutputStream.Write($msg, 0, $msg.Length) " & _
    "  }; " & _
    "  $res.Close() " & _
    "}"" "

' Inicia o PowerShell escondido
WshShell.Run psCommand, 0, False

' Aguarda 2 segundos para o servidor iniciar
WScript.Sleep 2000

' Abre o navegador
WshShell.Run "http://127.0.0.1:8080", 1, False

' Avisa o usuario
MsgBox "ParkHere iniciado com sucesso!" & vbCrLf & vbCrLf & _
       "O navegador esta abrindo o app." & vbCrLf & _
       "Para encerrar, feche esta mensagem e use o Gerenciador de Tarefas para finalizar 'wscript.exe' ou 'powershell.exe'.", _
       vbInformation, "ParkHere"
