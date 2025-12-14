// lib/screens/destination/destination_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/destination_provider.dart';
import '../../core/constants/app_colors.dart';

class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destinationId = ModalRoute.of(context)!.settings.arguments as String;
    final destination = Provider.of<DestinationProvider>(
      context,
    ).getDestinationById(destinationId);

    if (destination == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Destination')),
        body: const Center(child: Text('Destination not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(destination.name),
              background: destination.imageUrl.isNotEmpty
                  ? Image.network(
                      destination.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.landscape,
                          size: 120,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.landscape,
                        size: 120,
                        color: AppColors.primary,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(destination.province),
                        avatar: const Icon(Icons.location_on, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(destination.category),
                        backgroundColor: AppColors.secondary.withOpacity(0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    destination.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.wb_sunny, color: AppColors.accent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Best Time to Visit',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(destination.bestTimeToVisit),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
