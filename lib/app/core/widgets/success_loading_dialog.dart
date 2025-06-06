import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SuccessLoadingDialog extends StatefulWidget {
  final String? message;
  final String? successMessage;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onSuccess;

  const SuccessLoadingDialog({
    Key? key,
    this.message,
    this.successMessage,
    this.backgroundColor,
    this.textColor,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<SuccessLoadingDialog> createState() => _SuccessLoadingDialogState();
}

class _SuccessLoadingDialogState extends State<SuccessLoadingDialog>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _successController;
  late Animation<double> _scaleAnimation;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _successController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _loadingController.forward();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void showSuccess() {
    setState(() {
      _showSuccess = true;
    });
    _successController.forward().then((_) {
      // Auto close after showing success
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          widget.onSuccess?.call();
          Get.back();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animation container
            SizedBox(
              width: 100,
              height: 100,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _showSuccess
                    ? ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60,
                          ),
                        ),
                      )
                    : Lottie.asset(
                        'assets/lottie/loading.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        controller: _loadingController,
                        repeat: true,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // Message text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                _showSuccess
                    ? (widget.successMessage ?? 'Success!')
                    : (widget.message ?? 'Processing...'),
                key: ValueKey(_showSuccess),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor ?? Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            if (!_showSuccess)
              _PulsingDots(color: widget.textColor ?? Colors.black54),
          ],
        ),
      ),
    );
  }
}

class _PulsingDots extends StatefulWidget {
  final Color color;

  const _PulsingDots({Key? key, required this.color}) : super(key: key);

  @override
  _PulsingDotsState createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Text(
            'Please wait...',
            style: TextStyle(fontSize: 12, color: widget.color),
          ),
        );
      },
    );
  }
}

// Quick show success method for easy use
void showSuccessDialog({
  required String message,
  String? successMessage,
  VoidCallback? onSuccess,
}) {
  final dialog = SuccessLoadingDialog(
    message: message,
    successMessage: successMessage,
    onSuccess: onSuccess,
  );

  Get.dialog(dialog, barrierDismissible: false);

  // Show success after 2 seconds (simulate processing time)
  Future.delayed(const Duration(milliseconds: 2000), () {
    if (Get.isDialogOpen ?? false) {
      (dialog as dynamic).showSuccess();
    }
  });
}
