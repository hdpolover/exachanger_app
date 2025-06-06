import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../values/app_colors.dart';

class AnimatedCustomButton extends StatefulWidget {
  const AnimatedCustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isReverseButton = false,
    this.isSmallBtn = false,
    this.isLoading = false,
    this.loadingText,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final String label;
  final VoidCallback onPressed;
  final bool isReverseButton;
  final bool isSmallBtn;
  final bool isLoading;
  final String? loadingText;
  final Duration animationDuration;

  @override
  State<AnimatedCustomButton> createState() => _AnimatedCustomButtonState();
}

class _AnimatedCustomButtonState extends State<AnimatedCustomButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedCustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handlePress() {
    if (!widget.isLoading) {
      // Add haptic feedback for better user experience
      HapticFeedback.lightImpact();

      // Add a small tap animation
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: FilledButton(
              onPressed: widget.isLoading ? null : _handlePress,
              style: ButtonStyle(
                maximumSize: WidgetStateProperty.all(
                  Size(double.infinity, widget.isSmallBtn ? 40 : 56),
                ),
                minimumSize: WidgetStateProperty.all(
                  Size(double.infinity, widget.isSmallBtn ? 40 : 56),
                ),
                backgroundColor: widget.isLoading
                    ? WidgetStateProperty.all(Colors.grey.shade400)
                    : widget.isReverseButton
                    ? WidgetStateProperty.all(Colors.white)
                    : WidgetStateProperty.all(AppColors.colorPrimary),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: widget.isSmallBtn ? 5 : 16,
                    horizontal: 24,
                  ),
                ),
                elevation: WidgetStateProperty.all(1),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SpinKitThreeBounce(
                            color: Colors.white,
                            size: widget.isSmallBtn ? 16 : 20,
                          ),
                          if (widget.loadingText != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              widget.loadingText!,
                              style: regularBodyTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: widget.isSmallBtn ? 12 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      )
                    : Text(
                        widget.label,
                        style: regularBodyTextStyle.copyWith(
                          color: widget.isReverseButton
                              ? AppColors.colorPrimary
                              : Colors.white,
                          fontSize: widget.isSmallBtn ? 12 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Enhanced version with pulse animation
class PulseAnimatedButton extends StatefulWidget {
  const PulseAnimatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isReverseButton = false,
    this.isSmallBtn = false,
    this.isLoading = false,
    this.loadingText,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isReverseButton;
  final bool isSmallBtn;
  final bool isLoading;
  final String? loadingText;

  @override
  State<PulseAnimatedButton> createState() => _PulseAnimatedButtonState();
}

class _PulseAnimatedButtonState extends State<PulseAnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PulseAnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isLoading ? _pulseAnimation.value : 1.0,
          child: FilledButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    if (!widget.isLoading) {
                      HapticFeedback.lightImpact();
                      widget.onPressed();
                    }
                  },
            style: ButtonStyle(
              maximumSize: WidgetStateProperty.all(
                Size(double.infinity, widget.isSmallBtn ? 40 : 56),
              ),
              minimumSize: WidgetStateProperty.all(
                Size(double.infinity, widget.isSmallBtn ? 40 : 56),
              ),
              backgroundColor: widget.isLoading
                  ? WidgetStateProperty.all(Colors.grey.shade400)
                  : widget.isReverseButton
                  ? WidgetStateProperty.all(Colors.white)
                  : WidgetStateProperty.all(AppColors.colorPrimary),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(
                  vertical: widget.isSmallBtn ? 5 : 16,
                  horizontal: 24,
                ),
              ),
              elevation: WidgetStateProperty.all(1),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: widget.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: widget.isSmallBtn ? 16 : 20,
                          height: widget.isSmallBtn ? 16 : 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        if (widget.loadingText != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            widget.loadingText!,
                            style: regularBodyTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: widget.isSmallBtn ? 12 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Text(
                      widget.label,
                      style: regularBodyTextStyle.copyWith(
                        color: widget.isReverseButton
                            ? AppColors.colorPrimary
                            : Colors.white,
                        fontSize: widget.isSmallBtn ? 12 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
