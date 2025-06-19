import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';

class SimplePinInputWidget extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String, int) onChanged;

  const SimplePinInputWidget({
    Key? key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) {
          return Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 50)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    height: 56,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: _buildPinField(index),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPinField(int index) {
    return AnimatedBuilder(
      animation: Listenable.merge([controllers[index], focusNodes[index]]),
      builder: (context, child) {
        final hasValue = controllers[index].text.isNotEmpty;
        final hasFocus = focusNodes[index].hasFocus;

        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasFocus
                  ? AppColors.colorPrimary
                  : hasValue
                  ? AppColors.colorPrimary.withOpacity(0.5)
                  : Colors.grey[300]!,
              width: hasFocus ? 2.0 : 1.5,
            ),
            color: hasValue
                ? AppColors.colorPrimary.withOpacity(0.05)
                : Colors.white,
            boxShadow: hasFocus
                ? [
                    BoxShadow(
                      color: AppColors.colorPrimary.withOpacity(0.15),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
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
              hintText: '•',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            onChanged: (value) {
              onChanged(value, index);
              if (value.isNotEmpty) {
                HapticFeedback.lightImpact();
              }
            },
            onTap: () {
              HapticFeedback.selectionClick();
            },
          ),
        );
      },
    );
  }
}
