import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/values/app_values.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/core/widgets/simple_pin_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/setup_pin_controller.dart';

class SetupPinView extends BaseView<SetupPinController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      title: Text('Setup PIN', style: titleTextStyle.copyWith(fontSize: 18)),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppValues.largePadding * 2),

                    // Icon with animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.colorPrimary.withOpacity(
                                    0.1,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.security,
                              size: 40,
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppValues.largePadding),

                    // Title with slide animation
                    TweenAnimationBuilder<Offset>(
                      tween: Tween(begin: Offset(0, 30), end: Offset.zero),
                      duration: Duration(milliseconds: 600),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: value,
                          child: Opacity(
                            opacity: 1 - (value.dy / 30),
                            child: Text(
                              'Create Your PIN',
                              style: titleTextStyle.copyWith(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    // Description with slide animation
                    TweenAnimationBuilder<Offset>(
                      tween: Tween(begin: Offset(0, 20), end: Offset.zero),
                      duration: Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: value,
                          child: Opacity(
                            opacity: 1 - (value.dy / 20),
                            child: Text(
                              'Create a 6-digit PIN to secure your account.\nYou\'ll use this PIN to access your account.',
                              style: regularBodyTextStyle.copyWith(
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppValues.largePadding * 2),

                    // PIN Progress Indicator
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 900),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'PIN Progress: ',
                                  style: regularBodyTextStyle.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${controller.currentPin.value.length}/6',
                                  style: titleTextStyle.copyWith(
                                    color: AppColors.colorPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      },
                    ),

                    SizedBox(
                      height: AppValues.largePadding,
                    ), // PIN Input Fields - simple and clean
                    SimplePinInputWidget(
                      controllers: controller.pinControllers,
                      focusNodes: controller.pinFocusNodes,
                      onChanged: controller.onPinChanged,
                    ),

                    SizedBox(height: AppValues.largePadding),

                    // Clear PIN button with fade animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 1200),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: TextButton(
                            onPressed: controller.clearPin,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Clear PIN',
                              style: regularBodyTextStyle.copyWith(
                                color: AppColors.colorPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ), // Save PIN Button with animation and enhanced feedback
            Padding(
              padding: EdgeInsets.only(bottom: AppValues.largePadding),
              child: TweenAnimationBuilder<Offset>(
                tween: Tween(begin: Offset(0, 50), end: Offset.zero),
                duration: Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: value,
                    child: Obx(() {
                      final isComplete =
                          controller.currentPin.value.length == 6;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isComplete
                              ? [
                                  BoxShadow(
                                    color: AppColors.colorPrimary.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ]
                              : [],
                        ),
                        child: CustomButton(
                          label: isComplete ? "Save PIN ✓" : "Save PIN",
                          onPressed: isComplete
                              ? () {
                                  HapticFeedback.mediumImpact();
                                  controller.setupPin();
                                }
                              : () {
                                  HapticFeedback.lightImpact();
                                  // Optional: Show a hint about completing the PIN
                                },
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
