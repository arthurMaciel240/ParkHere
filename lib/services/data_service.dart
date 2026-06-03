import '../models/parking_lot_model.dart';
import '../models/spot_model.dart';
import '../models/booking_model.dart';
import '../models/event_model.dart';

abstract class DataService {
  // Parking Lots
  Future<List<ParkingLotModel>> getParkingLots({String? ownerId, String? eventId});
  Future<ParkingLotModel?> getParkingLot(String id);
  Future<void> saveParkingLot(ParkingLotModel lot);
  Future<void> deleteParkingLot(String id);

  // Spots
  Future<List<SpotModel>> getSpots(String lotId);
  Future<void> saveSpot(SpotModel spot);
  Future<void> deleteSpot(String id);

  // Bookings
  Future<List<BookingModel>> getBookings({String? userId, String? lotId});
  Future<void> saveBooking(BookingModel booking);

  // Events
  Future<List<EventModel>> getEvents();
  Future<EventModel?> getEvent(String id);
}
