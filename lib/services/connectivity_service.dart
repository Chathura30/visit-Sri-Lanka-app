// lib/core/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamController<bool>? _connectivityStreamController;

  // Check current connectivity status
  static Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isConnectionActive(result);
    } catch (e) {
      return false;
    }
  }

  // Get connectivity type
  static Future<ConnectivityResult> getConnectivityType() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  // Check if specific connection type is active
  static bool _isConnectionActive(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  // Get connectivity status as string
  static Future<String> getConnectivityStatus() async {
    final result = await getConnectivityType();
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.none:
        return 'Offline';
      default:
        return 'Unknown';
    }
  }

  // Stream of connectivity changes
  static Stream<bool> get connectivityStream {
    _connectivityStreamController ??= StreamController<bool>.broadcast();

    _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = _isConnectionActive(result);
      _connectivityStreamController?.add(isConnected);
    });

    return _connectivityStreamController!.stream;
  }

  // Stream of connectivity type changes
  static Stream<ConnectivityResult> get connectivityTypeStream {
    return _connectivity.onConnectivityChanged;
  }

  // Dispose the stream controller
  static void dispose() {
    _connectivityStreamController?.close();
    _connectivityStreamController = null;
  }

  // Wait for connection
  static Future<bool> waitForConnection({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (await isConnected()) return true;

    final completer = Completer<bool>();
    StreamSubscription? subscription;

    subscription = connectivityStream.listen((connected) {
      if (connected && !completer.isCompleted) {
        completer.complete(true);
        subscription?.cancel();
      }
    });

    // Set timeout
    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(false);
        subscription?.cancel();
      }
    });

    return completer.future;
  }

  // Check internet connectivity with actual request
  static Future<bool> hasInternetAccess() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (!_isConnectionActive(result)) return false;

      // You can add actual HTTP request here to verify internet access
      // For example: ping Google DNS or your API server
      return true;
    } catch (e) {
      return false;
    }
  }
}
