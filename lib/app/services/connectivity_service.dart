import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/flavors/build_config.dart';

/// Service to monitor internet connectivity status
class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();

  final Connectivity _connectivity = Connectivity();
  final logger = BuildConfig.instance.config.logger;

  final RxBool isConnected = true.obs;
  final Rx<ConnectivityResult> connectionType = ConnectivityResult.none.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _debounceTimer;
  // Track previous connection state to avoid duplicate logs
  bool _previouslyConnected = true;
  ConnectivityResult _previousConnectionType = ConnectivityResult.none;
  DateTime? _lastSnackbarShown;

  // Method to show a snackbar when connectivity is lost
  void showConnectivitySnackbar({String? customMessage}) {
    if (!isConnected.value) {
      // Prevent showing snackbar too frequently (minimum 10 seconds apart)
      final now = DateTime.now();
      if (_lastSnackbarShown != null &&
          now.difference(_lastSnackbarShown!).inSeconds < 10) {
        return;
      }
      _lastSnackbarShown = now;

      final message =
          customMessage ??
          'No internet connection. Please check your network settings.';

      Get.snackbar(
        'Connection Lost',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        icon: Icon(Icons.wifi_off, color: Colors.white),
        isDismissible: true,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
            checkConnectivity();
          },
          child: Text(
            'Retry',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  // Method to show a snackbar when connectivity is restored
  void showConnectivityRestoredSnackbar() {
    Get.snackbar(
      'Connection Restored',
      'Internet connection is back online',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      icon: Icon(Icons.wifi, color: Colors.white),
      isDismissible: true,
      borderRadius: 12,
      margin: EdgeInsets.all(16),
    );
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initConnectivity();
    _startListening();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }

  /// Initialize connectivity status
  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      await _updateConnectionStatus(results);
    } catch (e) {
      logger.e('Failed to get connectivity: $e');
      isConnected.value = false;
    }
  }

  /// Start listening to connectivity changes
  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        // Debounce rapid connectivity changes
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 1), () {
          _updateConnectionStatus(results);
        });
      },
      onError: (error) {
        logger.e('Connectivity stream error: $error');
        isConnected.value = false;
      },
    );
  }

  /// Update connection status based on connectivity results
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      connectionType.value =
          ConnectivityResult.none; // Only log if status changed
      if (isConnected.value != false) {
        isConnected.value = false;
        _previouslyConnected = false;
        _previousConnectionType = ConnectivityResult.none;
        logger.w('No internet connection detected');

        // Show snackbar when connection is lost
        showConnectivitySnackbar();
      }
      return;
    }

    // Get the primary connection type
    final primaryConnection = results.first;
    connectionType.value = primaryConnection;

    // For mobile or wifi, verify internet access with a real connectivity test
    if (primaryConnection == ConnectivityResult.mobile ||
        primaryConnection == ConnectivityResult.wifi) {
      final hasInternet = await _hasInternetAccess();

      // Only update and log if the status actually changed
      if (hasInternet != _previouslyConnected ||
          primaryConnection != _previousConnectionType) {
        isConnected.value = hasInternet;
        _previouslyConnected = hasInternet;
        _previousConnectionType = primaryConnection;
        if (hasInternet) {
          // Show restored snackbar only if we were previously disconnected
          if (!_previouslyConnected) {
            showConnectivityRestoredSnackbar();
          }
          logger.i(
            'Internet connection available via ${primaryConnection.name}',
          );
        } else {
          logger.w(
            'Connected to ${primaryConnection.name} but no internet access',
          );
          // Show snackbar for no internet access even when connected to network
          showConnectivitySnackbar(
            customMessage:
                'Connected to ${primaryConnection.name} but no internet access',
          );
        }
      }
    } else {
      // For other connection types, assume connected but only log changes
      if (isConnected.value != true ||
          _previousConnectionType != primaryConnection) {
        // Show restored snackbar only if we were previously disconnected
        if (!_previouslyConnected) {
          showConnectivityRestoredSnackbar();
        }
        isConnected.value = true;
        _previouslyConnected = true;
        _previousConnectionType = primaryConnection;
        logger.i('Connection available via ${primaryConnection.name}');
      }
    }
  }

  /// Perform actual internet connectivity test
  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 10));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      logger.w('Internet access test failed: $e');
      return false;
    }
  }

  /// Force check connectivity status
  Future<void> checkConnectivity() async {
    await _initConnectivity();
  }

  /// Get connection type string for display
  String get connectionTypeString {
    switch (connectionType.value) {
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
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }

  /// Check if connection is suitable for heavy operations
  bool get isSuitableForHeavyOperations {
    return isConnected.value &&
        (connectionType.value == ConnectivityResult.wifi ||
            connectionType.value == ConnectivityResult.ethernet);
  }

  /// Check if connection is mobile data
  bool get isMobileData {
    return isConnected.value &&
        connectionType.value == ConnectivityResult.mobile;
  }
}
