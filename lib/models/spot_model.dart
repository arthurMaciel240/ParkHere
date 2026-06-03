class SpotModel {
  final String id;
  final String lotId;
  final String name;
  final String type; // 'coberta' ou 'descoberta'
  final List<BookedSlot> bookedSlots;

  SpotModel({
    required this.id,
    required this.lotId,
    required this.name,
    this.type = 'descoberta',
    this.bookedSlots = const [],
  });

  bool isAvailable(DateTime start, DateTime end) {
    for (var slot in bookedSlots) {
      if (start.isBefore(slot.end) && end.isAfter(slot.start)) {
        return false;
      }
    }
    return true;
  }

  factory SpotModel.fromMap(Map<String, dynamic> map) {
    return SpotModel(
      id: map['id'] ?? '',
      lotId: map['lotId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'descoberta',
      bookedSlots: (map['bookedSlots'] as List<dynamic>? ?? [])
          .map((e) => BookedSlot.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lotId': lotId,
      'name': name,
      'type': type,
      'bookedSlots': bookedSlots.map((e) => e.toMap()).toList(),
    };
  }
}

class BookedSlot {
  final DateTime start;
  final DateTime end;

  BookedSlot({required this.start, required this.end});

  factory BookedSlot.fromMap(Map<String, dynamic> map) {
    return BookedSlot(
      start: DateTime.parse(map['start']),
      end: DateTime.parse(map['end']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}
