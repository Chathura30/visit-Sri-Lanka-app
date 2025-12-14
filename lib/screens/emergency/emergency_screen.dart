// lib/screens/emergency/emergency_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_card.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Help'),
        backgroundColor: AppColors.error,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningBanner(),
            const SizedBox(height: 24),
            _buildEmergencyNumbers(),
            const SizedBox(height: 24),
            _buildEmbassyInfo(),
            const SizedBox(height: 24),
            _buildHospitalInfo(),
            const SizedBox(height: 24),
            _buildSafetyTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: AppColors.error, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'In case of emergency, call 119 or the relevant emergency service immediately',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumbers() {
    final numbers = [
      {
        'title': 'Police Emergency',
        'number': '119',
        'icon': Icons.local_police,
      },
      {'title': 'Ambulance', 'number': '110', 'icon': Icons.local_hospital},
      {
        'title': 'Fire Service',
        'number': '111',
        'icon': Icons.local_fire_department,
      },
      {
        'title': 'Tourist Police',
        'number': '1912',
        'icon': Icons.support_agent,
      },
      {'title': 'Accident Service', 'number': '1990', 'icon': Icons.car_crash},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emergency Numbers',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...numbers.map(
          (contact) => _buildContactCard(
            contact['title']! as String,
            contact['number']! as String,
            contact['icon']! as IconData,
            AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildEmbassyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Embassy Contacts',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            children: [
              _buildInfoRow('US Embassy', '+94 11 249 8500'),
              const Divider(),
              _buildInfoRow('UK High Commission', '+94 11 539 0639'),
              const Divider(),
              _buildInfoRow('Australian High Commission', '+94 11 246 3200'),
              const Divider(),
              _buildInfoRow('Indian High Commission', '+94 11 242 1605'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Major Hospitals',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          'National Hospital Colombo',
          '+94 11 269 1111',
          Icons.local_hospital,
          AppColors.primary,
        ),
        _buildContactCard(
          'Asiri Central Hospital',
          '+94 11 466 5500',
          Icons.local_hospital,
          AppColors.primary,
        ),
        _buildContactCard(
          'Nawaloka Hospital',
          '+94 11 554 4444',
          Icons.local_hospital,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildSafetyTips() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: AppColors.success, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Safety Tips',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem('Keep your embassy contact saved'),
          _buildTipItem('Always carry a copy of your passport'),
          _buildTipItem('Share your itinerary with family/friends'),
          _buildTipItem('Keep emergency cash separate'),
          _buildTipItem('Download offline maps'),
          _buildTipItem('Know your hotel address in local language'),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    String number,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        Clipboard.setData(ClipboardData(text: number));
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.phone, color: color),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
