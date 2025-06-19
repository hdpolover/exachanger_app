import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';

class AnimatedPinInputWidget extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String, int) onChanged;
  final double animationValue;

  const AnimatedPinInputWidget({
    Key? key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.animationValue,
  }) : super(key: key);

  @override
  State<AnimatedPinInputWidget> createState() => _AnimatedPinInputWidgetState();
}

class _AnimatedPinInputWidgetState extends State<AnimatedPinInputWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _shakeControllers;
  late List<Animation<double>> _shakeAnimations;

  @override
  void initState() {
    super.initState();

    // Initialize shake animations for each PIN field
    _shakeControllers = List.generate(
      6,
      (index) => AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _shakeAnimations = _shakeControllers.map((controller) {
      return Tween(
        begin: 0.0,
        end: 8.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticIn));
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _shakeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void triggerShakeAnimation(int index) {
    _shakeControllers[index].forward().then((_) {
      _shakeControllers[index].reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        // Staggered animation delay for each PIN field
        final delay = index * 0.1;
        final adjustedValue = ((widget.animationValue - delay) / (1 - delay))
            .clamp(0.0, 1.0);

        return AnimatedBuilder(
          animation: _shakeAnimations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimations[index].value, 0),
              child: _buildPinField(index, adjustedValue),
            );
          },
        );
      }),
    );
  }

  Widget _buildPinField(int index, double adjustedValue) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.focusNodes[index],
        widget.controllers[index],
      ]),
      builder: (context, child) {
        final hasValue = widget.controllers[index].text.isNotEmpty;
        final hasFocus = widget.focusNodes[index].hasFocus;

        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()
            ..scale(adjustedValue)
            ..translate(0.0, 20 * (1 - adjustedValue)),
          child: GestureDetector(
            onTap: () {
              widget.focusNodes[index].requestFocus();
              HapticFeedback.selectionClick();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasFocus
                      ? AppColors.colorPrimary
                      : hasValue
                      ? AppColors.colorPrimary.withOpacity(0.5)
                      : Colors.grey[300]!,
                  width: hasFocus ? 2.5 : 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
                color: hasValue
                    ? AppColors.colorPrimary.withOpacity(0.08)
                    : hasFocus
                    ? AppColors.colorPrimary.withOpacity(0.03)
                    : Colors.white,
                boxShadow: hasFocus
                    ? [
                        BoxShadow(
                          color: AppColors.colorPrimary.withOpacity(0.25),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                          color: AppColors.colorPrimary.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : hasValue
                    ? [
                        BoxShadow(
                          color: AppColors.colorPrimary.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple effect when focused
                  if (hasFocus)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Container(
                          width: 50 * value,
                          height: 60 * value,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.colorPrimary.withOpacity(
                              0.05 * value,
                            ),
                          ),
                        );
                      },
                    ),
                  // Text field
                  TextField(
                    controller: widget.controllers[index],
                    focusNode: widget.focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    obscureText: true,
                    style: titleTextStyle.copyWith(
                      fontSize: 24,
                      color: AppColors.colorPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: hasValue ? '' : '•',
                      hintStyle: TextStyle(
                        color: Colors.grey[350],
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onChanged: (value) {
                      widget.onChanged(value, index);
                      // Add haptic feedback
                      if (value.isNotEmpty) {
                        HapticFeedback.lightImpact();
                      }
                    },
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                  ),
                  // Success checkmark animation when field is filled
                  if (hasValue && !hasFocus)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
