// lib/providers/trip_provider.dart
import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';
import '../services/connectivity_service.dart';

class TripProvider with ChangeNotifier {
  List<TripModel> _trips = [];
  bool _isLoading = false;
  bool _isOnline = false;

  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;

  TripProvider() {
    _init();
  }

  String? get userId => null;

  Future<void> _init() async {
    _isOnline = await ConnectivityService.isConnected();
    await loadTrips();

    ConnectivityService.connectivityStream.listen((connected) {
      _isOnline = connected;
      if (connected) {
        syncTrips();
      }
      notifyListeners();
    });
  }

  Future<void> loadTrips() async {
    _isLoading = true;
    notifyListeners();

    try {
      _trips = await DatabaseService.instance.getAllTrips();

      if (_isOnline) {
        await syncTrips();
      }
    } catch (e) {
      print('Error loading trips: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTrip(TripModel trip) async {
    await DatabaseService.instance.insertTrip(trip);
    _trips.add(trip);

    if (_isOnline) {
      await FirebaseService.syncTrip(trip);
    }

    notifyListeners();
  }

  Future<void> updateTrip(TripModel trip) async {
    await DatabaseService.instance.updateTrip(trip);
    final index = _trips.indexWhere((t) => t.id == trip.id);
    if (index != -1) {
      _trips[index] = trip;
    }

    if (_isOnline) {
      await FirebaseService.syncTrip(trip);
    }

    notifyListeners();
  }

  Future<void> deleteTrip(String id) async {
    await DatabaseService.instance.deleteTrip(id);
    _trips.removeWhere((t) => t.id == id);

    if (_isOnline) {
      await FirebaseService.deleteTrip(id);
    }

    notifyListeners();
  }

  Future<void> syncTrips() async {
    if (!_isOnline) return;
    if (userId == null) return; // Guard against null userId

    try {
      // Sync local trips to Firebase
      for (var trip in _trips.where((t) => !t.isSynced)) {
        await FirebaseService.syncTrip(trip);
        await DatabaseService.instance.updateTrip(
          trip.copyWith(isSynced: true),
        );
      }

      // Fetch trips from Firebase
      final firebaseTrips = await FirebaseService.fetchTrips(userId!);
      for (var trip in firebaseTrips) {
        final exists = _trips.any((t) => t.id == trip.id);
        if (!exists) {
          await DatabaseService.instance.insertTrip(trip);
          _trips.add(trip);
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error syncing trips: $e');
    }
  }

  TripModel? getTripById(String id) {
    try {
      return _trips.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
