# 🌐 Como publicar o ParkHere para apresentação

Aqui estão as melhores opções para deixar seu protótipo acessível na web.

---

## 🥇 Opção 1: Servidor local na sua máquina (MAIS FÁCIL)

Ideal para apresentação em sala de aula onde você vai mostrar na sua própria tela ou projetor.

### Passo a passo:

1. Certifique-se de que o build foi gerado:
   ```powershell
   D:\flutter\bin\flutter.bat build web
   ```

2. Inicie o servidor local com um dos métodos abaixo:

#### Usando Python (recomendado - geralmente já vem no Windows)
Abra o terminal na pasta `park_here_app` e execute:

```powershell
cd build\web
python -m http.server 8080
```

Acesse no navegador: `http://localhost:8080`

#### Usando Node.js (se tiver instalado)
```powershell
npx serve build\web
```

#### Usando o script que criamos
```powershell
.\start_server.ps1
```

> 💡 **Dica para sala de aula:** Se quiser que seus colegas acessem pelo celular na mesma rede Wi-Fi, descubra seu IP local digitando `ipconfig` no terminal e acesse `http://SEU_IP:8080` (ex: `http://192.168.1.15:8080`)

---

## 🥈 Opção 2: GitHub Pages (GRATUITO E ONLINE 24H)

Perfeito para deixar o link fixo e compartilhar com professores/colegas a qualquer hora.

### Passo a passo:

1. Crie um repositório no [GitHub](https://github.com/new) com o nome `parkhere`
2. No terminal, dentro da pasta `park_here_app`, execute:

```powershell
cd build\web
git init
git add .
git commit -m "Primeira versao do prototipo ParkHere"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/parkhere.git
git push -u origin main
```

3. No site do GitHub, vá em **Settings → Pages**
4. Em "Source", selecione a branch `main` e a pasta `/ (root)`
5. Salve e aguarde 1-2 minutos
6. Seu app estará em: `https://SEU_USUARIO.github.io/parkhere`

> ⚠️ **Importante:** Toda vez que você fizer alterações no app, precisa reconstruir (`flutter build web`) e fazer `git add .`, `git commit`, `git push` novamente na pasta `build/web`.

---

## 🥉 Opção 3: Netlify Drop (GRATUITO, SEM PRECISAR DE CONTA)

A maneira mais rápida de publicar na internet sem criar conta.

1. Acesse: [https://app.netlify.com/drop](https://app.netlify.com/drop)
2. Arraste a pasta `build/web` inteira para a área indicada no site
3. Pronto! Em segundos você terá um link tipo `https://abc123.netlify.app`

> ✅ **Vantagem:** Não precisa de GitHub, conta ou comandos. Só arrastar e soltar.
> 
> ❌ **Desvantagem:** O link é aleatório. Se quiser um link fixo, precisa criar uma conta gratuita no Netlify.

---

## 🚀 Opção Bônus: Vercel (muito profissional)

Se quiser algo mais "tech":

1. Instale o Vercel CLI (precisa do Node.js):
   ```powershell
   npm i -g vercel
   ```
2. Publique:
   ```powershell
   cd build\web
   vercel --prod
   ```
3. Pronto! Link profissional tipo `https://parkhere.vercel.app`

---

## 📋 Resumo rápido

| Opção | Dificuldade | Precisa de internet | Link fixo | Melhor para |
|-------|-------------|---------------------|-----------|-------------|
| **Servidor local** | ⭐ Fácil | ❌ Só rede local | ❌ Não | Apresentar na sua máquina/projetor |
| **GitHub Pages** | ⭐⭐ Médio | ✅ Sim | ✅ Sim | Compartilhar link permanente |
| **Netlify Drop** | ⭐ Fácil | ✅ Sim | ❌ Aleatório | Publicação emergencial rápida |
| **Vercel** | ⭐⭐ Médio | ✅ Sim | ✅ Sim | Portfólio profissional |

---

## 🎯 Minha recomendação para apresentação acadêmica

Se for apresentar **na sala de aula** usando seu notebook/projetor:
→ Use a **Opção 1** (servidor local). É a mais estável e não depende de internet.

Se precisar **compartilhar o link** com o professor antes da apresentação:
→ Use a **Opção 2** (GitHub Pages) ou **Opção 3** (Netlify Drop).

**Boa apresentação!** 🎓🚗
