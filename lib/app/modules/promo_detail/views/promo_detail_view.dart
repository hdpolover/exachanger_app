import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/utils/common_functions.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/promo_detail_controller.dart';

class PromoDetailView extends BaseView<PromoDetailController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: controller.promoModel.title!);
  }

  Widget useButton() {
    return CustomButton(label: "Use Promotion", onPressed: () {});
  }

  @override
  Widget body(BuildContext context) {
    PromoModel promo = controller.promoModel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: promo.id!,
            child: CachedNetworkImage(
              imageUrl: promo.image!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
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
          SizedBox(height: 10),
          Text(promo.content!, style: regularBodyTextStyle),
        ],
      ),
    );
  }
}
