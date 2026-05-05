import 'payment_method.dart';
// لو هتستخدم Firestore
// import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentRepository {
  // ✅ قائمة مبدئية بوسائل الدفع (Dummy Data) من غير Cash
  final List<PaymentMethod> _methods = [
    PaymentMethod(id: "1", type: "Visa", details: "**** 1234"),
    PaymentMethod(id: "2", type: "Wallet", details: "01066845465"),
  ];

  /// جلب كل وسائل الدفع
  Future<List<PaymentMethod>> getMethods() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate delay
    return List<PaymentMethod>.from(_methods); // نسخة جديدة علشان تبقى آمنة
  }

  /// إضافة وسيلة دفع جديدة
  Future<void> addMethod(PaymentMethod method) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate delay

    // ✅ منع إضافة Cash
    if (method.type.toLowerCase() == "cash") {
      throw Exception("Cash is not allowed");
    }

    _methods.add(method);

    // ✅ لو عايز تربط مع Firestore
    // await FirebaseFirestore.instance.collection('payment_methods').add(method.toMap());
  }

  /// حذف وسيلة دفع
  Future<void> removeMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
    _methods.removeWhere((m) => m.id == id);

    // ✅ لو عايز تربط مع Firestore
    // await FirebaseFirestore.instance.collection('payment_methods').doc(id).delete();
  }

  /// تسجيل الحجز بعد الدفع الناجح
  Future<void> confirmBooking(Map<String, dynamic> bookingData) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate delay

    // ✅ لو عايز تربط مع Firestore
    // await FirebaseFirestore.instance.collection('bookings').add(bookingData);
  }
}
