import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';

class VenueSlotsStore {
  static final Map<String, List<String>> _availableSlots = {};

  static List<String> getSlots(String venueId) =>
      _availableSlots[venueId] ?? [];

  static void setSlots(String venueId, List<String> slots) =>
      _availableSlots[venueId] = slots;
}

class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> venues = [];
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> payments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
<<<<<<< HEAD
    await Future.wait([_loadVenues(), _loadBookings()]);
=======
    await Future.wait([
      _loadVenues(),
      _loadBookings(),
      _loadPayments(),
    ]);
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    setState(() => isLoading = false);
  }

  Future<void> _loadVenues() async {
    try {
      final dio = getIt<Dio>();
<<<<<<< HEAD
      final response = await dio.get('/owner/courts');
      final List data = response.data['data'] ?? response.data;
      setState(() {
        venues = data
            .map(
              (v) => {
                'id': v['id'].toString(),
                'name': v['name'],
                'sport': v['sport']?['name'] ?? '',
                'price': double.parse(v['price_per_hour'].toString()).toInt(),
                'isAvailable': v['is_available'] == 1,
              },
            )
            .toList();
=======
      final response = await dio.get('/owner/courts'); // ✅ owner only
      final List data = response.data['data'];
      setState(() {
        venues = data.map((v) => {
          'id': v['id'].toString(),
          'name': v['name'],
          'sport': v['sport']?['name'] ?? '',
          'price': double.parse(v['price_per_hour'].toString()).toInt(),
          'isAvailable': v['is_available'] == 1,
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
<<<<<<< HEAD
      // ✅ تم التعديل: /owner/bookings بدل /my-bookings
      final response = await dio.get('/owner/bookings');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);

      setState(() {
        bookings = data.map((b) {
          // حساب الـ revenue من الـ bookings مباشرة
          final price = b['total_price'] ?? b['price'] ?? 0;
          return {
            'id': b['id'].toString(),
            'user': b['user']?['name'] ?? 'User #${b['user_id']}',
            'venue': b['court']?['name'] ?? '',
            'date': b['booking_date'] ?? b['date'] ?? '',
            'time': _formatTime(b['start_time']),
            'status': b['status'] == 'confirmed' ? 'Paid' : 'Pending',
            'amount': double.tryParse(price.toString())?.toInt() ?? 0,
          };
        }).toList();

        // ✅ بناء الـ payments من الـ bookings المدفوعة
        payments = bookings
            .where((b) => b['status'] == 'Paid')
            .map(
              (b) => {
                'id': b['id'],
                'user': b['user'],
                'amount': b['amount'],
                'method': 'Online',
                'status': 'Paid',
              },
            )
            .toList();
=======
      final response = await dio.get('/my-bookings');
      final List data = response.data is List ? response.data : response.data['data'];
      setState(() {
        bookings = data.map((b) => {
          'id': b['id'].toString(),
          'user': 'User #${b['user_id']}',
          'venue': b['court']?['name'] ?? '',
          'time': b['start_time'].toString().split(' ')[1],
          'status': b['status'] == 'confirmed' ? 'Paid' : 'Pending',
        }).toList();
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      });
    } catch (e) {
      debugPrint('Error loading bookings: $e');
    }
  }

<<<<<<< HEAD
  String _formatTime(dynamic time) {
    if (time == null) return '-';
    final str = time.toString();
    // لو فيه مسافة يبقا "2024-01-01 14:00:00" → خد الجزء التاني
    if (str.contains(' ')) return str.split(' ')[1];
    return str;
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.loginScreen,
      (route) => false,
    );
=======
  Future<void> _loadPayments() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/payments');
      final List data = response.data['data'];
      setState(() {
        payments = data.map((p) => {
          'id': p['id'].toString(),
          'user': 'User #${p['booking']?['user_id'] ?? ''}',
          'amount': double.parse(p['amount'].toString()).toInt(),
          'method': p['payment_method'],
          'status': 'Paid',
        }).toList();
      });
    } catch (e) {
      debugPrint('Error loading payments: $e');
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                if (isWide) _buildSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: _buildActiveTabContent(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: !isWide ? _buildMobileNav() : null,
<<<<<<< HEAD
=======
      floatingActionButton: null, // ✅ الـ owner مش admin
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(right: BorderSide(color: Color(0xFF30363D))),
      ),
      child: Column(
        children: [
          _buildSidebarBrand(),
          const SizedBox(height: 20),
          _sidebarItem(0, Icons.location_on_outlined, 'Availability'),
          _sidebarItem(1, Icons.calendar_today_outlined, 'Bookings'),
          _sidebarItem(2, Icons.account_balance_wallet_outlined, 'Financials'),
          const Spacer(),
          _buildUserProfile(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 40),
<<<<<<< HEAD
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white, size: 18),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
=======
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.logout, color: Colors.white, size: 18),
              label: const Text("Logout", style: TextStyle(color: Colors.white)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarBrand() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3D5AFE),
              borderRadius: BorderRadius.circular(10),
<<<<<<< HEAD
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3D5AFE).withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'OwnerHub',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
=======
              boxShadow: [BoxShadow(color: const Color(0xFF3D5AFE).withValues(alpha: 0.3), blurRadius: 10)],
            ),
            child: const Icon(Icons.emoji_events, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('OwnerHub', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white, letterSpacing: -0.5)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String label) {
    final bool active = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: () => setState(() => _selectedIndex = index),
<<<<<<< HEAD
        leading: Icon(
          icon,
          color: active ? const Color(0xFF3D5AFE) : const Color(0xFF8B949E),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF8B949E),
            fontSize: 14,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor: active
            ? const Color(0xFF3D5AFE).withValues(alpha: 0.1)
            : null,
=======
        leading: Icon(icon, color: active ? const Color(0xFF3D5AFE) : const Color(0xFF8B949E), size: 22),
        title: Text(label, style: TextStyle(color: active ? Colors.white : const Color(0xFF8B949E), fontSize: 14, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        tileColor: active ? const Color(0xFF3D5AFE).withValues(alpha: 0.1) : null,
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
<<<<<<< HEAD
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF30363D))),
      ),
=======
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF30363D)))),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      child: const Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF3D5AFE),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  'Owner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Stadium Owner',
                  style: TextStyle(fontSize: 11, color: Color(0xFF8B949E)),
                ),
=======
                Text('Owner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                Text('Stadium Owner', style: TextStyle(fontSize: 11, color: Color(0xFF8B949E))),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    const titles = ['Venue Overview', 'Bookings', 'Financials'];
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile ? 20 : 24,
      ),
      color: const Color(0xFF0F1115),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  titles[_selectedIndex],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Monitor your stadium fields and activities',
                  style: TextStyle(color: Color(0xFF8B949E), fontSize: 14),
                ),
                const SizedBox(height: 16),
                // ✅ زر Refresh
                GestureDetector(
                  onTap: () async {
                    setState(() => isLoading = true);
                    await _loadData();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      border: Border.all(color: const Color(0xFF30363D)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, color: Color(0xFF8B949E), size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Updated: Just Now',
                          style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
=======
                Text(titles[_selectedIndex], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1)),
                const SizedBox(height: 6),
                const Text('Monitor your stadium fields and activities', style: TextStyle(color: Color(0xFF8B949E), fontSize: 14)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    border: Border.all(color: const Color(0xFF30363D)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Updated: Just Now', style: TextStyle(color: Color(0xFF8B949E), fontSize: 12, fontWeight: FontWeight.bold)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(
                      titles[_selectedIndex],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Monitor your stadium fields and activities',
                      style: TextStyle(color: Color(0xFF8B949E), fontSize: 14),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() => isLoading = true);
                    await _loadData();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      border: Border.all(color: const Color(0xFF30363D)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.refresh, color: Color(0xFF8B949E), size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Updated: Just Now',
                          style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
=======
                    Text(titles[_selectedIndex], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1)),
                    const SizedBox(height: 4),
                    const Text('Monitor your stadium fields and activities', style: TextStyle(color: Color(0xFF8B949E), fontSize: 14)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    border: Border.all(color: const Color(0xFF30363D)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Updated: Just Now', style: TextStyle(color: Color(0xFF8B949E), fontSize: 12, fontWeight: FontWeight.bold)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
              ],
            ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_selectedIndex) {
<<<<<<< HEAD
      case 0:
        return _buildAvailabilityTab();
      case 1:
        return _buildBookingsTab();
      case 2:
        return _buildFinancialsTab();
      default:
        return const SizedBox();
=======
      case 0: return _buildAvailabilityTab();
      case 1: return _buildBookingsTab();
      case 2: return _buildFinancialsTab();
      default: return const SizedBox();
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    }
  }

  Widget _buildAvailabilityTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsGrid(),
        const SizedBox(height: 48),
        const Row(
          children: [
            Icon(Icons.bolt, color: Color(0xFF3D5AFE), size: 20),
            SizedBox(width: 8),
<<<<<<< HEAD
            Text(
              'Field Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
=======
            Text('Field Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ],
        ),
        const SizedBox(height: 24),
        venues.isEmpty
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
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
<<<<<<< HEAD
                  crossAxisCount: MediaQuery.of(context).size.width > 1200
                      ? 3
                      : (MediaQuery.of(context).size.width > 700 ? 2 : 1),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  mainAxisExtent: 180,
=======
                  crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : (MediaQuery.of(context).size.width > 700 ? 2 : 1),
                  crossAxisSpacing: 24, mainAxisSpacing: 24, mainAxisExtent: 180,
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
                itemCount: venues.length,
                itemBuilder: (context, index) => VenueCard(
                  venue: venues[index],
                  onToggle: () async {
                    try {
                      final dio = getIt<Dio>();
<<<<<<< HEAD
                      await dio.put(
                        '/courts/${venues[index]['id']}',
                        data: {
                          'is_available': venues[index]['isAvailable'] ? 0 : 1,
                        },
                      );
=======
                      await dio.put('/courts/${venues[index]['id']}', data: {
                        'is_available': venues[index]['isAvailable'] ? 0 : 1,
                      });
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                      await _loadVenues();
                    } catch (e) {
                      debugPrint('Error toggling venue: $e');
                    }
                  },
                  onManageSlots: () => _showManageSlotsDialog(venues[index]),
                ),
              ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final paidCount = bookings.where((b) => b['status'] == 'Paid').length;
    final pendingCount = bookings.where((b) => b['status'] == 'Pending').length;
<<<<<<< HEAD
    // ✅ حساب الـ revenue من الـ bookings المدفوعة
    final totalRevenue = bookings
        .where((b) => b['status'] == 'Paid')
        .fold(0, (sum, b) => sum + (b['amount'] as int));

    return LayoutBuilder(
      builder: (context, c) {
        int count = c.maxWidth > 800 ? 3 : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: count,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: count == 1 ? 2.2 : 2.5,
          children: [
            StatCard(
              label: 'TOTAL REVENUE',
              value: 'EGP $totalRevenue',
              accent: 'All time',
              accentColor: const Color(0xFF00E676),
            ),
            StatCard(
              label: 'ACTIVE BOOKINGS',
              value: '$paidCount',
              accent: 'Confirmed',
              accentColor: const Color(0xFF3D5AFE),
            ),
            StatCard(
              label: 'PENDING',
              value: '$pendingCount',
              accent: 'Awaiting',
              accentColor: Colors.amberAccent,
            ),
          ],
        );
      },
    );
=======
    final totalRevenue = payments.fold(0, (sum, p) => sum + (p['amount'] as int));

    return LayoutBuilder(builder: (context, c) {
      int count = c.maxWidth > 800 ? 3 : 1;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: count,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: count == 1 ? 2.2 : 2.5,
        children: [
          StatCard(label: 'TOTAL REVENUE', value: 'EGP $totalRevenue', accent: 'All time', accentColor: const Color(0xFF00E676)),
          StatCard(label: 'ACTIVE BOOKINGS', value: '$paidCount', accent: 'Confirmed', accentColor: const Color(0xFF3D5AFE)),
          StatCard(label: 'PENDING', value: '$pendingCount', accent: 'Awaiting', accentColor: Colors.amberAccent),
        ],
      );
    });
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  }

  void _showManageSlotsDialog(Map<String, dynamic> venue) {
    final venueId = venue['id'].toString();
    List<String> tempSlots = List.from(VenueSlotsStore.getSlots(venueId));

    const allPossibleSlots = [
<<<<<<< HEAD
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
      '06:00 PM',
      '07:00 PM',
      '08:00 PM',
=======
      '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
      '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM',
      '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM',
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF161B22),
<<<<<<< HEAD
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
=======
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          title: Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF3D5AFE), size: 20),
              const SizedBox(width: 8),
              Expanded(
<<<<<<< HEAD
                child: Text(
                  'Manage Slots – ${venue['name']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
=======
                child: Text('Manage Slots — ${venue['name']}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              ),
            ],
          ),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                const Text(
                  'Toggle which time slots are available for users to book:',
                  style: TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
=======
                const Text('Toggle which time slots are available for users to book:',
                    style: TextStyle(color: Color(0xFF8B949E), fontSize: 12, height: 1.5)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
<<<<<<< HEAD
                      onTap: () =>
                          setS(() => tempSlots = List.from(allPossibleSlots)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D5AFE).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFF3D5AFE,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          'Select All',
                          style: TextStyle(
                            color: Color(0xFF3D5AFE),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
=======
                      onTap: () => setS(() => tempSlots = List.from(allPossibleSlots)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D5AFE).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF3D5AFE).withValues(alpha: 0.3)),
                        ),
                        child: const Text('Select All', style: TextStyle(color: Color(0xFF3D5AFE), fontSize: 12, fontWeight: FontWeight.w700)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setS(() => tempSlots = []),
                      child: Container(
<<<<<<< HEAD
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${tempSlots.length} active',
                      style: const TextStyle(
                        color: Color(0xFF8B949E),
                        fontSize: 12,
                      ),
                    ),
=======
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: const Text('Clear All', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const Spacer(),
                    Text('${tempSlots.length} active', style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allPossibleSlots.map((slot) {
                    final isActive = tempSlots.contains(slot);
                    return GestureDetector(
                      onTap: () => setS(() {
                        if (isActive) {
                          tempSlots.remove(slot);
                        } else {
                          tempSlots.add(slot);
<<<<<<< HEAD
                          tempSlots.sort(
                            (a, b) => allPossibleSlots
                                .indexOf(a)
                                .compareTo(allPossibleSlots.indexOf(b)),
                          );
=======
                          tempSlots.sort((a, b) => allPossibleSlots.indexOf(a).compareTo(allPossibleSlots.indexOf(b)));
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                        }
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
<<<<<<< HEAD
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF3D5AFE)
                              : const Color(0xFF0F1115),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFF3D5AFE)
                                : const Color(0xFF30363D),
                          ),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF8B949E),
                            fontSize: 12,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
=======
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF3D5AFE) : const Color(0xFF0F1115),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isActive ? const Color(0xFF3D5AFE) : const Color(0xFF30363D)),
                        ),
                        child: Text(slot,
                            style: TextStyle(
                              color: isActive ? Colors.white : const Color(0xFF8B949E),
                              fontSize: 12,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                            )),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
<<<<<<< HEAD
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF8B949E)),
              ),
=======
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF8B949E))),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
            ),
            ElevatedButton(
              onPressed: () {
                VenueSlotsStore.setSlots(venueId, tempSlots);
                setState(() {});
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Slots updated for ${venue['name']}'),
                    backgroundColor: const Color(0xFF00E676),
                    behavior: SnackBarBehavior.floating,
<<<<<<< HEAD
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
=======
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D5AFE),
<<<<<<< HEAD
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
=======
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsTab() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        border: Border.all(color: const Color(0xFF30363D)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Incoming Bookings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // ✅ عداد الحجوزات
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D5AFE).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF3D5AFE).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${bookings.length} total',
                    style: const TextStyle(
                      color: Color(0xFF3D5AFE),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
=======
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Incoming Bookings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
          const Divider(height: 1, color: Color(0xFF30363D)),
          bookings.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
<<<<<<< HEAD
                  child: Center(
                    child: Text(
                      'No bookings found',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
=======
                  child: Center(child: Text('No bookings found', style: TextStyle(color: Colors.white70))),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
<<<<<<< HEAD
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFF30363D)),
                  itemBuilder: (context, index) =>
                      BookingTile(booking: bookings[index]),
=======
                  separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFF30363D)),
                  itemBuilder: (context, index) => BookingTile(booking: bookings[index]),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
        ],
      ),
    );
  }

  Widget _buildFinancialsTab() {
<<<<<<< HEAD
    final totalDeposits = payments.fold(
      0,
      (sum, p) => sum + (p['amount'] as int),
    );
=======
    final totalDeposits = payments.fold(0, (sum, p) => sum + (p['amount'] as int));
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    final paidCount = payments.length;
    final pendingCount = bookings.where((b) => b['status'] == 'Pending').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
<<<<<<< HEAD
        LayoutBuilder(
          builder: (context, c) {
            int count = c.maxWidth > 700 ? 3 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: count,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: count == 1 ? 2.2 : 2.2,
              children: [
                StatCard(
                  label: 'TOTAL COLLECTED',
                  value: 'EGP $totalDeposits',
                  accent: 'All time',
                  accentColor: const Color(0xFF00E676),
                ),
                StatCard(
                  label: 'PAID BOOKINGS',
                  value: '$paidCount',
                  accent: 'Confirmed',
                  accentColor: const Color(0xFF3D5AFE),
                ),
                StatCard(
                  label: 'PENDING PAYMENTS',
                  value: '$pendingCount',
                  accent: 'Awaiting',
                  accentColor: Colors.amberAccent,
                ),
              ],
            );
          },
        ),
=======
        LayoutBuilder(builder: (context, c) {
          int count = c.maxWidth > 700 ? 3 : 1;
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: count,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: count == 1 ? 2.2 : 2.2,
            children: [
              StatCard(label: 'TOTAL COLLECTED', value: 'EGP $totalDeposits', accent: 'All time', accentColor: const Color(0xFF00E676)),
              StatCard(label: 'PAID BOOKINGS', value: '$paidCount', accent: 'Confirmed', accentColor: const Color(0xFF3D5AFE)),
              StatCard(label: 'PENDING PAYMENTS', value: '$pendingCount', accent: 'Awaiting', accentColor: Colors.amberAccent),
            ],
          );
        }),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
        const SizedBox(height: 36),
        const Row(
          children: [
            Icon(Icons.receipt_long, color: Color(0xFF3D5AFE), size: 20),
            SizedBox(width: 8),
<<<<<<< HEAD
            Text(
              'Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
=======
            Text('Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            border: Border.all(color: const Color(0xFF30363D)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: payments.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
<<<<<<< HEAD
                  child: Center(
                    child: Text(
                      'No transactions found',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
=======
                  child: Center(child: Text('No transactions found', style: TextStyle(color: Colors.white70))),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: payments.length,
<<<<<<< HEAD
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFF30363D)),
=======
                  separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFF30363D)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  itemBuilder: (context, i) {
                    final p = payments[i];
                    const statusColor = Color(0xFF00E676);
                    return Padding(
<<<<<<< HEAD
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
=======
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
<<<<<<< HEAD
                            child: const Icon(
                              Icons.arrow_downward,
                              color: statusColor,
                              size: 18,
                            ),
=======
                            child: const Icon(Icons.arrow_downward, color: statusColor, size: 18),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
<<<<<<< HEAD
                                Text(
                                  p['user'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  p['method'],
                                  style: const TextStyle(
                                    color: Color(0xFF8B949E),
                                    fontSize: 12,
                                  ),
                                ),
=======
                                Text(p['user'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(p['method'], style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
<<<<<<< HEAD
                              Text(
                                '+EGP ${p['amount']}',
                                style: const TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              const Text(
                                'PAID',
                                style: TextStyle(
                                  color: Color(0xFF8B949E),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
=======
                              Text('+EGP ${p['amount']}', style: const TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 14)),
                              const Text('PAID', style: TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
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

  Widget _buildMobileNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (v) {
        if (v == 3) {
          _logout();
        } else {
          setState(() => _selectedIndex = v);
        }
      },
      backgroundColor: const Color(0xFF161B22),
      selectedItemColor: const Color(0xFF3D5AFE),
      unselectedItemColor: const Color(0xFF8B949E),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
<<<<<<< HEAD
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'VENUE'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'BOOKINGS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'WALLET',
        ),
=======
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'VENUE'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'BOOKINGS'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'WALLET'),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'LOGOUT'),
      ],
    );
  }
}

<<<<<<< HEAD
// ─────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String label, value, accent;
  final Color accentColor;
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    required this.accentColor,
  });
=======
class StatCard extends StatelessWidget {
  final String label, value, accent;
  final Color accentColor;
  const StatCard({super.key, required this.label, required this.value, required this.accent, required this.accentColor});
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
<<<<<<< HEAD
=======

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        border: Border.all(color: const Color(0xFF30363D)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
<<<<<<< HEAD
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 9 : 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B949E),
              letterSpacing: 2,
            ),
          ),
=======
          Text(label, style: TextStyle(fontSize: isMobile ? 9 : 10, fontWeight: FontWeight.bold, color: const Color(0xFF8B949E), letterSpacing: 2)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
<<<<<<< HEAD
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                accent,
                style: TextStyle(
                  color: accentColor,
                  fontSize: isMobile ? 11 : 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
=======
                child: Text(value, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: isMobile ? 22 : 26, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Text(accent, style: TextStyle(color: accentColor, fontSize: isMobile ? 11 : 13, fontWeight: FontWeight.bold)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
            ],
          ),
        ],
      ),
    );
  }
}

class VenueCard extends StatelessWidget {
  final Map<String, dynamic> venue;
  final VoidCallback onToggle;
  final VoidCallback onManageSlots;
<<<<<<< HEAD
=======
  // ✅ onDelete اتشالت
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6

  const VenueCard({
    super.key,
    required this.venue,
    required this.onToggle,
    required this.onManageSlots,
  });

  @override
  Widget build(BuildContext context) {
    final bool available = venue['isAvailable'];
<<<<<<< HEAD
    final Color stateColor = available
        ? const Color(0xFF00E676)
        : const Color(0xFFF44336);
    final int slotCount = VenueSlotsStore.getSlots(
      venue['id'].toString(),
    ).length;
=======
    final Color stateColor = available ? const Color(0xFF00E676) : const Color(0xFFF44336);
    final int slotCount = VenueSlotsStore.getSlots(venue['id'].toString()).length;
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        border: Border.all(color: const Color(0xFF30363D)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
<<<<<<< HEAD
                      decoration: BoxDecoration(
                        color: stateColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        available ? Icons.bolt : Icons.block,
                        color: stateColor,
                        size: 20,
                      ),
=======
                      decoration: BoxDecoration(color: stateColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(available ? Icons.bolt : Icons.block, color: stateColor, size: 20),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        Text(
                          venue['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          venue['sport'].toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF8B949E),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
=======
                        Text(venue['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                        Text(venue['sport'].toString().toUpperCase(), style: const TextStyle(fontSize: 10, color: Color(0xFF8B949E), letterSpacing: 1.5, fontWeight: FontWeight.bold)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                      ],
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  color: const Color(0xFF161B22),
                  icon: const Icon(Icons.more_vert, color: Color(0xFF8B949E)),
                  onSelected: (v) {
                    if (v == 'toggle') onToggle();
                    if (v == 'slots') onManageSlots();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'toggle',
<<<<<<< HEAD
                      child: Text(
                        available ? 'Mark Occupied' : 'Mark Available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
=======
                      child: Text(available ? 'Mark Occupied' : 'Mark Available',
                          style: const TextStyle(color: Colors.white, fontSize: 13)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                    ),
                    const PopupMenuItem(
                      value: 'slots',
                      child: Row(
                        children: [
<<<<<<< HEAD
                          Icon(
                            Icons.access_time,
                            color: Color(0xFF3D5AFE),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Manage Time Slots',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
=======
                          Icon(Icons.access_time, color: Color(0xFF3D5AFE), size: 16),
                          SizedBox(width: 8),
                          Text('Manage Time Slots', style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),
                    // ✅ Delete اتشالت — الـ owner مش admin
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1115).withValues(alpha: 0.5),
              border: Border(left: BorderSide(color: stateColor, width: 4)),
<<<<<<< HEAD
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
=======
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(
                      available ? 'AVAILABLE' : 'OCCUPIED',
                      style: TextStyle(
                        color: stateColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'EGP ${venue['price']} / hr',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
=======
                    Text(available ? 'AVAILABLE' : 'OCCUPIED',
                        style: TextStyle(color: stateColor, fontWeight: FontWeight.w900, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text('EGP ${venue['price']} / hr',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D5AFE).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
<<<<<<< HEAD
                  child: Text(
                    '$slotCount slots',
                    style: const TextStyle(
                      color: Color(0xFF3D5AFE),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
=======
                  child: Text('$slotCount slots',
                      style: const TextStyle(color: Color(0xFF3D5AFE), fontSize: 11, fontWeight: FontWeight.w700)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingTile extends StatelessWidget {
  final Map<String, dynamic> booking;
  const BookingTile({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bool paid = booking['status'] == 'Paid';
<<<<<<< HEAD
    final Color statusColor = paid
        ? const Color(0xFF00E676)
        : Colors.amberAccent;
=======
    final Color statusColor = paid ? const Color(0xFF00E676) : Colors.amberAccent;
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    return Container(
      color: const Color(0xFF0F1115).withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF3D5AFE).withValues(alpha: 0.15),
<<<<<<< HEAD
            child: Text(
              booking['user'].toString().isNotEmpty ? booking['user'][0] : '?',
              style: const TextStyle(
                color: Color(0xFF3D5AFE),
                fontWeight: FontWeight.bold,
              ),
            ),
=======
            child: Text(booking['user'][0], style: const TextStyle(color: Color(0xFF3D5AFE), fontWeight: FontWeight.bold)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  booking['user'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  booking['venue'].toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8B949E),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
=======
                Text(booking['user'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text(booking['venue'].toString().toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF8B949E), fontWeight: FontWeight.bold, letterSpacing: 1)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
              ],
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
<<<<<<< HEAD
              Text(
                booking['time'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              Text(
                booking['date'],
                style: const TextStyle(fontSize: 10, color: Color(0xFF8B949E)),
              ),
=======
              Text(booking['time'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
              const Text('DEPOSIT', style: TextStyle(fontSize: 9, color: Color(0xFF8B949E), fontWeight: FontWeight.w900)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
            ],
          ),
          const SizedBox(width: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
<<<<<<< HEAD
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              booking['status'].toString().toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
=======
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(booking['status'].toString().toUpperCase(),
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900)),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
