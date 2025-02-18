import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:flutter/material.dart';

class PromoItem extends StatelessWidget {
  const PromoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Image.asset(
        AppImages.welcome,
        fit: BoxFit.cover,
      ),
    );
  }
}
