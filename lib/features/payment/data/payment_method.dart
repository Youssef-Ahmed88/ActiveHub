class PaymentMethod {
  final String id;        // معرف فريد لكل وسيلة دفع
  final String type;      // نوع الوسيلة (Visa, MasterCard, Cash, PayPal, Wallet)
  final String details;   // تفاصيل إضافية (مثلاً آخر 4 أرقام من البطاقة أو وصف)
  final String? holderName; // اسم صاحب البطاقة أو الحساب (اختياري)
  final String? expiryDate; // تاريخ انتهاء البطاقة (اختياري)

  PaymentMethod({
    required this.id,
    required this.type,
    required this.details,
    this.holderName,
    this.expiryDate,
  });

  /// تحويل من Map (Firestore أو API) لـ Object
  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      details: map['details'] ?? '',
      holderName: map['holderName'],
      expiryDate: map['expiryDate'],
    );
  }

  /// تحويل من Object لـ Map (علشان نخزن في Firestore أو API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'details': details,
      'holderName': holderName,
      'expiryDate': expiryDate,
    };
  }
}
