# 🚗 ParkHere - Protótipo Acadêmico

Aplicativo de estacionamento por agendamento desenvolvido em **Flutter** para apresentação acadêmica.

## ✨ Funcionalidades implementadas

- **Autenticação** com roles separadas: Motorista e Proprietário
- **Cadastro de estacionamentos** com endereço, preço e foto
- **Cadastro de vagas** dentro de cada estacionamento (coberta/descoberta)
- **Mapa interativo** com markers dos estacionamentos cadastrados
- **Reserva de vagas** por período com verificação de disponibilidade em tempo real
- **Pagamento simulado** para demonstração completa do fluxo
- **Histórico de reservas** para motoristas e proprietários
- **Eventos** com filtragem de estacionamentos próximos (ex: jogos, shows)

## 🚀 Como executar o protótipo

O app está pronto para rodar **imediatamente** no navegador (Chrome), sem necessidade de configurar backend ou conta Firebase.

### 1. Rodar no modo desenvolvimento (debug)

Abra o terminal na pasta `park_here_app` e execute:

```bash
flutter run -d chrome
```

### 2. Gerar build de produção web

```bash
flutter build web
```

O build será gerado na pasta `build/web`. Você pode abrir o `index.html` em qualquer servidor web estático para apresentar.

## 👤 Contas de demonstração

Na tela de login, toque nos cards de demonstração para preencher automaticamente:

| Perfil | E-mail | Senha |
|--------|--------|-------|
| **Motorista** | `joao@email.com` | `123456` |
| **Proprietário** | `maria@email.com` | `123456` |

### Dados de seed (pré-cadastrados)

- **4 estacionamentos** em Belo Horizonte (Mineirão, Centro, Savassi, Liberdade)
- **2 eventos**: Cruzeiro x Atlético-MG e Festival de Inverno BH
- **Vagas e 1 reserva de exemplo** para demonstração imediata

## 🗺️ Mapa

O app utiliza **OpenStreetMap** via `flutter_map`, totalmente gratuito e sem necessidade de API Key. O mapa funciona imediatamente ao rodar o app, mostrando os estacionamentos cadastrados com markers interativos.

## 🔥 Migrando para Firebase (futuro)

O código já está estruturado para fácil migração para Firebase:

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Instale o Firebase CLI e execute `flutterfire configure`
3. Substitua as implementações mock pelas de Firebase:
   - `AuthServiceMock` → `FirebaseAuth`
   - `DataServiceMock` → `Cloud Firestore`
4. A arquitetura com `Provider` permanece exatamente a mesma

## 📁 Estrutura do projeto

```
lib/
├── main.dart              # Inicialização e providers
├── app.dart               # Roteamento baseado em autenticação
├── core/
│   ├── constants.dart     # Constantes do app
│   └── theme.dart         # Tema visual (Material 3)
├── models/
│   ├── user_model.dart
│   ├── parking_lot_model.dart
│   ├── spot_model.dart
│   ├── booking_model.dart
│   └── event_model.dart
├── services/
│   ├── auth_service.dart         # Interface
│   ├── auth_service_mock.dart    # Implementação demo
│   ├── data_service.dart         # Interface
│   └── data_service_mock.dart    # Implementação demo
├── providers/
│   ├── auth_provider.dart
│   └── app_provider.dart
└── screens/
    ├── login_screen.dart
    ├── register_screen.dart
    ├── driver/
    │   ├── driver_home_screen.dart
    │   ├── map_screen.dart
    │   ├── parking_detail_screen.dart
    │   ├── booking_screen.dart
    │   ├── payment_screen.dart
    │   ├── bookings_history_screen.dart
    │   └── events_screen.dart
    └── owner/
        ├── owner_home_screen.dart
        ├── parking_lots_screen.dart
        ├── parking_lot_form_screen.dart
        ├── spots_management_screen.dart
        ├── spot_form_screen.dart
        └── owner_bookings_screen.dart
```

## 🎓 Dicas para apresentação acadêmica

1. **Abra duas abas do Chrome**: uma logada como Motorista e outra como Proprietário
2. **Reserve uma vaga** no perfil Motorista e mostre a alteração no histórico
3. **Mostre o evento** "Cruzeiro x Atlético-MG" e os estacionamentos próximos ao Mineirão
4. **Cadastre um novo estacionamento** ao vivo no perfil Proprietário para demonstrar a usabilidade

## 🛠️ Tecnologias utilizadas

- **Flutter 3.41.6** (Dart 3.11)
- **Provider** - Gerenciamento de estado
- **Flutter Map + OpenStreetMap** - Mapas e geolocalização (gratuito, sem API Key)
- **Intl** - Formatação de datas e moeda
- **UUID** - Geração de IDs

---

Desenvolvido para fins acadêmicos. Protótipo 100% funcional e pronto para apresentação!
