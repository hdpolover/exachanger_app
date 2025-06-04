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
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
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
              (product) => product.rates != null && product.rates!.isNotEmpty)
          .toList();

      if (productsWithRates.isEmpty) {
        return Center(
          child: Text('No products with rates available'),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchProducts(),
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
