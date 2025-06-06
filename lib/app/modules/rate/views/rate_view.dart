import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'package:get/get.dart';

import '../controllers/rate_controller.dart';
import 'widgets/rate_item.dart';

class RateView extends BaseView<RateController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: 'Rate', isBackButtonEnabled: false);
  }

  // Shimmer loading for rate items
  Widget _buildShimmerRateItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product header shimmer
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          // Rate details shimmer
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description shimmer
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 10),
                // Rate items shimmer
                ...List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 80,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 60,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildShimmerRateItem(),
        );
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerList();
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

      // Filter products to only show those with rates
      final productsWithRates = controller.products
          .where(
            (product) => product.rates != null && product.rates!.isNotEmpty,
          )
          .toList();

      if (productsWithRates.isEmpty) {
        return Center(child: Text('No products with rates available'));
      }

      return SmartRefresher(
        key: const ValueKey('rate_smart_refresher'),
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
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          itemCount: productsWithRates.length,
          itemBuilder: (context, index) {
            final product = productsWithRates[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RateItem(product: product),
            );
          },
        ),
      );
    });
  }
}
