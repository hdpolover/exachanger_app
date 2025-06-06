import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/connectivity_service.dart';

/// Simple banner widget for showing connectivity status
class ConnectivityStatusWidget extends StatelessWidget {
  const ConnectivityStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();
    return Obx(
      () => connectivityService.isConnected.value
          ? const SizedBox.shrink()
          : Material(
              color: Colors.red,
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'No Internet Connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/// A simple connectivity indicator dot
class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Obx(
      () => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: connectivityService.isConnected.value
              ? Colors.green
              : Colors.red,
        ),
      ),
    );
  }
}
