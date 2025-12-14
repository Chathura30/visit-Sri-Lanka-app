// lib/screens/trip/trip_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/trip_card.dart';
import '../../widgets/loading_widget.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TripProvider>(context, listen: false).loadTrips(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.trips)),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, _) {
          if (tripProvider.isLoading) {
            return const LoadingWidget(message: 'Loading trips...');
          }

          if (tripProvider.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.luggage_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.noTrips,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: tripProvider.trips.length,
            itemBuilder: (context, index) {
              final trip = tripProvider.trips[index];
              return TripCard(
                trip: trip,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tripDetail,
                    arguments: trip.id,
                  );
                },
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.addEditTrip,
                    arguments: trip,
                  );
                },
                onDelete: () {
                  _showDeleteDialog(context, tripProvider, trip.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addEditTrip);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TripProvider provider,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: const Text('Are you sure you want to delete this trip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTrip(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
