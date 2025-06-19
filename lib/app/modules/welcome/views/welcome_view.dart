import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_images.dart';
import '../../../core/values/app_values.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/shimmer_widget.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends BaseView<WelcomeController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    return Stack(children: [_buildBackground(), Obx(() => _buildContent())]);
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.3159, 1.0],
          colors: [AppColors.colorPrimary, AppColors.colorWhite],
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Show loading shimmer if metadata is not loaded yet
    if (controller.metaData.value == null) {
      return _buildContentLoadingShimmer();
    }
    return _buildLoadedContent();
  }

  // Content loading shimmer for when metadata is being fetched
  Widget _buildContentLoadingShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppValues.largePadding,
        vertical: AppValues.largePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppValues.extraLargePadding),
          // Title shimmer
          ShimmerWidget(
            height: 40,
            width: Get.width * 0.8,
            radius: AppValues.smallRadius,
          ),
          SizedBox(height: AppValues.smallPadding),
          // Subtitle shimmer
          ShimmerWidget(
            height: 20,
            width: Get.width * 0.9,
            radius: AppValues.smallRadius,
          ),
          SizedBox(height: AppValues.halfPadding),
          ShimmerWidget(
            height: 20,
            width: Get.width * 0.7,
            radius: AppValues.smallRadius,
          ),
          SizedBox(height: AppValues.padding * 2),
          // Image shimmer
          ShimmerWidget(
            height: Get.height * 0.4,
            width: double.infinity,
            radius: AppValues.smallRadius,
          ),
          const Spacer(),
          // Button shimmers
          ShimmerWidget(
            height: 50,
            width: double.infinity,
            radius: AppValues.smallRadius,
          ),
          SizedBox(height: AppValues.halfPadding),
          ShimmerWidget(
            height: 50,
            width: double.infinity,
            radius: AppValues.smallRadius,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - opacity)), // Slight slide up animation
            child: child,
          ),
        );
      },
      child: Stack(
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
                SizedBox(height: AppValues.extraLargePadding),
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
      ),
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
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          child: _buildAnimatedNetworkImage(imageUrl),
        ),
      ),
    );
  }

  // Enhanced animated image widget with graceful loading
  Widget _buildAnimatedNetworkImage(String imageUrl) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Image.network(
        imageUrl,
        key: ValueKey(imageUrl),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImageWidget();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            // Image has loaded, show with fade-in animation
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              child: child,
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * opacity), // Slight scale animation
                    child: child,
                  ),
                );
              },
            );
          }
          // Still loading, show shimmer effect
          return _buildLoadingShimmer(loadingProgress);
        },
      ),
    );
  }

  // Loading shimmer widget
  Widget _buildLoadingShimmer(ImageChunkEvent? loadingProgress) {
    return Stack(
      children: [
        // Shimmer effect
        ShimmerWidget(
          height: Get.height * 0.5,
          width: double.infinity,
          radius: AppValues.smallRadius,
        ),
        // Loading progress indicator at the bottom
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            children: [
              if (loadingProgress != null &&
                  loadingProgress.expectedTotalBytes != null)
                LinearProgressIndicator(
                  value:
                      loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!,
                  backgroundColor: AppColors.colorWhite.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.colorPrimary,
                  ),
                )
              else
                LinearProgressIndicator(
                  backgroundColor: AppColors.colorWhite.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.colorPrimary,
                  ),
                ),
              SizedBox(height: AppValues.halfPadding),
              Text(
                'Loading image...',
                style: regularBodyTextStyle.copyWith(
                  color: AppColors.colorWhite.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Error image widget with animation
  Widget _buildErrorImageWidget() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            height: Get.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.colorWhite.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              border: Border.all(
                color: AppColors.colorWhite.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 64,
                  color: AppColors.colorWhite.withOpacity(0.6),
                ),
                SizedBox(height: AppValues.padding),
                Text(
                  'Image unavailable',
                  style: regularBodyTextStyle.copyWith(
                    color: AppColors.colorWhite.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: AppValues.halfPadding),
                Image.asset(
                  AppImages.noImage,
                  fit: BoxFit.contain,
                  height: 100,
                ),
              ],
            ),
          ),
        );
      },
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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Column(
          children: [
            // First button with earlier animation
            if (value > 0.3)
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, buttonOpacity, child) {
                  return Opacity(
                    opacity: buttonOpacity,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - buttonOpacity)),
                      child: CustomButton(
                        label: "Sign in",
                        onPressed: () => Get.toNamed(Routes.SIGN_IN),
                      ),
                    ),
                  );
                },
              )
            else
              SizedBox(height: 50), // Placeholder to maintain layout

            SizedBox(height: AppValues.halfPadding),

            // Second button with later animation
            if (value > 0.6)
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, buttonOpacity, child) {
                  return Opacity(
                    opacity: buttonOpacity,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - buttonOpacity)),
                      child: CustomButton(
                        label: "Sign Up",
                        onPressed: () => Get.toNamed(Routes.SIGN_UP),
                        isReverseButton: true,
                      ),
                    ),
                  );
                },
              )
            else
              SizedBox(height: 50), // Placeholder to maintain layout
          ],
        );
      },
    );
  }
}
