import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

class NoImage extends StatelessWidget {
  const NoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.noImage,
            fit: BoxFit.contain,
            height: 100,
          ),
          const SizedBox(height: 5),
          const Text(
            'No Image Available',
            style: regularBodyTextStyle,
          ),
        ],
      ),
    );
  }
}
