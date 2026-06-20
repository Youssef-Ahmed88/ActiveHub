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
    await Future.wait([
      _loadVenues(),
      _loadBookings(),
      _loadPayments(),
    ]);
    setState(() => isLoading = false);
  }
 
  Future<void> _loadVenues() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/owner/courts');
      final List data = response.data['data'];
      setState(() {
        venues = data.map((v) => {
          'id': v['id'].toString(),
          'name': v['name'],
          'sport': v['sport']?['name'] ?? '',
          'price': double.parse(v['price_per_hour'].toString()).toInt(),
          'isAvailable': v['is_available'] == 1,
        }).toList();
      });
    } catch (e) {
      debugPrint('Error loading venues: $e');
    }
  }
 
  Future<void> _loadBookings() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/owner/bookings');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      setState(() {
        bookings = data.map((b) => {
          'id': b['id'].toString(),
          'user': 'User #${b['user_id']}',
          'venue': b['court']?['name'] ?? '',
          'time': b['start_time'].toString().split('T').last.split('.').first,
          'status': b['status'] == 'confirmed' ? 'Paid' : 'Pending',
        }).toList();
      });
    } catch (e) {
      debugPrint('Error loading bookings: $e');
    }
  }
 
  Future<void> _loadPayments() async {
    try {
      final dio = getIt<Dio>();
      // Get payments from owner bookings
      final response = await dio.get('/owner/bookings');
      final List data = response.data is List
          ? response.data
          : (response.data['data'] ?? []);
      setState(() {
        payments = data
            .where((b) => b['status'] == 'confirmed')
            .map((b) => {
                  'id': b['id'].toString(),
                  'user': 'User #${b['user_id']}',
                  'amount': double.parse(b['total_price'].toString()).toInt(),
                  'method': 'Credit Card',
                  'status': 'Paid',
                })
            .toList();
      });
    } catch (e) {
      debugPrint('Error loading payments: $e');
    }
  }
 
  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.loginScreen, (route) => false);
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
                            constraints:
                                const BoxConstraints(maxWidth: 1200),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon:
                  const Icon(Icons.logout, color: Colors.white, size: 18),
              label: const Text("Logout",
                  style: TextStyle(color: Colors.white)),
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
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF3D5AFE).withValues(alpha: 0.3),
                    blurRadius: 10)
              ],
            ),
            child: const Icon(Icons.emoji_events,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('OwnerHub',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: -0.5)),
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
        leading: Icon(icon,
            color: active
                ? const Color(0xFF3D5AFE)
                : const Color(0xFF8B949E),
            size: 22),
        title: Text(label,
            style: TextStyle(
                color:
                    active ? Colors.white : const Color(0xFF8B949E),
                fontSize: 14,
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal)),
        tileColor: active
            ? const Color(0xFF3D5AFE).withValues(alpha: 0.1)
            : null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
 
  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: Color(0xFF30363D)))),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF3D5AFE),
            child:
                Icon(Icons.person, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Owner',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white)),
                Text('Stadium Owner',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B949E))),
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
                Text(titles[_selectedIndex],
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1)),
                const SizedBox(height: 6),
                const Text(
                    'Monitor your stadium fields and activities',
                    style: TextStyle(
                        color: Color(0xFF8B949E), fontSize: 14)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    border: Border.all(
                        color: const Color(0xFF30363D)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Updated: Just Now',
                      style: TextStyle(
                          color: Color(0xFF8B949E),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
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
                    Text(titles[_selectedIndex],
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1)),
                    const SizedBox(height: 4),
                    const Text(
                        'Monitor your stadium fields and activities',
                        style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 14)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    border: Border.all(
                        color: const Color(0xFF30363D)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Updated: Just Now',
                      style: TextStyle(
                          color: Color(0xFF8B949E),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
 
  Widget _buildActiveTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAvailabilityTab();
      case 1:
        return _buildBookingsTab();
      case 2:
        return _buildFinancialsTab();
      default:
        return const SizedBox();
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
            Text('Field Status',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        const SizedBox(height: 24),
        venues.isEmpty
            ? const Center(
                child: Text('No venues found',
                    style: TextStyle(color: Colors.white70)))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 1200
                          ? 3
                          : (MediaQuery.of(context).size.width > 700
                              ? 2
                              : 1),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  mainAxisExtent: 180,
                ),
                itemCount: venues.length,
                itemBuilder: (context, index) => VenueCard(
                  venue: venues[index],
                  onToggle: () async {
                    try {
                      final dio = getIt<Dio>();
                      await dio.put(
                          '/courts/${venues[index]['id']}',
                          data: {
                            'is_available':
                                venues[index]['isAvailable'] ? 0 : 1,
                          });
                      await _loadVenues();
                    } catch (e) {
                      debugPrint('Error toggling venue: $e');
                    }
                  },
                  onManageSlots: () =>
                      _showManageSlotsDialog(venues[index]),
                ),
              ),
      ],
    );
  }
 
  Widget _buildStatsGrid() {
    final paidCount =
        bookings.where((b) => b['status'] == 'Paid').length;
    final pendingCount =
        bookings.where((b) => b['status'] == 'Pending').length;
    final totalRevenue =
        payments.fold(0, (sum, p) => sum + (p['amount'] as int));
 
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
          StatCard(
              label: 'TOTAL REVENUE',
              value: 'EGP $totalRevenue',
              accent: 'All time',
              accentColor: const Color(0xFF00E676)),
          StatCard(
              label: 'ACTIVE BOOKINGS',
              value: '$paidCount',
              accent: 'Confirmed',
              accentColor: const Color(0xFF3D5AFE)),
          StatCard(
              label: 'PENDING',
              value: '$pendingCount',
              accent: 'Awaiting',
              accentColor: Colors.amberAccent),
        ],
      );
    });
  }
 
  void _showManageSlotsDialog(Map<String, dynamic> venue) {
    final venueId = venue['id'].toString();
    List<String> tempSlots =
        List.from(VenueSlotsStore.getSlots(venueId));
 
    const allPossibleSlots = [
      '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
      '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM',
      '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM',
    ];
 
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF161B22),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.access_time,
                  color: Color(0xFF3D5AFE), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    'Manage Slots — ${venue['name']}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
              ),
            ],
          ),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Toggle which time slots are available for users to book:',
                    style: TextStyle(
                        color: Color(0xFF8B949E),
                        fontSize: 12,
                        height: 1.5)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setS(() =>
                          tempSlots = List.from(allPossibleSlots)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D5AFE)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF3D5AFE)
                                  .withValues(alpha: 0.3)),
                        ),
                        child: const Text('Select All',
                            style: TextStyle(
                                color: Color(0xFF3D5AFE),
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setS(() => tempSlots = []),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.red
                                  .withValues(alpha: 0.3)),
                        ),
                        child: const Text('Clear All',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const Spacer(),
                    Text('${tempSlots.length} active',
                        style: const TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 12)),
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
                          tempSlots.sort((a, b) =>
                              allPossibleSlots
                                  .indexOf(a)
                                  .compareTo(
                                      allPossibleSlots.indexOf(b)));
                        }
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF3D5AFE)
                              : const Color(0xFF0F1115),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: isActive
                                  ? const Color(0xFF3D5AFE)
                                  : const Color(0xFF30363D)),
                        ),
                        child: Text(slot,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF8B949E),
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            )),
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
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF8B949E))),
            ),
            ElevatedButton(
              onPressed: () {
                VenueSlotsStore.setSlots(venueId, tempSlots);
                setState(() {});
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Slots updated for ${venue['name']}'),
                    backgroundColor: const Color(0xFF00E676),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D5AFE),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save Changes',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
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
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Incoming Bookings',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const Divider(height: 1, color: Color(0xFF30363D)),
          bookings.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                      child: Text('No bookings found',
                          style:
                              TextStyle(color: Colors.white70))),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  separatorBuilder: (_, _) => const Divider(
                      height: 1, color: Color(0xFF30363D)),
                  itemBuilder: (context, index) =>
                      BookingTile(booking: bookings[index]),
                ),
        ],
      ),
    );
  }
 
  Widget _buildFinancialsTab() {
    final totalDeposits =
        payments.fold(0, (sum, p) => sum + (p['amount'] as int));
    final paidCount = payments.length;
    final pendingCount =
        bookings.where((b) => b['status'] == 'Pending').length;
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              StatCard(
                  label: 'TOTAL COLLECTED',
                  value: 'EGP $totalDeposits',
                  accent: 'All time',
                  accentColor: const Color(0xFF00E676)),
              StatCard(
                  label: 'PAID BOOKINGS',
                  value: '$paidCount',
                  accent: 'Confirmed',
                  accentColor: const Color(0xFF3D5AFE)),
              StatCard(
                  label: 'PENDING PAYMENTS',
                  value: '$pendingCount',
                  accent: 'Awaiting',
                  accentColor: Colors.amberAccent),
            ],
          );
        }),
        const SizedBox(height: 36),
        const Row(
          children: [
            Icon(Icons.receipt_long,
                color: Color(0xFF3D5AFE), size: 20),
            SizedBox(width: 8),
            Text('Transactions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
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
                  child: Center(
                      child: Text('No transactions found',
                          style:
                              TextStyle(color: Colors.white70))),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: payments.length,
                  separatorBuilder: (_, _) => const Divider(
                      height: 1, color: Color(0xFF30363D)),
                  itemBuilder: (context, i) {
                    final p = payments[i];
                    const statusColor = Color(0xFF00E676);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: statusColor
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(
                                Icons.arrow_downward,
                                color: statusColor,
                                size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(p['user'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 14)),
                                Text(p['method'],
                                    style: const TextStyle(
                                        color: Color(0xFF8B949E),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text('+EGP ${p['amount']}',
                                  style: const TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14)),
                              const Text('PAID',
                                  style: TextStyle(
                                      color: Color(0xFF8B949E),
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.bold)),
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
      selectedLabelStyle:
          const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on), label: 'VENUE'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'BOOKINGS'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'WALLET'),
        BottomNavigationBarItem(
            icon: Icon(Icons.logout), label: 'LOGOUT'),
      ],
    );
  }
}
 
class StatCard extends StatelessWidget {
  final String label, value, accent;
  final Color accentColor;
  const StatCard(
      {super.key,
      required this.label,
      required this.value,
      required this.accent,
      required this.accentColor});
 
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
 
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
          Text(label,
              style: TextStyle(
                  fontSize: isMobile ? 9 : 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B949E),
                  letterSpacing: 2)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: isMobile ? 22 : 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Text(accent,
                  style: TextStyle(
                      color: accentColor,
                      fontSize: isMobile ? 11 : 13,
                      fontWeight: FontWeight.bold)),
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
 
  const VenueCard({
    super.key,
    required this.venue,
    required this.onToggle,
    required this.onManageSlots,
  });
 
  @override
  Widget build(BuildContext context) {
    final bool available = venue['isAvailable'];
    final Color stateColor = available
        ? const Color(0xFF00E676)
        : const Color(0xFFF44336);
    final int slotCount =
        VenueSlotsStore.getSlots(venue['id'].toString()).length;
 
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
                      decoration: BoxDecoration(
                          color:
                              stateColor.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(12)),
                      child: Icon(
                          available ? Icons.bolt : Icons.block,
                          color: stateColor,
                          size: 20),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(venue['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        Text(
                            venue['sport']
                                .toString()
                                .toUpperCase(),
                            style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF8B949E),
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  color: const Color(0xFF161B22),
                  icon: const Icon(Icons.more_vert,
                      color: Color(0xFF8B949E)),
                  onSelected: (v) {
                    if (v == 'toggle') onToggle();
                    if (v == 'slots') onManageSlots();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(
                          available
                              ? 'Mark Occupied'
                              : 'Mark Available',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13)),
                    ),
                    const PopupMenuItem(
                      value: 'slots',
                      child: Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Color(0xFF3D5AFE),
                              size: 16),
                          SizedBox(width: 8),
                          Text('Manage Time Slots',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1115).withValues(alpha: 0.5),
              border: Border(
                  left: BorderSide(
                      color: stateColor, width: 4)),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        available ? 'AVAILABLE' : 'OCCUPIED',
                        style: TextStyle(
                            color: stateColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 13)),
                    const SizedBox(height: 2),
                    Text('EGP ${venue['price']} / hr',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D5AFE)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('$slotCount slots',
                      style: const TextStyle(
                          color: Color(0xFF3D5AFE),
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
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
    final Color statusColor =
        paid ? const Color(0xFF00E676) : Colors.amberAccent;
    return Container(
      color: const Color(0xFF0F1115).withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                const Color(0xFF3D5AFE).withValues(alpha: 0.15),
            child: Text(booking['user'][0],
                style: const TextStyle(
                    color: Color(0xFF3D5AFE),
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking['user'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(booking['venue'].toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF8B949E),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
              ],
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(booking['time'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13)),
              const Text('DEPOSIT',
                  style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF8B949E),
                      fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(width: 32),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4)),
            child: Text(
                booking['status'].toString().toUpperCase(),
                style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}