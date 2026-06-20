class TimeSlotModel {
  final int id;
  final int courtId;
  final String slotDate;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  TimeSlotModel({
    required this.id,
    required this.courtId,
    required this.slotDate,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'],
      courtId: json['court_id'],
      slotDate: json['slot_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      // تحويل القيمة 0/1 إلى bool
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
    );
  }

  // اختياري: تحويل إلى Map إذا احتجت إرسال أي بيانات
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'court_id': courtId,
      'slot_date': slotDate,
      'start_time': startTime,
      'end_time': endTime,
      'is_available': isAvailable ? 1 : 0,
    };
  }
}
