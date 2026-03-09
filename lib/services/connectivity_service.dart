// lib/services/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService with ChangeNotifier {
  bool _hasInternet = true;
  StreamSubscription? _subscription;

  bool get hasInternet => _hasInternet;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    await _checkConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final isConnected = !results.contains(ConnectivityResult.none);
    if (isConnected != _hasInternet) {
      _hasInternet = isConnected;
      notifyListeners();
    }
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    final isConnected = !result.contains(ConnectivityResult.none);
    if (isConnected != _hasInternet) {
      _hasInternet = isConnected;
      notifyListeners();
    }
  }

  Future<void> retryConnection() => _checkConnectivity();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}