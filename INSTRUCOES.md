# 🚗 ParkHere - Instruções de Uso e Informações

> Arquivo gerado automaticamente com as instruções completas para execução, apresentação e manutenção do protótipo.

---

## 🚀 Como executar o protótipo AGORA

O app está 100% pronto para rodar **sem backend** e **sem Firebase configurado**.

### Opção 1: Modo desenvolvimento (recomendado para testes)

Abra o terminal na pasta `park_here_app` e execute:

```bash
flutter run -d chrome
```

### Opção 2: Build de produção web (para apresentação)

```bash
flutter build web
```

O build será gerado em `build/web/`. Você pode abrir esse conteúdo em qualquer servidor web estático (GitHub Pages, Netlify, Vercel, etc.) ou simplesmente rodar localmente.

---

## 👤 Contas de demonstração

Na tela de login existem cards de demonstração. Toque neles para preencher automaticamente os campos.

| Perfil | E-mail | Senha | O que faz |
|--------|--------|-------|-----------|
| **Motorista** | `joao@email.com` | `123456` | Busca vagas no mapa, reserva e paga |
| **Proprietário** | `maria@email.com` | `123456` | Cadastra estacionamentos e vagas |

---

## 🗺️ Configurando o Google Maps (opcional mas recomendado)

Para o mapa aparecer corretamente no Flutter Web, você precisa de uma API Key do Google:

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um projeto e habilite as APIs:
   - **Maps JavaScript API**
   - **Geocoding API**
3. Gere uma **API Key** restrita para web
4. Abra o arquivo `web/index.html`
5. Substitua `YOUR_API_KEY` pela sua chave real:

```html
<script src="https://maps.googleapis.com/maps/api/js?key=SUA_CHAVE_AQUI"></script>
```

> **Importante:** Sem a API Key, o mapa pode ficar em branco, mas a **lista de estacionamentos na parte inferior continua funcionando 100%**.

---

## 📊 Dados de demonstração já incluídos

O app já vem populado com dados fictícios para impressionar na apresentação:

### Eventos
- **Cruzeiro x Atlético-MG** — Mineirão, Belo Horizonte
- **Festival de Inverno BH** — Praça da Liberdade, Belo Horizonte

### Estacionamentos cadastrados
1. **Estacionamento Gigante da Pampulha** — próximo ao Mineirão (R$ 25,00/h)
2. **Park Centro BH** — Centro de BH (R$ 15,00/h)
3. **Savassi Park** — bairro Savassi (R$ 18,00/h)
4. **Estacionamento Liberdade** — próximo à Praça da Liberdade (R$ 20,00/h)

Cada estacionamento já possui vagas pré-cadastradas (cobertas e descobertas).

### Reserva de exemplo
- Uma reserva já existe na **Park Centro BH** para o motorista `joao@email.com`, provando que o sistema de histórico funciona.

---

## 🎓 Roteiro sugerido para apresentação acadêmica

### Passo 1: Mostre o login e as contas demo
- Explique que há dois perfis: Motorista e Proprietário.
- Clique rapidamente nos cards de demo para logar.

### Passo 2: Fluxo do Motorista
1. Logue como **joao@email.com**
2. Mostre o **mapa** com os estacionamentos em BH
3. Toque em um estacionamento (ou no card inferior)
4. Mostre a tela de detalhes com preço e comodidades
5. Toque em **"Reservar vaga"**
6. Escolha data/hora e uma vaga disponível
7. Avance para o **pagamento simulado**
8. Confirme e mostre a tela de sucesso
9. Vá na aba **"Reservas"** e mostre a nova reserva no histórico

### Passo 3: Fluxo do Proprietário
1. Logue como **maria@email.com** (pode abrir uma segunda aba do navegador)
2. Mostre a lista de **"Meus estacionamentos"**
3. Clique em **"Novo estacionamento"** e cadastre um ao vivo
4. Entre no estacionamento criado e clique em **"Gerenciar vagas"**
5. Adicione uma nova vaga (coberta ou descoberta)
6. Mostre a aba **"Reservas"** para ver as reservas recebidas

### Passo 4: Sistema de Eventos
1. No perfil Motorista, vá na aba **"Eventos"**
2. Mostre o evento **"Cruzeiro x Atlético-MG"**
3. Toque em **"Ver estacionamentos próximos"**
4. Explique como, no futuro, eventos publicados no app atrairão motoristas para estacionamentos próximos

### Dica de impacto
> Faça a reserva no celular/perfil do Motorista e mostre ao mesmo tempo o histórico no perfil do Proprietário. Isso demonstra a comunicação entre os dois lados da plataforma.

---

## 🔥 Como migrar para Firebase no futuro

O código foi escrito com arquitetura limpa para facilitar a migração.

### Passos:

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Instale o Firebase CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. No terminal do projeto, execute:
   ```bash
   flutterfire configure
   ```
4. Adicione as dependências no `pubspec.yaml`:
   ```yaml
   firebase_core: ^latest
   firebase_auth: ^latest
   cloud_firestore: ^latest
   firebase_storage: ^latest
   ```
5. Crie novas classes:
   - `AuthServiceFirebase` implementando `AuthService`
   - `DataServiceFirebase` implementando `DataService`
6. No `main.dart`, troque:
   ```dart
   final authService = AuthServiceMock();
   final dataService = DataServiceMock();
   ```
   por:
   ```dart
   final authService = AuthServiceFirebase();
   final dataService = DataServiceFirebase();
   ```
7. Pronto! Toda a UI, providers e lógica de negócio permanecem **inalterados**.

---

## 🛠️ Tecnologias e versões usadas

| Tecnologia | Versão |
|------------|--------|
| Flutter | 3.41.6 |
| Dart | 3.11.4 |
| Provider | 6.1.5 |
| Google Maps Flutter | 2.17.0 |
| Geolocator | 13.0.4 |
| Geocoding | 3.0.0 |
| Intl | 0.20.2 |
| UUID | 4.5.3 |

---

## 🐛 Problemas comuns e soluções

### O mapa não carrega tiles
- **Causa:** Problema de conexão com os servidores do OpenStreetMap
- **Solução:** Verifique sua conexão com a internet
- **Alternativa:** A lista de estacionamentos na parte inferior da tela continua funcional mesmo sem o mapa.

### Erro "Não foi possível localizar o endereço" ao cadastrar estacionamento
- **Causa:** A biblioteca `geocoding` não conseguiu converter o endereço em coordenadas
- **Solução:** Tente um endereço mais completo (ex: "Rua dos Carijós, 123, Belo Horizonte, MG")
- **Obs:** No modo demo, se o geocoding falhar, o app salva o estacionamento com coordenadas `0,0`. Ele ainda aparece na lista, mas não no mapa.

### Erro de compilação ao rodar no Windows nativo
- **Causa:** O app foi configurado para rodar em **Chrome/Web**
- **Solução:** Sempre use `flutter run -d chrome` para testar este protótipo.

---

## 📁 Estrutura de pastas resumida

```
park_here_app/
├── lib/
│   ├── main.dart                    # Ponto de entrada
│   ├── app.dart                     # Roteamento baseado em auth
│   ├── core/
│   │   ├── constants.dart           # Constantes do app
│   │   └── theme.dart               # Cores e estilos (Material 3)
│   ├── models/                      # Classes de dados
│   ├── services/                    # Interfaces + implementações mock
│   ├── providers/                   # Gerenciamento de estado (Provider)
│   ├── screens/                     # Todas as telas do app
│   │   ├── driver/                  # Fluxo do motorista
│   │   └── owner/                   # Fluxo do proprietário
│   └── widgets/                     # Componentes reutilizáveis
├── web/
│   └── index.html                   # Inclui script do Google Maps
├── pubspec.yaml                     # Dependências
├── README.md                        # Documentação técnica completa
└── INSTRUCOES.md                    # Este arquivo
```

---

## 💡 Ideias para expandir o protótipo

Se quiser evoluir o projeto para a próxima fase, considere:

1. **Autenticação social** — Login com Google/Facebook via Firebase Auth
2. **Upload de fotos reais** — Firebase Storage para imagens dos estacionamentos
3. **Notificações push** — Avisar o proprietário quando uma nova reserva for feita
4. **Avaliações e comentários** — Motoristas avaliam estacionamentos após uso
5. **Filtros avançados** — Preço máximo, distância, tipo de vaga (coberta, 24h, etc.)
6. **Pagamento real** — Integração com Stripe, Mercado Pago ou PagSeguro
7. **Painel administrativo web** — Para moderar eventos e estacionamentos

---

**Boa apresentação acadêmica!** 🎓🚗
