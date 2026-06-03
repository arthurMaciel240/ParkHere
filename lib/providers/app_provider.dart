import 'package:flutter/foundation.dart';

import '../models/parking_lot_model.dart';
import '../models/spot_model.dart';
import '../models/booking_model.dart';
import '../models/event_model.dart';
import '../services/data_service.dart';

class AppProvider extends ChangeNotifier {
  final DataService _dataService;

  AppProvider(this._dataService);

  List<ParkingLotModel> _parkingLots = [];
  List<SpotModel> _spots = [];
  List<BookingModel> _bookings = [];
  List<EventModel> _events = [];
  ParkingLotModel? _selectedLot;
  bool _loading = false;
  String? _error;

  List<ParkingLotModel> get parkingLots => _parkingLots;
  List<SpotModel> get spots => _spots;
  List<BookingModel> get bookings => _bookings;
  List<EventModel> get events => _events;
  ParkingLotModel? get selectedLot => _selectedLot;
  bool get loading => _loading;
  String? get error => _error;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Parking Lots
  Future<void> loadParkingLots({String? ownerId, String? eventId}) async {
    _setLoading(true);
    try {
      _parkingLots = await _dataService.getParkingLots(ownerId: ownerId, eventId: eventId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveParkingLot(ParkingLotModel lot) async {
    _setLoading(true);
    try {
      await _dataService.saveParkingLot(lot);
      await loadParkingLots(ownerId: lot.ownerId);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  Future<void> deleteParkingLot(String id, String ownerId) async {
    _setLoading(true);
    try {
      await _dataService.deleteParkingLot(id);
      await loadParkingLots(ownerId: ownerId);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  void selectLot(ParkingLotModel lot) {
    _selectedLot = lot;
    notifyListeners();
  }

  // Spots
  Future<void> loadSpots(String lotId) async {
    _setLoading(true);
    try {
      _spots = await _dataService.getSpots(lotId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveSpot(SpotModel spot, String ownerId) async {
    _setLoading(true);
    try {
      await _dataService.saveSpot(spot);
      await loadSpots(spot.lotId);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  Future<void> deleteSpot(String id, String lotId, String ownerId) async {
    _setLoading(true);
    try {
      await _dataService.deleteSpot(id);
      await loadSpots(lotId);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  // Bookings
  Future<void> loadBookings({String? userId, String? lotId}) async {
    _setLoading(true);
    try {
      _bookings = await _dataService.getBookings(userId: userId, lotId: lotId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveBooking(BookingModel booking) async {
    _setLoading(true);
    try {
      await _dataService.saveBooking(booking);
      if (booking.userId.isNotEmpty) {
        await loadBookings(userId: booking.userId);
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  // Events
  Future<List<BookingModel>> fetchBookings({String? userId, String? lotId}) async {
    return _dataService.getBookings(userId: userId, lotId: lotId);
  }

  Future<void> loadEvents() async {
    _setLoading(true);
    try {
      _events = await _dataService.getEvents();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }
}
