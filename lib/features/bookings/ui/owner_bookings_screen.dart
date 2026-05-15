import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/networking/api_service.dart';
import 'package:get_it/get_it.dart';
<<<<<<< HEAD
 
class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});
 
  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}
 
class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  late Future<List<dynamic>> _bookingsFuture;
 
=======

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  late Future<List<dynamic>> _bookingsFuture;

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchBookings();
  }
<<<<<<< HEAD
 
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
 
=======

  Future<List<dynamic>> _fetchBookings() async {
    final apiService = GetIt.instance<ApiService>();
    final response = await apiService.getMyBookings();
    return response as List<dynamic>;
  }

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
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
<<<<<<< HEAD
 
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
 
=======
          if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          }

          final bookings = snapshot.data ?? [];

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
<<<<<<< HEAD
                  Icon(Icons.calendar_today_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No bookings found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
=======
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No bookings yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  ),
                ],
              ),
            );
          }
<<<<<<< HEAD
 
=======

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _bookingsFuture = _fetchBookings();
              });
            },
            child: ListView.builder(
<<<<<<< HEAD
              padding: const EdgeInsets.all(12),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index] as Map<String, dynamic>;
=======
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                return _BookingCard(booking: booking);
              },
            ),
          );
        },
      ),
    );
  }
}
<<<<<<< HEAD
 
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
=======

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
<<<<<<< HEAD
                  courtName,
=======
                  booking['user']?['name'] ?? 'Unknown User',
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
<<<<<<< HEAD
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
=======
                _StatusChip(status: booking['status'] ?? 'pending'),
              ],
            ),
            const Divider(height: 16),
            _infoRow(Icons.sports_soccer, booking['court']?['name'] ?? '-'),
            const SizedBox(height: 6),
            _infoRow(Icons.calendar_today, booking['date'] ?? '-'),
            const SizedBox(height: 6),
            _infoRow(
              Icons.access_time,
              '${booking['start_time'] ?? '-'} → ${booking['end_time'] ?? '-'}',
            ),
            const SizedBox(height: 6),
            _infoRow(
              Icons.attach_money,
              '${booking['total_price'] ?? '-'} EGP',
            ),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
 
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
=======

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
