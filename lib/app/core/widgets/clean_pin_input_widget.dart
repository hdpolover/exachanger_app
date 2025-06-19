import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';

class CleanPinInputWidget extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String, int) onChanged;
  final double animationValue;
  const CleanPinInputWidget({
    Key? key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.animationValue,
  }) : super(key: key);

  @override
  State<CleanPinInputWidget> createState() => _CleanPinInputWidgetState();
}

class _CleanPinInputWidgetState extends State<CleanPinInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return _buildPinField(index);
        }),
      ),
    );
  }

  Widget _buildPinField(int index) {
    // Staggered animation for entrance
    final delay = index * 100; // milliseconds

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Container(
            width: 45,
            height: 55,
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: _buildInputField(index),
          ),
        );
      },
    );
  }

  Widget _buildInputField(int index) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controllers[index],
      builder: (context, value, child) {
        final hasValue = value.text.isNotEmpty;
        final hasFocus = widget.focusNodes[index].hasFocus;

        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasFocus
                  ? AppColors.colorPrimary
                  : hasValue
                  ? AppColors.colorPrimary.withOpacity(0.6)
                  : Colors.grey[300]!,
              width: hasFocus ? 2.0 : 1.5,
            ),
            color: hasValue
                ? AppColors.colorPrimary.withOpacity(0.05)
                : Colors.white,
            boxShadow: hasFocus
                ? [
                    BoxShadow(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: Center(
            child: TextField(
              controller: widget.controllers[index],
              focusNode: widget.focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              obscureText: true,
              style: titleTextStyle.copyWith(
                fontSize: 20,
                color: AppColors.colorPrimary,
                fontWeight: FontWeight.w600,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: hasValue ? '' : '•',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onChanged: (value) {
                widget.onChanged(value, index);
                if (value.isNotEmpty) {
                  HapticFeedback.lightImpact();
                }
              },
              onTap: () {
                HapticFeedback.selectionClick();
              },
            ),
          ),
        );
      },
    );
  }
}
