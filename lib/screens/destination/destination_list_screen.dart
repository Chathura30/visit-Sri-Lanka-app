// lib/screens/destination/destination_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/destination_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../widgets/loading_widget.dart';

class DestinationListScreen extends StatefulWidget {
  const DestinationListScreen({super.key});

  @override
  State<DestinationListScreen> createState() => _DestinationListScreenState();
}

class _DestinationListScreenState extends State<DestinationListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<DestinationProvider>(
        context,
        listen: false,
      ).loadDestinations(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Destinations')),
      body: Consumer<DestinationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading destinations...');
          }

          return Column(
            children: [
              _buildFilters(provider),
              Expanded(
                child: provider.destinations.isEmpty
                    ? const Center(child: Text('No destinations found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.destinations.length,
                        itemBuilder: (context, index) {
                          final destination = provider.destinations[index];
                          return _buildDestinationCard(context, destination);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(DestinationProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: provider.selectedProvince,
            decoration: InputDecoration(
              labelText: 'Province',
              prefixIcon: Icon(Icons.map, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: provider.provinces.map((province) {
              return DropdownMenuItem(value: province, child: Text(province));
            }).toList(),
            onChanged: (value) {
              if (value != null) provider.setProvince(value);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: provider.selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: provider.categories.map((category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: (value) {
              if (value != null) provider.setCategory(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(BuildContext context, destination) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.destinationDetail,
            arguments: destination.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 200,
                width: double.infinity,
                color: AppColors.primary.withOpacity(0.1),
                child: destination.imageUrl.isNotEmpty
                    ? Image.network(
                        destination.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.landscape,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      )
                    : Icon(Icons.landscape, size: 80, color: AppColors.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        destination.province,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          destination.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    destination.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, size: 16, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        'Best time: ${destination.bestTimeToVisit}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
