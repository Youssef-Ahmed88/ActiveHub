import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';
<<<<<<< HEAD
import 'package:google_maps_flutter/google_maps_flutter.dart';
=======
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> venues = [];
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> payments = [];
  List<Map<String, dynamic>> owners = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadVenues(),
      _loadBookings(),
      _loadPayments(),
      _loadOwners(),
    ]);
    setState(() => isLoading = false);
  }

  Future<void> _loadVenues() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/courts');
      final List data = response.data['data'];
      setState(() {
<<<<<<< HEAD
        venues = data
            .map(
              (v) => {
                'id': v['id'],
                'name': v['name'],
                'sport': v['sport']?['name'] ?? '',
                'price': double.parse(v['price_per_hour'].toString()).toInt(),
                'available': v['is_available'] == 1,
                'has_owner': v['owner_id'] != null,
                'latitude': v['latitude'],
                'longitude': v['longitude'],
              },
            )
            .toList();
=======
        venues = data.map((v) => {
          'id': v['id'],
          'name': v['name'],
          'sport': v['sport']?['name'] ?? '',
          'price': double.parse(v['price_per_hour'].toString()).toInt(),
          'available': v['is_available'] == 1,
          'has_owner': v['owner_id'] != null, // ✅ إضافة
        }).toList();
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      });
    } catch (e) {
      debugPrint('Error loading venues: $e');
    }
  }

  Future<void> _loadBookings() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/my-bookings');
<<<<<<< HEAD
      final List data = response.data is List
          ? response.data
          : response.data['data'];
      setState(() {
        bookings = data
            .map(
              (b) => {
                'id': b['id'],
                'user': b['user_id'].toString(),
                'venue': b['court']?['name'] ?? '',
                'date': b['start_time'].toString().split(' ')[0],
                'time': b['start_time'].toString().split(' ')[1],
                'status': b['status'],
              },
            )
            .toList();
=======
      final List data = response.data is List ? response.data : response.data['data'];
      setState(() {
        bookings = data.map((b) => {
          'id': b['id'],
          'user': b['user_id'].toString(),
          'venue': b['court']?['name'] ?? '',
          'date': b['start_time'].toString().split(' ')[0],
          'time': b['start_time'].toString().split(' ')[1],
          'status': b['status'],
        }).toList();
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      });
    } catch (e) {
      debugPrint('Error loading bookings: $e');
    }
  }

  Future<void> _loadPayments() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/payments');
      final List data = response.data['data'];
      setState(() {
<<<<<<< HEAD
        payments = data
            .map(
              (p) => {
                'id': p['id'],
                'user': p['booking']?['user_id'].toString() ?? '',
                'amount': double.parse(p['amount'].toString()).toInt(),
                'method': p['payment_method'],
                'status': 'Paid',
              },
            )
            .toList();
=======
        payments = data.map((p) => {
          'id': p['id'],
          'user': p['booking']?['user_id'].toString() ?? '',
          'amount': double.parse(p['amount'].toString()).toInt(),
          'method': p['payment_method'],
          'status': 'Paid',
        }).toList();
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      });
    } catch (e) {
      debugPrint('Error loading payments: $e');
    }
  }

  Future<void> _loadOwners() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/users?role=owner');
      final List data = response.data['data'] ?? response.data;
      setState(() {
<<<<<<< HEAD
        owners = data
            .map(
              (u) => {
                'id': u['id'],
                'name': u['full_name'] ?? u['name'] ?? 'Unknown',
                'email': u['email'],
              },
            )
            .toList();
=======
        owners = data.map((u) => {
          'id': u['id'],
          'name': u['full_name'] ?? u['name'] ?? 'Unknown',
          'email': u['email'],
        }).toList();
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      });
    } catch (e) {
      debugPrint('Error loading owners: $e');
      setState(() => owners = []);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.cardBg,
<<<<<<< HEAD
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
=======
        title: const Text('Admin Panel',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
<<<<<<< HEAD
              context,
              Routes.loginScreen,
              (route) => false,
            ),
=======
                context, Routes.loginScreen, (route) => false),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ColorsManager.primaryBlue,
          labelColor: ColorsManager.primaryBlue,
          unselectedLabelColor: ColorsManager.mutedText,
          tabs: const [
            Tab(icon: Icon(Icons.stadium_outlined), text: 'Venues'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Bookings'),
            Tab(icon: Icon(Icons.payment), text: 'Payments'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildVenuesTab(),
                _buildBookingsTab(),
                _buildPaymentsTab(),
              ],
            ),
    );
  }

  Widget _buildVenuesTab() {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManager.primaryBlue,
        onPressed: () => _showAddVenueDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: venues.isEmpty
<<<<<<< HEAD
          ? const Center(
              child: Text(
                'No venues found',
                style: TextStyle(color: Colors.white70),
              ),
            )
=======
          ? const Center(child: Text('No venues found', style: TextStyle(color: Colors.white70)))
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                return _buildVenueCard(venue, index);
              },
            ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderColor, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ColorsManager.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
<<<<<<< HEAD
            child: Icon(
              _getSportIcon(venue['sport']),
              color: ColorsManager.primaryBlue,
            ),
=======
            child: Icon(_getSportIcon(venue['sport']),
                color: ColorsManager.primaryBlue),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  venue['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  venue['sport'],
                  style: const TextStyle(
                    color: ColorsManager.mutedText,
                    fontSize: 13,
                  ),
                ),
=======
                Text(venue['name'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(venue['sport'],
                    style: const TextStyle(
                        color: ColorsManager.mutedText, fontSize: 13)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
<<<<<<< HEAD
              Text(
                'EGP ${venue['price']}/hr',
                style: const TextStyle(color: Colors.green, fontSize: 13),
              ),
=======
              Text('EGP ${venue['price']}/hr',
                  style: const TextStyle(color: Colors.green, fontSize: 13)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: venue['available']
                      ? Colors.green.withValues(alpha: 0.15)
                      : Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  venue['available'] ? 'Available' : 'Full',
                  style: TextStyle(
<<<<<<< HEAD
                    color: venue['available'] ? Colors.green : Colors.red,
                    fontSize: 11,
                  ),
=======
                      color: venue['available'] ? Colors.green : Colors.red,
                      fontSize: 11),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: ColorsManager.mutedText),
            color: ColorsManager.cardBg,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'edit',
<<<<<<< HEAD
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text('Edit', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.white)),
                  ],
                ),
=======
                child: Row(children: [
                  Icon(Icons.edit, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Text('Edit', style: TextStyle(color: Colors.white)),
                ]),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.white)),
                ]),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              ),
            ],
            onSelected: (value) async {
              if (value == 'delete') {
                try {
                  final dio = getIt<Dio>();
                  await dio.delete('/courts/${venues[index]['id']}');
                  await _loadVenues();
                } catch (e) {
                  debugPrint('Error deleting venue: $e');
                }
              } else if (value == 'edit') {
<<<<<<< HEAD
                await Future.delayed(const Duration(milliseconds: 200));
                if (mounted) _showEditVenueDialog(index);
=======
                _showEditVenueDialog(index);
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return bookings.isEmpty
<<<<<<< HEAD
        ? const Center(
            child: Text(
              'No bookings found',
              style: TextStyle(color: Colors.white70),
            ),
          )
=======
        ? const Center(child: Text('No bookings found', style: TextStyle(color: Colors.white70)))
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorsManager.cardBg,
                  borderRadius: BorderRadius.circular(16),
<<<<<<< HEAD
                  border: Border.all(
                    color: ColorsManager.borderColor,
                    width: 0.5,
                  ),
=======
                  border: Border.all(color: ColorsManager.borderColor, width: 0.5),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
<<<<<<< HEAD
                        Text(
                          'User #${booking['user']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
=======
                        Text('User #${booking['user']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                        _statusBadge(booking['status']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _infoRow(Icons.stadium_outlined, booking['venue']),
                    const SizedBox(height: 4),
                    _infoRow(Icons.calendar_today, booking['date']),
                    const SizedBox(height: 4),
                    _infoRow(Icons.access_time, booking['time']),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildPaymentsTab() {
    final total = payments.fold(0, (sum, p) => sum + (p['amount'] as int));
<<<<<<< HEAD
=======

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorsManager.primaryBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  Text(
                    'Total Collected',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
=======
                  Text('Total Collected',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  SizedBox(height: 4),
                ],
              ),
              Text(
                'EGP $total',
                style: const TextStyle(
<<<<<<< HEAD
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
=======
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              ),
            ],
          ),
        ),
        Expanded(
          child: payments.isEmpty
<<<<<<< HEAD
              ? const Center(
                  child: Text(
                    'No payments found',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
=======
              ? const Center(child: Text('No payments found', style: TextStyle(color: Colors.white70)))
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorsManager.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
<<<<<<< HEAD
                          color: ColorsManager.borderColor,
                          width: 0.5,
                        ),
=======
                            color: ColorsManager.borderColor, width: 0.5),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
<<<<<<< HEAD
                              color: ColorsManager.primaryBlue.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.payment,
                              color: ColorsManager.primaryBlue,
                            ),
=======
                              color: ColorsManager.primaryBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.payment,
                                color: ColorsManager.primaryBlue),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
<<<<<<< HEAD
                                Text(
                                  'User #${payment['user']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  payment['method'],
                                  style: const TextStyle(
                                    color: ColorsManager.mutedText,
                                    fontSize: 12,
                                  ),
                                ),
=======
                                Text('User #${payment['user']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                Text(payment['method'],
                                    style: const TextStyle(
                                        color: ColorsManager.mutedText,
                                        fontSize: 12)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
<<<<<<< HEAD
                              Text(
                                'EGP ${payment['amount']}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
=======
                              Text('EGP ${payment['amount']}',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                              const SizedBox(height: 4),
                              _statusBadge(payment['status']),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'Confirmed':
      case 'Paid':
      case 'confirmed':
        color = Colors.green;
        break;
      case 'Pending':
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 11)),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: ColorsManager.lightBlue, size: 14),
        const SizedBox(width: 6),
<<<<<<< HEAD
        Text(
          text,
          style: const TextStyle(color: ColorsManager.mutedText, fontSize: 13),
        ),
=======
        Text(text,
            style: const TextStyle(
                color: ColorsManager.mutedText, fontSize: 13)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      ],
    );
  }

  IconData _getSportIcon(String sport) {
    switch (sport) {
      case 'Football':
        return Icons.sports_soccer;
      case 'Padel':
        return Icons.sports_tennis;
      case 'Basketball':
        return Icons.sports_basketball;
      default:
        return Icons.sports;
    }
  }

<<<<<<< HEAD
  Future<LatLng?> _openLocationPicker({LatLng? initial}) async {
    final LatLng startPos = initial ?? const LatLng(30.0444, 31.2357);
    return showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _LocationPickerSheet(initialPosition: startPos),
    );
  }

=======
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  void _showAddVenueDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedSport = 'Football';
    bool createNewOwner = true;
    int? selectedOwnerId;
    final newOwnerEmailCtrl = TextEditingController();
    final newOwnerNameCtrl = TextEditingController();
    final newOwnerPassCtrl = TextEditingController();
<<<<<<< HEAD
    LatLng pickedLocation = const LatLng(30.0444, 31.2357);
    bool locationPicked = false;
=======
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: ColorsManager.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
<<<<<<< HEAD
            side: const BorderSide(
              color: ColorsManager.borderColor,
              width: 0.5,
            ),
=======
            side: const BorderSide(color: ColorsManager.borderColor, width: 0.5),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
          title: const Text('Add Venue', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Venue Name',
                    labelStyle: TextStyle(color: ColorsManager.mutedText),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price per hour (EGP)',
                    labelStyle: TextStyle(color: ColorsManager.mutedText),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedSport,
                  dropdownColor: ColorsManager.cardBg,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Sport Type',
                    labelStyle: TextStyle(color: ColorsManager.mutedText),
                  ),
                  items: ['Football', 'Basketball', 'Padel']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
<<<<<<< HEAD
                  onChanged: (val) =>
                      setDialogState(() => selectedSport = val!),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await _openLocationPicker(
                      initial: pickedLocation,
                    );
                    if (mounted) {
                      _showAddVenueDialogWithState(
                        nameController: nameController,
                        priceController: priceController,
                        selectedSport: selectedSport,
                        createNewOwner: createNewOwner,
                        selectedOwnerId: selectedOwnerId,
                        newOwnerEmailCtrl: newOwnerEmailCtrl,
                        newOwnerNameCtrl: newOwnerNameCtrl,
                        newOwnerPassCtrl: newOwnerPassCtrl,
                        pickedLocation: result ?? pickedLocation,
                        locationPicked: locationPicked || result != null,
                      );
                    }
                  },
                  child: _locationTile(locationPicked, pickedLocation),
=======
                  onChanged: (val) => setDialogState(() => selectedSport = val!),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
                const SizedBox(height: 16),
                const Divider(color: ColorsManager.borderColor),
                const Text(
                  'Owner Information',
<<<<<<< HEAD
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _ownerToggle(
                  createNewOwner,
                  onExisting: () =>
                      setDialogState(() => createNewOwner = false),
                  onNew: () => setDialogState(() => createNewOwner = true),
                ),
                const SizedBox(height: 12),
                if (createNewOwner) ...[
                  _ownerField(newOwnerEmailCtrl, 'Owner Email *'),
                  const SizedBox(height: 8),
                  _ownerField(newOwnerNameCtrl, 'Owner Full Name *'),
                  const SizedBox(height: 8),
                  _ownerField(
                    newOwnerPassCtrl,
                    'Owner Password *',
                    obscure: true,
=======
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => createNewOwner = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !createNewOwner
                                ? ColorsManager.primaryBlue.withValues(alpha: 0.2)
                                : Colors.transparent,
                            border: Border.all(color: ColorsManager.borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Existing Owner',
                              style: TextStyle(
                                color: !createNewOwner
                                    ? ColorsManager.primaryBlue
                                    : ColorsManager.mutedText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => createNewOwner = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: createNewOwner
                                ? ColorsManager.primaryBlue.withValues(alpha: 0.2)
                                : Colors.transparent,
                            border: Border.all(color: ColorsManager.borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'New Owner',
                              style: TextStyle(
                                color: createNewOwner
                                    ? ColorsManager.primaryBlue
                                    : ColorsManager.mutedText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (createNewOwner) ...[
                  TextField(
                    controller: newOwnerEmailCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Owner Email *',
                      labelStyle: TextStyle(color: ColorsManager.mutedText),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: newOwnerNameCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Owner Full Name *',
                      labelStyle: TextStyle(color: ColorsManager.mutedText),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: newOwnerPassCtrl,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Owner Password *',
                      labelStyle: TextStyle(color: ColorsManager.mutedText),
                    ),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  ),
                ] else ...[
                  if (owners.isEmpty)
                    const Text(
                      'No existing owners found.',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                  else
<<<<<<< HEAD
                    _ownerDropdown(
                      selectedOwnerId,
                      (val) => setDialogState(() => selectedOwnerId = val),
=======
                    DropdownButtonFormField<int>(
                      initialValue: selectedOwnerId,
                      dropdownColor: ColorsManager.cardBg,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Select Owner',
                        labelStyle: TextStyle(color: ColorsManager.mutedText),
                      ),
                      items: owners.map((owner) {
                        return DropdownMenuItem<int>(
                          value: owner['id'],
                          child: Text(owner['name'],
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (val) => setDialogState(() => selectedOwnerId = val),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                    ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
<<<<<<< HEAD
              child: const Text(
                'Cancel',
                style: TextStyle(color: ColorsManager.mutedText),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_validateAddVenue(
                  context,
                  nameController,
                  priceController,
                  createNewOwner,
                  newOwnerEmailCtrl,
                  newOwnerNameCtrl,
                  newOwnerPassCtrl,
                  selectedOwnerId,
                )) {
                  return;
                }
                try {
                  final dio = getIt<Dio>();
                  final data = _buildVenueData(
                    nameController.text,
                    priceController.text,
                    selectedSport,
                    pickedLocation,
                  );
=======
              child: const Text('Cancel',
                  style: TextStyle(color: ColorsManager.mutedText)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || priceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill venue name and price'),
                        backgroundColor: Colors.red),
                  );
                  return;
                }
                if (createNewOwner) {
                  if (newOwnerEmailCtrl.text.isEmpty ||
                      newOwnerNameCtrl.text.isEmpty ||
                      newOwnerPassCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill all owner fields'),
                          backgroundColor: Colors.red),
                    );
                    return;
                  }
                } else {
                  if (selectedOwnerId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select an existing owner'),
                          backgroundColor: Colors.red),
                    );
                    return;
                  }
                }
                try {
                  final dio = getIt<Dio>();
                  final Map<String, dynamic> data = {
                    'name': nameController.text,
                    'sport_id': ['Football', 'Padel', 'Basketball'].indexOf(selectedSport) + 1,
                    'price_per_hour': int.tryParse(priceController.text) ?? 0,
                    'description': '',
                    'latitude': 30.0444,
                    'longitude': 31.2357,
                  };
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  if (createNewOwner) {
                    data['owner_email'] = newOwnerEmailCtrl.text.trim();
                    data['owner_name'] = newOwnerNameCtrl.text.trim();
                    data['owner_password'] = newOwnerPassCtrl.text.trim();
                  } else {
                    data['owner_id'] = selectedOwnerId;
                  }
                  await dio.post('/courts', data: data);
                  await _loadVenues();
                  await _loadOwners();
<<<<<<< HEAD
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryBlue,
              ),
=======
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint('Error adding venue: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryBlue),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  void _showAddVenueDialogWithState({
    required TextEditingController nameController,
    required TextEditingController priceController,
    required String selectedSport,
    required bool createNewOwner,
    required int? selectedOwnerId,
    required TextEditingController newOwnerEmailCtrl,
    required TextEditingController newOwnerNameCtrl,
    required TextEditingController newOwnerPassCtrl,
    required LatLng pickedLocation,
    required bool locationPicked,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          String sport =
              ['Football', 'Basketball', 'Padel'].contains(selectedSport)
              ? selectedSport
              : 'Football';
          bool newOwner = createNewOwner;
          int? ownerId = selectedOwnerId;
          LatLng location = pickedLocation;
          bool picked = locationPicked;

          return AlertDialog(
            backgroundColor: ColorsManager.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: ColorsManager.borderColor,
                width: 0.5,
              ),
            ),
            title: const Text(
              'Add Venue',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ownerField(nameController, 'Venue Name'),
                  const SizedBox(height: 12),
                  _ownerField(
                    priceController,
                    'Price per hour (EGP)',
                    number: true,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: sport,
                    dropdownColor: ColorsManager.cardBg,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Sport Type',
                      labelStyle: TextStyle(color: ColorsManager.mutedText),
                    ),
                    items: ['Football', 'Basketball', 'Padel']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setDialogState(() => sport = val!),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await _openLocationPicker(
                        initial: location,
                      );
                      if (mounted) {
                        _showAddVenueDialogWithState(
                          nameController: nameController,
                          priceController: priceController,
                          selectedSport: sport,
                          createNewOwner: newOwner,
                          selectedOwnerId: ownerId,
                          newOwnerEmailCtrl: newOwnerEmailCtrl,
                          newOwnerNameCtrl: newOwnerNameCtrl,
                          newOwnerPassCtrl: newOwnerPassCtrl,
                          pickedLocation: result ?? location,
                          locationPicked: picked || result != null,
                        );
                      }
                    },
                    child: _locationTile(picked, location),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: ColorsManager.borderColor),
                  const Text(
                    'Owner Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ownerToggle(
                    newOwner,
                    onExisting: () => setDialogState(() => newOwner = false),
                    onNew: () => setDialogState(() => newOwner = true),
                  ),
                  const SizedBox(height: 12),
                  if (newOwner) ...[
                    _ownerField(newOwnerEmailCtrl, 'Owner Email *'),
                    const SizedBox(height: 8),
                    _ownerField(newOwnerNameCtrl, 'Owner Full Name *'),
                    const SizedBox(height: 8),
                    _ownerField(
                      newOwnerPassCtrl,
                      'Owner Password *',
                      obscure: true,
                    ),
                  ] else ...[
                    if (owners.isEmpty)
                      const Text(
                        'No existing owners found.',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    else
                      _ownerDropdown(
                        ownerId,
                        (val) => setDialogState(() => ownerId = val),
                      ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: ColorsManager.mutedText),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_validateAddVenue(
                    context,
                    nameController,
                    priceController,
                    newOwner,
                    newOwnerEmailCtrl,
                    newOwnerNameCtrl,
                    newOwnerPassCtrl,
                    ownerId,
                  )) {
                    return;
                  }
                  try {
                    final dio = getIt<Dio>();
                    final data = _buildVenueData(
                      nameController.text,
                      priceController.text,
                      sport,
                      location,
                    );
                    if (newOwner) {
                      data['owner_email'] = newOwnerEmailCtrl.text.trim();
                      data['owner_name'] = newOwnerNameCtrl.text.trim();
                      data['owner_password'] = newOwnerPassCtrl.text.trim();
                    } else {
                      data['owner_id'] = ownerId;
                    }
                    await dio.post('/courts', data: data);
                    await _loadVenues();
                    await _loadOwners();
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryBlue,
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditVenueDialog(int index) {
    final venue = venues[index];
    final nameController = TextEditingController(text: venue['name']);
    final priceController = TextEditingController(
      text: venue['price'].toString(),
    );
    String selectedSport =
        ['Football', 'Basketball', 'Padel'].contains(venue['sport'])
        ? venue['sport']
        : 'Football';
=======
  void _showEditVenueDialog(int index) {
    final venue = venues[index];
    final nameController = TextEditingController(text: venue['name']);
    final priceController = TextEditingController(text: venue['price'].toString());
    String selectedSport = venue['sport'];
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    bool isAvailable = venue['available'];
    bool hasOwner = venue['has_owner'] ?? false;
    final ownerEmailCtrl = TextEditingController();
    final ownerNameCtrl = TextEditingController();
    final ownerPassCtrl = TextEditingController();
<<<<<<< HEAD
    LatLng pickedLocation = LatLng(
      double.tryParse(venue['latitude']?.toString() ?? '') ?? 30.0444,
      double.tryParse(venue['longitude']?.toString() ?? '') ?? 31.2357,
    );
    bool locationPicked = venue['latitude'] != null;

    _showEditVenueDialogWithState(
      venue: venue,
      nameController: nameController,
      priceController: priceController,
      selectedSport: selectedSport,
      isAvailable: isAvailable,
      hasOwner: hasOwner,
      ownerEmailCtrl: ownerEmailCtrl,
      ownerNameCtrl: ownerNameCtrl,
      ownerPassCtrl: ownerPassCtrl,
      pickedLocation: pickedLocation,
      locationPicked: locationPicked,
    );
  }

  void _showEditVenueDialogWithState({
    required Map<String, dynamic> venue,
    required TextEditingController nameController,
    required TextEditingController priceController,
    required String selectedSport,
    required bool isAvailable,
    required bool hasOwner,
    required TextEditingController ownerEmailCtrl,
    required TextEditingController ownerNameCtrl,
    required TextEditingController ownerPassCtrl,
    required LatLng pickedLocation,
    required bool locationPicked,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          String sport = selectedSport;
          bool available = isAvailable;
          LatLng location = pickedLocation;
          bool picked = locationPicked;

          return AlertDialog(
            backgroundColor: ColorsManager.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: ColorsManager.borderColor,
                width: 0.5,
              ),
            ),
            title: const Text(
              'Edit Venue',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ownerField(nameController, 'Venue Name'),
                  const SizedBox(height: 12),
                  _ownerField(
                    priceController,
                    'Price per hour (EGP)',
                    number: true,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: sport,
                    dropdownColor: ColorsManager.cardBg,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Sport Type',
                      labelStyle: TextStyle(color: ColorsManager.mutedText),
                    ),
                    items: ['Football', 'Basketball', 'Padel']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setDialogState(() => sport = val!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: available,
                        activeThumbColor: ColorsManager.primaryBlue,
                        onChanged: (val) =>
                            setDialogState(() => available = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await _openLocationPicker(
                        initial: location,
                      );
                      if (mounted) {
                        _showEditVenueDialogWithState(
                          venue: venue,
                          nameController: nameController,
                          priceController: priceController,
                          selectedSport: sport,
                          isAvailable: available,
                          hasOwner: hasOwner,
                          ownerEmailCtrl: ownerEmailCtrl,
                          ownerNameCtrl: ownerNameCtrl,
                          ownerPassCtrl: ownerPassCtrl,
                          pickedLocation: result ?? location,
                          locationPicked: picked || result != null,
                        );
                      }
                    },
                    child: _locationTile(picked, location, isEdit: true),
                  ),
                  if (!hasOwner) ...[
                    const SizedBox(height: 16),
                    const Divider(color: ColorsManager.borderColor),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: Colors.orange,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'No Owner — Add Owner Account',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _ownerField(
                            ownerEmailCtrl,
                            'Owner Email *',
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 8),
                          _ownerField(
                            ownerNameCtrl,
                            'Owner Full Name *',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 8),
                          _ownerField(
                            ownerPassCtrl,
                            'Owner Password *',
                            icon: Icons.lock,
                            obscure: true,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'This venue has an owner',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: ColorsManager.mutedText),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final dio = getIt<Dio>();
                    final Map<String, dynamic> data = {
                      'name': nameController.text,
                      'sport_id':
                          ['Football', 'Padel', 'Basketball'].indexOf(sport) +
                          1,
                      'price_per_hour': int.tryParse(priceController.text) ?? 0,
                      'is_available': available ? 1 : 0,
                      'latitude': location.latitude,
                      'longitude': location.longitude,
                    };
                    if (!hasOwner &&
                        ownerEmailCtrl.text.isNotEmpty &&
                        ownerNameCtrl.text.isNotEmpty &&
                        ownerPassCtrl.text.isNotEmpty) {
                      data['owner_email'] = ownerEmailCtrl.text.trim();
                      data['owner_name'] = ownerNameCtrl.text.trim();
                      data['owner_password'] = ownerPassCtrl.text.trim();
                    }
                    await dio.put('/courts/${venue['id']}', data: data);
                    await _loadVenues();
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryBlue,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _locationTile(bool picked, LatLng location, {bool isEdit = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: picked
            ? ColorsManager.primaryBlue.withValues(alpha: 0.12)
            : ColorsManager.borderColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: picked
              ? ColorsManager.primaryBlue.withValues(alpha: 0.5)
              : ColorsManager.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ColorsManager.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on,
              color: ColorsManager.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  picked
                      ? (isEdit ? 'Update Location' : 'Location Selected')
                      : 'Pick Location on Map',
                  style: TextStyle(
                    color: picked ? Colors.white : ColorsManager.mutedText,
                    fontWeight: picked ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                if (picked) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(
                      color: ColorsManager.mutedText,
                      fontSize: 11,
=======

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorsManager.borderColor, width: 0.5),
        ),
        title: const Text('Edit Venue', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Venue Name',
                    labelStyle: TextStyle(color: ColorsManager.mutedText),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price per hour (EGP)',
                    labelStyle: TextStyle(color: ColorsManager.mutedText),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedSport,
                  dropdownColor: ColorsManager.cardBg,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Sport Type',
                    labelStyle: TextStyle(color: ColorsManager.mutedText),
                  ),
                  items: ['Football', 'Basketball', 'Padel']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedSport = val!),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Available', style: TextStyle(color: Colors.white)),
                    Switch(
                      value: isAvailable,
                      activeThumbColor: ColorsManager.primaryBlue,
                      onChanged: (val) => setDialogState(() => isAvailable = val),
                    ),
                  ],
                ),
                if (!hasOwner) ...[
                  const SizedBox(height: 16),
                  const Divider(color: ColorsManager.borderColor),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'No Owner — Add Owner Account',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: ownerEmailCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Owner Email *',
                            labelStyle: TextStyle(color: ColorsManager.mutedText),
                            prefixIcon: Icon(Icons.email, color: ColorsManager.mutedText),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: ownerNameCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Owner Full Name *',
                            labelStyle: TextStyle(color: ColorsManager.mutedText),
                            prefixIcon: Icon(Icons.person, color: ColorsManager.mutedText),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: ownerPassCtrl,
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Owner Password *',
                            labelStyle: TextStyle(color: ColorsManager.mutedText),
                            prefixIcon: Icon(Icons.lock, color: ColorsManager.mutedText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text('This venue has an owner',
                            style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                    ),
                  ),
                ],
              ],
            ),
          ),
<<<<<<< HEAD
          Icon(
            Icons.chevron_right,
            color: picked ? ColorsManager.primaryBlue : ColorsManager.mutedText,
=======
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: ColorsManager.mutedText)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final dio = getIt<Dio>();
                final Map<String, dynamic> data = {
                  'name': nameController.text,
                  'sport_id': ['Football', 'Padel', 'Basketball'].indexOf(selectedSport) + 1,
                  'price_per_hour': int.tryParse(priceController.text) ?? 0,
                  'is_available': isAvailable ? 1 : 0,
                };
                if (!hasOwner &&
                    ownerEmailCtrl.text.isNotEmpty &&
                    ownerNameCtrl.text.isNotEmpty &&
                    ownerPassCtrl.text.isNotEmpty) {
                  data['owner_email'] = ownerEmailCtrl.text.trim();
                  data['owner_name'] = ownerNameCtrl.text.trim();
                  data['owner_password'] = ownerPassCtrl.text.trim();
                }
                await dio.put('/courts/${venue['id']}', data: data);
                await _loadVenues();
                Navigator.pop(context);
              } catch (e) {
                debugPrint('Error editing venue: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryBlue),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD

  Widget _ownerField(
    TextEditingController ctrl,
    String label, {
    bool obscure = false,
    bool number = false,
    IconData? icon,
  }) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      obscureText: obscure,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: ColorsManager.mutedText),
        prefixIcon: icon != null
            ? Icon(icon, color: ColorsManager.mutedText)
            : null,
      ),
    );
  }

  Widget _ownerToggle(
    bool createNew, {
    required VoidCallback onExisting,
    required VoidCallback onNew,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onExisting,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: !createNew
                    ? ColorsManager.primaryBlue.withValues(alpha: 0.2)
                    : Colors.transparent,
                border: Border.all(color: ColorsManager.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Existing Owner',
                  style: TextStyle(
                    color: !createNew
                        ? ColorsManager.primaryBlue
                        : ColorsManager.mutedText,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onNew,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: createNew
                    ? ColorsManager.primaryBlue.withValues(alpha: 0.2)
                    : Colors.transparent,
                border: Border.all(color: ColorsManager.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'New Owner',
                  style: TextStyle(
                    color: createNew
                        ? ColorsManager.primaryBlue
                        : ColorsManager.mutedText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ownerDropdown(int? selectedId, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      initialValue: selectedId,
      dropdownColor: ColorsManager.cardBg,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Select Owner',
        labelStyle: TextStyle(color: ColorsManager.mutedText),
      ),
      items: owners
          .map(
            (owner) => DropdownMenuItem<int>(
              value: owner['id'],
              child: Text(
                owner['name'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  bool _validateAddVenue(
    BuildContext context,
    TextEditingController nameCtrl,
    TextEditingController priceCtrl,
    bool createNewOwner,
    TextEditingController emailCtrl,
    TextEditingController nameOwnerCtrl,
    TextEditingController passCtrl,
    int? selectedOwnerId,
  ) {
    if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill venue name and price'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (createNewOwner) {
      if (emailCtrl.text.isEmpty ||
          nameOwnerCtrl.text.isEmpty ||
          passCtrl.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all owner fields'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } else {
      if (selectedOwnerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an existing owner'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> _buildVenueData(
    String name,
    String price,
    String sport,
    LatLng location,
  ) {
    return {
      'name': name,
      'sport_id': ['Football', 'Padel', 'Basketball'].indexOf(sport) + 1,
      'price_per_hour': int.tryParse(price) ?? 0,
      'description': '',
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
  }
}

// ── Location Picker Sheet ─────────────────────────────────────────────────────

class _LocationPickerSheet extends StatefulWidget {
  final LatLng initialPosition;
  const _LocationPickerSheet({required this.initialPosition});

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  late LatLng _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pick Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, _selectedPosition),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Tap on the map to place a pin',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedPosition,
                  infoWindow: InfoWindow(
                    title: 'Selected Location',
                    snippet:
                        '${_selectedPosition.latitude.toStringAsFixed(4)}, ${_selectedPosition.longitude.toStringAsFixed(4)}',
                  ),
                ),
              },
              onTap: (pos) => setState(() => _selectedPosition = pos),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
=======
}
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
