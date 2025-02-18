import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_images.dart';
import '../../../core/values/app_values.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends BaseView<WelcomeController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(),
        Obx(() => _buildContent()),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.3159, 1.0],
          colors: [
            AppColors.colorPrimary,
            AppColors.colorWhite,
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return _buildLoadedContent();
  }

  Widget _buildLoadedContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppImages.shape, fit: BoxFit.cover),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppValues.largePadding,
              vertical: AppValues.largePadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppValues.padding,
                ),
                Text(
                  controller.metaData.value?.id ?? 'Exachanger',
                  style: titleTextStyle.copyWith(
                    color: AppColors.colorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppValues.smallPadding),
                Text(
                  'At Exachanger, we simplify access to the world\'s coin and crypto exchange process!.',
                  style: regularBodyTextStyle.copyWith(
                    color: AppColors.colorWhite,
                  ),
                ),
                const Spacer(),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        CustomButton(
          label: "Sign in",
          onPressed: () => Get.toNamed(Routes.SIGN_IN),
        ),
        SizedBox(height: AppValues.halfPadding),
        CustomButton(
          label: "Sign Up",
          onPressed: () => Get.toNamed(Routes.SIGN_UP),
          isReverseButton: true,
        ),
      ],
    );
  }
}
