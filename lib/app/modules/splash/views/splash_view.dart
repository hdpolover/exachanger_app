import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_images.dart';
import '../../../core/values/text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a try-catch block to handle potential controller not found errors
    late SplashController controller;
    try {
      controller = Get.find<SplashController>(tag: "splash_controller");
    } catch (e) {
      print("Error finding SplashController: $e");
      // Create a controller if not found
      controller = Get.put(SplashController(), tag: "splash_controller");
    }

    return Scaffold(
      body: Stack(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.logo,
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                // Loading status text
                Obx(() => Text(
                      controller.statusText.value,
                      style: regularBodyTextStyle.copyWith(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                SizedBox(height: 10),
                // Loading indicator
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.colorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // text for app name
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'PT. Vepay Multipayment Internasional',
                textAlign: TextAlign.center,
                style: regularBodyTextStyle.copyWith(
                  color: AppColors.colorPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
