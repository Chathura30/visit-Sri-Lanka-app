// lib/providers/alert_provider.dart
import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';
import '../services/connectivity_service.dart';

class AlertProvider with ChangeNotifier {
  List<AlertModel> _alerts = [];
  bool _isLoading = false;
  bool _isOnline = false;
  DateTime _lastSync = DateTime.now();

  List<AlertModel> get alerts => _alerts;
  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  DateTime get lastSync => _lastSync;

  AlertProvider() {
    _init();
  }

  Future<void> _init() async {
    _isOnline = await ConnectivityService.isConnected();
    await loadAlerts();

    ConnectivityService.connectivityStream.listen((connected) {
      _isOnline = connected;
      if (connected) {
        fetchFromFirebase();
      }
      notifyListeners();
    });

    // Auto-refresh alerts every 30 minutes when online
    if (_isOnline) {
      _startAutoRefresh();
    }
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(minutes: 30), () {
      if (_isOnline) {
        fetchFromFirebase();
        _startAutoRefresh();
      }
    });
  }

  Future<void> loadAlerts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _alerts = await DatabaseService.instance.getAllAlerts();

      if (_isOnline) {
        await fetchFromFirebase();
      }
    } catch (e) {
      print('Error loading alerts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFromFirebase() async {
    if (!_isOnline) return;

    try {
      final firebaseAlerts = await FirebaseService.fetchAlerts();

      // Clear old alerts and insert new ones
      await DatabaseService.instance.clearAlerts();
      for (var alert in firebaseAlerts) {
        await DatabaseService.instance.insertAlert(alert);
      }

      _alerts = await DatabaseService.instance.getAllAlerts();
      _lastSync = DateTime.now();
      notifyListeners();
    } catch (e) {
      print('Error fetching alerts: $e');
    }
  }

  List<AlertModel> getAlertsByLocation(String location) {
    return _alerts
        .where((a) => a.location.toLowerCase().contains(location.toLowerCase()))
        .toList();
  }

  List<AlertModel> getActiveAlerts() {
    final now = DateTime.now();
    return _alerts
        .where(
          (a) =>
              a.isActive && now.isAfter(a.validFrom) && now.isBefore(a.validTo),
        )
        .toList();
  }

  List<AlertModel> getAlertsBySeverity(String severity) {
    return _alerts.where((a) => a.severity == severity).toList();
  }
}
