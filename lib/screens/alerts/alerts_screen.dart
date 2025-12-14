// lib/screens/alerts/alerts_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/alert_provider.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/loading_widget.dart';
import '../../core/utils/date_helper.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AlertProvider>(context, listen: false).loadAlerts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Conditions & Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AlertProvider>(
                context,
                listen: false,
              ).fetchFromFirebase();
            },
          ),
        ],
      ),
      body: Consumer<AlertProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading alerts...');
          }

          final alerts = provider.getActiveAlerts();

          return Column(
            children: [
              _buildSyncInfo(provider),
              Expanded(
                child: alerts.isEmpty
                    ? const Center(child: Text('No active alerts at this time'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: alerts.length,
                        itemBuilder: (context, index) {
                          return AlertCard(alert: alerts[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSyncInfo(AlertProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: provider.isOnline ? Colors.green[50] : Colors.orange[50],
      child: Row(
        children: [
          Icon(
            provider.isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: provider.isOnline ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.isOnline ? 'Connected' : 'Offline Mode',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Last updated: ${DateHelper.getRelativeTime(provider.lastSync)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
