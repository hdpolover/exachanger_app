import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/widgets/no_image.dart';
import 'package:exachanger_get_app/app/data/model/promo_model.dart';
import 'package:flutter/material.dart';

class PromoItem extends StatelessWidget {
  final PromoModel promo;
  final VoidCallback? onTap;

  const PromoItem({super.key, required this.promo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        height: MediaQuery.sizeOf(context).height * 0.3,
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: CachedNetworkImage(
          imageUrl: promo.image ?? AppImages.logo,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => NoImage(),
        ),
      ),
    );
  }
}
