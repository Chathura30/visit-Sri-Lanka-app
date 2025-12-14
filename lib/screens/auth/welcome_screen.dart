// lib/screens/auth/welcome_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.9),
              AppColors.secondary.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo and Title
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🇱🇰', style: TextStyle(fontSize: 60)),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome to',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Visit Sri Lanka',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Smart Travel Companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                // Feature highlights
                _buildFeatureRow(Icons.map, 'Plan Your Perfect Trip'),
                const SizedBox(height: 12),
                _buildFeatureRow(Icons.explore, 'Explore Destinations'),
                const SizedBox(height: 12),
                _buildFeatureRow(
                  Icons.notifications_active,
                  'Live Travel Alerts',
                ),
                const SizedBox(height: 12),
                _buildFeatureRow(Icons.offline_bolt, 'Works Offline'),

                const Spacer(),

                // Buttons
                CustomButton(
                  text: 'Get Started',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signup);
                  },
                  color: Colors.white,
                  textColor: AppColors.primary,
                  icon: Icons.arrow_forward,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'I Already Have an Account',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  isOutlined: true,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
