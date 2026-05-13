import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/features/payment/data/payment_method.dart';
import '../logic/payment_cubit.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('💳 Payment args: $args');

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Methods")),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is BookingConfirmed) {
            _showPaymentSuccess(context);
          } else if (state is PaymentMethodSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.blue),
            );
          } else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ استخرج الـ methods من PaymentLoaded أو PaymentMethodSuccess
          List<PaymentMethod>? methods;
          if (state is PaymentLoaded) {
            methods = state.methods;
          } else if (state is PaymentMethodSuccess) {
            methods = state.methods;
          }

          if (methods != null) {
            if (methods.isEmpty) {
              return const Center(child: Text("No payment methods found"));
            }
            return ListView.builder(
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final method = methods![index];

                String displayDetails = method.details;
                if (method.type.toLowerCase() == "visa" ||
                    method.type.toLowerCase() == "mastercard") {
                  if (displayDetails.length > 4) {
                    displayDetails =
                        "**** ${displayDetails.substring(displayDetails.length - 4)}";
                  }
                }

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: const Icon(Icons.payment, color: Colors.blue),
                    title: Text("${method.type} - $displayDetails"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<PaymentCubit>().removeMethod(method.id);
                      },
                    ),
onTap: () async {
  int? bookingId = args?['booking_id'];
  double? totalPrice = args?['totalPrice'];

  // لو مفيش booking_id، جيب آخر booking
  if (bookingId == null) {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/my-bookings');
      final List data = response.data is List ? response.data : response.data['data'];
      if (data.isNotEmpty) {
        bookingId = data.last['id'];
        totalPrice = double.parse(data.last['total_price'].toString());
      }
    } catch (e) {
      debugPrint('Error getting last booking: $e');
    }
  }

  context.read<PaymentCubit>().confirmBooking({
    'booking_id': bookingId,
    'totalPrice': totalPrice ?? 0,
    'paymentMethod': method.type,
  });
},
                  ),
                );
              },
            );
          }

          if (state is PaymentFailure) {
            return Center(child: Text("Error: ${state.error}"));
          }

          return const Center(child: Text("No payment methods found"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPaymentMethodDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPaymentSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your deposit has been paid successfully.',
              style: TextStyle(
                fontSize: 13,
                color: ColorsManager.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.homeScreen,
                (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryBlue,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentMethodDialog(BuildContext context) {
    final cubit = context.read<PaymentCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final TextEditingController detailsController = TextEditingController();
    final TextEditingController holderController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();

    String selectedType = "Visa";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setState) {
            return AlertDialog(
              backgroundColor: ColorsManager.cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: const Text("Add Payment Method",
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedType,
                      dropdownColor: ColorsManager.cardBg,
                      items: const [
                        DropdownMenuItem(value: "Visa", child: Text("Visa")),
                        DropdownMenuItem(
                            value: "Wallet", child: Text("Wallet")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                    TextField(
                      controller: detailsController,
                      decoration: const InputDecoration(
                        labelText: "Details (Card Number / Wallet ID)",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextField(
                      controller: holderController,
                      decoration: const InputDecoration(
                        labelText: "Holder Name (optional)",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextField(
                      controller: expiryController,
                      decoration: const InputDecoration(
                        labelText: "Expiry Date (MM/YY)",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final method = PaymentMethod(
                      id: DateTime.now().toString(),
                      type: selectedType,
                      details: detailsController.text.trim(),
                      holderName: holderController.text.isEmpty
                          ? null
                          : holderController.text.trim(),
                      expiryDate: expiryController.text.isEmpty
                          ? null
                          : expiryController.text.trim(),
                    );

                    cubit.addMethod(method);
                    Navigator.pop(dialogContext);
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                          content: Text("Payment method added successfully")),
                    );
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}