import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.isReverseButton = false});

  final String label;
  final VoidCallback onPressed;
  final bool isReverseButton;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: WidgetStateProperty.all(Size(double.infinity, 56)),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 56)),
        backgroundColor: isReverseButton
            ? WidgetStateProperty.all(Colors.white)
            : WidgetStateProperty.all(AppColors.colorPrimary),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
        ),
        // elevation: WidgetStateProperty.all(0),
        elevation: WidgetStateProperty.all(1),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isReverseButton ? AppColors.colorPrimary : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
