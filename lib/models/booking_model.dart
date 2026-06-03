class BookingModel {
  final String id;
  final String userId;
  final String lotId;
  final String spotId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status; // 'confirmed', 'cancelled', 'completed'
  final String paymentMethod;
  final DateTime createdAt;
  final String? lotName;
  final String? spotName;

  BookingModel({
    required this.id,
    required this.userId,
    required this.lotId,
    required this.spotId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    this.status = 'confirmed',
    this.paymentMethod = 'simulated',
    required this.createdAt,
    this.lotName,
    this.spotName,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      lotId: map['lotId'] ?? '',
      spotId: map['spotId'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: map['status'] ?? 'confirmed',
      paymentMethod: map['paymentMethod'] ?? 'simulated',
      createdAt: DateTime.parse(map['createdAt']),
      lotName: map['lotName'],
      spotName: map['spotName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'lotId': lotId,
      'spotId': spotId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'lotName': lotName,
      'spotName': spotName,
    };
  }
}
