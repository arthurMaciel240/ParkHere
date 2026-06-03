import 'package:uuid/uuid.dart';

import '../models/parking_lot_model.dart';
import '../models/spot_model.dart';
import '../models/booking_model.dart';
import '../models/event_model.dart';
import 'data_service.dart';

class DataServiceMock implements DataService {
  final _uuid = const Uuid();

  final _lots = <String, ParkingLotModel>{};
  final _spots = <String, SpotModel>{};
  final _bookings = <String, BookingModel>{};
  final _events = <String, EventModel>{};

  DataServiceMock() {
    _seedData();
  }

  void _seedData() {
    // Events
    final eventMineirao = EventModel(
      id: 'evt-1',
      title: 'Cruzeiro x Atlético-MG',
      lat: -19.8659,
      lng: -43.9711,
      address: 'Mineirão, Belo Horizonte',
      date: DateTime.now().add(const Duration(days: 3)),
      description: 'O clássico mineiro que vai parar a cidade!',
    );
    final eventLiberdade = EventModel(
      id: 'evt-2',
      title: 'Festival de Inverno BH',
      lat: -19.8516,
      lng: -43.9530,
      address: 'Praça da Liberdade, Belo Horizonte',
      date: DateTime.now().add(const Duration(days: 10)),
      description: 'Música, gastronomia e cultura no coração de BH.',
    );
    _events[eventMineirao.id] = eventMineirao;
    _events[eventLiberdade.id] = eventLiberdade;

    // Parking Lots
    final lotMineirao = ParkingLotModel(
      id: 'lot-1',
      ownerId: 'owner-1',
      name: 'Estacionamento Gigante da Pampulha',
      address: 'Av. Antônio Abrahão Caram, 1001 - Pampulha',
      lat: -19.8665,
      lng: -43.9705,
      pricePerHour: 25.0,
      photos: const ['https://picsum.photos/seed/pampulha/400/300'],
      eventId: eventMineirao.id,
    );
    final lotCentro = ParkingLotModel(
      id: 'lot-2',
      ownerId: 'owner-1',
      name: 'Park Centro BH',
      address: 'Rua dos Carijós, 123 - Centro',
      lat: -19.9170,
      lng: -43.9350,
      pricePerHour: 15.0,
      photos: const ['https://picsum.photos/seed/centro/400/300'],
    );
    final lotSavassi = ParkingLotModel(
      id: 'lot-3',
      ownerId: 'owner-1',
      name: 'Savassi Park',
      address: 'Rua Cláudio Manoel, 500 - Savassi',
      lat: -19.9355,
      lng: -43.9345,
      pricePerHour: 18.0,
      photos: const ['https://picsum.photos/seed/savassi/400/300'],
    );
    final lotLiberdade = ParkingLotModel(
      id: 'lot-4',
      ownerId: 'owner-1',
      name: 'Estacionamento Liberdade',
      address: 'Rua Gonçalves Dias, 800 - Funcionários',
      lat: -19.8520,
      lng: -43.9525,
      pricePerHour: 20.0,
      photos: const ['https://picsum.photos/seed/liberdade/400/300'],
      eventId: eventLiberdade.id,
    );
    _lots[lotMineirao.id] = lotMineirao;
    _lots[lotCentro.id] = lotCentro;
    _lots[lotSavassi.id] = lotSavassi;
    _lots[lotLiberdade.id] = lotLiberdade;

    // Spots
    _addSpots(lotMineirao.id, 8);
    _addSpots(lotCentro.id, 6);
    _addSpots(lotSavassi.id, 5);
    _addSpots(lotLiberdade.id, 6);

    // Pre-book one spot at Centro for demo
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final spotCentro = _spots.values.firstWhere((s) => s.lotId == lotCentro.id);
    _bookings['bk-1'] = BookingModel(
      id: 'bk-1',
      userId: 'driver-1',
      lotId: lotCentro.id,
      spotId: spotCentro.id,
      startTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9),
      endTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 12),
      totalPrice: 45.0,
      createdAt: DateTime.now(),
      lotName: lotCentro.name,
      spotName: spotCentro.name,
    );
    _updateSpotBooking(spotCentro.id, _bookings['bk-1']!.startTime, _bookings['bk-1']!.endTime);
  }

  void _addSpots(String lotId, int count) {
    for (int i = 1; i <= count; i++) {
      final id = _uuid.v4();
      _spots[id] = SpotModel(
        id: id,
        lotId: lotId,
        name: 'Vaga ${String.fromCharCode(64 + ((i - 1) ~/ 4) + 1)}${((i - 1) % 4) + 1}',
        type: i % 2 == 0 ? 'coberta' : 'descoberta',
        bookedSlots: const [],
      );
    }
  }

  void _updateSpotBooking(String spotId, DateTime start, DateTime end) {
    final spot = _spots[spotId];
    if (spot != null) {
      final updatedSlots = [...spot.bookedSlots, BookedSlot(start: start, end: end)];
      _spots[spotId] = SpotModel(
        id: spot.id,
        lotId: spot.lotId,
        name: spot.name,
        type: spot.type,
        bookedSlots: updatedSlots,
      );
    }
  }

  @override
  Future<List<ParkingLotModel>> getParkingLots({String? ownerId, String? eventId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var result = _lots.values.toList();
    if (ownerId != null) {
      result = result.where((l) => l.ownerId == ownerId).toList();
    }
    if (eventId != null) {
      result = result.where((l) => l.eventId == eventId).toList();
    }
    return result;
  }

  @override
  Future<ParkingLotModel?> getParkingLot(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _lots[id];
  }

  @override
  Future<void> saveParkingLot(ParkingLotModel lot) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _lots[lot.id] = lot;
  }

  @override
  Future<void> deleteParkingLot(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _lots.remove(id);
    _spots.removeWhere((_, s) => s.lotId == id);
  }

  @override
  Future<List<SpotModel>> getSpots(String lotId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _spots.values.where((s) => s.lotId == lotId).toList();
  }

  @override
  Future<void> saveSpot(SpotModel spot) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _spots[spot.id] = spot;
  }

  @override
  Future<void> deleteSpot(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _spots.remove(id);
  }

  @override
  Future<List<BookingModel>> getBookings({String? userId, String? lotId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var result = _bookings.values.toList();
    if (userId != null) {
      result = result.where((b) => b.userId == userId).toList();
    }
    if (lotId != null) {
      result = result.where((b) => b.lotId == lotId).toList();
    }
    return result;
  }

  @override
  Future<void> saveBooking(BookingModel booking) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _bookings[booking.id] = booking;
    _updateSpotBooking(booking.spotId, booking.startTime, booking.endTime);
  }

  @override
  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _events.values.toList();
  }

  @override
  Future<EventModel?> getEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _events[id];
  }
}
