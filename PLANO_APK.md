# 📱 Plano de Execução - Geração do APK Android

Este documento descreve o passo a passo completo para compilar o app ParkHere em um arquivo `.apk` instalável em dispositivos Android.

---

## 📋 Pré-requisitos

| Componente | Versão Mínima | Função |
|------------|---------------|--------|
| Flutter SDK | 3.41.6 | Framework do app |
| Android SDK | API 34 (Android 14) | Plataforma de build |
| Java JDK | 17 ou superior | Compilação Java/Kotlin |
| Windows | 10/11 64-bit | Sistema operacional |

---

## 🗺️ Etapa 1: Instalar Android SDK (Command Line Tools)

### 1.1 Download
Acesse: https://developer.android.com/studio#command-tools

Ou baixe diretamente:
```
https://dl.google.com/android/repository/commandlinetools-win-12266719_latest.zip
```

### 1.2 Extração e organização
Extraia para `D:\Android\cmdline-tools\latest\`

A estrutura deve ficar:
```
D:\Android\
  └── cmdline-tools\
      └── latest\
          ├── bin\
          ├── lib\
          └── ...
```

> ⚠️ **IMPORTANTE:** A pasta DEVE se chamar `latest` dentro de `cmdline-tools`. O Flutter não reconhece outro nome.

---

## ⚙️ Etapa 2: Configurar Variáveis de Ambiente

### 2.1 Variáveis do Sistema
Abra: Configurações do Sistema → Variáveis de Ambiente

Adicione estas variáveis ao **Path do Usuário**:

```
D:\Android\cmdline-tools\latest\bin
D:\Android\platform-tools
```

### 2.2 Variável ANDROID_HOME
Crie uma nova variável de ambiente:

| Nome | Valor |
|------|-------|
| `ANDROID_HOME` | `D:\Android` |
| `ANDROID_SDK_ROOT` | `D:\Android` |

### 2.3 Configurar Java (se necessário)
O Flutter já inclui um JDK embutido, mas se precisar:

```
JAVA_HOME = C:\Program Files\Java\jdk-17
```

---

## 📦 Etapa 3: Instalar Componentes do Android SDK

### 3.1 Abra o terminal e execute:
```cmd
cd D:\Android\cmdline-tools\latest\bin
```

### 3.2 Liste os pacotes disponíveis:
```cmd
sdkmanager.bat --list
```

### 3.3 Instale os pacotes essenciais:
```cmd
sdkmanager.bat "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### 3.4 Aceite as licenças:
```cmd
sdkmanager.bat --licenses
```
> Digite `y` em todas as licenças solicitadas.

---

## 🔧 Etapa 4: Configurar Flutter para Android

### 4.1 Informe ao Flutter onde está o SDK:
```cmd
flutter config --android-sdk D:\Android
```

### 4.2 Verifique se tudo está OK:
```cmd
flutter doctor
```

Você deve ver algo como:
```
[✓] Android toolchain - develop for Android devices
```

---

## 🔨 Etapa 5: Compilar o APK

### 5.1 Navegue até o projeto:
```cmd
cd "D:\Trabalho Faculdade\park_here_app"
```

### 5.2 Limpe builds anteriores (recomendado):
```cmd
flutter clean
flutter pub get
```

### 5.3 Compile o APK de release:
```cmd
flutter build apk --release
```

> ⏱️ **Tempo estimado:** 2 a 5 minutos na primeira vez.

### 5.4 Localize o APK gerado:
```
D:\Trabalho Faculdade\park_here_app\build\app\outputs\flutter-apk\app-release.apk
```

---

## 📤 Etapa 6: Distribuir o APK

### Opção A: Enviar por WhatsApp/E-mail
- O arquivo `app-release.apk` pode ser enviado diretamente
- O destinatário precisa habilitar "Instalar de fontes desconhecidas"

### Opção B: Google Drive / OneDrive
- Faça upload do APK
- Compartilhe o link de download

### Opção C: Instalar via ADB (desenvolvimento)
```cmd
adb install build\app\outputs\flutter-apk\app-release.apk
```

---

## 🐛 Solução de Problemas Comuns

### Erro: "Unable to locate Android SDK"
**Solução:** Verifique se as variáveis `ANDROID_HOME` e `ANDROID_SDK_ROOT` estão configuradas corretamente.

### Erro: "sdkmanager.bat not found"
**Solução:** Verifique se a pasta está em `D:\Android\cmdline-tools\latest\bin\sdkmanager.bat`

### Erro: "Java not found"
**Solução:** Execute `flutter config --jdk-dir "C:\Program Files\Java\jdk-17"`

### Erro: "Gradle build failed"
**Solução:** Execute `flutter clean` e tente novamente. Verifique a conexão com a internet.

---

## 📊 Resumo Visual do Processo

```
Baixar Command Line Tools
        ↓
Extrair para D:\Android\cmdline-tools\latest\
        ↓
Configurar Variáveis de Ambiente (ANDROID_HOME, Path)
        ↓
Instalar SDK components (sdkmanager)
        ↓
Aceitar Licenças
        ↓
flutter config --android-sdk D:\Android
        ↓
flutter doctor (verificar ✓)
        ↓
flutter build apk --release
        ↓
APK pronto em build\app\outputs\flutter-apk\
```

---

## 💡 Dicas para Apresentação Acadêmica

1. **Teste o APK no celular antes** da apresentação
2. **Instale em pelo menos 2 celulares** (motorista + proprietário)
3. **Desative o modo escuro** do celular se o app ficar com cores estranhas
4. **Verifique a internet** do celular — o mapa e busca precisam de conexão

---

**Boa apresentação!** 🎓🚗
