class EventModel {
  final String id;
  final String title;
  final double lat;
  final double lng;
  final String address;
  final DateTime date;
  final String description;

  EventModel({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
    required this.address,
    required this.date,
    required this.description,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
      address: map['address'] ?? '',
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'lat': lat,
      'lng': lng,
      'address': address,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
