class ParkingLotModel {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final double pricePerHour;
  final List<String> photos;
  final String? eventId;

  ParkingLotModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.pricePerHour,
    this.photos = const [],
    this.eventId,
  });

  factory ParkingLotModel.fromMap(Map<String, dynamic> map) {
    return ParkingLotModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
      pricePerHour: (map['pricePerHour'] ?? 0).toDouble(),
      photos: List<String>.from(map['photos'] ?? []),
      eventId: map['eventId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'pricePerHour': pricePerHour,
      'photos': photos,
      'eventId': eventId,
    };
  }
}
