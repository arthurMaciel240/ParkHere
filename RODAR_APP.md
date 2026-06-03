# 🚀 Como rodar o ParkHere no seu computador

## O que aconteceu com o erro?

Quando você executou `D:\flutter\bin\flutter run -d chrome`, o Windows abriu um CMD separado porque o arquivo é um `.bat`. Isso é comportamento normal do Windows quando chama scripts `.bat` diretamente.

O app **funcionou**, mas o mapa do Google ficou cinza porque ainda falta a **API Key** (isso é esperado no protótipo).

---

## ✅ Forma mais fácil de rodar

### Opção 1: Usar o script que criamos (recomendado)

No terminal PowerShell, dentro da pasta do projeto (`park_here_app`), execute:

```powershell
.\run_web.ps1
```

Isso vai rodar o app no Chrome automaticamente, sem abrir janelas de CMD estranhas.

> **Nota:** Se der erro de execução de scripts no PowerShell, execute primeiro:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> E depois tente de novo.

---

### Opção 2: Fechar e reabrir o terminal

O PATH do Flutter já foi adicionado ao Windows. **Feche completamente o terminal atual** e abra um novo. Depois digite:

```powershell
flutter run -d chrome
```

Agora vai funcionar sem precisar digitar o caminho completo `D:\flutter\bin\flutter`.

---

### Opção 3: Caminho absoluto sem abrir CMD

Se quiser continuar no terminal atual sem fechar, use o arquivo `.bat` com o operador `&`:

```powershell
& "D:\flutter\bin\flutter.bat" run -d chrome
```

Ou chame o `dart` diretamente:

```powershell
D:\flutter\bin\dart.bat run -d chrome
```

> Não recomendado, a Opção 1 ou 2 são melhores.

---

## 🗺️ Sobre o mapa

O app agora usa **OpenStreetMap** (gratuito, sem API Key). O mapa deve carregar normalmente com os tiles do OpenStreetMap mostrando Belo Horizonte e os markers dos estacionamentos.

Se o mapa não carregar os tiles, verifique sua conexão com a internet. Mesmo assim, **a lista de estacionamentos na parte inferior da tela continua funcionando perfeitamente** para a apresentação.

---

## 🖼️ Imagens corrigidas

As imagens de exemplo que estavam quebradas (erro 404 do Unsplash) já foram substituídas por links do `picsum.photos` que funcionam 100%.
