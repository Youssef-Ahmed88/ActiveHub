import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';

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
        venues = data.map((v) => {
          'id': v['id'],
          'name': v['name'],
          'sport': v['sport']?['name'] ?? '',
          'price': double.parse(v['price_per_hour'].toString()).toInt(),
          'available': v['is_available'] == 1,
          'has_owner': v['owner_id'] != null, // ✅ إضافة
        }).toList();
      });
    } catch (e) {
      debugPrint('Error loading venues: $e');
    }
  }

  Future<void> _loadBookings() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/my-bookings');
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
        payments = data.map((p) => {
          'id': p['id'],
          'user': p['booking']?['user_id'].toString() ?? '',
          'amount': double.parse(p['amount'].toString()).toInt(),
          'method': p['payment_method'],
          'status': 'Paid',
        }).toList();
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
        owners = data.map((u) => {
          'id': u['id'],
          'name': u['full_name'] ?? u['name'] ?? 'Unknown',
          'email': u['email'],
        }).toList();
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
        title: const Text('Admin Panel',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, Routes.loginScreen, (route) => false),
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
          ? const Center(child: Text('No venues found', style: TextStyle(color: Colors.white70)))
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
            child: Icon(_getSportIcon(venue['sport']),
                color: ColorsManager.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venue['name'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(venue['sport'],
                    style: const TextStyle(
                        color: ColorsManager.mutedText, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('EGP ${venue['price']}/hr',
                  style: const TextStyle(color: Colors.green, fontSize: 13)),
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
                      color: venue['available'] ? Colors.green : Colors.red,
                      fontSize: 11),
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
                _showEditVenueDialog(index);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return bookings.isEmpty
        ? const Center(child: Text('No bookings found', style: TextStyle(color: Colors.white70)))
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
                  border: Border.all(color: ColorsManager.borderColor, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('User #${booking['user']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
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
                  Text('Total Collected',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  SizedBox(height: 4),
                ],
              ),
              Text(
                'EGP $total',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        Expanded(
          child: payments.isEmpty
              ? const Center(child: Text('No payments found', style: TextStyle(color: Colors.white70)))
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
                            color: ColorsManager.borderColor, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.payment,
                                color: ColorsManager.primaryBlue),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User #${payment['user']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                Text(payment['method'],
                                    style: const TextStyle(
                                        color: ColorsManager.mutedText,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('EGP ${payment['amount']}',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
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
        Text(text,
            style: const TextStyle(
                color: ColorsManager.mutedText, fontSize: 13)),
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

  void _showAddVenueDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedSport = 'Football';
    bool createNewOwner = true;
    int? selectedOwnerId;
    final newOwnerEmailCtrl = TextEditingController();
    final newOwnerNameCtrl = TextEditingController();
    final newOwnerPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: ColorsManager.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: ColorsManager.borderColor, width: 0.5),
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
                  onChanged: (val) => setDialogState(() => selectedSport = val!),
                ),
                const SizedBox(height: 16),
                const Divider(color: ColorsManager.borderColor),
                const Text(
                  'Owner Information',
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
                  ),
                ] else ...[
                  if (owners.isEmpty)
                    const Text(
                      'No existing owners found.',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                  else
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
                    ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditVenueDialog(int index) {
    final venue = venues[index];
    final nameController = TextEditingController(text: venue['name']);
    final priceController = TextEditingController(text: venue['price'].toString());
    String selectedSport = venue['sport'];
    bool isAvailable = venue['available'];
    bool hasOwner = venue['has_owner'] ?? false;
    final ownerEmailCtrl = TextEditingController();
    final ownerNameCtrl = TextEditingController();
    final ownerPassCtrl = TextEditingController();

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
                    ),
                  ),
                ],
              ],
            ),
          ),
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
          ),
        ],
      ),
    );
  }
}

