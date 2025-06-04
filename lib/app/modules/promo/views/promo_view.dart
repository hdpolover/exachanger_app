import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/promo_controller.dart';
import 'promo_full_item.dart';
import 'promo_detail_view.dart';

class PromoView extends BaseView<PromoController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: 'Promotions');
  }

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: controller.promos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: PromoFullItem(
            promo: controller.promos[index],
            onTap: () {
              controller.selectPromo(controller.promos[index]);
              Get.to(() => PromoDetailView());
            },
          ),
        );
      },
    );
  }
}
