# 📘 Documentação Técnica - ParkHere

> **Projeto:** Protótipo de Aplicativo de Estacionamento por Agendamento
> **Versão:** 1.0.0
> **Data:** Abril/2026
> **Plataforma:** Flutter (Web + Android)
> **Finalidade:** Apresentação Acadêmica

---

## 📑 Índice

1. [Visão Geral](#1-visão-geral)
2. [Arquitetura do Sistema](#2-arquitetura-do-sistema)
3. [Tecnologias Utilizadas](#3-tecnologias-utilizadas)
4. [Modelos de Dados](#4-modelos-de-dados)
5. [Serviços](#5-serviços)
6. [Telas e Fluxos](#6-telas-e-fluxos)
7. [Funcionalidades Implementadas](#7-funcionalidades-implementadas)
8. [APIs Externas](#8-apis-externas)
9. [Estrutura de Pastas](#9-estrutura-de-pastas)
10. [Como Executar](#10-como-executar)
11. [Build e Distribuição](#11-build-e-distribuição)
12. [Screenshots e Fluxo de Uso](#12-screenshots-e-fluxo-de-uso)

---

## 1. Visão Geral

O **ParkHere** é um protótipo funcional de aplicativo mobile para **estacionamento por agendamento**. O sistema permite que:

- **Proprietários** cadastrem seus estacionamentos, definam preços e gerenciem vagas
- **Motoristas** encontrem vagas disponíveis próximas ao seu destino, façam reservas e pagamentos simulados
- **Eventos** sejam anunciados, permitindo que motoristas encontrem estacionamentos próximos a shows, jogos, etc.

O protótipo foi desenvolvido com foco em **apresentação acadêmica**, utilizando dados mockados em memória para funcionamento imediato, mas com arquitetura preparada para migração futura para Firebase.

---

## 2. Arquitetura do Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                        FLUTTER APP                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │  Providers  │  │      Services       │  │
│  │  (UI/UX)    │◄─┤  (Estado)   │◄─┤  (Regras de Negócio)│  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│         ▲                                     ▲              │
│         │                                     │              │
│  ┌──────┴──────┐                     ┌────────┴────────┐     │
│  │   Models    │                     │   Data Source   │     │
│  │  (Entidades)│                     │ (Mock/Firebase) │     │
│  └─────────────┘                     └─────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │  APIs Externas  │
                    │ OpenStreetMap   │
                    │ OSRM (Rotas)    │
                    │ Nominatim       │
                    └─────────────────┘
```

### Padrão Arquitetural

O projeto utiliza o padrão **Provider + Repository**, com as seguintes camadas:

| Camada | Responsabilidade | Arquivos |
|--------|-----------------|----------|
| **UI** | Telas, widgets, navegação | `screens/`, `widgets/` |
| **Provider** | Gerenciamento de estado reativo | `providers/` |
| **Service** | Regras de negócio e acesso a dados | `services/` |
| **Model** | Entidades e DTOs | `models/` |

---

## 3. Tecnologias Utilizadas

### Core
| Tecnologia | Versão | Função |
|------------|--------|--------|
| Flutter | 3.41.6 | Framework UI |
| Dart | 3.11.4 | Linguagem de programação |

### Dependências Principais
| Pacote | Versão | Função |
|--------|--------|--------|
| `provider` | 6.1.2 | Gerenciamento de estado |
| `flutter_map` | 7.0.2 | Mapas interativos (OpenStreetMap) |
| `latlong2` | 0.9.1 | Cálculos de coordenadas geográficas |
| `geolocator` | 13.0.2 | GPS e localização do dispositivo |
| `http` | 1.3.0 | Requisições HTTP para APIs externas |
| `intl` | 0.20.2 | Formatação de datas e moeda |
| `uuid` | 4.5.1 | Geração de IDs únicos |
| `table_calendar` | 3.2.0 | Seleção de datas para reservas |
| `cached_network_image` | 3.4.1 | Cache de imagens |

### APIs Externas (Gratuitas)
| API | Provedor | Uso |
|-----|----------|-----|
| Nominatim | OpenStreetMap | Geocodificação (busca de endereços) |
| OSRM | Project OSRM | Cálculo de rotas e direções |
| OpenStreetMap Tiles | OpenStreetMap | Renderização de mapas |

---

## 4. Modelos de Dados

### 4.1 UserModel
```dart
{
  id: String,
  name: String,
  email: String,
  phone: String,
  role: String ('driver' | 'owner')
}
```

### 4.2 ParkingLotModel
```dart
{
  id: String,
  ownerId: String,
  name: String,
  address: String,
  lat: double,
  lng: double,
  pricePerHour: double,
  photos: List<String>,
  eventId: String? (opcional)
}
```

### 4.3 SpotModel
```dart
{
  id: String,
  lotId: String,
  name: String,
  type: String ('coberta' | 'descoberta'),
  bookedSlots: List<BookedSlot>
}
```

### 4.4 BookingModel
```dart
{
  id: String,
  userId: String,
  lotId: String,
  spotId: String,
  startTime: DateTime,
  endTime: DateTime,
  totalPrice: double,
  status: String ('confirmed' | 'cancelled' | 'completed'),
  paymentMethod: String,
  createdAt: DateTime,
  lotName: String?,
  spotName: String?
}
```

### 4.5 EventModel
```dart
{
  id: String,
  title: String,
  lat: double,
  lng: double,
  address: String,
  date: DateTime,
  description: String
}
```

---

## 5. Serviços

### 5.1 AuthService (Interface)
Define o contrato para autenticação:
- `login(email, password)` → UserModel
- `register(name, email, phone, password, role)` → UserModel
- `logout()` → void

### 5.2 DataService (Interface)
Define o contrato para operações de dados:
- CRUD de estacionamentos
- CRUD de vagas
- CRUD de reservas
- Listagem de eventos

### 5.3 GeocodingService
- **Fonte:** Nominatim (OpenStreetMap)
- **Endpoint:** `https://nominatim.openstreetmap.org/search`
- **Função:** Converte texto (rua, bairro, cidade) em coordenadas geográficas
- **Parâmetros:** `q={query}&format=json&limit=5&countrycodes=br`

### 5.4 RoutingService
- **Fonte:** OSRM (Open Source Routing Machine)
- **Endpoint:** `https://router.project-osrm.org/route/v1/driving/`
- **Função:** Calcula rotas entre dois pontos com distância e tempo estimado
- **Parâmetros:** `overview=full&geometries=geojson`

### 5.5 LocationService
- **Pacote:** `geolocator`
- **Função:** Obtém a localização GPS real do dispositivo
- **Permissões:** locationServiceEnabled, requestPermission, getCurrentPosition

---

## 6. Telas e Fluxos

### 6.1 Fluxo do Motorista
```
┌─────────────┐     ┌─────────────┐     ┌─────────────────┐
│   Login     │────▶│   Mapa      │────▶│ Detalhe do Lot  │
│ (joao@...)  │     │  + Busca    │     │  + Como Chegar  │
└─────────────┘     └──────┬──────┘     └────────┬────────┘
                           │                       │
                           ▼                       ▼
                    ┌─────────────┐       ┌──────────────┐
                    │   Eventos   │       │   Reserva    │
                    └─────────────┘       │  + Pagamento │
                                          └──────┬───────┘
                                                 │
                                                 ▼
                                          ┌──────────────┐
                                          │   Sucesso    │
                                          └──────────────┘
```

### 6.2 Fluxo do Proprietário
```
┌─────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Login     │────▶│ Meus Estacionam. │────▶│ Cadastrar/Editar│
│(maria@...)  │     │  + Vagas         │     │  Estacionamento │
└─────────────┘     └────────┬─────────┘     └─────────────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ Reservas Recebidas│
                    └──────────────────┘
```

### 6.3 Lista de Telas

| Tela | Arquivo | Perfil | Função |
|------|---------|--------|--------|
| Splash | `splash_screen.dart` | - | Tela inicial |
| Login | `login_screen.dart` | - | Autenticação |
| Cadastro | `register_screen.dart` | - | Criação de conta |
| Home Motorista | `driver_home_screen.dart` | Motorista | Navegação por abas |
| Mapa | `map_screen.dart` | Motorista | Mapa + busca + filtros |
| Detalhes | `parking_detail_screen.dart` | Motorista | Info + rota + reserva |
| Reserva | `booking_screen.dart` | Motorista | Selecionar vaga/horário |
| Pagamento | `payment_screen.dart` | Motorista | Simulação de pagamento |
| Histórico | `bookings_history_screen.dart` | Motorista | Minhas reservas |
| Eventos | `events_screen.dart` | Motorista | Eventos e filtragem |
| Home Proprietário | `owner_home_screen.dart` | Proprietário | Navegação por abas |
| Estacionamentos | `parking_lots_screen.dart` | Proprietário | Lista dos meus lots |
| Form Estacionamento | `parking_lot_form_screen.dart` | Proprietário | Cadastro/edição |
| Vagas | `spots_management_screen.dart` | Proprietário | Gerenciar vagas |
| Form Vaga | `spot_form_screen.dart` | Proprietário | Cadastro/edição de vaga |
| Reservas Recebidas | `owner_bookings_screen.dart` | Proprietário | Ver reservas |

---

## 7. Funcionalidades Implementadas

### 7.1 Core
- [x] Autenticação com roles (Motorista/Proprietário)
- [x] Cadastro de usuários
- [x] Dados mockados com seed para demonstração

### 7.2 Proprietário
- [x] Cadastrar estacionamento (nome, endereço, preço, foto)
- [x] Geocodificação de endereço para coordenadas
- [x] Cadastrar vagas (identificação, tipo coberta/descoberta)
- [x] Visualizar reservas recebidas

### 7.3 Motorista
- [x] Mapa interativo com OpenStreetMap
- [x] Busca dinâmica de regiões (rua, bairro, cidade)
- [x] Filtro de proximidade por raio (1km a 50km)
- [x] Ordenação por distância
- [x] Visualização de estacionamentos em cards
- [x] Detalhes do estacionamento
- [x] Sistema de rotas com localização real
- [x] Cálculo de distância e tempo estimado
- [x] Desenho de polylines no mapa
- [x] Seleção de data/hora para reserva
- [x] Verificação de disponibilidade de vagas
- [x] Pagamento simulado
- [x] Histórico de reservas
- [x] Sistema de eventos

### 7.4 Dados de Demonstração
- 4 estacionamentos em Belo Horizonte
- 2 eventos (Cruzeiro x Atlético-MG, Festival de Inverno BH)
- Vagas e reservas pré-cadastradas

---

## 8. APIs Externas

### 8.1 Nominatim (Geocodificação)
```
GET https://nominatim.openstreetmap.org/search
  ?q={endereco}
  &format=json
  &limit=5
  &countrycodes=br
```
**Headers obrigatórios:** `User-Agent: ParkHereApp/1.0`

### 8.2 OSRM (Roteamento)
```
GET https://router.project-osrm.org/route/v1/driving/
  {longitude_origem},{latitude_origem};
  {longitude_destino},{latitude_destino}
  ?overview=full
  &geometries=geojson
```

### 8.3 OpenStreetMap Tiles
```
https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

---

## 9. Estrutura de Pastas

```
park_here_app/
├── android/                      # Configuração Android nativa
├── ios/                          # Configuração iOS nativa
├── web/                          # Configuração Web
├── build/                        # Builds gerados
│   ├── web/                      # Build web
│   └── ParkHere_Presentacao.zip  # Pacote de distribuição
├── lib/
│   ├── main.dart                 # Ponto de entrada
│   ├── app.dart                  # Roteamento baseado em auth
│   ├── core/
│   │   ├── constants.dart        # Constantes do app
│   │   └── theme.dart            # Tema visual Material 3
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── parking_lot_model.dart
│   │   ├── spot_model.dart
│   │   ├── booking_model.dart
│   │   └── event_model.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── auth_service_mock.dart
│   │   ├── data_service.dart
│   │   ├── data_service_mock.dart
│   │   ├── geocoding_service.dart
│   │   ├── routing_service.dart
│   │   └── location_service.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── app_provider.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── splash_screen.dart
│   │   ├── driver/
│   │   │   ├── driver_home_screen.dart
│   │   │   ├── map_screen.dart
│   │   │   ├── parking_detail_screen.dart
│   │   │   ├── booking_screen.dart
│   │   │   ├── payment_screen.dart
│   │   │   ├── bookings_history_screen.dart
│   │   │   └── events_screen.dart
│   │   └── owner/
│   │       ├── owner_home_screen.dart
│   │       ├── parking_lots_screen.dart
│   │       ├── parking_lot_form_screen.dart
│   │       ├── spots_management_screen.dart
│   │       ├── spot_form_screen.dart
│   │       └── owner_bookings_screen.dart
│   └── widgets/
├── pubspec.yaml                  # Dependências
├── README.md                     # Documentação geral
├── INSTRUCOES.md                 # Instruções de uso
├── PLANO_APK.md                  # Plano para gerar APK
├── PUBLICAR.md                   # Opções de publicação
├── RODAR_APP.md                  # Como executar
├── DOCUMENTACAO_TECNICA.md       # Este arquivo
└── analysis_options.yaml         # Regras de lint
```

---

## 10. Como Executar

### 10.1 Web (Chrome)
```bash
flutter run -d chrome
```

### 10.2 APK Android
```bash
flutter build apk --release
```
APK gerado em: `build/app/outputs/flutter-apk/app-release.apk`

### 10.3 Servidor Local (produção)
```bash
flutter build web
cd build/web
python -m http.server 8080
```

---

## 11. Build e Distribuição

### 11.1 Build Web
```bash
flutter build web
```

### 11.2 Build APK
```bash
flutter build apk --release
```

### 11.3 Build AAB (Google Play)
```bash
flutter build appbundle --release
```

### 11.4 Hospedagem Web
- **Netlify Drop:** https://app.netlify.com/drop
- **GitHub Pages:** Configurar em Settings → Pages
- **Vercel:** `vercel --prod`

---

## 12. Screenshots e Fluxo de Uso

### Telas Principais

| Tela | Descrição |
|------|-----------|
| **Login** | Tela de entrada com cards de demonstração (Motorista/Proprietário) |
| **Mapa** | Mapa OpenStreetMap com busca dinâmica, filtros de raio e cards inferiores |
| **Busca** | Ao digitar "Savassi", resultados aparecem em tempo real |
| **Rota** | Linha azul traçada no mapa do ponto atual até o estacionamento |
| **Reserva** | Seleção de data, hora e vaga com cálculo de preço |
| **Pagamento** | Formulário simulado de cartão com confirmação |
| **Eventos** | Lista de eventos com filtragem de estacionamentos próximos |
| **Proprietário** | Dashboard com estacionamentos, vagas e reservas |

---

## 🔮 Roadmap Futuro

- [ ] Migração para Firebase (Auth + Firestore)
- [ ] Upload de fotos reais (Firebase Storage)
- [ ] Notificações push (Firebase Cloud Messaging)
- [ ] Sistema de avaliações e comentários
- [ ] Pagamento real (Stripe/Mercado Pago)
- [ ] Painel administrativo web
- [ ] Modo offline com cache

---

**Desenvolvido para fins acadêmicos.**
