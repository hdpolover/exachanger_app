import 'package:flutter/material.dart';

/// Widget that wraps the main app content
/// Connectivity issues are now handled via snackbars from the ConnectivityService
class ConnectivityOverlayWidget extends StatelessWidget {
  final Widget child;

  const ConnectivityOverlayWidget({Key? key, required this.child})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Simply return the child without any overlay
    // Connectivity issues will be handled via snackbars from the ConnectivityService
    return child;
  }
}
