import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../logic/nearby_cubit.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    context.read<NearbyCubit>().loadNearby();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Courts'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<NearbyCubit>().loadNearby(),
          ),
        ],
      ),
      body: BlocBuilder<NearbyCubit, NearbyState>(
        builder: (context, state) {
          if (state is NearbyLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 12),
                  Text('Finding nearby courts...'),
                ],
              ),
            );
          }

          if (state is NearbyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<NearbyCubit>().loadNearby(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is NearbyLoaded) {
            return Column(
              children: [
                // Google Map
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        state.position.latitude,
                        state.position.longitude,
                      ),
                      zoom: 14,
                    ),
                    markers: state.markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),

                // قايمة الملاعب
                Expanded(
                  child: state.courts.isEmpty
                      ? const Center(
                          child: Text(
                            'No courts found nearby',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: state.courts.length,
                          itemBuilder: (context, index) {
                            final court = state.courts[index];
                            return _CourtCard(
                              court: court,
                              onTap: () {
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(court['lat'], court['lng']),
                                    16,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _CourtCard extends StatelessWidget {
  final Map<String, dynamic> court;
  final VoidCallback onTap;

  const _CourtCard({required this.court, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.sports_soccer, color: Colors.green),
        ),
        title: Text(
          court['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(court['address']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(court['rating'], style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: court['isOpen']
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                court['isOpen'] ? 'Open' : 'Closed',
                style: TextStyle(
                  fontSize: 10,
                  color: court['isOpen'] ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
