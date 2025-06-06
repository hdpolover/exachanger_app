import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'widgets/product_item.dart';

class HomeMoreView extends BaseView<HomeController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'All Products',
      isBackButtonEnabled: true,
    );
  }

  // Shimmer loading for product grid
  Widget _buildShimmerProductGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          childAspectRatio: 0.8,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: 12, // Show more shimmer items for the full grid
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerProductGrid();
      }

      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.error.value),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshData,
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.products.isEmpty) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              'No products available',
              style: smallBodyTextStyle.copyWith(color: Colors.grey),
            ),
          ),
        );
      }

      return SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        enablePullDown: true,
        enablePullUp: false,
        physics: const BouncingScrollPhysics(),
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.colorPrimary,
          color: Colors.white,
          distance: 40.0,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Products grid
                GridView.builder(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100, // Maximum width per item
                    childAspectRatio: 0.8, // Adjust based on content
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    return ProductItem(
                      product: controller.products[index],
                      onTap: () {
                        // Navigate to exchange page with the product data
                        print(
                          "Navigating to exchange with product: ${controller.products[index].name}",
                        );
                        // Delete any existing controller before navigating to ensure a fresh state
                        if (Get.isRegistered<ExchangeController>()) {
                          Get.delete<ExchangeController>();
                        }
                        Get.toNamed(
                          Routes.EXCHANGE,
                          arguments: {
                            'product': controller.products[index],
                            'fromHome': true,
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
