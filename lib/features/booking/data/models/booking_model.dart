class BookingModel {
  final int id;
  final int courtId;
  final int timeSlotId;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final String status;           // ✅ أضفنا هذا السطر (الحقل)
  final CourtModel? court;

  BookingModel({
    required this.id,
    required this.courtId,
    required this.timeSlotId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,        // ✅ أضفنا هذا السطر
    this.court,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      courtId: json['court_id'],
      timeSlotId: json['time_slot_id'] ?? 0,
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['status'] ?? 'pending',   // ✅ أضفنا هذا السطر
      court: json['court'] != null ? CourtModel.fromJson(json['court']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'court_id': courtId,
      'time_slot_id': timeSlotId,
      'start_time': startTime,
      'end_time': endTime,
      'total_price': totalPrice,
      'status': status,          // ✅ أضفنا هذا السطر
      'court': court?.toJson(),
    };
  }
}

class CourtModel {
  final int id;
  final String name;
  final String address;
  final String pricePerHour;

  CourtModel({
    required this.id,
    required this.name,
    required this.address,
    required this.pricePerHour,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      id: json['id'],
      name: json['name'],
      address: json['address'] ?? '',
      pricePerHour: json['price_per_hour'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'price_per_hour': pricePerHour,
    };
  }
}