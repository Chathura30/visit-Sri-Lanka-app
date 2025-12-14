// lib/screens/food/food_culture_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_card.dart';

class FoodCultureScreen extends StatelessWidget {
  const FoodCultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food & Culture'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Local Food'),
              Tab(text: 'Cultural Tips'),
              Tab(text: 'Do\'s & Don\'ts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFoodTab(),
            _buildCultureTab(),
            _buildDosAndDontsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTab() {
    final foods = [
      {
        'name': 'Rice & Curry',
        'description':
            'Traditional Sri Lankan meal with rice and various curries',
        'icon': '🍛',
        'price': 'LKR 300-600',
      },
      {
        'name': 'Kottu Roti',
        'description': 'Chopped roti mixed with vegetables, eggs, and meat',
        'icon': '🥘',
        'price': 'LKR 400-800',
      },
      {
        'name': 'Hoppers (Appam)',
        'description': 'Bowl-shaped pancakes, often served with egg',
        'icon': '🥞',
        'price': 'LKR 50-150 each',
      },
      {
        'name': 'String Hoppers',
        'description': 'Steamed rice noodle nests',
        'icon': '🍜',
        'price': 'LKR 20-50 each',
      },
      {
        'name': 'Lamprais',
        'description':
            'Dutch-influenced dish with rice, meat, and sides wrapped in banana leaf',
        'icon': '🌯',
        'price': 'LKR 500-900',
      },
      {
        'name': 'Pol Sambol',
        'description': 'Spicy coconut relish',
        'icon': '🥥',
        'price': 'LKR 100-200',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return CustomCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    food['icon']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food['description']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food['price']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCultureTab() {
    final culturalTips = [
      {
        'title': 'Temple Etiquette',
        'icon': Icons.temple_buddhist,
        'tips': [
          'Remove shoes before entering',
          'Dress modestly (cover shoulders and knees)',
          'Don\'t turn your back to Buddha statues',
          'Ask permission before taking photos',
        ],
      },
      {
        'title': 'Greetings',
        'icon': Icons.waving_hand,
        'tips': [
          'Say "Ayubowan" (ah-yoo-bo-wan) for hello',
          'Slight bow with hands together is respectful',
          'Handshakes are common in business settings',
        ],
      },
      {
        'title': 'Festivals',
        'icon': Icons.celebration,
        'tips': [
          'Vesak (May) - Buddhist celebration with lanterns',
          'Sinhala & Tamil New Year (April)',
          'Esala Perahera (July/August) in Kandy',
        ],
      },
      {
        'title': 'Dining Customs',
        'icon': Icons.restaurant,
        'tips': [
          'Eating with right hand is traditional',
          'Try mixing rice and curry with your fingers',
          'Tipping 10% is appreciated but not mandatory',
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: culturalTips.length,
      itemBuilder: (context, index) {
        final tip = culturalTips[index];
        return CustomCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    tip['icon'] as IconData,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    tip['title']! as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...(tip['tips'] as List<String>).map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(t, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDosAndDontsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDosAndDontsCard('Do\'s', AppColors.success, Icons.check_circle, [
          'Respect religious sites and customs',
          'Bargain politely in markets',
          'Try local cuisine',
          'Learn a few Sinhala/Tamil phrases',
          'Dress modestly in religious places',
          'Carry cash as not all places accept cards',
          'Use sun protection',
        ]),
        const SizedBox(height: 16),
        _buildDosAndDontsCard('Don\'ts', AppColors.error, Icons.cancel, [
          'Don\'t touch someone\'s head',
          'Don\'t show affection in public',
          'Don\'t point feet at people or Buddha images',
          'Don\'t wear shoes in temples',
          'Don\'t take photos with Buddha disrespectfully',
          'Don\'t drink tap water',
          'Don\'t waste food',
        ]),
      ],
    );
  }

  Widget _buildDosAndDontsCard(
    String title,
    Color color,
    IconData icon,
    List<String> items,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    title == 'Do\'s' ? Icons.check : Icons.close,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 16)),
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
