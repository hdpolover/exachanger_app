import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/widgets/no_image.dart';
import 'package:exachanger_get_app/app/core/widgets/shimmer_widget.dart';
import 'package:exachanger_get_app/app/data/model/promo_model.dart';
import 'package:flutter/material.dart';

class PromoItem extends StatelessWidget {
  final PromoModel promo;

  const PromoItem({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height * 0.3;
    double w = MediaQuery.sizeOf(context).width * 0.8;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      height: h,
      width: w,
      child: Hero(
        tag: promo.id!,
        child: CachedNetworkImage(
          imageUrl: promo.image ?? AppImages.logo,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerWidget(
            height: h,
            width: w,
          ),
          errorWidget: (context, url, error) => NoImage(),
        ),
      ),
    );
  }
}
