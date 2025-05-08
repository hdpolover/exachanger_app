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
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppValues.largePadding,
            vertical: AppValues.largePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppValues.extraLargePadding,
              ),
              // Display title from hero-section if available
              Text(
                _getHeroSectionTitle() ?? 'Exachanger',
                style: titleTextStyle.copyWith(
                  color: AppColors.colorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppValues.smallPadding),
              // Display subtitle from hero-section if available
              Text(
                _getHeroSectionSubtitle() ??
                    'At Exachanger, we simplify access to the world\'s coin and crypto exchange process!.',
                style: regularBodyTextStyle.copyWith(
                  color: AppColors.colorWhite,
                ),
              ),
              SizedBox(height: AppValues.padding * 2),
              // Display image from image-section if available
              _buildImageSection(),
              const Spacer(),
              _buildButtons(),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to get the hero section title
  String? _getHeroSectionTitle() {
    if (controller.metaData.value?.content == null) return null;

    for (var content in controller.metaData.value!.content!) {
      if (content.section?.code == 'hero-section') {
        for (var component in content.section?.components ?? []) {
          if (component.order == 1 && component.component == 'text') {
            return component.data;
          }
        }
      }
    }
    return null;
  }

  // Helper method to get the hero section subtitle
  String? _getHeroSectionSubtitle() {
    if (controller.metaData.value?.content == null) return null;

    for (var content in controller.metaData.value!.content!) {
      if (content.section?.code == 'hero-section') {
        for (var component in content.section?.components ?? []) {
          if (component.order == 2 && component.component == 'text') {
            return component.data;
          }
        }
      }
    }
    return null;
  }

  // Widget to display the image from image section
  Widget _buildImageSection() {
    String? imageUrl = _getImageUrl();
    if (imageUrl == null) return const SizedBox();

    return Center(
      child: SizedBox(
        height: Get.height * 0.5, // Define appropriate height
        width: double.infinity,

        child: ClipRRect(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                AppImages.noImage,
                fit: BoxFit.contain,
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to get image URL
  String? _getImageUrl() {
    if (controller.metaData.value?.content == null) return null;

    for (var content in controller.metaData.value!.content!) {
      if (content.section?.code == 'iamge-section') {
        // Note: matches the typo in your JSON
        for (var component in content.section?.components ?? []) {
          if (component.component == 'image') {
            return component.data;
          }
        }
      }
    }
    return null;
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
