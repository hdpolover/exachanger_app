import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/utils/common_functions.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:flutter/material.dart';

import '../../../core/values/text_styles.dart';

class PromoFullItem extends StatelessWidget {
  final PromoModel promo;
  final VoidCallback? onTap;

  const PromoFullItem({super.key, required this.promo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(imageUrl: promo.image!),
          SizedBox(height: 10),
          Text(promo.title!,
              style: regularBodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 10),
          Text(
            "Valid until ${CommonFunctions.formatDateTime(
              DateTime.parse(promo.endDate!),
              withTime: false,
            )}",
          ),
        ],
      ),
    );
  }
}
