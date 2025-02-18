import 'package:flutter/material.dart';

import '../../../core/base/base_view.dart';
import '../../../core/values/app_images.dart';
import '../../../core/values/app_values.dart';
import '../../../core/values/text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends BaseView<SplashController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        // image for pattern
        Positioned.fill(
          child: Image.asset(
            AppImages.pattern,
            fit: BoxFit.cover,
          ),
        ),
        // image for logo
        Center(
          child: Image.asset(
            AppImages.logo,
            width: 200,
            height: 200,
          ),
        ),
        // text for app name
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: AppValues.largePadding),
            child: Text(
              'PT. Vepay Multipayment Internasional',
              style: centerTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
