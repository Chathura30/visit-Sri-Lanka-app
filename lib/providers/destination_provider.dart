// lib/providers/destination_provider.dart
import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';
import '../services/connectivity_service.dart';

class DestinationProvider with ChangeNotifier {
  List<DestinationModel> _destinations = [];
  bool _isLoading = false;
  bool _isOnline = false;
  String _selectedProvince = 'All';
  String _selectedCategory = 'All';

  List<DestinationModel> get destinations {
    var filtered = _destinations;

    if (_selectedProvince != 'All') {
      filtered = filtered
          .where((d) => d.province == _selectedProvince)
          .toList();
    }

    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((d) => d.category == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  String get selectedProvince => _selectedProvince;
  String get selectedCategory => _selectedCategory;

  List<String> get provinces => [
    'All',
    'Western',
    'Central',
    'Southern',
    'Northern',
    'Eastern',
    'North Western',
    'North Central',
    'Uva',
    'Sabaragamuwa',
  ];

  List<String> get categories => [
    'All',
    'Beach',
    'Wildlife',
    'Cultural',
    'Hill Country',
    'Adventure',
  ];

  DestinationProvider() {
    _init();
  }

  Future<void> _init() async {
    _isOnline = await ConnectivityService.isConnected();
    await loadDestinations();

    ConnectivityService.connectivityStream.listen((connected) {
      _isOnline = connected;
      if (connected) {
        fetchFromFirebase();
      }
      notifyListeners();
    });
  }

  Future<void> loadDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _destinations = await DatabaseService.instance.getAllDestinations();

      if (_destinations.isEmpty && _isOnline) {
        await fetchFromFirebase();
      }
    } catch (e) {
      print('Error loading destinations: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFromFirebase() async {
    if (!_isOnline) return;

    try {
      final firebaseDestinations = await FirebaseService.getDestinations();
      for (var destination in firebaseDestinations) {
        await DatabaseService.instance.insertDestination(destination);
      }
      _destinations = await DatabaseService.instance.getAllDestinations();
      notifyListeners();
    } catch (e) {
      print('Error fetching destinations: $e');
    }
  }

  void setProvince(String province) {
    _selectedProvince = province;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  DestinationModel? getDestinationById(String id) {
    try {
      return _destinations.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }
}
