// lib/screens/trip/trip_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';
import '../../providers/budget_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/date_helper.dart';
import '../../widgets/custom_card.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tripId = ModalRoute.of(context)!.settings.arguments as String;
    final trip = Provider.of<TripProvider>(context).getTripById(tripId);

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: const Center(child: Text('Trip not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.addEditTrip,
                arguments: trip,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(trip),
            _buildInfoSection(trip),
            _buildCitiesSection(trip),
            _buildExpensesSection(context, trip.id),
            _buildActionsSection(context, trip.id),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.destination,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${DateHelper.formatDate(trip.startDate)} - ${DateHelper.formatDate(trip.endDate)}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(trip) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: CustomCard(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${trip.duration}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Days'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomCard(
              child: Column(
                children: [
                  Icon(
                    Icons.location_city,
                    color: AppColors.secondary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${trip.cities.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Cities'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitiesSection(trip) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cities to Visit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: trip.cities.map<Widget>((city) {
              return Chip(
                label: Text(city),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                avatar: Icon(Icons.place, size: 18, color: AppColors.primary),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesSection(BuildContext context, String tripId) {
    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Budget Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/budget',
                          arguments: tripId,
                        );
                      },
                      child: const Text('View Details'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(
                      'Total Spent: LKR ${budgetProvider.getTotalExpenses().toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionsSection(BuildContext context, String tripId) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/budget', arguments: tripId);
            },
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text('Manage Budget'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/alerts');
            },
            icon: const Icon(Icons.warning),
            label: const Text('View Local Alerts'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
          ),
        ],
      ),
    );
  }
}
