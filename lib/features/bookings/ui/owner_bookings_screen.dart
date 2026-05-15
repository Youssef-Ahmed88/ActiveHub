import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/networking/api_service.dart';
import 'package:get_it/get_it.dart';
 
class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});
 
  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}
 
class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  late Future<List<dynamic>> _bookingsFuture;
 
  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchBookings();
  }
 
  Future<List<dynamic>> _fetchBookings() async {
    final apiService = GetIt.instance<ApiService>();
    // ✅ تم التعديل: getOwnerBookings بدل getMyBookings
    final response = await apiService.getOwnerBookings();
    // الـ API بيرجع Map فيها data array
    if (response is Map && response['data'] != null) {
      return response['data'] as List<dynamic>;
    }
    if (response is List) {
      return response;
    }
    return [];
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stadium Bookings'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
 
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bookingsFuture = _fetchBookings();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
 
          final bookings = snapshot.data ?? [];
 
          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No bookings found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
 
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _bookingsFuture = _fetchBookings();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index] as Map<String, dynamic>;
                return _BookingCard(booking: booking);
              },
            ),
          );
        },
      ),
    );
  }
}
 
class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
 
  const _BookingCard({required this.booking});
 
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final status = booking['status'] ?? 'unknown';
    final courtName = booking['court']?['name'] ?? 'Unknown Court';
    final userName = booking['user']?['name'] ?? 'Unknown User';
    final date = booking['booking_date'] ?? booking['date'] ?? '-';
    final startTime = booking['start_time'] ?? '-';
    final endTime = booking['end_time'] ?? '-';
    final totalPrice = booking['total_price'] ?? booking['price'] ?? '-';
 
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  courtName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor(status)),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _infoRow(Icons.person_outline, 'User', userName),
            const SizedBox(height: 6),
            _infoRow(Icons.calendar_today_outlined, 'Date', date),
            const SizedBox(height: 6),
            _infoRow(Icons.access_time, 'Time', '$startTime → $endTime'),
            const SizedBox(height: 6),
            _infoRow(Icons.attach_money, 'Price', '$totalPrice EGP'),
          ],
        ),
      ),
    );
  }
 
  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}