import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 56,
  });

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          Size(width, height),
        ),
        maximumSize: WidgetStateProperty.all(
          Size(width, height),
        ),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
        ),
        side: WidgetStateProperty.all(
          BorderSide(
            color: Colors.grey,
            width: 1,
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
        style: regularBodyTextStyle.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
