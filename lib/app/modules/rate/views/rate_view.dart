import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rate_controller.dart';
import 'widgets/rate_item.dart';

class RateView extends BaseView<RateController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Rate',
      isBackButtonEnabled: false,
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: RateItem(),
        );
      },
    );
  }
}
