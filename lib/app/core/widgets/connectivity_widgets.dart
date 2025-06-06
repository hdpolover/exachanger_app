import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/connectivity_service.dart';

/// Widget that shows connectivity status at the top of the screen
class ConnectivityStatusBar extends GetWidget<ConnectivityService> {
  const ConnectivityStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isConnected.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.red.shade700,
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No internet connection',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: () => controller.checkConnectivity(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Floating connectivity indicator for when you need a less intrusive indicator
class ConnectivityFloatingIndicator extends GetWidget<ConnectivityService> {
  const ConnectivityFloatingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isConnected.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No Internet Connection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Please check your connection and try again',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => controller.checkConnectivity(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// Simple connectivity dot indicator
class ConnectivityDotIndicator extends GetWidget<ConnectivityService> {
  final double size;

  const ConnectivityDotIndicator({super.key, this.size = 8});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: controller.isConnected.value ? Colors.green : Colors.red,
        ),
      );
    });
  }
}

/// Widget that rebuilds based on connectivity status
class ConnectivityBuilder extends GetWidget<ConnectivityService> {
  final Widget Function(BuildContext context, bool isConnected) builder;

  const ConnectivityBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Obx(() => builder(context, controller.isConnected.value));
  }
}
