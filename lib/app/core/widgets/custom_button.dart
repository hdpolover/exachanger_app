import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.isReverseButton = false,
      this.isSmallBtn = false});

  final String label;
  final VoidCallback onPressed;
  final bool isReverseButton;
  final bool isSmallBtn;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: WidgetStateProperty.all(
            Size(double.infinity, isSmallBtn ? 40 : 56)),
        minimumSize: WidgetStateProperty.all(
            Size(double.infinity, isSmallBtn ? 40 : 56)),
        backgroundColor: isReverseButton
            ? WidgetStateProperty.all(Colors.white)
            : WidgetStateProperty.all(AppColors.colorPrimary),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: isSmallBtn ? 5 : 16,
            horizontal: 24,
          ),
        ),
        // elevation: WidgetStateProperty.all(0),
        elevation: WidgetStateProperty.all(1),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      child: Text(
        label,
        style: regularBodyTextStyle.copyWith(
          color: isReverseButton ? AppColors.colorPrimary : Colors.white,
          fontSize: isSmallBtn ? 12 : 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
