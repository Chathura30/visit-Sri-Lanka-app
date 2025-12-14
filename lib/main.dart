import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:visit_srilanka/screens/auth/auth_gate.dart';

// Providers
import 'providers/trip_provider.dart';
import 'providers/destination_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/alert_provider.dart';

// Constants
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';

// Services
import 'services/auth_service.dart';

// Auth Screens

import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

// Main App Screens
import 'screens/home/home_screen.dart';
import 'screens/trip/trip_list_screen.dart';
import 'screens/trip/trip_detail_screen.dart';
import 'screens/trip/add_edit_trip_screen.dart';
import 'screens/destination/destination_list_screen.dart';
import 'screens/destination/destination_detail_screen.dart';
import 'screens/budget/budget_tracker_screen.dart';
import 'screens/food/food_culture_screen.dart';
import 'screens/alerts/alerts_screen.dart';
import 'screens/reviews/reviews_screen.dart';
import 'screens/emergency/emergency_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize authentication service
  AuthService.initializeAuth();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => DestinationProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: MaterialApp(
        title: 'Visit Sri Lanka',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        home: const AuthGate(),
        routes: {
          // Auth Routes
          AppRoutes.welcome: (context) => const WelcomeScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.signup: (context) => const SignupScreen(),

          // Main App Routes
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.tripList: (context) => const TripListScreen(),
          AppRoutes.tripDetail: (context) => const TripDetailScreen(),
          AppRoutes.addEditTrip: (context) => const AddEditTripScreen(),
          AppRoutes.destinationList: (context) => const DestinationListScreen(),
          AppRoutes.destinationDetail: (context) =>
              const DestinationDetailScreen(),
          AppRoutes.budgetTracker: (context) => const BudgetTrackerScreen(),
          AppRoutes.foodCulture: (context) => const FoodCultureScreen(),
          AppRoutes.alerts: (context) => const AlertsScreen(),
          AppRoutes.reviews: (context) => const ReviewsScreen(),
          AppRoutes.emergency: (context) => const EmergencyScreen(),
        },
      ),
    );
  }
}
